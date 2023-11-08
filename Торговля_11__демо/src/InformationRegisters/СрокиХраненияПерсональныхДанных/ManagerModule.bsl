///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ЕстьРассчитанныеСрокиХранения() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1 РАЗРЕШЕННЫЕ
		|	СрокиХраненияПерсональныхДанных.СрокХранения КАК СрокХранения
		|ИЗ
		|	РегистрСведений.СрокиХраненияПерсональныхДанных КАК СрокиХраненияПерсональныхДанных";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.СрокХранения <> Дата(3999, 12, 31);
	
КонецФункции

// Параметры:
//  Субъекты - ОпределяемыйТип.СубъектПерсональныхДанных
//  ДатаАктуальности - Дата
// 
// Возвращаемое значение:
//  Массив из ОпределяемыйТип.СубъектПерсональныхДанных
Функция СубъектыСИстекшимСрокомХранения(Субъекты, ДатаАктуальности = Неопределено) Экспорт
	
	Если ДатаАктуальности = Неопределено Тогда
		ДатаАктуальности = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СрокиХраненияПерсональныхДанных.Субъект
		|ИЗ
		|	РегистрСведений.СрокиХраненияПерсональныхДанных КАК СрокиХраненияПерсональныхДанных
		|ГДЕ
		|	СрокиХраненияПерсональныхДанных.СрокХранения < &ДатаАктуальности
		|	И СрокиХраненияПерсональныхДанных.Субъект В (&Субъекты)";
	
	Запрос.УстановитьПараметр("ДатаАктуальности", ДатаАктуальности);
	Запрос.УстановитьПараметр("Субъекты", Субъекты);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Субъект");
	
КонецФункции

#КонецОбласти

#КонецЕсли
