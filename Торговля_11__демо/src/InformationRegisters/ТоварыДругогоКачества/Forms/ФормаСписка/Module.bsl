
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Номенклатура") Тогда
		ОтборНоменклатура = Параметры.Номенклатура;
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОтборНоменклатура, Новый Структура("Качество"));
		Если Реквизиты.Качество = Перечисления.ГрадацииКачества.Новый
			Или Реквизиты.Качество = Перечисления.ГрадацииКачества.ОграниченноГоден Тогда
			ИмяЭлементаОтбора = "Номенклатура";
		Иначе
			ИмяЭлементаОтбора = "НоменклатураБрак";
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			ИмяЭлементаОтбора,
			ОтборНоменклатура,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
	Иначе
		ВызватьИсключение НСтр("ru = 'Список товаров другого качества можно посмотреть
		                             |только в форме номенклатуры.'");		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_ТоварыДругогоКачества", ОтборНоменклатура);
КонецПроцедуры

#КонецОбласти

