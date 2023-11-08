
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(КлючНазначенияИспользования) И Параметры.ГрупповоеЗаполнение Тогда
		КлючНазначенияИспользования = "ГрупповоеЗаполнение";
	КонецЕсли;
	
	// Заполнение параметров динамических списков.
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Склады, "Номенклатура",   Параметры.Номенклатура,   Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Склады, "Характеристика", Параметры.Характеристика, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Склады, "Склад",          Параметры.Склад,          Истина);
	
	Если РаспределениеЗапасов.ЭтоПроизводительныйРежим() Тогда
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ОсновнаяТаблица = "Справочник.Склады";
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		СвойстваСписка.ТекстЗапроса =
		"ВЫБРАТЬ
		|	СпрСклады.Ссылка КАК Склад,
		|	ЕСТЬNULL(ОстатокНаСкладеПереопределяемый.ВНаличииОстаток
		|				- ОстатокНаСкладеПереопределяемый.РезервироватьНаСкладеОстаток
		|				- ОстатокНаСкладеПереопределяемый.РезервироватьПоМереПоступленияОстаток, 0) КАК Доступно
		|ИЗ
		|	Справочник.Склады КАК СпрСклады
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыИПотребности.Остатки(,
		|				Номенклатура = &Номенклатура
		|					И Характеристика = &Характеристика
		|					И Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)) КАК ОстатокНаСкладеПереопределяемый
		|		ПО ОстатокНаСкладеПереопределяемый.Склад = СпрСклады.Ссылка
		|		 И ОстатокНаСкладеПереопределяемый.ВНаличииОстаток
		|			- ОстатокНаСкладеПереопределяемый.РезервироватьНаСкладеОстаток
		|			- ОстатокНаСкладеПереопределяемый.РезервироватьПоМереПоступленияОстаток > 0
		|ГДЕ
		|	НЕ СпрСклады.ЭтоГруппа
		|	И НЕ СпрСклады.ПометкаУдаления
		|	И НЕ СпрСклады.Ссылка = &Склад";
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Склады, СвойстваСписка);
	КонецЕсли;
	
	// Настройка внешнего вида формы.
	Если Параметры.ТипОбеспечения = Перечисления.ТипыОбеспечения.Покупка
		Или Параметры.ТипОбеспечения = Перечисления.ТипыОбеспечения.ПроизводствоНаСтороне Тогда
		
		УстановитьТекстЗапросаСпискаПоставщиков();
		
		Элементы.ГруппаПеремещение.Видимость = Ложь;
		Элементы.ГруппаПодразделения.Видимость = Ложь;
		
		Если Параметры.ГрупповоеЗаполнение Тогда
			
			Заголовок = НСтр("ru = 'Выбор поставщика'");
			Элементы.ГруппаОтборПоставщиков.Видимость = Ложь;
			
			Поставщики.Порядок.Элементы.Очистить();
			Поставщики.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
		Иначе
			
			Если ЗначениеЗаполнено(Параметры.Характеристика) Тогда
				
				ШаблонТекста = НСтр("ru = 'Выбор поставщика (Номенклатура: %1, Характеристика: %2, Склад: %3)'");
				Заголовок = СтрШаблон(ШаблонТекста, Параметры.Номенклатура, Параметры.Характеристика, Параметры.Склад);
				
			Иначе
				
				ШаблонТекста = НСтр("ru = 'Выбор поставщика (Номенклатура: %1, Склад: %2)'");
				Заголовок = СтрШаблон(ШаблонТекста, Параметры.Номенклатура, Параметры.Склад);
				
			КонецЕсли;
			
			ВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
			Элементы.ПоставщикиЦенаУпрУчет.Заголовок = СтрШаблон(НСтр("ru = 'Цена (%1)'"), ВалютаУпрУчета);
			
		КонецЕсли;
		
	ИначеЕсли Параметры.ТипОбеспечения = Перечисления.ТипыОбеспечения.Перемещение Тогда
		
		Элементы.ГруппаПоставщики.Видимость = Ложь;
		Элементы.ГруппаПодразделения.Видимость = Ложь;
		
		Если Параметры.ГрупповоеЗаполнение Тогда
			
			Заголовок = НСтр("ru = 'Выбор склада'");
			Элементы.СкладыДоступно.Видимость = Ложь;
			
			Склады.Порядок.Элементы.Очистить();
			Склады.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
		Иначе
			
			Если ЗначениеЗаполнено(Параметры.Характеристика) Тогда
				
				ШаблонТекста = НСтр("ru = 'Выбор склада (Номенклатура: %1, Характеристика: %2)'");
				Заголовок = СтрШаблон(ШаблонТекста, Параметры.Номенклатура, Параметры.Характеристика);
				
			Иначе
				
				Заголовок = СтрШаблон(НСтр("ru = 'Выбор склада (Номенклатура: %1)'"), Параметры.Номенклатура);
				
			КонецЕсли;
			
			ЕдиницаИзмерения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Номенклатура, "ЕдиницаИзмерения");
			Элементы.СкладыДоступно.Заголовок = СтрШаблон(НСтр("ru = 'Доступно (%1)'"), ЕдиницаИзмерения);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.ПоставщикиЦенаУпрУчет.Видимость           = Ложь;
	Элементы.ПоставщикиЗарегистрирована.Видимость      = Ложь;
	Элементы.ПоставщикиВидЦены.Видимость               = Ложь;
	Элементы.ПоставщикиПоследняяПоставка.Видимость     = Ложь;
	Элементы.ПоставщикиВсегоПоставок.Видимость         = Ложь;
	Элементы.ГруппаУпаковкаВалюта.Видимость            = Ложь;
	Элементы.БылиПоставки.Видимость = ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.Закупки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЦеныПриИзменении(Элемент)
	
	УстановитьТекстЗапросаСпискаПоставщиков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставкиПриИзменении(Элемент)
	
	УстановитьТекстЗапросаСпискаПоставщиков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоставщики

&НаКлиенте
Процедура ПоставщикиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСклады

&НаКлиенте
Процедура СкладыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодразделения

&НаКлиенте
Процедура ПодразделенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
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

&НаСервере
Процедура УстановитьТекстЗапросаСпискаПоставщиков()
	
	Элементы.ПоставщикиЦенаУпрУчет.Видимость               = Ложь;
	Элементы.ПоставщикиЗарегистрирована.Видимость          = Ложь;
	Элементы.ПоставщикиВидЦены.Видимость                   = Ложь;
	Элементы.ПоставщикиПоследняяПоставка.Видимость         = Ложь;
	Элементы.ПоставщикиВсегоПоставок.Видимость             = Ложь;
	Элементы.ГруппаУпаковкаВалюта.Видимость                = Ложь;
	Элементы.ПоставщикиУпаковкаЗаказа.Видимость            = Ложь;
	Элементы.ПоставщикиМинимальнаяПартияПоставки.Видимость = Ложь;
	
	// Установка свойств и параметров динамического списка "Поставщики".
	Если ЗарегистрированыЦены И БылиПоставки Тогда
		
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ОсновнаяТаблица              = "РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних";
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		СвойстваСписка.ТекстЗапроса =
			"ВЫБРАТЬ
			|	Поступление.Партнер                                        КАК Партнер,
			|	МАКСИМУМ(Поступление.Период)                               КАК ПоследняяПоставка,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Регистратор)                          КАК ВсегоПоставок,
			|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК УпаковкаЗаказа,
			|	0                                                          КАК МинимальнаяПартияПоставки
			|ПОМЕСТИТЬ Закупки
			|ИЗ
			|	Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитики
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Закупки КАК Поступление
			|		ПО Поступление.ХозяйственнаяОперация В (&ХозОперации)
			|		 И Поступление.Склад = &Склад
			|		 И Поступление.АналитикаУчетаНоменклатуры = КлючиАналитики.Ссылка
			|		 И Поступление.Активность
			|ГДЕ
			|	НЕ Поступление.Партнер ЕСТЬ NULL
			|		И КлючиАналитики.Номенклатура = &Номенклатура
			|		И КлючиАналитики.Характеристика = &Характеристика
			|	
			|СГРУППИРОВАТЬ ПО
			|	Поступление.Партнер
			|ИНДЕКСИРОВАТЬ ПО
			|	Партнер
			|;
			|
			|//////////////////////////////////////
			|ВЫБРАТЬ
			|	Цены.Партнер              КАК Поставщик,
			|	Цены.ВидЦеныПоставщика    КАК ВидЦены,
			|	Цены.Упаковка             КАК Упаковка,
			|	Цены.Цена                 КАК Цена,
			|	Цены.Валюта               КАК Валюта,
			|	Цены.Период               КАК Зарегистрирована,
			|	Закупки.ПоследняяПоставка КАК ПоследняяПоставка,
			|	Закупки.ВсегоПоставок     КАК ВсегоПоставок,
			|	ЕСТЬNULL(Цены.Цена * ВалютаЦены.КурсЧислитель / ВалютаЦены.КурсЗнаменатель, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) * &КоэффициентПересчетаЦены КАК ЦенаУпрУчет,
			|	УсловияЗакупок.УпаковкаЗаказа            КАК УпаковкаЗаказа,
			|	УсловияЗакупок.МинимальнаяПартияПоставки КАК МинимальнаяПартияПоставки
			|ИЗ
			|	РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(&ДатаЦены, Номенклатура = &Номенклатура И Характеристика = &Характеристика) КАК Цены
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&ДатаЦены, БазоваяВалюта = &БазоваяВалюта) КАК ВалютаЦены
			|		ПО Цены.Валюта = ВалютаЦены.Валюта
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ Закупки КАК Закупки
			|		ПО Закупки.Партнер = Цены.Партнер
			|
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УсловияЗакупок.СрезПоследних(&ДатаЦены, Номенклатура = &Номенклатура И Характеристика = &Характеристика) КАК УсловияЗакупок
			|		ПО Цены.ВидЦеныПоставщика = УсловияЗакупок.ВидЦеныПоставщика
			|		И Цены.Номенклатура = УсловияЗакупок.Номенклатура
			|		И Цены.Характеристика = УсловияЗакупок.Характеристика
			|ГДЕ
			|	Цены.Партнер.Поставщик
			|		И НЕ Цены.Партнер.ПометкаУдаления
			|		И НЕ Закупки.Партнер ЕСТЬ NULL";
		
		УчестьФункциональныеОпцииПриВыбореПартнера(СвойстваСписка.ТекстЗапроса, "Цены.Партнер");
		
		СвойстваСписка.ТекстЗапроса = СтрЗаменить(СвойстваСписка.ТекстЗапроса, "&ТекстЗапросаКоэффициентУпаковки",
			Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("Цены.Упаковка","Цены.Номенклатура"));
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Поставщики, СвойстваСписка);
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "Номенклатура",   Параметры.Номенклатура,   Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "Характеристика", Параметры.Характеристика, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "Склад",          Параметры.Склад,          Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "ДатаЦены",       ТекущаяДатаСеанса(),      Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "БазоваяВалюта", ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию(), Истина);
		
		ХозОперации = Документы.ЗаказПоставщику.ХозяйственныеОперацииДокумента(Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "ХозОперации", ХозОперации, Истина);
		
		КурсВалютыУпрУчета = РаботаСКурсамиВалютУТ.ПолучитьКурсВалюты(Константы.ВалютаУправленческогоУчета.Получить(), ТекущаяДатаСеанса());
		КоэффициентПересчетаЦены = 1 / (КурсВалютыУпрУчета.КурсЧислитель / КурсВалютыУпрУчета.КурсЗнаменатель);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "КоэффициентПересчетаЦены", КоэффициентПересчетаЦены, Истина);
		
		Элементы.ПоставщикиЦенаУпрУчет.Видимость               = Истина;
		Элементы.ПоставщикиЗарегистрирована.Видимость          = Истина;
		Элементы.ПоставщикиВидЦены.Видимость                   = Истина;
		Элементы.ПоставщикиПоследняяПоставка.Видимость         = Истина;
		Элементы.ПоставщикиВсегоПоставок.Видимость             = Истина;
		Элементы.ГруппаУпаковкаВалюта.Видимость                = Истина;
		Элементы.ПоставщикиУпаковкаЗаказа.Видимость            = Истина;
		Элементы.ПоставщикиМинимальнаяПартияПоставки.Видимость = Истина;
		
	ИначеЕсли ЗарегистрированыЦены И Не БылиПоставки Тогда
		
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ОсновнаяТаблица              = "РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних";
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		СвойстваСписка.ТекстЗапроса =
			"ВЫБРАТЬ
			|	Цены.Партнер           КАК Поставщик,
			|	Цены.ВидЦеныПоставщика КАК ВидЦены,
			|	Цены.Упаковка          КАК Упаковка,
			|	Цены.Цена              КАК Цена,
			|	Цены.Валюта            КАК Валюта,
			|	Цены.Период            КАК Зарегистрирована,
			|	ДАТАВРЕМЯ(1,1,1)       КАК ПоследняяПоставка,
			|	0                      КАК ВсегоПоставок,
			|	
			|	ЕСТЬNULL(Цены.Цена * ВалютаЦены.КурсЧислитель / ВалютаЦены.КурсЗнаменатель, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) * &КоэффициентПересчетаЦены КАК ЦенаУпрУчет,
			|	УсловияЗакупок.УпаковкаЗаказа            КАК УпаковкаЗаказа,
			|	УсловияЗакупок.МинимальнаяПартияПоставки КАК МинимальнаяПартияПоставки
			|ИЗ
			|	РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(&ДатаЦены, Номенклатура = &Номенклатура И Характеристика = &Характеристика) КАК Цены
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&ДатаЦены, БазоваяВалюта = &БазоваяВалюта) КАК ВалютаЦены
			|		ПО Цены.Валюта = ВалютаЦены.Валюта
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УсловияЗакупок.СрезПоследних(&ДатаЦены, Номенклатура = &Номенклатура И Характеристика = &Характеристика) КАК УсловияЗакупок
			|		ПО Цены.ВидЦеныПоставщика = УсловияЗакупок.ВидЦеныПоставщика
			|		И Цены.Номенклатура = УсловияЗакупок.Номенклатура
			|		И Цены.Характеристика = УсловияЗакупок.Характеристика
			|ГДЕ
			|	Цены.Партнер.Поставщик
			|		И НЕ Цены.Партнер.ПометкаУдаления";
		
		УчестьФункциональныеОпцииПриВыбореПартнера(СвойстваСписка.ТекстЗапроса, "Цены.Партнер");
		
		СвойстваСписка.ТекстЗапроса = СтрЗаменить(СвойстваСписка.ТекстЗапроса, "&ТекстЗапросаКоэффициентУпаковки",
			Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("Цены.Упаковка","Цены.Номенклатура"));
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Поставщики, СвойстваСписка);
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "Номенклатура",   Параметры.Номенклатура,   Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "Характеристика", Параметры.Характеристика, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "ДатаЦены",       ТекущаяДатаСеанса(),      Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "БазоваяВалюта", ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию(), Истина);
		
		КурсВалютыУпрУчета = РаботаСКурсамиВалютУТ.ПолучитьКурсВалюты(Константы.ВалютаУправленческогоУчета.Получить(), ТекущаяДатаСеанса());
		КоэффициентПересчетаЦены = 1 / (КурсВалютыУпрУчета.КурсЧислитель / КурсВалютыУпрУчета.КурсЗнаменатель);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "КоэффициентПересчетаЦены", КоэффициентПересчетаЦены, Истина);
		
		Элементы.ПоставщикиЦенаУпрУчет.Видимость               = Истина;
		Элементы.ПоставщикиЗарегистрирована.Видимость          = Истина;
		Элементы.ПоставщикиВидЦены.Видимость                   = Истина;
		Элементы.ГруппаУпаковкаВалюта.Видимость                = Истина;
		Элементы.ПоставщикиУпаковкаЗаказа.Видимость            = Истина;
		Элементы.ПоставщикиМинимальнаяПартияПоставки.Видимость = Истина;
		
	ИначеЕсли Не ЗарегистрированыЦены И БылиПоставки Тогда
		
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ОсновнаяТаблица              = "Справочник.Партнеры";
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		СвойстваСписка.ТекстЗапроса =
			"ВЫБРАТЬ
			|	Поступление.Партнер                                        КАК Партнер,
			|	МАКСИМУМ(Поступление.Период)                               КАК ПоследняяПоставка,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Регистратор)                          КАК ВсегоПоставок,
			|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК УпаковкаЗаказа,
			|	0                                                          КАК МинимальнаяПартияПоставки
			|ПОМЕСТИТЬ Закупки
			|ИЗ
			|	Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитики
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Закупки КАК Поступление
			|		ПО Поступление.ХозяйственнаяОперация В (&ХозОперации)
			|		 И Поступление.Склад = &Склад
			|		 И Поступление.АналитикаУчетаНоменклатуры = КлючиАналитики.Ссылка
			|		 И Поступление.Активность
			|ГДЕ
			|	НЕ Поступление.Партнер ЕСТЬ NULL
			|		И КлючиАналитики.Номенклатура = &Номенклатура
			|		И КлючиАналитики.Характеристика = &Характеристика
			|	
			|СГРУППИРОВАТЬ ПО
			|	Поступление.Партнер
			|ИНДЕКСИРОВАТЬ ПО
			|	Партнер
			|;
			|
			|//////////////////////////////////////
			|ВЫБРАТЬ
			|	Партнеры.Ссылка                                            КАК Поставщик,
			|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка)       КАК ВидЦены,
			|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка,
			|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)                   КАК Валюта,
			|	ДАТАВРЕМЯ(1,1,1)                                           КАК Зарегистрирована,
			|	0.00                                                       КАК Цена,
			|	0.00                                                       КАК ЦенаУпрУчет,
			|	Закупки.ПоследняяПоставка                                  КАК ПоследняяПоставка,
			|	Закупки.ВсегоПоставок                                      КАК ВсегоПоставок,
			|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК УпаковкаЗаказа,
			|	0                                                          КАК МинимальнаяПартияПоставки
			|ИЗ
			|	Справочник.Партнеры КАК Партнеры
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ Закупки КАК Закупки
			|		ПО Закупки.Партнер = Партнеры.Ссылка
			|ГДЕ
			|	Партнеры.Поставщик
			|		И НЕ Партнеры.ПометкаУдаления
			|		И НЕ Закупки.Партнер ЕСТЬ NULL";
		
		УчестьФункциональныеОпцииПриВыбореПартнера(СвойстваСписка.ТекстЗапроса, "Партнеры.Ссылка");
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Поставщики, СвойстваСписка);
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "Номенклатура",   Параметры.Номенклатура,   Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "Характеристика", Параметры.Характеристика, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "Склад",          Параметры.Склад,          Истина);
		ХозОперации = Документы.ЗаказПоставщику.ХозяйственныеОперацииДокумента(Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Поставщики, "ХозОперации", ХозОперации, Истина);
		
		Элементы.ПоставщикиПоследняяПоставка.Видимость      = Истина;
		Элементы.ПоставщикиВсегоПоставок.Видимость          = Истина;
		
	Иначе // Не ЗарегистрированыЦены И Не БылиПоставки
		
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ОсновнаяТаблица              = "Справочник.Партнеры";
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		СвойстваСписка.ТекстЗапроса =
			"ВЫБРАТЬ
			|	Партнеры.Ссылка                                            КАК Поставщик,
			|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка)       КАК ВидЦены,
			|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка,
			|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)                   КАК Валюта,
			|	ДАТАВРЕМЯ(1,1,1)                                           КАК Зарегистрирована,
			|	0.00                                                       КАК Цена,
			|	0.00                                                       КАК ЦенаУпрУчет,
			|	ДАТАВРЕМЯ(1,1,1)                                           КАК ПоследняяПоставка,
			|	0                                                          КАК ВсегоПоставок,
			|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК УпаковкаЗаказа,
			|	0                                                          КАК МинимальнаяПартияПоставки
			|ИЗ
			|	Справочник.Партнеры КАК Партнеры
			|ГДЕ
			|	Партнеры.Поставщик
			|	И НЕ Партнеры.ПометкаУдаления";
		
		УчестьФункциональныеОпцииПриВыбореПартнера(СвойстваСписка.ТекстЗапроса, "Партнеры.Ссылка");
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Поставщики, СвойстваСписка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УчестьФункциональныеОпцииПриВыбореПартнера(ТекстЗапроса, ИмяПоляПатнера)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		ТекстЗапроса = ТекстЗапроса + "	И " + ИмяПоляПатнера + " <> Значение(Справочник.Партнеры.НеизвестныйПартнер)";
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями") Тогда
		ТекстЗапроса = ТекстЗапроса + "	И " + ИмяПоляПатнера + " <> Значение(Справочник.Партнеры.НашеПредприятие)";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНаКлиенте()
	
	ПараметрыПоставкиОптимальные = Новый Структура("ИсточникОбеспечения");
	ПараметрыПоставкиОптимальные.Вставить("Соглашение", ПредопределенноеЗначение("Справочник.СоглашенияСПоставщиками.ПустаяСсылка"));
	ПараметрыПоставкиОптимальные.Вставить("ЦенаВВалютеУправленческогоУчета", 0);
	ПараметрыПоставкиОптимальные.Вставить("ЦенаВВалютеСоглашения",           0);
	ПараметрыПоставкиОптимальные.Вставить("МинимальнаяСуммаЗаказа",          0);
	ПараметрыПоставкиОптимальные.Вставить("МинимальнаяПартияПоставки",       0);
	ПараметрыПоставкиОптимальные.Вставить("ВалютаСоглашения", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	ПараметрыПоставкиОптимальные.Вставить("ВидЦены", ПредопределенноеЗначение("Справочник.ВидыЦенПоставщиков.ПустаяСсылка"));
	ПараметрыПоставкиОптимальные.Вставить("УпаковкаЗаказа", ПредопределенноеЗначение("Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка"));
	
	Если Параметры.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Покупка")
		Или Параметры.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.ПроизводствоНаСтороне") Тогда
			
			Если Элементы.Поставщики.ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			ТекущаяСтрока = Элементы.Поставщики.ТекущиеДанные;
			
			Партнер = ТекущаяСтрока.Поставщик;
			
			Если ЗарегистрированыЦены Тогда
				
				УсловияЗакупок = УсловияЗакупокПартнера(Партнер, ТекущаяСтрока.ЦенаУпрУчет);
				
			Иначе
				
				УсловияЗакупок = УсловияЗакупокПартнера(Партнер, 0);
				
			КонецЕсли;
			
			ПараметрыПоставкиОптимальные.Вставить("ИсточникОбеспечения",    Партнер);
			ПараметрыПоставкиОптимальные.Вставить("Соглашение",             УсловияЗакупок.Соглашение);
			ПараметрыПоставкиОптимальные.Вставить("ВалютаСоглашения",       УсловияЗакупок.Валюта);
			ПараметрыПоставкиОптимальные.Вставить("МинимальнаяСуммаЗаказа", УсловияЗакупок.МинимальнаяСуммаЗаказа);
			
			Если ЗарегистрированыЦены Тогда
				
				ПараметрыПоставкиОптимальные.Вставить("ЦенаВВалютеСоглашения",           УсловияЗакупок.Цена);
				ПараметрыПоставкиОптимальные.Вставить("ЦенаВВалютеУправленческогоУчета", ТекущаяСтрока.ЦенаУпрУчет);
				ПараметрыПоставкиОптимальные.Вставить("ВидЦены",                         ТекущаяСтрока.ВидЦены);
				ПараметрыПоставкиОптимальные.Вставить("УпаковкаЗаказа",                  ТекущаяСтрока.УпаковкаЗаказа);
				ПараметрыПоставкиОптимальные.Вставить("МинимальнаяПартияПоставки",       ТекущаяСтрока.МинимальнаяПартияПоставки);
				
			КонецЕсли;
			
	ИначеЕсли Параметры.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Перемещение") Тогда
		
		Если Элементы.Склады.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыПоставкиОптимальные.Вставить("ИсточникОбеспечения", Элементы.Склады.ТекущиеДанные.Склад);
		
	КонецЕсли;
	
	Результат = Новый Структура("ПараметрыПоставкиОптимальные", ПараметрыПоставкиОптимальные);
	ОповеститьОвыборе(Результат);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УсловияЗакупокПартнера(Партнер, Цена)
	
	Возврат ОбеспечениеСервер.УсловияЗакупокПартнера(Партнер, Цена);
	
КонецФункции


#КонецОбласти
