
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Реквизиты = ОборудованиеЧекопечатающиеУстройстваВызовСервера.ДанныеФискальнойОперации(Запись.ДокументОснование);
	
	Если Реквизиты = Неопределено Тогда
		
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		
	Иначе
		
		ТекстСообщенияXML = Реквизиты.ДанныеXML.Получить();
		
		Если ЗначениеЗаполнено(ТекстСообщенияXML) Тогда
			
			ПараметрыФорматирования = ИнтеграцияИС.ПараметрыФорматированияXML();
			
			ТекстXML.УстановитьТекст(
				ИнтеграцияИС.ФорматироватьXMLСПараметрами(
					ТекстСообщенияXML, ПараметрыФорматирования));
			
			Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
			
		Иначе
			
			Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
