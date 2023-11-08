#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует описание реквизитов объекта, заполняемых по статистике их использования.
//
// Параметры:
//  ОписаниеРеквизитов - Структура - описание реквизитов, для которых необходимо получить значения по статистике
//
//
Процедура ЗадатьОписаниеЗаполняемыхРеквизитовПоСтатистике(ОписаниеРеквизитов) Экспорт
	
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьТолькоЗаполненные = "Партнер, Соглашение";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов,
		"Организация", Параметры);

	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьТолькоЗаполненные = "Партнер, Организация";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов, "Менеджер", Параметры);
	
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьВсегда = "Менеджер";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов,
		"Подразделение", Параметры);
		
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьВсегда = "Контрагент";
	Параметры.ЗаполнятьПриУсловии.ПоляОбъектаЗаполнены = "Контрагент";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов,
		"НаименованиеВходящегоДокумента", Параметры);
КонецПроцедуры

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("Взаиморасчеты");
	МеханизмыДокумента.Добавить("ПриемНаОтветхранение");
	МеханизмыДокумента.Добавить("СуммыДокументовВВалютахУчета");
	МеханизмыДокумента.Добавить("УчетНДС");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов - таблиц значений - данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений
		
		ЗаполнитьПараметрыИнициализации(Запрос, Документ);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
		СформироватьСуммыДокументаВВалютахУчета(Запрос, ТекстыЗапроса, Регистры);
		
		ТекстЗапросаТаблицаПринятаяВозвратнаяТара(Запрос, ТекстыЗапроса, Регистры);
		
		ОтразитьВУчетеНДС(Запрос, ТекстыЗапроса, Регистры);
		
		ВыкупВозвратнойТарыУПоставщикаЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
		
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		
	КонецЕсли;
	
	ДобавитьТекстыОтраженияВзаиморасчетов(Запрос, ТекстыЗапроса, Регистры);
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Выкуп возвратной тары у поставщика".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	ТаблицаЗначений, Неопределено - сформированные команды для вывода в подменю.
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьМногооборотнуюТару";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Отчеты.КарточкаРасчетовПоПринятойВозвратнойТаре.ДобавитьКомандуОтчета(КомандыОтчетов);
	
	ВзаиморасчетыСервер.КарточкаРасчетовСПоставщиком_ДобавитьКомандуОтчетаПоДокументам(КомандыОтчетов);
	ВзаиморасчетыСервер.ЗадолженностьПоставщикам_ДобавитьКомандуОтчетаПоДокументам(КомандыОтчетов);
	
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

// Функция определяет реквизиты выбранного документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документа.
//
// Возвращаемое значение:
//	Структура - реквизиты выбранного документа.
//
Функция РеквизитыДокумента(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.ПорядокРасчетов КАК ПорядокРасчетов,
	|	ДанныеДокумента.КурсЧислитель КАК Курс,
	|	ДанныеДокумента.КурсЗнаменатель КАК Кратность
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &ДокументСсылка
	|");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Дата = Выборка.Дата;
		Организация = Выборка.Организация;
		Партнер = Выборка.Партнер;
		Контрагент = Выборка.Контрагент;
		Договор = Выборка.Договор;
		НаправлениеДеятельности = Выборка.НаправлениеДеятельности;
		ПорядокРасчетов = Выборка.ПорядокРасчетов;
		Валюта = Выборка.Валюта;
		ВалютаВзаиморасчетов = Выборка.ВалютаВзаиморасчетов;
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
		СуммаДокумента = Выборка.СуммаДокумента;
		СуммаВзаиморасчетов = ?(Выборка.Проведен, Выборка.СуммаВзаиморасчетов, 0);
		Кратность = Выборка.Кратность;
		Курс = Выборка.Курс;
	Иначе
		Дата = Дата(1,1,1);
		Организация = Справочники.Организации.ПустаяСсылка();
		Партнер = Справочники.Партнеры.ПустаяСсылка();
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		НаправлениеДеятельности = Справочники.НаправленияДеятельности.ПустаяСсылка();
		ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПустаяСсылка();
		Валюта = Справочники.Валюты.ПустаяСсылка();
		ВалютаВзаиморасчетов = Справочники.Валюты.ПустаяСсылка();
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
		СуммаДокумента = 0;
		СуммаВзаиморасчетов = 0;
		Кратность = 1;
		Курс = 1;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Дата", Дата);
	СтруктураРеквизитов.Вставить("Организация", Организация);
	СтруктураРеквизитов.Вставить("Партнер", Партнер);
	СтруктураРеквизитов.Вставить("Контрагент", Контрагент);
	СтруктураРеквизитов.Вставить("Договор", Договор);
	СтруктураРеквизитов.Вставить("ПорядокРасчетов", ПорядокРасчетов);
	СтруктураРеквизитов.Вставить("Валюта", Валюта);
	СтруктураРеквизитов.Вставить("ВалютаВзаиморасчетов", ВалютаВзаиморасчетов);
	СтруктураРеквизитов.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
	СтруктураРеквизитов.Вставить("СуммаДокумента", СуммаДокумента);
	СтруктураРеквизитов.Вставить("СуммаВзаиморасчетов", СуммаВзаиморасчетов);
	СтруктураРеквизитов.Вставить("Курс", Курс);
	СтруктураРеквизитов.Вставить("Кратность", Кратность);
	СтруктураРеквизитов.Вставить("НаправлениеДеятельности", НаправлениеДеятельности);
	
	Возврат СтруктураРеквизитов;

КонецФункции

// Возвращает структуру параметров для заполнения налогообложения НДС закупки.
//
// Параметры:
//  Объект - ДокументОбъект.ВыкупВозвратнойТарыУПоставщика - документ, по которому необходимо сформировать параметры.
//
// Возвращаемое значение:
//  См. УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСЗакупки
//
Функция ПараметрыЗаполненияНалогообложенияНДСЗакупки(Объект) Экспорт

	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСЗакупки();
	
	ПараметрыЗаполнения.Контрагент = Объект.Контрагент;
	ПараметрыЗаполнения.Договор = Объект.Договор;

	ПараметрыЗаполнения.ВыкупВозвратнойТарыУПоставщика = Истина;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Возвращает параметры механизма взаиморасчетов.
//
// Параметры:
// 	ДанныеЗаполнения - ДокументОбъект, СправочникОбъект, ДокументСсылка, СправочникСсылка, Структура, ДанныеФормыСтруктура - Объект или коллекция для
//              расчета параметров взаиморасчетов.
//
// Возвращаемое значение:
// 	См. ВзаиморасчетыСервер.ПараметрыМеханизма
//
Функция ПараметрыВзаиморасчеты(ДанныеЗаполнения = Неопределено) Экспорт
	
	Если ОбщегоНазначения.ЗначениеСсылочногоТипа(ДанныеЗаполнения) Тогда
		СтруктураДанныеЗаполнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДанныеЗаполнения, 
			"ПредусмотренЗалогЗаТару");
		ПредусмотренЗалогЗаТару = СтруктураДанныеЗаполнения.ПредусмотренЗалогЗаТару;
	ИначеЕсли ДанныеЗаполнения = Неопределено Тогда
		ПредусмотренЗалогЗаТару = Ложь;
	Иначе
		ПредусмотренЗалогЗаТару = ДанныеЗаполнения.ПредусмотренЗалогЗаТару;
	КонецЕсли;
	
	СтруктураПараметров = ВзаиморасчетыСервер.ПараметрыМеханизма();
	СтруктураПараметров.ЭтоПродажаЗакупка                    = Истина;
	СтруктураПараметров.ТипРасчетов                          = Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком;
	СтруктураПараметров.ИзменяетРасчетыСтрокой               = "НЕ ИсточникДанных.ПредусмотренЗалогЗаТару";
	СтруктураПараметров.ИзменяетПланОплаты                   = НЕ ПредусмотренЗалогЗаТару;
	СтруктураПараметров.ИзменяетПланОтгрузкиПоставки         = НЕ ПредусмотренЗалогЗаТару;
	
	СтруктураПараметров.ВалютаВзаиморасчетов                 = "Объект.ВалютаВзаиморасчетов";
	СтруктураПараметров.СуммаВзаиморасчетов                  = "Объект.СуммаВзаиморасчетов";
	СтруктураПараметров.СуммаВзаиморасчетовПоТаре            = ""; 
	
	СтруктураПараметров.ДатаПлатежа                          = "Объект.ДатаПлатежа";
	СтруктураПараметров.БанковскийСчетОрганизации            = "";
	СтруктураПараметров.БанковскийСчетКонтрагента            = ""; 
	СтруктураПараметров.КурсЧислитель                        = "Объект.КурсЧислитель";
	СтруктураПараметров.КурсЗнаменатель                      = "Объект.КурсЗнаменатель";
	
	СтруктураПараметров.ПутьКДаннымТЧ                        = "Объект.Товары";
	
	СтруктураПараметров.ИмяРеквизитаТЧЗаказ                  = "";
	СтруктураПараметров.ПутьКДаннымТЧРасшифровкаПлатежа      = "Объект.РасшифровкаПлатежа";
	
	СтруктураПараметров.Касса                                = "";
	СтруктураПараметров.ИдентификаторПлатежа                 = "";
	СтруктураПараметров.Менеджер                             = "Объект.Менеджер";
	СтруктураПараметров.НомерВходящегоДокумента              = "Объект.НомерВходящегоДокумента";
	СтруктураПараметров.ДатаВходящегоДокумента               = "Объект.ДатаВходящегоДокумента";
	СтруктураПараметров.НаименованиеПервичногоДокумента  = "Объект.НаименованиеВходящегоДокумента";
	СтруктураПараметров.НакладнаяПоЗаказам                   = "";
	СтруктураПараметров.ЗаказОснование                       = "";
	
	СтруктураПараметров.ЭлементыФормы.НадписьВалюты          = "ДекорацияВалюты";
	СтруктураПараметров.ЭлементыФормы.НадписьЭтапы           = "ДекорацияЭтапыОплаты";
	СтруктураПараметров.ЭлементыФормы.НадписьРасчеты         = "ДекорацияСостояниеРасчетов";
	СтруктураПараметров.ЭлементыФормы.ЗачетОплаты            = "ЗачетОплатыФорма";
	СтруктураПараметров.ЭлементыФормы.СуммаВзаиморасчетовТЧ  = "ТоварыСуммаВзаиморасчетов";
	СтруктураПараметров.ЭлементыФормы.ГруппаФинансовогоУчета  = "ГруппаФинансовогоУчета";
	СтруктураПараметров.ЭлементыФормы.НаправлениеДеятельности = "НаправлениеДеятельности";
	
	СтруктураПараметров.ЭтапыОплатыТолькоПросмотр            = ПредусмотренЗалогЗаТару;
	
	СтруктураПараметров.ПутьКДаннымТЧЭтапыОплаты             = "";
	СтруктураПараметров.НадписьЭтапыОплаты                   = "Форма.НадписьЭтапыОплаты";
	СтруктураПараметров.СуммаДокументаФорма                  = "";
	СтруктураПараметров.СуммаЗалогаЗаТаруФорма               = "";
	СтруктураПараметров.ВозможнаНакладнаяПоНесколькимЗаказам = Ложь;
	СтруктураПараметров.ОбъектРасчетов                       = "Объект.ОбъектРасчетов";
	
	Возврат СтруктураПараметров;
	
КонецФункции


#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Партнер)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область УчетНДС

// Инициализирует параметры регистрации счетов-фактур (полученных)
//
// Параметры:
//  Объект		- ДокументОбъект.ВыкупВозвратнойТарыУПоставщика, ДанныеФормыСтруктура	- документ, для которого необходимо получить параметры.
//
// Возвращаемое значение:
//  См. УчетНДСУПКлиентСервер.ПараметрыРегистрацииСчетовФактурПолученных
//
Функция ПараметрыРегистрацииСчетовФактурПолученных(Объект) Экспорт
	
	ПараметрыРегистрации = УчетНДСУПКлиентСервер.ПараметрыРегистрацииСчетовФактурПолученных();
	
	ПараметрыРегистрации.Ссылка				= Объект.Ссылка;
	ПараметрыРегистрации.Дата				= Объект.Дата;
	ПараметрыРегистрации.Организация		= Объект.Организация;
	ПараметрыРегистрации.Контрагент			= Объект.Контрагент;
	ПараметрыРегистрации.НалогообложениеНДС	= Объект.НалогообложениеНДС;
			
	ПараметрыРегистрации.ПриобретениеТоваровРаботУслуг  = Истина;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти

// Возвращает массив допустимых наименований входящих документов.
// 
// Возвращаемое значение:
// 	Массив - массив наименований.
Функция НаименованияВходящихДокументов() Экспорт
	МассивНаименований = Новый Массив();
	МассивНаименований.Добавить(НСтр("ru='Выкуп возвратной тары'"));
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ДополнитьНаименованияВходящихДокументов(МассивНаименований);
	Возврат МассивНаименований
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТКлиентСервер.ОбработкаПолученияПредставленияВходящегоДокумента(
		Данные, Представление, СтандартнаяОбработка, "ВыкупВозвратнойТарыУПоставщика");
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Очистить();
	Поля.Добавить("НаименованиеВходящегоДокумента");
	Поля.Добавить("НомерВходящегоДокумента");
	Поля.Добавить("ДатаВходящегоДокумента");
	Поля.Добавить("Дата");
	Поля.Добавить("Номер");
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Организация.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.ПредусмотренЗалогЗаТару КАК ПредусмотренЗалогЗаТару,
	|	ДанныеДокумента.ДатаПлатежа КАК ДатаПлатежа,
	|	ДанныеДокумента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ДанныеДокумента.ФормаОплаты КАК ФормаОплаты,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Менеджер КАК Менеджер,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
	|	ДанныеДокумента.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	|	ДанныеДокумента.ОбъектРасчетов.УникальныйИдентификатор КАК ИдентификаторОбъектаРасчетов
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                                        Реквизиты.Период);
	Запрос.УстановитьПараметр("Номер",                                         Реквизиты.Номер);
	Запрос.УстановитьПараметр("Партнер",                                       Реквизиты.Партнер);
	Запрос.УстановитьПараметр("Организация",                                   Реквизиты.Организация);
	Запрос.УстановитьПараметр("Валюта",                                        Реквизиты.Валюта);
	Запрос.УстановитьПараметр("ПредусмотренЗалогЗаТару",                       Реквизиты.ПредусмотренЗалогЗаТару);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета",                Реквизиты.ВалютаРегламентированногоУчета);
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",                    Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ДатаПлатежа",                                   Реквизиты.ДатаПлатежа);
	Запрос.УстановитьПараметр("ФормаОплаты",                                   Реквизиты.ФормаОплаты);
	Запрос.УстановитьПараметр("ВалютаВзаиморасчетов",                          Реквизиты.ВалютаВзаиморасчетов);
	Запрос.УстановитьПараметр("Договор",                                       Реквизиты.Договор);
	Запрос.УстановитьПараметр("ИдентификаторОбъектаРасчетов",                  Реквизиты.ИдентификаторОбъектаРасчетов);
	Запрос.УстановитьПараметр("ИдентификаторНеиспользуемойФинЗаписи",          ПроведениеДокументов.ИдентификаторНеиспользуемойФинЗаписи());
	
	Запрос.УстановитьПараметр("ИдентификаторМетаданных",                       ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(ДокументСсылка)));
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",                         Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика);
	Запрос.УстановитьПараметр("Контрагент",                                    Реквизиты.Контрагент);
	Запрос.УстановитьПараметр("НаправлениеДеятельности",                       Реквизиты.НаправлениеДеятельности);
	Запрос.УстановитьПараметр("Подразделение",                                 Реквизиты.Подразделение);
	Запрос.УстановитьПараметр("Менеджер",                                      Реквизиты.Менеджер);
	Запрос.УстановитьПараметр("Комментарий",                                   Реквизиты.Комментарий);
	Запрос.УстановитьПараметр("СуммаДокумента",                                Реквизиты.СуммаДокумента);
	Запрос.УстановитьПараметр("Проведен",                                      Реквизиты.Проведен);
	Запрос.УстановитьПараметр("ПометкаУдаления",                               Реквизиты.ПометкаУдаления);
	Запрос.УстановитьПараметр("НомерВходящегоДокумента",                       Реквизиты.НомерВходящегоДокумента);
	Запрос.УстановитьПараметр("ДатаВходящегоДокумента",                        Реквизиты.ДатаВходящегоДокумента);
	ИнформацияПоДоговору = Неопределено;
	Если ЗначениеЗаполнено(Реквизиты.Договор) Тогда
		ИнформацияПоДоговору = НСтр("ru = 'По договору ""%Договор%""'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ИнформацияПоДоговору = СтрЗаменить(ИнформацияПоДоговору, "%Договор%", Реквизиты.Договор);
	КонецЕсли;
	Запрос.УстановитьПараметр("ИнформацияПоДоговору", ИнформацияПоДоговору);
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаПринятаяВозвратнаяТара(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПринятаяВозвратнаяТара";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки              КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	ТаблицаТовары.Количество               КАК Количество,
	|	ТаблицаТовары.СуммаСНДС                КАК Сумма,
	|	&Партнер                               КАК Партнер,
	|	ТаблицаТовары.ДокументПоступления      КАК ДокументПоступления,
	|	ИСТИНА                                 КАК Выкуп,
	|	&ПредусмотренЗалогЗаТару               КАК ПредусмотренЗалог,
	|
	|	ВЫБОР
	|		КОГДА &ПредусмотренЗалогЗаТару
	|			ТОГДА &ИдентификаторНеиспользуемойФинЗаписи
	|		ИНАЧЕ &ИдентификаторОбъектаРасчетов
	|	КОНЕЦ                                  КАК ИдентификаторФинЗаписи,
	|	ВЫБОР
	|		КОГДА &ПредусмотренЗалогЗаТару
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.ПокупкаПолученнойВозвратнойТары)
	|	КОНЕЦ                                  КАК НастройкаХозяйственнойОперации
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура СформироватьСуммыДокументаВВалютахУчета(Запрос, ТекстыЗапроса, Регистры = Неопределено) Экспорт
	
	ТекстЗапросаДанных = "
	|ВЫБРАТЬ
	|	""Товары"" КАК ИсточникДанных,
	|	ИСТИНА КАК РаспределятьОбщуюСумму,
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Ссылка.Дата КАК Дата,
	|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
	|	ТаблицаДокумента.Ссылка.Валюта КАК ВалютаДокумента,
	|	ТаблицаДокумента.Ссылка.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ТаблицаДокумента.Ссылка.Дата КАК ПериодБазыНДС,
	|	ТаблицаДокумента.Ссылка.Дата КАК ДатаКурса,
	|
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаДокумента.СуммаСНДС - ТаблицаДокумента.СуммаНДС КАК СуммаБезНДС,
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаДокумента.СуммаНДС КАК СуммаНДС,
	|	ТаблицаДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	ТаблицаДокумента.СуммаНДСВзаиморасчетов КАК СуммаНДСВзаиморасчетов,
	|	
	|	ИСТИНА КАК ОтражаетсяВРасчетах,
	|	ТаблицаДокумента.Ссылка.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ИСТИНА КАК ПересчитыватьПоДаннымРасчетов
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В (&Ссылка)
	|";
	
	РегистрыСведений.СуммыДокументовВВалютахУчета.СформироватьПоДаннымДокумента(
		Запрос, ТекстыЗапроса, Регистры, ТекстЗапросаДанных);
	
КонецПроцедуры

Процедура УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос)
	
	Если Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуУпр")
		И Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуРегл") Тогда
		Возврат;
	КонецЕсли;
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(
		Запрос.Параметры.Валюта, 
		Запрос.Параметры.ВалютаВзаиморасчетов,
		Запрос.Параметры.Период,
		Запрос.Параметры.Организация);
	
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр",           Коэффициенты.КоэффициентПересчетаВВалютуУПР);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл",          Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	
КонецПроцедуры

Процедура ОтразитьВУчетеНДС(Запрос, ТекстыЗапроса, Регистры)
	
	Если ТипЗнч(Регистры) = Тип("Структура") И Регистры.Свойство("НДСПредъявленный") Тогда
		Регистры.Удалить("НДСПредъявленный");
	КонецЕсли;
	
	Если Не УчетНДСУП.ТребуетсяПроведениеПоРегистрамНДС(Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЦенности =
	"ВЫБРАТЬ
	|	Товары.Ссылка.Дата КАК Период,
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Ссылка.Организация КАК Организация,
	|	Товары.Ссылка.Подразделение КАК Подразделение,
	|	Товары.Ссылка.Контрагент КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК Грузоотправитель,
	|	Товары.Ссылка КАК ДокументПриобретения,
	|	Товары.Ссылка КАК ИсходныйТорговыйДокумент,
	|	ЛОЖЬ КАК ИсправлениеОшибок,
	|	ЛОЖЬ КАК КорректировкаПоСогласованиюСторон,
	|	НЕОПРЕДЕЛЕНО КАК ДокументКорректировкиПриобретения,
	|	Товары.Ссылка.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС) КАК ВидДеятельностиНДС,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	Товары.Номенклатура КАК Номенклатура,
	|	НЕОПРЕДЕЛЕНО КАК ВидЗапасов,
	|	НЕОПРЕДЕЛЕНО КАК НомерГТД,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеУчета,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО КАК СписатьНаРасходы,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяПрочихАктивов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаПрочихАктивов,
	|	НЕОПРЕДЕЛЕНО КАК Назначение,
	|	Товары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	Товары.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.ВходящийНДСПоПриобретению) КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В (&Ссылка)
	|";
	УчетНДСУП.ОтразитьПриобретениеУПоставщика(Запрос, ТекстыЗапроса, Регистры, ТекстЦенности);
	
КонецПроцедуры

Процедура ДобавитьТекстыОтраженияВзаиморасчетов(Запрос, ТекстыЗапроса, Регистры)
	
	#Область Закупка
	
	ТекстЗакупка = "
		|ВЫБРАТЬ
		|	Таблица.Ссылка                                                      КАК Ссылка,
		|	Таблица.Ссылка.Организация                                          КАК Организация,
		|	Таблица.Ссылка.Партнер                                              КАК Партнер,
		|	Таблица.Ссылка.Дата                                                 КАК ДатаРегистратора,
		|	Таблица.Ссылка.Номер                                                КАК НомерРегистратора,
		|
		|	Таблица.Ссылка.ОбъектРасчетов                                       КАК ОбъектРасчетов,
		|	Таблица.Ссылка.ДатаПлатежа                                          КАК ДатаПлатежа,
		|	НЕОПРЕДЕЛЕНО                                                        КАК ВариантОплаты,
		|	Неопределено                                                        КАК ЗаказЗакупки,
		|	
		|	Таблица.СуммаСНДС                                                   КАК Сумма,
		|	Таблица.СуммаВзаиморасчетов                                         КАК СуммаВзаиморасчетов,
		|	0                                                                   КАК СуммаВзаиморасчетовПоТаре,
		|
		|	Таблица.Ссылка.ПорядокРасчетов                                      КАК ПорядокРасчетов,
		|	ЛОЖЬ                                                                КАК НакладнаяПоЗаказам,
		|	Таблица.Ссылка.ВалютаВзаиморасчетов                                 КАК ВалютаВзаиморасчетов,
		|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика)     КАК ХозяйственнаяОперация,
		|	Таблица.Ссылка.ФормаОплаты                                          КАК ФормаОплаты,
		|	Таблица.Ссылка.Валюта                                               КАК ВалютаДокумента,
		|	Таблица.Ссылка.Дата                                                 КАК ДатаКурса,
		|	Неопределено                                                        КАК СвязанныйДокумент
		|ИЗ
		|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка В (&Ссылка)
		|	И НЕ Таблица.Ссылка.ПредусмотренЗалогЗаТару
		|";
	
	#КонецОбласти
	
	#Область УвеличениеПланаОплаты
	
	ТекстПланОплаты = "
		|ВЫБРАТЬ
		|	Таблица.Ссылка                                                      КАК Ссылка,
		|	Таблица.Ссылка.Дата                                                 КАК ДатаРегистратора,
		|	Таблица.Ссылка.Номер                                                КАК НомерРегистратора,
		|	Таблица.Ссылка.ДатаПлатежа                    						КАК ДатаПлатежа,
		|	Таблица.Ссылка.Партнер                                              КАК Партнер,
		|	
		|	Таблица.Ссылка.ОбъектРасчетов                                       КАК ОбъектРасчетов,
		|	
		|	Таблица.Ссылка.ПорядокРасчетов                                      КАК ПорядокРасчетов,
		|	ЛОЖЬ                                                                КАК НакладнаяПоЗаказам,
		|	ЛОЖЬ                                                                КАК СверхЗаказа,
		|	Неопределено                                                        КАК ЗаказЗакупки,
		|	Таблица.СуммаВзаиморасчетов                                         КАК КОплате,
		|	Таблица.Ссылка.ВалютаВзаиморасчетов                                 КАК ВалютаВзаиморасчетов,
		|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика)     КАК ХозяйственнаяОперация,
		|	Таблица.Ссылка.ФормаОплаты                                          КАК ФормаОплаты,
		|	Таблица.Ссылка.Валюта                                               КАК ВалютаДокумента,
		|	Неопределено                                                        КАК ВариантОплаты,
		|	Неопределено                                                        КАК СвязанныйДокумент
		|ИЗ
		|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка В (&Ссылка)
		|	И НЕ Таблица.Ссылка.ПредусмотренЗалогЗаТару
		|";

	#КонецОбласти
	
	#Область ЗачетАвансов
	
	ТекстЗачетАванса = "
		|ВЫБРАТЬ
		|	Таблица.Ссылка                                                     КАК Ссылка,
		|	Таблица.Ссылка.Организация                                         КАК Организация,
		|	Таблица.Ссылка.Партнер                                             КАК Партнер,
		|	
		|	Таблица.ОбъектРасчетов                                             КАК ОбъектРасчетовИсточник,
		|	Таблица.Ссылка.ОбъектРасчетов                                      КАК ОбъектРасчетовПриемник,
		|
		|	Таблица.Ссылка.ВалютаВзаиморасчетов                                КАК ВалютаВзаиморасчетов,
		|	Таблица.СуммаВзаиморасчетов                                        КАК СуммаВзаиморасчетов,
		|	Таблица.Ссылка.Валюта                                              КАК ВалютаДокумента,
		|	Таблица.Сумма                                                      КАК Сумма,
		|
		|	Таблица.Ссылка.Дата                                                КАК ДатаКурса,
		|	Таблица.Ссылка.Дата                                                КАК ДатаРегистратора,
		|	Таблица.Ссылка.Дата                                                КАК ДатаКурса,
		|	Таблица.Ссылка.Номер                                               КАК НомерРегистратора,
		|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПереносАванса)         КАК ХозяйственнаяОперация
		|	
		|ИЗ
		|	Документ.ВыкупВозвратнойТарыУПоставщика.РасшифровкаПлатежа КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка В (&Ссылка)
		|	И НЕ Таблица.Ссылка.ПредусмотренЗалогЗаТару
		|";
	
	#КонецОбласти
	
	ВзаиморасчетыСервер.ПроведениеЗакупки(Запрос, ТекстыЗапроса, Регистры, ТекстЗакупка, ТекстПланОплаты, ТекстЗачетАванса);
	
КонецПроцедуры

#Область Проведение

#КонецОбласти

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос();
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента      = "Документ.ВыкупВозвратнойТарыУПоставщика";
	СинонимТаблицыДокумента = "";
	ВЗапросеЕстьИсточник    = Истина;
	
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ИдентификаторМетаданных",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяДокумента));
	ЗначенияПараметров.Вставить("ХозяйственнаяОперация",
		Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика);
	
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("ИнформацияПоДоговору", """""");
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		ВЗапросеЕстьИсточник = Ложь;
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
			ТекстЗапроса,
			ПолноеИмяДокумента,
			СинонимТаблицыДокумента,
			ВЗапросеЕстьИсточник,
			ПереопределениеРасчетаПараметров);
		
	Иначе
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
			ТекстЗапроса,
			ПолноеИмяДокумента,
			СинонимТаблицыДокумента,
			ПереопределениеРасчетаПараметров);
		
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Номер                                  КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Организация                            КАК Организация,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Партнер                                КАК Партнер,
	|	&Контрагент                             КАК Контрагент,
	|	&Договор                                КАК Договор,
	|	&НаправлениеДеятельности                КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                            КАК МестоХранения,
	|	&Подразделение                          КАК Подразделение,
	|	&Менеджер                               КАК Ответственный,
	|	&Комментарий                            КАК Комментарий,
	|	&Валюта                                 КАК Валюта,
	|	&СуммаДокумента                         КАК Сумма,
	|	НЕОПРЕДЕЛЕНО                            КАК Статус,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	&ИнформацияПоДоговору                   КАК Дополнительно,
	|	&ДатаВходящегоДокумента                 КАК ДатаПервичногоДокумента,
	|	ЛОЖЬ                                    КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО                            КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО                            КАК ИсправляемыйДокумент,
	|	&НомерВходящегоДокумента                КАК НомерПервичногоДокумента,
	|	НЕОПРЕДЕЛЕНО                            КАК Приоритет";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли
