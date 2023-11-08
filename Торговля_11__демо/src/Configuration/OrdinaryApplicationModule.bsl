///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

//РаботаСВнешнимОборудованием
Перем глПодключаемоеОборудованиеСобытиеОбработано Экспорт; // для предотвращения повторной обработки события
Перем глДоступныеТипыОборудования Экспорт;
//Конец РаботаСВнешнимОборудованием

Перем глКомпонентаОбменаСМобильнымиПриложениями Экспорт;
Перем глФормаНачальнойНастройкиПрограммы Экспорт;

// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

// Конец СтандартныеПодсистемы

// ТехнологияСервиса

Перем ОповещениеПриПримененииЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса Экспорт;

// Конец ТехнологияСервиса

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы()
	
	//++ НЕ ГОСИС
	глФормаНачальнойНастройкиПрограммы = ОткрытиеФормПриНачалеРаботыСистемыВызовСервера.ФормаНачальнойНастройкиПрограммы();
	//-- НЕ ГОСИС
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	//++ НЕ ГОСИС
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователейКлиент.ПередНачаломРаботыСистемы();
	// Конец ИнтернетПоддержкаПользователей
	
	//-- НЕ ГОСИС
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередНачаломРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения);
	// Конец СтандартныеПодсистемы
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	//++ НЕ ГОСИС
	Если Лев(Источник, 17) = "MobileApplication" Тогда
		МобильныеПриложенияКлиент.ОбработатьВнешнееСобытиеОтМобильногоПриложения(Источник, Событие, Данные);
		Возврат;
	КонецЕсли;
	//-- НЕ ГОСИС
	
	глПодключаемоеОборудованиеСобытиеОбработано = Ложь;
	
	//РаботаСВнешнимОборудованием
	// Подготовить данные
	ОписаниеСобытия = Новый Структура();
	ОписаниеОшибки  = "";
	
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);
	
	// Передать на обработку данные
	Результат = МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При обработке внешнего события от устройства произошла ошибка.'")
		                                                 + Символы.ПС + ОписаниеОшибки);
	КонецЕсли;
	//Конец РаботаСВнешнимОборудованием
	
КонецПроцедуры

Процедура ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора, Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Обсуждения
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Обсуждения") Тогда
	
		МодульОбсужденияСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбсужденияСлужебныйКлиент");
		МодульОбсужденияСлужебныйКлиент.ПриПолученииФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора, Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка);
	
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Обсуждения
		
КонецПроцедуры

#КонецОбласти

#Область Инициализация

//++ НЕ ГОСИС
глНомерКонтейнераСбербанк     = 0;
глУстановленКаналСоСбербанком = Ложь;
//-- НЕ ГОСИС
глПодключаемоеОборудованиеСобытиеОбработано = Ложь;

#КонецОбласти