#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	// Очистим табличные части документа.
	ИтоговыеЗаписи.Очистить();
	ДетальныеЗаписи.Очистить();
	
	Организация			= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Статус				= Перечисления.СтатусыСверокВзаиморасчетов2_5_11.Создана;
	Менеджер			= Пользователи.ТекущийПользователь();
	Автор				= Пользователи.ТекущийПользователь();
	НомерКонтрагента	= "";
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЕстьРасхождения = Ложь;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьДокументПоДаннымПомощника(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьКорректностьПериода(Отказ);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если ЗначениеЗаполнено(ТипРасчетов) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ИтоговыеЗаписи.ТипРасчетов");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ИтоговыеЗаписи.Партнер");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);

	Если ЕстьРасхождения И Статус = Перечисления.СтатусыСверокВзаиморасчетов2_5_11.СверенаБезРазногласий Тогда
		Для каждого СтрокаТабличнойЧасти Из ИтоговыеЗаписи Цикл
			Если СтрокаТабличнойЧасти.НомерДоговора <> СтрокаТабличнойЧасти.НомерДоговораКонтрагент
				Или СтрокаТабличнойЧасти.ДатаДоговора <> СтрокаТабличнойЧасти.ДатаДоговораКонтрагент Тогда
				ТекстСообщения = НСтр("ru = 'Не все итоговые записи сопоставлены.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "ИтоговыеЗаписи", "Объект", Отказ);
				Прервать;
			КонецЕсли;
		КонецЦикла;

		Для каждого СтрокаТабличнойЧасти Из ДетальныеЗаписи Цикл
			Если СтрокаТабличнойЧасти.НомерДокумента <> СтрокаТабличнойЧасти.НомерДокументаКонтрагент
				Или СтрокаТабличнойЧасти.ДатаДокумента <> СтрокаТабличнойЧасти.ДатаДокументаКонтрагент Тогда
				ТекстСообщения = НСтр("ru = 'Не все детальные записи сопоставлены.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "ДетальныеЗаписи", "Объект", Отказ);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Если ЕстьРасхождения И Статус <> Перечисления.СтатусыСверокВзаиморасчетов2_5_11.Отклонена Тогда
		ПроверитьКорректностьЗаполненияДанныхКонтрагента(Отказ);
		ПроверитьКорректностьЗаписейПострочно(Отказ);
		ПроверитьКорректностьЗаписейПоГруппировкам(Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	УстановитьСвойстваИзмененияРеквизитов(ЭтотОбъект, ДополнительныеСвойства);
	
	ВзаиморасчетыКлиентСервер.ОбновитьСостояниеСверкиОбъекта(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено) Экспорт
	
	Автор = Пользователи.ТекущийПользователь();
	ОтветственныеЛицаСервер.ЗаполнитьМенеджера(ЭтотОбъект, Ложь);
	Если НЕ ЗначениеЗаполнено(Менеджер) Тогда
		Менеджер = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Статус) Тогда
		Статус = Перечисления.СтатусыСверокВзаиморасчетов.Создана;
	КонецЕсли;
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) И НЕ ЗначениеЗаполнено(КонтактноеЛицо) Тогда
		КонтактноеЛицо = ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераКонтрагентаПоУмолчанию(Контрагент);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоДаннымПомощника(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	ДанныеЗаполнения.Вставить("Дата", Дата);
	
	ДанныеДокумента = Документы.СверкаВзаиморасчетов2_5_11.РеквизитыПоследнегоДокумента(Контрагент);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеДокумента, "ФИОРуководителяКонтрагента, ДолжностьРуководителяКонтрагента");
	
	Если ДанныеЗаполнения.Свойство("НастройкиОтбора") Тогда
		УстановитьОтборыНаРавенство(ДанныеЗаполнения);
		НастройкиОтбора = Новый ХранилищеЗначения(ДанныеЗаполнения.НастройкиОтбора);
	КонецЕсли;
	
	Документы.СверкаВзаиморасчетов2_5_11.ЗаполнитьДанныеПоРасчетам(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьКорректностьЗаписейПострочно(Отказ)

	Для каждого ИтоговаяЗапись Из ИтоговыеЗаписи Цикл
		Если ИтоговаяЗапись.ТипРасчетов.Пустая() Тогда	// Нет данных организации
			Продолжить;
		КонецЕсли;

		Если ИтоговаяЗапись.КонечноеСальдоДтКонтрагент <> 0 И ИтоговаяЗапись.КонечноеСальдоКтКонтрагент <> 0 Тогда	// Развернутое сальдо, требуется раздельный расчет Дт/Кт
			ДанныеКорректны = ИтоговаяЗапись.НачальноеСальдоДтКонтрагент
				+ ИтоговаяЗапись.ОборотДтКонтрагент
				= ИтоговаяЗапись.КонечноеСальдоДтКонтрагент
				И ИтоговаяЗапись.НачальноеСальдоКтКонтрагент
				+ ИтоговаяЗапись.ОборотКтКонтрагент
				= ИтоговаяЗапись.КонечноеСальдоКтКонтрагент;
		Иначе
			ДанныеКорректны = ИтоговаяЗапись.НачальноеСальдоДтКонтрагент - ИтоговаяЗапись.НачальноеСальдоКтКонтрагент
				+ ИтоговаяЗапись.ОборотДтКонтрагент - ИтоговаяЗапись.ОборотКтКонтрагент
				= ИтоговаяЗапись.КонечноеСальдоДтКонтрагент - ИтоговаяЗапись.КонечноеСальдоКтКонтрагент;
		КонецЕсли;

		Если Не ДанныеКорректны Тогда
			Если ИтоговаяЗапись.КонечноеСальдоДтКонтрагент <> 0 Тогда
				РеквизитОборота = ".КонечноеСальдоДтКонтрагент";
			ИначеЕсли ИтоговаяЗапись.КонечноеСальдоКтКонтрагент <> 0 Тогда
				РеквизитОборота = ".КонечноеСальдоКтКонтрагент";
			Иначе
				РеквизитОборота = "";
			КонецЕсли;
			ТекстСообщения = НСтр("ru = 'Сумма начального остатка и оборотов не равна конечному остатку.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ИтоговыеЗаписи[%1]%2",
					Формат(ИтоговыеЗаписи.Индекс(ИтоговаяЗапись), "ЧН=0; ЧГ="),
					РеквизитОборота),
				"Объект",
				Отказ);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПроверитьКорректностьЗаписейПоГруппировкам(Отказ)

	СверкаПоДоговорам = РежимСверкиИтоговВзаиморасчетов = Перечисления.РежимСверкиИтоговВзаиморасчетов.ПоДоговорам;

	КолонкиГруппировок = "ТипРасчетов, Партнер, Договор, ОбъектРасчетов";
	КолонкиСуммирования = "СуммаДебет, СуммаДебетКонтрагент, СуммаКредит, СуммаКредитКонтрагент";
	ДанныеДетальныхЗаписей = ДетальныеЗаписи.Выгрузить(, КолонкиГруппировок + ", " + КолонкиСуммирования);
	ДанныеДетальныхЗаписей.Свернуть(КолонкиГруппировок, КолонкиСуммирования);

	КопияИтоговойЗаписи = Новый Структура();
	КопияИтоговойЗаписи.Вставить("ТипРасчетов");
	КопияИтоговойЗаписи.Вставить("Партнер");
	КопияИтоговойЗаписи.Вставить("Договор");
	КопияИтоговойЗаписи.Вставить("ОбъектРасчетов");
	КопияИтоговойЗаписи.Вставить("НачальноеСальдоДтКонтрагент");
	КопияИтоговойЗаписи.Вставить("НачальноеСальдоКтКонтрагент");
	КопияИтоговойЗаписи.Вставить("СуммаДебетКонтрагент");
	КопияИтоговойЗаписи.Вставить("СуммаКредитКонтрагент");
	КопияИтоговойЗаписи.Вставить("ОборотДтКонтрагент");
	КопияИтоговойЗаписи.Вставить("ОборотКтКонтрагент");
	КопияИтоговойЗаписи.Вставить("КонечноеСальдоДтКонтрагент");
	КопияИтоговойЗаписи.Вставить("КонечноеСальдоКтКонтрагент");

	Для каждого ИтоговаяЗапись Из ИтоговыеЗаписи Цикл
		Если ИтоговаяЗапись.ТипРасчетов.Пустая() Тогда	// Нет данных организации
			Продолжить;
		КонецЕсли;
		Если ИтоговаяЗапись.НачальноеСальдоДтКонтрагент = 0
			И ИтоговаяЗапись.НачальноеСальдоКтКонтрагент = 0
			И ИтоговаяЗапись.ОборотДтКонтрагент = 0
			И ИтоговаяЗапись.ОборотКтКонтрагент = 0
			И ИтоговаяЗапись.КонечноеСальдоДтКонтрагент = 0
			И ИтоговаяЗапись.КонечноеСальдоКтКонтрагент = 0 Тогда	// Нет данных контрагента
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(КопияИтоговойЗаписи, ИтоговаяЗапись);
		ВзаиморасчетыКлиентСервер.РассчитатьКонечноеСальдоДтКт(КопияИтоговойЗаписи, ДанныеДетальныхЗаписей, СверкаПоДоговорам, Истина);
		Если КопияИтоговойЗаписи.ОборотДтКонтрагент <> ИтоговаяЗапись.ОборотДтКонтрагент Тогда
			ТекстСообщения = НСтр("ru = 'Сумма оборота по дебету в детальных записях не равна обороту по дебету в итоговой записи.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ИтоговыеЗаписи[%1].ОборотДтКонтрагент",
					Формат(ИтоговыеЗаписи.Индекс(ИтоговаяЗапись), "ЧН=0; ЧГ=")),
				"Объект",
				Отказ);
		КонецЕсли;
		Если КопияИтоговойЗаписи.ОборотКтКонтрагент <> ИтоговаяЗапись.ОборотКтКонтрагент Тогда
			ТекстСообщения = НСтр("ru = 'Сумма оборота по кредиту в детальных записях не равна обороту по кредиту в итоговой записи.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ИтоговыеЗаписи[%1].ОборотКтКонтрагент",
					Формат(ИтоговыеЗаписи.Индекс(ИтоговаяЗапись), "ЧН=0; ЧГ=")),
				"Объект",
				Отказ);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// В деталях: наим, номер, дата.
Процедура ПроверитьКорректностьЗаполненияДанныхКонтрагента(Отказ)

	МассивПроверяемыхРеквизитов = СтрРазделить("НаименованиеДокументаКонтрагент,НомерДокументаКонтрагент,ДатаДокументаКонтрагент", ",");
	ШаблонТекстаСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Детальные записи"".'");

	Для каждого СтрокаТабличнойЧасти Из ДетальныеЗаписи Цикл
		Если СтрокаТабличнойЧасти.ТипРасчетов.Пустая() Тогда
			Для каждого ПроверяемыйРеквизит Из МассивПроверяемыхРеквизитов Цикл
				Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти[ПроверяемыйРеквизит]) Тогда
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						ШаблонТекстаСообщения,
						ПроверяемыйРеквизит,
						СтрокаТабличнойЧасти.НомерСтроки);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ДетальныеЗаписи[%1].%2",
							Формат(ИтоговыеЗаписи.Индекс(СтрокаТабличнойЧасти), "ЧН=0; ЧГ="),
							),
						"Объект",
						Отказ);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов.
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Статус = Перечисления.СтатусыСверокВзаиморасчетов2_5_11[НовыйСтатус];
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

Процедура ПроверитьКорректностьПериода(Отказ)
	
	Если ЗначениеЗаполнено(НачалоПериода)
	 И ЗначениеЗаполнено(КонецПериода)
	 И НачалоПериода > КонецПериода Тогда
	 
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Дата начала периода не должна быть больше окончания периода %1'"),
			Формат(КонецПериода, "ДЛФ=DD"));
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"НачалоПериода",
			, // ПутьКДанным
			Отказ);
	 
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьОтборыНаРавенство(ДанныеЗаполнения)
	
	ПоляОтбора = Новый Массив();
	ПоляОтбора.Добавить("ТипРасчетов");
	ПоляОтбора.Добавить("Партнер");
	ПоляОтбора.Добавить("Договор");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ПоляОтбора.Добавить("Организация");
	КонецЕсли;
	ПоляОтбора.Добавить("Контрагент");
	
	Отбор = ДанныеЗаполнения.НастройкиОтбора.Отбор;
	Для Каждого ПолеОтбора Из ПоляОтбора Цикл
		РазбиватьДокументы = Истина;
		Если ПолеОтбора = "ТипРасчетов" Тогда
			РазбиватьДокументы = ДанныеЗаполнения.РазбиватьПоТипамРасчетов;
			
		ИначеЕсли ПолеОтбора = "Партнер" Тогда
			РазбиватьДокументы = ДанныеЗаполнения.РазбиватьПоПартнерам;
			
		ИначеЕсли ПолеОтбора = "Договор" Тогда
			РазбиватьДокументы = ДанныеЗаполнения.РазбиватьПоДоговорам;
			
		КонецЕсли;
		Если РазбиватьДокументы Тогда
			ФинансоваяОтчетностьСервер.УстановитьОтбор(Отбор, ПолеОтбора, ДанныеЗаполнения[ПолеОтбора], ВидСравненияКомпоновкиДанных.Равно, РазбиватьДокументы);
		КонецЕсли;
	КонецЦикла;
	
	ОтборДоговорыБезОборотов = ФинансоваяОтчетностьСервер.НайтиЭлементОтбора(Отбор, "ДоговорыБезОборотов");
	ОтборДоговорыБезОборотов.Использование = ДанныеЗаполнения.ДоговорыБезОборотов;
	
КонецПроцедуры

Процедура УстановитьСвойстваИзмененияРеквизитов(Объект, ДополнительныеСвойства)
		
	ИзменилсяТолькоСтатусСвереноНаСверке = Ложь;
	
	Если Объект.Проведен Тогда
		
		НепроверяемыеРеквизиты = Новый Структура;
		НепроверяемыеРеквизиты.Вставить("Комментарий");
		НепроверяемыеРеквизиты.Вставить("НастройкиОтбора");
		
		ИзмененияДокумента = ОбщегоНазначенияУТ.ИзмененияДокумента(Объект, НепроверяемыеРеквизиты);
		
		ИзменилисьДругиеРеквизиты = Ложь;
		ИзменилсяСтатус = Ложь;
		
		Если ИзмененияДокумента.Свойство("ТабличныеЧасти") Тогда
			ИзменилисьДругиеРеквизиты = Истина;
		КонецЕсли;                                  
		
		Если ИзмененияДокумента.Свойство("Реквизиты") Тогда
			Если ИзмененияДокумента.Реквизиты.Найти("Статус", "Имя") <> Неопределено Тогда
				ИзменилсяСтатус = Истина;
			КонецЕсли;
			Для каждого Реквизит Из ИзмененияДокумента.Реквизиты Цикл
				Если Реквизит.Имя <> "Статус" Тогда
					ИзменилисьДругиеРеквизиты = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;                                    
		
		ИзменилсяТолькоСтатусСвереноНаСверке = ИзменилсяСтатус И Не ИзменилисьДругиеРеквизиты;
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ИзменилсяТолькоСтатусСвереноНаСверке", ИзменилсяТолькоСтатусСвереноНаСверке);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
