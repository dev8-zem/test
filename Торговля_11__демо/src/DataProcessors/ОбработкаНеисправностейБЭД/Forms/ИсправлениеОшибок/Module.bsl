
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("ПараметрыПредставленияДанных") И Параметры.Свойство("Данные") Тогда
		Если Параметры.ПараметрыПредставленияДанных.ОбработчикПолученияПредставлений <> Неопределено Тогда
			ПредставленияДанных = ОбработкаНеисправностейБЭД.ПредставлениеДанныхВСписке(
				Параметры.ПараметрыПредставленияДанных.ОбработчикПолученияПредставлений, Параметры.Данные);
			Элементы.ТаблицаДанныхСсылка.Видимость = Ложь;
			Элементы.ТаблицаДанныхПредставлениеДанных.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("Данные") Тогда
		Для каждого ЭлементМассива Из Параметры.Данные Цикл
			НоваяСтрока = ТаблицаДанных.Добавить();
			НоваяСтрока.Ссылка = ЭлементМассива;
			Если ПредставленияДанных <> Неопределено И ПредставленияДанных[ЭлементМассива] <> Неопределено Тогда
				НоваяСтрока.Ссылка = ПредставленияДанных[ЭлементМассива].Ссылка;
				НоваяСтрока.ПредставлениеДанных = ПредставленияДанных[ЭлементМассива].Представление;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыИсправленияОшибок = Неопределено;
	Если Параметры.Свойство("ПараметрыИсправленияОшибок", ПараметрыИсправленияОшибок) Тогда
		Если ПараметрыИсправленияОшибок.СкрытьКнопкуПросмотреть Тогда
			Элементы.ТаблицаДанныхПросмотреть.Видимость = Ложь;
		КонецЕсли;
		Заголовок = Параметры.ПараметрыИсправленияОшибок.Заголовок;
		ДополнительныеПараметрыОбработчиков.Добавить(ПараметрыИсправленияОшибок.ДополнительныеПараметрыОбработчиков);
		Элементы.ТаблицаДокументовЗаглушка.Видимость = Ложь;
		ЕстьПодсказки = Ложь;
		Если ПараметрыИсправленияОшибок.ОбработчикСобытияВыбор <> Неопределено Тогда
			ОбработчикСобытияВыбор = ПараметрыИсправленияОшибок.ОбработчикСобытияВыбор.Обработчик;
		КонецЕсли;
		Если ПараметрыИсправленияОшибок.Команды.Количество() = 1 Тогда
			Команда = ПараметрыИсправленияОшибок.Команды[0];
			Элементы.ГруппаИсправить.Видимость = Ложь;
			ДобавитьКнопку(Команда, Истина);
			Если ЗначениеЗаполнено(Команда.Подсказка) Тогда
				ЕстьПодсказки = Истина;
			КонецЕсли;
			СтрокаТЗ = ОписанияКоманд.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЗ, Команда);
		Иначе 
			Для каждого Команда Из ПараметрыИсправленияОшибок.Команды Цикл
				ДобавитьКнопку(Команда);
				Если ЗначениеЗаполнено(Команда.Подсказка) Тогда
					ЕстьПодсказки = Истина;
				КонецЕсли;
				СтрокаТЗ = ОписанияКоманд.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТЗ, Команда);
			КонецЦикла;
		КонецЕсли;
		Элементы.ТаблицаДанныхПомощь.Видимость = ЕстьПодсказки;
		Если Не ПараметрыИсправленияОшибок.МножественныйВыбор Тогда
			Элементы.ТаблицаДанныхФлаг.Видимость = Ложь;
			Элементы.ГруппаВыбрать.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Заголовок) Тогда
		Заголовок = НСтр("ru = 'Обработка данных'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ОбработкаНеисправностейБЭДКлиент.ИмяСобытияИсправлениеВидаОшибки()
		И ТипЗнч(Параметр) = Тип("Массив") Тогда
		Для каждого ЭлементМассива Из Параметр Цикл
			СтрокиТаблицы = ТаблицаДанных.НайтиСтроки(Новый Структура("Ссылка", ЭлементМассива));
			Для каждого СтрокаТаблицы Из СтрокиТаблицы Цикл
				СтрокаТаблицы.Обработано = Истина;
			КонецЦикла;
		КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДанных

&НаКлиенте
Процедура ТаблицаДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ИмяКомандыОбработчикСобытияВыбор) Тогда
		ВыполнитьКоманду(Команды[ИмяКомандыОбработчикСобытияВыбор]);
	Иначе
		ОткрытьЭлементДанных();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	Для каждого СтрокаТЗ Из ТаблицаДанных Цикл
		
		Если Не СтрокаТЗ.Обработано Тогда
			СтрокаТЗ.Флаг = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для каждого СтрокаТЗ Из ТаблицаДанных Цикл
		
		Если Не СтрокаТЗ.Обработано Тогда
			СтрокаТЗ.Флаг = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Помощь(Команда)
	
	ТекстовыеСтроки = Новый Массив;
	Для каждого СтрокаТЗ Из ОписанияКоманд Цикл
		Текст = СтрШаблон(НСтр("ru = '<span style=""font: ЖирныйШрифтБЭД"">%1</span> - %2'"),
			СтрокаТЗ.Заголовок, СтрокаТЗ.Подсказка);
		ТекстовыеСтроки.Добавить(Текст);
	КонецЦикла;
	ФорматированнаяСтрока = СтроковыеФункцииКлиент.ФорматированнаяСтрока(СтрСоединить(ТекстовыеСтроки, Символы.ПС));
	ПоказатьПредупреждение(, ФорматированнаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Просмотреть(Команда)
	
	ОткрытьЭлементДанных();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление() 
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаДанных.Обработано");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДанныхФлаг");
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаДанных.Обработано");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДанныхПредставлениеДанных");
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДанныхСсылка");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКнопку(ОписаниеКоманды, ДобавлятьВКоманднуюПанель = Ложь) 
	
	Если ДобавлятьВКоманднуюПанель Тогда
		Родитель = Элементы.ТаблицаДанныхКоманднаяПанель;
	Иначе
		Родитель = Элементы.ГруппаИсправить;
	КонецЕсли;
	ИмяКоманды = СтрЗаменить(ОписаниеКоманды.Обработчик, ".", "_");
	Команда = Команды.Добавить(ИмяКоманды);
	Команда.Заголовок = ОписаниеКоманды.Заголовок;
	Команда.Действие = "Подключаемый_ОбработчикКоманды";
	Если ДобавлятьВКоманднуюПанель Тогда
		Кнопка = Элементы.Вставить(ИмяКоманды, Тип("КнопкаФормы"), Родитель, Элементы.ГруппаВыбрать);
	Иначе 
		Кнопка = Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Родитель);
	КонецЕсли;
	Кнопка.ИмяКоманды = Команда.Имя;
	Если ДобавлятьВКоманднуюПанель Тогда
		Кнопка.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	Если ОписаниеКоманды.Обработчик = ОбработчикСобытияВыбор Тогда
		ИмяКомандыОбработчикСобытияВыбор = Команда.Имя;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикКоманды(Команда) 
	
	ВыполнитьКоманду(Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭлементДанных() 
	
	Если Элементы.ТаблицаДанных.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, Элементы.ТаблицаДанных.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКоманду(Команда)
	
	Если Элементы.ТаблицаДанныхФлаг.Видимость Тогда
		ОтмеченныеСтроки = ТаблицаДанных.НайтиСтроки(Новый Структура("Флаг", Истина));
		Если ОтмеченныеСтроки.Количество() = 0 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Для выполнения действия необходимо отметить нужные строки'"));
			Возврат; 
		КонецЕсли;
		ОбрабатываемыеДанные = Новый Массив;
		Для каждого ОтмеченнаяСтрока Из ОтмеченныеСтроки Цикл
			Если Не ОтмеченнаяСтрока.Обработано Тогда
				ОбрабатываемыеДанные.Добавить(ОтмеченнаяСтрока.Ссылка);
			КонецЕсли;
		КонецЦикла;
		Если ОбрабатываемыеДанные.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
	Иначе
		ТекущиеДанные = Элементы.ТаблицаДанных.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ОбрабатываемыеДанные = ТекущиеДанные.Ссылка;
		Если ТекущиеДанные.Обработано Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Обработчик = СтрЗаменить(Команда.Имя, "_", ".");
	ОбработкаНеисправностейБЭДКлиент.ВыполнитьОбработчикИсправленияОшибки(Обработчик,
		ОбрабатываемыеДанные, ДополнительныеПараметрыОбработчиков[0].Значение);
	
КонецПроцедуры

#КонецОбласти