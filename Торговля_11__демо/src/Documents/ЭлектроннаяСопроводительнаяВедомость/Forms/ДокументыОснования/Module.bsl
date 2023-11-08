
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("МассивДокументов") Тогда
		Для Каждого Документ Из Параметры.МассивДокументов Цикл
			НовСтр = Документы.Добавить();	
			НовСтр.Документ = Документ;	
		КонецЦикла;		
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоПросмотр") И Параметры.ТолькоПросмотр = Истина Тогда
		ТолькоПросмотр = Истина;
		Элементы.ДокументыОснование.ТолькоПросмотр = Истина;
		Элементы.ФормаОК.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	МассивДокументов = Новый Массив;
	Для Каждого СтрТаб Из Документы Цикл
		Если МассивДокументов.Найти(СтрТаб.Документ) = Неопределено Тогда
			МассивДокументов.Добавить(СтрТаб.Документ);
		КонецЕсли;	
	КонецЦикла;
	
	Закрыть(МассивДокументов);
	
КонецПроцедуры
