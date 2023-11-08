
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Ссылка") Тогда
		Ссылка = Параметры.Ссылка;
	Иначе
		Склад = Параметры.Склад;
		Помещение = Параметры.Помещение;
	КонецЕсли;
	
	ЗаполнитьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("ЗавершитьРазмещениеВЯчейку", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура",                 Элемент.ТекущиеДанные.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика",               Элемент.ТекущиеДанные.Характеристика);
	ПараметрыФормы.Вставить("Серия",                        Элемент.ТекущиеДанные.Серия);
	ПараметрыФормы.Вставить("Упаковка",                     Элемент.ТекущиеДанные.УпаковкаОтбор);
	ПараметрыФормы.Вставить("УпаковкаРазмещено",            Элемент.ТекущиеДанные.УпаковкаРазмещение);
	ПараметрыФормы.Вставить("КоличествоУпаковок",           Элемент.ТекущиеДанные.КоличествоУпаковокОтбор);
	ПараметрыФормы.Вставить("КоличествоУпаковокРазмещено",  Элемент.ТекущиеДанные.КоличествоУпаковокРазмещение);
	ПараметрыФормы.Вставить("Режим",                        "ПересчетРедактирование");
	ПараметрыФормы.Вставить("НомерСтроки",                  Элемент.ТекущаяСтрока);
	ПараметрыФормы.Вставить("Склад",                        Склад);
	ПараметрыФормы.Вставить("Помещение",                    Помещение);
	ПараметрыФормы.Вставить("Ячейка",                       Элемент.ТекущиеДанные.ЯчейкаОтбор);
	ПараметрыФормы.Вставить("ЯчейкаЗамена",                 Элемент.ТекущиеДанные.ЯчейкаРазмещение);
	ПараметрыФормы.Вставить("ТипОперации",                  3);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.РазмещениеВЯчейки",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьКонтроль(Команда)
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить("Завершить", НСтр("ru = 'Завершить'"));
	СписокЗначений.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Завершить перемещение?'"), СписокЗначений, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура Сканировать(Команда)
	
	Описание = Новый ОписаниеОповещения("РезультатПоискаЯчейки", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипПоиска", "ПоискЯчейки");
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СканированиеШтрихкода",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФорму()
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		СтруктураДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Склад, Комментарий, Помещение, Исполнитель");
		Склад       = СтруктураДокумента.Склад;
		Комментарий = СтруктураДокумента.Комментарий;
		Помещение   = СтруктураДокумента.Помещение;
		Исполнитель = СтруктураДокумента.Исполнитель;
	КонецЕсли;
	
	Для Каждого Строка Из Ссылка.ТоварыОтбор Цикл
		
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.ЯчейкаОтбор = Строка.Ячейка;
		НоваяСтрока.УпаковкаОтбор = Строка.Упаковка;
		НоваяСтрока.КоличествоОтбор = Строка.Количество;
		НоваяСтрока.КоличествоУпаковокОтбор = Строка.КоличествоУпаковок;
		
		// Поиск строк в размещении
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Номенклатура",   Строка.Номенклатура);
		СтруктураПоиска.Вставить("Характеристика", Строка.Характеристика);
		СтруктураПоиска.Вставить("Серия",          Строка.Серия);
		СтруктураПоиска.Вставить("Назначение",     Строка.Назначение);
		
		РезультатПоиска = Ссылка.ТоварыРазмещение.НайтиСтроки(СтруктураПоиска);
		Если РезультатПоиска.Количество() > 0 Тогда
			НоваяСтрока.ЯчейкаРазмещение             = РезультатПоиска[0].Ячейка;
			НоваяСтрока.УпаковкаРазмещение           = РезультатПоиска[0].Упаковка;
			НоваяСтрока.КоличествоРазмещение         = РезультатПоиска[0].Количество;
			НоваяСтрока.КоличествоУпаковокРазмещение = РезультатПоиска[0].КоличествоУпаковок;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["СтраницаИнформация"] Тогда
		
		СтандартнаяОбработка = Ложь;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["СтраницаКПоступлению"];
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РезультатПоискаЯчейки(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Описание = Новый ОписаниеОповещения("ЗавершитьРазмещениеВЯчейку", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ячейка",      Результат);
	ПараметрыФормы.Вставить("Склад",       Склад);
	ПараметрыФормы.Вставить("Помещение",   Помещение);
	ПараметрыФормы.Вставить("ТипОперации", 3);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.РазмещениеВЯчейки",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРазмещениеВЯчейку(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Результат.МассивРазмещений Цикл
		
		Если Результат.Режим = "ПересчетРедактирование" Тогда
			НоваяСтрока = Товары[Строка.НомерСтроки];
		Иначе
			НоваяСтрока = Товары.Добавить();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		
		НоваяСтрока.ЯчейкаОтбор = Строка.Ячейка;
		НоваяСтрока.ЯчейкаРазмещение = Строка.ЯчейкаЗамена;
		
		НоваяСтрока.УпаковкаОтбор = Строка.Упаковка;
		НоваяСтрока.УпаковкаРазмещение = Строка.УпаковкаРазмещено;
		
		НоваяСтрока.КоличествоУпаковокОтбор = Строка.КоличествоУпаковок;
		НоваяСтрока.КоличествоУпаковокРазмещение = Строка.КоличествоУпаковокРазмещено;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = "Завершить" Тогда
		
		ОтборЗавершен = ЗакончитьПеремещениеНаСервере();
		
		Если ОтборЗавершен Тогда
			Закрыть();
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗакончитьПеремещениеНаСервере()
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ДокументОбъект = Ссылка.ПолучитьОбъект();
	Иначе
		ДокументОбъект                      = Документы.ОтборРазмещениеТоваров.СоздатьДокумент();
		ДокументОбъект.ВидОперации          = Перечисления.ВидыОперацийОтбораРазмещенияТоваров.Перемещение;
		ДокументОбъект.ДатаНачалаВыполнения = ТекущаяДатаСеанса();
		ДокументОбъект.Дата                 = ТекущаяДатаСеанса();
		Исполнитель                         = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	ДокументОбъект.Статус      = Перечисления.СтатусыОтборовРазмещенийТоваров.ВыполненоБезОшибок;
	ДокументОбъект.Помещение   = Помещение;
	ДокументОбъект.Комментарий = Комментарий;
	ДокументОбъект.Исполнитель = Исполнитель;
	ДокументОбъект.Склад       = Склад;
	
	ДокументОбъект.ДатаОкончанияВыполнения = ТекущаяДатаСеанса();
	
	ДокументОбъект.ТоварыОтбор.Очистить();
	ДокументОбъект.ТоварыРазмещение.Очистить();
	
	Если Склад.ИспользоватьСкладскиеПомещения И Помещение.Пустая() Тогда
		
		Сообщить("Не выбрано помещение");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["СтраницаИнформация"];
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Для Каждого Строка Из Товары Цикл
		
		НоваяСтрока = ДокументОбъект.ТоварыОтбор.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		
		КоэффициентУпаковки = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Строка.УпаковкаОтбор, Строка.Номенклатура);
		НоваяСтрока.КоличествоОтобрано = Строка.КоличествоУпаковокОтбор * КоэффициентУпаковки;
		НоваяСтрока.КоличествоУпаковокОтобрано = Строка.КоличествоУпаковокОтбор;
		НоваяСтрока.Количество = НоваяСтрока.КоличествоОтобрано;
		НоваяСтрока.КоличествоУпаковок = НоваяСтрока.КоличествоУпаковокОтобрано;
		НоваяСтрока.Ячейка = Строка.ЯчейкаОтбор;
		НоваяСтрока.Упаковка = Строка.УпаковкаОтбор;
		
		НоваяСтрока = ДокументОбъект.ТоварыРазмещение.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		
		КоэффициентУпаковки = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Строка.УпаковкаРазмещение, Строка.Номенклатура);
		НоваяСтрока.КоличествоРазмещено = Строка.КоличествоУпаковокРазмещение * КоэффициентУпаковки;
		НоваяСтрока.КоличествоУпаковокРазмещено = Строка.КоличествоУпаковокРазмещение;
		НоваяСтрока.Количество = НоваяСтрока.КоличествоРазмещено;
		НоваяСтрока.КоличествоУпаковок = НоваяСтрока.КоличествоУпаковокРазмещено;
		НоваяСтрока.Ячейка = Строка.ЯчейкаРазмещение;
		НоваяСтрока.Упаковка = Строка.УпаковкаРазмещение;
		
	КонецЦикла;
	
	Попытка
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
