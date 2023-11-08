
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Список.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	СписокВыборКлиент();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыВыбранныеОтправители

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВыборКлиент();
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СписокВыборКлиент()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Выберите строку.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	
	Результат.Вставить("Отправитель", ТекущиеДанные.Отправитель); 
	Результат.Вставить("Договор", ТекущиеДанные.Договор); 
	Результат.Вставить("ВидЦен", ТекущиеДанные.ВидЦен); 
	Результат.Вставить("ТипЗапасов", ТекущиеДанные.ТипЗапасов);
	Результат.Вставить("ХозяйственнаяОперация", ТекущиеДанные.ХозяйственнаяОперация);
	
	Закрыть(Результат);

КонецПроцедуры

#КонецОбласти
