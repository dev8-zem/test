///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидОтчета = "АнализОтветов";
	
	Опрос = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Опрос");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(Опрос) Тогда
		Сформировать(Команды.Сформировать);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаОтчетаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Расшифровка.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
		
		СтруктураОткрытия = Новый Структура;
		СтруктураОткрытия.Вставить("Опрос", Опрос);
		СтруктураОткрытия.Вставить("ВопросШаблонаАнкеты", Расшифровка.ВопросШаблона);
		СтруктураОткрытия.Вставить("ПолныйКод", Расшифровка.ПолныйКод);
		СтруктураОткрытия.Вставить("НаименованиеОпроса", НаименованиеОпроса);
		СтруктураОткрытия.Вставить("ДатаОпроса", ДатаОпроса);
		
		ОткрытьФорму("Отчет.АнализОпроса.Форма.РасшифровкаТабличныхВопросов", СтруктураОткрытия, ЭтотОбъект);
		
	Иначе
		
		СтруктураОткрытия = Новый Структура;
		СтруктураОткрытия.Вставить("Опрос", Опрос);
		СтруктураОткрытия.Вставить("ВопросШаблонаАнкеты", Расшифровка.ВопросШаблона);
		СтруктураОткрытия.Вставить("ВариантОтчета", "Респонденты");
		СтруктураОткрытия.Вставить("ПолныйКод", Расшифровка.ПолныйКод);
		СтруктураОткрытия.Вставить("НаименованиеОпроса", НаименованиеОпроса);
		СтруктураОткрытия.Вставить("ДатаОпроса", ДатаОпроса);
		
		ОткрытьФорму("Отчет.АнализОпроса.Форма.РасшифровкаПростыхОтветов", СтруктураОткрытия, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьОтчет();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет()
	
	РеквизитФормыВЗначение("Отчет").СформироватьОтчет(ТаблицаОтчета, Опрос, ВидОтчета);
	РеквизитыОпрос     = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Опрос,"Наименование, Дата");
	НаименованиеОпроса = РеквизитыОпрос.Наименование;
	ДатаОпроса         = РеквизитыОпрос.Дата;
	
КонецПроцедуры

#КонецОбласти
