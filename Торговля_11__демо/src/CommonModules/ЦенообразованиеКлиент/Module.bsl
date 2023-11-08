////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции для обработки действий пользователя
// в процессе работы с ценами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет, используется ли ценообразование версии 2.5 на указанную дату.
//
// Параметры:
//	Дата - Дата - дата, для которой надо определить режим ценообразования.
//
// Возвращаемое значение:
//	Булево - признак использования ценообразования версии 2.5 на указанную дату
//	Если дата не указана, то она приравнивается к текущей.
Функция ИспользуетсяЦенообразование25(Дата = Неопределено) Экспорт

	Возврат ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25(Дата);

КонецФункции

// Определяет необходимость пересчита цены при изменении серии или упаковки.
// 
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - номенклатура проверки
//  ИмяРеквизита - Строка - "Серия" или "Упаковка". имя изменяемого реквизита
//  Дата - Неопределено, Дата - Дата проверки
// 
// Возвращаемое значение:
//  Булево - Истина, Необходимо пересчитать цены
Функция НеобходимПересчетЦеныПриИзменении(Номенклатура, ИмяРеквизита, Дата = Неопределено) Экспорт

	Если Номенклатура.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = ЦенообразованиеВызовСервера.НеобходимПересчетЦеныПриИзменении(Номенклатура, ИмяРеквизита, Дата);
	
	Возврат Результат;
	
КонецФункции

#Область ПроцедурыИФункцииПроверкиВозможностиВыполненияДействий

// Проверяет заполненность реквизитов, необходимых для пересчета из валюты в валюту.
//
// Параметры:
//  Документ	 - ДокументОбъект			 - Документ, для которого выполняются проверки.
//  СтараяВалюта - СправочникСсылка.Валюты	 - Предыдущая валюта документа.
//  ИмяТЧ		 - Строка					 - Имя табличной части.
//  ИмяПоляЦена	 - Строка					 - Имя поля, содержащее сумму, которая зависит от валюты.
// 
// Возвращаемое значение:
//  Булево - Истина, если необходим пересчет в валюту.
//
Функция НеобходимПересчетВВалюту(Документ, СтараяВалюта, ИмяТЧ="Товары", ИмяПоляЦена = "Цена") Экспорт

	Если Не ЗначениеЗаполнено(Документ.Валюта) Тогда
		Документ.Валюта = СтараяВалюта;
		Возврат Ложь;
	ИначеЕсли Не ЗначениеЗаполнено(СтараяВалюта) Тогда
		Возврат Ложь;
	ИначеЕсли СтараяВалюта = Документ.Валюта Тогда
		Возврат Ложь;
	ИначеЕсли Документ[ИмяТч].Итог(ИмяПоляЦена) = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

// Проверяет заполненность реквизитов, необходимых пересчета сумм взаиморасчетов
//
// Параметры:
// 		Документ 		- ДокументОбъект 			- ДокументОбъект, для которого выполняются проверки
// 		СтараяВалюта 	- СправочникСсылка.Валюты	- Предыдущая валюта взаиморасчетов
// 		ИмяТЧ 			- Строка 					- Имя табличной части.
//
// Возвращаемое значение:
// 		Булево - Ложь, если необходимые пересчитать суммы взаиморасчетов.
//
Функция НеобходимПересчетСуммыВзаиморасчетов(Документ, СтараяВалюта, ИмяТЧ="Товары") Экспорт

	Если Не ЗначениеЗаполнено(Документ.ВалютаВзаиморасчетов) Тогда
		Документ.ВалютаВзаиморасчетов = СтараяВалюта;
		Возврат Ложь;
	ИначеЕсли Не ЗначениеЗаполнено(СтараяВалюта) Тогда
		Возврат Истина;
	ИначеЕсли СтараяВалюта = Документ.ВалютаВзаиморасчетов Тогда
		Возврат Ложь;
	ИначеЕсли Документ[ИмяТч].Итог("СуммаВзаиморасчетов") = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

#КонецОбласти

#Область ПроцедурыОповещенияПользователяОВыполненныхДействиях

// Показывает оповещение пользователя об окончании пересчета сумм из валюты в валюту.
//
// Параметры:
// ВалютаИсточник - СправочникСсылка.Валюты - валюта, из которой осуществлялся пересчет
// ВалютаПриемник - СправочникСсылка.Валюты - валюта, в которую осуществляется пересчет.
//
Процедура ОповеститьОбОкончанииПересчетаСуммВВалюту(ВалютаИсточник, ВалютаПриемник) Экспорт

	СтрокаСообщения = НСтр("ru='Суммы в документе пересчитаны из валюты %ВалютаИсточник% в валюту %ВалютаПриемник%'");
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%ВалютаИсточник%", ВалютаИсточник);
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%ВалютаПриемник%", ВалютаПриемник);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Суммы пересчитаны'"),
		,
		СтрокаСообщения,
		БиблиотекаКартинок.Информация32);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
