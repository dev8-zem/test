///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейКлиентСервер.
//
// Клиент-серверные процедуры и функции Интернет-поддержка пользователей:
//  - определение настроек библиотеки;
//  - общие проверки данных аутентификации.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает номер версии библиотеки.
//
// Возвращаемое значение:
//  Строка - номер версии библиотеки.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат "2.6.4.49";
	
КонецФункции

// Возвращает идентификатор поставщика услуг "Портал 1С:ИТС"
// для интеграции с подсистемой "Управление тарифами в модели
// сервиса" библиотеки "Технология сервиса".
//
// Возвращаемое значение:
//	Строка - идентификатор поставщика услуг.
//
Функция ИдентификаторПоставщикаУслугПортал1СИТС() Экспорт
	
	Возврат "Portal1CITS";
	
КонецФункции

// Выполняет проверку данных аутентификации Интернет-поддержки пользователей.
// Необходимо вызвать перед выполнением проверки логина и пароля в сервисе
// и сохранением данных в информационной базе.
//
// Параметры:
//  ДанныеАутентификации - Структура - структура, содержащая логин и пароль пользователя
//                         Интернет-поддержки:
//   * Логин - Строка - логин пользователя Интернет-поддержки;
//   * Пароль - Строка - пароль пользователя Интернет-поддержки.
//
// Возвращаемое значение:
//  Структура - результаты проверки данных аутентификации:
//   *Отказ - Булево - если Истина, при проверке обнаружены ошибки;
//   *СообщениеОбОшибке - Строка - сообщение для пользователя программы;
//   *Поле - Строка - идентификатор поля, в котором возникла ошибка:
//                      - "Логин" - ошибка возникла при проверке данных поля Логин;
//                      - "Пароль" - ошибка возникла при проверке данных поля Пароль;
//
Функция ПроверитьДанныеАутентификации(ДанныеАутентификации) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Отказ", Ложь);
	Результат.Вставить("СообщениеОбОшибке", "");
	Результат.Вставить("Поле", "");
	
	Если ПустаяСтрока(ДанныеАутентификации.Логин) Тогда
		Результат.Отказ = Истина;
		Результат.СообщениеОбОшибке = НСтр("ru = 'Поле ""Логин"" не заполнено.'");
		Результат.Поле = "Логин";
	ИначеЕсли ПустаяСтрока(ДанныеАутентификации.Пароль) Тогда
		Результат.Отказ = Истина;
		Результат.СообщениеОбОшибке = НСтр("ru = 'Поле ""Пароль"" не заполнено.'");
		Результат.Поле = "Пароль";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбщегоНазначения

// Подставляет в текст домен серверов ИПП в соответствии с текущими
// настройками подключения к серверам.
//
Функция ПодставитьДомен(Текст, Знач ДоменнаяЗона = Неопределено) Экспорт

	Если ДоменнаяЗона = 1 Тогда
		Результат = СтрЗаменить(Текст, "webits-info@1c.ru", "webits-info@1c.ua");
		Возврат СтрЗаменить(Результат, ".1c.ru", ".1c.eu");
	Иначе
		Возврат Текст;
	КонецЕсли;

КонецФункции

// Возвращает строковое представление размера файла.
//
Функция ПредставлениеРазмераФайла(Знач Размер) Экспорт

	Если Размер < 1024 Тогда
		Возврат Формат(Размер, "ЧДЦ=1") + " " + НСтр("ru = 'байт'");
	ИначеЕсли Размер < 1024 * 1024 Тогда
		Возврат Формат(Размер / 1024, "ЧДЦ=1") + " " + НСтр("ru = 'КБ'");
	ИначеЕсли Размер < 1024 * 1024 * 1024 Тогда
		Возврат Формат(Размер / (1024 * 1024), "ЧДЦ=1") + " " + НСтр("ru = 'МБ'");
	Иначе
		Возврат Формат(Размер / (1024 * 1024 * 1024), "ЧДЦ=1") + " " + НСтр("ru = 'ГБ'");
	КонецЕсли;

КонецФункции

// Преобразует переданную строку:
// в форматированную строку, если строка начинается с "<body>" и заканчивается "</body>";
// В противном случае строка остается без изменений.
//
Функция ФорматированныйЗаголовок(ТекстСообщения) Экспорт

	Если Лев(ТекстСообщения, 6) <> "<body>" Тогда
		Возврат ТекстСообщения;
	Иначе
		#Если ВебКлиент Тогда
		Возврат ИнтернетПоддержкаПользователейВызовСервера.ФорматированнаяСтрокаИзHTML(ТекстСообщения);
		#Иначе
		Возврат ФорматированнаяСтрокаИзHTML(ТекстСообщения);
		#КонецЕсли
	КонецЕсли;

КонецФункции

// Определяет URL для вызова сервиса аутентификации.
//
// Параметры:
//  Операция - Строка - путь к ресурсу;
//  НастройкиСоединения - Структура, Неопределено - настройки подключения.
//
// Возвращаемое значение:
//  Строка - URL операции.
//
Функция URLСтраницыСервисаLogin(Путь = "", Знач НастройкиСоединения = Неопределено) Экспорт
	
	Если НастройкиСоединения = Неопределено Тогда
		Домен = 0;
	Иначе
		Домен = НастройкиСоединения.ДоменРасположенияСерверовИПП;
	КонецЕсли;
	Возврат "https://"
		+ ХостСервисаLogin(Домен)
		+ Путь;
	
КонецФункции

// Определяет URL для перехода на страницу Портала 1С:ИТС.
//
// Параметры:
//  Операция  - Строка - путь к ресурсу;
//  Домен     - Число, Неопределено  - идентификатор домена.
//
// Возвращаемое значение:
//  Строка - URL операции.
//
Функция URLСтраницыПорталаПоддержки(Путь = "", Знач Домен = Неопределено) Экспорт
	
	Если Домен = Неопределено Тогда
		Домен = 0;
	КонецЕсли;
	Возврат "https://"
		+ ХостПорталаПоддержки(Домен)
		+ Путь;
	
КонецФункции

// Формирует пользовательское представление расписания.
//
// Параметры:
//  Расписание - Структура - данные расписания.
//
// Возвращаемое значение:
//  Строка - представление расписания.
//
Функция ПредставлениеРасписания(Расписание) Экспорт

	Если Расписание = Неопределено Тогда
		Возврат НСтр("ru = 'Настроить расписание'");
	Иначе
		Если ТипЗнч(Расписание) = Тип("Структура") Тогда
			Возврат Строка(ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание));
		Иначе
			Возврат Строка(Расписание);
		КонецЕсли;
	КонецЕсли;

КонецФункции

// Преобразует переданную строку:
// в форматированную строку, если строка начинается с "<body>" и заканчивается "</body>";
// В противном случае строка остается без изменений.
//
// Параметры:
//  ТекстСообщения - Строка - исходная строка.
//
// Возвращаемое значение:
//  Строка - результат преобразования.
//
Функция ФорматированнаяСтрокаИзHTML(ТекстСообщения) Экспорт
	
	Документ = Новый ФорматированныйДокумент;
	Документ.УстановитьHTML("<html>" + ТекстСообщения + "</html>", Новый Структура);
	Возврат Документ.ПолучитьФорматированнуюСтроку();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет хост Портала 1С:ИТС.
//
// Параметры:
//  Домен - Число  - идентификатор домена.
//
// Возвращаемое значение:
//  Строка - хост подключения.
//
Функция ХостПорталаПоддержки(Домен)


	Если Домен = 0 Тогда
		Возврат "portal.1c.ru";
	Иначе
		Возврат "portal.1c.eu";
	КонецЕсли;

КонецФункции

// Определяет хост сервиса аутентификации.
//
// Параметры:
//  Домен - Число  - идентификатор домена.
//
// Возвращаемое значение:
//  Строка - хост подключения.
//
Функция ХостСервисаLogin(Домен) Экспорт


	Если Домен = 0 Тогда
		Возврат "login.1c.ru";
	Иначе
		Возврат "login.1c.eu";
	КонецЕсли;

КонецФункции

// Возвращает строковое представление типа платформы.
//
// Параметры:
//  ПараметрТипПлатформы - ТипПлатформы - значение типа платформы.
//
// Возвращаемое значение:
//  Строка - строковое представление типа платформы.
//
Функция ИмяТипаПлатформы(ПараметрТипПлатформы) Экспорт
	
	Если ПараметрТипПлатформы = ТипПлатформы.Linux_x86 Тогда
		Возврат "Linux_x86";
	ИначеЕсли ПараметрТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		Возврат "Linux_x86_64";
	ИначеЕсли ПараметрТипПлатформы = ТипПлатформы.MacOS_x86 Тогда
		Возврат "MacOS_x86";
	ИначеЕсли ПараметрТипПлатформы = ТипПлатформы.MacOS_x86_64 Тогда
		Возврат "MacOS_x86_64";
	ИначеЕсли ПараметрТипПлатформы = ТипПлатформы.Windows_x86 Тогда
		Возврат "Windows_x86";
	ИначеЕсли ПараметрТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Возврат "Windows_x86_64";
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Отображает состояние подключения ИПП на панели
// "Интернет-поддержка и сервисы" (БСП).
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма для настройки.
//
Процедура ОтобразитьСостояниеПодключенияИПП(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Если Форма.БИПДанныеАутентификации = Неопределено Тогда
		Элементы.ДекорацияЛогинИПП.Заголовок = НСтр("ru = 'Подключение к Интернет-поддержке не выполнено.'");
		Элементы.ВойтиИлиВыйтиИПП.Заголовок = НСтр("ru = 'Подключить'");
		Элементы.ВойтиИлиВыйтиИПП.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	Иначе
		Логин = Форма.БИПДанныеАутентификации.Логин;
		ШаблонЗаголовка = ПодставитьДомен(
			НСтр("ru = '<body>Подключена Интернет-поддержка для пользователя <a href=""action:openUsersSite"">%1</body>'"));
		Элементы.ДекорацияЛогинИПП.Заголовок =
			ФорматированныйЗаголовок(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонЗаголовка,
					Логин));
		Элементы.ВойтиИлиВыйтиИПП.Заголовок = НСтр("ru = 'Отключить'");
		Элементы.ВойтиИлиВыйтиИПП.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
