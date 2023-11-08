#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет реквизиты выбранного договора эквайринга.
//
// Параметры:
//    Договор - СправочникСсылка.ДоговорыЭквайринга - Ссылка на договор эквайринга.
//
// Возвращаемое значение:
//    Структура - Реквизиты договора эквайринга.
//
Функция РеквизитыДоговора(Договор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеСправочника.Организация                                    КАК Организация,
	|	ДанныеСправочника.БанковскийСчет                                 КАК БанковскийСчет,
	|	ДанныеСправочника.БанковскийСчет.ВалютаДенежныхСредств           КАК Валюта,
	|	ДанныеСправочника.Контрагент                                     КАК Эквайер,
	|	ДанныеСправочника.БанковскийСчетКонтрагента                      КАК БанковскийСчетКонтрагента,
	|	ДанныеСправочника.ИспользуютсяЭквайринговыеТерминалы             КАК ИспользуютсяЭквайринговыеТерминалы,
	|	ДанныеСправочника.ДетальнаяСверкаТранзакций                      КАК ДетальнаяСверкаТранзакций,
	|	ДанныеСправочника.СпособОтраженияКомиссии                        КАК СпособОтраженияКомиссии,
	|	ДанныеСправочника.ФиксированнаяСтавкаКомиссии                    КАК ФиксированнаяСтавкаКомиссии,
	|	ДанныеСправочника.СтавкаКомиссии                                 КАК СтавкаКомиссии,
	|	ДанныеСправочника.ВзимаетсяКомиссияПриВозврате                   КАК ВзимаетсяКомиссияПриВозврате,
	|	ДанныеСправочника.РазрешитьПлатежиБезУказанияЗаявок              КАК РазрешитьПлатежиБезУказанияЗаявок,
	|	ДанныеСправочника.СтатьяРасходов                                 КАК СтатьяРасходов,
	|	ДанныеСправочника.АналитикаРасходов                              КАК АналитикаРасходов,
	|	ДанныеСправочника.ПодразделениеРасходов                          КАК ПодразделениеРасходов,
	|	ДанныеСправочника.НаправлениеДеятельности                        КАК НаправлениеДеятельности,
	|	ДанныеСправочника.СтатьяДвиженияДенежныхСредствПоступлениеОплаты КАК СтатьяДвиженияДенежныхСредствПоступлениеОплаты,
	|	ДанныеСправочника.СтатьяДвиженияДенежныхСредствВозврат           КАК СтатьяДвиженияДенежныхСредствВозврат
	|ИЗ
	|	Справочник.ДоговорыЭквайринга КАК ДанныеСправочника
	|ГДЕ
	|	ДанныеСправочника.Ссылка = &Договор
	|";
	
	Запрос.УстановитьПараметр("Договор", Договор);
	
	СтруктураРеквизитов = Новый Структура("Организация, БанковскийСчет, Валюта, Эквайер, БанковскийСчетКонтрагента,
		|ИспользуютсяЭквайринговыеТерминалы, ДетальнаяСверкаТранзакций,
		|СпособОтраженияКомиссии, ФиксированнаяСтавкаКомиссии, СтавкаКомиссии, ВзимаетсяКомиссияПриВозврате, РазрешитьПлатежиБезУказанияЗаявок,
		|СтатьяРасходов, АналитикаРасходов, ПодразделениеРасходов, НаправлениеДеятельности,
		|СтатьяДвиженияДенежныхСредствПоступлениеОплаты, СтатьяДвиженияДенежныхСредствВозврат");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Выборка);
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

// Функция определяет договор эквайринга по выбранной организации.
//
// Возвращает договор, если найден единственный договор.
// Возвращает пустую ссылку, в противном случае.
//
// Параметры:
//    Организация - СправочникСсылка.Организации - Выбранная организация.
//    Эквайер - СправочникСсылка.Контрагенты - Выбранный контрагент.
//    Валюта - СправочникСсылка.Валюты - Выбранная валюта.
//
// Возвращаемое значение:
//    СправочникСсылка.ДоговорыЭквайринга - Найденный договор.
//
Функция ДоговорПоУмолчанию(Организация = Неопределено, Эквайер = Неопределено, Валюта = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ДанныеСправочника.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДоговорыЭквайринга КАК ДанныеСправочника
	|ГДЕ
	|	НЕ ДанныеСправочника.ПометкаУдаления
	|	И ДанныеСправочника.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|	И (ДанныеСправочника.Организация = &Организация
	|		ИЛИ &Организация = Неопределено)
	|	И (ДанныеСправочника.Контрагент = &Эквайер
	|		ИЛИ &Эквайер = Неопределено)
	|	И (ДанныеСправочника.БанковскийСчет.ВалютаДенежныхСредств = &Валюта
	|		ИЛИ &Валюта = Неопределено
	|		ИЛИ ДанныеСправочника.БанковскийСчет.ВалютаДенежныхСредств ЕСТЬ NULL)
	|";
	
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	Запрос.УстановитьПараметр("Эквайер", ?(ЗначениеЗаполнено(Эквайер), Эквайер, Неопределено));
	Запрос.УстановитьПараметр("Валюта", ?(ЗначениеЗаполнено(Валюта), Валюта, Неопределено));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество()=1 И Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	Иначе
		Результат = Справочники.ДоговорыЭквайринга.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Партнер");
	Результат.Добавить("Контрагент");
	Результат.Добавить("Организация");
	Результат.Добавить("Подразделение");
	Результат.Добавить("БанковскийСчет");
	Результат.Добавить("НаправлениеДеятельности");
	
	Возврат Результат;
	
КонецФункции

// Добавляет команду создания справочника "Договоры лизинга".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	МетаданныеСправочника = Метаданные.Справочники.ДоговорыЭквайринга;
	
	Если ПравоДоступа("Добавление", МетаданныеСправочника) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = МетаданныеСправочника.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(МетаданныеСправочника);
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Документы.ОтчетБанкаПоОперациямЭквайринга.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Определяет свойства полей формы в зависимости от данных
//
// Параметры:
//	Настройки - ТаблицаЗначений - таблица с колонками:
//		* Поля - Массив - поля, для которых определяются настройки отображения
//		* Условие - ОтборКомпоновкиДанных - условия применения настройки
//		* Свойства - Структура - имена и значения свойств
//
Процедура ЗаполнитьНастройкиПолейФормы(Настройки) Экспорт
	
	Финансы = ФинансоваяОтчетностьСервер;
	
	// Основание
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтавкаКомиссии");
	Финансы.НовыйОтбор(Элемент.Условие, "ФиксированнаяСтавкаКомиссии", Истина);
	Элемент.Свойства.Вставить("Доступность");
	
	// ВзимаетсяКомиссияПриВозврате
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ВзимаетсяКомиссияПриВозврате");
	ГруппаИли = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИли, "СпособОтраженияКомиссии", Перечисления.СпособыОтраженияЭквайринговойКомиссии.ПриЗачислении);
	Финансы.НовыйОтбор(ГруппаИли, "СпособОтраженияКомиссии", Перечисления.СпособыОтраженияЭквайринговойКомиссии.ВоВремяТранзакции);
	Элемент.Свойства.Вставить("Доступность");
	
	// НадписьЭквайринговыеТерминалы
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("НадписьЭквайринговыеТерминалы");
	Финансы.НовыйОтбор(Элемент.Условие, "СпособПроведенияПлатежа", Перечисления.СпособыПроведенияПлатежей.ЭквайринговыйТерминал);
	Элемент.Свойства.Вставить("Видимость");

	// НадписьНастройкаПодключенияПлатежнойСистемы
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("НадписьНастройкаПодключенияПлатежнойСистемы");
	Финансы.НовыйОтбор(Элемент.Условие, "СпособПроведенияПлатежа", Перечисления.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей);
	Элемент.Свойства.Вставить("Видимость");
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияПартнеров КАК Т2 
	|	ПО Т2.Родитель = Т.Партнер
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т2.Партнер)
	|	И ЗначениеРазрешено(Т.Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Заполняет реквизиты параметров настройки счетов учета эквайринга, которые влияют на настройку,
// 	соответствующими им именам реквизитов аналитики учета.
//
// Параметры:
// 	СоответствиеИмен - Соответствие - ключом выступает имя реквизита, используемое в настройке счетов учета,
// 		значением является соответствующее имя реквизита аналитики учета.
// 
Процедура ЗаполнитьСоответствиеРеквизитовНастройкиСчетовУчета(СоответствиеИмен) Экспорт
	
	СоответствиеИмен.Организация = "Организация";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.СтрокаПоиска) Тогда
		СтандартнаяОбработка = Ложь;
		
		Запрос = Новый Запрос;
		
		ТекстСоединений = "";
		ТекстУсловий    = "";
		НомерОтбора     = 0;
		Если Параметры.Свойство("Отбор") Тогда
			
			Для Каждого ТекущийОтбор Из Параметры.Отбор Цикл
				
				Если НастройкаИнтеграцииЛокализация(ТекущийОтбор.Ключ, ТекстСоединений, ТекстУсловий) Тогда
					Продолжить;
				КонецЕсли;
				
				НомерОтбора = НомерОтбора + 1;
				
				ТекстУсловий = ТекстУсловий + "
				|	И ДоговорыЭквайринга." + ТекущийОтбор.Ключ + " В (&ЗначениеОтбора" + СокрЛП(НомерОтбора) + ")";
				
				Запрос.УстановитьПараметр("ЗначениеОтбора" + СокрЛП(НомерОтбора), ТекущийОтбор.Значение);
				
			КонецЦикла;
			
		КонецЕсли;
		
		// Текст запроса содержит литералы для переопределения/подстановки &ТекстСоединений &ТекстУсловий
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	ДоговорыЭквайринга.Ссылка КАК Ссылка,
				|	ДоговорыЭквайринга.Наименование КАК Наименование,
				|	ДоговорыЭквайринга.Наименование КАК Совпадение,
				|	1 КАК Порядок
				|ПОМЕСТИТЬ ДоговорыЭквайрингаПоиск 
				|ИЗ
				|	Справочник.ДоговорыЭквайринга КАК ДоговорыЭквайринга
				|
				|,&ТекстСоединений
				|
				|ГДЕ
				|	ДоговорыЭквайринга.Наименование ПОДОБНО &СтрокаПоиска
				|	И &ТекстУсловий
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ
				|	ДоговорыЭквайринга.Ссылка,
				|	ДоговорыЭквайринга.Наименование,
				|	ДоговорыЭквайринга.Номер,
				|	2
				|ИЗ
				|	Справочник.ДоговорыЭквайринга КАК ДоговорыЭквайринга
				|
				|,&ТекстСоединений
				|
				|ГДЕ
				|	ДоговорыЭквайринга.Номер ПОДОБНО &СтрокаПоиска
				|	И &ТекстУсловий
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ДоговорыЭквайрингаПоиск.Ссылка КАК Ссылка,
				|	МИНИМУМ(ДоговорыЭквайрингаПоиск.Порядок) КАК Порядок
				|ПОМЕСТИТЬ ДоговорыЭквайрингаПоПорядку
				|ИЗ
				|	ДоговорыЭквайрингаПоиск КАК ДоговорыЭквайрингаПоиск
				|
				|СГРУППИРОВАТЬ ПО
				|	ДоговорыЭквайрингаПоиск.Ссылка
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ЕСТЬNULL(ДоговорыЭквайрингаПоиск.Ссылка, ЗНАЧЕНИЕ(Справочник.ДоговорыЭквайринга.ПустаяСсылка)) КАК Ссылка,
				|	ЕСТЬNULL(ДоговорыЭквайрингаПоиск.Наименование, """") КАК Наименование,
				|	ЕСТЬNULL(ДоговорыЭквайрингаПоиск.Совпадение, """") КАК Совпадение,
				|	ЕСТЬNULL(ДоговорыЭквайрингаПоиск.Порядок, 0) КАК Порядок
				|ИЗ
				|	ДоговорыЭквайрингаПоПорядку КАК ДоговорыЭквайрингаПоПорядку
				|		ЛЕВОЕ СОЕДИНЕНИЕ ДоговорыЭквайрингаПоиск КАК ДоговорыЭквайрингаПоиск
				|		ПО ДоговорыЭквайрингаПоПорядку.Ссылка = ДоговорыЭквайрингаПоиск.Ссылка
				|			И ДоговорыЭквайрингаПоПорядку.Порядок = ДоговорыЭквайрингаПоиск.Порядок
				|
				|УПОРЯДОЧИТЬ ПО
				|	ЕСТЬNULL(ДоговорыЭквайрингаПоиск.Порядок, 0),
				|	ЕСТЬNULL(ДоговорыЭквайрингаПоиск.Совпадение, """"),
				|	ЕСТЬNULL(ДоговорыЭквайрингаПоиск.Наименование, """")";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ТекстСоединений", ТекстСоединений);
		
		Если Не ПустаяСтрока(ТекстУсловий) Тогда
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ТекстУсловий", ТекстУсловий);
			
		Иначе

			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ТекстУсловий", "");
			
		КонецЕсли;
		
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
		
		ДанныеВыбора = Новый СписокЗначений;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ТекстЗначение = ?(
				Выборка.Порядок = 1,
				Выборка.Наименование,
				СокрП(Выборка.Совпадение) + " (" + Выборка.Наименование + ")");
				
			ДанныеВыбора.Добавить(Выборка.Ссылка, ТекстЗначение);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.ДоговорыЭквайринга.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.10.14";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("4a162f96-d826-da43-6aa2-e94531cf4239");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ДоговорыЭквайринга.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет новый реквизит ""Способ проведения платежа"" справочника ""Эквайринговые терминалы"" в соответствии со значением реквизита ""Используются эквайринговые терминалы""'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.ДоговорыЭквайринга.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.ДоговорыЭквайринга.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.ДоговорыЭквайринга.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.ДоговорыЭквайринга";
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Ссылка");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДоговорыЭквайринга.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДоговорыЭквайринга КАК ДоговорыЭквайринга
		|ГДЕ
		|	ДоговорыЭквайринга.СпособПроведенияПлатежа = ЗНАЧЕНИЕ(Перечисление.СпособыПроведенияПлатежей.ПустаяСсылка)";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = ПустаяСсылка().Метаданные().ПолноеИмя();
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
		
	Для Каждого ЭлементСправочника Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементСправочника.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			СправочникОбъект = ЭлементСправочника.Ссылка.ПолучитьОбъект();
			
			Если СправочникОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЭлементСправочника.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
						
			НовоеЗначениеРеквизита = Перечисления.СпособыПроведенияПлатежей.ИнтернетЭквайринг;
			Если СправочникОбъект.ИспользуютсяЭквайринговыеТерминалы Тогда
				НовоеЗначениеРеквизита = Перечисления.СпособыПроведенияПлатежей.ЭквайринговыйТерминал;
			КонецЕсли;
			
			Если СправочникОбъект.СпособПроведенияПлатежа <> НовоеЗначениеРеквизита Тогда
				СправочникОбъект.СпособПроведенияПлатежа = НовоеЗначениеРеквизита;
			КонецЕсли;

			Если СправочникОбъект.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЭлементСправочника.Ссылка);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ЭлементСправочника.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#Область Локализация

Функция НастройкаИнтеграцииЛокализация(Ключ, ТекстСоединений, ТекстУсловий)
	
	ЕстьНастройкаИнтеграции = Ложь;
	
	//++ Локализация
	Если Ключ = "ЕстьНастройкаИнтеграции" Тогда
		
		ТекстСоединений = ТекстСоединений + "
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиИнтеграцииСПлатежнымиСистемамиУТ КАК НастройкиИнтеграции
		|	ПО ДоговорыЭквайринга.Ссылка = НастройкиИнтеграции.Договор";

		ТекстУсловий = ТекстУсловий + "
		|	И (ВЫБОР КОГДА ЕСТЬNULL(НастройкиИнтеграции.Интеграция, ЗНАЧЕНИЕ(Справочник.НастройкиИнтеграцииСПлатежнымиСистемами.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.НастройкиИнтеграцииСПлатежнымиСистемами.ПустаяСсылка)
		|		ТОГДА ЛОЖЬ ИНАЧЕ ИСТИНА	КОНЕЦ)";
		
		ЕстьНастройкаИнтеграции = Истина;
		
	КонецЕсли;
	//-- Локализация
	
	Возврат ЕстьНастройкаИнтеграции;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

