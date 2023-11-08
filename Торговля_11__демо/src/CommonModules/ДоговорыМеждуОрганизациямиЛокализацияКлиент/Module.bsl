#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийФормыЭлемента

// Обработчик события ПриОткрытии формы элемента справочника Договоры
//
// Параметры:
//  Отказ - Булево - признак отказа.
//  Форма - ФормаКлиентскогоПриложения - форма, для которой выполняется обработчик.
//
Процедура ПриОткрытии(Отказ, Форма) Экспорт
	//++ Локализация

	//-- Локализация
КонецПроцедуры

// Обработчик события ОбработкаОповещения формы элемента справочника Договоры
//
// Параметры:
//  ИмяСобытия - Произвольный - имя события;
//  Параметр   - Произвольный - параметр оповещения;
//  Источник   - Произвольный - источник оповещения.
//  Форма      - ФормаКлиентскогоПриложения -//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник, Форма) Экспорт
	//++ Локализация
	
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

Процедура ОбработкаНавигационнойСсылкиФормы(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, Форма) Экспорт
	//++ Локализация
	СтандартнаяОбработка = Ложь;

	//-- Локализация
КонецПроцедуры

// Параметры:
//	Элемент - ГруппаФормы, ТаблицаФормы, ПолеФормы, КнопкаФормы - ЭлементФормы
// 	Форма - ФормаКлиентскогоПриложения
Процедура ПриИзмененииРеквизита(Элемент, Форма) Экспорт
	//++ Локализация


	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормыЭлемента

Процедура ВыполнитьКомандуЛокализации(Команда, Форма) Экспорт
	//++ Локализация
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиКомандФормы_Контрагенты_Служебные

//++ Локализация


//-- Локализация
#КонецОбласти

#КонецОбласти


