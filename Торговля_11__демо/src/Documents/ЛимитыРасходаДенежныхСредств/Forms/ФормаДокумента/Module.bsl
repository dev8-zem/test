
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПериодОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РезультатВыбора = Неопределено;
	ВыбратьПериодИзВыпадающегоСписка(РезультатВыбора, Элемент, ВидПериода, Объект.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛимитыНетЛимитаРасходаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Лимиты.ТекущиеДанные;
	
	Если Не ТекущиеДанные.ЕстьЛимит Тогда
		ТекущиеДанные.Сумма = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЛимитамиПрошлогоМесяца(Команда)
	
	ПараметрыПроверки = РаботаСТабличнымиЧастямиКлиент.ПараметрыПроверкиЗаполнения();
	ПараметрыПроверки.ТабличнаяЧасть = Объект.Лимиты;
	ПараметрыПроверки.ПроверятьРаспроведенность = Ложь;
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьЛимитамиПрошлогоМесяцаЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.ПроверитьВозможностьЗаполнения(ЭтаФорма, Оповещение, ПараметрыПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЛимитамиПрошлогоМесяцаЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаполнитьЛимитамиПрошлогоМесяцаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьямиДвиженияДенежныхСредств(Команда)
	
	ПараметрыПроверки = РаботаСТабличнымиЧастямиКлиент.ПараметрыПроверкиЗаполнения();
	ПараметрыПроверки.ТабличнаяЧасть = Объект.Лимиты;
	ПараметрыПроверки.ПроверятьРаспроведенность = Ложь;
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьСтатьямиДвиженияДенежныхСредствЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.ПроверитьВозможностьЗаполнения(ЭтаФорма, Оповещение, ПараметрыПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьямиДвиженияДенежныхСредствЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаполнитьСтатьямиДвиженияДенежныхСредствСервер();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЛимитыСумма.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Лимиты.ЕстьЛимит");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не ограничен>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

#Область Прочее

&НаКлиенте
Процедура ВыбратьПериодИзВыпадающегоСписка(РезультатВыбора, Элемент, ВидПериода, Период, ИндексНачальногоЗначения = Неопределено)
	
	СписокПериодов = СписокФиксированныхПериодов(Период, ВидПериода, ОбщегоНазначенияКлиент.ДатаСеанса());
	Если ИндексНачальногоЗначения = Неопределено Тогда
		ИндексНачальногоЗначения = СписокПериодов.НайтиПоЗначению(Период);
	КонецЕсли;
	Если ИндексНачальногоЗначения = Неопределено Тогда
		ИндексНачальногоЗначения = СписокПериодов.Количество() - 1;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("СписокПериодов", СписокПериодов);
	ПараметрыОповещения.Вставить("РезультатВыбора", РезультатВыбора);
	ПараметрыОповещения.Вставить("ЭлементФормы", Элемент);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборПериодаИзСпискаЗавершение", ЭтаФорма, ПараметрыОповещения);
	
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокПериодов, Элемент, ИндексНачальногоЗначения);
	
КонецПроцедуры

// Обработка выбора
// 
// Параметры:
//    ВыбранныйЭлемент - ПолеФормы - Выбранный элемент
//    ДополнительныеПараметры - Структура - структура с полями:
//     * СписокПериодов - СписокЗначений - Список периодов
//     * РезультатВыбора - Строка - Выбранный период
//     * ЭлементФормы - ПолеФормы - Поле, в котором происходит выбор периода
//
&НаКлиенте
Процедура ВыборПериодаИзСпискаЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	РезультатВыбора = ДополнительныеПараметры.РезультатВыбора;
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		РезультатВыбора = Неопределено;
		Возврат;
	КонецЕсли;
	
	// Листание вверх-вниз.
	СписокПериодов = ДополнительныеПараметры.СписокПериодов;
	Индекс = СписокПериодов.Индекс(ВыбранныйЭлемент);
	Если Индекс = 0 Или Индекс = СписокПериодов.Количество() - 1 Тогда
		ВыбратьПериодИзВыпадающегоСписка(
			РезультатВыбора, ДополнительныеПараметры.ЭлементФормы, ВидПериода, ВыбранныйЭлемент.Значение, Индекс);
	Иначе
		Объект.Период = ВыбранныйЭлемент.Значение;
		Модифицированность = Истина;
		ЗаполнитьСписокВыбораПериода();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ВидПериода = Перечисления.ДоступныеПериодыОтчета.Месяц;
	
	ЗаполнитьСписокВыбораПериода();
	
	ВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
	Элементы.ЛимитыСумма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Лимит (%1)'"),
		Строка(ВалютаУпрУчета));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораПериода()
	
	СписокВыбораПериода = Элементы.Период.СписокВыбора;
	СписокВыбораПериода.Очистить();
	
	ПериодСтрокой = ПолучитьПредставлениеПериода(ВидПериода, Объект.Период, КонецМесяца(Объект.Период));
	СписокВыбораПериода.Добавить(Объект.Период, ПериодСтрокой);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЛимитамиПрошлогоМесяцаСервер()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЛимитыРасходаДенежныхСредств.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ИСТИНА КАК ЕстьЛимит,
	|	ЛимитыРасходаДенежныхСредств.ЛимитОборот КАК Сумма
	|ИЗ
	|	РегистрНакопления.ЛимитыРасходаДенежныхСредств.Обороты(
	|		ДОБАВИТЬКДАТЕ(&ДатаНачала, МЕСЯЦ, -1),
	|		ДОБАВИТЬКДАТЕ(&ДатаОкончания, МЕСЯЦ, -1),
	|		,
	|		Организация = &Организация
	|		И Подразделение = &Подразделение) КАК ЛимитыРасходаДенежныхСредств");
	
	ИспользоватьЛимитыПоОрганизация = ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям"); 
	ИспользоватьЛимитыПоПодразделениям = ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям");
	
	Запрос.УстановитьПараметр("Организация", 
		?(ИспользоватьЛимитыПоОрганизация, Объект.Организация, Справочники.Организации.ПустаяСсылка()));
	Запрос.УстановитьПараметр("Подразделение", 
		?(ИспользоватьЛимитыПоПодразделениям, Объект.Подразделение, Справочники.СтруктураПредприятия.ПустаяСсылка()));
		
	Запрос.УстановитьПараметр("ДатаНачала", Объект.Период);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Объект.Период));
	
	Объект.Лимиты.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Если Не Объект.Лимиты.Количество() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Отсутствуют данные для заполнения.'"),, "Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатьямиДвиженияДенежныхСредствСервер()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтатьиДвиженияДенежныхСредств.Ссылка КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Справочник.СтатьиДвиженияДенежныхСредств.ХозяйственныеОперации КАК СтатьиДвиженияДенежныхСредств
	|ГДЕ
	|	СтатьиДвиженияДенежныхСредств.ХозяйственнаяОперация В (&МассивОпераций)
	|	И НЕ СтатьиДвиженияДенежныхСредств.Ссылка.ПометкаУдаления
	|	И НЕ СтатьиДвиженияДенежныхСредств.Ссылка.ЭтоГруппа
	|");
	
	Запрос.УстановитьПараметр("МассивОпераций",
		Справочники.СтатьиДвиженияДенежныхСредств.ХозяйственныеОперацииРасходаДенежныхСредств());
	Объект.Лимиты.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПредставлениеПериода(ВидПериода, Знач НачалоПериода, Знач КонецПериода)
	
	Если ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.ПроизвольныйПериод") Тогда	
		Если Не ЗначениеЗаполнено(НачалоПериода) И Не ЗначениеЗаполнено(КонецПериода) Тогда
			Возврат "";
		Иначе
			Возврат Формат(НачалоПериода, "ДФ=dd.MM.yy") + " - " + Формат(КонецПериода, "ДФ=dd.MM.yy");
		КонецЕсли;
	Иначе
		НачалоПериода = НачалоДня(НачалоПериода);
		КонецПериода = КонецДня(КонецПериода);
		РасчетныйВидПериода = ОтчетыУТКлиентСервер.ПолучитьВидПериода(НачалоПериода, КонецПериода);
		Если РасчетныйВидПериода <> ВидПериода И ЗначениеЗаполнено(НачалоПериода) Тогда
			ВидПериода = РасчетныйВидПериода;
		КонецЕсли;
		
		Список = СписокФиксированныхПериодов(НачалоПериода, ВидПериода, ТекущаяДатаСеанса());
		
		ЭлементСписка = Список.НайтиПоЗначению(НачалоПериода);
		Если ЭлементСписка <> Неопределено Тогда
			Возврат ЭлементСписка.Представление;
		Иначе
			Возврат "";
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СписокФиксированныхПериодов(Знач НачалоПериода, ВидПериода, Сегодня)
	
	СписокПериодов = Новый СписокЗначений;
	
	Если НачалоПериода = '00010101' Тогда
		Возврат СписокПериодов;
	КонецЕсли;
	
	НачалоПериода = НачалоДня(НачалоПериода);
	
	Сегодня = НачалоДня(Сегодня);
	
	НавигационныйПунктРанееПредставление = НСтр("ru = 'Ранее...'");
	НавигационныйПунктПозжеПредставление = НСтр("ru = 'Позже...'");
	
	Если ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.День") Тогда
		ТекущийДеньНедели   = ДеньНедели(Сегодня);
		ВыбранныйДеньНедели = ДеньНедели(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле. В 1 дне 86400 секунд.
		НачальныйДеньНедели = ТекущийДеньНедели - 5;
		КонечныйДеньНедели  = ТекущийДеньНедели + 1;
		Если ВыбранныйДеньНедели > КонечныйДеньНедели Тогда
			ВыбранныйДеньНедели = ВыбранныйДеньНедели - 7;
		КонецЕсли;
		
		Период = НачалоПериода - 86400 * (ВыбранныйДеньНедели - НачальныйДеньНедели);
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		СписокПериодов.Добавить(Период - 86400 * 7, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Счетчик = 1 По 7 Цикл
			СписокПериодов.Добавить(Период, Формат(Период, НСтр("ru='ДФ=''dd MMMM yyyy, dddd'''"))
				+ ?(Период = Сегодня, " - " + НСтр("ru = 'сегодня'"), ""));
			Период = Период + 86400;
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		СписокПериодов.Добавить(Период + 86400 * 6, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Неделя") Тогда
		ТекущееНачалоНедели   = НачалоНедели(Сегодня);
		ВыбранноеНачалоНедели = НачалоНедели(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле. В 7 днях 604800 секунд.
		РазностьНедель = (ВыбранноеНачалоНедели - ТекущееНачалоНедели) / 604800;
		Коэффициент = (РазностьНедель - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальнаяНеделя = ТекущееНачалоНедели + (2 + Коэффициент*7) * 604800;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		СписокПериодов.Добавить(НачальнаяНеделя - 7 * 604800, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Счетчик = 0 По 6 Цикл
			Период = НачальнаяНеделя + Счетчик * 604800;
			КонецПериода  = КонецНедели(Период);
			ПредставлениеПериода = Формат(Период, "ДФ=dd.MM") + " - " + Формат(КонецПериода, "ДЛФ=D")
				+ " (" + НеделяГода(КонецПериода) + " " + НСтр("ru = 'неделя года'") + ")";
			Если Период = ТекущееНачалоНедели Тогда
				ПредставлениеПериода = ПредставлениеПериода + " - " + НСтр("ru = 'эта неделя'");
			КонецЕсли;
			СписокПериодов.Добавить(Период, ПредставлениеПериода);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		СписокПериодов.Добавить(НачальнаяНеделя + 13 * 604800, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Декада") Тогда
		ТекущийГод   = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущийМесяц   = Месяц(Сегодня);
		ВыбранныйМесяц = Месяц(НачалоПериода);
		ТекущийДень   = День(Сегодня);
		ВыбранныйДень = День(НачалоПериода);
		ТекущаяДекада   = ?(ТекущийДень   <= 10, 1, ?(ТекущийДень   <= 20, 2, 3));
		ВыбраннаяДекада = ?(ВыбранныйДень <= 10, 1, ?(ВыбранныйДень <= 20, 2, 3));
		ТекущаяДекадаАбсолютно   = ТекущийГод*36 + (ТекущийМесяц-1)*3 + (ТекущаяДекада-1);
		ВыбраннаяДекадаАбсолютно = ВыбранныйГод*36 + (ВыбранныйМесяц-1)*3 + (ВыбраннаяДекада-1);
		СтрокаДекада = НСтр("ru = 'декада'");
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбраннаяДекадаАбсолютно - ТекущаяДекадаАбсолютно - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальнаяДекада = ТекущаяДекадаАбсолютно + 2 + Коэффициент*7;
		КонечнаяДекада  = НачальнаяДекада + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Декада = НачальнаяДекада - 7;
		Год = Цел(Декада/36);
		ДекадаВГоду = Декада - Год*36;
		МесяцВГоду = Цел(ДекадаВГоду/3) + 1;
		ДекадаВМесяце = ДекадаВГоду - (МесяцВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, (ДекадаВМесяце - 1) * 10 + 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Декада = НачальнаяДекада По КонечнаяДекада Цикл
			Год = Цел(Декада/36);
			ДекадаВГоду = Декада - Год*36;
			МесяцВГоду = Цел(ДекадаВГоду/3) + 1;
			ДекадаВМесяце = ДекадаВГоду - (МесяцВГоду-1)*3 + 1;
			Период = Дата(Год, МесяцВГоду, (ДекадаВМесяце - 1) * 10 + 1);
			Представление = Формат(Период, НСтр("ru='ДФ=''MMMM yyyy'''"))
				+ ", " + Лев("III", ДекадаВМесяце)
				+ " " + СтрокаДекада + ?(Декада = ТекущаяДекадаАбсолютно, " - " + НСтр("ru = 'эта декада'"), "");
			СписокПериодов.Добавить(Период, Представление);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Декада = КонечнаяДекада + 1;
		Год = Цел(Декада/36);
		ДекадаВГоду = Декада - Год*36;
		МесяцВГоду = Цел(ДекадаВГоду/3) + 1;
		ДекадаВМесяце = ДекадаВГоду - (МесяцВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, (ДекадаВМесяце - 1) * 10 + 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц") Тогда
		ТекущийГод   = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущийМесяц   = ТекущийГод*12   + Месяц(Сегодня);
		ВыбранныйМесяц = ВыбранныйГод*12 + Месяц(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранныйМесяц - ТекущийМесяц - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальныйМесяц = ТекущийМесяц + 2 + Коэффициент*7;
		КонечныйМесяц  = НачальныйМесяц + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Месяц = НачальныйМесяц - 7;
		Год = Цел((Месяц - 1) / 12);
		МесяцВГоду = Месяц - Год * 12;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Месяц = НачальныйМесяц По КонечныйМесяц Цикл
			Год = Цел((Месяц - 1) / 12);
			МесяцВГоду = Месяц - Год * 12;
			Период = Дата(Год, МесяцВГоду, 1);
			СписокПериодов.Добавить(Период, Формат(Период, НСтр("ru='ДФ=''MMMM yyyy'''"))
				+ ?(Год = ТекущийГод И ТекущийМесяц = Месяц, " - " + НСтр("ru = 'этот месяц'"), ""));
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Месяц = КонечныйМесяц + 1;
		Год = Цел((Месяц - 1) / 12);
		МесяцВГоду = Месяц - Год * 12;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Квартал") Тогда
		ТекущийГод = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущийКвартал   = 1 + Цел((Месяц(Сегодня)-1)/3);
		ВыбранныйКвартал = 1 + Цел((Месяц(НачалоПериода)-1)/3);
		ТекущийКварталАбсолютно   = ТекущийГод*4   + ТекущийКвартал   - 1;
		ВыбранныйКварталАбсолютно = ВыбранныйГод*4 + ВыбранныйКвартал - 1;
		СтрокаКвартал = НСтр("ru = 'квартал'");
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранныйКварталАбсолютно - ТекущийКварталАбсолютно - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальныйКвартал = ТекущийКварталАбсолютно + 2 + Коэффициент*7;
		КонечныйКвартал  = НачальныйКвартал + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Квартал = НачальныйКвартал - 7;
		Год = Цел(Квартал/4);
		КварталВГоду = Квартал - Год*4 + 1;
		МесяцВГоду = (КварталВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Квартал = НачальныйКвартал По КонечныйКвартал Цикл
			Год = Цел(Квартал/4);
			КварталВГоду = Квартал - Год*4 + 1;
			МесяцВГоду = (КварталВГоду-1)*3 + 1;
			Период = Дата(Год, МесяцВГоду, 1);
			Представление = ?(КварталВГоду = 4, "IV", Лев("III", КварталВГоду))
				+ " " + СтрокаКвартал + " " + Формат(Период, НСтр("ru='ДФ=''yyyy'''"))
				+ ?(Квартал = ТекущийКварталАбсолютно, " - " + НСтр("ru = 'этот квартал'"), "");
			СписокПериодов.Добавить(Период, Представление);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Квартал = КонечныйКвартал + 1;
		Год = Цел(Квартал/4);
		КварталВГоду = Квартал - Год*4 + 1;
		МесяцВГоду = (КварталВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Полугодие") Тогда
		ТекущийГод = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущееПолугодие   = 1 + Цел((Месяц(Сегодня)-1)/6);
		ВыбранноеПолугодие = 1 + Цел((Месяц(НачалоПериода)-1)/6);
		ТекущееПолугодиеАбсолютно   = ТекущийГод*2   + ТекущееПолугодие   - 1;
		ВыбранноеПолугодиеАбсолютно = ВыбранныйГод*2 + ВыбранноеПолугодие - 1;
		СтрокаПолугодие = НСтр("ru = 'полугодие'");
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранноеПолугодиеАбсолютно - ТекущееПолугодиеАбсолютно - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальноеПолугодие = ТекущееПолугодиеАбсолютно + 2 + Коэффициент*7;
		КонечноеПолугодие  = НачальноеПолугодие + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Полугодие = НачальноеПолугодие - 7;
		Год = Цел(Полугодие/2);
		ПолугодиеВГоду = Полугодие - Год*2 + 1;
		МесяцВГоду = (ПолугодиеВГоду-1)*6 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Полугодие = НачальноеПолугодие По КонечноеПолугодие Цикл
			Год = Цел(Полугодие/2);
			ПолугодиеВГоду = Полугодие - Год*2 + 1;
			МесяцВГоду = (ПолугодиеВГоду-1)*6 + 1;
			Период = Дата(Год, МесяцВГоду, 1);
			Представление = Лев("II", ПолугодиеВГоду) + " "
				+ СтрокаПолугодие + " " + Формат(Период, НСтр("ru='ДФ=''yyyy'''"))
				+ ?(Полугодие = ТекущееПолугодиеАбсолютно, " - " + НСтр("ru = 'это полугодие'"), "");
			СписокПериодов.Добавить(Период, Представление);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Полугодие = КонечноеПолугодие + 1;
		Год = Цел(Полугодие/2);
		ПолугодиеВГоду = Полугодие - Год*2 + 1;
		МесяцВГоду = (ПолугодиеВГоду-1)*6 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Год") Тогда
		ТекущийГод = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранныйГод - ТекущийГод - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальныйГод = ТекущийГод + 2 + Коэффициент*7;
		КонечныйГод = НачальныйГод + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		СписокПериодов.Добавить(Дата(НачальныйГод-7, 1, 1), НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Год = НачальныйГод По КонечныйГод Цикл
			СписокПериодов.Добавить(Дата(Год, 1, 1), Формат(Год, "ЧГ=")
				+ ?(Год = ТекущийГод, " - " + НСтр("ru = 'этот год'"), ""));
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		СписокПериодов.Добавить(Дата(КонечныйГод+7, 1, 1), НавигационныйПунктПозжеПредставление);
	КонецЕсли;
	
	Возврат СписокПериодов;
	
КонецФункции

#КонецОбласти

#КонецОбласти
