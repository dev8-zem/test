#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в выкупе товаров хранителем.
//
// Параметры:
//	УсловияПродаж - Структура - Данные для заполнения.
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИменаРеквизитов = 
		"Валюта,
		|ВалютаВзаиморасчетов,
		|НаправлениеДеятельности,
		|ЦенаВключаетНДС,
		|ФормаОплаты";
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, УсловияПродаж, ИменаРеквизитов);
	
	ИзмененаОрганизация = ЗначениеЗаполнено(УсловияПродаж.Организация)
							И УсловияПродаж.Организация <> Организация;
	
	Если ИзмененаОрганизация Тогда
		Организация = УсловияПродаж.Организация;
	КонецЕсли;
	
	Если Не УсловияПродаж.Типовое Тогда
		Если ЗначениеЗаполнено(УсловияПродаж.Контрагент)
			И УсловияПродаж.Контрагент <> Контрагент Тогда
			
			Контрагент                = УсловияПродаж.Контрагент;
			БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
			
		КонецЕсли;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Если УсловияПродаж.ИспользуютсяДоговорыКонтрагентов <> Неопределено
		И УсловияПродаж.ИспользуютсяДоговорыКонтрагентов Тогда
		
		Обработчик = Документы.ВыкупТоваровХранителем.ОбработчикДействий(ХозяйственнаяОперация);
		Договор = Обработчик.ПолучитьДоговорПоУмолчанию(ЭтотОбъект);
		РеквизитыДоговора = Новый Структура;
		РеквизитыДоговора.Вставить("Валюта", "ВалютаВзаиморасчетов");
		РеквизитыДоговора.Вставить("ВалютаВзаиморасчетов");
		РеквизитыДоговора.Вставить("НаправлениеДеятельности");
		РеквизитыДоговора.Вставить("Подразделение");
		Справочники.ДоговорыКонтрагентов.ЗаполнитьРеквизитыДокумента(ЭтотОбъект, Договор, РеквизитыДоговора);
		
		ПродажиСервер.ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации, БанковскийСчетКонтрагента);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности") Тогда
			НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Соглашение, Договор);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.ГруппаФинансовогоУчета) Тогда
		ГруппаФинансовогоУчета = УсловияПродаж.ГруппаФинансовогоУчета;
	КонецЕсли;
	
	ЗаполнитьНалогообложениеНДС();
	
КонецПроцедуры

// Заполняет условия продаж по умолчанию в выкупе товаров хранителем.
//
// Параметры:
//	ПересчитатьЦены - Булево - Истина - Признак необходимости пересчитать цены в табличной части документа.
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию(ПересчитатьЦены = Истина) Экспорт
	
	Обработчик = Документы.ВыкупТоваровХранителем.ОбработчикДействий(ХозяйственнаяОперация);
	
	ИспользоватьСоглашенияСКлиентами = Обработчик.ИспользоватьСоглашенияСКлиентами();
	
	Если ЗначениеЗаполнено (Партнер)
		Или Не ИспользоватьСоглашенияСКлиентами Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ВыбранноеСоглашение",   Соглашение);
		ПараметрыОтбора.Вставить("ПустаяСсылкаДокумента", Документы.ВыкупТоваровХранителем.ПустаяСсылка());
		ПараметрыОтбора.Вставить("ХозяйственныеОперации", Обработчик.ХозяйственнаяОперацияДоговора());
		
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
									Партнер, ПараметрыОтбора, Обработчик.СоглашенияСКлиентамиПрименимы());
		
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			Если Не ИспользоватьСоглашенияСКлиентами
				Или (Соглашение <> УсловияПродажПоУмолчанию.Соглашение
					И ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Соглашение)) Тогда
				
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
				
				Если ИспользоватьСоглашенияСКлиентами
					И ПересчитатьЦены Тогда
					
					ЗаполнитьЦеныПоУсловиямПродаж();
					
				КонецЕсли;
			Иначе
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				
				ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			КонецЕсли;
			
			ПараметрыСчета = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
			ПараметрыСчета.Организация             = Организация;
			ПараметрыСчета.НаправлениеДеятельности = НаправлениеДеятельности;
			
			БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(ПараметрыСчета);
			
		Иначе
			Соглашение = Неопределено;
			
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			
			Договор = Обработчик.ПолучитьДоговорПоУмолчанию(ЭтотОбъект);
			
			ЗаполнитьНалогообложениеНДС();
			
			ПродажиСервер.ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации, БанковскийСчетКонтрагента);
		КонецЕсли;
		
		БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент,
																										Неопределено,
																										БанковскийСчетКонтрагента);
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в передаче товаров хранителю.
//
Процедура ЗаполнитьУсловияПродажПоСоглашению() Экспорт
	
	УсловияПродаж = ПродажиСервер.ПолучитьУсловияПродаж(Соглашение, Истина, Истина);
	
	ЗаполнитьУсловияПродаж(УсловияПродаж);
	ЗаполнитьЦеныПоУсловиямПродаж();
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    = Организация;
	СтруктураПараметров.БанковскийСчет = БанковскийСчетОрганизации;
	
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент,
																									Неопределено,
																									БанковскийСчетКонтрагента);
	
КонецПроцедуры

// Функция формирует временные данных документа
//
// Возвращаемое значение:
// 		МенеджерВременныхТаблиц - менеджер временных таблиц
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Партнер КАК Партнер,
	|	&Контрагент КАК Контрагент,
	|	&Соглашение КАК Соглашение,
	|	&Договор КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ВЫБОР
	|		КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|				И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|			ТОГДА &Подразделение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ КАК Подразделение,
	|	ВЫБОР
	|		КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|				И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|			ТОГДА &Менеджер
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	КОНЕЦ КАК Менеджер,
	|	ВЫБОР
	|		КОГДА СделкиСКлиентами.ОбособленныйУчетТоваровПоСделке
	|				И &ФормироватьВидыЗапасовПоСделкам
	|			ТОГДА &Сделка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)
	|	КОНЕЦ КАК Сделка,
	|	НЕОПРЕДЕЛЕНО КАК ДокументРеализации,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|		ПО (СтруктураПредприятия.Ссылка = &Подразделение)
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК СделкиСКлиентами
	|		ПО (СделкиСКлиентами.Ссылка = &Сделка)
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ &ТекстПоляТаблицаТоваровКоличествоПоРНПТ_
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ТаблицаТоваров.НомерГТД КАК НомерГТД,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.Сумма + ТаблицаТоваров.СуммаНДС * &ЦенаВключаетНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	&Сделка КАК Сделка
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	Аналитика.МестоХранения КАК Склад,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	&Сделка КАК Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ЛОЖЬ КАК ПодбиратьВидыЗапасов,
	|	ТаблицаТоваров.НомерГТД КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаТоваров.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	&Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	Аналитика.МестоХранения КАК Склад,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	НЕОПРЕДЕЛЕНО КАК ВидЗапасовПолучателя,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	&Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную,
	|	ТаблицаВидыЗапасов.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ТаблицаТоваров = ?(ДополнительныеСвойства.Свойство("ТаблицыЗаполненияВидовЗапасовПриОбмене")
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене <> Неопределено
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Свойство("Товары"),
						ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Товары,
						Товары);
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Менеджер", Менеджер);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Сделка", Сделка);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС", ?(ЦенаВключаетНДС, 0, 1));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоСделкам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	ОбщегоНазначенияУТ.ЗаменитьОтсутствующиеПоляТаблицыЗначенийВТекстеЗапроса(
		ТаблицаТоваров,
		Запрос.Текст,
		"&ТекстПоляТаблицаТоваровКоличествоПоРНПТ_",
		"ТаблицаТоваров",
		"КоличествоПоРНПТ",
		"ТаблицаТоваров.КоличествоПоРНПТ",
		"0");
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

// Инициализирует параметры заполнения видов запасов дополнительных свойств документа, используемых при записи документа
// в режиме 'Проведения' или 'Отмены проведения'.
//
// Параметры:
//	ДокументОбъект - ДокументОбъект.ВыкупТоваровХранителем - документ, для которого выполняется инициализация параметров.
//	РежимЗаписи - РежимЗаписиДокумента - режим записи документа.
//
Процедура ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ДокументОбъект, РежимЗаписи = Неопределено) Экспорт
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	
	ДокументОбъект.ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ПараметрыЗаполнения);
	
КонецПроцедуры

// Заполняет реквизиты, хранящие информацию о видах запасов и аналитиках учета номенклатуры в табличной части 'Товары'
// документа, а также заполняет табличную часть 'ВидыЗапасов'.
//
// Параметры:
//	Отказ - Булево - признак того, что не удалось заполнить данные.
//	ТаблицыДокумента - см. Документы.ВыкупТоваровХранителем.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьВидыЗапасовПриОбмене(Отказ, ТаблицыДокумента) Экспорт
	
	ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
	
	Если ТаблицыДокумента <> Неопределено Тогда
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента);
		ДополнительныеСвойства.Вставить("ТаблицыЗаполненияВидовЗапасовПриОбмене", ТаблицыДокумента);
	Иначе
		ИмяПараметра = "ТаблицыДокумента";
		
		ТекстИсключения = НСтр("ru = 'Для заполнения видов запасов не передан параметр ""%1"".'");
		ТекстИсключения = СтрШаблон(ТекстИсключения, ИмяПараметра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЗаполнитьВидыЗапасов(Отказ);
	ДополнительныеСвойства.Удалить("ТаблицыЗаполненияВидовЗапасовПриОбмене");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	СуммаДокумента = ПолучитьСуммуДокумента();
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;
	
	ИдентификаторПлатежа = ОбщегоНазначенияУТ.ПолучитьУникальныйИдентификаторПлатежа(ЭтотОбъект);
	
	ВзаиморасчетыСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов");
		
	ПараметрыРегистрации = Документы.ВыкупТоваровХранителем.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	ВыкупТоваровХранителемЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Если Не ЗначениеЗаполнено(Автор) И ЭтоНовый() Тогда
		Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
		
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьУсловияПродаж();
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияКассыПриФОИспользоватьНесколькоКассЛожь", Ложь);
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
	ОтветственныеЛицаСервер.ЗаполнитьМенеджера(ЭтотОбъект, Ложь);
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(Менеджер) Тогда
		Менеджер = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	ВыкупТоваровХранителемЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
 	ВзаиморасчетыСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	 		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
		
	МассивНепроверяемыхРеквизитов.Добавить("ДатаПлатежа");
	
	Обработчик = Документы.ВыкупТоваровХранителем.ОбработчикДействий(ХозяйственнаяОперация);
	Если Не Обработчик.ИспользоватьСоглашенияСКлиентами() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Соглашение");
	КонецЕсли;
	
	Если Обработчик.СоглашенияСКлиентамиПрименимы()
	   И (Не ЗначениеЗаполнено(Соглашение)
		  Или Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов")) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам") Тогда
		ПроверяемыеРеквизиты.Добавить("Подразделение");
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ВыкупТоваровХранителем),
		Отказ,
		МассивНепроверяемыхРеквизитов);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	Если ПолучитьФункциональнуюОпцию("ЗапретитьПоступлениеТоваровБезНомеровГТД")
		И Истина Тогда
		ЗапасыСервер.ПроверитьЗаполнениеНомеровГТД(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗатратыСервер.ПроверитьИспользованиеПартионногоУчета22(ЭтотОбъект, Дата, Отказ);
	
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект, Отказ);
	
	ВыкупТоваровХранителемЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ВыкупТоваровХранителемЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриПроведении(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ЭтотОбъект);
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ВыкупТоваровХранителемЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриУдаленииПроведения(Ссылка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВидыЗапасов.Очистить();
	
	ИнициализироватьДокумент();
	
	ИдентификаторПлатежа		= Неопределено;
	ВидыЗапасовУказаныВручную	= Ложь;
	
	ВзаиморасчетыСервер.ПриКопировании(ЭтотОбъект);	
	
	Если ЗначениеЗаполнено(ОбъектКопирования.ДатаПлатежа) Тогда
		ДатаПлатежа = ТекущаяДатаСеанса() + (НачалоДня(ОбъектКопирования.ДатаПлатежа) - НачалоДня(ОбъектКопирования.Дата));
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов");
	
	ВыкупТоваровХранителемЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
			ЗаполнитьУсловияПродажПоУмолчанию();
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ДанныеЗаполнения.Организация;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Автор = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Менеджер, Подразделение);
	
	Если Не ЗначениеЗаполнено(НалогообложениеНДС) Тогда
		ЗаполнитьНалогообложениеНДС();
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	СтруктураДействий.Вставить("СкорректироватьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(ЭтотОбъект));
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Товары, СтруктураДействий, КэшированныеЗначения);
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(ЭтотОбъект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(КэшированныеЗначения.ОбработанныеСтроки, СтруктураДействий, Неопределено);
	
	БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);
		
КонецПроцедуры

Процедура ИнициализироватьУсловияПродаж()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		ЗаполнитьУсловияПродажПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНалогообложениеНДС()
	
	ПараметрыЗаполнения = Документы.ВыкупТоваровХранителем.ПараметрыЗаполненияНалогообложенияНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Дата, Организация, ХозяйственнаяОперация, Партнер, Договор, НалогообложениеНДС";
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|		ТаблицаТоваров.НомерГТД КАК НомерГТД,
	|		ТаблицаТоваров.Количество КАК Количество,
	|		ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|		ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|		ТаблицаТоваров.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|		ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|		-ТаблицаВидыЗапасов.Количество КАК Количество,
	|		-ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|		-ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|		-ТаблицаВидыЗапасов.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.СтавкаНДС,
	|	ТаблицаТоваров.НомерГТД
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаСНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаВзаиморасчетов) <> 0
	|";
	РезультатЗапрос = Запрос.Выполнить();
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Процедура ЗаполнитьДопКолонкиВидовЗапасов()
	
	ИменаКолонокГруппировки		= "АналитикаУчетаНоменклатуры, Упаковка";
	ИменаКолонокСуммирования	= "Количество, КоличествоУпаковок, СуммаВзаиморасчетов";
	ВыгружаемыеКолонки			= ИменаКолонокГруппировки + ", " + ИменаКолонокСуммирования;
	
	ТаблицаТовары = Товары.Выгрузить(, ВыгружаемыеКолонки);
	ТаблицаТовары.Свернуть(ИменаКолонокГруппировки, ИменаКолонокСуммирования);
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	
	Для Каждого СтрокаТоваров Из ТаблицаТовары Цикл
		
		КоличествоТоваровПоСтроке	= СтрокаТоваров.Количество;
		КоличествоУпаковокПоСтроке	= СтрокаТоваров.КоличествоУпаковок;
		СуммаВзаиморасчетовПоСтроке	= СтрокаТоваров.СуммаВзаиморасчетов;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
			
			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			КоличествоПоСтроке = Мин(КоличествоТоваровПоСтроке, СтрокаЗапасов.Количество);
			
			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.Упаковка			= СтрокаТоваров.Упаковка;
			НоваяСтрока.КоличествоУпаковок	= ?(КоличествоТоваровПоСтроке <> 0,
												КоличествоУпаковокПоСтроке * КоличествоПоСтроке / КоличествоТоваровПоСтроке,
												0);
			НоваяСтрока.Количество			= КоличествоПоСтроке;
			НоваяСтрока.КоличествоПоРНПТ	= КоличествоПоСтроке * СтрокаЗапасов.КоличествоПоРНПТ / СтрокаЗапасов.Количество;
			НоваяСтрока.СуммаСНДС			= ?(СтрокаЗапасов.Количество <> 0,
												КоличествоПоСтроке * СтрокаЗапасов.СуммаСНДС / СтрокаЗапасов.Количество,
												0);
			НоваяСтрока.СуммаНДС			= ?(СтрокаЗапасов.Количество <> 0,
												КоличествоПоСтроке * СтрокаЗапасов.СуммаНДС / СтрокаЗапасов.Количество,
												0);
			НоваяСтрока.СуммаВзаиморасчетов	= ?(СтрокаЗапасов.Количество <> 0,
												КоличествоПоСтроке * СуммаВзаиморасчетовПоСтроке / КоличествоТоваровПоСтроке,
												0);
			
			СтрокаЗапасов.Количество		= СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			СтрокаЗапасов.КоличествоПоРНПТ	= СтрокаЗапасов.КоличествоПоРНПТ - НоваяСтрока.КоличествоПоРНПТ;
			СтрокаЗапасов.СуммаСНДС			= СтрокаЗапасов.СуммаСНДС - НоваяСтрока.СуммаСНДС;
			СтрокаЗапасов.СуммаНДС			= СтрокаЗапасов.СуммаНДС - НоваяСтрока.СуммаНДС;
			
			КоличествоТоваровПоСтроке	= КоличествоТоваровПоСтроке - НоваяСтрока.Количество;
			КоличествоУпаковокПоСтроке	= КоличествоУпаковокПоСтроке - НоваяСтрока.КоличествоУпаковок;
			СуммаВзаиморасчетовПоСтроке	= СуммаВзаиморасчетовПоСтроке - НоваяСтрока.СуммаВзаиморасчетов;
			
			Если КоличествоТоваровПоСтроке = 0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ПараметрыПоиска = Новый Структура("Количество", 0);
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(ПараметрыПоиска);
	
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц		= ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов	= ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
		Или ПерезаполнитьВидыЗапасов
		Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
		
		ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
																МенеджерВременныхТаблиц,
																Отказ,
																ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, СтавкаНДС",
								"Количество, КоличествоПоРНПТ, СуммаСНДС, СуммаНДС");
		
		ЗаполнитьДопКолонкиВидовЗапасов();
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращаемое значение:
// 	см. ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов
// 
Функция ПараметрыЗаполненияВидовЗапасов()
	
	Обработчик = Документы.ВыкупТоваровХранителем.ОбработчикДействий(ХозяйственнаяОперация);
	
	Возврат Обработчик.ПараметрыЗаполненияВидовЗапасов(ЭтотОбъект);

КонецФункции

// Заполняет аналитики учета номенклатуры в табличных частях документа, хранящих информацию о товарах.
// Если параметр не передан, тогда будет выполнено заполнение данных в табличных частях документа.
//
// Параметры:
//	ТаблицыДокумента - см. Документы.ВыкупТоваровХранителем.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента = Неопределено)
	
	Если ТаблицыДокумента = Неопределено Тогда
		ТаблицыДокумента = Документы.ВыкупТоваровХранителем.КоллекцияТабличныхЧастейТоваров();
		
		ЗаполнитьЗначенияСвойств(ТаблицыДокумента, ЭтотОбъект);
	КонецЕсли;
	
	ТаблицаТовары = ТаблицыДокумента.Товары;
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(ХозяйственнаяОперация,
																		Договор,
																		Подразделение,
																		Партнер,
																		Договор);
	
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(ТаблицаТовары, МестаУчета, ИменаПолей);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ЗаполнитьЦеныПоУсловиямПродаж()
	
	Если Товары.Количество() = 0
		И Не ЗначениеЗаполнено(Соглашение) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ИменаПолей = "ВидЦены, Цена, СтавкаНДС";
	
	ПараметрыЗаполнения = Новый Структура();
	ПараметрыЗаполнения.Вставить("ПоляЗаполнения",     ИменаПолей);
	ПараметрыЗаполнения.Вставить("Дата",               Дата);
	ПараметрыЗаполнения.Вставить("Организация",        Организация);
	ПараметрыЗаполнения.Вставить("Валюта",             Валюта);
	ПараметрыЗаполнения.Вставить("Соглашение",         Соглашение);
	ПараметрыЗаполнения.Вставить("НалогообложениеНДС", НалогообложениеНДС);
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСумму",     "КоличествоУпаковок");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС",  СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ОчиститьСуммуВзаиморасчетов");
	
	ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(Товары, Неопределено, ПараметрыЗаполнения, СтруктураДействий);
	
КонецПроцедуры

Функция ПолучитьСуммуДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.СуммаСНДС КАК СуммаСНДС
	|ПОМЕСТИТЬ
	|	Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(Товары.СуммаСНДС),0) КАК СуммаСНДС
	|ИЗ
	|	Товары КАК Товары
	|");
	
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(,"Номенклатура,СуммаСНДС"));
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	СуммаИтого = Выгрузка[0].СуммаСНДС;
	Возврат СуммаИтого;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
