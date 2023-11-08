#Область ПрограммныйИнтерфейс

// Выделение штрихкода упаковки серии. Временный обработчик.
// 
// Параметры:
//  Источник - РегистрНакопленияНаборЗаписей.ДвиженияСерийТоваров - записываемый набор записей
//  Отказ - Булево - Отказ
//  Замещение - Булево - Замещение
Процедура ВыделениеШтрихкодаУпаковкиСерии(Источник, Отказ, Замещение) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркировкиПродукцииВГИСМ")
			И Не ИнтеграцияГИСМ.ПодсистемаНеИспользуется()
			И Не Отказ Тогда
		УстановитьПривилегированныйРежим(Истина);
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Источник.ВыгрузитьКолонку("Серия"));
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Серии.Ссылка КАК Серия,
		|	Серии.НомерКизГИСМ КАК Штрихкод
		|ИЗ
		|Справочник.СерииНоменклатуры КАК Серии
		|ГДЕ
		|	Серии.Ссылка В (&Ссылка)
		|	И Серии.НомерКизГИСМ <> """"
		|	И НЕ Серии.Ссылка В (ВЫБРАТЬ Серия ИЗ Справочник.ШтрихкодыУпаковокТоваров ГДЕ Серия в (&Ссылка))";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() Тогда
			КэшСтатусовУказанияСерий = Новый Соответствие;
			ДанныеШтрихкода = Новый Структура;
			ДанныеШтрихкода.Вставить("Номенклатура");
			ДанныеШтрихкода.Вставить("Характеристика");
			ДанныеШтрихкода.Вставить("Серия");
			ДанныеШтрихкода.Вставить("Штрихкод");
			ДанныеШтрихкода.Вставить("ВидПродукции", Перечисления.ВидыПродукцииИС.ПродукцияИзНатуральногоМеха);
			ДанныеШтрихкода.Вставить("ТипУпаковки", Перечисления.ТипыУпаковок.МаркированныйТовар);
			ДанныеШтрихкода.Вставить("Количество", 1);
			Таблица = Источник.Выгрузить(,"Номенклатура,Характеристика,Серия");
			Таблица.Индексы.Добавить("Серия");
			Попытка
				Пока Выборка.Следующий() Цикл
					ДанныеШтрихкода.Штрихкод = Выборка.Штрихкод;
					СтрокаИсточника = Таблица.Найти(Выборка.Серия);
					ЗаполнитьЗначенияСвойств(ДанныеШтрихкода, СтрокаИсточника);
					Справочники.ШтрихкодыУпаковокТоваров.СоздатьШтрихкодУпаковки(ДанныеШтрихкода,,, КэшСтатусовУказанияСерий);
				КонецЦикла;
			Исключение
				ТекстСообщения = НСтр("ru='Не удалось создать штрихкод упаковки по номеру КИЗ ГИСМ.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Регистрация данных RFID. Временный обработчик.
// 
// Параметры:
//  Источник - СправочникОбъект.СерииНоменклатуры - записываемая серия
//  Отказ - Булево - Отказ
Процедура РегистрацияДанныхRFID (Источник, Отказ) Экспорт
	
	Если ЗначениеЗаполнено(Источник.RFIDTID)
			И ЗначениеЗаполнено(Источник.НомерКиЗГИСМ)
			И ПолучитьФункциональнуюОпцию("ВестиУчетМаркировкиПродукцииВГИСМ")
			И Не ИнтеграцияГИСМ.ПодсистемаНеИспользуется()
			И Не Отказ Тогда
		Элемент = РегистрыСведений.ДанныеRFIDИСМП.НовыйЭлементЗаписиДанных();
		ЗаполнитьЗначенияСвойств(Элемент, Источник);
		Записи = Новый Массив;
		Записи.Добавить(Элемент);
		УстановитьПривилегированныйРежим(Истина);
		Попытка
			РегистрыСведений.ДанныеRFIDИСМП.ЗаписатьДанные(Записи);
		Исключение
			ТекстСообщения = НСтр("ru='Не удалось записать данные RFID в регистр ""Данные RFID ИС МП"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область СерииНоменклатуры

Функция ПараметрыУказанияСерийМаркировкаТоваровГИСМ(Объект) Экспорт
	
	ПараметрыУказанияСерий = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	ПараметрыСерийСклада = СкладыСервер.ИспользованиеСерийНаСкладе(Объект.Склад, Ложь);
	
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.МаркировкаТоваровГИСМ";
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
	ПараметрыУказанияСерий.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.МаркировкаПродукцииДляГИСМ);
	
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("GTIN");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("НоменклатураКиЗ");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("ХарактеристикаКиЗ");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("КодТаможенногоОргана");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("ДатаРегистрацииДекларации");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("РегистрационныйНомерДекларации");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("НомерТовараВДекларации");
	
	ПараметрыУказанияСерий.ОперацияДокумента = Объект.ОперацияМаркировки;
	
	ПараметрыУказанияСерий.ЭтоНакладная = Истина;
	ПараметрыУказанияСерий.ТолькоПросмотр = Ложь;
	ПараметрыУказанияСерий.Дата = Объект.Дата;
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

Функция ПараметрыУказанияСерийПеремаркировкаТоваровГИСМ(Объект) Экспорт
	
	ПараметрыУказанияСерий = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	ПараметрыСерийСклада = СкладыСервер.ИспользованиеСерийНаСкладе(Объект.Склад, Ложь);
	
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ПеремаркировкаТоваровГИСМ";
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
	ПараметрыУказанияСерий.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.МаркировкаПродукцииДляГИСМ);
	
	ПараметрыУказанияСерий.ИмяТЧСерии = "Товары";
	
	ПараметрыУказанияСерий.ЭтоНакладная = Истина;
	ПараметрыУказанияСерий.ТолькоПросмотр = Ложь;
	ПараметрыУказанияСерий.Дата = Объект.Дата;
	
	ПараметрыУказанияСерий.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерий");
	ПараметрыУказанияСерий.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийСписываемаяСерия");
	
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("GTIN");
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("НоменклатураКиЗ");
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("ХарактеристикаКиЗ");
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("СписываемаяСерия");
	
	ПараметрыУказанияСерий.ОсобеннаяПроверкаСтатусовУказанияСерий = Истина;
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

Функция ТекстЗапросаЗаполненияСтатусовУказанияСерийМаркировкаТоваровГИСМ(ПараметрыУказанияСерий) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.GTIN,
	|	Товары.НоменклатураКиЗ,
	|	Товары.ХарактеристикаКиЗ,
	|	Товары.Количество,
	|	Товары.СтатусУказанияСерий,
	|	Товары.НомерСтроки
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.НоменклатураКиЗ,
	|	Товары.ХарактеристикаКиЗ,
	|	Товары.GTIN,
	|	СУММА(Товары.Количество) КАК Количество,
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры КАК ВидНоменклатуры
	|ПОМЕСТИТЬ ТоварыДляЗапроса
	|ИЗ
	|	Товары КАК Товары
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.GTIN,
	|	Товары.НоменклатураКиЗ,
	|	Товары.ХарактеристикаКиЗ,
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Номенклатура,
	|	Серии.Характеристика,
	|	Серии.НоменклатураКиЗ,
	|	Серии.ХарактеристикаКиЗ,
	|	Серии.GTIN,
	|	Серии.Количество
	|ПОМЕСТИТЬ Серии
	|ИЗ
	|	&Серии КАК Серии
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Номенклатура,
	|	Серии.Характеристика,
	|	Серии.GTIN,
	|	Серии.НоменклатураКиЗ,
	|	Серии.ХарактеристикаКиЗ,
	|	СУММА(Серии.Количество) КАК Количество
	|ПОМЕСТИТЬ СерииДляЗапроса
	|ИЗ
	|	Серии КАК Серии
	|
	|СГРУППИРОВАТЬ ПО
	|	Серии.Номенклатура,
	|	Серии.Характеристика,
	|	Серии.GTIN,
	|	Серии.НоменклатураКиЗ,
	|	Серии.ХарактеристикаКиЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
	|			ТОГДА 0
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриМаркировкеПродукцииДляГИСМ
	|			ТОГДА ВЫБОР
	|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
	|						ТОГДА ВЫБОР
	|								КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
	|										И ТоварыДляЗапроса.Количество > 0
	|									ТОГДА 4
	|								ИНАЧЕ 3
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
	|									И ТоварыДляЗапроса.Количество > 0
	|								ТОГДА 2
	|							ИНАЧЕ 1
	|						КОНЕЦ
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ Статусы
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыДляЗапроса КАК ТоварыДляЗапроса
	|			ЛЕВОЕ СОЕДИНЕНИЕ СерииДляЗапроса КАК СерииДляЗапроса
	|			ПО ТоварыДляЗапроса.Номенклатура = СерииДляЗапроса.Номенклатура
	|				И ТоварыДляЗапроса.Характеристика = СерииДляЗапроса.Характеристика
	|				И ТоварыДляЗапроса.GTIN = СерииДляЗапроса.GTIN
	|				И ТоварыДляЗапроса.НоменклатураКиЗ = СерииДляЗапроса.НоменклатураКиЗ
	|				И ТоварыДляЗапроса.ХарактеристикаКиЗ = СерииДляЗапроса.ХарактеристикаКиЗ
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|				ПО ПолитикиУчетаСерий.Склад = Склады.Ссылка
	|			ПО (ПолитикиУчетаСерий.Склад = &Склад)
	|				И ТоварыДляЗапроса.ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка
	|		ПО Товары.Номенклатура = ТоварыДляЗапроса.Номенклатура
	|			И Товары.Характеристика = ТоварыДляЗапроса.Характеристика
	|			И Товары.GTIN = ТоварыДляЗапроса.GTIN
	|			И Товары.НоменклатураКиЗ = ТоварыДляЗапроса.НоменклатураКиЗ
	|			И Товары.ХарактеристикаКиЗ = ТоварыДляЗапроса.ХарактеристикаКиЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Статусы.НомерСтроки КАК НомерСтроки,
	|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ИЗ
	|	Статусы КАК Статусы
	|ГДЕ
	|	Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат ТекстЗапроса;
	
	
КонецФункции

Функция ТекстЗапросаЗаполненияСтатусовУказанияСерийПеремаркировкаТоваровГИСМ(ПараметрыУказанияСерий) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.GTIN,
	|	Товары.НоменклатураКиЗ,
	|	Товары.ХарактеристикаКиЗ,
	|	Товары.Количество,
	|	Товары.Серия,
	|	Товары.СписываемаяСерия,
	|	Товары.СтатусУказанияСерий,
	|	Товары.СтатусУказанияСерийСписываемаяСерия,
	|	Товары.НомерСтроки
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
	|	Товары.СтатусУказанияСерийСписываемаяСерия КАК СтарыйСтатусУказанияСерийСписываемаяСерия,
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
	|			ТОГДА 0
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриМаркировкеПродукцииДляГИСМ
	|			ТОГДА ВЫБОР
	|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
	|						ТОГДА ВЫБОР
	|								КОГДА Товары.Количество > 0
	|									ТОГДА 4
	|								ИНАЧЕ 3
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА Товары.Количество > 0
	|								ТОГДА 2
	|							ИНАЧЕ 1
	|						КОНЕЦ
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтатусУказанияСерий,
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
	|			ТОГДА 0
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриМаркировкеПродукцииДляГИСМ
	|			ТОГДА ВЫБОР
	|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
	|						ТОГДА ВЫБОР
	|								КОГДА Товары.Количество > 0
	|									ТОГДА 4
	|								ИНАЧЕ 3
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА Товары.Количество > 0
	|								ТОГДА 2
	|							ИНАЧЕ 1
	|						КОНЕЦ
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтатусУказанияСерийСписываемаяСерия
	|ПОМЕСТИТЬ Статусы
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|			ПО ПолитикиУчетаСерий.Склад = Склады.Ссылка
	|		ПО (ПолитикиУчетаСерий.Склад = &Склад)
	|			И (ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Статусы.НомерСтроки КАК НомерСтроки,
	|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Статусы.СтатусУказанияСерийСписываемаяСерия КАК СтатусУказанияСерийСписываемаяСерия
	|ИЗ
	|	Статусы КАК Статусы
	|ГДЕ
	|	(Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерий
	|		ИЛИ Статусы.СтатусУказанияСерийСписываемаяСерия <> Статусы.СтарыйСтатусУказанияСерийСписываемаяСерия)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПроверкиЗаполненияСерийПеремаркировкаТоваровГИСМ(ПараметрыУказанияСерий) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаСерий.НомерСтроки КАК НомерСтроки,
	|	ТаблицаСерий.Номенклатура КАК Номенклатура,
	|	ТаблицаСерий.Характеристика КАК Характеристика,
	|	ТаблицаСерий.Серия КАК Серия,
	|	""Серия"" КАК ИмяПоляСерия,
	|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка,
	|	ТаблицаСерий.Количество КАК КоличествоУпаковок
	|ПОМЕСТИТЬ ТаблицаСерийДляЗапроса1
	|ИЗ
	|	&ТаблицаСерий КАК ТаблицаСерий
	|ГДЕ
	|	ТаблицаСерий.СтатусУказанияСерий > 0
	|	И НЕ ТаблицаСерий.СтатусУказанияСерий В (&СтатусыСерийСериюМожноУказать)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСерий.НомерСтроки КАК НомерСтроки,
	|	ТаблицаСерий.Номенклатура КАК Номенклатура,
	|	ТаблицаСерий.Характеристика КАК Характеристика,
	|	ТаблицаСерий.СписываемаяСерия КАК Серия,
	|	""СписываемаяСерия"" КАК ИмяПоляСерия,
	|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка,
	|	ТаблицаСерий.Количество КАК КоличествоУпаковок
	|ПОМЕСТИТЬ ТаблицаСерийДляЗапроса2
	|ИЗ
	|	&ТаблицаСерий КАК ТаблицаСерий
	|ГДЕ
	|	ТаблицаСерий.СтатусУказанияСерийСписываемаяСерия > 0
	|	И НЕ ТаблицаСерий.СтатусУказанияСерийСписываемаяСерия В (&СтатусыСерийСериюМожноУказать)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСерий.НомерСтроки,
	|	ТаблицаСерий.Номенклатура,
	|	ТаблицаСерий.Характеристика,
	|	ТаблицаСерий.Серия,
	|	ТаблицаСерий.ИмяПоляСерия,
	|	ТаблицаСерий.Упаковка,
	|	ТаблицаСерий.КоличествоУпаковок
	|ПОМЕСТИТЬ ТаблицаСерийДляЗапроса
	|ИЗ
	|	ТаблицаСерийДляЗапроса1 КАК ТаблицаСерий
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаСерий.НомерСтроки,
	|	ТаблицаСерий.Номенклатура,
	|	ТаблицаСерий.Характеристика,
	|	ТаблицаСерий.Серия,
	|	ТаблицаСерий.ИмяПоляСерия,
	|	ТаблицаСерий.Упаковка,
	|	ТаблицаСерий.КоличествоУпаковок
	|ИЗ
	|	ТаблицаСерийДляЗапроса2 КАК ТаблицаСерий
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Номенклатура


// Проверяет заполнение обязательных реквизитов ГИСМ при записи номенклатуры / характеристики номенклатуры
//
// Параметры:
//   Объект - СправочникОбъект.Номенклатура, СправочникОбъект.ХарактеристикиНоменклатуры - проверяемый объект
//   Отказ  - Булево - признак отказа от записи
//
Процедура ОбработкаПроверкиЗаполненияGTIN(Объект, Отказ) Экспорт
	
	Если ЗначениеЗаполнено(Объект.КиЗГИСМGTIN)
		И Не МенеджерОборудованияКлиентСервер.ПроверитьКорректностьGTIN(Объект.КиЗГИСМGTIN) Тогда
		ТекстСообщения = НСтр("ru = 'Указан некорректный GTIN.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "КиЗГИСМGTIN", "Объект", Отказ);
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоМаркировкаТоваровГИСМ(ПараметрыУказанияСерий) Экспорт

	Возврат ПараметрыУказанияСерий.СкладскиеОперации.Найти(Перечисления.СкладскиеОперации.МаркировкаПродукцииДляГИСМ) <> Неопределено;
	
КонецФункции

Функция ЭтоМаркировкаОстатковГИСМ(ПараметрыУказанияСерий) Экспорт
	
	Возврат ПараметрыУказанияСерий.ОперацияДокумента = Перечисления.ОперацииМаркировкиГИСМ.МаркировкаОстатковНа12082016;
	
КонецФункции

Функция ЭтоПоступлениеИзТаможенногоСоюзаМаркированногоТовара(НастройкиИспользованияСерий, ПараметрыУказанияСерий) Экспорт
	
	ЭтоПоступлениеИзТаможенногоСоюзаМаркированногоТовара = ПараметрыУказанияСерий.ОперацияДокумента = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС
		И НастройкиИспользованияСерий.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ПродукцияИзНатуральногоМеха;
	
	Возврат ЭтоПоступлениеИзТаможенногоСоюзаМаркированногоТовара;
	
КонецФункции

Функция ЭтоМаркировкаПерсонифицированнымиКиЗ(НастройкиИспользованияСерий, ПараметрыУказанияСерий, ЗначенияПолейСвязи) Экспорт
	
	Если ЭтоМаркировкаТоваровГИСМ(ПараметрыУказанияСерий)
		И ПараметрыУказанияСерий.ОперацияДокумента <> Перечисления.ОперацииМаркировкиГИСМ.ИдентификацияРанееМаркированнойНаПроизводствеПродукции
		И ПараметрыУказанияСерий.ОперацияДокумента <> Перечисления.ОперацииМаркировкиГИСМ.ИдентификацияРанееМаркированныхПриИмпортеТоваров
		И ПараметрыУказанияСерий.Свойство("НоменклатураКиЗ") Тогда
		
		GTINИзКиЗ = GTINКиЗ(ЗначенияПолейСвязи.НоменклатураКиЗ, ЗначенияПолейСвязи.ХарактеристикаКиЗ);
		ЭтоМаркировкаПерсонифицированнымиКиЗ = ЗначениеЗаполнено(GTINИзКиЗ);
	Иначе
		ЭтоМаркировкаПерсонифицированнымиКиЗ = Ложь;
	КонецЕсли;
	
	Возврат ЭтоМаркировкаПерсонифицированнымиКиЗ;

КонецФункции

Функция ДобавитьСериюПоИнформацииПоКиЗ(ИнформацияПоКиЗ, Параметры, ТЧСерии, ИдентификаторТекущейСтроки) Экспорт
	
	НастройкиИспользованияСерий = Параметры.НастройкиИспользованияСерий;
	ВидНоменклатуры             = НастройкиИспользованияСерий.ВладелецСерий;
	ЭтоМаркировкаТоваровГИСМ    = ЭтоМаркировкаТоваровГИСМ(Параметры.ПараметрыУказанияСерий);
	ЭтоМаркировкаОстатковГИСМ   = ЭтоМаркировкаОстатковГИСМ(Параметры.ПараметрыУказанияСерий);
	
	Если Не ЗначениеЗаполнено(ИнформацияПоКиЗ.НомерКиЗ) Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка добавления серии по информации о КиЗ: не заполнен номер КиЗ.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЭтоМаркировкаТоваровГИСМ Тогда
		
		GTIN = Параметры.ЗначенияПолейСвязи.GTIN;
		
		Если ЗначениеЗаполнено(ИнформацияПоКиЗ.GTIN)
			И GTIN <> ИнформацияПоКиЗ.GTIN Тогда
			ТекстСообщения = НСтр("ru = 'Считанный КиЗ не может быть использован для маркировки товаров с GTIN %GTINТовара%, т.к. предназначен для маркировки товаров с GTIN %GTINКиЗ%.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTINТовара%", GTIN);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTINКиЗ%", ИнформацияПоКиЗ.GTIN);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Неопределено;
		КонецЕсли;
		
		Если ЭтоМаркировкаОстатковГИСМ Тогда
			
			Если ИнформацияПоКиЗ.ДляМаркировкиОстатков = Ложь Тогда
				ТекстСообщения = НСтр("ru = 'Считанный КиЗ не может быть использован для маркировки остатков товаров.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTINТовара%", GTIN);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTINКиЗ%", ИнформацияПоКиЗ.GTIN);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Возврат Неопределено;
			КонецЕсли;
			
		Иначе
			
			Если ИнформацияПоКиЗ.ДляМаркировкиОстатков = Истина Тогда
				ТекстСообщения = НСтр("ru = 'Считанный КиЗ не может быть использован только для маркировки остатков товаров.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTINТовара%", GTIN);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTINКиЗ%", ИнформацияПоКиЗ.GTIN);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Возврат Неопределено;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	НайденныеСтроки = ТЧСерии.НайтиСтроки(Новый Структура("НомерКИЗГИСМ", ИнформацияПоКиЗ.НомерКиЗ));
	
	ОбрабатываемаяСтрока = Неопределено;
	
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		ТекущаяСтрока = ТЧСерии.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	Иначе
		ТекущаяСтрока = Неопределено;
	КонецЕсли;
	
	// Для случая, когда информации о КиЗ в системе нет, поэтому мы считываем RFID и сканером номер КиЗ.
	Если НайденныеСтроки.Количество() = 0
		И ТекущаяСтрока <> Неопределено
		И Не ЗначениеЗаполнено(ТекущаяСтрока.НомерКИЗГИСМ)
		И (ТекущаяСтрока.RFIDTID = ИнформацияПоКиЗ.RFIDTID
		Или Не ЗначениеЗаполнено(ИнформацияПоКиЗ.RFIDTID)) Тогда
		
		ОбрабатываемаяСтрока = ТекущаяСтрока;
		ЗаполнитьСтрокуПоИнформацииПоКиЗ(ОбрабатываемаяСтрока, ИнформацияПоКиЗ, НастройкиИспользованияСерий);
		
	ИначеЕсли НайденныеСтроки.Количество() > 0 Тогда
		
		ОбрабатываемаяСтрока = НайденныеСтроки[0];
		
		Если Не ЗначениеЗаполнено(ОбрабатываемаяСтрока.Серия) Тогда
			Выборка = ВыборкаИзЗапросаПоискаСерииПоНомеруКиЗ(ИнформацияПоКиЗ.НомерКиЗ, ВидНоменклатуры);
			
			Если Выборка.Следующий() Тогда
				Если РеквизитыСерииСовпадаютСИнформациейПоКиЗ(Выборка, ИнформацияПоКиЗ, ЭтоМаркировкаТоваровГИСМ) Тогда
					ЗаполнитьЗначенияСвойств(ОбрабатываемаяСтрока, Выборка);
				КонецЕсли;
			Иначе
				ЗаполнитьСтрокуПоИнформацииПоКиЗ(ОбрабатываемаяСтрока, ИнформацияПоКиЗ, НастройкиИспользованияСерий);
			КонецЕсли;
			
		Иначе
			Если Не РеквизитыСерииСовпадаютСИнформациейПоКиЗ(ОбрабатываемаяСтрока, ИнформацияПоКиЗ, ЭтоМаркировкаТоваровГИСМ) Тогда
				ТЧСерии.Удалить(ОбрабатываемаяСтрока);
				ОбрабатываемаяСтрока = Неопределено;
			КонецЕсли;
		КонецЕсли;
	Иначе
		
		Выборка = ВыборкаИзЗапросаПоискаСерииПоНомеруКиЗ(ИнформацияПоКиЗ.НомерКиЗ, ВидНоменклатуры);
		
		Если Выборка.Следующий() Тогда
			Если РеквизитыСерииСовпадаютСИнформациейПоКиЗ(Выборка, ИнформацияПоКиЗ, ЭтоМаркировкаТоваровГИСМ) Тогда
				ОбрабатываемаяСтрока = ТЧСерии.Добавить();
				ЗаполнитьЗначенияСвойств(ОбрабатываемаяСтрока, Выборка);
				ОбрабатываемаяСтрока.Количество         = 1;
				ОбрабатываемаяСтрока.КоличествоУпаковок = 1;
			КонецЕсли;
		Иначе
			ОбрабатываемаяСтрока = ТЧСерии.Добавить();
			ЗаполнитьСтрокуПоИнформацииПоКиЗ(ОбрабатываемаяСтрока, ИнформацияПоКиЗ, НастройкиИспользованияСерий);
			ОбрабатываемаяСтрока.Количество         = 1;
			ОбрабатываемаяСтрока.КоличествоУпаковок = 1;
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыЗаполненияФлаговРаботыСМеткой = ШтрихкодированиеНоменклатурыСервер.ПараметрыЗаполненияФлаговРаботыСМеткой();
	ПараметрыЗаполненияФлаговРаботыСМеткой.ТекущаяМетка = Неопределено;
	ПараметрыЗаполненияФлаговРаботыСМеткой.НастройкиИспользованияСерий = Параметры.НастройкиИспользованияСерий;
	ПараметрыЗаполненияФлаговРаботыСМеткой.ЗначенияПолейСвязи          = Параметры.ЗначенияПолейСвязи;
	ШтрихкодированиеНоменклатурыСервер.ЗаполнитьФлагиРаботыСМеткой(ОбрабатываемаяСтрока, ПараметрыЗаполненияФлаговРаботыСМеткой);
	
	Возврат ОбрабатываемаяСтрока;
	
КонецФункции

Функция GTINКиЗ(Номенклатура, Характеристика) Экспорт
	
	Если ЗначениеЗаполнено(Характеристика) Тогда
		
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Характеристика ,"КиЗГИСМGTIN");
		
	Иначе
		
		РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, "КиЗГИСМGTIN,ИспользованиеХарактеристик");
		
		Если РеквизитыНоменклатуры.ИспользованиеХарактеристик <> Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать Тогда
			ТекстИсключения = НСтр("ru = 'Невозможно определить GTIN КиЗ, т.к. не передана характеристика.'");
			ВызватьИсключение ТекстИсключения;
		Иначе
			Возврат РеквизитыНоменклатуры.КиЗГИСМGTIN;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

// Возвращает массив особенностей учета номенклатуры подсистемы
//
// Возвращаемое значение:
//   Массив из ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры
Функция ОсобенностиУчетаНоменклатуры() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Перечисления.ОсобенностиУчетаНоменклатуры.ПродукцияИзНатуральногоМеха);
	Массив.Добавить(Перечисления.ОсобенностиУчетаНоменклатуры.КиЗГИСМ);
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСтрокуПоИнформацииПоКиЗ(Строка, ИнформацияПоКиЗ, НастройкиИспользованияСерий)
	
	Строка.НомерКИЗГИСМ = ИнформацияПоКиЗ.НомерКиЗ;
		
	Если НастройкиИспользованияСерий.ИспользоватьRFIDМеткиСерии Тогда
		Если ЗначениеЗаполнено(ИнформацияПоКиЗ.RFIDTID) Тогда
			Строка.RFIDTID = ИнформацияПоКиЗ.RFIDTID;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИнформацияПоКиЗ.RFIDEPC) Тогда
			Строка.RFIDEPC = ИнформацияПоКиЗ.RFIDEPC;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИнформацияПоКиЗ.GTIN) Тогда
			Строка.EPCGTIN = ИнформацияПоКиЗ.GTIN;
		КонецЕсли;
	КонецЕсли;
	
	Если НастройкиИспользованияСерий.ИспользоватьНомерСерии 
		И ЗначениеЗаполнено(ИнформацияПоКиЗ.СерийныйНомер) Тогда
		Строка.Номер = ИнформацияПоКиЗ.СерийныйНомер;
	КонецЕсли;
	
КонецПроцедуры

Функция ВыборкаИзЗапросаПоискаСерииПоНомеруКиЗ(НомерКиЗ, ВидНоменклатуры)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СерииНоменклатуры.Ссылка КАК Серия,
	|	СерииНоменклатуры.Номер КАК Номер,
	|	СерииНоменклатуры.НомерКиЗГИСМ КАК НомерКиЗГИСМ,
	|	СерииНоменклатуры.RFIDTID КАК RFIDTID,
	|	СерииНоменклатуры.RFIDUser КАК RFIDUser,
	|	СерииНоменклатуры.RFIDEPC КАК RFIDEPC,
	|	СерииНоменклатуры.EPCGTIN КАК EPCGTIN,
	|	СерииНоменклатуры.ГоденДо КАК  ГоденДо
	|ИЗ
	|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|ГДЕ
	|	СерииНоменклатуры.ВидНоменклатуры = &ВидНоменклатуры
	|	И СерииНоменклатуры.НомерКиЗГИСМ = &НомерКиЗГИСМ";
	
	Запрос.УстановитьПараметр("НомерКиЗГИСМ", НомерКиЗ);
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция РеквизитыСерииСовпадаютСИнформациейПоКиЗ(РеквизитыСерии, ИнформацияПоКиЗ, ЭтоМаркировкаТоваровГИСМ)
	
	Если ЭтоМаркировкаТоваровГИСМ
		И (     (ЗначениеЗаполнено(ИнформацияПоКиЗ.RFIDTID) И РеквизитыСерии.RFIDTID <> ИнформацияПоКиЗ.RFIDTID)
			Или (ЗначениеЗаполнено(ИнформацияПоКиЗ.GTIN)    И РеквизитыСерии.EPCGTIN <> ИнформацияПоКиЗ.GTIN)
			Или (ЗначениеЗаполнено(ИнформацияПоКиЗ.СерийныйНомер) 
				И СтрЧислоВхождений(ИнформацияПоКиЗ.СерийныйНомер, "0") <> СтрДлина(ИнформацияПоКиЗ.СерийныйНомер)
				И РеквизитыСерии.Номер <> ИнформацияПоКиЗ.СерийныйНомер)) Тогда
		ТекстСообщения = НСтр("ru = 'Информация о КиЗ с номером %НомерКиЗ% предоставленная эмитентом не соответствует информации, сохраненной в серии. Этот КиЗ не может быть использован для маркировки.'");	
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерКиЗ%", ИнформацияПоКиЗ.НомерКиЗ); 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);	
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
