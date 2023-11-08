#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	КоэффициентПересчетаВТонны     		 = НоменклатураСервер.КоэффициентПересчетаВТонны(Константы.ЕдиницаИзмеренияВеса.Получить());
	КоэффициентПересчетаВКубическиеМетры = НоменклатураСервер.КоэффициентПересчетаВКубическиеМетры(Константы.ЕдиницаИзмеренияОбъема.Получить());
	
	ДатаОтбор        = Параметры.ДатаОтбор;
	Склад	         = Параметры.Склад;
	ТребуемыйВес     = Параметры.ИтогоВес * КоэффициентПересчетаВТонны;
	ТребуемыйОбъем   = Параметры.ИтогоОбъем * КоэффициентПересчетаВКубическиеМетры;
	ОсталосьВес      = ТребуемыйВес;
	ОсталосьОбъем    = ТребуемыйОбъем;
	НабралиВесПроц   = 0;
	НабралиОбъемПроц = 0;
	Если НЕ ЗначениеЗаполнено(ДатаОтбор) Тогда
		ДатаОтбор = ТекущаяДатаСеанса;
	КонецЕсли;
	ЗаданияФормируемые.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресЗаданийФормируемых));
	ОбновитьСписокТранспорта();
	ДоставкаТоваровКлиентСервер.ЗаполнитьСписокВыбораПоляВремени(Элементы.ВыбранныеТранспортныеСредстваВремяС);
	ДоставкаТоваровКлиентСервер.ЗаполнитьСписокВыбораПоляВремени(Элементы.ВыбранныеТранспортныеСредстваВремяПо);
	
	Если ЗначениеЗаполнено(Параметры.ЗаданиеБудетВыполнять) Тогда
		ЗаданиеБудетВыполнять = Параметры.ЗаданиеБудетВыполнять;
		Элементы.ЗаданиеБудетВыполнять.ТолькоПросмотр = Истина;
	Иначе
		ЗаданиеБудетВыполнять = Перечисления.ТипыИсполнителейЗаданийНаПеревозку.НашаТранспортнаяСлужба;
	КонецЕсли;
	НастроитьПоТипуИсполнителя();	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		И ВыбранныеТранспортныеСредства.Количество() > 0 Тогда
		
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'");
		
		Возврат;
		
	КонецЕсли;
	
	Если Не ВыполняетсяЗакрытие
		И ВыбранныеТранспортныеСредства.Количество() > 0 Тогда
		
		Отказ = Истина;
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Перенести и закрыть'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не переносить и закрыть'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(Новый ОписаниеОповещения("ПослеВопросаОЗакрытии", ЭтотОбъект),
			НСтр("ru = 'Выбранные транспортные средства не перенесены в список формируемых заданий. Перенести?'"), Кнопки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОЗакрытии(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть(АдресНовыхЗаданийВХранилище());
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ТранспортноеСредство" Тогда
		ДобавитьИзменитьСтрокуСТранспортом(Источник);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция АдресНовыхЗаданийВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(ВыбранныеТранспортныеСредства.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ДатаОтборПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("ДатаОтборПриИзмененииОбработчикОжидания", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтборРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(ДатаОтбор) Тогда
		СтандартнаяОбработка = Ложь;
		ДатаОтбор = ТекущаяДатаСеанса;
		ПодключитьОбработчикОжидания("ДатаОтборПриИзмененииОбработчикОжидания", 0.3, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТранспортныеСредстваВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПеренестиСтроки(Элементы.ТранспортныеСредства.ВыделенныеСтроки)
КонецПроцедуры

&НаКлиенте
Процедура ТранспортныеСредстваНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	НачалиПеретаскивание = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТранспортныеСредстваОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	НачалиПеретаскивание = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТипыТранспортныхСредствВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПеренестиСтроки(Элементы.ТипыТранспортныхСредств.ВыделенныеСтроки, Ложь)
КонецПроцедуры

&НаКлиенте
Процедура ТранспортныеСредстваПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	Если Копирование Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.ТранспортныеСредства.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ТранспортныеСредства.ФормаОбъекта",ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыТранспортныхСредствНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	НачалиПеретаскивание = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТипыТранспортныхСредствОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	НачалиПеретаскивание = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеТранспортныеСредстваПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Если НЕ НачалиПеретаскивание Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	Иначе
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеТранспортныеСредстваПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Если ЗаданиеБудетВыполнять = ПредопределенноеЗначение("Перечисление.ТипыИсполнителейЗаданийНаПеревозку.НашаТранспортнаяСлужба") Тогда
		ПараметрыПеретаскиванияЗначение = ПараметрыПеретаскивания.Значение[0]; // СправочникСсылка.ТипыТранспортныхСредств, ДанныеФормыСтруктура
		Если ТипЗнч(ПараметрыПеретаскиванияЗначение) =Тип("СправочникСсылка.ТипыТранспортныхСредств") Тогда
			ПеренестиСтроки(Элементы.ТипыТранспортныхСредств.ВыделенныеСтроки, Ложь)
		ИначеЕсли ПараметрыПеретаскиванияЗначение.Свойство("Ссылка")
			И ТипЗнч(ПараметрыПеретаскиванияЗначение.Ссылка) =Тип("СправочникСсылка.ТранспортныеСредства") Тогда
			ПеренестиСтроки(Элементы.ТранспортныеСредства.ВыделенныеСтроки)
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(Перевозчик) Тогда
			ТекстСообщения = "ru = 'Выберите перевозчика'";
			ПоказатьПредупреждение(, ТекстСообщения);
			Возврат;
		КонецЕсли;
		ПеренестиСтроки(Элементы.ТипыТранспортныхСредствПеревозчика.ВыделенныеСтроки, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеТранспортныеСредстваПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	УдалитьСтрокиВыбранныхТранспортныхСредств(Элементы.ВыбранныеТранспортныеСредства.ВыделенныеСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеТранспортныеСредстваДатаВремяПриИзменении(Элемент)
	
	ПроверитьСкорректироватьОтсортироватьПоВремени(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеТранспортныеСредстваПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеБудетВыполнятьПриИзменении(Элемент)
	Если ЗаданиеБудетВыполнять = ПредопределенноеЗначение("Перечисление.ТипыИсполнителейЗаданийНаПеревозку.ПустаяСсылка") Тогда
		ЗаданиеБудетВыполнять = ПредопределенноеЗначение("Перечисление.ТипыИсполнителейЗаданийНаПеревозку.НашаТранспортнаяСлужба");
		Если Элементы.СтраницыТипыИсполнителей.ТекущаяСтраница = Элементы.СтраницаНашаТранспортнаяСлужба Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	НастроитьПоТипуИсполнителя();
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикПриИзменении(Элемент)
	
	ПеревозчикПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ТранспортныеСредстваИзменить(Команда)
	ТекущиеДанные = Элементы.ТранспортныеСредства.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПоказатьЗначение(,ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	Если ЗаданиеБудетВыполнять = ПредопределенноеЗначение("Перечисление.ТипыИсполнителейЗаданийНаПеревозку.НашаТранспортнаяСлужба") Тогда
		Если Элементы.СтраницыТранспортныеСредстваТипы.ТекущаяСтраница = Элементы.СтраницыТранспортныеСредстваТипы.ПодчиненныеЭлементы.СтраницаТранспортныеСредства Тогда
			ПеренестиСтроки(Элементы.ТранспортныеСредства.ВыделенныеСтроки)
		Иначе 
			ПеренестиСтроки(Элементы.ТипыТранспортныхСредств.ВыделенныеСтроки, Ложь)
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(Перевозчик) Тогда
			ТекстСообщения = НСтр("ru = 'Выберите перевозчика'");
			ПоказатьПредупреждение(, ТекстСообщения);
			Возврат;
		КонецЕсли;
		ПеренестиСтроки(Элементы.ТипыТранспортныхСредствПеревозчика.ВыделенныеСтроки, Ложь)
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Убрать(Команда)
	Если Элементы.ВыбранныеТранспортныеСредства.ВыделенныеСтроки.Количество() > 0 Тогда
		УдалитьСтрокиВыбранныхТранспортныхСредств(Элементы.ВыбранныеТранспортныеСредства.ВыделенныеСтроки)
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВыбранныеВДоставку(Команда)
	ВыполняетсяЗакрытие = Истина;
	Если ВыбранныеТранспортныеСредства.Количество() = 0 Тогда
		Закрыть();
	Иначе
		Закрыть(АдресНовыхЗаданийВХранилище());
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТранспортныеСредстваНаименование.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТранспортныеСредства.НормЧастота");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 0.7;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветИтоговыхПоказателейДокументов);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТранспортныеСредстваЗаданияНаПеревозку.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТранспортныеСредства.ЗаданияНаПеревозку");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<нет заданий на перевозку>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВыбранныеТранспортныеСредстваПеревозчик.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВыбранныеТранспортныеСредства.Перевозчик");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<наша транспортная служба>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокТранспортныеСредстваЗаданияНаПеревозку()
	Если НЕ ЗначениеЗаполнено(ДатаОтбор) Тогда
		Элементы.ТранспортныеСредстваЗаданияНаПеревозку.Видимость = Ложь;
	Иначе
		Элементы.ТранспортныеСредстваЗаданияНаПеревозку.Видимость = Истина;
		Элементы.ТранспортныеСредстваЗаданияНаПеревозку.Заголовок = НСтр("ru = 'Задания на перевозку на ';") 
																	+ Формат(ДатаОтбор, Нстр("ru='ДФ=""д МММ""'"));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокТранспорта()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаданиеНаПеревозку.ТранспортноеСредство КАК ТранспортноеСредство,
	|	СУММА(1) КАК Частота
	|ПОМЕСТИТЬ ВТЧастотаИспользованияТранспорта
	|ИЗ
	|	Документ.ЗаданиеНаПеревозку КАК ЗаданиеНаПеревозку
	|ГДЕ
	|	ЗаданиеНаПеревозку.Проведен
	|	И ЗаданиеНаПеревозку.Дата >= &ДатаДляСтатистики
	|	И НЕ ЗаданиеНаПеревозку.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаданийНаПеревозку.Формируется)
	|	И ЗаданиеНаПеревозку.Склад В ИЕРАРХИИ(&Склад)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаданиеНаПеревозку.ТранспортноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТранспортныеСредства.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА влЧастотаИспользованияТранспорта.Частота ЕСТЬ NULL 
	|			ТОГДА 0
	|		КОГДА ИтогиЧастотаИспользованияТранспорта.МаксЧастота = 0
	|			ТОГДА 0
	|		ИНАЧЕ влЧастотаИспользованияТранспорта.Частота / ИтогиЧастотаИспользованияТранспорта.МаксЧастота
	|	КОНЕЦ КАК НормЧастота,
	|	ЛОЖЬ КАК Выбран,
	|	0 КАК ВыбранСчетчик
	|ИЗ
	|	Справочник.ТранспортныеСредства КАК ТранспортныеСредства
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЧастотаИспользованияТранспорта КАК влЧастотаИспользованияТранспорта
	|		ПО (влЧастотаИспользованияТранспорта.ТранспортноеСредство = ТранспортныеСредства.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ВТЧастотаИспользованияТранспорта.Частота) КАК МаксЧастота
	|		ИЗ
	|			ВТЧастотаИспользованияТранспорта КАК ВТЧастотаИспользованияТранспорта) КАК ИтогиЧастотаИспользованияТранспорта
	|		ПО (ИСТИНА)
	|ГДЕ
	|	НЕ ТранспортныеСредства.ПометкаУдаления";
	Запрос.УстановитьПараметр("ДатаДляСтатистики",ДобавитьМесяц(ТекущаяДатаСеанса, -2));
	Запрос.УстановитьПараметр("Склад", Склад);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат
	КонецЕсли;
	
	ТранспортныеСредства.Загрузить(Результат.Выгрузить());
	ЗаполнитьЗаданияНаПеревозку();
	УстановитьЗаголовокТранспортныеСредстваЗаданияНаПеревозку()
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаданияНаПеревозку()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаданияНаПеревозкуПланируемые.ТранспортноеСредство,
	|	ЗаданияНаПеревозкуПланируемые.Ссылка,
	|	ЗаданияНаПеревозкуПланируемые.Статус,
	|	ЗаданияНаПеревозкуПланируемые.ВремяС,
	|	ЗаданияНаПеревозкуПланируемые.ВремяПо
	|ПОМЕСТИТЬ ВТЗаданияНаПеревозкуПланируемые
	|ИЗ
	|	&ЗаданияНаПеревозкуПланируемые КАК ЗаданияНаПеревозкуПланируемые
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТЗаданияНаПеревозкуПланируемые.ТранспортноеСредство, ЗаданиеНаПеревозку.ТранспортноеСредство) КАК Ссылка,
	|	ЕСТЬNULL(ВТЗаданияНаПеревозкуПланируемые.Статус, ЗаданиеНаПеревозку.Статус) КАК Статус,
	|	ЕСТЬNULL(ВТЗаданияНаПеревозкуПланируемые.ВремяС, ВЫБОР
	|			КОГДА ЗаданиеНаПеревозку.ДатаВремяРейсаФактС = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЗаданиеНаПеревозку.ДатаВремяРейсаПланС
	|			ИНАЧЕ ЗаданиеНаПеревозку.ДатаВремяРейсаФактС
	|		КОНЕЦ) КАК ВремяС,
	|	ЕСТЬNULL(ВТЗаданияНаПеревозкуПланируемые.ВремяПо, ВЫБОР
	|			КОГДА ЗаданиеНаПеревозку.ДатаВремяРейсаФактПо = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЗаданиеНаПеревозку.ДатаВремяРейсаПланПо
	|			ИНАЧЕ ЗаданиеНаПеревозку.ДатаВремяРейсаФактПо
	|		КОНЕЦ) КАК ВремяПо
	|ИЗ
	|	Документ.ЗаданиеНаПеревозку КАК ЗаданиеНаПеревозку
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаданияНаПеревозкуПланируемые КАК ВТЗаданияНаПеревозкуПланируемые
	|		ПО (ВТЗаданияНаПеревозкуПланируемые.Ссылка = ЗаданиеНаПеревозку.Ссылка)
	|ГДЕ
	|	ЗаданиеНаПеревозку.Проведен
	|	И НАЧАЛОПЕРИОДА(ВЫБОР
	|				КОГДА ЗаданиеНаПеревозку.ДатаВремяРейсаФактС = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА ЗаданиеНаПеревозку.ДатаВремяРейсаПланС
	|				ИНАЧЕ ЗаданиеНаПеревозку.ДатаВремяРейсаФактС
	|			КОНЕЦ, ДЕНЬ) = &ДатаОтбор
	|	И НЕ ЗаданиеНаПеревозку.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаданийНаПеревозку.Закрыто)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВремяС,
	|	ВремяПо";
	
	Запрос.УстановитьПараметр("ДатаОтбор",ДатаОтбор);
	Запрос.УстановитьПараметр("ЗаданияНаПеревозкуПланируемые",ЗаданияФормируемые.Выгрузить());
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат
	КонецЕсли;
	
	ТаблицаЗаданийНаПеревозку = Результат.Выгрузить();
	
	Для Каждого Стр Из ТранспортныеСредства Цикл
		МассивЗаданийНаПеревозку = ТаблицаЗаданийНаПеревозку.НайтиСтроки(Новый Структура("Ссылка", Стр.Ссылка));
		СтрЗаданияНаПеревозку = "";
		Для Каждого ВлСтр Из МассивЗаданийНаПеревозку Цикл
			Если НачалоДня(ВлСтр.ВремяС) = НачалоДня(ВлСтр.ВремяПо) Тогда
				СтрЗаданияНаПеревозку = СтрЗаданияНаПеревозку + ?(СтрЗаданияНаПеревозку = "","",Символы.ПС) + НСтр("ru='С';")
										+ Символы.НПП + Формат(ВлСтр.ВремяС, Нстр("ru='ДФ=""ЧЧ:мм""'")) + Символы.НПП + НСтр("ru='до';")
										+ Символы.НПП + Формат(ВлСтр.ВремяПо, Нстр("ru='ДФ=""ЧЧ:мм""'")) + " (" + ВлСтр.Статус + ")"
			Иначе
				СтрЗаданияНаПеревозку = СтрЗаданияНаПеревозку + ?(СтрЗаданияНаПеревозку = "","",Символы.ПС) + НСтр("ru='С';")
										+ Символы.НПП + Формат(ВлСтр.ВремяС, Нстр("ru='ДФ=""ЧЧ:мм""'")) + Символы.НПП + НСтр("ru='весь день (';") + ВлСтр.Статус + ")"
			КонецЕсли;
		КонецЦикла;
		Стр.ЗаданияНаПеревозку = СтрЗаданияНаПеревозку;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтборПриИзмененииОбработчикОжидания()
	ДатаОтборПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура ПеренестиСтроки(Знач МассивСтрок, ЭтоТранспортныеСредства = Истина)
	Если МассивСтрок.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не выбран транспорт';"));
		Возврат;
	КонецЕсли;
	Для Каждого ИдентификаторСсылка Из МассивСтрок Цикл
		НоваяСтр = ВыбранныеТранспортныеСредства.Добавить();
		РеквизитыТранспорта = "Наименование, ГрузоподъемностьВТоннах, ВместимостьВКубическихМетрах";
		Если ЭтоТранспортныеСредства Тогда
			СтрокаТранспорт = ТранспортныеСредства.НайтиПоИдентификатору(ИдентификаторСсылка);
			Ссылка = СтрокаТранспорт.Ссылка;
			СтрокаТранспорт.Выбран = Истина;
			СтрокаТранспорт.ВыбранСчетчик = СтрокаТранспорт.ВыбранСчетчик + 1;
			РеквизитыТранспорта = РеквизитыТранспорта +",Тип";
		Иначе
			Ссылка = ИдентификаторСсылка;
		КонецЕсли;
		НоваяСтр.Ссылка = Ссылка;
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, РеквизитыТранспорта);
		ЗаполнитьЗначенияСвойств(НоваяСтр, СтруктураРеквизитов);
		НоваяСтр.ВремяС = НачалоДня(ДатаОтбор);
		НоваяСтр.ВремяПо = НачалоДня(ДатаОтбор);
		НоваяСтр.ЗаданиеВыполняет = ЗаданиеБудетВыполнять;
		Если ЗаданиеБудетВыполнять = Перечисления.ТипыИсполнителейЗаданийНаПеревозку.Перевозчик Тогда 
			НоваяСтр.Перевозчик = Перевозчик;
			НоваяСтр.Контрагент = Контрагент;
			НоваяСтр.БанковскийСчетПеревозчика = БанковскийСчетПеревозчика;
		КонецЕсли;
	КонецЦикла;
	
	Если ТребуемыйВес <> 0 Тогда
		ОсталосьВес = ТребуемыйВес - ВыбранныеТранспортныеСредства.Итог("ГрузоподъемностьВТоннах");
		НабралиВесПроц = 100 * (ТребуемыйВес - ОсталосьВес) / ТребуемыйВес;
	КонецЕсли;
	Если ТребуемыйОбъем <> 0 Тогда
		ОсталосьОбъем = ТребуемыйОбъем - ВыбранныеТранспортныеСредства.Итог("ВместимостьВКубическихМетрах");
		НабралиОбъемПроц = 100 * (ТребуемыйОбъем - ОсталосьОбъем) / ТребуемыйОбъем;
	КонецЕсли;
	ВыбранныеТранспортныеСредства.Сортировать("ВремяС, ВремяПо");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиВыбранныхТранспортныхСредств(Знач МассивСтрок)
	Для Каждого ИД Из МассивСтрок Цикл
		СтрокаТранспорт = ВыбранныеТранспортныеСредства.НайтиПоИдентификатору(ИД);
		Если СтрокаТранспорт = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТребуемыйВес <> 0 Тогда
			ОсталосьВес = ОсталосьВес + СтрокаТранспорт.ГрузоподъемностьВТоннах;
			НабралиВесПроц = 100 * (ТребуемыйВес - ОсталосьВес) / ТребуемыйВес;
		КонецЕсли;
		Если ТребуемыйОбъем <> 0 Тогда
			ОсталосьОбъем = ОсталосьОбъем + СтрокаТранспорт.ВместимостьВКубическихМетрах;
			НабралиОбъемПроц = 100 * (ТребуемыйОбъем - ОсталосьОбъем) / ТребуемыйОбъем;
		КонецЕсли;
		Если ТипЗнч(СтрокаТранспорт.Ссылка) = Тип("СправочникСсылка.ТранспортныеСредства") Тогда
			МассивСтрок = ТранспортныеСредства.НайтиСтроки(Новый Структура("Ссылка",
																			СтрокаТранспорт.Ссылка));
			Если МассивСтрок.Количество() > 0 Тогда
				Если МассивСтрок[0].ВыбранСчетчик < 2 Тогда
					МассивСтрок[0].ВыбранСчетчик = 0;
					МассивСтрок[0].Выбран = Ложь;
				Иначе
					МассивСтрок[0].ВыбранСчетчик = МассивСтрок[0].ВыбранСчетчик - 1;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ВыбранныеТранспортныеСредства.Удалить(СтрокаТранспорт);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСкорректироватьОтсортироватьПоВремени(ИмяЭлемента)
	
	ТекДанные = Элементы.ВыбранныеТранспортныеСредства.ТекущиеДанные;
	ТекДанные.ВремяС = НачалоДня(ТекДанные.ВремяС)
				+ Час(ТекДанные.ВремяСБезДаты)*60*60 + Минута(ТекДанные.ВремяСБезДаты)*60;
	ТекДанные.ВремяПо = НачалоДня(ТекДанные.ВремяПо)
				+ Час(ТекДанные.ВремяПоБезДаты)*60*60 + Минута(ТекДанные.ВремяПоБезДаты)*60;
	Если ТекДанные.ВремяПо < ТекДанные.ВремяС Тогда
		Если СтрНайти(ИмяЭлемента,"По") = 0 Тогда
			ТекДанные.ВремяПо = ТекДанные.ВремяС;
			ТекДанные.ВремяПоБезДаты = ТекДанные.ВремяСБезДаты;
		Иначе
			ТекДанные.ВремяС = ТекДанные.ВремяПо;
			ТекДанные.ВремяСБезДаты = ТекДанные.ВремяПоБезДаты;
		КонецЕсли;
	КонецЕсли;
	ТекущаяСтрока = ВыбранныеТранспортныеСредства.НайтиПоИдентификатору(Элементы.ВыбранныеТранспортныеСредства.ТекущаяСтрока);
	ТекущийИндекс = ВыбранныеТранспортныеСредства.Индекс(ТекДанные);
	
	Если (ТекущийИндекс>0 И (ВыбранныеТранспортныеСредства[ТекущийИндекс-1].ВремяС > ТекущаяСтрока.ВремяС
							 ИЛИ (ВыбранныеТранспортныеСредства[ТекущийИндекс-1].ВремяС = ТекущаяСтрока.ВремяС
							 	  И ВыбранныеТранспортныеСредства[ТекущийИндекс-1].ВремяПо > ТекущаяСтрока.ВремяПо)))
		  ИЛИ (ТекущийИндекс < ВыбранныеТранспортныеСредства.Количество()-1
		  	   И (ВыбранныеТранспортныеСредства[ТекущийИндекс+1].ВремяС < ТекущаяСтрока.ВремяС
							 ИЛИ (ВыбранныеТранспортныеСредства[ТекущийИндекс+1].ВремяС = ТекущаяСтрока.ВремяС
							 	  И ВыбранныеТранспортныеСредства[ТекущийИндекс+1].ВремяПо < ТекущаяСтрока.ВремяПо))) Тогда
		ВыбранныеТранспортныеСредства.Сортировать("ВремяС, ВремяПо");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьИзменитьСтрокуСТранспортом(Ссылка)
	
	Строки = ТранспортныеСредства.НайтиСтроки(Новый Структура("Ссылка", Ссылка));
	Если Строки.Количество() = 0 Тогда
		НоваяСтрока = ТранспортныеСредства.Добавить();
		НоваяСтрока.Ссылка = Ссылка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаОтборПриИзмененииСервер()
	Если НЕ ЗначениеЗаполнено(ДатаОтбор) Тогда
		ДатаОтбор = ТекущаяДатаСеанса;
	КонецЕсли;
	ЗаполнитьЗаданияНаПеревозку();
	УстановитьЗаголовокТранспортныеСредстваЗаданияНаПеревозку();
КонецПроцедуры

&НаСервере
Процедура НастроитьПоТипуИсполнителя()
	
	Если ЗаданиеБудетВыполнять = Перечисления.ТипыИсполнителейЗаданийНаПеревозку.НашаТранспортнаяСлужба Тогда
		Элементы.СтраницыТипыИсполнителей.ТекущаяСтраница = Элементы.СтраницаНашаТранспортнаяСлужба;
	Иначе
		Элементы.СтраницыТипыИсполнителей.ТекущаяСтраница = Элементы.СтраницаПеревозчики;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПеревозчикПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Перевозчик) Тогда
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Перевозчик, Контрагент, Истина);
		
		Если ЗначениеЗаполнено(Контрагент) Тогда
			БанковскийСчетПеревозчика = Справочники.БанковскиеСчетаКонтрагентов.ПолучитьБанковскийСчетПоУмолчанию(Контрагент);
		КонецЕсли;
	Иначе
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		БанковскийСчетПеревозчика = Справочники.БанковскиеСчетаКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
