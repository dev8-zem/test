#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_КлючиРеквизитовОрганизацийЗЕРНО", Объект.Ссылка, ВладелецФормы);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// РаботаСПолямимСоставногоТипа
	Если ВРег(Лев(ИмяСобытия, 6)) = "ЗАПИСЬ" Тогда
		СобытияФормИСКлиент.ПолеСоставногоТипаОбработатьИзменениеДанных(ЭтотОбъект, Источник);
	КонецЕсли;
	// Конец РаботаСПолямимСоставногоТипа
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОрганизацииПриИзменении(Элемент)
	УстановитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияКонтрагентСтрокойПриИзменении(Элемент)
	
	ПолеСоставногоТипаПриИзменении(Элемент);
	НастроитьТипСправочника();
	УстановитьВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияКонтрагентСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	ПолеСоставногоТипаОткрытие(Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияКонтрагентСтрокойОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПолеСоставногоТипаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	НастроитьТипСправочника();
	УстановитьВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияКонтрагентСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ПолеСоставногоТипаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияКонтрагентСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПолеСоставногоТипаАвтоПодбор(Элемент, Элемент.ТекстРедактирования, ДанныеВыбора, Неопределено, 0, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ПравоИзменения = ПравоДоступа("Изменение", Метаданные.Справочники.КлючиРеквизитовОрганизацийЗЕРНО);
	
	Если ЗначениеЗаполнено(Объект.ОрганизацияКонтрагент) Тогда
		
		ТипСправочникаСопоставления = ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(Объект.ОрганизацияКонтрагент);
		
	Иначе
		
		СвязанноеЗначение = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.ОрганизацииКонтрагентыПоКлючам(Объект.Ссылка)[Объект.Ссылка];
		Если СвязанноеЗначение = Неопределено Тогда
			ТипСправочникаСопоставления = ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(Объект.ОрганизацияКонтрагент);
			Элементы.Подразделение.ПодсказкаВвода = "";
		ИначеЕсли ЗначениеЗаполнено(СвязанноеЗначение.Организация) Тогда
			Элементы.ОрганизацияКонтрагентСтрокой.ПодсказкаВвода = Строка(СвязанноеЗначение.Организация);
			Элементы.Подразделение.ПодсказкаВвода         = Строка(СвязанноеЗначение.Подразделение);
		ИначеЕсли ЗначениеЗаполнено(СвязанноеЗначение.Контрагент) Тогда
			Элементы.ОрганизацияКонтрагентСтрокой.ПодсказкаВвода = Строка(СвязанноеЗначение.Контрагент);
			Элементы.Подразделение.ПодсказкаВвода         = "";
			ТипСправочникаСопоставления = 1;
		КонецЕсли;
	
	КонецЕсли;
	
	ПодразделенияИспользуются = ИнтеграцияИС.ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс();
	
	НастроитьТипСправочника();
	УстановитьВидимостьДоступность(ЭтотОбъект);
	
	// РаботаСПолямимСоставногоТипа
	СобытияФормИС.ПоляСоставногоТипаИнициализация(ЭтотОбъект, ИменаЭлементовПолейСоставногоТипа());
	// Конец РаботаСПолямимСоставногоТипа
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Форма)
	
	Элементы    = Форма.Элементы;
	Объект      = Форма.Объект;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Элементы.Наименование.ТолькоПросмотр    = Истина;
		Элементы.ТипОрганизации.ТолькоПросмотр  = Истина;
		Элементы.ИНН.ТолькоПросмотр             = Истина;
		Элементы.КПП.ТолькоПросмотр             = Истина;
		Элементы.ОГРН.ТолькоПросмотр            = Истина;
		Элементы.Фамилия.ТолькоПросмотр         = Истина;
		Элементы.Имя.ТолькоПросмотр             = Истина;
		Элементы.Отчество.ТолькоПросмотр        = Истина;
	КонецЕсли;
	
	Элементы.ИНН.Видимость      = Ложь;
	Элементы.КПП.Видимость      = Ложь;
	Элементы.ОГРН.Видимость     = Ложь;
	Элементы.Фамилия.Видимость  = Ложь;
	Элементы.Имя.Видимость      = Ложь;
	Элементы.Отчество.Видимость = Ложь;
	Элементы.ЮридическийАдрес.Видимость = Ложь;
	Элементы.Индекс.Видимость           = Ложь;
	Элементы.КодАльфа3.Видимость        = Ложь;
	
	Если Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЗЕРНО.ЮридическоеЛицо") Тогда
		Элементы.ИНН.Видимость  = Истина;
		Элементы.КПП.Видимость  = Истина;
		Элементы.ОГРН.Видимость = Истина;
		Элементы.ЮридическийАдрес.Видимость = Истина;
		Элементы.Индекс.Видимость           = Истина;
	ИначеЕсли Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЗЕРНО.ИндивидульныйПредприниматель") Тогда
		Элементы.ИНН.Видимость  = Истина;
		Элементы.ОГРН.Видимость = Истина;
		Элементы.ЮридическийАдрес.Видимость = Истина;
		Элементы.Индекс.Видимость           = Истина;
	ИначеЕсли Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЗЕРНО.ИностраннаяОрганизация") Тогда
		Элементы.ИНН.Видимость  = Истина;
		Элементы.КПП.Видимость  = Истина;
		Элементы.ЮридическийАдрес.Видимость = Истина;
		Элементы.КодАльфа3.Видимость        = Истина;
	КонецЕсли;
	
	Если Форма.ТипСправочникаСопоставления = 0 Тогда
		Элементы.ОрганизацияКонтрагентСтрокой.Заголовок = НСтр("ru = 'Организация'");
		Элементы.Подразделение.Видимость         = Форма.ПодразделенияИспользуются;
	Иначе
		Элементы.ОрганизацияКонтрагентСтрокой.Заголовок = НСтр("ru = 'Контрагент'");
		Элементы.Подразделение.Видимость         = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьТипСправочника()
	
	ТипСправочникаСопоставления = ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(Объект.ОрганизацияКонтрагент);
	
КонецПроцедуры

#Область РаботаСПолямимСоставногоТипа

&НаСервереБезКонтекста
Функция ИменаЭлементовПолейСоставногоТипа()
	
	Возврат "ОрганизацияКонтрагентСтрокой";
	
КонецФункции

&НаКлиенте
Процедура ПолеСоставногоТипаОкончаниеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	СобытияФормИСКлиент.ПолеСоставногоТипаОкончаниеВыбора(ЭтотОбъект, Результат, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаПриИзменении(Элемент)
	
	СобытияФормИСКлиент.ПолеСоставногоТипаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаОткрытие(Элемент, СтандартнаяОбработка)
	
	СобытияФормИСКлиент.ПолеСоставногоТипаОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СобытияФормИСКлиент.ПолеСоставногоТипаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СобытияФормИСКлиент.ПолеСоставногоТипаАвтоПодбор(ЭтотОбъект,
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
