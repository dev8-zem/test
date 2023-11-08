#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("МеждународныйУчет");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("СебестоимостьИПартионныйУчет");
	МеханизмыДокумента.Добавить("УчетДоходовРасходов");
	МеханизмыДокумента.Добавить("УчетНДС");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов:
//     * Ключ - Строка - Имя таблицы.
//     * Значение - ТаблицаЗначений - таблица данных для отражения в регистр.
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
		
		ТекстЗапросаТаблицаНДСПредъявленный(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДвиженияПоНДС(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
		
		ПроведениеДокументов.ДобавитьЗапросыСторноДвижений(Запрос, ТекстыЗапроса, Регистры, ПустаяСсылка().Метаданные());
		
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции


#КонецОбласти

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	ИсправлениеДокументов.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.НачислениеРеверсивногоНДС);
	
КонецПроцедуры

// Добавляет команду создания документа "Начисление реверсивного НДС".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
// Возвращаемое значение:  
//	 СтрокаТаблицыЗначений, Неопределено - команда для вывода в подменю.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.НачислениеРеверсивногоНДС) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.НачислениеРеверсивногоНДС.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.НачислениеРеверсивногоНДС);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьРеверсивноеОбложениеНДС";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Возвращает параметры формирования списка документов для начисления реверсивного НДС
//
// Возвращаемое значение:
// 	Структура - Параметры проверки:
// 		* Организация - СправочникСсылка.Организации - Отбор по организации. Если Неопределено, то по всем.
// 		* Контрагент - СправочникСсылка.Контрагенты - Отбор по контрагенту. Если Неопределено, то по всем.
// 		* НачалоПериода - Дата - Отбор документов старше указанной даты.
// 		* КонецПериода - Дата - Отбор документов младше указанной даты.
//
Функция ПараметрыФормированияСпискаДокументовДляНачисленияРеверсивногоНДС() Экспорт
	
	ПараметрыФоновогоЗадания = Новый Структура;
	ПараметрыФоновогоЗадания.Вставить("Организация");
	ПараметрыФоновогоЗадания.Вставить("Контрагент");
	ПараметрыФоновогоЗадания.Вставить("НачалоПериода");
	ПараметрыФоновогоЗадания.Вставить("КонецПериода");
	
	Возврат ПараметрыФоновогоЗадания;
	
КонецФункции

// Формирует список документов для начисления реверсивного НДС
//
// Параметры:
// 	 Параметры - Структура -
//
// Возвращаемое значение:
//	РезультатЗапроса - Результат выполнения запроса
Функция ОбновитьСписокРаспоряжений(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументПоступления.Ссылка КАК ДокументОснование,
	|	ДокументПоступления.Дата КАК Дата,
	|	ДокументПоступления.Организация КАК Организация,
	|	ДокументПоступления.Контрагент КАК Контрагент,
	|	ДокументПоступления.Валюта КАК Валюта,
	|	ДокументПоступления.СуммаДокумента КАК СуммаДокумента
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг КАК ДокументПоступления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НачислениеРеверсивногоНДС КАК НачислениеРеверсивногоНДС
	|		ПО ДокументПоступления.Ссылка = НачислениеРеверсивногоНДС.ДокументОснование 
	|ГДЕ
	|	ДокументПоступления.Проведен
	|	И &УсловиеПоОрганизации
	|	И &УсловиеПоКонтрагенту
	|	И &УсловиеПоДате
	|	И ДокументПоступления.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.РеверсивноеОбложениеНДС)
	|	И НачислениеРеверсивногоНДС.Ссылка ЕСТЬ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДокументПоступления.Ссылка,
	|	ДокументПоступления.Дата,
	|	ДокументПоступления.Организация КАК Организация,
	|	ДокументПоступления.Контрагент,
	|	ДокументПоступления.Валюта,
	|	ДокументПоступления.СуммаДокумента
	|ИЗ
	|	Документ.ПриобретениеУслугПрочихАктивов КАК ДокументПоступления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НачислениеРеверсивногоНДС КАК НачислениеРеверсивногоНДС
	|		ПО ДокументПоступления.Ссылка = НачислениеРеверсивногоНДС.ДокументОснование
	|ГДЕ
	|	ДокументПоступления.Проведен
	|	И &УсловиеПоОрганизации
	|	И &УсловиеПоКонтрагенту
	|	И &УсловиеПоДате
	|	И ДокументПоступления.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.РеверсивноеОбложениеНДС)
	|	И НачислениеРеверсивногоНДС.Ссылка ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДокументПоступления.Ссылка,
	|	ДокументПоступления.Дата,
	|	ДокументПоступления.Организация КАК Организация,
	|	ДокументПоступления.Контрагент,
	|	ДокументПоступления.Валюта,
	|	ДокументПоступления.СуммаДокумента
	|ИЗ
	|	Документ.ВыкупПринятыхНаХранениеТоваров КАК ДокументПоступления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НачислениеРеверсивногоНДС КАК НачислениеРеверсивногоНДС
	|		ПО ДокументПоступления.Ссылка = НачислениеРеверсивногоНДС.ДокументОснование
	|ГДЕ
	|	ДокументПоступления.Проведен
	|	И &УсловиеПоОрганизации
	|	И &УсловиеПоКонтрагенту
	|	И &УсловиеПоДате
	|	И ДокументПоступления.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.РеверсивноеОбложениеНДС)
	|	И НачислениеРеверсивногоНДС.Ссылка ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДокументПоступления.Ссылка,
	|	ДокументПоступления.Дата,
	|	ДокументПоступления.Организация КАК Организация,
	|	ДокументПоступления.Контрагент,
	|	ДокументПоступления.Валюта,
	|	ДокументПоступления.СуммаДокумента
	|ИЗ
	|	Документ.КорректировкаПриобретения КАК ДокументПоступления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НачислениеРеверсивногоНДС КАК НачислениеРеверсивногоНДС
	|		ПО ДокументПоступления.Ссылка = НачислениеРеверсивногоНДС.ДокументОснование
	|ГДЕ
	|	ДокументПоступления.Проведен
	|	И &УсловиеПоОрганизации
	|	И &УсловиеПоКонтрагенту
	|	И &УсловиеПоДате
	|	И ДокументПоступления.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.РеверсивноеОбложениеНДС)
	|	И НачислениеРеверсивногоНДС.Ссылка ЕСТЬ NULL
	|";
	
	Запрос.УстановитьПараметр("Организация", Параметры.Организация);
	Запрос.УстановитьПараметр("Контрагент", Параметры.Контрагент);
	Запрос.УстановитьПараметр("НачалоПериода", Параметры.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", Параметры.КонецПериода);
	
	УсловиеПоОрганизации = "ИСТИНА";
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		
		УсловиеПоОрганизации = "ДокументПоступления.Организация = &Организация";
		
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоОрганизации", УсловиеПоОрганизации);
	
	УсловиеПоКонтрагенту = "ИСТИНА";
	Если ЗначениеЗаполнено(Параметры.Контрагент) Тогда
		
		УсловиеПоКонтрагенту = "ДокументПоступления.Контрагент = &Контрагент";
		
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКонтрагенту", УсловиеПоКонтрагенту);
	
	УсловиеПоДате = "ДокументПоступления.Дата МЕЖДУ &НачалоПериода И &КонецПериода";
	Если НЕ ЗначениеЗаполнено(Параметры.КонецПериода) Тогда
		
		УсловиеПоДате = "ДокументПоступления.Дата >= &НачалоПериода"
		
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоДате", УсловиеПоДате);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

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
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.Исправление КАК Исправление,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Номер КАК НомерНаПечать,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Ответственный КАК Ответственный,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.СуммаНДС КАК СуммаНДС,
	|	ДанныеДокумента.СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	ДанныеДокумента.ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	ДанныеДокумента.Организация.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
	|ИЗ
	|	Документ.НачислениеРеверсивногоНДС КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("Период", Реквизиты.Дата);
	Запрос.УстановитьПараметр("ДатаСоставления", Реквизиты.Период);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.НачислениеРеверсивногоНДС"));
	Запрос.УстановитьПараметр("СтавкаНДС", УчетНДСУП.СтавкаНДСПоУмолчанию(Реквизиты.Организация, Реквизиты.Период, Истина));
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.НачислениеРеверсивногоНДС);
	Запрос.УстановитьПараметр("УправленческийУчетОрганизаций",
		РасчетСебестоимостиПовтИсп.УправленческийУчетОрганизаций(Реквизиты.Период));
	
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка КАК Ссылка,
	|	&Период КАК ДатаДокументаИБ,
	|	&Номер КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	&Организация КАК Организация,
	|	&Контрагент КАК Контрагент,
	|	&Подразделение КАК Подразделение,
	|	&Ответственный КАК Ответственный,
	|	&Комментарий КАК Комментарий,
	|	&СуммаНДС КАК Сумма,
	|	&Проведен КАК Проведен,
	|	&ПометкаУдаления КАК ПометкаУдаления,
	|	"""" КАК Дополнительно,
	|	&Период КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать КАК НомерПервичногоДокумента,
	|	ВЫБОР
	|		КОГДА &Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Контрагент.Партнер
	|		ИНАЧЕ &Партнер
	|	КОНЕЦ КАК Партнер,
	|	ЛОЖЬ КАК ДополнительнаяЗапись,
	|	&Период КАК ДатаОтраженияВУчете,
	|	&Исправление КАК СторноИсправление,
	|	&СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	&ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК Приоритет
	|ИЗ
	|	Документ.НачислениеРеверсивногоНДС КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции


Функция ТекстЗапросаТаблицаНДСПредъявленный(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НДСПредъявленный";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	УстановитьПараметрКоэффициентПересчетаВВалютуУпр(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.ДокументОснование КАК СчетФактура,
	|	ДанныеДокумента.Контрагент КАК Поставщик,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.РеверсивноеОбложениеНДС) КАК ВидЦенности,
	|	Строки.СтавкаНДС КАК СтавкаНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС) КАК ВидДеятельностиНДС,
	|	Строки.НалоговаяБаза КАК СуммаБезНДС,
	|	Строки.СуммаНДС КАК НДС,
	|	НЕОПРЕДЕЛЕНО КАК КорВидДеятельностиНДС,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	"""" КАК ИдентификаторСтроки,
	|	ЛОЖЬ КАК РегламентнаяОперация,
	|	Строки.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	НастройкиХозяйственныхОпераций.Ссылка КАК НастройкаХозяйственнойОперации,
	|	ВЫБОР 
	|		КОГДА &УправленческийУчетОрганизаций 
	|			ТОГДА Строки.СуммаНДС * &КоэффициентПересчетаВВалютуУпр
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НДСУпр
	|ИЗ
	|	Документ.НачислениеРеверсивногоНДС КАК ДанныеДокумента
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.НачислениеРеверсивногоНДС.НачислениеНДС КАК Строки
	|	ПО
	|		Строки.Ссылка = ДанныеДокумента.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|	ПО
	|		НастройкиХозяйственныхОпераций.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|	И (Строки.СуммаНДС <> 0)
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияПоНДС(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияПоНДС";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрКоэффициентПересчетаВВалютуУпр(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейДвиженийПоНДС.Исходящий) КАК ТипЗаписи,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.ДокументОснование КАК СчетФактура,
	|	Строки.СтавкаНДС КАК СтавкаНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.РеверсивноеОбложениеНДС) КАК ВидЦенности,
	|	Строки.НалоговаяБаза КАК СуммаБезНДС,
	|	Строки.СуммаНДС КАК НДС,
	|	ВЫБОР 
	|		КОГДА &УправленческийУчетОрганизаций 
	|			ТОГДА Строки.СуммаНДС * &КоэффициентПересчетаВВалютуУпр
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НДСУпр,
	|	НЕОПРЕДЕЛЕНО КАК ОбъектРасчетов,
	|	ЛОЖЬ КАК РегламентнаяОперация,
	|	Строки.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	НастройкиХозяйственныхОпераций.Ссылка КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.НачислениеРеверсивногоНДС КАК ДанныеДокумента
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.НачислениеРеверсивногоНДС.НачислениеНДС КАК Строки
	|	ПО
	|		Строки.Ссылка = ДанныеДокумента.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|	ПО
	|		НастройкиХозяйственныхОпераций.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И (Строки.СуммаНДС <> 0)
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПартииПрочихРасходов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПартииПрочихРасходов.ТекстЗапросаТаблицаПартииПрочихРасходов();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПартииПрочихРасходов";
	
	ИнициализироватьВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	
	ТекстЗапроса = РегистрыНакопления.ПартииПрочихРасходов.ТекстЗапросаТаблицаВтПартииПрочихРасходов(, Истина);
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ИнициализироватьВтПартииПрочихРасходов(Запрос, ТекстыЗапроса)
	
	Если Запрос.Параметры.Свойство("ВтПартииПрочихРасходовИнициализирована") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрКоэффициентПересчетаВВалютуУпр(Запрос);
	ИнициализироватьКлючиАналитикиУчетаПартийДокумента(Запрос);
	
	ЗапросПартииПрочихРасходов = Новый Запрос;
	ЗапросПартииПрочихРасходов.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
	ЗапросПартииПрочихРасходов.УстановитьПараметр("Ссылка", Запрос.Параметры.Ссылка);
	ЗапросПартииПрочихРасходов.УстановитьПараметр("УправленческийУчетОрганизаций", Запрос.Параметры.УправленческийУчетОрганизаций);
	ЗапросПартииПрочихРасходов.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр", Запрос.Параметры.КоэффициентПересчетаВВалютуУпр);
	ЗапросПартииПрочихРасходов.УстановитьПараметр("ХозяйственнаяОперация", Запрос.Параметры.ХозяйственнаяОперация);
	
	ЗапросПартииПрочихРасходов.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.НДСНалоговогоАгента) КАК СтатьяРасходов,
	|	ДанныеДокумента.ДокументОснование КАК АналитикаРасходов,
	|	ДанныеДокумента.ДокументОснование КАК ДокументПоступленияРасходов,
	|	Аналитика.АналитикаУчетаПартий КАК АналитикаУчетаПартий,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС)КАК ВидДеятельностиНДС,
	|	0 КАК СтоимостьБезНДС,
	|	Строки.СуммаНДС КАК НДСРегл,
	|	ВЫБОР 
	|		КОГДА &УправленческийУчетОрганизаций 
	|			ТОГДА Строки.СуммаНДС * &КоэффициентПересчетаВВалютуУпр
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НДСУпр,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Строки.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	НастройкиХозяйственныхОпераций.Ссылка КАК НастройкаХозяйственнойОперации,
	|	Строки.СуммаНДС * &КоэффициентПересчетаВВалютуУпр КАК СуммаНДСУпр
	|ПОМЕСТИТЬ ВтПартииПрочихРасходовПрочиеРасходы
	|ИЗ
	|	Документ.НачислениеРеверсивногоНДС КАК ДанныеДокумента
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.НачислениеРеверсивногоНДС.НачислениеНДС КАК Строки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтТаблицаАналитикУчетаПартий КАК Аналитика
	|		ПО Строки.ИдентификаторСтроки = Аналитика.НомерСтроки
	|	ПО
	|		Строки.Ссылка = ДанныеДокумента.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|	ПО
	|		НастройкиХозяйственныхОпераций.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И (Строки.СуммаНДС <> 0)
	|";
	
	ЗапросПартииПрочихРасходов.Выполнить();
	НДСПартииПрочихРасходов = РегистрыНакопления.ПартииПрочихРасходов.СоздатьНаборЗаписей();
	НДСПартииПрочихРасходов.Загрузить(РасчетСебестоимостиПрикладныеАлгоритмы.ВыгрузитьВременнуюТаблицу(ЗапросПартииПрочихРасходов.МенеджерВременныхТаблиц, "ВтПартииПрочихРасходовПрочиеРасходы"));
	
	ЗапросПартииПрочихРасходов.УстановитьПараметр("НДСПартииПрочихРасходов", НДСПартииПрочихРасходов);
	ЗапросПартииПрочихРасходов.Текст = 
	"ВЫБРАТЬ
	|	ПартииПрочихРасходов.АналитикаРасходов,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ПустаяСсылка) КАК АналитикаАктивовПассивов,
	|	ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка) КАК АналитикаУчетаНоменклатуры,
	|	ПартииПрочихРасходов.АналитикаУчетаПартий,
	|	ПартииПрочихРасходов.ВидДвижения,
	|	ПартииПрочихРасходов.ВременнаяРазница,
	|	ПартииПрочихРасходов.ДокументПоступленияРасходов,
	|	ПартииПрочихРасходов.ВидДеятельностиНДС,
	|	ПартииПрочихРасходов.НДСРегл,
	|	ПартииПрочихРасходов.НДСУпр,
	|	ПартииПрочихРасходов.НалогообложениеНДС,
	|	ПартииПрочихРасходов.НомерСтроки,
	|	ПартииПрочихРасходов.Организация,
	|	ПартииПрочихРасходов.Период,
	|	ПартииПрочихРасходов.Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельности,
	|	ПартииПрочихРасходов.ПостояннаяРазница,
	|	ПартииПрочихРасходов.Регистратор,
	|	ПартииПрочихРасходов.СтатьяРасходов,
	|	ПартииПрочихРасходов.Стоимость,
	|	ПартииПрочихРасходов.СтоимостьБезНДС,
	|	ПартииПрочихРасходов.СтоимостьРегл,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПустаяСсылка) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.ПустаяСсылка) КАК НастройкаХозяйственнойОперации,
	|	"""" КАК ИдентификаторФинЗаписи
	|ПОМЕСТИТЬ ВтИсходныеПартииПрочихРасходов
	|ИЗ
	|	&НДСПартииПрочихРасходов КАК ПартииПрочихРасходов";
	
	ЗапросПартииПрочихРасходов.Выполнить();
	
	МассивПериодов = Новый Массив;
	МассивПериодов.Добавить(Запрос.Параметры.ДатаСоставления);

	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализацииПоПериодам(
		Запрос,
		Запрос.Параметры,
		МассивПериодов);
	
	Запрос.УстановитьПараметр("ВтПартииПрочихРасходовИнициализирована", Истина);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаПрочиеРасходы("ИдентификаторСтроки");
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПрочиеРасходы";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтИсходныеПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаВтПрочиеРасходы("ИдентификаторСтроки");
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПрочиеРасходы";
	
	ИнициализироватьВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 0
	|	ТаблицаРасходов.Период КАК Период,
	|	ТаблицаРасходов.ВидДвижения КАК ВидДвижения,
	|	ТаблицаРасходов.Организация КАК Организация,
	|	ТаблицаРасходов.Подразделение КАК Подразделение,
	|	ТаблицаРасходов.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаРасходов.СтатьяРасходов КАК СтатьяРасходов,
	|	ТаблицаРасходов.АналитикаРасходов КАК АналитикаРасходов,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК ВидДеятельностиНДС,
	|
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаБезНДС,
	|	0 КАК СуммаБезНДСУпр,
	|
	|	0 КАК СуммаСНДСРегл,
	|	0 КАК СуммаБезНДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|
	|	ТаблицаРасходов.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ТаблицаРасходов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	
	|	"""" КАК ИдентификаторСтроки,
	|	"""" КАК ИдентификаторФинЗаписи,
	|	ТаблицаРасходов.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации 
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходы КАК ТаблицаРасходов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаРасходов.Период КАК Период,
	|	ТаблицаРасходов.ВидДвижения КАК ВидДвижения,
	|	ТаблицаРасходов.Организация КАК Организация,
	|	ТаблицаРасходов.Подразделение КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	ТаблицаРасходов.СтатьяРасходов КАК СтатьяРасходов,
	|	ТаблицаРасходов.АналитикаРасходов КАК АналитикаРасходов,
	|	ТаблицаРасходов.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
	|
	|	СУММА(ТаблицаРасходов.СуммаНДСУпр) КАК СуммаСНДС,
	|	0 КАК СуммаБезНДС,
	|	0 КАК СуммаБезНДСУпр,
	|
	|	СУММА(ТаблицаРасходов.НДСРегл) КАК СуммаСНДСРегл,
	|	0 КАК СуммаБезНДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	NULL КАК АналитикаУчетаНоменклатуры,
	|	
	|	"""" КАК ИдентификаторСтроки,
	|	ТаблицаРасходов.ИдентификаторФинЗаписи КАК ИдентификаторФинЗаписи,
	|	НЕОПРЕДЕЛЕНО КАК НастройкаХозяйственнойОперации 
	|
	|ИЗ
	|	ВтПартииПрочихРасходовПрочиеРасходы КАК ТаблицаРасходов
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРасходов.Период,
	|	ТаблицаРасходов.ВидДвижения,
	|	ТаблицаРасходов.Организация,
	|	ТаблицаРасходов.Подразделение,
	|	ТаблицаРасходов.СтатьяРасходов,
	|	ТаблицаРасходов.АналитикаРасходов,
	|	ТаблицаРасходов.ВидДеятельностиНДС,
	|	ТаблицаРасходов.ИдентификаторФинЗаписи
	|";

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура УстановитьПараметрКоэффициентПересчетаВВалютуУпр(Запрос)
	
	Если Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуУпр") Тогда
		Возврат;
	КонецЕсли;
	
	КоэффициентПересчетаВВалютуУпр = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
										Запрос.Параметры.ВалютаРегламентированногоУчета,
										Константы.ВалютаУправленческогоУчета.Получить(),
										Запрос.Параметры.Период);
										
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр", КоэффициентПересчетаВВалютуУпр);
	
КонецПроцедуры

Процедура ИнициализироватьКлючиАналитикиУчетаПартийДокумента(Запрос)
	
	Если Запрос.Параметры.Свойство("КлючиАналитикиУчетаПартийДокументаИнициализированы") Тогда
		Возврат;
	КонецЕсли;
	
	// Создадим временную таблицу "ВтТаблицаАналитикУчетаПартий"
	
	УстановитьПараметрЗапросаНалогообложениеОрганизации(Запрос);
	
	ТекстВыборкаПоляАналитик =
	"ВЫБРАТЬ
	|	Строки.ИдентификаторСтроки КАК НомерСтроки,
	|	""НачислениеНДС"" КАК ИмяТабличнойЧасти,
	|	ДанныеДокумента.Партнер КАК Поставщик,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС) КАК НалогообложениеНДС,
	|	Строки.СтавкаНДС КАК СтавкаНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.РеверсивноеОбложениеНДС) КАК ВидЦенности,
	|	0 КАК КодСтроки
	|ПОМЕСТИТЬ ВТПоляАналитикУчетаПартий
	|ИЗ
	|	Документ.НачислениеРеверсивногоНДС КАК ДанныеДокумента
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.НачислениеРеверсивногоНДС.НачислениеНДС КАК Строки
	|	ПО
	|		Строки.Ссылка = ДанныеДокумента.Ссылка
	|";
	
	ТекстЗапроса = Справочники.КлючиАналитикиУчетаПартий.ТекстЗапросаВтТаблицаАналитикУчетаПартий(ТекстВыборкаПоляАналитик, Запрос);
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
	
	Запрос.УстановитьПараметр("КлючиАналитикиУчетаПартийДокументаИнициализированы", Истина);
	
КонецПроцедуры

Процедура УстановитьПараметрЗапросаНалогообложениеОрганизации(Запрос)
	
	Если Запрос.Параметры.Свойство("НалогообложениеОрганизации") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Запрос.Параметры.Организация, Запрос.Параметры.Период);
	Запрос.УстановитьПараметр("НалогообложениеОрганизации", ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи);
	
КонецПроцедуры

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента      = "Документ.НачислениеРеверсивногоНДС";
	СинонимТаблицыДокумента = "ДанныеДокумента";
	ВЗапросеЕстьИсточник    = Истина;
	ТекстыЗапросаВременныхТаблиц = Новый Соответствие();
	
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	ПереопределениеРасчетаПараметров.Вставить("ИнформацияПоИсправлению", """""");
	
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.НачислениеРеверсивногоНДС"));
	ЗначенияПараметров.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.НачислениеРеверсивногоНДС);
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", 	ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", 		ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
		ТекстЗапроса,
		ПолноеИмяДокумента,
		СинонимТаблицыДокумента,
		ВЗапросеЕстьИсточник,
		ПереопределениеРасчетаПараметров,
		ТекстыЗапросаВременныхТаблиц);
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
