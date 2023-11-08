
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// Подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	
	// Отработка видимости элементов формы, напрямую не связанных с ФО
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		УправлениеЭлементамиФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();

	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
// Конец СтандартныеПодсистемы.Свойства
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если Не ПолныеВозможности Тогда
		Объект.ВариантРаспределенияРасходовРегл = Объект.ВариантРаспределенияРасходовУпр;
		Объект.ПравилоРаспределенияРасходовРегл = Объект.ПравилоРаспределенияРасходовУпр;
		Объект.ВариантРаспределенияРасходовНУ = Объект.ВариантРаспределенияРасходовУпр;
		Объект.ПравилоРаспределенияРасходовНУ = Объект.ПравилоРаспределенияРасходовУпр;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	Если Не ПустаяСтрока(ТипЗначения) Тогда
		Если ТипЗначения = "ДокументСсылка.ЗаказКлиента"
			ИЛИ ТипЗначения = "ДокументСсылка.РеализацияТоваровУслуг"
		Тогда
			ТекущийОбъект.АналитикаРасходовЗаказРеализация = Истина;
			ТекущийОбъект.ТипЗначения = 
				Новый ОписаниеТипов("ДокументСсылка.АктВыполненныхРабот,
				|ДокументСсылка.РеализацияТоваровУслуг,
				|ДокументСсылка.РеализацияУслугПрочихАктивов,
				|ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента,
				|ДокументСсылка.ЗаказКлиента");
		Иначе
			ТекущийОбъект.АналитикаРасходовЗаказРеализация = Ложь;
			ТекущийОбъект.ТипЗначения = Новый ОписаниеТипов(ТипЗначения);
		КонецЕсли;
	КонецЕсли;
	
	ТекущийОбъект.ДоступныеХозяйственныеОперации.Очистить();
	Для Каждого ЭлементСписка Из ДоступныеХозяйственныеОперации Цикл
		Если ЭлементСписка.Пометка Тогда
			НоваяСтрока = ТекущийОбъект.ДоступныеХозяйственныеОперации.Добавить();
			НоваяСтрока.ХозяйственнаяОперация = ЭлементСписка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПолеТипЗначения = Элементы.ТипЗначения;
	Если ПолеТипЗначения.СписокВыбора.НайтиПоЗначению(ТипЗначения) = Неопределено
		И Не Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаПрочиеАктивы
		И Не ТипЗначения = "СправочникСсылка.ПрочиеАктивыПассивы" Тогда
		ТекстСообщения = НСтр("ru = 'В поле ""Аналитика расходов"" не выбрано ни одного вида аналитики'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			, // Ключ данных
			"ТипЗначения",
			, // Путь к данным
			Отказ);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства

	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если НЕ Объект.ОграничитьИспользование Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоступныеХозяйственныеОперации");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_СтатьяРасходов", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДеятельностиРасходовПриИзменении(Элемент)
	
	ВидДеятельностиРасходовПриИзмененииСервер(Элемент.Имя);
	СтатьиРасходовКлиентЛокализация.ПриИзмененииРеквизита(Элемент.Имя, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаспределенияРасходовУпрПолныеПриИзменении(Элемент)
	
	ВариантРаспределенияРасходовУпрПриИзмененииСервер();

	ДополнитьСписокВидовАналитикРасходовЭлементамиЗависимымиОтВариантовРаспределения();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры


&НаКлиенте
Процедура ВариантРаспределенияРасходовРеглПолныеПриИзменении(Элемент)
	
	ВариантРаспределенияРасходовРеглПриИзмененииСервер();
	
	Если Объект.ВариантРаспределенияРасходовНУ.Пустая() Тогда
		Объект.ВариантРаспределенияРасходовНУ = Объект.ВариантРаспределенияРасходовРегл;
		ДополнитьСписокВидовАналитикРасходовЭлементамиЗависимымиОтВариантовРаспределения();
		ВариантРаспределенияРасходовНУПолныеПриИзменении(Элементы.ВариантРаспределенияРасходовНУПолные);
	Иначе
		ПрямыеКосвенныеПоНастройкамОтнесения();
		ДополнитьСписокВидовАналитикРасходовЭлементамиЗависимымиОтВариантовРаспределения();
		УправлениеЭлементамиФормы();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВариантРаспределенияРасходовНУПолныеПриИзменении(Элемент)
	
	ПрямыеКосвенныеПоНастройкамОтнесения();
	ДополнитьСписокВидовАналитикРасходовЭлементамиЗависимымиОтВариантовРаспределения();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаспределенияРасходовОбщПриИзменении(Элемент)

	ПривестиВариантыИПравилаКНастройкамУпр();
	ВариантРаспределенияРасходовРеглПриИзмененииСервер();
	ДополнитьСписокВидовАналитикРасходовЭлементамиЗависимымиОтВариантовРаспределения();
	УправлениеЭлементамиФормы();

КонецПроцедуры

&НаКлиенте
Процедура ПравилоРаспределенияРасходовОбщПриИзменении(Элемент)

	ПривестиВариантыИПравилаКНастройкамУпр();

КонецПроцедуры

&НаКлиенте
Процедура ПравилоРаспределенияРасходовУпрПолныеПриИзменении(Элемент)
	ПравилоРаспределенияРасходовУпрПолныеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ТипРасходовПриИзменении(Элемент)
	
	ТипРасходовПриИзмененииСервер(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	
	ТипЗначенияПриИзмененииСервер(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНастроитьПравилаРаспределенияНажатие(Элемент)
	
	
	Возврат; // в УТ пустой
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничитьИспользованиеПриИзменении(Элемент)
	
	Элементы.ДоступныеХозяйственныеОперации.Доступность = Объект.ОграничитьИспользование;
	
	Если Не Объект.ОграничитьИспользование Тогда
		Для каждого ЭлементСписка Из ДоступныеХозяйственныеОперации Цикл
			Если ЭлементСписка.Пометка Тогда
				ЭлементСписка.Пометка = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизитаЛокализации(Элемент)
	
	СтатьиРасходовКлиентЛокализация.ПриИзмененииРеквизита(Элемент.Имя, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОкончанииИзмененияРеквизитаЛокализации(ИмяЭлемента, Параметры = Неопределено) Экспорт
	
	Если Параметры.ТребуетсяВызовСервера Тогда
		ПриОкончанииИзмененияРевизитаЛокализацииНаСервере(ИмяЭлемента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриОкончанииИзмененияРевизитаЛокализацииНаСервере(ИмяЭлемента)
	
	СтатьиРасходовЛокализация.ПриИзмененииРеквизита(ИмяЭлемента, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательИспользоватьПолныеВозможностиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПолныеВозможности = Истина;
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтключитьПолныеВозможностиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПолныеВозможности = Ложь;
	
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ПараметрыФормы = Новый Структура("СтатьяРасходов", Объект.Ссылка);
		ПараметрыФормы.Вставить("ВидДеятельностиРасходов", Объект.ВидДеятельностиРасходов);
		ПараметрыФормы.Вставить("ВариантРаспределенияРасходовНУ", Объект.ВариантРаспределенияРасходовНУ);
		ПараметрыФормы.Вставить("ВариантРаспределенияРасходовУпр", Объект.ВариантРаспределенияРасходовУпр);
		ПараметрыФормы.Вставить("ВариантРаспределенияРасходовРегл", Объект.ВариантРаспределенияРасходовРегл);
		ПараметрыФормы.Вставить("Предопределенный", Объект.Предопределенный);
	
		ОткрытьФорму("ПланВидовХарактеристик.СтатьиРасходов.Форма.РазблокированиеРеквизитов", ПараметрыФормы,,,,, Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик выполнения команды.
//
// Параметры:
//	Команда - КомандаФормы - команда формы.
//
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЛокализации(Команда)
	
	СтатьиРасходовКлиентЛокализация.ВыполнитьКоманду(Команда.Имя, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыполнениеКомандыЛокализации(ИмяКоманды, Параметры) Экспорт
	
	Если Параметры.ТребуетсяВызовСервера Тогда
		ВыполнитьКомандуЛокализацииНаСервере(ИмяКоманды);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуЛокализацииНаСервере(ИмяКоманды)
	
	СтатьиРасходовЛокализация.ВыполнитьКоманду(ИмяКоманды, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ПрямыеКосвенныеПоНастройкамОтнесения()

	Объект.КосвенныеЗатратыНУ = Объект.ВариантРаспределенияРасходовНУ = Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности;

КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПрямыеКосвенныеНажатие(Элемент)

	ПолныеВозможности = Истина;
	УправлениеЭлементамиФормы();
	ЭтаФорма.ТекущийЭлемент = Элементы.ВариантРаспределенияРасходовНУПолные;
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаОсновное; 
	 
КонецПроцедуры


&НаСервере
Процедура ВидДеятельностиРасходовПриИзмененииСервер(ИмяЭлемента)
	
	СтатьиРасходовЛокализация.ВидДеятельностиРасходовПриИзменении(ЭтаФорма);
	
КонецПроцедуры



&НаСервере
Процедура ПравилоРаспределенияРасходовУпрПолныеПриИзмененииНаСервере()
	Если (Объект.ВариантРаспределенияРасходовРегл = Объект.ВариантРаспределенияРасходовУпр) И НЕ ЗначениеЗаполнено(Объект.ПравилоРаспределенияРасходовРегл) Тогда
		Объект.ПравилоРаспределенияРасходовРегл = Объект.ПравилоРаспределенияРасходовУпр;
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ТипРасходовПриИзмененииСервер(ИмяЭлемента)
	
	ИзменилсяТипЗначения =						Ложь;
	ИзменилсяВариантРаспределенияРасходовУпр =	Ложь;
	ИзменилсяВариантРаспределенияРасходовРегл =	Ложь;
	
	Если Элементы.ТипЗначения.СписокВыбора.НайтиПоЗначению(ТипЗначения) = Неопределено ИЛИ НЕ ЗначениеЗаполнено(Объект.ВариантРаспределенияРасходовУпр) Тогда
			ИзменилсяТипЗначения = 						Истина;
			Если Объект.ТипРасходов = Перечисления.ТипыРасходов.ЗакупкаТоваров Тогда
			ТипЗначения = "ДокументСсылка.ПриобретениеТоваровУслуг";
			Вариант = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров;
			Объект.ВариантРаспределенияРасходовУпр =	Вариант;
			Объект.ПравилоРаспределенияНаСебестоимость = Перечисления.ПравилаРаспределенияНаСебестоимостьТоваров.ПропорциональноКоличеству;
			ИзменилсяВариантРаспределенияРасходовУпр =	Истина;
		ИначеЕсли Объект.ТипРасходов = Перечисления.ТипыРасходов.СкладскоеХранение Тогда
			ТипЗначения = "СправочникСсылка.Склады";
			Вариант = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров;
			Объект.ВариантРаспределенияРасходовУпр =	Вариант;
			Объект.ПравилоРаспределенияНаСебестоимость = Перечисления.ПравилаРаспределенияНаСебестоимостьТоваров.ПропорциональноКоличеству;
			ИзменилсяВариантРаспределенияРасходовУпр =	Истина;
		ИначеЕсли Объект.ТипРасходов = Перечисления.ТипыРасходов.ПродажаТоваров Тогда
			ТипЗначения = "СправочникСсылка.Партнеры";
			Вариант = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПродаж;
			Объект.ВариантРаспределенияРасходовУпр =	Вариант;
			Объект.ПравилоРаспределенияНаСебестоимостьПродажУпр = Перечисления.ПравилаРаспределенияНаСебестоимостьПродаж.ПропорциональноКоличеству;
			ИзменилсяВариантРаспределенияРасходовУпр =	Истина;
		ИначеЕсли Объект.ТипРасходов = Перечисления.ТипыРасходов.ПрочиеРасходы Тогда
			ТипЗначения = "СправочникСсылка.СтруктураПредприятия";
			Вариант = Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности;
			Объект.ВариантРаспределенияРасходовУпр =	Вариант;
			ИзменилсяВариантРаспределенияРасходовУпр =	Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если (ИзменилсяВариантРаспределенияРасходовУпр ) Тогда
		ПривестиВариантыИПравилаКНастройкамУпр();
		ИзменилсяВариантРаспределенияРасходовРегл = Истина;
	КонецЕсли;
	
	Если ИзменилсяТипЗначения Тогда
		ЗаполнитьВидЦенностиНДС();
		СтатьиРасходовЛокализация.ТипЗначенияПриИзмененииСервер(ЭтаФорма);
	КонецЕсли;
	
	Если ИзменилсяВариантРаспределенияРасходовРегл Тогда
		СтатьиРасходовЛокализация.ВариантРаспределенияРасходовРеглПриИзмененииСервер(ЭтаФорма);
	КонецЕсли;
	
	Если НЕ Объект.КонтролироватьЗаполнениеАналитики И 
		(Объект.ТипРасходов = Перечисления.ТипыРасходов.ФормированиеСтоимостиВНА
			ИЛИ Объект.ТипРасходов = Перечисления.ТипыРасходов.ВозникновениеЗатратНаОбъектах
			ИЛИ Объект.ТипРасходов = Перечисления.ТипыРасходов.ПроизводствоПродукции) 
	Тогда
		Объект.КонтролироватьЗаполнениеАналитики = Истина;
	КонецЕсли;
		
	ЗаполнитьСписокВидовАналитикРасходов();
	
	ОчиститьНедоступныеХозяйственныеОперации();
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ТипЗначенияПриИзмененииСервер(ИмяЭлемента)
	
	Если Не ПустаяСтрока(ТипЗначения) Тогда
		Если ТипЗначения = "ДокументСсылка.ЗаказКлиента"
			ИЛИ ТипЗначения = "ДокументСсылка.РеализацияТоваровУслуг"
		Тогда
			Объект.АналитикаРасходовЗаказРеализация = Истина;
			Объект.ТипЗначения = 
				Новый ОписаниеТипов("ДокументСсылка.АктВыполненныхРабот,
				|ДокументСсылка.РеализацияТоваровУслуг,
				|ДокументСсылка.РеализацияУслугПрочихАктивов,
				|ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента,
				|ДокументСсылка.ЗаказКлиента");
		Иначе
			Объект.АналитикаРасходовЗаказРеализация = Ложь;
			Объект.ТипЗначения = Новый ОписаниеТипов(ТипЗначения);
		КонецЕсли;
	КонецЕсли;
	
	
	ЗаполнитьВидЦенностиНДС();
	
	УправлениеЭлементамиФормы();
	
	СтатьиРасходовЛокализация.ТипЗначенияПриИзмененииСервер(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВариантРаспределенияРасходовРеглПриИзмененииСервер()
	
	
	ОчиститьНедоступныеХозяйственныеОперации();
	
	ЗаполнитьВидЦенностиНДС();
	
	СтатьиРасходовЛокализация.ВариантРаспределенияРасходовРеглПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВариантРаспределенияРасходовУпрПриИзмененииСервер()
	
	ОчиститьНедоступныеХозяйственныеОперации();
	
КонецПроцедуры

#КонецОбласти


#Область Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура ОпределитьИспользованиеПолныхВозможностей()
	
	ПолныеВозможности = Ложь;
	
	Если БазоваяВерсия Тогда
		Возврат
	КонецЕсли;
	
	ПолныеВозможности = (Объект.ВариантРаспределенияРасходовУпр <> Объект.ВариантРаспределенияРасходовРегл);
	Если ПолныеВозможности Тогда
		Возврат;
	КонецЕсли;
	
	Правила = Новый Соответствие();
	Если Объект.ВариантРаспределенияРасходовУпр = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров 
			ИЛИ Объект.ВариантРаспределенияРасходовУпр = Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности 
			ИЛИ Объект.ВариантРаспределенияРасходовУпр = Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов 
	Тогда
		Правила.Вставить(Объект.ПравилоРаспределенияРасходовУпр);
	ИначеЕсли Объект.ВариантРаспределенияРасходовУпр = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПродаж 
	Тогда
		Правила.Вставить(Объект.ПравилоРаспределенияНаСебестоимостьПродажУпр);
	КонецЕсли;
	
	Если Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров 
			ИЛИ Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности 
			ИЛИ Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов 
	Тогда
		Правила.Вставить(Объект.ПравилоРаспределенияРасходовРегл);
	ИначеЕсли Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПродаж 
	Тогда
		Правила.Вставить(Объект.ПравилоРаспределенияНаСебестоимостьПродажРегл);
	КонецЕсли;


	ПолныеВозможности = ПолныеВозможности ИЛИ Правила.Количество() > 1;
	
	
КонецПроцедуры


&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	СтатьиРасходовСервер.УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьТиповЗначенийАналитики()
	
	СписокИсключаемыхТипов = Новый СписокЗначений;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
		СписокИсключаемыхТипов.Добавить("ДокументСсылка.ЗаказКлиента");
	КонецЕсли;
		
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам") Тогда
		СписокИсключаемыхТипов.Добавить("ДокументСсылка.ЗаказПоставщику");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаПеремещение") Тогда
		СписокИсключаемыхТипов.Добавить("ДокументСсылка.ЗаказНаПеремещение");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСделкиСКлиентами") Тогда
		СписокИсключаемыхТипов.Добавить("СправочникСсылка.СделкиСКлиентами");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОплатуПлатежнымиКартами") Тогда
		СписокИсключаемыхТипов.Добавить("СправочникСсылка.ЭквайринговыеТерминалы");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями") Тогда
		СписокИсключаемыхТипов.Добавить("ДокументСсылка.ПередачаТоваровМеждуОрганизациями");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ФиксироватьПретензии") Тогда
		СписокИсключаемыхТипов.Добавить("СправочникСсылка.Претензии");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьМаркетинговыеМероприятия") Тогда
		СписокИсключаемыхТипов.Добавить("СправочникСсылка.МаркетинговыеМероприятия");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПеремещениеТоваров") Тогда
		СписокИсключаемыхТипов.Добавить("ДокументСсылка.ПеремещениеТоваров");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат")
	 ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности")
		И НЕ Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.НаправленияДеятельности")) Тогда
		СписокИсключаемыхТипов.Добавить("СправочникСсылка.НаправленияДеятельности");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПроекты") Тогда
		СписокИсключаемыхТипов.Добавить("СправочникСсылка.Проекты");
	КонецЕсли;
	
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		СписокИсключаемыхТипов.Добавить("ПеречислениеСсылка.АналитикаКурсовыхРазниц");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") Тогда
		СписокИсключаемыхТипов.Добавить("СправочникСсылка.СтруктураПредприятия");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		СписокИсключаемыхТипов.Добавить("СправочникСсылка.Организации");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыКредитовИДепозитов") Тогда
		СписокИсключаемыхТипов.Добавить("СправочникСсылка.ДоговорыКредитовИДепозитов");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс") Тогда
		СписокИсключаемыхТипов.Добавить("СправочникСсылка.Кассы");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаСборку") Тогда
		СписокИсключаемыхТипов.Добавить("ДокументСсылка.ЗаказНаСборку");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСборкуРазборку") Тогда
		СписокИсключаемыхТипов.Добавить("ДокументСсылка.СборкаТоваров");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеЗакупки") Тогда
		СписокИсключаемыхТипов.Добавить("ДокументСсылка.ТаможеннаяДекларацияИмпорт");
	КонецЕсли;
	
	
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНеотфактурованныеПоставки")
	 И Не ПолучитьФункциональнуюОпцию("ИспользоватьТоварыВПутиОтПоставщиков") Тогда
		СписокИсключаемыхТипов.Добавить("ДокументСсылка.ПоступлениеТоваровНаСклад");
	КонецЕсли;
	
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранениеВПроцессеЗакупки") Тогда
		СписокИсключаемыхТипов.Добавить("ДокументСсылка.ВыкупПринятыхНаХранениеТоваров");
	КонецЕсли;
	
	Поле = Элементы.ТипЗначения;
	Для Каждого Элемент Из СписокИсключаемыхТипов Цикл
		ЭлементСписка = Поле.СписокВыбора.НайтиПоЗначению(Элемент.Значение);
		Если ЭлементСписка <> Неопределено И ТипЗначения <> Элемент.Значение Тогда
			Поле.СписокВыбора.Удалить(ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры




#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПривестиВариантыИПравилаКНастройкамУпр()
	
	Объект.ВариантРаспределенияРасходовРегл = Объект.ВариантРаспределенияРасходовУпр; 
	Объект.ПравилоРаспределенияРасходовРегл = Объект.ПравилоРаспределенияРасходовУпр;
	Объект.ПравилоРаспределенияНаСебестоимостьПродажРегл = Объект.ПравилоРаспределенияНаСебестоимостьПродажУпр;
	
	 
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЭтоУТ = ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	БазоваяВерсия = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	ИспользуетсяРеглУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	ЛокализацияРФ = ПолучитьФункциональнуюОпцию("ЛокализацияРФ");
	
	
	
	Если Не (ИспользуетсяРеглУчет 
		)
	Тогда
		Элементы.ГруппаСтраницаРеглУчет.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаКорреспондирующийСчет.Видимость = Ложь;
	Если ЭтоУТ Или НЕ ИспользуетсяРеглУчет Или НЕ ЛокализацияРФ Тогда
		Элементы.ГруппаКорреспондирующийСчет.Видимость = Истина;
		Элементы.КорреспондирующийСчет.Маска = ОбменДаннымиСобытияУТУП.МаскаСчета();
		Если НЕ ЛокализацияРФ Тогда
			Элементы.КорреспондирующийСчет.КнопкаВыпадающегоСписка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоУТ Тогда
		ЭлементСписка = Элементы.ВидДеятельностиРасходов.СписокВыбора.НайтиПоЗначению(Перечисления.ВидыДеятельностиРасходов.ОсновнаяИПрочаяДеятельность); 
		Если ЭлементСписка <> Неопределено Тогда
			Элементы.ВидДеятельностиРасходов.СписокВыбора.Удалить(ЭлементСписка);
		КонецЕсли;
		Элементы.ПереключательИспользоватьПолныеВозможности.Видимость = Не БазоваяВерсия;
		Элементы.НадписьНастроитьПравилаРаспределения.Видимость = Ложь;
	КонецЕсли;
	

	ОпределитьИспользованиеПолныхВозможностей();

	ФормироватьФинансовыйРезультат = ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат");
	
	ЗаполнитьСписокВидовАналитикРасходов();
	УстановитьТипЗначения(Объект.ТипЗначения);
	УправлениеЭлементамиФормы();
	ЗаполнитьСписокДоступныхХозяйственныхОпераций();
	
	СтатьиРасходовЛокализация.ПриЧтенииСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипЗначения(ВыбранныйТипЗначения)
	
	Если ВыбранныйТипЗначения = Неопределено Тогда
		Если ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
			ВыбранныйТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Склады");
		Иначе
			ВыбранныйТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
		КонецЕсли;
	КонецЕсли;
	
	ИсключаемыеТипы = Новый Массив;
	СписокТиповЗначений = Элементы.ТипЗначения.СписокВыбора;
	Для Каждого ЭлементСписка Из СписокТиповЗначений Цикл
		Если ИсключаемыеТипы.Найти(ЭлементСписка.Значение) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если ВыбранныйТипЗначения.СодержитТип(Тип(ЭлементСписка.Значение)) Тогда
			ТипЗначения = ЭлементСписка.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьНедоступныеХозяйственныеОперации()
	
	ТекущиеДоступныеХозяйственныеОперации = ОбщегоНазначения.СкопироватьРекурсивно(ДоступныеХозяйственныеОперации);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьСписокХозяйственныхОпераций(
		ДоступныеХозяйственныеОперации,
		Объект.ВариантРаспределенияРасходовУпр,
		Объект.ВариантРаспределенияРасходовРегл);
		
	Для Каждого ТекущийЭлементСписка Из ТекущиеДоступныеХозяйственныеОперации Цикл
		Если Не ТекущийЭлементСписка.Пометка Тогда
			Продолжить;
		КонецЕсли;
		ЭлементСписка = ДоступныеХозяйственныеОперации.НайтиПоЗначению(ТекущийЭлементСписка.Значение);
		Если ЭлементСписка <> Неопределено Тогда
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхХозяйственныхОпераций()
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьСписокХозяйственныхОпераций(
		ДоступныеХозяйственныеОперации,
		Объект.ВариантРаспределенияРасходовУпр,
		Объект.ВариантРаспределенияРасходовРегл);
	
	Для Каждого СтрокаТаблицы Из Объект.ДоступныеХозяйственныеОперации Цикл
		ЭлементСписка = ДоступныеХозяйственныеОперации.НайтиПоЗначению(СтрокаТаблицы.ХозяйственнаяОперация);
		Если ЭлементСписка <> Неопределено Тогда
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВидовАналитикРасходов()
	
	СписокВыбора = Элементы.ТипЗначения.СписокВыбора;
	СписокВыбора.Очистить();
	
	Если Ложь Тогда
	ИначеЕсли Объект.ТипРасходов = ПредопределенноеЗначение("Перечисление.ТипыРасходов.ЗакупкаТоваров") Тогда
		СписокВыбора.Добавить("ДокументСсылка.ЗаказПоставщику", 					НСтр("ru='Заказ поставщику'"));
		СписокВыбора.Добавить("ДокументСсылка.ПриобретениеТоваровУслуг", 			НСтр("ru='Приобретение товаров и услуг'"));
		СписокВыбора.Добавить("ДокументСсылка.ПоступлениеТоваровНаСклад", 					НСтр("ru='Поступление товаров'"));
		Если ЕстьВводОстатковСтарогоОбразца() Тогда
			СписокВыбора.Добавить("ДокументСсылка.ВводОстатков", 						НСтр("ru='Ввод остатков'"));
			СписокВыбора.Добавить("ДокументСсылка.ВводОстатковТоваров", 				НСтр("ru='Ввод остатков (2.5)'"));
		Иначе
			СписокВыбора.Добавить("ДокументСсылка.ВводОстатковТоваров", 				НСтр("ru='Ввод остатков'"));
		КонецЕсли;
		СписокВыбора.Добавить("ДокументСсылка.ПередачаТоваровМеждуОрганизациями", 	НСтр("ru='Передача товаров между организациями'"));
		СписокВыбора.Добавить("ДокументСсылка.ТаможеннаяДекларацияИмпорт", 			НСтр("ru='Таможенная декларация'"));
		Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранениеВПроцессеЗакупки") Тогда
			СписокВыбора.Добавить("ДокументСсылка.ВыкупПринятыхНаХранениеТоваров", 			НСтр("ru='Выкуп товаров с хранения'"));
		КонецЕсли;
		
	ИначеЕсли Объект.ТипРасходов = ПредопределенноеЗначение("Перечисление.ТипыРасходов.СкладскоеХранение") Тогда
		СписокВыбора.Добавить("СправочникСсылка.Склады", 			НСтр("ru='Склад (Место хранения)'"));
		СписокВыбора.Добавить("СправочникСсылка.Номенклатура", 		НСтр("ru='Номенклатура'"));
		СписокВыбора.Добавить("ДокументСсылка.ЗаказНаПеремещение", 	НСтр("ru='Заказ на перемещение'"));
		СписокВыбора.Добавить("ДокументСсылка.ПеремещениеТоваров", 	НСтр("ru='Перемещение товаров'"));
		СписокВыбора.Добавить("ДокументСсылка.ЗаказНаСборку", 		НСтр("ru='Заказ на сборку (разборку)'"));
		СписокВыбора.Добавить("ДокументСсылка.СборкаТоваров", 		НСтр("ru='Сборка (разборка) товаров'"));
		СписокВыбора.Добавить("ДокументСсылка.ПрочееОприходованиеТоваров", 	НСтр("ru='Прочее оприходование'"));
		
	ИначеЕсли Объект.ТипРасходов = ПредопределенноеЗначение("Перечисление.ТипыРасходов.ПродажаТоваров") Тогда
		СписокВыбора.Добавить("СправочникСсылка.Партнеры",					НСтр("ru='Клиент'"));
		СписокВыбора.Добавить("СправочникСсылка.СделкиСКлиентами",			НСтр("ru='Сделка'"));
		Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
			СписокВыбора.Добавить("ДокументСсылка.ЗаказКлиента",			НСтр("ru='Заказ / Реализация'"));
		Иначе
			СписокВыбора.Добавить("ДокументСсылка.РеализацияТоваровУслуг",	НСтр("ru='Реализация товаров и услуг'"));
		КонецЕсли;
		
		
	ИначеЕсли Объект.ТипРасходов = ПредопределенноеЗначение("Перечисление.ТипыРасходов.ПрочиеРасходы") Тогда
		СписокВыбора.Добавить("СправочникСсылка.СтруктураПредприятия", 		НСтр("ru='Подразделение'"));
		СписокВыбора.Добавить("СправочникСсылка.Организации", 				НСтр("ru='Организация'"));
		СписокВыбора.Добавить("ПеречислениеСсылка.АналитикаКурсовыхРазниц", НСтр("ru='Виды курсовых разниц'"));
		СписокВыбора.Добавить("СправочникСсылка.Кассы", 					НСтр("ru='Касса'"));
		СписокВыбора.Добавить("СправочникСсылка.ФизическиеЛица", 			НСтр("ru='Физическое лицо'"));
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности") Тогда
			СписокВыбора.Добавить("СправочникСсылка.НаправленияДеятельности",	НСтр("ru='(не используется) Направление деятельности'"));
		Иначе
			СписокВыбора.Добавить("СправочникСсылка.НаправленияДеятельности",	НСтр("ru='Направление деятельности'"));
		КонецЕсли;
		СписокВыбора.Добавить("СправочникСсылка.ДоговорыКредитовИДепозитов",НСтр("ru='Договор кредита (депозита)'"));
		СписокВыбора.Добавить("СправочникСсылка.МаркетинговыеМероприятия", 	НСтр("ru='Маркетинговое мероприятие'"));
		СписокВыбора.Добавить("СправочникСсылка.Претензии", 		        НСтр("ru='Претензия клиента'"));
		СписокВыбора.Добавить("СправочникСсылка.Проекты", 					НСтр("ru='Проект'"));
		СписокВыбора.Добавить("СправочникСсылка.Склады", 					НСтр("ru='Склад (Место хранения)'"));
		СписокВыбора.Добавить("СправочникСсылка.Номенклатура", 				НСтр("ru='Номенклатура'"));
		СписокВыбора.Добавить("СправочникСсылка.ПрочиеРасходы", 			НСтр("ru='Прочие расходы'"));
		СтатьиРасходовЛокализация.ДополнитьСписокТиповАналитикамиУчетаЗарплаты(СписокВыбора);
		
		
	КонецЕсли;
	
	УстановитьВидимостьТиповЗначенийАналитики();
	ДополнитьСписокВидовАналитикРасходовЭлементамиЗависимымиОтВариантовРаспределения();
		
КонецПроцедуры

&НаСервере
Процедура ДополнитьСписокВидовАналитикРасходовЭлементамиЗависимымиОтВариантовРаспределения()
	СписокДобавляемыхТипов = Новый СписокЗначений;
	СписокИсключаемыхТипов = Новый СписокЗначений;
	
	
	Если Объект.ТипРасходов = ПредопределенноеЗначение("Перечисление.ТипыРасходов.ПродажаТоваров") Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьМаркетинговыеМероприятия") 
			И (Объект.ВариантРаспределенияРасходовУпр = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПродаж
				ИЛИ Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПродаж


			) Тогда
				СписокДобавляемыхТипов.Добавить("СправочникСсылка.МаркетинговыеМероприятия", 	НСтр("ru = 'Маркетинговое мероприятие'"));
		Иначе
				СписокИсключаемыхТипов.Добавить("СправочникСсылка.МаркетинговыеМероприятия");
		КонецЕсли;
	КонецЕсли;
	
	Поле = Элементы.ТипЗначения;
	Для Каждого Элемент Из СписокИсключаемыхТипов Цикл
		ЭлементСписка = Поле.СписокВыбора.НайтиПоЗначению(Элемент.Значение);
		Если ЭлементСписка <> Неопределено И ТипЗначения <> Элемент.Значение Тогда
			Поле.СписокВыбора.Удалить(ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Элемент Из СписокДобавляемыхТипов Цикл
		ЭлементСписка = Поле.СписокВыбора.НайтиПоЗначению(Элемент.Значение);
		Если ЭлементСписка = Неопределено Тогда
			Поле.СписокВыбора.Добавить(Элемент.Значение, Элемент.Представление);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидЦенностиНДС()
	
	Если Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
		Объект.ВидЦенностиНДС = Перечисления.ВидыЦенностей.Товары;
	Иначе
		Объект.ВидЦенностиНДС = Перечисления.ВидыЦенностей.ПрочиеРаботыИУслуги;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЕстьВводОстатковСтарогоОбразца()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВводОстатковТовары.Ссылка
	|ИЗ
	|	Документ.ВводОстатков.Товары КАК ВводОстатковТовары
	|ГДЕ
	|	ВводОстатковТовары.Ссылка.Проведен");
	Результат = Запрос.Выполнить().Выбрать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат.Следующий();
	
КонецФункции

#КонецОбласти

#КонецОбласти
