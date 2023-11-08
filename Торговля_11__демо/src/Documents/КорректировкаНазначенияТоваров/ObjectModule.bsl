#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует параметры заполнения видов запасов дополнительных свойств документа, используемых при записи документа
// в режиме 'Проведения' или 'Отмены проведения'.
//
// Параметры:
//	ДокументОбъект - ДокументОбъект.КорректировкаНазначенияТоваров - документ, для которого выполняется инициализация параметров.
//	РежимЗаписи - РежимЗаписиДокумента - режим записи документа.
//
Процедура ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ДокументОбъект, РежимЗаписи) Экспорт
	
	ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов(Ложь);
	ПараметрыЗаполнения.ДокументДелаетИПриходИРасход = РежимЗаписи = РежимЗаписиДокумента.Проведение;
	
	ДокументОбъект.ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ПараметрыЗаполнения);
	
КонецПроцедуры

// Заполняет реквизиты, хранящие информацию о видах запасов и аналитиках учета номенклатуры в табличной части 'Товары'
// документа, а также заполняет табличную часть 'ВидыЗапасов'.
//
// Параметры:
//	Отказ - Булево - признак того, что не удалось заполнить данные.
//	ТаблицыДокумента - см. Документы.КорректировкаНазначенияТоваров.КоллекцияТабличныхЧастейТоваров.
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

// Параметры:
// ДанныеЗаполнения - Структура:
//  * РеквизитыШапки - Структура - реквизиты шапки документа.
//  * Товары - ТаблицаЗначений - товары для переноса в документ.
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
	
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			
			Если ДанныеЗаполнения.Свойство("РеквизитыШапки") Тогда
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения.РеквизитыШапки);
			ИначеЕсли ДанныеЗаполнения.Свойство("ВидОперации")
				И ЗначениеЗаполнено(ДанныеЗаполнения.ВидОперации) Тогда
				ВидОперации = ДанныеЗаполнения.ВидОперации;
			Иначе
				ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезерв;
			КонецЕсли;
			
			Если ДанныеЗаполнения.Свойство("Товары") Тогда
				ЗаполнитьПоТаблицеТовары(ДанныеЗаполнения.Товары);
				
				Если ДанныеЗаполнения.Товары.Колонки.Найти("КоличествоУпаковок") = Неопределено Тогда
					СтруктураДействий = Новый Структура();
					СтруктураДействий.Вставить(
						"ПересчитатьКоличествоУпаковок",
						ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаКоличестваУпаковок());
						ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Товары, СтруктураДействий, Неопределено);
				КонецЕсли;
				
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Дата) Тогда
				Дата = ТекущаяДатаСеанса();
			КонецЕсли;
			
		Иначе
			
			ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезерв;
			
		КонецЕсли;
		
		Заказ = Неопределено;
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура")
			И ТипЗнч(ДанныеЗаполнения) <> Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
			
			Заказ = ДанныеЗаполнения;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Заказ) Тогда
			
			Назначение = Документы.КорректировкаНазначенияТоваров.НазначениеЗаказа(Заказ);
			Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заказ, "Организация");
			НазначениеДляЗаполненияДокумента = Назначение;
			ТоварыОтбор = Неопределено;
			
			МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Заказ);

			Документы.КорректировкаНазначенияТоваров.ЗаполнитьПоОснованию(
				НазначениеДляЗаполненияДокумента, Неопределено, Ссылка, ВидОперации, Товары, ТоварыОтбор);
			
			Если Товары.Количество() = 0 Тогда
				
				ТекстСообщения = НСтр("ru = 'Нет данных для заполнения по ""%Заказ%"" .'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Заказ%", Строка(ДанныеЗаполнения));
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	КорректировкаНазначенияТоваровЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	Если ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезервПоМногимНазначениям Тогда
		Назначение = Неопределено;
		Заказ = Неопределено;
	КонецЕсли;
	
	Автор = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ПроверитьКомплектностьТоварныхМест = Истина;
	ПараметрыПроверки.ПоляГруппировкиПроверкиКомплектности = "ИсходноеНазначение, НовоеНазначение";
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаНазначенияТоваров),
												Отказ,
												МассивНепроверяемыхРеквизитов);
												
	СкладыСервер.ПроверитьЗаполнениеЯчеек(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	СкладыСервер.ПроверитьЗаполнениеПомещений(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НовоеНазначение");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ИсходноеНазначение");
	
	Если ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезервПоМногимНазначениям
		Или ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.ПроизвольнаяКорректировкаНазначений Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
	КонецЕсли;
	ПроверитьТипНазначений(Отказ);
	ПроверитьЗаполнениеНовогоНазначения(Отказ);
	
	// Проверка заполнения упаковок номенклатуры на адресных складах
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Склад,
	|	Товары.Помещение
	|ПОМЕСТИТЬ СкладыИПомещения
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладыИПомещения.Склад,
	|	СкладыИПомещения.Помещение
	|ИЗ
	|	СкладыИПомещения КАК СкладыИПомещения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
	|		ПО (НастройкиАдресныхСкладов.ИспользоватьАдресноеХранение)
	|			И (НастройкиАдресныхСкладов.ДатаНачалаАдресногоХраненияОстатков <= &Дата)
	|			И (НастройкиАдресныхСкладов.Склад = СкладыИПомещения.Склад)
	|			И (НастройкиАдресныхСкладов.Помещение = СкладыИПомещения.Помещение)
	|			И (НЕ СкладыИПомещения.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|				ИЛИ (НЕ НастройкиАдресныхСкладов.Склад.ИспользоватьСкладскиеПомещения
	|					ИЛИ &Дата < НастройкиАдресныхСкладов.Склад.ДатаНачалаИспользованияСкладскихПомещений))";
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(,"Склад, Помещение"));
	Запрос.УстановитьПараметр("Дата",
		?(ЗначениеЗаполнено(Дата),Дата,ТекущаяДатаСеанса()));
	
	ВыборкаСкладПомещение = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаСкладПомещение.Следующий() Цикл
		ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияУпаковок();
		ПараметрыПроверки.ОтборПроверяемыхСтрок.Вставить("Склад", ВыборкаСкладПомещение.Склад);
		ПараметрыПроверки.ОтборПроверяемыхСтрок.Вставить("Помещение", ВыборкаСкладПомещение.Помещение);
		НоменклатураСервер.ПроверитьЗаполнениеУпаковок(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	КонецЦикла;
	
	// Проверка на то, что одно из двух полей назначения заполнено
	ПустоеНазначение = Справочники.Назначения.ПустаяСсылка();
	СтруктураПоиска = Новый Структура("ИсходноеНазначение, НовоеНазначение", ПустоеНазначение, ПустоеНазначение);
	НайденныеСтроки = Товары.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.Количество() > 0 Тогда
		
		ШаблонСообщения = НСтр("ru='Не заполнено назначение в колонках ""Исходное назначение"" и ""Новое назначение"" в строке %НомерСтроки%. 
			|Необходимо заполнить одну из колонок (либо обе).'");
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%НомерСтроки%", Строка.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , "Объект", Отказ)
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	КорректировкаНазначенияТоваровЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Или ДополнительныеСвойства.Свойство("ПрограммноеСозданиеДокумента") Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПравоПроведенияДокумента(Отказ);
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаНазначенияТоваров));
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ВидыЗапасов");
	
	КорректировкаНазначенияТоваровЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	Если ИспользуетсяАдресноеХранение() Тогда
		ЭтотОбъект.ДополнительныеСвойства.Вставить("ИспользуетсяАдресноеХранение");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ЭтотОбъект, РежимЗаписиДокумента.Проведение);
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	КорректировкаНазначенияТоваровЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ЭтотОбъект, РежимЗаписиДокумента.ОтменаПроведения);
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	КорректировкаНазначенияТоваровЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.ВстречнаяКорректировка Тогда
		
		ВидОперации               = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезерв;
		Назначение                = Неопределено;
		ВидыЗапасовУказаныВручную = Ложь;
		
		Товары.Очистить();
		ВидыЗапасов.Очистить();
		
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ВидыЗапасов");

	Автор = Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПравоПроведенияДокумента(Отказ)
	
	Если Не Документы.КорректировкаНазначенияТоваров.ДоступнаВозможностьИзменения(Ссылка) Тогда
		СтрокаИсключения = НСтр("ru = 'Недостаточно прав доступа для записи документа с действием ""%1"".'");
		СтрокаИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаИсключения, ВидОперации);
		ВызватьИсключение СтрокаИсключения;
	КонецЕсли;
	
КонецПроцедуры

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьПоТаблицеТовары(ТаблицаТоваров)
	
	Товары.Загрузить(ТаблицаТоваров);
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаНазначенияТоваров));
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ПроверитьЗаполнениеНовогоНазначения(Отказ)
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Функция ВременныеТаблицыДанныхДокумента(НаПустоеНазначение)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КорректировкаОбособленногоУчета) КАК ХозяйственнаяОперация,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ &ТекстПоляТаблицаТоваровКоличествоПоРНПТ_
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ТаблицаТоваров.Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаТоваров.ИсходноеНазначение КАК Назначение,
	|	ТаблицаТоваров.НовоеНазначение КАК НовоеНазначение,
	|	ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	&ТекстПоляТаблицаТоваровНомерГТД_ КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|
	|ГДЕ
	|	ВЫБОР
	|		КОГДА &НаПустоеНазначение
	|			ТОГДА ТаблицаТоваров.НовоеНазначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|		ИНАЧЕ ТаблицаТоваров.НовоеНазначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
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
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	Аналитика.МестоХранения КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК СпрВидЗапасов
	|		ПО (СпрВидЗапасов.Ссылка = ТаблицаВидыЗапасов.ВидЗапасов)
	|
	|ГДЕ
	|	НЕ (СпрВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|		И СпрВидЗапасов.ВладелецТовара = НЕОПРЕДЕЛЕНО)
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
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов.Выгрузить(Новый Структура("НовоеНазначениеПустое", НаПустоеНазначение)));
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	Запрос.УстановитьПараметр("НаПустоеНазначение", НаПустоеНазначение);
	
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
	
	ОбщегоНазначенияУТ.ЗаменитьОтсутствующиеПоляТаблицыЗначенийВТекстеЗапроса(
		ТаблицаТоваров,
		Запрос.Текст,
		"&ТекстПоляТаблицаТоваровНомерГТД_",
		"ТаблицаТоваров",
		"НомерГТД",
		"ТаблицаТоваров.НомерГТД",
		"ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)");
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Процедура СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ВЫБОР
	|		КОГДА ТаблицаТоваров.СтатусУказанияСерий = 14
	|			ТОГДА ТаблицаТоваров.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТоваров.Склад,
	|
	|	ТаблицаДанныхДокумента.Подразделение,
	|	ТаблицаДанныхДокумента.Менеджер,
	|	ТаблицаДанныхДокумента.Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|
	|	ТаблицаТоваров.Количество КАК Количество
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровИАналитики
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокумента КАК ТаблицаДанныхДокумента
	|	ПО
	|		ИСТИНА
	|ГДЕ
	|	ТаблицаТоваров.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|;
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОтборСтрок = Новый Структура("НовоеНазначение", Справочники.Назначения.ПустаяСсылка());
	СтрокиСПустымНазначением = Товары.НайтиСтроки(ОтборСтрок);
	
	ЕстьПоПустомуНазначению      = СтрокиСПустымНазначением.Количество() > 0;
	ЕстьПоЗаполненномуНазначению = СтрокиСПустымНазначением.Количество() <> Товары.Количество();
	
	ПерезаполнитьВидыЗапасов = ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	ВидыЗапасовПерезаполнены = Ложь;
	
	Если ЕстьПоПустомуНазначению Тогда
		
		МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента(Истина);
		
		Если Не Проведен
			Или ПерезаполнитьВидыЗапасов
			Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
			Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
			
			ВидыЗапасовПерезаполнены = Истина;
			
			Если ЕстьПоЗаполненномуНазначению Тогда
				ВидыЗапасовПоЗаполненномуНазначению = ВидыЗапасов.Выгрузить(Новый Структура("НовоеНазначениеПустое", Ложь));
				
				ВидыЗапасов.Очистить();
			КонецЕсли;
			
			ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов(Истина);
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
												МенеджерВременныхТаблиц,
												Отказ,
												ПараметрыЗаполнения);
			
			Для Каждого СтрТабл Из ВидыЗапасов Цикл
				СтрТабл.НовоеНазначениеПустое = Истина;
			КонецЦикла;
			
			Если ЕстьПоЗаполненномуНазначению Тогда
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасов, ВидыЗапасовПоЗаполненномуНазначению);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьПоЗаполненномуНазначению Тогда
		
		МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента(Ложь);
		
		Если Не Проведен
			Или ПерезаполнитьВидыЗапасов
			Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
			Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
			
			ВидыЗапасовПерезаполнены = Истина;
			
			Если ЕстьПоПустомуНазначению Тогда
				ВидыЗапасовПустомуНазначению = ВидыЗапасов.Выгрузить(Новый Структура("НовоеНазначениеПустое", Истина));
				
				ВидыЗапасов.Очистить();
			КонецЕсли;
		
			ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов(Ложь);
			
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
												МенеджерВременныхТаблиц,
												Отказ,
												ПараметрыЗаполнения);
			
			Если ЕстьПоПустомуНазначению Тогда
				ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(ВидыЗапасов, ВидыЗапасовПустомуНазначению);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВидыЗапасовПерезаполнены Тогда
		
		ИменаКолонокГруппировки		= "АналитикаУчетаНоменклатуры, АналитикаУчетаНоменклатурыОприходование,
										|ВидЗапасовОприходование, ВидЗапасов, НовоеНазначениеПустое, НомерГТД";
		ИменаКолонокСуммирования	= "Количество, КоличествоПоРНПТ";
		
		ВидыЗапасов.Свернуть(ИменаКолонокГруппировки, ИменаКолонокСуммирования);
		
		ЗаполнитьАналитикуОприходованиеВидовЗапасов();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|		ТаблицаТоваров.Количество КАК Количество
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатурыОприходование КАК АналитикаУчетаНоменклатурыОприходование,
	|		-ТаблицаВидыЗапасов.Количество КАК Количество
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатурыОприходование
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Процедура ЗаполнитьАналитикуОприходованиеВидовЗапасов()
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	
	Для Каждого СтрокаТоваров Из Товары Цикл

		КоличествоТоваров = СтрокаТоваров.Количество;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл

			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);

			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.АналитикаУчетаНоменклатурыОприходование = СтрокаТоваров.АналитикаУчетаНоменклатурыОприходование;
			НоваяСтрока.ВидЗапасовОприходование = ?(СтрокаЗапасов.ВидЗапасов.РеализацияЗапасовДругойОрганизации, 
													Справочники.ВидыЗапасов.ВидЗапасовДокумента(
														СтрокаЗапасов.ВидЗапасов.Организация,
														,
														СтрокаЗапасов.ВидЗапасов),
													СтрокаЗапасов.ВидЗапасов);
			НоваяСтрока.Количество = Количество;
			НоваяСтрока.КоличествоПоРНПТ = Количество * СтрокаЗапасов.КоличествоПоРНПТ / СтрокаЗапасов.Количество;
			
			СтрокаЗапасов.Количество		= СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			СтрокаЗапасов.КоличествоПоРНПТ	= СтрокаЗапасов.КоличествоПоРНПТ - НоваяСтрока.КоличествоПоРНПТ;
			
			КоличествоТоваров = КоличествоТоваров - НоваяСтрока.Количество;
			
			Если КоличествоТоваров = 0 Тогда
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

Функция ПараметрыЗаполненияВидовЗапасов(НаПустоеНазначение)
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполнения.ДокументДелаетИПриходИРасход = Истина;
	
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Заполняет аналитики учета номенклатуры в табличных частях документа, хранящих информацию о товарах.
// Если параметр не передан, тогда будет выполнено заполнение данных в табличных частях документа.
//
// Параметры:
//	ТаблицыДокумента - см. Документы.КорректировкаНазначенияТоваров.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента = Неопределено)
	
	Если ТаблицыДокумента = Неопределено Тогда
		ТаблицыДокумента = Документы.КорректировкаНазначенияТоваров.КоллекцияТабличныхЧастейТоваров();
		
		ЗаполнитьЗначенияСвойств(ТаблицыДокумента, ЭтотОбъект);
	КонецЕсли;
	
	ТаблицаТовары = ТаблицыДокумента.Товары;
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
					Перечисления.ХозяйственныеОперации.КорректировкаОбособленногоУчета,
					Неопределено,
					Неопределено,
					Неопределено);
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.Произвольный = "Склад";
	ИменаПолей.Назначение = "ИсходноеНазначение";
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(ТаблицаТовары, МестаУчета, ИменаПолей);
	
	ИменаПолей.Назначение = "НовоеНазначение";
	ИменаПолей.АналитикаУчетаНоменклатуры = "АналитикаУчетаНоменклатурыОприходование";
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(ТаблицаТовары, МестаУчета, ИменаПолей);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ИспользуетсяАдресноеХранение()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЧТовары.Склад КАК Склад,
		|	ТЧТовары.Помещение КАК Помещение
		|ПОМЕСТИТЬ ТЧТовары
		|ИЗ
		|	&ТЧТовары КАК ТЧТовары
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Склад,
		|	Помещение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	1 КАК Поле1
		|ИЗ
		|	РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТЧТовары КАК ТЧТовары
		|		ПО НастройкиАдресныхСкладов.Склад = ТЧТовары.Склад
		|			И НастройкиАдресныхСкладов.Помещение = ТЧТовары.Помещение
		|ГДЕ
		|	НастройкиАдресныхСкладов.ИспользоватьАдресноеХранение
		|	И НастройкиАдресныхСкладов.ДатаНачалаАдресногоХраненияОстатков <= &Дата
		|	И (НЕ НастройкиАдресныхСкладов.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
		|			ИЛИ (НЕ НастройкиАдресныхСкладов.Склад.ИспользоватьСкладскиеПомещения
		|				ИЛИ &Дата < НастройкиАдресныхСкладов.Склад.ДатаНачалаИспользованияСкладскихПомещений))";
		
	Запрос.УстановитьПараметр("ТЧТовары", Товары.Выгрузить(,"Склад, Помещение"));
	Запрос.УстановитьПараметр("Дата",
		?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура ПроверитьТипНазначений(Отказ)
	
	Если ЗначениеЗаполнено(Назначение)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Назначение, "ТипНазначения") = Перечисления.ТипыНазначений.ПоставкаПодПринципала Тогда
		ТекстСообщения = НСтр("ru = 'В корректировке назначения нельзя использовать назначение данного типа.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Назначение", "Объект", Отказ);
	КонецЕсли;
	
	ЭтоСнятиеРезерва = ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезерв;
	
	ЭтоСнятиеРезерваПоМногимНазначениям = ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезервПоМногимНазначениям;
	
	ШаблонСообщенияСнятияРезерваПоМногимНазначениям  = НСтр("ru='В колонке ""Назначение"" в строке %1 нельзя использовать назначение данного типа.'");
	ШаблонСообщенияСнятияРезерва = НСтр("ru = 'В колонке ""Новое назначение"" в строке %1 нельзя использовать назначение данного типа.'");
	ШаблонСообщенияРезрвирования = НСтр("ru = 'В колонке ""Исходное назначение"" в строке %1 нельзя использовать назначение данного типа.'");
	
	Если ЭтоСнятиеРезерваПоМногимНазначениям Тогда
		ШаблонСообщения = ШаблонСообщенияСнятияРезерваПоМногимНазначениям;
	ИначеЕсли ЭтоСнятиеРезерва Тогда
		ШаблонСообщения = ШаблонСообщенияСнятияРезерва;
	Иначе
		ШаблонСообщения = ШаблонСообщенияРезрвирования;
	КонецЕсли;
	
	КлючДанных = ОбщегоНазначенияУТ.КлючДанныхДляСообщенияПользователю(ЭтотОбъект);
	
	Для каждого СтрокаТовара Из Товары Цикл
		
		Если (Не ЭтоСнятиеРезерва ИЛИ ЭтоСнятиеРезерваПоМногимНазначениям) И ЗначениеЗаполнено(СтрокаТовара.ИсходноеНазначение)
			И СтрокаТовара.ИсходноеНазначение.ТипНазначения = Перечисления.ТипыНазначений.ПоставкаПодПринципала Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, СтрокаТовара.НомерСтроки);
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТовара.НомерСтроки, "ИсходноеНазначение");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, "Объект", Отказ);
			
		КонецЕсли;
		
		Если Не ЭтоСнятиеРезерваПоМногимНазначениям И ЭтоСнятиеРезерва И ЗначениеЗаполнено(СтрокаТовара.НовоеНазначение)
			И СтрокаТовара.НовоеНазначение.ТипНазначения = Перечисления.ТипыНазначений.ПоставкаПодПринципала Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, СтрокаТовара.НомерСтроки);
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТовара.НомерСтроки, "НовоеНазначение");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, "Объект", Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
