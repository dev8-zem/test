#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ID", ID);
	Параметры.Свойство("Тип", Тип);
	Параметры.Свойство("Представление", Представление);
	
	ЭлементыДерева = ДеревоДокументов.ПолучитьЭлементы();
	
	ПодходящиеДокументы = ПолучитьПодходящиеДокументы();
	
	Если ПодходящиеДокументы.Количество() <> 0 Тогда
		
		СтрокаГруппа = ЭлементыДерева.Добавить();
		СтрокаГруппа.ЭтоГруппа = Истина;
		СтрокаГруппа.Представление = СтрШаблон(
			НСтр("ru = 'Подходящие (%1)'"), 
			ПодходящиеДокументы.Количество());
		
		ЭлементыГруппы = СтрокаГруппа.ПолучитьЭлементы();
		
		Для Каждого ПодходящийДокумент Из ПодходящиеДокументы Цикл
			СтрокаЭлемент = ЭлементыГруппы.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаЭлемент, ПодходящийДокумент);
		КонецЦикла;
		
	КонецЕсли;
	
	СтрокаГруппа = ЭлементыДерева.Добавить();
	СтрокаГруппа.ЭтоГруппа = Истина;
	СтрокаГруппа.Представление = НСтр("ru = 'Возможные (3)'");
	
	ЭлементыГруппы = СтрокаГруппа.ПолучитьЭлементы();
	
	СтрокаЭлемент = ЭлементыГруппы.Добавить();
	СтрокаЭлемент.Тип = "DMInternalDocument";
	СтрокаЭлемент.Представление = НСтр("ru = 'Внутренний документ'");
	
	СтрокаЭлемент = ЭлементыГруппы.Добавить();
	СтрокаЭлемент.Тип = "DMIncomingDocument";
	СтрокаЭлемент.Представление = НСтр("ru = 'Входящий документ'");
	
	СтрокаЭлемент = ЭлементыГруппы.Добавить();
	СтрокаЭлемент.Тип = "DMOutgoingDocument";
	СтрокаЭлемент.Представление = НСтр("ru = 'Исходящий документ'");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоДокументов

&НаКлиенте
Процедура ДеревоДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Закрывает форму, передавая в качестве результата описание документа в текущей строке.
//
&НаКлиенте
Процедура ВыбратьИЗакрыть()
	
	ТекущиеДанные = Элементы.ДеревоДокументов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Или ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("РеквизитID", ТекущиеДанные.ID);
	Результат.Вставить("РеквизитТип", ТекущиеДанные.Тип);
	Результат.Вставить("РеквизитПредставление", ТекущиеДанные.Представление);
	
	Закрыть(Результат);
	
КонецПроцедуры

// Возвращает массив структур, описывающих подходящие документы ДО.
//
&НаСервере
Функция ПолучитьПодходящиеДокументы()
	
	Результат = Новый Массив;
	
	// Получим объект ИС по объекту ДО.
	СсылкаНаОбъектИС = РегистрыСведений.ОбъектыИнтегрированныеС1СДокументооборотом.СсылкаНаОбъектИСПоДаннымДокументооборота(
		ID,
		Тип);
	Если СсылкаНаОбъектИС = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПодходящиеОбъекты = ИнтеграцияС1СДокументооборот.ПолучитьПодходящиеОбъектыДляДобавленияСвязей(СсылкаНаОбъектИС);
		
	Если ПодходящиеОбъекты.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Получим связанные документы ДО для подходящих объектов ИС.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИнтегрированныеОбъекты.ТипОбъектаДО КАК Тип,
		|	ИнтегрированныеОбъекты.ИдентификаторОбъектаДО КАК ID,
		|	ПРЕДСТАВЛЕНИЕ(ИнтегрированныеОбъекты.Объект) КАК Представление
		|ИЗ
		|	РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом КАК ИнтегрированныеОбъекты
		|ГДЕ
		|	ИнтегрированныеОбъекты.Объект В(&ПодходящиеОбъекты)
		|	И ИнтегрированныеОбъекты.ТипОбъектаДО В(&ДопустимыеТипы)");
	
	ДопустимыеТипы = Новый Массив; // веб-сервис ДО поддерживает только связи с документами
	ДопустимыеТипы.Добавить("DMIncomingDocument");
	ДопустимыеТипы.Добавить("DMInternalDocument");
	ДопустимыеТипы.Добавить("DMOutgoingDocument");
	Запрос.УстановитьПараметр("ДопустимыеТипы", ДопустимыеТипы);
	
	Запрос.УстановитьПараметр("ПодходящиеОбъекты", ПодходящиеОбъекты);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ОписаниеОбъекта = Новый Структура;
		ОписаниеОбъекта.Вставить("Тип", Выборка.Тип);
		ОписаниеОбъекта.Вставить("ID", Выборка.ID);
		ОписаниеОбъекта.Вставить("Представление", Выборка.Представление);
		
		Результат.Добавить(ОписаниеОбъекта);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти