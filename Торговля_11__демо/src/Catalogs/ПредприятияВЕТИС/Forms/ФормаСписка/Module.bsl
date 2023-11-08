#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
	ОбработатьПереданныеПараметры(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	НастроитьЭлементыФормыПриСоздании();
	УстановитьЗаголовокФормы();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПредприятияВЕТИС"
		И ТипЗнч(Параметр) = Тип("СправочникСсылка.ПредприятияВЕТИС")
		И ЗначениеЗаполнено(Параметр) Тогда
		
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Параметр;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыФормыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если РежимВыбора Тогда
		
		Если ТекущаяСтраница  = Элементы.СтраницаЗагруженные Тогда
		
			Элементы.СписокВыбрать.КнопкаПоУмолчанию = Истина;
			
		Иначе
			
			Элементы.ВыбратьИзКлассификатора.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПереключениеМеждуСтраницамиВыполнялось
		И ТипЗнч(ПараметрыПоиска) = Тип("Структура")
		И ПараметрыПоиска.Количество() > 0 Тогда
		
		ОбработатьНайденныеПредприятия(1);
		
	КонецЕсли;
	
	ПереключениеМеждуСтраницамиВыполнялось = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОтборПоХозяйствующемуСубъектуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьХозяйствующийСубъект" Тогда
		
		ПоказатьЗначение(, ХозяйствующийСубъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоПредприятияХозяйствующегоСубъектаПриИзменении(Элемент)
	
	ОтборПоХозяйствующемуСубъектуПриИзмененииСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоДоступныеПриИзменении(Элемент)
	
	ОтборПоХозяйствующемуСубъектуПриИзмененииСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СвязаноПриИзменении(Элемент)
	
	ОтборСвязаноПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМаркировкаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"НомераПредприятий.Номер",
		ОтборМаркировка,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборМаркировка));
	
КонецПроцедуры
 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПриВыбореИзЗагруженных();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Производитель");
	Таблица.Колонки.Добавить("НомераПредприятий");
	
	Для каждого Строка Из Строки Цикл
		Таблица.Добавить().Производитель = Строка.Значение.Данные["Ссылка"];
	КонецЦикла;
	Таблица.Индексы.Добавить("Производитель");
	
	Справочники.ПредприятияВЕТИС.ЗаполнитьНомера(Таблица);
	
	Для каждого Строка Из Строки Цикл
		
		ДанныеСтроки = Строка.Значение.Данные;
		ДанныеСтроки["Маркировка"] = Таблица.НайтиСтроки(Новый Структура("Производитель", ДанныеСтроки["Ссылка"]))[0].НомераПредприятий;
		
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПредприятия

&НаКлиенте
Процедура ПредставлениеПараметровПоискаВКлассификатореОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьФормуПараметрыПоиска" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ПараметрыПоиска", ПараметрыПоиска);
		
		ОткрытьФорму(
			"Справочник.ПредприятияВЕТИС.Форма.ПараметрыПоиска",
			ПараметрыОткрытия,
			ЭтотОбъект,,,,
			Новый ОписаниеОповещения("ОбработатьПараметрыПоискаВКлассификаторе", ЭтотОбъект));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПриВыбореИзДанныхКлассификатора();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ХозяйствующийСубъект",          Неопределено);
	ПараметрыОткрытияФормы.Вставить("Предприятие",                   Неопределено);
	ПараметрыОткрытияФормы.Вставить("СоздаетсяХозяйствующийСубъект", Ложь);
	ПараметрыОткрытияФормы.Вставить("ОтборПредприятие",              ПараметрыПоиска);
	
	ОповещениеПослеСоздания = Новый ОписаниеОповещения("ПредприятиеПослеСоздания", ЭтотОбъект);
	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.СозданиеХозяйствующегоСубъектаИПредприятия",
		ПараметрыОткрытияФормы, ЭтотОбъект,,,ОповещениеПослеСоздания);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеКлассификатора(Команда)
	
	ТекущиеДанные = Элементы.Предприятия.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, ИнтеграцияИСКлиентСервер.ТекстКомандаНеМожетБытьВыполнена());
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуДанныхКлассификатора(ТекущиеДанные.GUID);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	
	ПриВыбореИзДанныхКлассификатора();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзЗагруженных(Команда)
	
	ПриВыбореИзЗагруженных();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияФормыИУправлениеЭлементами

&НаСервере
Процедура ОбработатьПереданныеПараметры(Отказ)

	РежимВыбора                       = Параметры.РежимВыбора;
	ХозяйствующийСубъект              = Параметры.ХозяйствующийСубъект;
	НедоступноИзменениеОтбора         = Параметры.НедоступноИзменениеОтбора;
	ВыборИдентификаторов              = Параметры.ВыборИдентификаторов;
	ХозяйствующийСубъектИдентификатор = Параметры.ХозяйствующийСубъектИдентификатор;
	ХозяйствующийСубъектПредставление = Параметры.ХозяйствующийСубъектПредставление;
	ОтборСвязано                      = Параметры.Связано;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Если Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора) Тогда
		
		ДальнейшееДействиеВЕТИС = Неопределено;
		Если ИнтеграцияВЕТИСКлиентСервер.НеобходимОтборПоДальнейшемуДействиюВЕТИСПриСозданииНаСервере(ДальнейшееДействиеВЕТИС, СтруктураБыстрогоОтбора) Тогда
			УстановитьОтборПоДальнейшемуДействиюСервер(ДальнейшееДействиеВЕТИС);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ХозяйствующийСубъект) Тогда
		
		ТолькоДоступные = Истина;
		ОтобразитьОтборПоХозяйствующемуСубъекту();
		
	ИначеЕсли Не ПустаяСтрока(ХозяйствующийСубъектИдентификатор) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ХозяйствующиеСубъектыВЕТИС.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъектыВЕТИС
		|ГДЕ
		|	ХозяйствующиеСубъектыВЕТИС.Идентификатор = &Идентификатор");
		
		Запрос.УстановитьПараметр("Идентификатор", ХозяйствующийСубъектИдентификатор);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			ХозяйствующийСубъект = Выборка.Ссылка;
			ОтобразитьОтборПоХозяйствующемуСубъекту();
			
		Иначе
			
			ОтобразитьОтборПоИдентификаторуХозяйствующегоСубъекта();
			
		КонецЕсли;
		
	Иначе
		
		Если Не ПустаяСтрока(Параметры.Связано)
			И РежимВыбора Тогда
			ОтборСвязано = Параметры.Связано;
		Иначе
			ОтборСвязано = "Все";
		КонецЕсли;
		
		ОтборСвязаноПриИзмененииНаСервере();
		
		Если ТипЗнч(Параметры.ПараметрыПоиска) = Тип("Структура") Тогда
			ПараметрыПоиска = Параметры.ПараметрыПоиска;
			ОбработатьНайденныеПредприятия(1);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьОтборПоХозяйствующемуСубъекту()
	
	ТолькоПредприятияХозяйствующегоСубъекта = Истина;
	
	Строки = Новый Массив;
	Строки.Добавить(НСтр("ru = 'Только предприятия ХС'"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(ХозяйствующийСубъект),,ЦветГиперссылки,,"ОткрытьХозяйствующийСубъект"));
	
	ПредставлениеОтборПоХозяйствующемуСубъекту = Новый ФорматированнаяСтрока(Строки);
	
	Элементы.ГруппаОтборХозяйствующийСубъект.Видимость           = Истина;
	Элементы.ТолькоПредприятияХозяйствующегоСубъекта.Доступность = Не НедоступноИзменениеОтбора;
	
	ОтборПоХозяйствующемуСубъектуПриИзмененииСервере();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХозяйствующиеСубъектыВЕТИС.Идентификатор КАК Идентификатор,
	|	ХозяйствующиеСубъектыВЕТИС.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъектыВЕТИС
	|ГДЕ
	|	ХозяйствующиеСубъектыВЕТИС.Ссылка = &ХозяйствующийСубъект");
	
	Запрос.УстановитьПараметр("ХозяйствующийСубъект", ХозяйствующийСубъект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("ИдентификаторХС",        Выборка.Идентификатор);
		ПараметрыПоиска.Вставить("ПредставлениеХС",        Выборка.Наименование);
		ПараметрыПоиска.Вставить("ТолькоСредиПредприятий", Истина);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОтборСвязаноПриИзмененииНаСервере()

	Если ОтборСвязано = "Все" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка",Неопределено,,,Ложь);
		
	ИначеЕсли ОтборСвязано = "Наши" Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие КАК Ссылка
		|ИЗ
		|	Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК ХозяйствующиеСубъектыВЕТИСПредприятия
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъектыВЕТИС
		|		ПО ХозяйствующиеСубъектыВЕТИСПредприятия.Ссылка = ХозяйствующиеСубъектыВЕТИС.Ссылка
		|ГДЕ
		|	ХозяйствующиеСубъектыВЕТИС.СоответствуетОрганизации");
		
		МассивПредприятий = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Ссылка",
			МассивПредприятий,ВидСравненияКомпоновкиДанных.ВСписке,
			НСтр("ru = 'Условие по связи предприятий'"),
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	ИначеЕсли ОтборСвязано = "Подключенные" Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие КАК Ссылка
		|ИЗ
		|	Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК ХозяйствующиеСубъектыВЕТИСПредприятия
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъектыВЕТИС
		|		ПО ХозяйствующиеСубъектыВЕТИСПредприятия.Ссылка = ХозяйствующиеСубъектыВЕТИС.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиПодключенияВЕТИС КАК НастройкиПодключенияВЕТИС
		|		ПО (ХозяйствующиеСубъектыВЕТИС.Ссылка = НастройкиПодключенияВЕТИС.ХозяйствующийСубъект)");
		
		МассивПредприятий = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Ссылка",
			МассивПредприятий,ВидСравненияКомпоновкиДанных.ВСписке,
			НСтр("ru = 'Условие по связи предприятий'"),
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОтобразитьОтборПоИдентификаторуХозяйствующегоСубъекта()

	ТолькоПредприятияХозяйствующегоСубъекта = Истина;
	
	Если ЗначениеЗаполнено(ХозяйствующийСубъектПредставление) Тогда
		ПредставлениеОтбора = СтрШаблон(НСтр("ru = 'Только предприятия XC %1'"), ХозяйствующийСубъектПредставление);
	Иначе
		ПредставлениеОтбора = СтрШаблон(НСтр("ru = 'Только предприятия XC с идентификатором %1'"), ХозяйствующийСубъектИдентификатор);
	КонецЕсли;
	
	ПредставлениеОтборПоХозяйствующемуСубъекту = Новый ФорматированнаяСтрока(ПредставлениеОтбора);
	
	Элементы.ГруппаОтборХозяйствующийСубъект.Видимость           = Истина;
	Элементы.ТолькоПредприятияХозяйствующегоСубъекта.Доступность = Не НедоступноИзменениеОтбора;
	
	ОтборПоХозяйствующемуСубъектуПриИзмененииСервере();
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("ИдентификаторХС",        ХозяйствующийСубъектИдентификатор);
	ПараметрыПоиска.Вставить("ПредставлениеХС",        ХозяйствующийСубъектПредставление);
	ПараметрыПоиска.Вставить("ТолькоСредиПредприятий", Истина);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыПриСоздании()

	СформироватьПредставлениеПараметровПоиска(ПараметрыПоиска, Истина);

	Элементы.ПоискНеНастроен.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.ПоискНеНастроен.ОтображениеСостояния.Текст = НСтр("ru = 'Элементы классификатора не выведены. Настройте отбор и выполните поиск.'");
	Элементы.ПоискНеНастроен.ОтображениеСостояния.Видимость = Истина;
	
	Элементы.СписокВыбрать.Видимость                = РежимВыбора;
	Элементы.СписокКонтекстноеМенюВыбрать.Видимость = РежимВыбора;
	
	Элементы.Связано.Видимость = РежимВыбора
	                             И Не ЗначениеЗаполнено(ХозяйствующийСубъект)
	                             И Не ЗначениеЗаполнено(ХозяйствующийСубъектИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

#Область ПредприятияТипНеизвестен

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредприятияТип.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Предприятия.Тип");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыХозяйствующихСубъектовВЕТИС.ФизическоеЛицо;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<неизвестен>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
#КонецОбласти

#Область ПредприятияВидыДеятельностиНеизвестны

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредприятияВидыДеятельности.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Предприятия.КоличествоВидовДеятельности");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<неизвестны>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
#КонецОбласти

#Область ПредприятияНомераНеизвестны

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредприятияНомераПредприятий.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Предприятия.КоличествоНомеровПредприятий");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<неизвестны>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
#КонецОбласти

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()

	ТекстЗаголовка = "";
	
	Если РежимВыбора Тогда
		
		ТекстЗаголовка = НСтр("ru = 'Выбор предприятия'");
		
	Иначе
		
		ТекстЗаголовка = НСтр("ru = 'Предприятия'");
		
	КонецЕсли;
	
	Заголовок = ТекстЗаголовка;

КонецПроцедуры

#КонецОбласти

#Область Поиск

&НаСервере
Процедура ЗагрузитьСписокПредприятий(Результат, НомерСтраницы)
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Фильтры = Новый Структура;
	
	ЦерберВЕТИСВызовСервера.УстановитьОтборПоАдресуВФильтре(ПараметрыПоиска, Фильтры);
	
	СписокПредприятий = Новый Массив;
	Для Каждого businessEntity Из Результат.Список Цикл
		
		Если businessEntity.Свойство("enterprise") Тогда
			СписокПредприятий.Добавить(businessEntity.enterprise);
		Иначе
			СписокПредприятий.Добавить(businessEntity);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из СписокПредприятий Цикл
		
		Если Не ЦерберВЕТИСВызовСервера.АдресСоответствуетФильтру(СтрокаТЧ.address, Фильтры) Тогда
			Продолжить;
		КонецЕсли;
		
		ДобавитьСтрокуСПредприятием(СтрокаТЧ);
		
	КонецЦикла;
	
	ОбщееКоличество      = Результат.ОбщееКоличество;
	ТекущийНомерСтраницы = НомерСтраницы;
	
	КоличествоСтраниц = ОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	ОпределитьНаличиеПредприятийВИБ();
	СформироватьПредставлениеПараметровПоиска(ПараметрыПоиска);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуСПредприятием(ДанныеПредприятия)
	
	НоваяСтрока = Предприятия.Добавить();
	НоваяСтрока.Активность    = ДанныеПредприятия.active;
	НоваяСтрока.Актуальность  = ДанныеПредприятия.last;
	НоваяСтрока.GUID          = ДанныеПредприятия.GUID;
	НоваяСтрока.UUID          = ДанныеПредприятия.UUID;
	НоваяСтрока.Наименование  = ДанныеПредприятия.Name;
	НоваяСтрока.ДатаСоздания  = ДанныеПредприятия.createDate;
	НоваяСтрока.ДатаИзменения = ДанныеПредприятия.updateDate;
	
	Если ЗначениеЗаполнено(ДанныеПредприятия.address) Тогда
		
		НоваяСтрока.ДанныеАдреса        = ДанныеПредприятия.address;
		НоваяСтрока.ПредставлениеАдреса = ДанныеПредприятия.address.addressView;
		
	КонецЕсли;
	
	НоваяСтрока.Статус         = ИнтеграцияВЕТИСПовтИсп.СтатусВерсионногоОбъекта(ДанныеПредприятия.status);
	НоваяСтрока.СтатусВРеестре = ИнтеграцияВЕТИСПовтИсп.СтатусПредприятияВРеестре(ДанныеПредприятия.registryStatus);
	НоваяСтрока.Тип            = ИнтеграцияВЕТИСПовтИсп.ТипПредприятия(ДанныеПредприятия.type);
	
	Если ЗначениеЗаполнено(ДанныеПредприятия.activityList) Тогда
		Для Каждого activity Из ДанныеПредприятия.activityList.activity Цикл
			НоваяСтрока.ВидыДеятельности.Добавить(activity.name);
		КонецЦикла;
	КонецЕсли;
	
	НоваяСтрока.КоличествоВидовДеятельности = НоваяСтрока.ВидыДеятельности.Количество();
	
	Если ЗначениеЗаполнено(ДанныеПредприятия.numberList) Тогда
		Для Каждого НомерПредприятия Из ДанныеПредприятия.numberList.enterpriseNumber Цикл
			НоваяСтрока.НомераПредприятий.Добавить(НомерПредприятия);
		КонецЦикла;
	КонецЕсли;
	
	НоваяСтрока.КоличествоНомеровПредприятий = НоваяСтрока.НомераПредприятий.Количество();
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНаличиеПредприятийВИБ()

	Если Предприятия.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	МассивИдентификаторов = Предприятия.Выгрузить(, "GUID").ВыгрузитьКолонку("GUID");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПредприятияВЕТИС.Идентификатор КАК Идентификатор,
	|	ПредприятияВЕТИС.Ссылка        КАК Ссылка
	|ИЗ
	|	Справочник.ПредприятияВЕТИС КАК ПредприятияВЕТИС
	|ГДЕ
	|	ПредприятияВЕТИС.Идентификатор В(&МассивИдентификаторов)";
	
	Запрос.УстановитьПараметр("МассивИдентификаторов", МассивИдентификаторов);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ПараметрыПоискаИмеющихся = Новый Структура;
		ПараметрыПоискаИмеющихся.Вставить("GUID", Выборка.Идентификатор);
		
		НайденныеСтроки = Предприятия.НайтиСтроки(ПараметрыПоискаИмеющихся);
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.ИндексКартинкиЕстьВБазе = 1;
			НайденнаяСтрока.Предприятие             = Выборка.Ссылка;
		КонецЦикла;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВСписокНайденноеПредприятие(Результат)
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если Результат.Элемент <> Неопределено Тогда
		ДобавитьСтрокуСПредприятием(Результат.Элемент);
		ОпределитьНаличиеПредприятийВИБ();
	КонецЕсли;
	
	ОбщееКоличество      = 1;
	ТекущийНомерСтраницы = 1;
	КоличествоСтраниц    = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПараметрыПоискаВКлассификаторе(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено
		Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПоиска = Результат;
	ОбработатьНайденныеПредприятия(1);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьНайденныеПредприятия(НомерСтраницы)
	
	Предприятия.Очистить();
	
	КоличествоЭлементовНаСтранице = 1000;
	
	Если ПараметрыПоиска.Свойство("ТолькоСредиПредприятий")
		И ПараметрыПоиска.ТолькоСредиПредприятий Тогда
		
		Результат = ЦерберВЕТИСВызовСервера.СписокПредприятийХозяйствующегоСубъекта(ПараметрыПоиска.ИдентификаторХС, НомерСтраницы);
		ЗагрузитьСписокПредприятий(Результат, НомерСтраницы);
		
	ИначеЕсли ПараметрыПоиска.Свойство("Идентификатор") Тогда
		
		Результат = ЦерберВЕТИСВызовСервера.ПредприятиеПоGUID(ПараметрыПоиска.Идентификатор);
		ДобавитьВСписокНайденноеПредприятие(Результат);
		
	ИначеЕсли ПараметрыПоиска.Свойство("GLN") Тогда
		
		Результат = ЦерберВЕТИСВызовСервера.ХозяйствующийСубъектИПредприятиеПоGLN(ПараметрыПоиска.GLN);
		ЗаполнитьРезультатыНайденоПоGLN(Результат);
		
	ИначеЕсли ПараметрыПоиска.Свойство("НомерПредприятия") Тогда
		
		Если ПараметрыПоиска.РежимПоиска = 0 Тогда
			Результат = ЦерберВЕТИСВызовСервера.СписокПредприятийРФ(ПараметрыПоиска, НомерСтраницы, Ложь, КоличествоЭлементовНаСтранице);
		Иначе
			Результат = ЦерберВЕТИСВызовСервера.СписокЗарубежныхПредприятий(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);
		КонецЕсли;
		
		ЗагрузитьСписокПредприятий(Результат, НомерСтраницы)
		
	ИначеЕсли ПараметрыПоиска.РежимПоиска = 0 Тогда
		
		Результат = ЦерберВЕТИСВызовСервера.СписокПредприятийРФ(ПараметрыПоиска, НомерСтраницы, Ложь, КоличествоЭлементовНаСтранице);
		ЗагрузитьСписокПредприятий(Результат, НомерСтраницы)
		
	ИначеЕсли ПараметрыПоиска.РежимПоиска = 1 Тогда
		
		Результат = ЦерберВЕТИСВызовСервера.СписокЗарубежныхПредприятий(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);
		ЗагрузитьСписокПредприятий(Результат, НомерСтраницы);
		
	КонецЕсли;
	
	СформироватьПредставлениеПараметровПоиска(ПараметрыПоиска);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРезультатыНайденоПоGLN(Результат)
	
	Если Результат = Неопределено Тогда
		
		ДанныеХозяйствующегоСубъектаПоGLN = Неопределено;
		
	Иначе
		
		Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(Результат.ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		ДобавитьСтрокуСПредприятием(Результат.Элемент.enterprise);
		Если Предприятия.Количество() > 0 Тогда
			ДанныеПредприятия = Предприятия[0];
		Иначе
			Возврат;
		КонецЕсли;
		
		ДанныеХозяйствующегоСубъектаПоGLN = ИнтеграцияВЕТИС.ДанныеХозяйствующегоСубъекта(Результат.Элемент.businessEntity, Ложь);
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ХозяйствующиеСубъектыВЕТИС.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъектыВЕТИС
		|ГДЕ
		|	ХозяйствующиеСубъектыВЕТИС.Идентификатор = &ИдентификаторХозяйствующегоСубъекта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПредприятияВЕТИС.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПредприятияВЕТИС КАК ПредприятияВЕТИС
		|ГДЕ
		|	ПредприятияВЕТИС.Идентификатор = &ИдентификаторПредприятия";
		
		Запрос.УстановитьПараметр("ИдентификаторХозяйствующегоСубъекта", ДанныеХозяйствующегоСубъектаПоGLN.Идентификатор);
		Запрос.УстановитьПараметр("ИдентификаторПредприятия",            ДанныеПредприятия.GUID);
		
		Результат = Запрос.ВыполнитьПакет();
		ВыборкаХозяйствующийСубъект = Результат[0].Выбрать();
		
		Если ВыборкаХозяйствующийСубъект.Следующий() Тогда
			ДанныеХозяйствующегоСубъектаПоGLN.Ссылка = ВыборкаХозяйствующийСубъект.Ссылка;
		КонецЕсли;
		
		ВыборкаПредприятие = Результат[1].Выбрать();
		
		Если ВыборкаПредприятие.Следующий() Тогда
			ДанныеПредприятия.Предприятие             = ВыборкаПредприятие.Ссылка;
			ДанныеПредприятия.ИндексКартинкиЕстьВБазе = 1;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНомераСтраницыПредприятия(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьНайденныеПредприятия(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ПредставлениеОтбора

&НаСервере
Процедура СформироватьПредставлениеПараметровПоиска(ПараметрыОтбора, ПриСоздании = Ложь)
	
	СтрокаОтбор = "";
	
	КоличествоПараметровОтбора = 0;
	
	Если ПараметрыОтбора <> Неопределено Тогда
		
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Наименование'"),         "Наименование",         КоличествоПараметровОтбора);
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Номер предприятия'"),    "Номер",                КоличествоПараметровОтбора);
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Адрес'"),                "ДанныеАдреса",         КоличествоПараметровОтбора);
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'GLN'"),                  "GLN",                  КоличествоПараметровОтбора);
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Идентификатор'"),        "Идентификатор",        КоличествоПараметровОтбора);
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Идентификатор версии'"), "ИдентификаторВерсии",  КоличествоПараметровОтбора);
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'ИдентификаторХС'"),      "ИдентификаторХС",      КоличествоПараметровОтбора);
		
	КонецЕсли;
	
	Если КоличествоПараметровОтбора = 0 Тогда
		
		ПредставлениеОтбора = ПредставлениеПустогоОтбора(ЭтотОбъект, ПриСоздании);
		
	Иначе
		
		ПредставлениеОтбора = ПредставлениеНеПустогоОтбора(СтрокаОтбор, ЭтотОбъект, ПриСоздании);
		
	КонецЕсли;
	
	КоличествоСтраницНесколько = КоличествоСтраниц > 1;
	НулевойРезультат           = Предприятия.Количество() = 0;
	
	Элементы.ГруппаИнформацияОНеКорректномЗапросе.Видимость = КоличествоСтраницНесколько И Не НулевойРезультат;
	
	Если ПриСоздании Или КоличествоСтраницНесколько И НулевойРезультат Тогда
		
		Элементы.КартинкаИнформацияНеНастроенПоиск.Видимость = Истина;
		Элементы.Создать.Видимость                           = Ложь;
		Элементы.ВыбратьИзКлассификатора.Видимость           = Ложь;
		
		Элементы.СтраницыПредприятия.ТекущаяСтраница = Элементы.СтраницаПредприятияПоискНеВыполнен;
		
		Если КоличествоСтраницНесколько Тогда
			Элементы.КартинкаИнформацияНеНастроенПоиск.Видимость  = Ложь;
			Элементы.ПоискНеНастроен.ОтображениеСостояния.Текст   =
				НСтр("ru = 'Заданные условия поиска дали слишком много результатов. Уточните реквизиты отбора и выполните поиск.'");
		КонецЕсли;
		
	Иначе
		
		Элементы.КартинкаИнформацияНеНастроенПоиск.Видимость                 = Ложь;
		Элементы.Создать.Видимость                                           = Не РежимВыбора И КоличествоПараметровОтбора > 0;
		Элементы.ВыбратьИзКлассификатора.Видимость                           = РежимВыбора;
		Элементы.ПредприятияКонтекстноеМенюВыбратьИзКлассификатора.Видимость = РежимВыбора;
		
		Элементы.СтраницыПредприятия.ТекущаяСтраница = Элементы.СтраницаПредприятияЭлементы;
		
	КонецЕсли;
	
	ПредставлениеПараметровПоиска = ПредставлениеОтбора;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеПустогоОтбора(Форма, ПриСоздании = Ложь)
	
	Если ПриСоздании Тогда
	
		Строки = Новый Массив;
		Строки.Добавить(НСтр("ru = 'Для вывода предприятий'"));
		Строки.Добавить(" ");
		Строки.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'настройте отбор'"),,
				Форма.ЦветГиперссылки,,
				"ОткрытьФормуПараметрыПоиска"));
		Строки.Добавить(" ");
		Строки.Добавить(НСтр("ru = 'и выполните поиск'"));
	
	Иначе
		
		СтрокаПредставлениеОтбора = НСтр("ru = 'Отбор не настроен'");
		
		МассивСтрокИзменить = Новый Массив;
		
		Если Форма.НедоступноИзменениеОтбора Тогда
			МассивСтрокИзменить.Добавить("");
		Иначе
			
			МассивСтрокИзменить.Добавить(" (");
			МассивСтрокИзменить.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru = 'настроить отбор'"),,
					Форма.ЦветГиперссылки,,
					"ОткрытьФормуПараметрыПоиска"));
			МассивСтрокИзменить.Добавить(")");
		КонецЕсли;
		
		Строки = Новый Массив;
		Строки.Добавить(СтрокаПредставлениеОтбора);
		Строки.Добавить(Новый ФорматированнаяСтрока(МассивСтрокИзменить));
		
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(Строки);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеНеПустогоОтбора(СтрокаОтбор, Форма, ПриСоздании = Ложь)
	
	СтрокаПредставлениеОтбора = СтрШаблон(НСтр("ru = 'Установлен отбор по %1'"), СтрокаОтбор);
	
	МассивСтрокИзменить = Новый Массив;
	
	Если Форма.НедоступноИзменениеОтбора Тогда
		МассивСтрокИзменить.Добавить("");
	Иначе
		
		МассивСтрокИзменить.Добавить(" (");
		МассивСтрокИзменить.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'изменить'"),,
				Форма.ЦветГиперссылки,,
				"ОткрытьФормуПараметрыПоиска"));
		МассивСтрокИзменить.Добавить(")");
	КонецЕсли;
	
	Строки = Новый Массив;
	Строки.Добавить(СтрокаПредставлениеОтбора);
	Строки.Добавить(Новый ФорматированнаяСтрока(МассивСтрокИзменить));
	
	Возврат Новый ФорматированнаяСтрока(Строки);
	
КонецФункции

&НаСервере
Процедура ДобавитьВПредставление(Представление, ПараметрыОтбора, ПредставлениеПоля, ИмяПоля, КоличествоПараметров)
	
	Если ПараметрыОтбора.Свойство(ИмяПоля) Тогда
		
		Если ТипЗнч(ПараметрыОтбора[ИмяПоля]) = Тип("Структура")
			И ПараметрыОтбора[ИмяПоля].Свойство("ПредставлениеАдреса") Тогда
			Значение = ПараметрыОтбора[ИмяПоля].ПредставлениеАдреса;
		Иначе
			Значение = ПараметрыОтбора[ИмяПоля];
		КонецЕсли;
		
	Иначе
		
		Значение = Неопределено;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоПараметров = КоличествоПараметров + 1;
	
	Если ИмяПоля = "ИдентификаторХС" Тогда
		
		Если ПараметрыПоиска.Свойство("ТолькоСредиПредприятий")
			И ПараметрыПоиска.ТолькоСредиПредприятий Тогда
			
			Если ЗначениеЗаполнено(ПараметрыПоиска.ПредставлениеХС) Тогда
			
				ПредставлениеПоля = НСтр("ru = 'Хозяйствующий субъект'");
				Значение          = ПараметрыПоиска.ПредставлениеХС;
				
			Иначе
				
				ПредставлениеПоля = НСтр("ru = 'Идентификатор ХС'");
				Значение          = ПараметрыПоиска.ИдентификаторХС;
				
			КонецЕсли;
			
		Иначе
			
			Возврат;
			
		КонецЕсли
		
	КонецЕсли;
	
	Если ИмяПоля = "Наименование" Тогда
		
		Разделитель = " " + НСтр("ru = 'содержит'") + " ";
		
	Иначе
		
		Разделитель = " = ";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Представление) Тогда
		Представление = Представление + " " + НСтр("ru = 'и'") + " " + ПредставлениеПоля + Разделитель + """" + Значение + """";
	Иначе
		Представление = ПредставлениеПоля + Разделитель + """" + Значение + """";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаСобытий

&НаКлиенте
Процедура ПредприятиеПослеСоздания(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора
		И ЗначениеЗаполнено(Результат)
		И ТипЗнч(Результат) = Тип("СправочникСсылка.ПредприятияВЕТИС") Тогда
		
		ОповеститьОВыборе(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДанныхКлассификатора(ИдентификаторХС)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Идентификатор", ИдентификаторХС);
	
	ОповещениеОЗакрытииФормыДанныхКлассификатора = Новый ОписаниеОповещения("ДанныеКлассификатораПослеЗакрытия", ЭтотОбъект);
	ОткрытьФорму(
		"Справочник.ПредприятияВЕТИС.Форма.ДанныеКлассификатора",
		ПараметрыФормы, ЭтотОбъект,,,,
		ОповещениеОЗакрытииФормыДанныхКлассификатора,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеКлассификатораПослеЗакрытия(Результат, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(Результат)
		И ТипЗнч(Результат) = Тип("СправочникСсылка.ПредприятияВЕТИС") Тогда
		
		Если РежимВыбора Тогда
			ОповеститьОВыборе(Результат);
		Иначе
			ОпределитьНаличиеПредприятийВИБ();
			Элементы.Список.ТекущаяСтрока = Результат;
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагруженные;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореИзДанныхКлассификатора()

	ТекущиеДанные = Элементы.Предприятия.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		
		Если ВыборИдентификаторов Тогда
			
			ДанныеВыбора = ПустаяСтруктураВозвратаВыборИдентификаторов();
			ДанныеВыбора.Ссылка        = ТекущиеДанные.Предприятие;
			ДанныеВыбора.Наименование  = ТекущиеДанные.Наименование;
			ДанныеВыбора.Идентификатор = ТекущиеДанные.GUID;
			
			ОповеститьОВыборе(ДанныеВыбора);
			
		ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Предприятие) Тогда
		
			ОповеститьОВыборе(ТекущиеДанные.Предприятие);
			
		Иначе
			
			ОткрытьФормуДанныхКлассификатора(ТекущиеДанные.GUID);
			
		КонецЕсли;
		
	Иначе
		
		ОткрытьФормуДанныхКлассификатора(ТекущиеДанные.GUID);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореИзЗагруженных()
	
	ОчиститьСообщения();
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.Список, Истина, Ложь) Тогда
		ПоказатьПредупреждение(, ИнтеграцияИСКлиентСервер.ТекстКомандаНеМожетБытьВыполнена());
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если РежимВыбора Тогда
		
		Если ВыборИдентификаторов Тогда
			
			ДанныеВыбора = ПустаяСтруктураВозвратаВыборИдентификаторов();
			ДанныеВыбора.Ссылка        = ТекущиеДанные.Ссылка;
			ДанныеВыбора.Наименование  = ТекущиеДанные.Наименование;
			ДанныеВыбора.Идентификатор = ТекущиеДанные.Идентификатор;
			
			ОповеститьОВыборе(ДанныеВыбора);
			
		Иначе
			
			ОповеститьОВыборе(ТекущиеДанные.Ссылка);
			
		КонецЕсли;
		
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОтборПоХозяйствующемуСубъектуПриИзмененииСервере()

	Если Не ТолькоПредприятияХозяйствующегоСубъекта Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка", Неопределено,,, Ложь);
	Иначе
		
		ПользовательВЕТИС = ПользователиВЕТИС.ТекущийПользовательВЕТИС();
		
		Если ТолькоДоступные Тогда
			
			ЕстьОграниченияПоАдресам = Ложь;
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ИСТИНА КАК СтранаИдентификатор
			|ИЗ
			|	РегистрСведений.АдресаЗонОтветственностиВЕТИС КАК АдресаЗонОтветственностиВЕТИС
			|ГДЕ
			|	АдресаЗонОтветственностиВЕТИС.ХозяйствующийСубъект = &ХозяйствующийСубъект
			|	И АдресаЗонОтветственностиВЕТИС.ПользовательВЕТИС = &ПользовательВЕТИС
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ПредприятияЗонОтветственностиВЕТИС.Предприятие КАК Предприятие
			|ИЗ
			|	РегистрСведений.ПредприятияЗонОтветственностиВЕТИС КАК ПредприятияЗонОтветственностиВЕТИС
			|ГДЕ
			|	ПредприятияЗонОтветственностиВЕТИС.ХозяйствующийСубъект = &ХозяйствующийСубъект
			|	И ПредприятияЗонОтветственностиВЕТИС.ПользовательВЕТИС = &ПользовательВЕТИС
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие КАК Предприятие
			|ИЗ
			|	Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК ХозяйствующиеСубъектыВЕТИСПредприятия
			|ГДЕ
			|	ХозяйствующиеСубъектыВЕТИСПредприятия.Ссылка = &ХозяйствующийСубъект
			|	И НЕ ХозяйствующиеСубъектыВЕТИСПредприятия.НеИспользовать");
			
			Запрос.УстановитьПараметр("ХозяйствующийСубъект", ХозяйствующийСубъект);
			Запрос.УстановитьПараметр("ПользовательВЕТИС",    ПользовательВЕТИС);
			
			Результат = Запрос.ВыполнитьПакет();
			
			ВыборкаОграниченияПоАдресам = Результат[0].Выбрать();
			Если ВыборкаОграниченияПоАдресам.Количество() > 0 Тогда
			
				ЕстьОграниченияПоАдресам = Истина;
			
			КонецЕсли;
			
			МассивПредприятий = Результат[1].Выгрузить().ВыгрузитьКолонку("Предприятие");
			
			Если МассивПредприятий.Количество() = 0
				И Не ЕстьОграниченияПоАдресам Тогда
				
				МассивПредприятий = Результат[2].Выгрузить().ВыгрузитьКолонку("Предприятие");
				
			КонецЕсли;
			
		Иначе
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие КАК Предприятие
			|ИЗ
			|	Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК ХозяйствующиеСубъектыВЕТИСПредприятия
			|ГДЕ
			|	ХозяйствующиеСубъектыВЕТИСПредприятия.Ссылка = &ХозяйствующийСубъект
			|	И НЕ ХозяйствующиеСубъектыВЕТИСПредприятия.НеИспользовать");
			
			Запрос.УстановитьПараметр("ХозяйствующийСубъект", ХозяйствующийСубъект);
			
			МассивПредприятий = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Предприятие");
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Ссылка",
			МассивПредприятий,ВидСравненияКомпоновкиДанных.ВСписке,
			НСтр("ru = 'Предприятия хозяйствующего субъекта'"),
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ПустаяСтруктураВозвратаВыборИдентификаторов()
	
	ПустаяСтруктура = Новый Структура;
	ПустаяСтруктура.Вставить("Ссылка",        ПредопределенноеЗначение("Справочник.ПредприятияВЕТИС.ПустаяСсылка"));
	ПустаяСтруктура.Вставить("Наименование",  "");
	ПустаяСтруктура.Вставить("Идентификатор", "");
	
	Возврат ПустаяСтруктура;
	
КонецФункции

#КонецОбласти

#Область ОтборДальнейшиеДействия

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер(ДальнейшееДействиеВЕТИС)
	
	Если ДальнейшееДействиеВЕТИС = Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПроверьтеКорректностьДанных Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ТребуетсяЗагрузка", Истина,,, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти