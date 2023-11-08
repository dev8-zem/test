
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЕдиницаИзмеренияНоменклатуры = Параметры.ЕдиницаИзмеренияНоменклатуры;
	
	Элементы.ЕдиницаИзмеренияСоставляющей.СписокВыбора.Добавить(0, ЕдиницаИзмеренияНоменклатуры);
	
	Для Каждого Упаковка Из Параметры.Упаковки Цикл
		СтрокаУпаковок = Упаковки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаУпаковок, Упаковка);
		Элементы.ЕдиницаИзмеренияСоставляющей.СписокВыбора.Добавить(Упаковки.Индекс(СтрокаУпаковок) + 1,
			СтрокаУпаковок.Представление);
	КонецЦикла;
	
	НайденныеСтроки = Упаковки.НайтиСтроки(Новый Структура("Идентификатор", Параметры.ТекущаяСтрока));
	Если НайденныеСтроки.Количество() = 0 Тогда
		ЕдиницаИзмеренияСоставляющей = 0;
	Иначе
		ЕдиницаИзмеренияСоставляющей = Упаковки.Индекс(НайденныеСтроки[0]) + 1;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураУпаковки = Новый Структура;
	СтруктураУпаковки.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
	СтруктураУпаковки.Вставить("Количество",       Количество);
	СтруктураУпаковки.Вставить("Коэффициент",      Коэффициент);
	СтруктураУпаковки.Вставить("Наименование",     Наименование);
	Если ЕдиницаИзмеренияСоставляющей = 0 Тогда
		СтруктураУпаковки.Вставить("ИдентификаторСоставляющей", Неопределено);
	Иначе
		СтруктураУпаковки.Вставить("ИдентификаторСоставляющей", Упаковки[ЕдиницаИзмеренияСоставляющей - 1].Идентификатор);
	КонецЕсли;
	
	Закрыть(СтруктураУпаковки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЕдиницаИзмеренияПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоУпаковокПриИзменении(Элемент)
	
	РасчитатьКоэффициент();
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияСоставляющейПриИзменении(Элемент)
	
	РасчитатьКоэффициент();
	СформироватьНаименование();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура РасчитатьКоэффициент()
	
	Если ЕдиницаИзмеренияСоставляющей = 0 Тогда
		Коэффициент = Количество;
	Иначе
		Коэффициент = Количество * Упаковки[ЕдиницаИзмеренияСоставляющей - 1].Коэффициент;
	КонецЕсли;
	
Конецпроцедуры

&НаКлиенте
Процедура СформироватьНаименование()
	
	Наименование = СтрШаблон("%1 (%2 %3)",
		ЕдиницаИзмерения,
		Коэффициент,
		ЕдиницаИзмеренияНоменклатуры);
	
Конецпроцедуры

#КонецОбласти
