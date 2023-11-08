
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = Заголовок + ": "+ Параметры.Номенклатура;
	
	Если ЗначениеЗаполнено(Параметры.Характеристика) Тогда
		Элементы.СписокХарактеристика.Видимость = Ложь;
		Заголовок = Заголовок + " ("+ Параметры.Характеристика + ")";
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Дата", Параметры.Дата);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Номенклатура", Параметры.Номенклатура);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Характеристика", Параметры.Характеристика);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Серия", Справочники.СерииНоменклатуры.ПустаяСсылка());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Упаковка", Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
		
	ДополнитьОтборДинамическогоСписка();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДополнитьОтборДинамическогоСписка()
	
	Перем CписокОтбораВладельцев;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ВидЦены.Статус",                 Перечисления.СтатусыДействияВидовЦен.Действует);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ВидЦены.ВспомогательнаяЦена",    Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ВидЦены.ИспользоватьПриПродаже", Истина);
	
	Если Параметры.Свойство("ОбъектХраненияУсловийПродаж") Тогда
		CписокОтбораВладельцев = Новый СписокЗначений();
		CписокОтбораВладельцев.Добавить(Справочники.Партнеры.ПустаяСсылка());
		CписокОтбораВладельцев.Добавить(Параметры.ОбъектХраненияУсловийПродаж);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ОбъектХраненияУсловийПродаж", CписокОтбораВладельцев);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ВидЦены.Назначение", Перечисления.НазначенияВидовЦен.Общий);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти