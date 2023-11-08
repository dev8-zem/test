#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация = Параметры.Организация;
	ТолькоПросмотр = Параметры.ТолькоПросмотр;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно, , 
		ЗначениеЗаполнено(Организация),,);
		
	ДействующиеПараметры = РегистрыСведений.НастройкиУчетаНДС.ЗначенияПоУмолчанию();
	Ресурсы = Метаданные.РегистрыСведений.НастройкиУчетаНДС.Ресурсы;
	Для каждого Колонка Из Элементы.Список.ПодчиненныеЭлементы Цикл
		ЧастиПути = СтрРазделить(Колонка.ПутьКДанным, ".");
		ИмяПоля = ЧастиПути[1];
		Если Ресурсы.Найти(ИмяПоля) <> Неопределено И НЕ ДействующиеПараметры.Свойство(ИмяПоля) Тогда
			Колонка.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Добавить(Команда)
	ОповеститьОВыборе(Новый Структура("Организация, Период", 
		Организация,
		ОбщегоНазначенияКлиент.ДатаСеанса()));
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОповеститьОВыборе(ВыбраннаяСтрока);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти