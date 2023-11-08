#Область ПрограммныйИнтерфейс

//Определяет использование актов о расхождении после приемки для документа
//
//Параметры:
//  Документ     - ДокументСсылка - документ, для которого необходимо определить возможность использования актов о расхождении.
//  Используется - Булево - в данный параметр необходимо установить признак использования актов, по умолчанию установлен в Ложь.
//
Процедура ОпределитьИспользованиеАктовОРасхожденииПослеПриемки(Документ, Используется) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияИСМПУТ.ОпределитьИспользованиеАктовОРасхожденииПослеПриемки(Документ, Используется);
	//-- НЕ ГОСИС
	
КонецПроцедуры

//Заполняет в переданную таблицу данные из ТЧ документа.
//
//Параметры:
//   Документ - ДокументСсылка - Документ из ТЧ которого будет происходить заполнение.
//   ТаблицаПродукции - ТаблицаЗначений - Таблица для заполнения данными из документа.
//   ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС, Массив из ПеречислениеСсылка.ВидыПродукцииИС - 
//     вид(ы) маркируемой продукции, которым(и) необходимо заполнить таблицу.
//
Процедура СформироватьТаблицуМаркируемойПродукцииДокумента(Документ, ТаблицаПродукции, ВидМаркируемойПродукции) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияИСМПУТ.СформироватьТаблицуМаркируемойПродукцииДокумента(Документ, ТаблицаПродукции, ВидМаркируемойПродукции);
	//-- НЕ ГОСИС
	
КонецПроцедуры

//Заполняет таблицу маркированный товаров по выбранным документам.
//
//Параметры:
//   Запрос - Запрос - запрос, в котором требуется сформировать временную таблицу.
//   ИсточникОснований - Строка - Имя временной таблицы с колонкой "ДокументОснование".
//   СтандартнаяОбработка - Булево - Необходимость обработки события "по-умолчанию" (установить Ложь при переопределении).
//
Процедура СформироватьТаблицуМаркированныхТоваровОснований(Запрос, ИсточникОснований, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПУТ.СформироватьТаблицуМаркированныхТоваровОснований(Запрос, ИсточникОснований);
	//-- НЕ ГОСИС
	
КонецПроцедуры

//Дополнительные действия прикладной конфигурации при изменении статуса документа ИСМП.
//
//Параметры:
//   ДокументСсылка   - ДокументСсылка     - ссылка на документ с изменением статуса.
//   ПредыдущийСтатус - ПеречислениеСсылка - предыдущий статус обработки.
//   НовыйСтатус      - ПеречислениеСсылка - новый статус обработки.
//   ПараметрыОбновленияСтатуса - Структура, Неопределено - (См. ИнтеграцияИСМПСлужебныйКлиентСервер.ПараметрыОбновленияСтатуса).
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса = Неопределено) Экспорт

	Возврат;

КонецПроцедуры

#Область Серии

//Предназачена для реализации механизма генерации серий номенклатуры по переданным данным
//  (См. ИнтеграцияИСМП.СгенерироватьСерии)
//
Процедура СгенерироватьСерии(ДанныеДляГенерации, ВидМаркируемойПродукции) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияИСМПУТ.СгенерироватьСерии(ДанныеДляГенерации, ВидМаркируемойПродукции);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#Область Номенклатура

// Определяет заполнение Товарного знака по номенклатуре.
// 
// Параметры:
// 	Номенклатура - Массив из ОпределяемыйТип.Номенклатура - Исходные данные для заполнения.
// 	ТоварныеЗнакиПоНоменклатуре - Соответствие:
// 	 * Ключ     - ОпределяемыйТип.Номенклатура - Значение номенклатуры из исходных данных.
// 	 * Значение - Строка, произвольный         - Товарный знак по номенклатуре (значение будет конвертировано в строку).
Процедура ТоварныеЗнакиПоНоменклатуре(Номенклатура, ТоварныеЗнакиПоНоменклатуре) Экспорт
	
	//++ НЕ ГОСИС
	ТоварныеЗнакиПоНоменклатуре = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Номенклатура, "Производитель");
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

//Получение ссылки ТН ВЭД по коду.
//
//Параметры:
//  КодТНВЭД - Строка - Код по классификатору товарной номенклатуры внешнеэкономической деятельности.
//  ТНВЭД - Произвольный - искомый элемент.
//
Процедура КлассификаторТНВЭД(КодТНВЭД, ТНВЭД) Экспорт
	
	//++ НЕ ГОСИС
	ТНВЭД = Справочники.КлассификаторТНВЭД.ПустаяСсылка();
	Если ЗначениеЗаполнено(КодТНВЭД) Тогда
		ТНВЭД = Справочники.КлассификаторТНВЭД.НайтиПоКоду(КодТНВЭД);
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Предназначена для поиска по коду элемента в Классификаторе ТН ВЭД.
// Если элемент не найден, то, при использовании классификатора, создать элемент справочника в соответствии с классификатором ТН ВЭД ЕАЭС.
// 
// Параметры:
//  КодТНВЭД - Строка - Строка с кодом классификатора ТН ВЭД.
//  ДанныеЭлемента - Структура - Переопределяемый параметр, содержащий структуру со свойствами:
//   * ЭлементСправочника - Произвольный - Ссылка на элемент классификатора.
//   * НаименованиеПолное - Строка - наименование найденного элемента классификатора.
//  Наименование - Строка - Наименование элемента классификатора ТН ВЭД по данным ГИС МТ.
Процедура ПриОпределенииСопоставленногоКлассификатораТНВЭД(КодТНВЭД, ДанныеЭлемента, Наименование = "") Экспорт
	
	//++ НЕ ГОСИС
	
	ЭлементСправочника = ИнтеграцияИСМПУТ.ПриОпределенииСопоставленногоКлассификатораТНВЭД(КодТНВЭД, Наименование);
	
	Если ЭлементСправочника <> Неопределено Тогда
		ДанныеЭлемента.ЭлементСправочника = ЭлементСправочника;
		ДанныеЭлемента.НаименованиеПолное = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементСправочника, "НаименованиеПолное");
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Предназначена для получения объема маркируемой продукции в литрах.
// 
// Параметры:
//  Таблица - ТаблицаЗначений - Таблица с колонками:
//   * Номенклатура - ОпределяемыйТип.Номенклатура - Ссылка на маркируемую продукцию.
//   * ОбъемВЛитрах - Число - Объем в литрах, который необходимо заполнить.

Процедура ОбъемМаркируемойПродукцииВЛитрах(Таблица) Экспорт
	
	//++ НЕ ГОСИС
	
	ИнтеграцияИСУТ.ОбъемМаркируемойПродукцииВЛитрах(Таблица);
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

#Область КаталогGS46

// Заполняет свойства номенклатуры, используемые для передачи в каталог GS46. Могут быть заполнены колонки:
//   * Торговая марка,
//   * Страна производства,
//   * Вид обуви,
//   * Материал верха,
//   * Материал подкладки,
//   * Материал низа,
//   * Цвет,
//   * Размер.
// 
// Параметры:
//   Товары - ДанныеФормыКоллекция - таблица для заполнения.
//
Процедура ЗаполнитьСвойстваНоменклатурыДляКаталогаGS46(Товары) Экспорт
	
	//++ НЕ ГОСИС
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Товары.Номенклатура   КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.КодТНВЭД       КАК КодТНВЭД,
	|	Товары.GTIN           КАК GTIN
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.GTIN                                           КАК GTIN,
	|	Товары.Номенклатура                                   КАК Номенклатура,
	|	Товары.Характеристика                                 КАК Характеристика,
	|	Товары.КодТНВЭД                                       КАК КодТНВЭД,
	|	ПРЕДСТАВЛЕНИЕ(СправочникНоменклатура.ВидНоменклатуры) КАК ВидОбуви,
	|	ПРЕДСТАВЛЕНИЕ(ХарактеристикиНоменклатуры.Ссылка)      КАК Размер,
	|	ПРЕДСТАВЛЕНИЕ(СправочникНоменклатура.Ссылка)          КАК Наименование,
	|	СправочникНоменклатура.Марка                          КАК ТорговаяМарка
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО Товары.Характеристика = ХарактеристикиНоменклатуры.Ссылка";
	Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Для Каждого СтрокаТовар Из Товары Цикл
		СтрокаТовар.Наименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
			СтрокаТовар.Наименование,
			СтрокаТовар.Размер);
	КонецЦикла;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ЗагрузитьПолученныеGTINКаталогаGS46(Товары) Экспорт
	
	//++ НЕ ГОСИС
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.GTIN КАК GTIN
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.GTIN                                           КАК Штрихкод,
	|	Товары.Номенклатура                                   КАК Номенклатура,
	|	Товары.Характеристика                                 КАК Характеристика
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК Штрихкоды
	|		ПО Товары.GTIN = Штрихкоды.Штрихкод
	|ГДЕ
	|	Штрихкоды.Штрихкод ЕСТЬ NULL";
	
	Набор = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьНаборЗаписей();
	СтрокаНабора = Набор.Добавить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СтрокаНабора, Выборка);
		Набор.Отбор.Штрихкод.Установить(Выборка.Штрихкод, Истина);
		Набор.Записать();
	КонецЦикла;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область УпаковкиНоменклатуры

// Обработчик события получения сведений об иерархии упаковок номенклатуры.
// Если обработчик пустой, то подсистема виртуальной агрегации не сможет автоматически распределять
// коды маркировки по упаковкам. В этом случае будет возможна только ручная агрегация.
//
// Параметры:
//  Номенклатура         - Массив из ОпределяемыйТип.Номенклатура - Номенклатура [Входящий]
//  УпаковкиНоменклатуры - ТаблицаЗначений - сведения об упаковках [Исходящий], должны быть отсортированы по возрастанию коэффициента упаковки:
//   * Номенклатура       - ОпределяемыйТип.Номенклатура - номенклатура упаковки,
//   * Упаковка           - ОпределяемыйТип.Упаковка - упаковка,
//   * РодительУпаковки   - ОпределяемыйТип.Упаковка - родительская упаковка,
//   * ЕдиницаИзмерения   - Строка - наименование единицы измерения упаковки,
//   * Наименование       - Строка - наименование упаковки,
//   * КоличествоУпаковок - Число - количество упаковок, содержащихся в родительской упаковке,
//   * Коэффициент        - Число - коэффициент пересчета в единицу измерения номенклатуры.
//
Процедура ПриОпределенииИерархииУпаковокНоменклатуры(Номенклатура, УпаковкиНоменклатуры) Экспорт
	
	//++ НЕ ГОСИС
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	Упаковки.Ссылка КАК Упаковка,
	|	Упаковки.Родитель КАК РодительУпаковки,
	|	Упаковки.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	|	Упаковки.Наименование КАК Наименование,
	|	Упаковки.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Упаковки.Числитель / ВЫБОР
	|		КОГДА Упаковки.Знаменатель = 0
	|			ТОГДА 1
	|		ИНАЧЕ Упаковки.Знаменатель
	|	КОНЕЦ КАК Коэффициент
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК Упаковки
	|		ПО (ВЫБОР
	|				КОГДА Номенклатура.НаборУпаковок = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|					ТОГДА Номенклатура.Ссылка = Упаковки.Владелец
	|				КОГДА Номенклатура.НаборУпаковок <> ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ПустаяСсылка)
	|					ТОГДА Номенклатура.НаборУпаковок = Упаковки.Владелец
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|			И (НЕ Упаковки.ПометкаУдаления)
	|			И (Упаковки.ТипУпаковки <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто))
	|ГДЕ
	|	Номенклатура.Ссылка В (&Номенклатура)
	|	И Номенклатура.ИспользоватьУпаковки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Коэффициент";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.Текст = ТекстЗапроса;
	
	УпаковкиНоменклатуры = Запрос.Выполнить().Выгрузить();
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Наборы

// Обработчик события получения сведений о комплектующих набора. Данные о комплектующих могут быть
// получены из вариантов комплектации (ERP, УНФ) при создании наборов оптовиками и розничными магазинами из введенных в оборот товаров
// и могут быть получены из производственных спецификаций при производстве наборов и их комплектующих.
// Если обработчик пустой, то в документе маркировки возможно ручное создание наборов, без проверки принадлежности.
//
// Параметры:
//  Наборы - ТаблицаЗначений, ДанныеФормыКоллекция, Массив - массив строк [Входящий]:
//   * НомерСтроки         - Число - уникальный номер строки с набором,
//   * Номенклатура        - ОпределяемыйТип.Номенклатура - номенклатура набора,
//   * Характеристика      - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика набора,
//   * Упаковка            - ОпределяемыйТип.Упаковка - упаковка набора,
//   * КоличествоУпаковок  - Число - количество упаковок набора,
//   * Количество          - Число - количество наборов.
//  КомплектующиеНаборов - ТаблицаЗначений - сведения о наборах [Исходящий], должны быть отсортированы по убыванию номера строки набора:
//   * НомерСтрокиНабора            - Число - уникальный номер строки с набором,
//   * НоменклатураНабора           - ОпределяемыйТип.Номенклатура - номенклатура набора,
//   * ХарактеристикаНабора         - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика набора,
//   * УпаковкаНабора               - ОпределяемыйТип.Упаковка - упаковка набора,
//   * НомерСтрокиКомплектации      - Число - порядковый номер строки комплектации,
//   * Номенклатура                 - ОпределяемыйТип.Номенклатура - номенклатура комплектующей набора,
//   * Характеристика               - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика комплектующей набора,
//   * Упаковка                     - ОпределяемыйТип.Упаковка - упаковка комплектующей набора,
//   * КоличествоУпаковок           - Число - количество упаковок комплектующей набора,
//   * Количество                   - Число - количество комплектующей набора.
Процедура ПриОпределенииКомплектующихНаборов(Наборы, КомплектующиеНаборов) Экспорт
	
	//++ НЕ ГОСИС
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтрокиНабора,
	|	ТаблицаТоваров.Номенклатура КАК НоменклатураНабора,
	|	ТаблицаТоваров.Характеристика КАК ХарактеристикаНабора,
	|	ТаблицаТоваров.Упаковка КАК УпаковкаНабора,
	|	ТаблицаТоваров.КоличествоУпаковок КАК КоличествоУпаковокНабора,
	|	ТаблицаТоваров.Количество КАК КоличествоНаборов
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтрокиНабора КАК НомерСтрокиНабора,
	|	ТаблицаТоваров.НоменклатураНабора КАК НоменклатураНабора,
	|	ТаблицаТоваров.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	ТаблицаТоваров.УпаковкаНабора КАК УпаковкаНабора,
	|	МИНИМУМ(ВариантыКомплектацииНоменклатурыТовары.НомерСтроки) КАК НомерСтрокиКомплектации,
	|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура КАК Номенклатура,
	|	ВариантыКомплектацииНоменклатурыТовары.Характеристика КАК Характеристика,
	|	ВариантыКомплектацииНоменклатурыТовары.Упаковка КАК Упаковка,
	|	ТаблицаТоваров.КоличествоУпаковокНабора / ВариантыКомплектацииНоменклатуры.КоличествоУпаковок *
	|		СУММА(ВариантыКомплектацииНоменклатурыТовары.КоличествоУпаковок) КАК КоличествоУпаковок,
	|	ТаблицаТоваров.КоличествоНаборов / ВариантыКомплектацииНоменклатуры.Количество *
	|		СУММА(ВариантыКомплектацииНоменклатурыТовары.Количество) КАК Количество
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|		ПО (ВариантыКомплектацииНоменклатуры.Владелец = ТаблицаТоваров.НоменклатураНабора)
	|		И (ВариантыКомплектацииНоменклатуры.Характеристика = ТаблицаТоваров.ХарактеристикаНабора)
	|		И (ВариантыКомплектацииНоменклатуры.Упаковка = ТаблицаТоваров.УпаковкаНабора)
	|		И (ВариантыКомплектацииНоменклатуры.Основной)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК ВариантыКомплектацииНоменклатурыТовары
	|		ПО (ВариантыКомплектацииНоменклатурыТовары.Ссылка = ВариантыКомплектацииНоменклатуры.Ссылка)
	|		И
	|			ВариантыКомплектацииНоменклатурыТовары.Номенклатура.ОсобенностьУчета = ВариантыКомплектацииНоменклатуры.Владелец.ОсобенностьУчета
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.НомерСтрокиНабора,
	|	ТаблицаТоваров.НоменклатураНабора,
	|	ТаблицаТоваров.ХарактеристикаНабора,
	|	ТаблицаТоваров.УпаковкаНабора,
	|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура,
	|	ВариантыКомплектацииНоменклатурыТовары.Характеристика,
	|	ВариантыКомплектацииНоменклатурыТовары.Упаковка,
	|	ТаблицаТоваров.КоличествоУпаковокНабора,
	|	ТаблицаТоваров.КоличествоНаборов,
	|	ВариантыКомплектацииНоменклатуры.КоличествоУпаковок,
	|	ВариантыКомплектацииНоменклатуры.Количество";
	
	ТаблицаТоваров = Новый ТаблицаЗначений;
	ТаблицаТоваров.Колонки.Добавить("НомерСтроки",         ОбщегоНазначения.ОписаниеТипаЧисло(5));
	ТаблицаТоваров.Колонки.Добавить("Номенклатура",        Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ТаблицаТоваров.Колонки.Добавить("Характеристика",      Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ТаблицаТоваров.Колонки.Добавить("Упаковка",            Метаданные.ОпределяемыеТипы.Упаковка.Тип);
	ТаблицаТоваров.Колонки.Добавить("КоличествоУпаковок",  ОбщегоНазначения.ОписаниеТипаЧисло(15,3));
	ТаблицаТоваров.Колонки.Добавить("Количество",          ОбщегоНазначения.ОписаниеТипаЧисло(15,3));
	Для Каждого Строка Из Наборы Цикл
		НоваяСтрока = ТаблицаТоваров.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	Запрос.Текст = ТекстЗапроса;
	КомплектующиеНаборов = Запрос.Выполнить().Выгрузить();
	

	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти


#Область ПанельАдминистрированияИСМП

// Предназначения для управления признаком возможности включения / отключения ведения учета МРЦ табачной продукции.
// При заполнении причины - соответствующая доступность изменяется, на форме отображатеся указанная причина.
// Например, можно запретить отключение функции, если ведется учет МРЦ в составе серий или характеристик.
// 
//Параметры:
//  ВозможноВключение              - Булево - Признак возможности включения.
//  ПричинаНевозможностиВключения  - Строка - Причина, по которой невозможно включить учет МРЦ.
//  ВозможноОтключение             - Булево - Признак возможности отключения.
//  ПричинаНевозможностиОтключения - Строка - Причина, по которой невозможно выключить учет МРЦ.
Процедура ПриОпределенииВозможностиВключенияОтключенияВеденияУчетаМРЦ(ВозможноВключение, ПричинаНевозможностиВключения, ВозможноОтключение, ПричинаНевозможностиОтключения) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияИСМПУТ.ПриОпределенииВозможностиВключенияОтключенияВеденияУчетаМРЦ(
		ВозможноВключение,
		ПричинаНевозможностиВключения,
		ВозможноОтключение,
		ПричинаНевозможностиОтключения);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область МаркировкаОстатков

// Определяет ссылку на документ-основание маркировки товаров, как документ, являющийся основанием для маркировки остатков.
// 
// Параметры:
// 	СсылкаНаДокумент   - ОпределяемыйТип.ОснованиеМаркировкаТоваровИСМП - Ссылка на проверямый документ.
// 	ЯвляетсяОснованием - Булево                                         - Выходной параметр.
Процедура ЯвляетсяОснованиемДляМаркировкиОстатков(СсылкаНаДокумент, ЯвляетсяОснованием) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияИСМПУТ.ЯвляетсяОснованиемДляМаркировкиОстатков(СсылкаНаДокумент, ЯвляетсяОснованием);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаСредствамиККТ

// При определении текста запроса платежных документов по документу продажи или возврата.
// Определяет текст запроса получения ссылок на платежные документы, из которых могла выполняться проверка средствами ККТ при пробитии чека, для отображения результатов проверки при открытии формы проверки.
// 
// Используется в случае наличия функционала, при котором возможно пробитие чека на ККТ из платежного документа, связанного
// с товароучетным документом, в котором присутствуют коды маркировки, и при заполнении параметров сканирования платежного документа используется
// ссылка на платежный документ (ПараметрыСканирования.СсылкаНаДокумент), а не ссылка на товароучетный документ.
// Например: Приходный кассовый ордер может быть оформлен по нескольким документам Реализации товара с кодами маркировки,
// при этом при заполнении параметров сканирования для ПКО ПараметрыСканирования.СсылкаНаДокумент - устанавливается ссылка
// на ПКО. В этом случае, в переопределеннии необходимо дополнить текст запроса для получения документов ПКО,
// связанными с текущей реализацией. Возможен аналогичный сценарий с РКО и Возвратом.
//
// Текст запроса присоединяется конструкцией ОБЪЕДИНИТЬ ВСЕ, должен содержать единственное поле поле со ссылкой на платежный документ
// типа ОпределяемыйТип.ОснованиеФискальнойОперацииИСМП.
// В запросе установлен параметр &СсылкаНаДокумент значением параметра СсылкаНаДокумент.
// 
// Параметры:
//  СсылкаНаДокумент                - ОпределяемыйТип.ОснованиеФискальнойОперацииИСМП - Ссылка на товароучетный документ.
//  ТекстЗапросаПлатежныхДокументов - Строка - Текст запроса платежных документов по товароучетному
Процедура ПриОпределенииТекстаЗапросаПлатежныхДокументовПоДокументуПродажиИлиВозврата(СсылкаНаДокумент, ТекстЗапросаПлатежныхДокументов) Экспорт
	
	//++ НЕ ГОСИС
	
	Если ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
	
		ТекстЗапросаПлатежныхДокументов =
			"ВЫБРАТЬ
			|	ОперацияПоПлатежнойКартеРасшифровкаПлатежа.Ссылка
			|ИЗ
			|	Документ.ОперацияПоПлатежнойКарте.РасшифровкаПлатежа КАК ОперацияПоПлатежнойКартеРасшифровкаПлатежа
			|ГДЕ
			|	ОперацияПоПлатежнойКартеРасшифровкаПлатежа.Ссылка.Проведен
			|	И ОперацияПоПлатежнойКартеРасшифровкаПлатежа.ОснованиеПлатежа = &СсылкаНаДокумент
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка
			|ИЗ
			|	Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК ПриходныйКассовыйОрдерРасшифровкаПлатежа
			|ГДЕ
			|	ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Проведен
			|	И ПриходныйКассовыйОрдерРасшифровкаПлатежа.ОснованиеПлатежа = &СсылкаНаДокумент"
		
		
	ИначеЕсли ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
		
		ТекстЗапросаПлатежныхДокументов =
			"ВЫБРАТЬ
			|	ОперацияПоПлатежнойКартеРасшифровкаПлатежа.Ссылка КАК ПлатежныйДокумент
			|ИЗ
			|	Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОперацияПоПлатежнойКарте.РасшифровкаПлатежа КАК
			|			ОперацияПоПлатежнойКартеРасшифровкаПлатежа
			|		ПО ОбъектыРасчетов.Ссылка = ОперацияПоПлатежнойКартеРасшифровкаПлатежа.ОбъектРасчетов
			|ГДЕ
			|	ОбъектыРасчетов.Объект = &СсылкаНаДокумент
			|	И ОперацияПоПлатежнойКартеРасшифровкаПлатежа.Ссылка.Проведен
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка КАК ПлатежныйДокумент
			|ИЗ
			|	Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК
			|			РасходныйКассовыйОрдерРасшифровкаПлатежа
			|		ПО ОбъектыРасчетов.Ссылка = РасходныйКассовыйОрдерРасшифровкаПлатежа.ОбъектРасчетов
			|ГДЕ
			|	ОбъектыРасчетов.Объект = &СсылкаНаДокумент
			|	И РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Проведен"
		
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийДокументов

//Вызывается при вводе документа на основании, при выполнении метода Заполнить или при интерактивном вводе нового.
//
//Параметры:
//   ДокументОбъект - ДокументОбъект - заполняемый документ,
//   ДанныеЗаполнения - Произвольный - значение, которое используется как основание для заполнения,
//   ТекстЗаполнения - Строка, Неопределено - текст, используемый для заполнения документа,
//   СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполненияДокумента(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	//++ НЕ ГОСИС
	ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ДанныеЗаполнения.Свойство("Организация", ДокументОбъект.Организация);
	КонецЕсли;
	
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ЗаказНаЭмиссиюКодовМаркировкиСУЗ") Тогда
		ИнтеграцияИСМПУТ.ОбработкаЗаполненияДокументаЗаказНаЭмиссиюКодовМаркировкиСУЗ(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.МаркировкаТоваровИСМП") Тогда
		ИнтеграцияИСМПУТ.ОбработкаЗаполненияДокументаМаркировкаТоваровИСМП(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.СписаниеКодовМаркировкиИСМП") Тогда
		ИнтеграцияИСМПУТ.ОбработкаЗаполненияДокументаСписаниеКодовМаркировкиИСМП(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ВыводИзОборотаИСМП") Тогда
		ИнтеграцияИСМПУТ.ОбработкаЗаполненияДокументаВыводИзОборотаИСМП(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПеремаркировкаТоваровИСМП") Тогда
		ИнтеграцияИСМПУТ.ОбработкаЗаполненияДокументаПеремаркировкаТоваровИСМП(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ВозвратВОборотИСМП") Тогда
		ИнтеграцияИСМПУТ.ОбработкаЗаполненияДокументаВозвратВОборотИСМП(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ОтгрузкаТоваровИСМП") Тогда
		ИнтеграцияИСМПУТ.ОбработкаЗаполненияДокументаОтгрузкаТоваровИСМП(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.УточнениеСведенийОКодахМаркировкиИСМП") Тогда
		ИнтеграцияИСМПУТ.ОбработкаЗаполненияДокументаУточнениеСведенийОКодахМаркировкиИСМП(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ЗаказНаЭмиссиюКодовМаркировкиСУЗ")
			ИЛИ ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.МаркировкаТоваровИСМП")
			ИЛИ ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.СписаниеКодовМаркировкиИСМП")
			ИЛИ ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ВыводИзОборотаИСМП")
			ИЛИ ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПеремаркировкаТоваровИСМП")
			ИЛИ ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ВозвратВОборотИСМП")
			ИЛИ ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ОтгрузкаТоваровИСМП")
			ИЛИ ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.УточнениеСведенийОКодахМаркировкиИСМП") Тогда
				ДокументОбъект.Организация = Справочники.Организации.ПолучитьОрганизациюПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийДокументов

//Вызывается при выполнении заполнения набора из какого-либо значения.
//
//Параметры:
//   РегистрСведенийНаборЗаписей - РегистрСведенийНаборЗаписей - заполняемый регистр сведений,
//   ДанныеЗаполнения - Произвольный - значение, которое используется как основание для заполнения,
//   СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполненияРегистраСведений(РегистрСведенийНаборЗаписей, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполнения = Новый Структура;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ДанныеЗаполнения.Вставить("Организация", Справочники.Организации.ПолучитьОрганизациюПоУмолчанию());
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;

КонецПроцедуры

#КонецОбласти

#Область ТипыРасхожденийКодовМаркировки

// Реализовать получение значение Брак определяемого типа ТипРасхожденияИСМП.
// Параметры:
//  ТипРасхождения - ОпределяемыйТип.ТипРасхожденияИСМП - для определения типа расхождения
Процедура ПриОпределенииТипаРасхожденияИСМПБрак(ТипРасхождения) Экспорт
	
	//++ НЕ ГОСИС
	ТипРасхождения = ИнтеграцияИСМПУТ.ТипРасхожденияИСМПБрак();
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Реализовать получение значение Излишек определяемого типа ТипРасхожденияИСМП.
// Параметры:
//  ТипРасхождения - ОпределяемыйТип.ТипРасхожденияИСМП - для определения типа расхождения
Процедура ПриОпределенииТипаРасхожденияИСМПИзлишек(ТипРасхождения) Экспорт
	
	//++ НЕ ГОСИС
	ТипРасхождения = ИнтеграцияИСМПУТ.ТипРасхожденияИСМПИзлишек();
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Реализовать получение значение Недостача определяемого типа ТипРасхожденияИСМП.
// Параметры:
//  ТипРасхождения - ОпределяемыйТип.ТипРасхожденияИСМП - для определения типа расхождения
//  
Процедура ПриОпределенииТипаРасхожденияИСМПНедостача(ТипРасхождения) Экспорт
	
	//++ НЕ ГОСИС
	ТипРасхождения = ИнтеграцияИСМПУТ.ТипРасхожденияИСМПНедостача();
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныйПрограммныйИнтерфейс

#Область Отладка

Процедура ПриОпределенииПутиКФайлуЛогирования(ПутьКФайлу) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывается расширением формы при необходимости проверки заполнения реквизитов при записи или при проведении документа в форме,
// а также при выполнении метода ПроверитьЗаполнение.
//
// Параметры:
//  ДокументОбъект - ДокументОбъект - проверяемый документ,
//  Отказ - Булево - признак отказа от проведения документа,
//  ПроверяемыеРеквизиты - Массив - массив путей к реквизитам, для которых будет выполнена проверка заполнения,
//  МассивНепроверяемыхРеквизитов - Массив - массив путей к реквизитам, для которых не будет выполнена проверка заполнения.
Процедура ПриОпределенииОбработкиПроверкиЗаполнения(ДокументОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов) Экспорт
	
	//++ НЕ ГОСИС
	Если    ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ЗаказНаЭмиссиюКодовМаркировкиСУЗ")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.МаркировкаТоваровИСМП")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ВыводИзОборотаИСМП")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.СписаниеКодовМаркировкиИСМП")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ОтгрузкаТоваровИСМП")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПриемкаТоваровИСМП")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.УточнениеСведенийОКодахМаркировкиИСМП") Тогда
		
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ДокументОбъект, МассивНепроверяемыхРеквизитов, Отказ);
		
	КонецЕсли;
	
	Если    ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ЗаказНаЭмиссиюКодовМаркировкиСУЗ")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ОтгрузкаТоваровИСМП") Тогда
		
		НоменклатураСервер.ПроверитьЗаполнениеКоличества(ДокументОбъект, ПроверяемыеРеквизиты, Отказ);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#Область ЭлектроннаяПодпись

// Предназначена для получения сертификата на компьютере по строке отпечатка.
// (См. ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку)
//
// Параметры:
//   Сертификат             - СертификатКриптографии - найденный сертификат электронной подписи и шифрования.
//   Отпечаток              - Строка - Base64 кодированный отпечаток сертификата.
//   ТолькоВЛичномХранилище - Булево - если Истина, тогда искать в личном хранилище, иначе везде.
//   СтандартнаяОбработка   - Булево - признак обработки стандартной библиотекой (установить Ложь при переопределении)
//
Процедура ПриОпределенииСертификатаПоОтпечатку(Сертификат, Отпечаток, ТолькоВЛичномХранилище, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Процедура заполняет признак использования производства на стороне.
//
// Параметры:
//  Используется - Булево - Признак использования производства на стороне.
Процедура ИспользуетсяПереработкаНаСтороне(Используется) Экспорт

	//++ НЕ ГОСИС
	
	Используется = Истина;
	

	//-- НЕ ГОСИС
	Возврат;

КонецПроцедуры

// Процедура заполняет признак использования производственного объекта.
//
// Параметры:
//  Используется - Булево - Признак использования производственного объекта.
Процедура ПриОпределенииИспользованияПроизводственногоОбъекта(Используется) Экспорт

	//++ НЕ ГОСИС

	Используется = ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения");

	//-- НЕ ГОСИС
	Возврат;

КонецПроцедуры

// Процедура заполняет признак использования передачи товаров между организациями.
// Вызывается из документа ОтгрузкаТоваровИСМП для определения доступных типов элемента формы Контрагент.
//
// Параметры:
//  Используется - Булево - Признак использования передачи товаров между организациями, значение по умолчанию Ложь.
Процедура ПриОпределенииИспользованияПередачиТоваровМеждуОрганизациями(Используется) Экспорт
	
	//++ НЕ ГОСИС
	
	Используется = ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями");
	
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ПриОпределенииСкладаДокументаОснования(Склад, ДокументОснование) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияИСМПУТ.ОпределитьСкладДокументаОснования(Склад, ДокументОснование);
	//-- НЕ ГОСИС
	
КонецПроцедуры

Процедура ЗаполнитьКодыТНВЭДПоНоменклатуреВТабличнойЧасти(ТабличнаяЧасть) Экспорт
	
	//++ НЕ ГОСИС
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Товары.НомерСтроки,
	|	Товары.Номенклатура
	|ПОМЕСТИТЬ вт_Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт_Товары.НомерСтроки КАК НомерСтроки,
	|	вт_Товары.Номенклатура,
	|	вт_Товары.Номенклатура.КодТНВЭД.Код КАК КодТНВЭД
	|ИЗ
	|	вт_Товары КАК вт_Товары
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("Товары", ТабличнаяЧасть.Выгрузить(, "НомерСтроки, Номенклатура"));
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ТабличнаяЧасть[Выборка.НомерСтроки - 1].КодТНВЭД = Выборка.КодТНВЭД;
	КонецЦикла;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти