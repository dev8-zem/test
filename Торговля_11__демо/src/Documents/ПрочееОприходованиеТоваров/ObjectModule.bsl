#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует параметры заполнения видов запасов дополнительных свойств документа, используемых при записи документа
// в режиме 'Проведения' или 'Отмены проведения'.
//
// Параметры:
//	ДокументОбъект - ДокументОбъект.ПрочееОприходованиеТоваров - документ, для которого выполняется инициализация параметров.
//	РежимЗаписи - РежимЗаписиДокумента - режим записи документа.
//
Процедура ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ДокументОбъект, РежимЗаписи = Неопределено) Экспорт
	
	ПараметрыЗаполненияВидовЗапасов = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	
	ДокументОбъект.ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ПараметрыЗаполненияВидовЗапасов);
	
КонецПроцедуры

// Заполняет реквизиты, хранящие информацию о видах запасов и аналитиках учета номенклатуры в табличной части 'Товары'
// документа, а также заполняет табличную часть 'ВидыЗапасов'.
//
// Параметры:
//	Отказ - Булево - признак того, что не удалось заполнить данные.
//	ТаблицыДокумента - см. Документы.ПрочееОприходованиеТоваров.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьВидыЗапасовПриОбмене(Отказ, ТаблицыДокумента) Экспорт
	
	ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
	
	Если ТаблицыДокумента <> Неопределено Тогда
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента);
		ДополнительныеСвойства.Вставить("ТаблицыЗаполненияВидовЗапасовПриОбмене", ТаблицыДокумента);
	Иначе
		ИмяПараметра = "ТаблицыДокумента";
		
		ТекстИсключения = НСтр("ru = 'Для заполнения видов запасов не передан параметр ""%1"".'");
		ТекстИсключения = СтрШаблон(ТекстИсключения, ИмяПараметра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЗаполнитьВидыЗапасов(Отказ);
	ДополнительныеСвойства.Удалить("ТаблицыЗаполненияВидовЗапасовПриОбмене");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
 	Перем РеквизитыШапки;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ВнутреннееПотребление") Тогда
		
		Операция = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "ХозяйственнаяОперация");
		
		Если Операция = Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию Тогда
			
			ЗаполнитьДокументНаОснованииСписанияНаРасходы(ДанныеЗаполнения);
	
		ИначеЕсли Операция = Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию Тогда
			
			ЗаполнитьДокументНаОснованииПередачиВЭксплуатацию(ДанныеЗаполнения);
			
		Иначе
			
			ТекстИсключения = НСтр("ru='Ввод на основании операции ""%1"" не предусмотрен.'");
			ТекстИсключения = СтрШаблон(ТекстИсключения, Строка(Операция));
			
			ВызватьИсключение ТекстИсключения;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПрочееОприходованиеТоваров") Тогда
		
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Товары") Тогда
		
		Если ДанныеЗаполнения.Свойство("РеквизитыШапки") Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения.РеквизитыШапки);
		КонецЕсли;
		
		Для Каждого ЭлементКоллекции Из ДанныеЗаполнения.Товары Цикл
			ДанныеСтроки = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, ЭлементКоллекции);
		КонецЦикла;
		
	КонецЕсли;
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ПрочееОприходованиеТоваров.ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ПересчитатьКоличествоРНПТ();
	
	ПрочееОприходованиеТоваровЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	Серии.Очистить();
	ВидыЗапасов.Очистить();
	
	СостояниеЗаполненияМногооборотнойТары = Перечисления.СостоянияЗаполненияМногооборотнойТары.ПустаяСсылка();
	
	ИнициализироватьДокумент();
	
	ПересчитатьКоличествоРНПТ();
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов");
	
	ПрочееОприходованиеТоваровЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПрочееОприходованиеТоваров));
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов		= Новый Массив;
	МассивРеквизитовОперации	= Новый Массив;
	
	Документы.ПрочееОприходованиеТоваров.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
		
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
		ЗаполнитьВидыЗапасов(Отказ);
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ВидыЗапасов.Очистить();
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов");
	
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ПрочееОприходованиеТоваров.ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	
	ПрочееОприходованиеТоваровЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ПрочееОприходованиеТоваровЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.ПрочееОприходованиеТоваров.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	// Проверка количества в т.ч. товары.
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	// Проверка характеристик в т.ч. товары.
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПрочееОприходованиеТоваров),
		Отказ,
		МассивНепроверяемыхРеквизитов);
		
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ПрочееОприходованиеТоваров.ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
		
	ОперацииПриКоторыхМожноНеЗаполнятьПодразделение = Документы.ПрочееОприходованиеТоваров.ОперацииПриКоторыхМожноНеЗаполнятьПодразделение();
	Если ОперацииПриКоторыхМожноНеЗаполнятьПодразделение.Найти(ХозяйственнаяОперация) <> Неопределено Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПоРНПТ");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	
	ЭтоПрослеживаемыйДокумент = УчетПрослеживаемыхТоваровЛокализация.ЭтоПрослеживаемыйДокумент(Товары, Дата);
	
	Если (ЭтоПрослеживаемыйДокумент
			Или ПолучитьФункциональнуюОпцию("ЗапретитьПоступлениеТоваровБезНомеровГТД"))
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.СторноСписанияНаРасходы Тогда
		
		ЗапасыСервер.ПроверитьЗаполнениеНомеровГТД(ЭтотОбъект, Отказ);
		
	КонецЕсли;
	
	Если ЭтоПрослеживаемыйДокумент Тогда
		УчетПрослеживаемыхТоваровЛокализация.ПроверитьКорректностьНастроекТоваровРНПТ(ЭтотОбъект, Товары, Дата);
	КонецЕсли;
	
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПрочееОприходованиеТоваровЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ЭтотОбъект);
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	
	ПрочееОприходованиеТоваровЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ЭтотОбъект);
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПрочееОприходованиеТоваровЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//    Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Организация;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Склад;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Подразделение;
	
КонецПроцедуры

#Область ИнициализацияИЗаполнение


Процедура ЗаполнитьДокументНаОснованииСписанияНаРасходы(Знач ДокументОснование)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторноСписанияНаРасходы) КАК ХозяйственнаяОперация,
	|	ВнутреннееПотребление.Ссылка КАК ДокументОснование,
	|	ВнутреннееПотребление.Склад КАК Склад,
	|	ВнутреннееПотребление.Подразделение КАК Подразделение,
	|	ВнутреннееПотребление.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ВнутреннееПотребление.Организация КАК Организация,
	|	НЕ ВнутреннееПотребление.Проведен КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ВнутреннееПотребление КАК ВнутреннееПотребление
	|ГДЕ
	|	ВнутреннееПотребление.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	&Ссылка КАК СписаниеНаРасходы,
	|	ВЫБОР КОГДА Товары.СтатусУказанияСерий <> 10 ТОГДА
	|			Товары.Серия
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|		КОНЕЦ КАК Серия,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	Товары.СтатьяРасходов КАК СтатьяРасходовДоходов,
	|	Товары.АналитикаРасходов КАК АналитикаРасходов
	|ИЗ
	|	Документ.ВнутреннееПотребление.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И НЕ Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Серия КАК Серия,
	|	Серии.Количество КАК Количество,
	|	Серии.Номенклатура КАК Номенклатура,
	|	Серии.Характеристика КАК Характеристика
	|ИЗ
	|	Документ.ВнутреннееПотребление.Серии КАК Серии
	|ГДЕ
	|	Серии.Ссылка = &Ссылка
	|		И НЕ (Серии.Ссылка.Склад.ИспользоватьОрдернуюСхемуПриПоступлении
	|				И Серии.Ссылка.Склад.ДатаНачалаОрдернойСхемыПриПоступлении <= Серии.Ссылка.Дата)
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	Товары.Серия КАК Серия,
	|	СУММА(Товары.Количество) КАК Количество,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика
	|ИЗ
	|	Документ.ВнутреннееПотребление.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И НЕ Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|	И Товары.СтатусУказанияСерийОтправитель = 10
	|	И НЕ (Товары.Ссылка.Склад.ИспользоватьОрдернуюСхемуПриПоступлении
	|		И Товары.Ссылка.Склад.ДатаНачалаОрдернойСхемыПриПоступлении <= Товары.Ссылка.Дата)
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Серия,
	|	Товары.Номенклатура,
	|	Товары.Назначение,
	|	Товары.Характеристика
	|");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ВыборкаШапка = МассивРезультатов[0].Выбрать();
	ВыборкаШапка.Следующий();
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(ДокументОснование, , ВыборкаШапка.ЕстьОшибкиПроведен);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	Товары.Загрузить(МассивРезультатов[1].Выгрузить());
	Серии.Загрузить(МассивРезультатов[2].Выгрузить());
	
	НазначениеПоУмолчанию = НаправленияДеятельностиСервер.ТолкающееНазначение(НаправлениеДеятельности);
	НакладныеСервер.ЗаполнитьНазначенияВТабличнойЧасти(Товары, НазначениеПоУмолчанию);
	НакладныеСервер.ЗаполнитьНазначенияВТабличнойЧасти(Серии, НазначениеПоУмолчанию);
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПередачиВЭксплуатацию(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации) КАК ХозяйственнаяОперация,
	|	ВнутреннееПотребление.Ссылка КАК ДокументОснование,
	|	ВнутреннееПотребление.Склад КАК Склад,
	|	ВнутреннееПотребление.Подразделение КАК Подразделение,
	|	ВнутреннееПотребление.Организация КАК Организация,
	|	ВнутреннееПотребление.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НЕ ВнутреннееПотребление.Проведен КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ВнутреннееПотребление КАК ВнутреннееПотребление
	|ГДЕ
	|	ВнутреннееПотребление.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Назначение КАК Назначение,
	|	ВЫБОР
	|		КОГДА Товары.СтатусУказанияСерийОтправитель <> 10
	|			ТОГДА Товары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	&Ссылка КАК ПередачаВЭксплуатацию,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	Товары.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	Документ.ВнутреннееПотребление.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Серия КАК Серия,
	|	Серии.Количество КАК Количество,
	|	Серии.Номенклатура КАК Номенклатура,
	|	Серии.Назначение КАК Назначение,
	|	Серии.Характеристика КАК Характеристика
	|ИЗ
	|	Документ.ВнутреннееПотребление.Серии КАК Серии
	|ГДЕ
	|	Серии.Ссылка = &Ссылка
	|		И НЕ (Серии.Ссылка.Склад.ИспользоватьОрдернуюСхемуПриПоступлении
	|				И Серии.Ссылка.Склад.ДатаНачалаОрдернойСхемыПриПоступлении <= Серии.Ссылка.Дата)
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	Товары.Серия КАК Серия,
	|	СУММА(Товары.Количество) КАК Количество,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Назначение КАК Назначение,
	|	Товары.Характеристика КАК Характеристика
	|ИЗ
	|	Документ.ВнутреннееПотребление.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|		И Товары.СтатусУказанияСерийОтправитель = 10
	|		И НЕ (Товары.Ссылка.Склад.ИспользоватьОрдернуюСхемуПриПоступлении
	|				И Товары.Ссылка.Склад.ДатаНачалаОрдернойСхемыПриПоступлении <= Товары.Ссылка.Дата)
	|СГРУППИРОВАТЬ ПО
	|	Товары.Серия,
	|	Товары.Номенклатура,
	|	Товары.Назначение,
	|	Товары.Характеристика";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка = МассивРезультатов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(ДокументОснование, , ВыборкаШапка.ЕстьОшибкиПроведен);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	
	Товары.Загрузить(МассивРезультатов[1].Выгрузить());
	Серии.Загрузить(МассивРезультатов[2].Выгрузить());
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		СкладДляЗаполнения = Склад;
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
				И ДанныеЗаполнения.Свойство("Склад") Тогда
				СкладДляЗаполнения = ДанныеЗаполнения.Склад;
		КонецЕсли;
		ВидЦены = Справочники.Склады.УчетныйВидЦены(СкладДляЗаполнения);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(
			Справочники.ВидыЦен.ПолучитьРеквизитыВидаЦены(ВидЦены).ВалютаЦены);
	КонецЕсли;
	
	ВариантПриемкиТоваров = Константы.ВариантПриемкиТоваров.Получить();
	
	Если Не (ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Товары"))
			И Не ДанныеЗаполнения = Неопределено Тогда
		СтруктураЗаполненияЦен = Новый Структура("Дата,Валюта,ВидЦены", Дата, Валюта, ВидЦены);
		СтруктураПересчета = Новый Структура("ПересчитатьСумму", "КоличествоУпаковок");
		ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(Товары, , СтруктураЗаполненияЦен, СтруктураПересчета);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.СторноСписанияНаРасходы Тогда
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, Товары);
	Иначе // хоз. операция - Сторно списания на расходы.
		
		ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоОстаткамКОформлению(ЭтотОбъект,
																МенеджерВременныхТаблиц,
																Отказ,
																ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, ВидЗапасовОтгрузки, СкладОтгрузки,
							|ДокументРеализации, СтатьяРасходов, АналитикаРасходов, АналитикаУчетаНоменклатурыОтгрузки",
							"Количество, КоличествоПоРНПТ");
		
		ЗаполнитьСтатьюРасходовВидовЗапасов();
		
	КонецЕсли;

КонецПроцедуры

// Процедура заполняет статью и аналитику расходов видов запасов документа.
//
Процедура ЗаполнитьСтатьюРасходовВидовЗапасов()
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	
	Для Каждого СтрокаТоваров Из Товары Цикл
		
		КоличествоТоваров = СтрокаТоваров.Количество;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
			
			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);
			
			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.СтатьяРасходов	= СтрокаТоваров.СтатьяРасходовДоходов;
			НоваяСтрока.АналитикаРасходов	= СтрокаТоваров.АналитикаРасходов;
			НоваяСтрока.Количество			= Количество;
			НоваяСтрока.КоличествоПоРНПТ	= Количество * СтрокаЗапасов.КоличествоПоРНПТ / СтрокаЗапасов.Количество;
			
			СтрокаЗапасов.Количество	= СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			СтрокаЗапасов.КоличествоПоРНПТ	= СтрокаЗапасов.КоличествоПоРНПТ - НоваяСтрока.КоличествоПоРНПТ;
			
			КоличествоТоваров = КоличествоТоваров - НоваяСтрока.Количество;
			
			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ПараметрыПоиска = Новый Структура("Количество", 0);
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(ПараметрыПоиска);
	
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Функция ПараметрыЗаполненияВидовЗапасов()
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполнения.ИмяТаблицыОстатков = "ТоварыСписанныеНаРасходы";
	ПараметрыЗаполнения.ПриНехваткеТоваровОрганизацииЗаполнятьВидамиЗапасовПоУмолчанию = Ложь;
	ПараметрыЗаполнения.СторнируемыйДокумент = СторнируемыйДокумент;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Заполняет аналитики учета номенклатуры в табличных частях документа, хранящих информацию о товарах.
// Если параметр не передан, тогда будет выполнено заполнение данных в табличных частях документа.
//
// Параметры:
//	ТаблицыДокумента - см. Документы.ПрочееОприходованиеТоваров.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента = Неопределено)
	
	Если ТаблицыДокумента = Неопределено Тогда
		ТаблицыДокумента = Документы.ПрочееОприходованиеТоваров.КоллекцияТабличныхЧастейТоваров();
		
		ЗаполнитьЗначенияСвойств(ТаблицыДокумента, ЭтотОбъект);
	КонецЕсли;
	
	ТаблицаТовары = ТаблицыДокумента.Товары;
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(ХозяйственнаяОперация,
																		Склад,
																		Подразделение,
																		Неопределено);
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(ТаблицаТовары, МестаУчета);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Функция формирует временные таблицы данных документа.
//
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - менеджер временных таблиц.
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.ВидЗапасов КАК ВидЗапасов
	|ПОМЕСТИТЬ ВтИсходнаяТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	ИЛИ &ПерезаполнитьВидыЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаТоваров.ВидЗапасов
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеТоваров) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеОрганизации,
	|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка) КАК ВидЦены
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ВтИсходнаяТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	НЕОПРЕДЕЛЕНО КАК ДокументРеализации,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторноСписанияНаРасходы) КАК ХозяйственнаяОперация,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаТоваров.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	&Склад КАК Склад,
	|	ТаблицаТоваров.СписаниеНаРасходы КАК ДокументРеализации,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ТаблицаТоваров.НомерГТД КАК НомерГТД
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаТоваров.Склад КАК Склад,
	|	ТаблицаТоваров.ДокументРеализации,
	|	ТаблицаТоваров.Сделка КАК Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаВознаграждения КАК СуммаВознаграждения,
	|	ТаблицаТоваров.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ПодбиратьВидыЗапасов,
	|	Аналитика.КлючАналитики КАК АналитикаУчетаНоменклатурыОприходования,
	|	ТаблицаТоваров.НомерГТД КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО ТаблицаТоваров.Номенклатура = СпрНоменклатура.Ссылка
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаТоваров.Номенклатура = Аналитика.Номенклатура
	|			И ТаблицаТоваров.Характеристика = Аналитика.Характеристика
	|			И ТаблицаТоваров.Серия = Аналитика.Серия
	|			И ТаблицаТоваров.Склад = Аналитика.МестоХранения
	|			И ТаблицаТоваров.Назначение = Аналитика.Назначение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	Аналитика.Номенклатура КАК НоменклатураОприходование,
	|	Аналитика.Характеристика КАК ХарактеристикаОприходование,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	Аналитика.МестоХранения КАК Склад,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ЛОЖЬ КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|
	|//////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВтИсходнаяТаблицаТоваров
	|";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ТаблицаТоваров = ?(ДополнительныеСвойства.Свойство("ТаблицыЗаполненияВидовЗапасовПриОбмене")
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене <> Неопределено
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Свойство("Товары"),
						ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Товары,
						Товары);
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
	Запрос.УстановитьПараметр("Проведен", Проведен);
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект, Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Процедура ПересчитатьКоличествоРНПТ()
	
	ИсключаемыеОперации = Новый Массив;
	ИсключаемыеОперации.Добавить(Перечисления.ХозяйственныеОперации.ПустаяСсылка());
	ИсключаемыеОперации.Добавить(Перечисления.ХозяйственныеОперации.СторноСписанияНаРасходы);
	
	Если ИсключаемыеОперации.Найти(ХозяйственнаяОперация) = Неопределено Тогда
		ПараметрыПересчета = УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ПараметрыПолученияКоэффициентаРНПТ(
												ЭтотОбъект);
		УчетПрослеживаемыхТоваровЛокализация.ЗаполнитьКоличествоПоРНПТВТабличнойЧасти(ПараметрыПересчета, Товары);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли
