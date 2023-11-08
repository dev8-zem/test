#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = НастройкиСистемыПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьВерсионированиеОбъектов");
	
	РежимРаботы = Новый Структура;
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("БазоваяВерсия", 				 ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьЗаказыПоставщикамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКомиссиюПриЗакупкахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРучныеСкидкиВЗакупкахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантЗапретитьОформлениеОперацийСИмпортнымиТоварамиБезНомеровГТДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИмпортныеТоварыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКорректировкиПриобретенийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПокупкаТоваровОблагаемыхНДСУПокупателяПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантЗапретитьПоступлениеТоваровБезНомеровГТДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУчетПрослеживаемыхИмпортныхТоваровПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваровПриИзменении(Элемент)
	
	ЗначениеКонстанты = НаборКонстант.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров;
	НаборКонстант.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров = НачалоМесяца(ЗначениеКонстанты);
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦеныСтоимостиПрослеживаемыхТоваровПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПанельАдминистрированияУчетПрослеживаемыхИмпортныхТоваровОбработкаНавигационнойСсылки(Элемент,
																										НавигационнаяСсылкаФорматированнойСтроки,
																										СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПанельАдминистрированияРНПТ" Тогда
		ОткрытьФорму("Обработка.ПанельАдминистрированияУчетПрослеживаемыхТоваров.Форма.УчетПрослеживаемыхТоваров", , ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДоговорыСПоставщикамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСоглашенияСПоставщикамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АвтоПостановкаПоставщиковНаМониторингСПАРКПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Сервер

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = ""
		Или РеквизитПутьКДанным = "НаборКонстант.ИспользоватьИмпортныеТовары" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьИмпортныеТовары;
		
		Элементы.ЗапретитьПоступлениеТоваровБезНомеровГТД.Доступность						= ЗначениеКонстанты;
		Элементы.ЗапретитьОформлениеОперацийСИмпортнымиТоварамиБезНомеровГТД.Доступность	= ЗначениеКонстанты;
		Элементы.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров.Доступность					= ЗначениеКонстанты;
		
		ОтображениеПредупрежденияПриРедактировании();
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = ""
		Или РеквизитПутьКДанным = "НаборКонстант.ИспользоватьИмпортныеТовары"
		Или РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров"
		Или РеквизитПутьКДанным = "НаборКонстант.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров" Тогда
		
		Если НаборКонстант.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
			И Не ЗначениеЗаполнено(НаборКонстант.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров) Тогда
			
			НаборКонстант.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров = НачалоМесяца(ТекущаяДатаСеанса());
			
			СохранитьЗначениеРеквизита("НаборКонстант.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров");
			
		ИначеЕсли Не НаборКонстант.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
			И ЗначениеЗаполнено(НаборКонстант.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров) Тогда
			
			НаборКонстант.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров = Дата(1, 1, 1);
			
			СохранитьЗначениеРеквизита("НаборКонстант.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров");
			
		КонецЕсли;
		
		Если НаборКонстант.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров Тогда
			УчетПрослеживаемыхТоваровЛокализация.УстановитьФОИспользуетсяУчетВЕдиницеИзмеренияТНВЭД();
		КонецЕсли;
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров;
		
		Элементы.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров.Доступность = ЗначениеКонстанты;
		Элементы.ДекорацияПанельАдминистрированияУчетПрослеживаемыхИмпортныхТоваров.Доступность = ЗначениеКонстанты;
		Элементы.ГруппаВидЦеныСтоимостиПрослеживаемыхТоваров.Доступность = ЗначениеКонстанты;
		
		ЗначениеКонстанты = ПолучитьФункциональнуюОпцию("ИспользуетсяУчетВЕдиницеИзмеренияТНВЭД");
		
		Элементы.ГруппаКомментарийИспользуетсяУчетВЕдиницеИзмеренияТНВЭД.Видимость = ЗначениеКонстанты;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = ""
		Или РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДоговорыСПоставщиками" Тогда
		
		ЗначениеКонстанты = Константы.ИспользоватьДоговорыСПоставщиками.Получить();
		
		Элементы.ГруппаАвтоПостановкаПоставщиковНаМониторингСПАРК.Доступность = ЗначениеКонстанты;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	КонстантаИмя = "";
	Если СтрНачинаетсяС(НРег(РеквизитПутьКДанным), НРег("НаборКонстант.")) Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
		КонстантаИмя = ЧастиИмени[1];
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "ВключитьВерсионированиеУстановкиЦенНоменклатуры" Тогда
			НаборКонстант.ИспользоватьВерсионированиеОбъектов = Истина;
			КонстантаИмя = "ИспользоватьВерсионированиеОбъектов";
		КонецЕсли;
	КонецЕсли;

	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КонстантаИмя
	
КонецФункции

&НаСервере
Процедура ОтображениеПредупрежденияПриРедактировании()
	
	СтруктураКонстант = Новый Структура(
	"ИспользоватьИмпортныеТовары,
	|ИспользоватьУчетПрослеживаемыхИмпортныхТоваров");
	
	Для Каждого КлючИЗначение Из СтруктураКонстант Цикл
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(Элементы[КлючИЗначение.Ключ],
																					НаборКонстант[КлючИЗначение.Ключ]);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#КонецОбласти
