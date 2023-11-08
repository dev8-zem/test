////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность в модели сервиса".
// Серверные процедуры и функции общего назначения:
// - Поддержка профилей безопасности.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Обработать запросы на использование внешних ресурсов
// 
// Параметры: 
//  ИдентификаторыЗапросов -  Массив Из УникальныйИдентификатор 
// 
// Возвращаемое значение: 
//  Структура:
// * ТребуетсяПрименениеРазрешений - Булево
// * ИдентификаторПакета - УникальныйИдентификатор
Функция ОбработатьЗапросыНаИспользованиеВнешнихРесурсов(Знач ИдентификаторыЗапросов) Экспорт
	
	Результат = Новый Структура("ТребуетсяПрименениеРазрешений, ИдентификаторПакета");
	
	Менеджер = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.МенеджерПримененияРазрешений(
		ИдентификаторыЗапросов);
	
	Если Менеджер.ТребуетсяПрименениеРазрешенийВКластереСерверов() Тогда
		
		Результат.ТребуетсяПрименениеРазрешений = Истина;
		
		Результат.ИдентификаторПакета = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.ПакетПрименяемыхЗапросов(
			Менеджер.ЗаписатьСостояниеВСтрокуXML());
		
	Иначе
		
		Результат.ТребуетсяПрименениеРазрешений = Ложь;
		Менеджер.ЗавершитьПрименениеЗапросовНаИспользованиеВнешнихРесурсов();
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти