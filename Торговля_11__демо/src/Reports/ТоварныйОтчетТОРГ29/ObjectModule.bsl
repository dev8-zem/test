#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомерОтчета = НомерОтчета + 1;
	
	ДокументРезультат.Вывести(СформироватьОтчетТОРГ29(
		ДатаНачала,
		ДатаОкончания,
		Склад,
		Организация,
		НомерОтчета));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПредставлениеДокумента(СтрокаТЗ, ТипыКорректировок, ТипДвижения = "Расход")
	
	ТипДокумента = ТипЗнч(СтрокаТЗ.Документ);
	Если ТипДокумента = Тип("ДокументСсылка.УстановкаЦенНоменклатуры") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Установка цен'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Возврат от клиента'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Возврат поставщику'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ОприходованиеИзлишковТоваров") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Акт об оприходовании товаров'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПрочееОприходованиеТоваров") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Акт об оприходовании товаров'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Отчет о розничных продажах'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Накладная на перемещение'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПересортицаТоваров") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Акт о пересортице товаров'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПорчаТоваров") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Акт о порче товаров'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Приходная накладная'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.КорректировкаПриобретения") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Корректировка приходной накладной'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Расходная накладная'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Корректировка расходной накладной'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.СборкаТоваров") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Сборка товаров'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.СписаниеНедостачТоваров") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Акт о списании товаров'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ВнутреннееПотребление") Тогда
		Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Требование-накладная'"));
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями") Тогда
		Если ТипДвижения = "Расход" Тогда
			Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Расходная накладная'"));
		Иначе // Приход
			Представление =  ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Приходная накладная'"));
		КонецЕсли;
	ИначеЕсли ТипыКорректировок.Найти(ТипДокумента) <> Неопределено Тогда
		Представление = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, НСтр("ru = 'Корректировка остатков'"));
	Иначе
		Представление = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтрокаТЗ, Строка(ТипДокумента));
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

Функция СформироватьОтчетТОРГ29(ДатаНачала, ДатаОкончания, Склад, Организация, НомерОтчета)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	РозничныйВидЦены = Склад.РозничныйВидЦены;
	Если Не ЗначениеЗаполнено(РозничныйВидЦены) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для склада не установлен розничный вид цены.'"));
		Возврат ТабДокумент;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(РозничныйВидЦены.ВалютаЦены) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не установлена валюта розничного вида цены для склада.'"));
		Возврат ТабДокумент;
	КонецЕсли;
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	Если Не ЗначениеЗаполнено(ВалютаРегламентированногоУчета) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не установлена валюта регламентированного учета.'"));
		Возврат ТабДокумент;
	КонецЕсли;
	
	Макет = ПолучитьМакет("Макет");
	
	// Выведем заголовок.
	СведенияОПокупателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Организация, ДатаОкончания);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ОрганизацияПредставление = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе);
	ОбластьМакета.Параметры.ДатаСоставления = ТекущаяДатаСеанса();
	ОбластьМакета.Параметры.ДатаНачала = ДатаНачала;
	ОбластьМакета.Параметры.ДатаКонца = ДатаОкончания;
	ОбластьМакета.Параметры.ОрганизацияПоОКПО = СведенияОПокупателе.КодПоОКПО;
	
	ОбластьМакета.Параметры.Номер = НомерОтчета;
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ТабДокумент.Вывести(ОбластьМакета);
	
	// Повторение шапки
	ПовторятьПриПечатиСтроки = ТабДокумент.Область(1 + ОбластьМакета.ВысотаТаблицы, ,2 + ОбластьМакета.ВысотаТаблицы);
	
	СхемаКомпоновкиДанных = Отчеты.ВедомостьПоТоварамОрганизацийВЦенахНоменклатуры.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
		
	НаборДанных25 = СхемаКомпоновкиДанных.НаборыДанных.Найти("Запрос2_5");
	Если ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25() Тогда
		НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Найти("Запрос");
		НаборДанных.Запрос = НаборДанных25.Запрос;
	КонецЕсли;
	СхемаКомпоновкиДанных.НаборыДанных.Удалить(НаборДанных25);

	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных[0].Запрос;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
		
		ТекстЗамены = 
		"ВЫБОР
		|		КОГДА ЦеныНоменклатурыА.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|				ИЛИ ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 0) = 0
		|			ТОГДА ЦеныНоменклатурыА.Цена
		|		ИНАЧЕ ЦеныНоменклатурыА.Цена / &ТекстЗапросаКоэффициентУпаковки1
		|	КОНЕЦ";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&АктуальнаяЦена", ТекстЗамены);
		
		ТекстЗамены = 
		"ВЫБОР
		|		КОГДА ЦеныНоменклатурыБ.Цена ЕСТЬ NULL 
		|			ТОГДА 0
		|		КОГДА ЦеныНоменклатурыБ.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|				ИЛИ ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 0) = 0
		|			ТОГДА ЦеныНоменклатурыБ.Цена
		|		ИНАЧЕ ЦеныНоменклатурыБ.Цена / &ТекстЗапросаКоэффициентУпаковки2
		|	КОНЕЦ";

		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СтараяЦена", ТекстЗамены);
		
		ТекстЗамены = 
		"ВЫБОР
		|		КОГДА ЦеныНоменклатурыА.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|				ИЛИ ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 0) = 0
		|			ТОГДА ЦеныНоменклатурыА.Цена
		|		ИНАЧЕ ЦеныНоменклатурыА.Цена / &ТекстЗапросаКоэффициентУпаковки1
		|	КОНЕЦ - ВЫБОР
		|		КОГДА ЦеныНоменклатурыБ.Цена ЕСТЬ NULL 
		|			ТОГДА 0
		|		КОГДА ЦеныНоменклатурыБ.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|				ИЛИ ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 0) = 0
		|			ТОГДА ЦеныНоменклатурыБ.Цена
		|		ИНАЧЕ ЦеныНоменклатурыБ.Цена / &ТекстЗапросаКоэффициентУпаковки2
		|	КОНЕЦ";

		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Дельта", ТекстЗамены);
		
	Иначе

		ТекстЗамены = 
		"ЦеныНоменклатурыА.Цена";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&АктуальнаяЦена", ТекстЗамены);

		ТекстЗамены = 
		"ВЫБОР
		|		КОГДА
		|			ЦеныНоменклатурыБ.Цена ЕСТЬ NULL
		|		ТОГДА
		|			0
		|		ИНАЧЕ
		|			ЦеныНоменклатурыБ.Цена
		|	КОНЕЦ";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СтараяЦена", ТекстЗамены);

		ТекстЗамены = 
		"ЦеныНоменклатурыА.Цена
		|		- ВЫБОР
		|			КОГДА
		|				ЦеныНоменклатурыБ.Цена ЕСТЬ NULL
		|			ТОГДА
		|				0
		|			ИНАЧЕ
		|				ЦеныНоменклатурыБ.Цена
		|		КОНЕЦ";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Дельта", ТекстЗамены);
		
	КонецЕсли;
	
	СхемаКомпоновкиДанных.НаборыДанных[0].Запрос = ТекстЗапроса;	
	
	СхемаКомпоновкиДанных.НаборыДанных[0].Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных[0].Запрос, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыА.Упаковка",
			"ЦеныНоменклатурыА.Номенклатура"));
	СхемаКомпоновкиДанных.НаборыДанных[0].Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных[0].Запрос, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыБ.Упаковка",
			"ЦеныНоменклатурыБ.Номенклатура"));
	// Подготовка компоновщика макета компоновки данных.
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	// Выбранные поля.
	ОбязательныеПоля = Новый Массив;
	ОбязательныеПоля.Добавить("Регистратор");
	ОбязательныеПоля.Добавить("ЦенаУстановлена");
	ОбязательныеПоля.Добавить("СуммаНачальныйОстаток");
	ОбязательныеПоля.Добавить("СуммаПриход");
	ОбязательныеПоля.Добавить("СуммаРасход");
	ОбязательныеПоля.Добавить("СуммаКонечныйОстаток");
	ОбязательныеПоля.Добавить("КоличествоНачальныйОстаток");
	ОбязательныеПоля.Добавить("КоличествоПриход");
	ОбязательныеПоля.Добавить("КоличествоРасход");
	ОбязательныеПоля.Добавить("КоличествоКонечныйОстаток");
	
	Компоновщик.Настройки.Выбор.Элементы.Очистить();
	Для Каждого ОбязательноеПоле Из ОбязательныеПоля Цикл
		ПолеСКД = КомпоновкаДанныхСервер.НайтиПолеСКДПоПолномуИмени(Компоновщик.Настройки.Выбор.ДоступныеПоляВыбора.Элементы, ОбязательноеПоле);
		Если ПолеСКД <> Неопределено Тогда
			ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле = ПолеСКД.Поле;
		КонецЕсли;
	КонецЦикла;
	
	// Добавление группировок.
	Компоновщик.Настройки.Структура.Очистить();
	КомпоновкаДанныхКлиентСервер.ДобавитьГруппировку(Компоновщик, "Регистратор");
	КомпоновкаДанныхКлиентСервер.ДобавитьГруппировку(Компоновщик, "ЦенаУстановлена");
	
	// Отключение итогов.
	КомпоновкаДанныхКлиентСервер.УстановитьПараметрВывода(Компоновщик,"ВертикальноеРасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметрВывода(Компоновщик,"ГоризонтальноеРасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
	
	// Установка отборов.
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Компоновщик, "Склад",       Склад);
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Компоновщик, "Организация", Организация);
	
	// Установка параметра "Вид цены"
	ПараметрВидЦены = Новый ПараметрКомпоновкиДанных("ВидЦены");
	ЗначениеПараметраВидЦены = Компоновщик.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрВидЦены);
	Если ЗначениеПараметраВидЦены <> Неопределено Тогда
		ЗначениеПараметраВидЦены.Значение = РозничныйВидЦены;
		ЗначениеПараметраВидЦены.Использование = Истина;
	КонецЕсли;
	
	Период = Новый СтандартныйПериод;
	Период.ДатаНачала    = НачалоДня(ДатаНачала);
	Период.ДатаОкончания = КонецДня(ДатаОкончания);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "ПериодОтчета", Период);
	
	// Компоновка макета компоновки данных.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Компоновщик.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	// Построение таблицы значений.
	Процессор = Новый ПроцессорКомпоновкиДанных;
	Процессор.Инициализировать(МакетКомпоновкиДанных, , , Истина);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений();
	ИсходныеДанные = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ИсходныеДанные);
	ПроцессорВывода.Вывести(Процессор);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Таблица.Регистратор                       КАК Регистратор,
	|	Таблица.ЦенаУстановлена                   КАК ЦенаУстановлена,
	|	ЕСТЬNULL(Таблица.КоличествоНачальныйОстаток,0) КАК НачОстКол,
	|	ЕСТЬNULL(Таблица.КоличествоПриход,0)           КАК ПриходКол,
	|	ЕСТЬNULL(Таблица.КоличествоРасход,0)           КАК РасходКол,
	|	ЕСТЬNULL(Таблица.КоличествоКонечныйОстаток,0)  КАК КонОстКол,
	|	ЕСТЬNULL(Таблица.СуммаНачальныйОстаток,0) КАК НачОст,
	|	ЕСТЬNULL(Таблица.СуммаПриход,0)           КАК Приход,
	|	ЕСТЬNULL(Таблица.СуммаРасход,0)           КАК Расход,
	|	ЕСТЬNULL(Таблица.СуммаКонечныйОстаток,0)  КАК КонОст
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	&ИсходныеДанные КАК Таблица
	|ГДЕ Таблица.Регистратор <> Неопределено
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Регистратор       КАК Документ,
	|	ТаблицаДокументов.Регистратор.Дата  КАК Дата,
	|	ТаблицаДокументов.Регистратор.Номер КАК Номер,
	|	ТаблицаДокументов.ЦенаУстановлена   КАК ЦенаУстановлена,
	|	СУММА(ВЫБОР КОГДА ТаблицаДокументов.КонОстКол - ТаблицаДокументов.НачОстКол > 0 ТОГДА ТаблицаДокументов.КонОстКол - ТаблицаДокументов.НачОстКол ИНАЧЕ 0 КОНЕЦ) КАК ПриходКол,
	|	СУММА(ВЫБОР КОГДА ТаблицаДокументов.НачОстКол - ТаблицаДокументов.КонОстКол > 0 ТОГДА ТаблицаДокументов.НачОстКол - ТаблицаДокументов.КонОстКол ИНАЧЕ 0 КОНЕЦ) КАК РасходКол,
	|	СУММА(ВЫБОР КОГДА ТаблицаДокументов.КонОст - ТаблицаДокументов.НачОст > 0 ТОГДА ТаблицаДокументов.КонОст - ТаблицаДокументов.НачОст ИНАЧЕ 0 КОНЕЦ) КАК Приход,
	|	СУММА(ВЫБОР КОГДА ТаблицаДокументов.НачОст - ТаблицаДокументов.КонОст > 0 ТОГДА ТаблицаДокументов.НачОст - ТаблицаДокументов.КонОст ИНАЧЕ 0 КОНЕЦ) КАК Расход
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокументов.Регистратор,
	|	ТаблицаДокументов.ЦенаУстановлена
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Документ
	|");
	
	Запрос.УстановитьПараметр("ИсходныеДанные", ИсходныеДанные);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ИсходныеДанные.Количество() = 0 Тогда
		
		НачОст = 0;
		КонОст = 0;
		
	Иначе
		
		Если ИсходныеДанные.Количество() > 1 Тогда
			
			Если ИсходныеДанные[0].Регистратор = Неопределено И ИсходныеДанные[1].Регистратор <> Неопределено Тогда
				НачОст = ИсходныеДанные[1].СуммаНачальныйОстаток;
			Иначе
				НачОст = ИсходныеДанные[0].СуммаНачальныйОстаток;
			КонецЕсли;
			
		Иначе
			НачОст = ИсходныеДанные[0].СуммаНачальныйОстаток;
		КонецЕсли;
		
		КонОст = ИсходныеДанные[ИсходныеДанные.Количество()-1].СуммаКонечныйОстаток;
		
	КонецЕсли;
	
	ВалютаСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РозничныйВидЦены, "ВалютаЦены");
	ВалютаРеглУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ОстатокНачала");
	ОбластьМакета.Параметры.ДатаНачала = НСтр("ru = 'Остаток на'") + " " + Формат(ДатаНачала, "ДЛФ=Д");
	ОбластьМакета.Параметры.НачСтоимостьВсего = ФормированиеПечатныхФорм.ФорматСумм(НачОст
		* РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаСклада, ВалютаРеглУчета, Неопределено, ВалютаРеглУчета));
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Приход");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ТипыКорректировок = Новый Массив;
	ТипыКорректировок.Добавить(Тип("ДокументСсылка.КорректировкаОбособленногоУчетаЗапасов"));
	ТипыКорректировок.Добавить(Тип("ДокументСсылка.КорректировкаРегистров"));
	
	ТипыВводаОстатков = ВводОстатковСервер.ДоступныеТипыВводаОстатков();
	Для Каждого ТипВводаОстатков Из ТипыВводаОстатков Цикл
		ТипыКорректировок.Добавить(ТипВводаОстатков);
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	Для Каждого СтрокаТЗ Из РезультатЗапроса Цикл
		
		Если СтрокаТЗ.ЦенаУстановлена = Неопределено
			ИЛИ (СтрокаТЗ.Приход = 0 И СтрокаТЗ.ПриходКол = 0) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ВыводитьДокументыБезЦеныВНоменклатуре
			И СтрокаТЗ.Приход = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьМакета.Параметры.Документ       = ПолучитьПредставлениеДокумента(СтрокаТЗ, ТипыКорректировок, "Приход");
		ОбластьМакета.Параметры.Расшифровка    = СтрокаТЗ.Документ;
		ОбластьМакета.Параметры.ДатаДокумента  = СтрокаТЗ.Дата;
		ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СтрокаТЗ.Номер, Ложь, Истина);
		
		Если СтрокаТЗ.ЦенаУстановлена Тогда
			ОбластьМакета.Параметры.СуммаТовара = ФормированиеПечатныхФорм.ФорматСумм(СтрокаТЗ.Приход
				* РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаСклада, ВалютаРеглУчета, Неопределено, ВалютаРеглУчета));
			ОбластьМакета.Параметры.СуммаТары   = ФормированиеПечатныхФорм.ФорматСумм(0);
		Иначе
			ОбластьМакета.Параметры.СуммаТовара = 0;
			ОбластьМакета.Параметры.СуммаТары   = 0;
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
	Приход = РезультатЗапроса.Итог("Приход");
	
	ОбластьМакета = Макет.ПолучитьОбласть("ИтогоПриход");
	ОбластьМакета.Параметры.ПрихСтоимостьВсего = ФормированиеПечатныхФорм.ФорматСумм(Приход
		* РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаСклада, ВалютаРеглУчета, Неопределено, ВалютаРеглУчета));
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ВсегоПриход");
	ОбластьМакета.Параметры.ПриходСОстатком = ФормированиеПечатныхФорм.ФорматСумм((Приход + НачОст)
		* РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаСклада, ВалютаРеглУчета, Неопределено, ВалютаРеглУчета));
	ТабДокумент.Вывести(ОбластьМакета);
	
	ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	ОбластьМакета = Макет.ПолучитьОбласть("Расход");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	Для Каждого СтрокаТЗ Из РезультатЗапроса Цикл
		
		Если СтрокаТЗ.ЦенаУстановлена = Неопределено
			ИЛИ (СтрокаТЗ.Расход = 0 И СтрокаТЗ.РасходКол = 0) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ВыводитьДокументыБезЦеныВНоменклатуре
			И СтрокаТЗ.Расход = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьМакета.Параметры.Документ       = ПолучитьПредставлениеДокумента(СтрокаТЗ, ТипыКорректировок, "Расход");
		ОбластьМакета.Параметры.Расшифровка    = СтрокаТЗ.Документ;
		ОбластьМакета.Параметры.ДатаДокумента  = СтрокаТЗ.Дата;
		ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СтрокаТЗ.Номер, Ложь, Истина);
		
		Если СтрокаТЗ.ЦенаУстановлена Тогда
			ОбластьМакета.Параметры.СуммаТовара = ФормированиеПечатныхФорм.ФорматСумм(СтрокаТЗ.Расход
				* РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаСклада, ВалютаРеглУчета, Неопределено, ВалютаРеглУчета));
			ОбластьМакета.Параметры.СуммаТары   = ФормированиеПечатныхФорм.ФорматСумм(0);
		Иначе
			ОбластьМакета.Параметры.СуммаТовара = 0;
			ОбластьМакета.Параметры.СуммаТары   = 0;
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
	Расход = РезультатЗапроса.Итог("Расход");
	
	ОбластьМакета = Макет.ПолучитьОбласть("ИтогоРасход");
	ОбластьМакета.Параметры.РасхСтоимостьВсего = ФормированиеПечатныхФорм.ФорматСумм(Расход
		* РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаСклада, ВалютаРеглУчета, Неопределено, ВалютаРеглУчета));
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ОстатокКонец");
	ОбластьМакета.Параметры.ДатаКонца = НСтр("ru = 'Остаток на'") + " "  + Формат(ДатаОкончания, "ДЛФ=Д");
	ОбластьМакета.Параметры.КонСтоимостьВсего = ФормированиеПечатныхФорм.ФорматСумм(КонОст
		* РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаСклада, ВалютаРеглУчета, Неопределено, ВалютаРеглУчета));
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ТабДокумент.ПовторятьПриПечатиСтроки = ПовторятьПриПечатиСтроки;
	
	Возврат ТабДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли
