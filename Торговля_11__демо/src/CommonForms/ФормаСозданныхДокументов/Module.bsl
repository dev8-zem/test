
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗагрузитьСписок(Отказ);
	УстановитьЗаголовокПрограммно();
	ЗагрузитьПараметры();
	
	СписокТипов = Новый Массив;
	Для каждого Элемент Из СписокДокументов Цикл
		СписокТипов.Добавить(ТипЗнч(Элемент.Значение));
	КонецЦикла;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(СписокТипов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокСозданныеДокументыКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗакрытьБезВопроса Тогда
		
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'");
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Закрыть'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		ТекстВопроса = НСтр("ru = 'Работа с созданными документами не была завершена. Закрыть форму?'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗакрытии", ЭтотОбъект), ТекстВопроса, Кнопки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если СобытияОбновления.НайтиПоЗначению(ИмяСобытия) <> Неопределено Тогда
		
		Элементы.СписокСозданныеДокументы.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокСозданныеДокументы

&НаКлиенте
Процедура СписокСозданныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСозданныеДокументыПриАктивизацииСтроки(Элемент)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СписокСозданныеДокументыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСозданныеДокументыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокСозданныеДокументыПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	ОбщегоНазначенияУТ.ОбработатьМультиязычнуюКолонкуСписка(Строки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокСозданныеДокументы);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокСозданныеДокументы, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокСозданныеДокументы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура НазадЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если СозданныеДокументыУдалены() Тогда
		ЗакрытьБезВопроса = Истина;
		Оповестить("Принять_ФормаСозданныхДокументов",, ЭтаФорма);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	Кнопки = Новый СписокЗначений();
	Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Пометить документы на удаление'"));
	Кнопки.Добавить(КодВозвратаДиалога.Отмена);
	
	ТекстВопроса = НСтр("ru = 'Сформированные документы будут помечены на удаление.'");
	
	ПоказатьВопрос(Новый ОписаниеОповещения("НазадЗавершение", ЭтотОбъект), ТекстВопроса, Кнопки);
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	ВопросНепроведенныеДокументы();
КонецПроцедуры

&НаКлиенте
Процедура Провести(Команда)
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СписокСозданныеДокументы, Заголовок);
КонецПроцедуры

&НаКлиенте
Процедура ОтменаПроведения(Команда)
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.СписокСозданныеДокументы, Заголовок);
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ЗагрузитьСписок(Отказ)
	
	СозданныеДокументыВБезопасномХранилище = Параметры.СозданныеДокументы = Неопределено;
	
	Если СозданныеДокументыВБезопасномХранилище Тогда
		СозданныеДокументы = ПрочитатьДанныеИзБезопасногоХранилища(Параметры.КлючДанных);
	Иначе
		СозданныеДокументы = Новый Массив;
		Для каждого ЭлементСД Из Параметры.СозданныеДокументы Цикл
			СозданныеДокументы.Добавить(ЭлементСД.Документ);
		КонецЦикла;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СозданныеДокументы) Тогда
		ВызватьИсключение НСтр("ru='Произошла исключительная ситуация при создании документов.'");
		Отказ = Истина;
	ИначеЕсли СозданныеДокументыВБезопасномХранилище Тогда
		УдалитьДанныеИзБезопасногоХранилища();
	КонецЕсли;
	
	СписокДокументов.ЗагрузитьЗначения(СозданныеДокументы);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокСозданныеДокументы,
		"Ссылка",
		СозданныеДокументы,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокПрограммно()
	
	КоличествоДокументов = СписокДокументов.Количество();
	
	СклонениеСоздано = НСтр("ru = 'Создан, Создано, Создано'");
	Создано = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДокументов, СклонениеСоздано);
	Создано = СтрЗаменить(Создано, КоличествоДокументов + " ", "");
	
	СклонениеДокументов = НСтр("ru = 'документ, документа, документов'");
	Документов = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДокументов, СклонениеДокументов);
	
	Заголовок = Создано + " " + Документов;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПараметры()
	
	Для каждого Колонка Из Элементы.СписокСозданныеДокументы.ПодчиненныеЭлементы Цикл
		Если Колонка <> Элементы.ГруппаОперацияТип Тогда
			Колонка.Видимость = Параметры.ВидимыеКолонки.Найти(Колонка.Имя) <> Неопределено;
		КонецЕсли;
	КонецЦикла;
	СобытияОбновления.ЗагрузитьЗначения(Параметры.СобытияОбновления);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗакрытии(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.ОК Тогда
		ВопросНепроведенныеДокументы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросНепроведенныеДокументы()
	Если ЕстьНепроведенныеДокументы() Тогда
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да);
		Кнопки.Добавить(КодВозвратаДиалога.Нет);
		
		ТекстВопроса = НСтр("ru='Некоторые документы не были проведены. Вы уверены, что хотите оставить документы непроведенными?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗакрытииНепроведенныеДокументы", ЭтотОбъект), ТекстВопроса, Кнопки);
	Иначе
		ЗакрытьБезВопроса = Истина;
		Оповестить("Принять_ФормаСозданныхДокументов",, ЭтаФорма);
		Если ЭтаФорма.Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗакрытииНепроведенныеДокументы(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		ЗакрытьБезВопроса = Истина;
		Оповестить("Принять_ФормаСозданныхДокументов",, ЭтаФорма);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЕстьНепроведенныеДокументы()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	РеестрДокументов.Ссылка
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	НЕ РеестрДокументов.Проведен
	|	И РеестрДокументов.Ссылка В (&СписокДокументов)
	|");
	
	Запрос.УстановитьПараметр("СписокДокументов", СписокДокументов);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Функция СозданныеДокументыУдалены()

	СписокОшибок = ОбщегоНазначенияУТ.УстановитьПометкуУдаленияДокументов(СписокДокументов.ВыгрузитьЗначения());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК Поле1
		|ИЗ
		|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
		|ГДЕ
		|	РеестрДокументов.Ссылка В(&Ссылка)
		|		И НЕ РеестрДокументов.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Ссылка", СписокДокументов.ВыгрузитьЗначения());
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Истина;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СписокОшибок);
		Элементы.СписокСозданныеДокументы.Обновить();
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокСозданныеДокументы.Дата", "Дата");
	
КонецПроцедуры

#Область ОбеспечениеБезопасностиДанных

&НаСервереБезКонтекста
Функция ПрочитатьДанныеИзБезопасногоХранилища(КлючДанных)
	
	Владелец = Пользователи.АвторизованныйПользователь();
	УстановитьПривилегированныйРежим(Истина);
	ЗащищенныеДанные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, КлючДанных);
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ЗащищенныеДанные
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьДанныеИзБезопасногоХранилища()
	Владелец = Пользователи.АвторизованныйПользователь();
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Владелец, "ЖурналДокументовПереработкиСозданныеДокументы");
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

#КонецОбласти

#КонецОбласти