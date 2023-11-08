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
	
	Если Не Параметры.Свойство("НастройкаПодключения", НастройкаПодключения) Тогда
		ВызватьИсключение НСтр("ru = 'Не корректные параметры формы.'");
	КонецЕсли;
	
	ИнтеграцияПодсистемБИП.ПриСозданииНаСервереФормыПодключенияСсылки(
		ЭтотОбъект,
		Отказ);
	ИнтеграцияСПлатежнымиСистемамиПереопределяемый.ПриСозданииНаСервереФормыПодключенияСсылки(
		ЭтотОбъект,
		Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтеграцияПодсистемБИПКлиент.ПриОткрытииФормыПодключенияСсылки(
		ЭтотОбъект,
		Отказ);
	ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриОткрытииФормыПодключенияСсылки(
		ЭтотОбъект,
		Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ИнтеграцияПодсистемБИПКлиент.ПриЗакрытииФормыПодключенияСсылки(
		ЭтотОбъект,
		ЗавершениеРаботы);
	ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриЗакрытииФормыПодключенияСсылки(
		ЭтотОбъект,
		ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИнтеграцияПодсистемБИПКлиент.ОбработкаОповещенияФормыПодключенияСсылки(
		ЭтотОбъект,
		ИмяСобытия,
		Параметр,
		Источник);
	ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ОбработкаОповещенияФормыПодключенияСсылки(
		ЭтотОбъект,
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключить(Команда)
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(
		КассоваяСсылка);
	
	// Проверки на "дурака".
	Если СтруктураURI.Схема <> "https"
		Или (СтруктураURI.Порт <> Неопределено И СтруктураURI.Порт <> 443)
		Или ПустаяСтрока(СтруктураURI.ПутьНаСервере) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Неверный формат кассовой ссылки.'"),
			,
			,
			"КассоваяСсылка");
		Возврат;
	КонецЕсли;
	
	РезультатПодключения = КассоваяСсылка(
		НастройкаПодключения,
		Лев(СтруктураURI.ПутьНаСервере, 32));
	
	Если ЗначениеЗаполнено(РезультатПодключения.КодОшибки) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			РезультатПодключения.СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	ДанныеСсылки = Новый Структура;
	ДанныеСсылки.Вставить("ИдентификаторОплаты", РезультатПодключения.ИдентификаторОплаты);
	ДанныеСсылки.Вставить("КассоваяСсылка", РезультатПодключения.КассоваяСсылка);
	
	Закрыть(ДанныеСсылки);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция КассоваяСсылка(Знач НастройкаПодключения, Знач ИдентификаторОплаты)
	
	Возврат ИнтеграцияСПлатежнымиСистемами.СлужебныйКассоваяСсылка(
		НастройкаПодключения,
		ИдентификаторОплаты);
	
КонецФункции

#КонецОбласти
