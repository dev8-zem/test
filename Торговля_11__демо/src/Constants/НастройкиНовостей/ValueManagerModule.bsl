///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Константа.НастройкиНовостей: Модуль менеджера.
//
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации() Тогда
		// Чтение константы "НастройкиНовостей".
		ЗначениеКонстанты = Неопределено;
		Запрос = Новый Запрос;
		Запрос.Текст = "
			|ВЫБРАТЬ
			|	НастройкиНовостей.Значение КАК Значение
			|ИЗ
			|	Константа.НастройкиНовостей КАК НастройкиНовостей
			|";
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.Прямой);
			Если Выборка.Следующий() Тогда
				ЗначениеКонстанты = Выборка.Значение;
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеКонстанты <> Неопределено Тогда
			ДополнительныеСвойства.Вставить("ЗначениеПередЗаписью", ЗначениеКонстанты);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ТипСтруктура         = Тип("Структура");
	ТипХранилищеЗначения = Тип("ХранилищеЗначения");

	// Получение функциональных опций "РазрешенаРаботаСНовостями"
	//  и "РазрешенаРаботаСНовостямиЧерезИнтернет" осуществляется через
	//  общий модуль "ОбработкаНовостейПовтИсп", поэтому после установки
	//  константы необходимо сбросить кэш.
	// Есть исключение: при начале работы системы, если происходит создание базы из cf, то сбрасывать кэш не нужно,
	//  т.к. это может привести к таким последствиям:
	//  - основная конфигурация (куда внедрена подсистема БИП:Новости) рассчитывает сложный код в модуле ПовтИсп;
	//  - БИП:Новости определяет, что константа "НастройкиНовостей" пустая (а в ней хранится в том числе номер версии платформы),
	//      записывает константу и сбрасывает кэш;
	//  - основной конфигурации (куда внедрена подсистема БИП:Новости) придется рассчитывать сложный код в модуле ПовтИсп заново.
	УстановитьПривилегированныйРежим(Истина);
		СостояниеПриНачалеРаботыСистемы = Ложь;
		ПараметрыОкруженияБИП_Новости = ПараметрыСеанса.ПараметрыОкруженияБИП_Новости.Получить();
		Если ТипЗнч(ПараметрыОкруженияБИП_Новости) = ТипСтруктура Тогда
			Если (ПараметрыОкруженияБИП_Новости.Свойство("СостояниеПриНачалеРаботыСистемы"))
					И (ПараметрыОкруженияБИП_Новости.СостояниеПриНачалеРаботыСистемы = Истина) Тогда
				СостояниеПриНачалеРаботыСистемы = Истина;
			КонецЕсли;
		КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	Если СостояниеПриНачалеРаботыСистемы = Ложь Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;

	Если ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации() Тогда
		// Запись в журнал регистрации
		ТекстСообщения = НСтр("ru='Записана константа НастройкиНовостей
			|Предыдущее значение:
			|%ПредыдущееЗначение%
			|
			|Новое значение:
			|%НовоеЗначение%'");

		лкПредыдущееЗначение_Строка = "Неопределено";
		Если ДополнительныеСвойства.Свойство("ЗначениеПередЗаписью") Тогда
			лкСтароеЗначение = ДополнительныеСвойства.ЗначениеПередЗаписью;
			Если ТипЗнч(лкСтароеЗначение) = ТипХранилищеЗначения Тогда
				Если ТипЗнч(лкСтароеЗначение.Получить()) = ТипСтруктура Тогда
					лкПредыдущееЗначение_Строка = ОбработкаНовостейКлиентСервер.ПредставлениеЗначения(
						лкСтароеЗначение.Получить(),
						": ",
						Символы.ПС);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

		лкНовоеЗначение_Строка = "Неопределено";
		Если ТипЗнч(Значение) = ТипХранилищеЗначения Тогда
			Если ТипЗнч(Значение.Получить()) = ТипСтруктура Тогда
				лкНовоеЗначение_Строка  = ОбработкаНовостейКлиентСервер.ПредставлениеЗначения(
					Значение.Получить(),
					": ",
					Символы.ПС);
			КонецЕсли;
		КонецЕсли;

		#Если ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
			ОбъектМетаданных = Неопределено;
		#Иначе
			ОбъектМетаданных = Метаданные.Константы.НастройкиНовостей;
		#КонецЕсли

		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредыдущееЗначение%", лкПредыдущееЗначение_Строка);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НовоеЗначение%", лкНовоеЗначение_Строка);
		// Запись в журнал регистрации
		ОбработкаНовостейВызовСервера.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Изменение данных'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИмяСобытия.
			НСтр("ru='Новости. Изменение данных. Константы. НастройкиНовостей'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИдентификаторШага.
			"Информация", // УровеньЖурналаРегистрации.*
			ОбъектМетаданных, // ОбъектМетаданных
			, // Данные
			ТекстСообщения, // Комментарий
			ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
