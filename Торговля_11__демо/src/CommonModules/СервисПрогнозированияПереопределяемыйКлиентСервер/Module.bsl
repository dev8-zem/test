
#Область СлужебныйПрограммныйИнтерфейс

// Реквизиты справочника Виды планов, необходимые для сервиса прогнозирования.
// 
// Возвращаемое значение:
//  Строка - список реквизитов.
Функция РеквизитыВидаПланаДляСервисаПрогнозирования() Экспорт
	
	Возврат "Периодичность, КоличествоПериодов,
		|АвтоматическиОбновлятьПрогноз, ПериодичностьОбновленияПрогноза, КоличествоОбновленийЗаПериод,
		|МетрикаОценкиКачестваПрогноза, ВзвешиваниеОбъектовПриПодсчетеМетрики, УчетПотерянныхПродаж,
		|КоэффициентВосстановленияУчетаПотерянныхПродаж, СглаживаниеВыбросовИсторическихДанных,
		|НижняяГраницаВыброса, ВерхняяГраницаВыброса, РассчитыватьОтклонениеПоСезоннымЗначениям,
		|НачалоПрогнозирования, ДополнительноеСвойствоВзвешивания, ЗаполнятьПоДаннымСервиса,
		|УскоритьОбучениеСПотерейКачества, КоличествоПериодовДляОценкиТочности, ИсключатьСезонность,
		|РеквизитыРасчетаСезонности, ДеньНеделиНачалаПрогноза, ИдентификаторМоделиПрогнозирования";
	
КонецФункции

// Значения по умолчанию реквизитов справочника Виды планов, необходимые для сервиса прогнозирования.
// 
// Возвращаемое значение:
//  Структура:
//  * Периодичность - ПеречислениеСсылка.Периодичность -
//  * ДеньНеделиНачалаПрогноза - ПеречислениеСсылка.ДниНедели - 
//  * КоличествоПериодов - Число - 
//  * АвтоматическиОбновлятьПрогноз - Булево - 
//  * ПериодичностьОбновленияПрогноза - Число - 
//  * КоличествоОбновленийЗаПериод - Число - 
//  * МетрикаОценкиКачестваПрогноза - Строка - 
//  * ВзвешиваниеОбъектовПриПодсчетеМетрики - Число - 
//  * УчетПотерянныхПродаж - Число - 
//  * КоэффициентВосстановленияУчетаПотерянныхПродаж - Число - 
//  * СглаживаниеВыбросовИсторическихДанных - Число - 
//  * НижняяГраницаВыброса - Число -
//  * ВерхняяГраницаВыброса - Число - 
//  * РассчитыватьОтклонениеПоСезоннымЗначениям - Число - 
//  * НачалоПрогнозирования - Дата - 
//  * ДополнительноеСвойствоВзвешивания - Строка - 
//  * ЗаполнятьПоДаннымСервиса - Булево - 
//  * УскоритьОбучениеСПотерейКачества - Булево - 
//  * КоличествоПериодовДляОценкиТочности - Число - 
Функция ЗначенияВидаПлановПоУмолчанию() Экспорт
	
	Структура = Новый Структура(РеквизитыВидаПланаДляСервисаПрогнозирования());
	
	Структура.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя");
	Структура.ДеньНеделиНачалаПрогноза = ПредопределенноеЗначение("Перечисление.ДниНедели.Понедельник");
	Структура.КоличествоПериодов = 5;
	Структура.АвтоматическиОбновлятьПрогноз = Ложь;
	Структура.ПериодичностьОбновленияПрогноза = 0;
	Структура.КоличествоОбновленийЗаПериод = 0;
	Структура.МетрикаОценкиКачестваПрогноза = "MAE";
	Структура.ВзвешиваниеОбъектовПриПодсчетеМетрики = 0;
	Структура.УчетПотерянныхПродаж = 0;
	Структура.КоэффициентВосстановленияУчетаПотерянныхПродаж = 0.5;
	Структура.СглаживаниеВыбросовИсторическихДанных = 0;

	Структура.НижняяГраницаВыброса = 2;
	Структура.ВерхняяГраницаВыброса = 2;
	Структура.РассчитыватьОтклонениеПоСезоннымЗначениям = 0;
	Структура.НачалоПрогнозирования = Неопределено;
	Структура.ДополнительноеСвойствоВзвешивания = "";
	Структура.ЗаполнятьПоДаннымСервиса = Истина;
	Структура.УскоритьОбучениеСПотерейКачества = Ложь;
	Структура.КоличествоПериодовДляОценкиТочности = 4;
	
	Структура.ИдентификаторМоделиПрогнозирования = -1;
	
	Возврат Структура;
	
КонецФункции

// Описание выгружаемого элемента данных.
// 
// Параметры:
//  ИмяВСервисе - Строка - 
//  Обязательный - Булево -
//  Выгружать - Булево -  
//  ИмяВИсточнике - ПеречислениеСсылка.КоллекцииСервисаПрогнозированияПродаж - 
//  Представление - Строка -
//  Категориальный - Булево - 
//  ВложенноеОписание - см. ОписаниеВыгружаемогоЭлементаДанных.
// Возвращаемое значение:
//  Структура - Получить даты начала окончания продаж:
//  * ИмяВСервисе - Строка - 
//  * Обязательный - Булево -
//  * Выгружать - Булево -  
//  * ИмяВИсточнике - ПеречислениеСсылка.КоллекцииСервисаПрогнозированияПродаж - 
//  * Представление - Строка -
//  * Категориальный - Булево - 
//  * ВложенноеОписание - см. ОписаниеВыгружаемогоЭлементаДанных.
Функция ОписаниеВыгружаемогоЭлементаДанных(ИмяВСервисе,
	Обязательный,
	Выгружать,
	ИмяВИсточнике,
	Представление = "",
	Категориальный = Истина,
	ВложенноеОписание = Неопределено) Экспорт
	
	Структура = Новый Структура();
	Структура.Вставить("ИмяВСервисе", ИмяВСервисе);
	Структура.Вставить("Обязательный", Обязательный);
	Структура.Вставить("Выгружать", Выгружать);
	Структура.Вставить("ИмяВИсточнике", ИмяВИсточнике); // Источником является запрос выборки данных.
	Структура.Вставить("Представление", Представление);
	Структура.Вставить("Категориальный", Категориальный);
	Структура.Вставить("ВложенноеОписание", ВложенноеОписание); // Описание предопределенных реквизитов сервиса.
	
	Структура.Вставить("ЭтоПользовательскоеПоле", Ложь);
	Структура.Вставить("ДополнительноеСвойство", Неопределено); // Дополнительный реквизит (сведение).
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти
