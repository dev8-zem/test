#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Формирует параметры для проведения документа по регистрам учетного механизма через общий механизм проведения.
//
// Параметры:
//  Документ - ДокументОбъект - записываемый документ
//  Свойства - См. ПроведениеДокументов.СвойстваДокумента
//
// Возвращаемое значение:
//  Структура - См. ПроведениеДокументов.ПараметрыУчетногоМеханизма
//
Функция ПараметрыДляПроведенияДокумента(Документ, Свойства) Экспорт
	
	Параметры = ПроведениеДокументов.ПараметрыУчетногоМеханизма();
	
	// Проведение
	Если Свойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыНакопления.МатериалыИРаботыВПроизводстве);
		
	КонецЕсли;
	
	// Контроль
	Если Свойства.РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
		
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыНакопления.МатериалыИРаботыВПроизводстве);
		
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

// Возвращает тексты запросов для сторнирования движений при исправлении документов
// 
// Параметры:
// 	МетаданныеДокумента - ОбъектМетаданныхДокумент - Метаданные документа, который проводится.
// 
// Возвращаемое значение:
// 	Соответствие - Соответствие полного имени регистра тексту запроса сторнирования
//
Функция ТекстыЗапросовСторнирования(МетаданныеДокумента) Экспорт
	
	ДвиженияДокумента = МетаданныеДокумента.Движения;

	ТекстыЗапросов = Новый Соответствие();
	
	МетаданныеРегистра = Метаданные.РегистрыНакопления.МатериалыИРаботыВПроизводстве;
	Если ДвиженияДокумента.Содержит(МетаданныеРегистра) Тогда
		ТекстДопУсловий = "
		|	НЕ ДанныеРегистра.РасчетПартий
		|";	
		ТекстыЗапросов.Вставить(МетаданныеРегистра.ПолноеИмя(),
			ПроведениеДокументов.ТекстСторнирующегоЗапроса(
				МетаданныеРегистра,
				МетаданныеДокумента,
				ТекстДопУсловий));
	КонецЕсли;
	
	Возврат ТекстыЗапросов;
	
КонецФункции

// Процедура формирования движений по регистру.
//
// Параметры:
//	ТаблицыДляДвижений - Структура - таблицы данных документа
//	Движения - КоллекцияДвижений - коллекция наборов записей движений документа
//	Отказ - Булево - признак отказа от проведения документа.
//
Процедура ОтразитьДвижения(ТаблицыДляДвижений, Движения, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "МатериалыИРаботыВПроизводстве");
	
КонецПроцедуры

// Дополняет текст запроса механизма проверки даты запрета по таблице изменений.
// 
// Параметры:
// 	Запрос - Запрос - используется для установки параметров запроса.
// 
// Возвращаемое значение:
//	Соответствие - соответствие имен таблиц изменения регистров и текстов запросов.
//	
Функция ТекстыЗапросовКонтрольДатыЗапретаПоТаблицеИзменений(Запрос) Экспорт

	СоответствиеТекстовЗапросов = Новый Соответствие();
	Возврат СоответствиеТекстовЗапросов;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
