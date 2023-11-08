#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаблицаДляСортировки = Новый ТаблицаЗначений;
	ТаблицаДляСортировки.Колонки.Добавить("Значение");
	ТаблицаДляСортировки.Колонки.Добавить("Представление");
	ТипыОбъектовПоддерживающихИнтеграцию =
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ТипыОбъектовПоддерживающихИнтеграцию();
	Для Каждого ТипЗначения Из ТипыОбъектовПоддерживающихИнтеграцию Цикл
		МетаданныеИнтегрированногоОбъекта = Метаданные.НайтиПоТипу(ТипЗначения);
		НовСтр = ТаблицаДляСортировки.Добавить();
		НовСтр.Значение = МетаданныеИнтегрированногоОбъекта.ПолноеИмя();
		НовСтр.Представление = МетаданныеИнтегрированногоОбъекта.Синоним;
	КонецЦикла;
	ТаблицаДляСортировки.Сортировать("Представление");
	Для Каждого Строка Из ТаблицаДляСортировки Цикл
		Элементы.ТипОбъектаИС.СписокВыбора.Добавить(Строка.Значение, Строка.Представление);
	КонецЦикла;
	
	СокращенноеНаименованиеКонфигурации =
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.СокращенноеНаименованиеКонфигурации();
	Если ЗначениеЗаполнено(СокращенноеНаименованиеКонфигурации) Тогда
		Элементы.ПредставлениеОбъектаИССКлючевымиПолями.Заголовок = СтрШаблон(
			НСтр("ru = 'В %1'"),
			СокращенноеНаименованиеКонфигурации);
		Элементы.ТипОбъектаИС.Заголовок = СтрШаблон(
			НСтр("ru = 'Тип объекта %1'"),
			СокращенноеНаименованиеКонфигурации);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТипОбъектаИС) Тогда
		ТипОбъектаИС = Параметры.ТипОбъектаИС;
		ОбновитьОтбор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ПоказатьУдаленные.Пометка = ПоказыватьУдаленные;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ПометкаУдаления",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно,,
		Не ПоказыватьУдаленные,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
	ПроверитьПодключение();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИнтеграцияС1СДокументооборотом_УспешноеПодключение" И Источник <> ЭтотОбъект Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатие(Элемент)
	
	Оповещение = Новый ОписаниеОповещения("ДекорацияНастройкиАвторизацииНажатиеЗавершение", ЭтотОбъект);
	ИмяФормыПараметров = "Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.АвторизацияВ1СДокументооборот";
	
	ОткрытьФорму(ИмяФормыПараметров,, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатиеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОбъектаИСПриИзменении(Элемент)
	
	ОбновитьОтбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	Если ЗначениеЗаполнено(ТипОбъектаИС) Тогда
		ПараметрыФормы.Вставить("ТипОбъектаИС", ТипОбъектаИС);
	КонецЕсли;
	Если Копирование Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом3.Форма.ФормаЭлемента",
		ПараметрыФормы,
		Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.ПоказатьУдаленные.Пометка = ПоказыватьУдаленные;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ПометкаУдаления",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно,,
		Не ПоказыватьУдаленные,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Пометка = ПометкаУдаления(Элементы.Список.ВыделенныеСтроки);
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 1 Тогда
		Если Пометка Тогда
			ТекстВопроса = СтрШаблон(
				НСтр("ru = 'Снять с ""%1"" пометку на удаление?'"),
				Строка(ТекущиеДанные.Ссылка));
		Иначе
			ТекстВопроса = СтрШаблон(
				НСтр("ru = 'Пометить ""%1"" на удаление?'"),
				Строка(ТекущиеДанные.Ссылка));
		КонецЕсли;
	Иначе
		Если Пометка Тогда
			ТекстВопроса = НСтр("ru = 'Снять с выделенных элементов пометку на удаление?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Пометить выделенные элементы на удаление?'");
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ВыделенныеСтроки", Элементы.Список.ВыделенныеСтроки);
	ПараметрыОбработчика.Вставить("Пометка", Пометка);
	Обработчик = Новый ОписаниеОповещения("ПометитьНаУдалениеСнятьПометкуЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометкуЗавершение(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПометитьНаУдалениеСнятьПометкуНаСервере(
		ПараметрыВыполнения.ВыделенныеСтроки,
		ПараметрыВыполнения.Пометка);
	
	Элементы.Список.Обновить();
	Оповестить("ИнтеграцияС1СДокументооборотом3_ЗаписаноПравило");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет подключение к ДО, выводя окно авторизации, если необходимо, и изменяя форму согласно результату.
//
&НаКлиенте
Процедура ПроверитьПодключение()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПодключениеЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(
		ОписаниеОповещения,
		ЭтотОбъект,,
		Ложь,
		Истина);
	
КонецПроцедуры

// Вызывается после проверки подключения к ДО и изменяет форму согласно результату.
//
&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	ОбработатьФормуСогласноВерсииСервиса();
	
КонецПроцедуры

// Изменяет форму согласно доступности сервиса ДО и номеру его версии.
//
&НаСервере
Функция ОбработатьФормуСогласноВерсииСервиса()
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВерсияСервиса();
	
	ФормаОбработанаУспешно = Истина;
	
	Попытка
		
		Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.СервисДоступен(ВерсияСервиса) Тогда
			
			Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница = Элементы.СтраницаДокументооборотНедоступен;
			ФормаОбработанаУспешно = Ложь;
			
		ИначеЕсли ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("3.0.7.1") Тогда
			
			Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница = Элементы.СтраницаДокументооборотДоступен;
			
		Иначе
			
			Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница = Элементы.СтраницаВерсияНеПоддерживается;
			ФормаОбработанаУспешно = Ложь;
			
		КонецЕсли;
		
	Исключение
		
		ОбработатьИсключение(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Возврат ФормаОбработанаУспешно;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПометкаУдаления(Знач МассивОбъектов)
	
	Результат = Ложь;
	
	ТекущаяПометкаУдаленияМассив = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивОбъектов, "ПометкаУдаления");
	
	Для Каждого ТекущаяПометка Из ТекущаяПометкаУдаленияМассив Цикл
		Результат = Результат Или ТекущаяПометка.Значение;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПометитьНаУдалениеСнятьПометкуНаСервере(Знач МассивОбъектов, ТекущаяПометкаУдаления)
	
	Для Каждого Ссылка Из МассивОбъектов Цикл
		ТекущийОбъект = Ссылка.ПолучитьОбъект();
		Если ТекущийОбъект.ПометкаУдаления <> ТекущаяПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		ТекущийОбъект.Заблокировать();
		ТекущийОбъект.УстановитьПометкуУдаления(Не ТекущаяПометкаУдаления);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИсключение(ИнформацияОбОшибке)
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВерсияСервиса();
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.СервисДоступен(ВерсияСервиса) Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	Иначе
		Если ТипЗнч(ИнформацияОбОшибке) = Тип("Строка") Тогда
			ПредставлениеОшибки = ИнформацияОбОшибке;
		Иначе
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецЕсли;
		ВызватьИсключение ПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтбор()
	
	Если ЗначениеЗаполнено(ТипОбъектаИС) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ТипОбъектаИС",
			ТипОбъектаИС,
			ВидСравненияКомпоновкиДанных.Равно);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
			Список.Отбор,
			"ТипОбъектаИС");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти