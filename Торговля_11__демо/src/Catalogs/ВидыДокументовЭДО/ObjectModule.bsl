#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

// Проверяет уникальность вида документа
//
// Возвращаемое значение:
//  Булево - Истина, если вид документа уникален.
//
Функция ВидДокументаУникален()
	
	Если НЕ ЭтоНовый() Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПараметрыПоиска = ЭлектронныеДокументыЭДО.НовыеПараметрыПоискаВидаДокумента(ТипДокумента);
	ПараметрыПоиска.ПрикладнойТипДокумента = ПрикладнойТипДокумента;	
	ПараметрыПоиска.ИдентификаторКомандыПечати = ИдентификаторКомандыПечати;	
	ПараметрыПоиска.ИдентификаторОбъектаУчета = ИдентификаторОбъектаУчета;
	
	ЭлектронныеДокументыЭДО.БлокировкаВидаДокумента(ПараметрыПоиска).Заблокировать();
	ВидДокумента = ЭлектронныеДокументыЭДО.НайтиВидДокумента(ПараметрыПоиска);

	Если ЗначениеЗаполнено(ВидДокумента) Тогда
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(НСтр("ru = 'Параметры поиска:'"));
		МассивСтрок.Добавить(ОбщегоНазначенияБЭДКлиентСервер.СтруктураВСтроку(ПараметрыПоиска,,Символы.ПС));
		МассивСтрок.Добавить(НСтр("ru = 'Описание ошибки:'"));
		МассивСтрок.Добавить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ТекстОшибки = СтрСоединить(МассивСтрок, Символы.ПС);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поиск вида документа'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		
		Возврат Ложь;
		
	КонецЕсли;
			
	Возврат Истина;
	
КонецФункции

#КонецОбласти
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипДокумента <> Перечисления.ТипыДокументовЭДО.Прикладной Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПрикладнойТипДокумента");
	КонецЕсли;
	
	Если ТипДокумента <> Перечисления.ТипыДокументовЭДО.Внутренний Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторКомандыПечати");
		МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторОбъектаУчета");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивНепроверяемыхРеквизитов) Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ТипДокумента <> Перечисления.ТипыДокументовЭДО.Прикладной Тогда
		ПрикладнойТипДокумента = Неопределено;
	КонецЕсли;
	
	Если ТипДокумента <> Перечисления.ТипыДокументовЭДО.Внутренний Тогда 
		ИдентификаторОбъектаУчета = Неопределено;
		ИдентификаторКомандыПечати = "";
	КонецЕсли;

	Если НЕ ВидДокументаУникален() Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Вид документа не уникален'"));
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ДополнительныеСвойства.ЭтоНовый И Не Отказ Тогда
		ЭлектронныеДокументыЭДОСобытия.ПриЗаписиНовогоВидаДокумента(Ссылка, Отказ);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли
