#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НастройкаКонтроляОбеспечения);
	
	Если Параметры.КонтролироватьСвободныеОстатки Тогда
		Заколовок = НСтр("ru = 'Номенклатура без контроля свободного остатка (Склад: %1)'");
	Иначе
		Заколовок = НСтр("ru = 'Номенклатура с контролем свободного остатка (Склад: %1)'");
	КонецЕсли;
	Заголовок = СтрЗаменить(Заколовок, "%1",Параметры.Склад);
	
	КонтролироватьСвободныеОстатки = Параметры.КонтролироватьСвободныеОстатки;
	Склад                          = Параметры.Склад;
	
	ОбновитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.НастройкаКонтроляОбеспечения.Форма.ВыборХарактеристик" Тогда
		ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
		
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ВыбранноеЗначение);
		СформироватьНадпись(ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Модифицированность И ЗавершениеРаботы Тогда
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'");
		Возврат;
	КонецЕсли;
	
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать'"));
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru = 'Все измененные данные будут потеряны. Закрыть форму?'"), СписокКнопок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ОтветНаВопрос = РезультатВопроса;
    
    Если ОтветНаВопрос <> "НеЗакрывать" Тогда
        ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		Закрыть();
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если Поле = Элементы.СписокХарактеристика Тогда
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) И ТекущаяСтрока.ТипЗаписи <> 0 Тогда
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("Номенклатура",                   ТекущаяСтрока.Номенклатура);
			ПараметрыОткрытия.Вставить("СписокХарактеристикиИсключения", ТекущаяСтрока.ХарактеристикиИсключения);
			
			ОткрытьФорму("РегистрСведений.НастройкаКонтроляОбеспечения.Форма.ВыборХарактеристик", 
				ПараметрыОткрытия,
				ЭтаФорма,
				УникальныйИдентификатор);
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатураПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	ОбновитьСписок(Элементы.список.ТекущаяСтрока);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	ОчиститьСообщения();
	Если ЗаписатьНастройкиКонтроляВРегистр() Тогда
		Оповестить("ЗаписьНастроекКонтроляОбеспечения", Склад);
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ОчиститьСообщения();
	Если ЗаписатьНастройкиКонтроляВРегистр() Тогда
		Оповестить("ЗаписьНастроекКонтроляОбеспечения", Склад);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписок(ТекущаяСтрока = Неопределено)

	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Т.Номенклатура КАК Номенклатура,
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ПОМЕСТИТЬ ВтХарактеристикиИсключения
		|ИЗ
		|	РегистрСведений.НастройкаКонтроляОбеспечения КАК Т
		|ГДЕ
		|	Т.Склад = &Склад
		|	И Т.КонтролироватьСвободныеОстатки <> &КонтролироватьСвободныеОстатки
		|	И Т.Характеристика <> ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
		|	И Т.Номенклатура = &Номенклатура
		|
		|СГРУППИРОВАТЬ ПО
		|	Т.Номенклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Т.Номенклатура КАК Номенклатура,
		|	Т.Характеристика КАК ХарактеристикаИсключение,
		|	0 КАК ТипЗаписи,
		|	0 КАК КоличествоИсключений
		|ИЗ
		|	РегистрСведений.НастройкаКонтроляОбеспечения КАК Т
		|ГДЕ
		|	Т.Склад = &Склад
		|	И Т.КонтролироватьСвободныеОстатки <> &КонтролироватьСвободныеОстатки
		|	И Т.Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
		|	И Т.Номенклатура = &Номенклатура
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Т.Номенклатура,
		|	Т.Характеристика,
		|	1,
		|	ЕСТЬNULL(Исключения.Количество, 0)
		|ИЗ
		|	РегистрСведений.НастройкаКонтроляОбеспечения КАК Т
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтХарактеристикиИсключения КАК Исключения
		|		ПО Т.Номенклатура = Исключения.Номенклатура
		|ГДЕ
		|	Т.Склад = &Склад
		|	И Т.КонтролироватьСвободныеОстатки <> &КонтролироватьСвободныеОстатки
		|	И Т.Номенклатура.ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
		|	И Т.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
		|	И Т.Номенклатура = &Номенклатура
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Т.Номенклатура,
		|	Т.Характеристика,
		|	2,
		|	ЕСТЬNULL(Исключения.Количество, 0)
		|ИЗ
		|	РегистрСведений.НастройкаКонтроляОбеспечения КАК Т
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтХарактеристикиИсключения КАК Исключения
		|		ПО Т.Номенклатура = Исключения.Номенклатура
		|ГДЕ
		|	Т.Склад = &Склад
		|	И Т.КонтролироватьСвободныеОстатки <> &КонтролироватьСвободныеОстатки
		|	И Т.Номенклатура.ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
		|	И Т.Характеристика <> ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
		|	И Т.Номенклатура = &Номенклатура
		|ИТОГИ
		|	МАКСИМУМ(ТипЗаписи),
		|	МАКСИМУМ(КоличествоИсключений)
		|ПО
		|	Номенклатура";

	Запрос.УстановитьПараметр("Склад", Параметры.Склад);
	Запрос.УстановитьПараметр("КонтролироватьСвободныеОстатки", Параметры.КонтролироватьСвободныеОстатки);
	
	Если ТекущаяСтрока = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Т.Номенклатура = &Номенклатура", "");
	Иначе
		СтрокаСписка = Список.НайтиПоИдентификатору(ТекущаяСтрока);
		Запрос.УстановитьПараметр("Номенклатура", СтрокаСписка.Номенклатура);
	КонецЕсли;

	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если ТекущаяСтрока <> Неопределено Тогда

		Если Выборка.Следующий() Тогда

			ЗаполнитьЗначенияСвойств(СтрокаСписка, Выборка);

			Если СтрокаСписка.ТипЗаписи = 2 Тогда

				ВыборкаХарактеристик = Выборка.Выбрать();
				Пока ВыборкаХарактеристик.Следующий() Цикл

					СтрокаСписка.ХарактеристикиИсключения.Добавить(ВыборкаХарактеристик.ХарактеристикаИсключение);

				КонецЦикла;

			КонецЕсли;

			СформироватьНадпись(СтрокаСписка);

		Иначе

			ХарактеристикиИспользуются = ХарактеристикиИспользуются(СтрокаСписка.Номенклатура);
			СтрокаСписка.ТипЗаписи = Число(ХарактеристикиИспользуются);
			СтрокаСписка.ХарактеристикиИсключения.Очистить();
			СтрокаСписка.КоличествоИсключений = 0;
			СформироватьНадпись(СтрокаСписка);

		КонецЕсли;

	Иначе

		Пока Выборка.Следующий() Цикл
			
			СтрокаСписка = Список.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаСписка, Выборка);
			
			Если СтрокаСписка.ТипЗаписи = 2 Тогда
				
				ВыборкаХарактеристик = Выборка.Выбрать();
				Пока ВыборкаХарактеристик.Следующий() Цикл
					
					СтрокаСписка.ХарактеристикиИсключения.Добавить(ВыборкаХарактеристик.ХарактеристикаИсключение);
					
				КонецЦикла;
				
			КонецЕсли;
			
			СформироватьНадпись(СтрокаСписка);
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьНадпись(Строка)

	Если Строка.ТипЗаписи = 0 Тогда
		Строка.Характеристика = НСтр("ru = '<не используются>'");
	ИначеЕсли Строка.ТипЗаписи = 1 И Строка.КоличествоИсключений = 0 Тогда
		Строка.Характеристика = НСтр("ru = 'для всех характеристик'");
	ИначеЕсли Строка.ТипЗаписи = 2 И Строка.КоличествоИсключений = 1 Тогда
		Строка.Характеристика =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'для %1 характеристики'"), Строка.КоличествоИсключений);
	Иначе
		Строка.Характеристика =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'для %1 характеристик'"), Строка.КоличествоИсключений);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ХарактеристикиИспользуются(Номенклатура)
	Возврат Справочники.Номенклатура.ХарактеристикиИспользуются(Номенклатура);
КонецФункции

&НаСервере
Функция ЗаписатьНастройкиКонтроляВРегистр()
	
	ДублиОтсутсвуют = ПроверитьНаличиеДублейТоваров();
	
	Если ДублиОтсутсвуют Тогда
		НаборЗаписей = РегистрыСведений.НастройкаКонтроляОбеспечения.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Склад.Установить(Склад);
		
		СтруктураЗаполнения = Новый Структура("Склад, КонтролироватьСвободныеОстатки", Склад, НЕ КонтролироватьСвободныеОстатки);
		
		Для каждого Строка Из Список Цикл
			СтруктураЗаполнения.Вставить("Номенклатура", Строка.Номенклатура);
			Если НЕ ЗначениеЗаполнено(Строка.Номенклатура) Тогда
				Продолжить;
			КонецЕсли; 
			ЕстьХарактеристики = Ложь;
			Для каждого Характеристика Из Строка.ХарактеристикиИсключения Цикл
				СтрокаЗаписи = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЗаписи, СтруктураЗаполнения);
				СтрокаЗаписи.Характеристика = Характеристика.Значение;
				ЕстьХарактеристики          = Истина;
			КонецЦикла;
			Если НЕ ЕстьХарактеристики Тогда
				СтрокаЗаписи = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЗаписи, СтруктураЗаполнения);
			КонецЕсли;
		КонецЦикла;
		
		СтрокаЗаписи = НаборЗаписей.Добавить();
		СтрокаЗаписи.Склад                          = Склад;
		СтрокаЗаписи.КонтролироватьСвободныеОстатки = КонтролироватьСвободныеОстатки;
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
	Возврат ДублиОтсутсвуют
	
КонецФункции

&НаСервере
Функция ПроверитьНаличиеДублейТоваров()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаТовары.Номенклатура   КАК Номенклатура
		|ПОМЕСТИТЬ
		|	ДокументТовары
		|ИЗ
		|	&ТаблицаТовары КАК ТаблицаТовары;
		|
		|ВЫБРАТЬ
		|	Товары.Номенклатура             КАК Номенклатура
		|ИЗ
		|	ДокументТовары КАК Товары
		|СГРУППИРОВАТЬ ПО
		|	Товары.Номенклатура
		|ИМЕЮЩИЕ 
		|	КОЛИЧЕСТВО (*) > 1");
	
	Запрос.УстановитьПараметр("ТаблицаТовары", Список.Выгрузить(,"Номенклатура"));
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru='Номенклатура ""%Номенклатура%"" повторяется.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Номенклатура%", Выборка.Номенклатура);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ,"Список");
		
	КонецЦикла;
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокХарактеристика.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТипЗаписи");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокХарактеристика.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТипЗаписи");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);

КонецПроцедуры

#КонецОбласти

#Область Инициализация
	
	ВыполняетсяЗакрытие = Ложь;
	
#КонецОбласти
