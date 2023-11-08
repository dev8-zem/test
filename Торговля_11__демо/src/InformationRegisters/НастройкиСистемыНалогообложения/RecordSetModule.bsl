#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Для Каждого СтрокаНабора Из ЭтотОбъект Цикл
		СтрокаНабора.ПрименяетсяУСН =
			СтрокаНабора.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
		Если НЕ СтрокаНабора.ПрименяетсяУСН Тогда
			СтрокаНабора.ДатаПереходаНаУСН = Неопределено;
			СтрокаНабора.УведомлениеНомерУСН = Неопределено;
			СтрокаНабора.УведомлениеДатаУСН = Неопределено;
			СтрокаНабора.ПлательщикНалогаНаПрибыль = Истина;
		Иначе
			СтрокаНабора.ПлательщикНалогаНаПрибыль = Ложь;
		КонецЕсли;
		//++ Локализация

		Если НЕ ПлатежиВБюджетКлиентСервер.ДействуетЭкспериментПоПрименениюЕНПСогласно379ФЗ(СтрокаНабора.Период)
			ИЛИ СтрокаНабора.ПрименяетсяАУСН Тогда
			СтрокаНабора.ПлательщикЕНП = Ложь;
		КонецЕсли;

		//-- Локализация
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
