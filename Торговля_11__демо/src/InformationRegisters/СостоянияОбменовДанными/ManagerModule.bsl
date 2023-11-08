///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ОбменДаннымиСлужебный.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияОбменовДаннымиОбластейДанных");
	Иначе
		ОбменДаннымиСлужебный.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияОбменовДанными");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗапись(СтруктураЗаписи) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ОбменДаннымиСлужебный.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияОбменовДаннымиОбластейДанных");
	Иначе
		ОбменДаннымиСлужебный.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияОбменовДанными");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли