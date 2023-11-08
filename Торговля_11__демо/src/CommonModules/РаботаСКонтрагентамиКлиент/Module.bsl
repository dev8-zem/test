///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обрабатывает стандартным способом ошибку, возвращенную в поле ОписаниеОшибки
// одним из методов:
// - РаботаСКонтрагентами.РеквизитыЮридическогоЛицаПоИНН;
// - РаботаСКонтрагентами.РеквизитыПредпринимателяПоИНН;
// - РаботаСКонтрагентами.РеквизитыЮридическихЛицПоНаименованию;
// - РаботаСКонтрагентами.ИнформацияОСвязяхЮридическогоЛицаПоИНН;
// - РаботаСКонтрагентами.ИнформацияОСвязяхПредпринимателяПоИНН;
// - РаботаСКонтрагентами.ИнформацияОПроверкахКонтролирующимиОрганамиПоСпискуИНН;
// - РаботаСКонтрагентами.РеквизитыНалоговогоОрганаПоКоду;
// - РаботаСКонтрагентами.РеквизитыОтделенияФССПоКоду;
// - РаботаСКонтрагентами.РеквизитыОтделенияПФРПоКоду;
//
// Параметры:
//	ОписаниеОшибки - Строка - полученное описание ошибки;
//	ОбработчикЗавершения - ОписаниеОповещения - обработчик, вызываемый
//		при завершении обработки ошибки. В обработчик передается
//		значение типа Структура с полями:
//		*ПовторитьДействие - Булево - если Истина, пользователь выполнил
//			действия, необходимые для исправления ошибки и можно повторно
//			вызвать выбранный метод;
//	ДополнительныеПараметры - Структура - дополнительные параметры
//		обработки ошибки. Поля:
//		*ПредставлениеДействия - Строка - представление выполняемого действия
//			в сообщениях пользователю;
//		*ИдентификаторМестаВызова - Строка - произвольный идентификатор
//			функциональности конфигурации;
//		*Форма - ФормаКлиентскогоПриложения - форма, в которой вызывается функциональность.
//			Используется как владелец форм, открываемых в режиме
//			"Блокировать окно владельца".
//
Процедура ОбработатьОшибку(
	ОписаниеОшибки,
	ОбработчикЗавершения = Неопределено,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	ПредставлениеДействия    = Неопределено;
	ИдентификаторМестаВызова = Неопределено;
	Форма                    = Неопределено;
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ДополнительныеПараметры.Свойство("ПредставлениеДействия"   , ПредставлениеДействия);
		ДополнительныеПараметры.Свойство("ИдентификаторМестаВызова", ИдентификаторМестаВызова);
		ДополнительныеПараметры.Свойство("Форма"                   , Форма);
	КонецЕсли;
	
	ДополнительныеПараметрыОбработчиковЗавершения = Новый Структура;
	ДополнительныеПараметрыОбработчиковЗавершения.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	ДополнительныеПараметрыОбработчиковЗавершения.Вставить("Форма"               , Форма);
	
	Если ОписаниеОшибки = "Сервис1СКонтрагентНеПодключен" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ИдентификаторМестаВызова", ИдентификаторМестаВызова);
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПодключениеСервисовСопровождения") Тогда
			
			ОбработчикПриЗакрытииФормы = Новый ОписаниеОповещения(
				"ФормаСервисКонтрагентНеПодключенПриЗакрытии",
				ЭтотОбъект,
				ДополнительныеПараметрыОбработчиковЗавершения);
			
			ПодключитьТестовыйПериод(
				ПараметрыФормы,
				Форма,
				ДополнительныеПараметрыОбработчиковЗавершения,
				ОбработчикПриЗакрытииФормы);
		Иначе
			ОткрытьФорму(
				"ОбщаяФорма.Сервис1СКонтрагентНеПодключен",
				ПараметрыФормы,
				Форма,
				,
				,
				,
				ОбработчикПриЗакрытииФормы);
		КонецЕсли;
		
		Возврат;
		
	ИначеЕсли ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Или ОписаниеОшибки = "НеУказанПароль" Тогда
		
		Если Не ЗначениеЗаполнено(ПредставлениеДействия) Тогда
			ТекстСообщения = НСтр("ru = 'Для продолжения необходимо подключить Интернет-поддержку пользователей.'");
		Иначе
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 станет возможным после подключения Интернет-поддержки пользователей.'"),
				ПредставлениеДействия);
		КонецЕсли;
		
		Если ИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки() Тогда
			
			ОбработчикЗавершения = Новый ОписаниеОповещения(
				"ПриОтветеНаВопросПодключитьИнтернетПоддержкуОбработатьОшибку",
				ЭтотОбъект,
				ДополнительныеПараметрыОбработчиковЗавершения);
			ПоказатьВопрос(
				ОбработчикЗавершения,
				ТекстСообщения + Символы.ПС + НСтр("ru = 'Подключить Интернет-поддержку?'"),
				РежимДиалогаВопрос.ДаНет);
			
		Иначе
			
			ОбработчикЗавершения = Новый ОписаниеОповещения(
				"ПредупреждениеТекстОшибкиЗавершение",
				ЭтотОбъект,
				ДополнительныеПараметрыОбработчиковЗавершения);
			ПоказатьПредупреждение(ОбработчикЗавершения, ТекстСообщения + Символы.ПС + НСтр("ru = 'Обратитесь к администратору.'"));
			
		КонецЕсли;
		
	Иначе
		
		ОбработчикЗавершения = Новый ОписаниеОповещения(
			"ПредупреждениеТекстОшибкиЗавершение",
			ЭтотОбъект,
			ДополнительныеПараметрыОбработчиковЗавершения);
		ПоказатьПредупреждение(ОбработчикЗавершения, ОписаниеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру дополнительных параметров для метода ОбработатьОшибку().
//
// Возвращаемое значение:
//	Структура - дополнительные параметры. Поля:
//		*ПредставлениеДействия - Строка - представление выполняемого действия
//			в сообщениях пользователю;
//		*ИдентификаторМестаВызова - Строка - произвольный идентификатор
//			функциональности конфигурации;
//		*Форма - ФормаКлиентскогоПриложения - форма, в которой вызывается функциональность.
//			Используется как владелец форм, открываемых в режиме
//			"Блокировать окно владельца".
//
Функция НовыйДополнительныеПараметрыОбработкиОшибки() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПредставлениеДействия"   , "");
	Результат.Вставить("ИдентификаторМестаВызова", "");
	Результат.Вставить("Форма"                   , Неопределено);
	
	Возврат Результат;
	
КонецФункции

// Обработчик события ПриИзменении() элемента ИспользоватьАвтоматическуюПроверкуКонтрагентов
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма панели администрирования;
//	Элемент - ПолеФормы - элементы управления формы панели администрирования.
//
Процедура ИнтернетПоддержкаИСервисы_ИспользоватьПроверкуКонтрагентовПриИзменении(Форма, Элемент) Экспорт
	
	ВключитьПроверку = (Форма.БИПИспользоватьПроверкуКонтрагентов = 1);
	ПроверкаКонтрагентовВызовСервера.ПриВключенииВыключенииПроверки(ВключитьПроверку);
	
КонецПроцедуры

// Обработчик команды БИППроверкаКонтрагентовПроверитьДоступКВебСервису
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма панели администрирования;
//	Команда - КомандаФормы - команда на панели администрирования.
//
Процедура ИнтернетПоддержкаИСервисы_БИППроверкаКонтрагентовПроверитьДоступКВебСервису(Форма, Команда) Экспорт
	
	ПроверкаКонтрагентовКлиент.ПроверитьДоступКСервису();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПредупреждениеТекстОшибкиЗавершение(ДополнительныеПараметры) Экспорт
	
	ОповеститьОЗавершенииОбработкиОшибки(ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПодключитьТестовыйПериод(
		ПараметрыФормы,
		Владелец,
		ДополнительныеПараметрыОбработчиков,
		ОбработчикПриЗакрытииФормы = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыФормы",                      ПараметрыФормы);
	ДополнительныеПараметры.Вставить("Владелец",                            Владелец);
	ДополнительныеПараметры.Вставить("ОбработчикПриЗакрытииФормы",          ОбработчикПриЗакрытииФормы);
	ДополнительныеПараметры.Вставить("ДополнительныеПараметрыОбработчиков", ДополнительныеПараметрыОбработчиков);
	
	ОповещениеПриЗавершенииПодключения = Новый ОписаниеОповещения(
		"ЗавершениеПодключенияТестовогоПериода",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	МодульПодключениеСервисовСопровожденияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
		"ПодключениеСервисовСопровожденияКлиент");
	
	МодульПодключениеСервисовСопровожденияКлиент.ПодключитьТестовыйПериод(
		"1C-Counteragent",
		Владелец,
		ОповещениеПриЗавершенииПодключения);
	
КонецПроцедуры

Процедура ЗавершениеПодключенияТестовогоПериода(Результат, ДополнительныеПараметры) Экспорт
	
	МодульПодключениеСервисовСопровожденияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
		"ПодключениеСервисовСопровожденияКлиент");
	
	Если Результат = МодульПодключениеСервисовСопровожденияКлиент.СостояниеПодключенияПодключениеНедоступно() Тогда
		ОткрытьФорму(
			"ОбщаяФорма.Сервис1СКонтрагентНеПодключен",
			ДополнительныеПараметры.ПараметрыФормы,
			ДополнительныеПараметры.Владелец,
			,
			,
			,
			ДополнительныеПараметры.ОбработчикПриЗакрытииФормы);
	ИначеЕсли Результат = МодульПодключениеСервисовСопровожденияКлиент.СостояниеПодключенияПодключен() Тогда
		ОповеститьОЗавершенииОбработкиОшибки(
			ДополнительныеПараметры.ДополнительныеПараметрыОбработчиков,
			Истина);
	ИначеЕсли Результат = МодульПодключениеСервисовСопровожденияКлиент.СостояниеПодключенияНеПодключен() Тогда
		ОповеститьОЗавершенииОбработкиОшибки(
			ДополнительныеПараметры.ДополнительныеПараметрыОбработчиков,
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаСервисКонтрагентНеПодключенПриЗакрытии(Результат, ДополнительныеПараметры) Экспорт
	
	ОповеститьОЗавершенииОбработкиОшибки(ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПриОтветеНаВопросПодключитьИнтернетПоддержкуОбработатьОшибку(КодВозврата, ДополнительныеПараметры) Экспорт
	
	Если КодВозврата <> КодВозвратаДиалога.Да Тогда
		
		ОповеститьОЗавершенииОбработкиОшибки(ДополнительныеПараметры);
		
	Иначе
		
		ОбработчикЗавершения = Новый ОписаниеОповещения(
			"ОбработатьОшибкуПодключитьИнтернетПоддержкуЗавершение",
			ЭтотОбъект,
			ДополнительныеПараметры);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			ОбработчикЗавершения,
			ДополнительныеПараметры.Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьОшибкуПодключитьИнтернетПоддержкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОповеститьОЗавершенииОбработкиОшибки(ДополнительныеПараметры, (Результат <> Неопределено));
	
КонецПроцедуры

Процедура ОповеститьОЗавершенииОбработкиОшибки(ДополнительныеПараметрыОбработчика, ПовторитьДействие = Ложь)
	
	Если ТипЗнч(ДополнительныеПараметрыОбработчика) = Тип("Структура")
		И ДополнительныеПараметрыОбработчика.ОбработчикЗавершения <> Неопределено Тогда
		Результат = Новый Структура;
		Результат.Вставить("ПовторитьДействие", ПовторитьДействие);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметрыОбработчика.ОбработчикЗавершения, Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
