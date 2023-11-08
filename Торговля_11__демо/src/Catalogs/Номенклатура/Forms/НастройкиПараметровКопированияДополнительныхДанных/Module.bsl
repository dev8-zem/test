
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИсточникКопирования = Параметры.ИсточникКопирования;
	
	ПараметрыКопированияДополнительныхДанных = Параметры.ПараметрыКопированияДополнительныхДанных;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработкаКоманд

&НаКлиенте
Процедура Копировать(Команда)
		
	Закрыть(ПараметрыКопированияДополнительныхДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти