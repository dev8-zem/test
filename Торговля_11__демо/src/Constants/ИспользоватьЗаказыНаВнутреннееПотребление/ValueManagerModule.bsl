#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыНабора = УправлениеСвойствами.СтруктураПараметровНабораСвойств();
	ПараметрыНабора.Используется = Константы.ИспользоватьЗаказыНаВнутреннееПотребление.Получить();
	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ЗаказНаВнутреннееПотребление", ПараметрыНабора);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
