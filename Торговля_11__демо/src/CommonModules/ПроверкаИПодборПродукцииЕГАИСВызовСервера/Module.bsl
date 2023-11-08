
#Область СлужебныйПрограммныйИнтерфейс

#Область РасчетХешСумм
	
// Получает данные по хеш суммам для переданных упаковок. Возвращает таблицу с идентификаторами строк, требующих перемаркировки
//
// Параметры:
//	* СтрокиДерева - Массив - содержит структуры с данными упаковок, для которых требуется получить хеш сумму:
//		** ИдентификаторСтроки - Число - идентификатор строки дерева маркируемой продукции
//		** ТипУпаковки - ПеречислениеСсылка.ТипыУпаковок - тип упаковки строки дерева маркируемой продукции
//		** СтатусПроверки - ПеречислениеСсылка.СтатусыПроверкиИПодбораИС - статус проверки строки дерева маркируемой продукции
//		** ЗначениеШтрихкода - Строка - значение штрихкода строки дерева маркируемой продукции
//		** ХешСумма - Строка - рассчитываемая хеш-сумма строки дерева маркируемой продукции
//		** ПодчиненныеСтроки - Массив - дочерние строки строки дерева маркируемой продукции
//	
// Возвращаемое значение:
//	* ТаблицаПеремаркировки - Массив - содержит структуры с данными строк, для которых требуется перемаркировка
//		** ИдентификаторВДереве - Число - идентификатор строки дерева маркируемой продукции
//		** ТребуетсяПеремаркировка - Булево - признак необходимости перемаркировки
//
Функция ПересчитатьХешСуммыВсехУпаковок(СтрокиДерева) Экспорт
	
	ТаблицаХешСумм = ПроверкаИПодборПродукцииИС.ПустаяТаблицаХешСумм();
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(СтрокаДерева.ТипУпаковки) Тогда
			ПроверкаИПодборПродукцииИС.РассчитатьХешСуммыУпаковки(СтрокаДерева, ТаблицаХешСумм, Истина);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаПеремаркировки = ПроверкаИПодборПродукцииИС.ТаблицаПеремаркировки(ТаблицаХешСумм);
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаПеремаркировки);
	
КонецФункции

#КонецОбласти

#КонецОбласти
