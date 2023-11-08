//////////////////////////////////////////////////////////////////////////////////////////////
// УчетнаяПолитикаПереопределяемый: переопределяемый механизм отвечающий за получение данных учетной политики.
//  
//////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбщиеПараметрыУчетнойПолитики

Функция Существует(Организация, Период, ВыводитьСообщениеОбОтсутствииУчетнойПолитики = Ложь, ДокументСсылка = Неопределено) Экспорт

	Возврат НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитик("НастройкиСистемыНалогообложения",
		Организация, Период, Ложь) <> Неопределено;

КонецФункции


// Возвращает систему налогообложения применяемую организацией: общая или упрощенная.
// Параметры:
//	Организация - СправочникСсылка.Организации - организация, для которой определяется система налогообложения;
//	Период - Дата - дата, на начало месяца которой определяется система налогообложения.
//
// Возвращаемое значение:
//	ПеречислениеСсылка.СистемыНалогообложения - система налогообложения, применяемая для данной организации на указанную дату.
//	Значение по умолчанию: Общая.
//
Функция СистемаНалогообложения(Организация, Период) Экспорт

	Если ПрименяетсяУСН(Организация, Период) Тогда
		Возврат Перечисления.СистемыНалогообложения.Упрощенная;
	Иначе
		Возврат Перечисления.СистемыНалогообложения.Общая;
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область ПараметрыУчетнойПолитикиПоНДС

// Параметры учетной политики по НДС

// Возвращает признак, является ли организация плательщиком налога на добавленную стоимость (НДС).
// Определяется на основании того, применяет ли организация упрощенную систему налогообложения. Если применяет - то не является плательщиком НДС.
// Параметры:
//	Организация - СправочникСсылка.Организации - организация, для которой определяется признак оплаты НДС;
//	Период - Дата - дата, на начало месяца которой определяется необходимость оплаты НДС.
//
// Возвращаемое значение:
//	Булево - Истина, если организация на дату является плательщиком налога на добавленную стоимость. В противном случае - ложь.
//
Функция ПлательщикНДС(Организация, Период) Экспорт

	Возврат НЕ ПрименяетсяУСН(Организация, Период);

КонецФункции 

// Возвращает признак освобождения организации от уплаты НДС.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация, для которой определяется признак освобождения от уплаты НДС;
//	Период - Дата - дата, на которую определяется признак освобождения от уплаты НДС.
//
// Возвращаемое значение:
//	Булево - Истина, если организация на дату освобождается от уплаты НДС. Всегда возвращается Ложь.
//
Функция ПрименяетсяОсвобождениеОтУплатыНДС(Организация, Период) Экспорт
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитик(
		"НастройкиУчетаНДС",
		Организация,
		Период,
		Ложь);
	Результат = Не ПараметрыУчетнойПолитики = Неопределено И ПараметрыУчетнойПолитики.ПрименяетсяОсвобождениеОтУплатыНДС;

	Возврат Результат;

КонецФункции


// Возвращает правило отбора авансов для регистрации счетов-фактур
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация, для которой необходимо определить правило отбора авансов
//	Период - Дата - дата, на которую определяется правило отбора авансов.
//
// Возвращаемое значение:
//	ПеречислениеСсылка.ПорядокРегистрацииСчетовФактурНаАванс - Правило отбора авансов
//
Функция ПравилоОтбораАвансовДляРегистрацииСчетовФактур(Организация, Период) Экспорт
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитик(
		"НастройкиУчетаНДС",
		Организация,
		Период,
		Ложь);
		
	Если ПараметрыУчетнойПолитики = Неопределено Тогда
		Результат = Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеДня; 
	Иначе 
		Результат = ПараметрыУчетнойПолитики.ПравилоОтбораАвансовДляРегистрацииСчетовФактур;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


// Возвращает периодичность формирования вычетов и восстановлений НДС
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация, для которой необходимо определить
//										периодичность формирования вычетов и восстановлений НДС
//	Период - Дата - дата, на которую определяется периодичность формирования вычетов и восстановлений НДС
//
// Возвращаемое значение:
//	ПеречислениеСсылка.Периодичность - Периодичность формирования вычетов и восстановлений НДС
//
Функция ПериодичностьФормированияВычетовИВосстановленийНДС(Организация, Период) Экспорт
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитик(
		"НастройкиУчетаНДС",
		Организация,
		Период,
		Ложь);
		
	Если ПараметрыУчетнойПолитики = Неопределено Тогда
		Результат = Перечисления.Периодичность.Месяц;
	Иначе 
		Результат = ПараметрыУчетнойПолитики.ПериодичностьФормированияВычетовИВосстановленийНДС;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПараметрыУчетнойПолитикиПоЕНВД

// Параметры учетной политики по ЕНВД

// Возвращает признак, применяет ли организация единый налог на вмененный доход (ЕНВД).
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация, для которой определяется применяет ли она ЕНВД;
//	Период - Дата - дата, на которую определяется применение ЕНВД.
//
// Возвращаемое значение:
//	Булево - Истина, если организация на дату является плательщиком единого налога на вмененный доход. В противном случае - ложь.
//
Функция ПлательщикЕНВД(Организация, Период) Экспорт

	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитик(
		"НастройкиСистемыНалогообложения",
		Организация,
		Период,
		Ложь);
	
	Если НЕ ПараметрыУчетнойПолитики = Неопределено Тогда
		Возврат ПараметрыУчетнойПолитики.ПрименяетсяЕНВД;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

// Определяет, являлась ли организация плательщиком единого налога на вмененный доход (ЕНВД) в течении указанного периода.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация, для которой определяется применение ЕНВД;
//	НачалоПериода - Дата - начало периода, для которого определяется применение организацией ЕНВД;
//	КонецПериода - Дата - конец периода, для которого определяется применение организацией ЕНВД.
//
// Возвращаемое значение:
//	Булево - Истина, если организация в течении указанного периода являлась плательщиком ЕНВД (хотя бы раз). В противном случае - ложь.
//
Функция ПлательщикЕНВДЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт

	МассивЗначений = ЗначенияРесурсаУчетнойПолитикиЗаПериод(
		"ПрименяетсяЕНВД", Организация, НачалоПериода, КонецПериода);
	
	Результат = Ложь;
	Для Каждого Значение Из МассивЗначений Цикл
		Результат = Результат ИЛИ Значение;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПараметрыУчетнойПолитикиПоУСН

// Параметры учетной политики по УСН

// Возвращает признак применения для организации упрошенной системы налогообложения.
// Параметры:
//	Организация - Массив, СправочникСсылка.Организации - организация или массив организаций, для которых необходимо определить применение УСН;
//	Период - Дата - дата, на начало месяца которой определяется признак применения УСН.
//
// Возвращаемое значение:
//	Булево - Истина, если для организации (или если для хотя бы одной организации из списка) на дату
//				применяется упрощенная система налогообложения. В противном случае - ложь.
//
Функция ПрименяетсяУСН(Знач Организация, Период) Экспорт

	Если ТипЗнч(Организация) = Тип("СписокЗначений") Тогда
		Организация = Организация.ВыгрузитьЗначения();
	КонецЕсли;
	
	Если ТипЗнч(Организация) = Тип("Массив") И Организация.Количество() = 1 Тогда
		 Организация = Организация.Получить(0);
	КонецЕсли;
	
	Если ТипЗнч(Организация) = Тип("СправочникСсылка.Организации") Тогда
		Результат = ПолучитьФункциональнуюОпцию("ПрименятьУСН", Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	ИначеЕсли ТипЗнч(Организация) = Тип("Массив") Тогда
		
		Запрос = Новый Запрос;
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
		НастройкиНалоговУчетныхПолитик.ДополнитьМенеджерВременныхТаблицГоловнымиОрганизациями(МенеджерВременныхТаблиц, Организация);
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиСистемыНалогообложенияСрезПоследних.Организация
		|ИЗ
		|	РегистрСведений.НастройкиСистемыНалогообложения.СрезПоследних(
		|			&Период,
		|			ПрименяетсяУСН И
		|			(Организация В (ВЫБРАТЬ Организация ИЗ ВтГоловныеОрганизации)
		|				ИЛИ &ВсеОрганизации)) КАК НастройкиСистемыНалогообложенияСрезПоследних";
		Запрос.УстановитьПараметр("Период", НачалоМесяца(Период));
		Запрос.УстановитьПараметр("ВсеОрганизации", Организация.Количество() = 0);
		
		РезультатЗапроса = Запрос.Выполнить();
		Результат = Не РезультатЗапроса.Пустой();
		
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//++ Локализация

// Возвращает признак использования патента для организации.
// Параметры:
//	Организация - СправочникСсылка.Организации- организация, для которых необходимо определить применение ПСН;
//	Период - Дата - дата, которой определяется признак применения ПСН.
//
// Возвращаемое значение:
//	Булево - Истина, если для организации установлено использование патентов в учетной политике на дату.
//				В противном случае - ложь.
//
Функция ПрименяетсяПСН(Знач Организация, Период) Экспорт
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитик(
	"НастройкиСистемыНалогообложения",
	Организация,
	Период,
	Ложь);
	
	Если НЕ ПараметрыУчетнойПолитики = Неопределено Тогда
		Возврат ПараметрыУчетнойПолитики.ПрименяетсяПСН;
	Иначе
		Возврат Ложь;
	КонецЕсли;
		
КонецФункции

// Возвращает признак использования АУСН для организации.
// Параметры:
//	Организация - СправочникСсылка.Организации- организация, для которых необходимо определить применение АУСН;
//	Период - Дата - дата, которой определяется признак применения АУСН.
//
// Возвращаемое значение:
//	Булево - Истина, если для организации установлено использование патентов в учетной политике на дату.
//				В противном случае - ложь.
//
Функция ПрименяетсяАУСН(Знач Организация, Период) Экспорт
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитик(
	"НастройкиСистемыНалогообложения",
	Организация,
	Период,
	Ложь);
	
	Если НЕ ПараметрыУчетнойПолитики = Неопределено Тогда
		Возврат ПараметрыУчетнойПолитики.ПрименяетсяАУСН;
	Иначе
		Возврат Ложь;
	КонецЕсли;
		
КонецФункции

// Возвращает признак необходимости заполнения книги учета доходов и расходов для организации.
// Такая необходимость присутствует, когда организация применяет УСН или ПСН.
// Параметры:
//	Организация - СправочникСсылка.Организации- организация, для которых необходимо определить необходимость заполнения КУДиР;
//	Период - Дата - дата, для которой определяется необходимость заполнения КУДиР.
//
// Возвращаемое значение:
//	Булево - Истина, если для организации установлено использование патентов (или УСН) в учетной политике на дату.
//				В противном случае - ложь.
//
Функция ЗаполнятьКУДиР(Знач Организация, Период) Экспорт
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитик(
	"НастройкиСистемыНалогообложения",
	Организация,
	Период,
	Ложь);
	
	Если НЕ ПараметрыУчетнойПолитики = Неопределено  И НЕ ПараметрыУчетнойПолитики.ПрименяетсяАУСН Тогда
		Возврат ПараметрыУчетнойПолитики.ПрименяетсяУСН ИЛИ ПараметрыУчетнойПолитики.ПрименяетсяПСН;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает признак использования патента в программе.
//
// Возвращаемое значение:
//	Булево - Истина, если для какой-либо из организаций установлено использование патентов в учетной политике.
//				В противном случае - ложь.
//
Функция ИспользуетсяПСН() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	(УчетнаяПолитикаОрганизации.ПрименяетсяПСН) КАК ПрименяетсяПСН
	|ИЗ
	|	РегистрСведений.НастройкиСистемыНалогообложения КАК УчетнаяПолитикаОрганизации
	|ГДЕ
	|	УчетнаяПолитикаОрганизации.ПрименяетсяПСН");

	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции


// Возвращает признак применения объекта налогообложения "Доходы, уменьшенные на величину расходов",
//	который используется для организации на упрощенной системе налогообложения.
// Параметры:
//	Организация - Массив, СправочникСсылка.Организации - организация или массив организаций,
//					для которых необходимо определить применение объекта налогообложения "ДоходыМинусРасходы";
//	Период - Дата - дата, на которую анализируется учетная политика организации.
//
// Возвращаемое значение:
//	Булево - Истина, если для организации (или если для хотя бы одной организации из списка) на дату
//				применяется объект налогообложения "ДоходыМинусРасходы". В противном случае - ложь.
//
Функция ПрименяетсяУСНДоходыМинусРасходы(Знач Организация, Период) Экспорт

	Если ТипЗнч(Организация) = Тип("СписокЗначений") Тогда
		Организация = Организация.ВыгрузитьЗначения();
	КонецЕсли;
	
	Если ТипЗнч(Организация) = Тип("Массив") И Организация.Количество() = 1 Тогда
		 Организация = Организация.Получить(0);
	КонецЕсли;
	
	Если ТипЗнч(Организация) = Тип("СправочникСсылка.Организации") Тогда
		Результат = ПолучитьФункциональнуюОпцию("ПрименяетсяУСНДоходыМинусРасходы", Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	ИначеЕсли ТипЗнч(Организация) = Тип("Массив") Тогда
		
		Запрос = Новый Запрос;
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
		НастройкиНалоговУчетныхПолитик.ДополнитьМенеджерВременныхТаблицГоловнымиОрганизациями(МенеджерВременныхТаблиц, Организация);
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиСистемыНалогообложенияСрезПоследних.Организация
		|ИЗ
		|	РегистрСведений.НастройкиУчетаУСН.СрезПоследних(
		|			&Период,
		|			(Организация В (ВЫБРАТЬ Организация ИЗ ВтГоловныеОрганизации)
		|				ИЛИ &ВсеОрганизации)
		|				И ПрименяетсяУСНДоходыМинусРасходы) КАК НастройкиУчетаУСНСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиСистемыНалогообложения.СрезПоследних(
		|			&Период,
		|			(Организация В (ВЫБРАТЬ Организация ИЗ ВтГоловныеОрганизации)
		|				ИЛИ &ВсеОрганизации)
		|				И ПрименяетсяУСН) КАК НастройкиСистемыНалогообложенияСрезПоследних
		|		ПО НастройкиСистемыНалогообложенияСрезПоследних.Организация = НастройкиУчетаУСНСрезПоследних.Организация";
		Запрос.УстановитьПараметр("Период", НачалоМесяца(Период));
		Запрос.УстановитьПараметр("СписокОрганизаций", Организация);
		Запрос.УстановитьПараметр("ВсеОрганизации", Организация.Количество() = 0);
		
		РезультатЗапроса = Запрос.Выполнить();
		Результат = Не РезультатЗапроса.Пустой();
		
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

// Возвращает признак применения объекта налогообложения "Доходы",
//	который используется для организации на упрощенной системе налогообложения.
// Параметры:
//	Организация - Массив, СправочникСсылка.Организации - организация или массив организаций,
//					для которых необходимо определить применение объекта налогообложения "Доходы";
//	Период - Дата - дата, на которую анализируется учетная политика организации.
//
// Возвращаемое значение:
//	Булево - Истина, если для организации (или если для хотя бы одной организации из списка) на дату
//				применяется объект налогообложения "Доходы". В противном случае - ложь.
//
Функция ПрименяетсяУСНДоходы(Знач Организация, Период) Экспорт

	Если ТипЗнч(Организация) = Тип("СписокЗначений") Тогда
		Организация = Организация.ВыгрузитьЗначения();
	КонецЕсли;
	
	Если ТипЗнч(Организация) = Тип("Массив") И Организация.Количество() = 1 Тогда
		 Организация = Организация.Получить(0);
	КонецЕсли;
	
	Если ТипЗнч(Организация) = Тип("СправочникСсылка.Организации") Тогда
		ПараметрыФО = Новый Структура("Организация, Период", Организация, НачалоМесяца(Период));
		Результат = ПолучитьФункциональнуюОпцию("ПрименятьУСН", ПараметрыФО) И Не ПолучитьФункциональнуюОпцию("ПрименяетсяУСНДоходыМинусРасходы", ПараметрыФО);
	ИначеЕсли ТипЗнч(Организация) = Тип("Массив") Тогда
		
		Запрос = Новый Запрос;
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
		НастройкиНалоговУчетныхПолитик.ДополнитьМенеджерВременныхТаблицГоловнымиОрганизациями(МенеджерВременныхТаблиц, Организация);
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиСистемыНалогообложенияСрезПоследних.Организация
		|ИЗ
		|	РегистрСведений.НастройкиСистемыНалогообложения.СрезПоследних(
		|			&Период,
		|			(Организация В (ВЫБРАТЬ Организация ИЗ ВтГоловныеОрганизации)
		|				ИЛИ &ВсеОрганизации)
		|				И ПрименяетсяУСН) КАК НастройкиСистемыНалогообложенияСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиУчетаУСН.СрезПоследних(
		|			&Период,
		|			(Организация В (ВЫБРАТЬ Организация ИЗ ВтГоловныеОрганизации)
		|				ИЛИ &ВсеОрганизации)
		|				И Не ПрименяетсяУСНДоходыМинусРасходы) КАК НастройкиУчетаУСНСрезПоследних
		|		ПО НастройкиСистемыНалогообложенияСрезПоследних.Организация = НастройкиУчетаУСНСрезПоследних.Организация
		|";
		Запрос.УстановитьПараметр("Период", НачалоМесяца(Период));
		Запрос.УстановитьПараметр("СписокОрганизаций", Организация);
		Запрос.УстановитьПараметр("ВсеОрганизации", Организация.Количество() = 0);
		
		РезультатЗапроса = Запрос.Выполнить();
		Результат = Не РезультатЗапроса.Пустой();
		
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает массив организаций, находящихся на УСН за определенный период.
// Параметры:
//	НачалоПериода - Дата - дата, на начало месяца которой определяется список организаций на УСН;
//	КонецПериода - Дата - дата, на конец месяца которой определяется список организаций на УСН.
//
// Возвращаемое значение:
//	Массив - СправочникСсылка.Организации - все организации, применяющие УСН в течении указанного периода.
//
Функция ОрганизацииНаУСНЗаПериод(НачалоПериода, КонецПериода) Экспорт
	
	СледующийМесяц = НачалоМесяца(ДобавитьМесяц(НачалоПериода, 1));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода",    НачалоМесяца(НачалоПериода));
	Запрос.УстановитьПараметр("СледующийМесяц",   СледующийМесяц);
	Запрос.УстановитьПараметр("ОкончаниеПериода", КонецМесяца(КонецПериода));
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	РегистрСведений.НастройкиСистемыНалогообложения.СрезПоследних(&НачалоПериода, ПрименяетсяУСН И НЕ Организация.Ссылка ЕСТЬ NULL) КАК НастройкиСистемыНалогообложенияСрезПоследних
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО Организации.ГоловнаяОрганизация = НастройкиСистемыНалогообложенияСрезПоследних.Организация
	|";
	
	Если СледующийМесяц < КонецМесяца(КонецПериода) Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|"+
		"ВЫБРАТЬ
		|	Организации.Ссылка КАК Организация
		|ИЗ
		|	РегистрСведений.НастройкиСистемыНалогообложения КАК НастройкиСистемыНалогообложения
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО Организации.ГоловнаяОрганизация = НастройкиСистемыНалогообложения.Организация
		|ГДЕ
		|	НастройкиСистемыНалогообложения.ПрименяетсяУСН
		|	И НастройкиСистемыНалогообложения.Период МЕЖДУ &СледующийМесяц И &ОкончаниеПериода";
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	МассивОрганизаций = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Организация");
	
	Возврат МассивОрганизаций;
	
КонецФункции

// Возвращает признак применения для организации упрошенной системы налогообложения за определенный период.
// Параметры:
//	Организация - СправочникСсылка.Организации - организация, для которой необходимо определить применение УСН с объектом налогообложения "Доходы минус расходы";
//	НачалоПериода - Дата - дата, на начало месяца которой определяется признак применения УСН с объектом налогообложения "Доходы минус расходы";
//	КонецПериода - Дата - дата, на конец месяца которой определяется признак применения УСН с объектом налогообложения "Доходы минус расходы";
//	ОбъектНалогообложения - ПеречислениеСсылка.ОбъектыНалогообложенияПоУСН - ссылка на объект налогообложения, если требуется получить признак
//		применения конкретного объекта налогообложения, если не заполнен - получает признак непосредственного применения УСН.
//
// Возвращаемое значение:
//	Булево - Истина, если для организации в какой-либо из отрезков указанного периода применялась упрощенная система налогообложения с объектом налогообложения "Доходы минус расходы".
//				В противном случае - ложь.
//
Функция ПрименяетсяУСНЗаПериод(Организация, НачалоПериода, КонецПериода, ОбъектНалогообложения = Неопределено) Экспорт

	СледующийМесяц = НачалоМесяца(ДобавитьМесяц(НачалоПериода, 1));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",      Организация);
	Запрос.УстановитьПараметр("НачалоПериода",    НачалоМесяца(НачалоПериода));
	Запрос.УстановитьПараметр("СледующийМесяц",   СледующийМесяц);
	Запрос.УстановитьПараметр("ОкончаниеПериода", КонецМесяца(КонецПериода));
	
	МассивТекстовЗапроса = Новый Массив;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Данные.ПрименяетсяУСН И &УсловиеНаОбъектНалогообложения КАК Значение
	|ИЗ
	|	РегистрСведений.НастройкиСистемыНалогообложения.СрезПоследних(&НачалоПериода, Организация = ВЫРАЗИТЬ(&Организация КАК Справочник.Организации).ГоловнаяОрганизация) КАК Данные
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиУчетаУСН.СрезПоследних(&НачалоПериода, Организация = ВЫРАЗИТЬ(&Организация КАК Справочник.Организации).ГоловнаяОрганизация) КАК ДанныеУСН
	|	ПО Данные.Организация = ДанныеУСН.Организация";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	Если СледующийМесяц < КонецМесяца(КонецПериода) Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Данные.ПрименяетсяУСН И &УсловиеНаОбъектНалогообложения
		|ИЗ
		|	РегистрСведений.НастройкиСистемыНалогообложения КАК Данные
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиУчетаУСН КАК ДанныеУСН
		|	ПО Данные.Организация = ДанныеУСН.Организация
		|		И КОНЕЦПЕРИОДА(Данные.Период, Квартал) = КОНЕЦПЕРИОДА(ДанныеУСН.Период, Квартал)
		|ГДЕ
		|	Данные.Организация = ВЫРАЗИТЬ(&Организация КАК Справочник.Организации).ГоловнаяОрганизация
		|	И Данные.Период МЕЖДУ &СледующийМесяц И &ОкончаниеПериода";
		МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	КонецЕсли;
	
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	УсловиеНаОбъектНалогообложения = "ЛОЖЬ";
	Если ОбъектНалогообложения = Неопределено Тогда
		УсловиеНаОбъектНалогообложения = "ИСТИНА";
	ИначеЕсли ОбъектНалогообложения = Перечисления.ОбъектыНалогообложенияПоУСН.ДоходыМинусРасходы Тогда
		УсловиеНаОбъектНалогообложения = "ДанныеУСН.ПрименяетсяУСНДоходыМинусРасходы";
	ИначеЕсли ОбъектНалогообложения = Перечисления.ОбъектыНалогообложенияПоУСН.Доходы Тогда
		УсловиеНаОбъектНалогообложения = "НЕ ДанныеУСН.ПрименяетсяУСНДоходыМинусРасходы";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаОбъектНалогообложения", УсловиеНаОбъектНалогообложения);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Значение");
	
	Результат = Ложь;
	Для Каждого Значение Из РезультатЗапроса Цикл
		Результат = Результат ИЛИ Значение;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции


//-- Локализация

#КонецОбласти

// Параметры учетной политики по производству


// Определяет, применялся ли для организации признак, указанный в первом параметре, в течении указанного периода.
//
// Параметры:
//	ИмяРесурса - Строка - имя ресурса регистра сведений "УчетныеПолитикиОрганизаций" с типом "Булево";
//	Организация - СправочникСсылка.Организации - организация, для которой определяется значение ресурса;
//	НачалоПериода - Дата - начало периода, для которого определяется значение ресурса;
//	ОкончаниеПериода - Дата - конец периода, для которого определяется значение ресурса.
//
// Возвращаемое значение:
//	Булево - Истина, если для организации в течении указанного периода, значение ресурса хотя бы раз принимало значение "Истина". В противном случае - ложь.
//
Функция ЗначенияРесурсаУчетнойПолитикиЗаПериод(ИмяРесурса, Организация, НачалоПериода, ОкончаниеПериода) Экспорт
	
	СледующийМесяц = НачалоМесяца(ДобавитьМесяц(НачалоПериода, 1));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",      Организация);
	Запрос.УстановитьПараметр("НачалоПериода",    НачалоМесяца(НачалоПериода));
	Запрос.УстановитьПараметр("СледующийМесяц",   СледующийМесяц);
	Запрос.УстановитьПараметр("ОкончаниеПериода", КонецМесяца(ОкончаниеПериода));
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НастройкиСистемыНалогообложенияСрезПоследних.СистемаНалогообложения КАК Значение
	|ИЗ
	|	РегистрСведений.НастройкиСистемыНалогообложения.СрезПоследних(&НачалоПериода, Организация = ВЫРАЗИТЬ(&Организация КАК Справочник.Организации).ГоловнаяОрганизация) КАК НастройкиСистемыНалогообложенияСрезПоследних";
	
	Если СледующийМесяц < КонецМесяца(ОкончаниеПериода) Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|"+
		"ВЫБРАТЬ
		|	НастройкиСистемыНалогообложения.СистемаНалогообложения
		|ИЗ
		|	РегистрСведений.НастройкиСистемыНалогообложения КАК НастройкиСистемыНалогообложения
		|ГДЕ
		|	НастройкиСистемыНалогообложения.Организация = ВЫРАЗИТЬ(&Организация КАК Справочник.Организации).ГоловнаяОрганизация
		|	И НастройкиСистемыНалогообложения.Период МЕЖДУ &СледующийМесяц И &ОкончаниеПериода";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СистемаНалогообложения", ИмяРесурса);
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Значение");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
	
