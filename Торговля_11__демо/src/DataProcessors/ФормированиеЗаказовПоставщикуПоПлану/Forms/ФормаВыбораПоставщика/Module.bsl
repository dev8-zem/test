
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	// Заполнение параметров динамических списков.
	ПараметрыСписка = Новый Структура("Номенклатура, Характеристика, Склад");
	ЗаполнитьЗначенияСвойств(ПараметрыСписка, Параметры);

	УстановитьПараметрыСписка(Поставщики,      ПараметрыСписка);
	УстановитьПараметрыСписка(ЦеныПоставщиков, ПараметрыСписка);

	ТекущаяДата = ТекущаяДатаСеанса();
	КурсВалютыУпрУчета = РаботаСКурсамиВалютУТ.ПолучитьКурсВалюты(Константы.ВалютаУправленческогоУчета.Получить(), ТекущаяДата);
	КоэффициентПересчетаЦены = 1 / (КурсВалютыУпрУчета.КурсЧислитель / КурсВалютыУпрУчета.КурсЗнаменатель);

	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Номенклатура, "СтавкаНДС, ЕдиницаИзмерения");
	КоэффициентНДС = 1 + ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(Реквизиты.СтавкаНДС)/100;
	ЕдиницаИзмерения = Реквизиты.ЕдиницаИзмерения;
	ВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = "РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Ложь;
	СвойстваСписка.ТекстЗапроса = СтрЗаменить(ЦеныПоставщиков.ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ЦеныПереопределяемый.Упаковка",
		"ЦеныПереопределяемый.Номенклатура"));
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.ЦеныПоставщиков,
	СвойстваСписка);
		
	ЦеныПоставщиков.Параметры.УстановитьЗначениеПараметра("ДатаЦены",                 ТекущаяДата);
	ЦеныПоставщиков.Параметры.УстановитьЗначениеПараметра("КоэффициентПересчетаЦены", КоэффициентПересчетаЦены);
	ЦеныПоставщиков.Параметры.УстановитьЗначениеПараметра("КоэффициентНДС",           КоэффициентНДС);
	
	// Настройка внешнего вида формы.
	Элементы.ЦенаУпрУчет.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Цена (%1)'"), Строка(ВалютаУпрУчета));
	
	Позиция = Строка(Параметры.Номенклатура) +
		?(ЗначениеЗаполнено(Параметры.Характеристика), ", " + Строка(Параметры.Характеристика), "");
		
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выбор поставщика для позиции: %1'"), Позиция);
	
	УстановитьКнопкуПоУмолчанию();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)

	УстановитьКнопкуПоУмолчанию();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЦеныПоставщиков

&НаКлиенте
Процедура ЦеныПоставщиковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ВыбратьНаКлиенте();

КонецПроцедуры

&НаКлиенте
Процедура ПоставщикНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ПоставщикОчистка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоставщики

&НаКлиенте
Процедура ПоставщикиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ВыбратьНаКлиенте();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)

	ВыбратьНаКлиенте();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьНаКлиенте()

	ПараметрыПоставщика = Новый Структура("Партнер");
	ПараметрыПоставщика.Вставить("Соглашение", ПредопределенноеЗначение("Справочник.СоглашенияСПоставщиками.ПустаяСсылка"));
	ПараметрыПоставщика.Вставить("ЦенаВВалютеУправленческогоУчета", 0);
	ПараметрыПоставщика.Вставить("ЦенаВВалютеСоглашения",           0);
	ПараметрыПоставщика.Вставить("Валюта", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	ПараметрыПоставщика.Вставить("ВидЦеныПоставщика", ПредопределенноеЗначение("Справочник.ВидыЦенПоставщиков.ПустаяСсылка"));
	ПараметрыПоставщика.Вставить("УпаковкаЗаказа", ПредопределенноеЗначение("Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка"));
	ПараметрыПоставщика.Вставить("МинимальнаяПартияПоставки",       0);
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоставщики Тогда
		
		Если Элементы.Поставщики.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Партнер = Элементы.Поставщики.ТекущиеДанные.Поставщик;
		УсловияЗакупок = УсловияЗакупокПартнера(Партнер);
		
		ПараметрыПоставщика.Вставить("Партнер",     Партнер);
		ПараметрыПоставщика.Вставить("Соглашение",  УсловияЗакупок.Соглашение);
		ПараметрыПоставщика.Вставить("Валюта",      УсловияЗакупок.Валюта);
		
	Иначе
		
		Если Элементы.ЦеныПоставщиков.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ТекущаяСтрока = Элементы.ЦеныПоставщиков.ТекущиеДанные;
		УсловияЗакупок = УсловияЗакупокПартнера(ТекущаяСтрока.Партнер, ТекущаяСтрока.ЦенаУпрУчет);
		
		ПараметрыПоставщика.Вставить("Партнер",               ТекущаяСтрока.Партнер);
		ПараметрыПоставщика.Вставить("Соглашение",            УсловияЗакупок.Соглашение);
		ПараметрыПоставщика.Вставить("Валюта",                УсловияЗакупок.Валюта);
		ПараметрыПоставщика.Вставить("ЦенаВВалютеСоглашения", УсловияЗакупок.Цена);
		
		ПараметрыПоставщика.Вставить("ЦенаВВалютеУправленческогоУчета", ТекущаяСтрока.ЦенаУпрУчет);
		ПараметрыПоставщика.Вставить("ВидЦеныПоставщика",               ТекущаяСтрока.ВидЦены);
		ПараметрыПоставщика.Вставить("Упаковка",                        ТекущаяСтрока.УпаковкаЗаказа);
		ПараметрыПоставщика.Вставить("МинимальнаяПартияПоставки",       ТекущаяСтрока.МинимальнаяПартияПоставки);
		
	КонецЕсли;
	
	Результат = Новый Структура("ПараметрыПоставщика", ПараметрыПоставщика);
	ОповеститьОвыборе(Результат);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыСписка(Список, Параметры)

	Для каждого Свойство Из Параметры Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, Свойство.Ключ, Свойство.Значение, Истина);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УстановитьКнопкуПоУмолчанию()

	Кнопка = ?(Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПодборПоЦене, Элементы.ВыбратьПоставщикаССоглашением,
		?(Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоставщики, Элементы.ВыбратьПоставщика, Неопределено));
	Кнопка.КнопкаПоУмолчанию = Истина;

КонецПроцедуры

&НаСервереБезКонтекста
Функция УсловияЗакупокПартнера(Партнер, Цена = 0)

	ВалютаУпрУчет = Константы.ВалютаУправленческогоУчета.Получить();
	Результат = Новый Структура("Соглашение, Валюта, Цена",
		Справочники.СоглашенияСПоставщиками.ПустаяСсылка(), ВалютаУпрУчет, Цена);

	Коэффициент = 1;
	УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(Партнер);
	Если УсловияЗакупок <> Неопределено И ЗначениеЗаполнено(УсловияЗакупок.Соглашение) Тогда
		Результат.Соглашение = УсловияЗакупок.Соглашение;
		Результат.Валюта = УсловияЗакупок.Валюта;
		Коэффициент = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
			ВалютаУпрУчет, УсловияЗакупок.Валюта, ТекущаяДатаСеанса());
		Результат.Цена = Результат.Цена * Коэффициент;
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти
