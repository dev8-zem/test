///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("Валюты") И ПараметрыКлиента.Валюты.ТребуетсяОбновитьКурсыВалют Тогда
		ПодключитьОбработчикОжидания("РаботаСКурсамиВалютВывестиОповещениеОНеактуальности", 15, Истина);
	КонецЕсли;
	
КонецПроцедуры

// См. СтандартныеПодсистемыКлиент.ПриПолученииСерверногоОповещения.
Процедура ПриПолученииСерверногоОповещения(ИмяОповещения, Результат) Экспорт
	
	Если ИмяОповещения <> "СтандартныеПодсистемы.Валюты.ТребуетсяОбновитьКурсыВалют" Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьКурсыУстарели();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление курсов валют

Функция НастройкиНаКлиенте()
	
	ИмяПараметра = "СтандартныеПодсистемы.Валюты";
	Настройки = ПараметрыПриложения[ИмяПараметра];
	
	Если Настройки = Неопределено Тогда
		Настройки = Новый Структура;
		Настройки.Вставить("НачалоДняПоследнегоОповещения", '00010101');
		ПараметрыПриложения[ИмяПараметра] = Настройки;
	КонецЕсли;
	
	Возврат Настройки;
	
КонецФункции

Процедура ОповеститьКурсыУстарели() Экспорт
	
	ДатаНачалаДня = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
	Настройки = НастройкиНаКлиенте();
	
	Если Настройки.НачалоДняПоследнегоОповещения >= ДатаНачалаДня Тогда
		Возврат;
	КонецЕсли;
	Настройки.НачалоДняПоследнегоОповещения = ДатаНачалаДня;
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Курсы валют устарели'"),
		НавигационнаяСсылкаОбработки(),
		НСтр("ru = 'Обновить курсы валют'"),
		БиблиотекаКартинок.Предупреждение32,
		СтатусОповещенияПользователя.Важное,
		"КурсыВалютУстарели");
	
КонецПроцедуры

// Выводит соответствующее оповещение.
//
Процедура ОповеститьКурсыУспешноОбновлены() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Курсы валют успешно обновлены'"),
		,
		НСтр("ru = 'Курсы валют обновлены'"),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Выводит соответствующее оповещение.
//
Процедура ОповеститьКурсыАктуальны() Экспорт
	
	ПоказатьПредупреждение(,НСтр("ru = 'Курсы валют актуальны.'"));
	
КонецПроцедуры

// Возвращает навигационную ссылку для оповещений.
//
Функция НавигационнаяСсылкаОбработки()
	Возврат "e1cib/app/Обработка.ЗагрузкаКурсовВалют";
КонецФункции

#КонецОбласти
