#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	ОбщегоНазначенияУТ.СвернутьНаборЗаписей(ЭтотОбъект, Истина);
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяКонтроль = Истина;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если (Запись.ВидДвижения = ВидДвиженияНакопления.Расход И Запись.ВНаличии <> 0)
		 Или (Запись.ВидДвижения = ВидДвиженияНакопления.Приход И Запись.КОтбору <> 0) Тогда
			ТребуетсяКонтроль = Запись.Ячейка.Владелец.КонтролироватьОперативныеОстатки;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ТребуетсяКонтроль Тогда
		ДополнительныеСвойства.РассчитыватьИзменения = Ложь;
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу "ДвиженияТоварыВЯчейкахЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.СвойстваДокумента.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Назначение КАК Назначение,
	|	Таблица.Серия КАК Серия,
	|	Таблица.Упаковка КАК Упаковка,
	|	Таблица.Ячейка КАК Ячейка,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.ВНаличии
	|		ИНАЧЕ -Таблица.ВНаличии
	|	КОНЕЦ КАК ВНаличииПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.КОтбору
	|		ИНАЧЕ -Таблица.КОтбору
	|	КОНЕЦ КАК КОтборуПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.КРазмещению
	|		ИНАЧЕ -Таблица.КРазмещению
	|	КОНЕЦ КАК КРазмещениюПередЗаписью
	|ПОМЕСТИТЬ ДвиженияТоварыВЯчейкахПередЗаписью
	|ИЗ
	|	РегистрНакопления.ТоварыВЯчейках КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И (НЕ &ЭтоНовый)
	|	И (Таблица.Ячейка.ТипСкладскойЯчейки = ЗНАЧЕНИЕ(Перечисление.ТипыСкладскихЯчеек.Хранение)
	|			ИЛИ Таблица.Ячейка.ТипСкладскойЯчейки = ЗНАЧЕНИЕ(Перечисление.ТипыСкладскихЯчеек.Приемка)
	|			ИЛИ Таблица.Ячейка.ТипСкладскойЯчейки = ЗНАЧЕНИЕ(Перечисление.ТипыСкладскихЯчеек.Отгрузка))";
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Номенклатура КАК Номенклатура,
	|	ТаблицаИзменений.Характеристика КАК Характеристика,
	|	ТаблицаИзменений.Назначение КАК Назначение,
	|	ТаблицаИзменений.Серия КАК Серия,
	|	ТаблицаИзменений.Упаковка КАК Упаковка,
	|	ТаблицаИзменений.Ячейка КАК Ячейка,
	|	СУММА(ТаблицаИзменений.ВНаличииИзменение) КАК ВНаличииИзменение,
	|	СУММА(ТаблицаИзменений.КОтборуИзменение) КАК КОтборуИзменение,
	|	СУММА(ТаблицаИзменений.КРазмещениюИзменение) КАК КРазмещениюИзменение
	|ПОМЕСТИТЬ ДвиженияТоварыВЯчейкахИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Номенклатура КАК Номенклатура,
	|		Таблица.Характеристика КАК Характеристика,
	|		Таблица.Назначение КАК Назначение,
	|		Таблица.Серия КАК Серия,
	|		Таблица.Упаковка КАК Упаковка,
	|		Таблица.Ячейка КАК Ячейка,
	|		Таблица.ВНаличииПередЗаписью КАК ВНаличииИзменение,
	|		Таблица.КОтборуПередЗаписью КАК КОтборуИзменение,
	|		Таблица.КРазмещениюПередЗаписью КАК КРазмещениюИзменение
	|	ИЗ
	|		ДвиженияТоварыВЯчейкахПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Номенклатура,
	|		Таблица.Характеристика,
	|		Таблица.Назначение,
	|		Таблица.Серия,
	|		Таблица.Упаковка,
	|		Таблица.Ячейка,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.ВНаличии
	|			ИНАЧЕ Таблица.ВНаличии
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.КОтбору
	|			ИНАЧЕ Таблица.КОтбору
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.КРазмещению
	|			ИНАЧЕ Таблица.КРазмещению
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ТоварыВЯчейках КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор
	|	 	И (Таблица.Ячейка.ТипСкладскойЯчейки = ЗНАЧЕНИЕ(Перечисление.ТипыСкладскихЯчеек.Хранение)
	|			ИЛИ Таблица.Ячейка.ТипСкладскойЯчейки = ЗНАЧЕНИЕ(Перечисление.ТипыСкладскихЯчеек.Приемка)
	|			ИЛИ Таблица.Ячейка.ТипСкладскойЯчейки = ЗНАЧЕНИЕ(Перечисление.ТипыСкладскихЯчеек.Отгрузка))) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.Упаковка,
	|	ТаблицаИзменений.Характеристика,
	|	ТаблицаИзменений.Назначение,
	|	ТаблицаИзменений.Серия,
	|	ТаблицаИзменений.Ячейка
	|
	|ИМЕЮЩИЕ
	// По ВНаличии к не правильному состоянию регистра приведет уменьшение прихода и увеличение расхода.
	|	(СУММА(ТаблицаИзменений.ВНаличииИзменение) > 0
	// По КОтбору к не правильному состоянию регистра приведет увеличение прихода и уменьшение расхода.
	|		ИЛИ СУММА(ТаблицаИзменений.КОтборуИзменение) < 0
	// По КРазмещению требуется проверка, что в область обособленного хранения размещаются только обособленные товары по
	// одному назначению.
	|		ИЛИ СУММА(ТаблицаИзменений.КРазмещениюИзменение) < 0)
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияТоварыВЯчейкахПередЗаписью";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет()[0]; // РезультатЗапроса
	Выборка = РезультатЗапроса.Выбрать();
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
		"ДвиженияТоварыВЯчейкахИзменение", Выборка.Следующий() И Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли