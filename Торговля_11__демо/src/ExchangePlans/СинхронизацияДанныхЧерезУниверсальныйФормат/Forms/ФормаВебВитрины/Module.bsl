#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаУзлаПриСозданииНаСервере(ЭтаФорма, Отказ);
	
	ИспользоватьНесколькоВидовЦен             = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен");
	ИспользоватьНесколькоСкладов              = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	ИспользоватьИнформативныеЦеныНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьИнформативныеЦеныНоменклатуры");
	
	Если Объект.ИспользоватьОтборПоОрганизациям Тогда
		
		ПравилоОтбораСправочников = "Отбор";
		
	Иначе
		
		Если Объект.ВыгружатьУправленческуюОрганизацию Тогда
			ПравилоОтбораСправочников = "УпрОрганизация";
		Иначе
			ПравилоОтбораСправочников = "БезОтбора";
		КонецЕсли;
		
	КонецЕсли;

	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ИсточникВыбора) = Тип("ФормаКлиентскогоПриложения")
		И ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ФормаОтметкиЭлементов" Тогда
		ОбновитьНаименованиеКомандФормы();
	Иначе
		ОбновитьДанныеОбъекта(ВыбранноеЗначение);
	КонецЕсли;
	
	Модифицированность = Истина;
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФлагИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковСОтборомПриИзменении(Элемент)
	УстановитьУсловияОграниченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковБезОтбораСУпрПриИзменении(Элемент)
	УстановитьУсловияОграниченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковБезОтбораБезУпрПриИзменении(Элемент)
	УстановитьУсловияОграниченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагОтправлятьИнформОстаткиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагОтправлятьВидыЦенНоменклатурыПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагОтправлятьИнформативныеЦеныПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоНоменклатуреПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизаций(Команда)
	
	Если Не Объект.ВыгружатьУправленческуюОрганизацию
		Или Не ПолучитьФункциональнуюОпциюИнтерфейса("ИспользоватьУправленческуюОрганизацию") Тогда
		
		КоллекцияФильтров = Новый Массив;
		
		НакладываемыеФильтры = Новый Структура();
		НакладываемыеФильтры.Вставить("РеквизитОтбора",    "Ссылка");
		НакладываемыеФильтры.Вставить("Условие",           "<>");
		НакладываемыеФильтры.Вставить("ИмяПараметра",      "ИсключаемаяСсылка");
		НакладываемыеФильтры.Вставить("ЗначениеПараметра", 
			ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.Организации.УправленческаяОрганизация"));
		
		КоллекцияФильтров.Добавить(НакладываемыеФильтры);
		
	Иначе
		
		КоллекцияФильтров = Неопределено;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Организации");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Организация");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокОтправляемыхВидовЦенНоменклатуры(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "ВидыЦенНоменклатуры");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "ВидЦенНоменклатуры");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.ВидыЦен");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите виды цен для отправки:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      Неопределено);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокОтправляемыхСкладовИнформОстатков(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "СкладыИнформативныхОстатков");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Склад");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Склады");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите склады, для которых требуется выгрузить информативные остатки:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      Неопределено);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВидоЦенИСоглашенийИнформативныхЦенНоменклатуры(Команда)

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "СоглашенияИВидыЦен");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "ТипЦены");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.ВидыЦен");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите виды цен или соглашения, для которых требуется выгрузить информативные цены:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      Неопределено);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуУстановкиОтборовФильтровПоНоменклатуре(Команда)
	
	ПараметрыФормы = Новый Структура();
	
	ОткрытьФорму("ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.НастройкаВыгрузкиКаталога",
		ПараметрыФормы,
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРезультатПримененияОтборовПоНоменклатуре(Команда)
	СформироватьКаталогНоменклатуры();
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура УстановитьУсловияОграниченияСинхронизации()
	
	Если ПравилоОтбораСправочников = "Отбор" Тогда
		
		Объект.ИспользоватьОтборПоОрганизациям = Истина;
		Объект.ВыгружатьУправленческуюОрганизацию = Ложь;
		
	ИначеЕсли ПравилоОтбораСправочников = "УпрОрганизация" Тогда
		
		Объект.ИспользоватьОтборПоОрганизациям = Ложь;
		Объект.ВыгружатьУправленческуюОрганизацию = Истина;
		
	ИначеЕсли ПравилоОтбораСправочников = "БезОтбора" Тогда
		
		Объект.ИспользоватьОтборПоОрганизациям = Ложь;
		Объект.ВыгружатьУправленческуюОрганизацию = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения;
		Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	#Область ГруппаСтраницыОтборПоОрганизациям
	
	Элементы.ГруппаСтраницыОтборПоОрганизациям.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Если Элементы.ГруппаСтраницыОтборПоОрганизациям.Видимость Тогда
		
		Элементы.ГруппаСтраницыОтборПоОрганизациям.Доступность = Истина;
		Элементы.ГруппаСтраницыОтборПоОрганизациям.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтборПоОрганизациям;
		
		// Видимость управленческой организации и варианта отбора
		ИспользоватьУправленческуюОрганизацию =
			ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию");
				
		// Видимость управленческой организации и варианта отбора.
		Элементы.ГруппаВыборУправленческойОрганизации.Видимость = ИспользоватьУправленческуюОрганизацию;
		
		Элементы.ОткрытьСписокВыбранныхОрганизаций.Доступность = Объект.ИспользоватьОтборПоОрганизациям;
		
		Если Элементы.ГруппаВыборУправленческойОрганизации.Видимость Тогда
			Элементы.ГруппаСтраницыВариантВыбораОтбора.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаПереключательОтбора;
		Иначе
			
			Элементы.ГруппаСтраницыВариантВыбораОтбора.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаФлагОтбора;
		КонецЕсли;
			
	КонецЕсли;
	
	УстановитьВидимостьГруппыНаСервере(Элементы, "ГруппировкаОтборов");
	УстановитьВидимостьГруппыНаСервере(Элементы, "ГруппаНастройкаОтборов");
	
	#КонецОбласти
	
	#Область СкладыИнформОстатков
	
	Если Объект.ВыгружатьИнформативныеОстатки И ИспользоватьНесколькоСкладов Тогда
		Элементы.ГруппаСтраницыИнформативныеОстаткиПоСкладам.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаКомандаВыбратьСкладыИнформативныхОстатков;
	Иначе
		Элементы.ГруппаСтраницыИнформативныеОстаткиПоСкладам.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаКомандаВыбратьСкладыИнформОстатковПустая;
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ГруппаИнформативныеВидыЦен
	
	Элементы.ГруппаИнформативныеЦеныНоменклатуры.Видимость = ИспользоватьИнформативныеЦеныНоменклатуры;
	
	Если Объект.ВыгружатьИнформативныеЦены Тогда
		Элементы.ГруппаСтраницыОтправлятьИнформВидыЦен.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаКомандаВыбратьИнформВидыЦен;
	Иначе
		Элементы.ГруппаСтраницыОтправлятьИнформВидыЦен.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаКомандаВыбратьИнформВидыЦенПустая;
	КонецЕсли;
	#КонецОбласти
	
	#Область ВидыЦен
	
	Если Объект.ВыгружатьЦеныНоменклатуры И ИспользоватьНесколькоВидовЦен Тогда
		Элементы.ГруппаСтраницыОтправлятьВидыЦенНоменклатуры.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаКомандаВыбратьВидыЦен;
	Иначе
		Элементы.ГруппаСтраницыОтправлятьВидыЦенНоменклатуры.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаКомандаВыбратьВидыЦенПустая;
	КонецЕсли;
	
	#КонецОбласти

	#Область ОтборНоменклатуры
	
	Если Объект.ИспользоватьОтборПоНоменклатуре Тогда
		Элементы.ГруппаСтраницыКритерииОтбораНоменклатуры.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаКомандаКритерииОтбораНоменклатуры;
	Иначе
		Элементы.ГруппаСтраницыКритерииОтбораНоменклатуры.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаКомандаКритерииОтбораНоменклатуыПустая;
	КонецЕсли;
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	ТабличнаяЧасть           = Объект[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения];
	ТаблицаВыбранныхЗначений = ТабличнаяЧасть.Выгрузить(,ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	МассивВыбранныхЗначений  = ТаблицаВыбранныхЗначений.ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	
	Возврат МассивВыбранныхЗначений;

КонецФункции

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	// Обновим заголовок выбранных организаций
	Если Объект.Организации.Количество() > 0 Тогда
		
		ВыбранныеОрганизации = Объект.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
		НовыйЗаголовокОрганизаций = СтрСоединить(ВыбранныеОрганизации, ",");
		
	Иначе
		
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Заголовок = НовыйЗаголовокОрганизаций;
	
	// Обновим заголовок выбранных видов цен
	Если Объект.ВидыЦенНоменклатуры.Количество() > 0 Тогда
		
		ВыбранныеВидыЦен = Объект.ВидыЦенНоменклатуры.Выгрузить().ВыгрузитьКолонку("ВидЦенНоменклатуры");
		НовыйЗаголовокВидовЦен = СтрСоединить(ВыбранныеВидыЦен, ",");
		
	Иначе
		
		НовыйЗаголовокВидовЦен = НСтр("ru = 'Выбрать виды цен'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокОтправляемыхВидовЦенНоменклатуры.Заголовок = НовыйЗаголовокВидовЦен;
	
	Если Объект.СкладыИнформативныхОстатков.Количество() > 0 Тогда
		
		ВыбранныеСклады = Объект.СкладыИнформативныхОстатков.Выгрузить().ВыгрузитьКолонку("Склад");
		НовыйЗаголовокСкладов = СтрСоединить(ВыбранныеСклады, ",");
		
	Иначе
		
		НовыйЗаголовокСкладов = НСтр("ru = 'Выбрать склады'");
	КонецЕсли;
	
	Элементы.ОткрытьСписокОтправляемыхСкладовИнформОстатков.Заголовок = НовыйЗаголовокСкладов;

	Если Объект.СоглашенияИВидыЦен.Количество() > 0 Тогда
		
		ВыбранныеПрайсЛисты = Объект.СоглашенияИВидыЦен.Выгрузить().ВыгрузитьКолонку("ТипЦены");
		НовыйЗаголовокПрайсЛистов = СтрСоединить(ВыбранныеПрайсЛисты, ",");
		
	Иначе
		НовыйЗаголовокПрайсЛистов = НСтр("ru = 'Выбрать виды цен или соглашения'");
	КонецЕсли;
	
	Элементы.ОткрытьСписокВидоЦенИСоглашенийИнформативныхЦенНоменклатуры.Заголовок = НовыйЗаголовокПрайсЛистов;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьГруппыНаСервере(ЭлементыФормы, ИмяГруппы)
	
	ГруппаФормы = ЭлементыФормы.Найти(ИмяГруппы);
	
	Если ГруппаФормы = Неопределено
		Или Не ТипЗнч(ГруппаФормы) = Тип("ГруппаФормы") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Видимость = Ложь;
	
	Для Каждого ПодчиненныйЭлемент Из ГруппаФормы.ПодчиненныеЭлементы Цикл
		
		Если Не ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы") Тогда
			Продолжить; // устанавливаем видимость только по видимости дочерних групп первого уровня вложенности
		КонецЕсли;
		
		Видимость = Видимость ИЛИ ПодчиненныйЭлемент.Видимость;
			
	КонецЦикла;
	
	ГруппаФормы.Видимость = Видимость;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьКаталогНоменклатуры()
	
	ВыгружаемаяНоменклатура.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос(
"ВЫБРАТЬ
|	СпрНоменклатура.Ссылка КАК Номенклатура
|ИЗ
|	Справочник.Номенклатура КАК СпрНоменклатура
|ГДЕ
|	(СпрНоменклатура.ЭтоГруппа = ЛОЖЬ)
|УПОРЯДОЧИТЬ ПО
|	СпрНоменклатура.Наименование
|ИТОГИ
|ПО
|	СпрНоменклатура.Ссылка ТОЛЬКО ИЕРАРХИЯ");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДеревоНоменклатуры = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗначениеВРеквизитФормы(ДеревоНоменклатуры, "ВыгружаемаяНоменклатура");
	
КонецПроцедуры

#КонецОбласти