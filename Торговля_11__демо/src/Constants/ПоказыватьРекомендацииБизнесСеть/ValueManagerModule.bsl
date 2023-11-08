#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Использование = ПолучитьФункциональнуюОпцию("ИспользоватьОбменБизнесСеть") И Значение;
	
	ТорговыеПредложенияСлужебный.УстановитьИспользованиеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ОбновлениеПодсказокТорговыеПредложения, Использование);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли