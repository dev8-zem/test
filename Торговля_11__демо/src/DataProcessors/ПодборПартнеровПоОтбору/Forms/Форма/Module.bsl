#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.УникальныйИдентификатор = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Предусмотрено открытие обработки только из форм объектов.'");
	КонецЕсли;
	
	ОбработатьПереданныеПараметры(Параметры);
	
	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	                       ЭтотОбъект, "ПодобранныеПартнеры", НСтр("ru = 'Подобранные контрагенты'"), ИспользоватьПартнеровКакКонтрагентов);
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	                       ЭтотОбъект, "ПартнерыПартнеры", НСтр("ru = 'Контрагент'"), ИспользоватьПартнеровКакКонтрагентов);
	
	ИнициализироватьКомпоновщикСервер(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ЗавершениеРаботы И НЕ ВыполняетсяЗакрытие И Не ПеренестиВДокумент И Партнеры.Количество() > 0 Тогда
		
		Если ИспользоватьПартнеровКакКонтрагентов Тогда
			ТекстВопроса = НСтр("ru = 'Подобранные контрагенты не перенесены в документ. Перенести?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Подобранные партнеры не перенесены в документ. Перенести?'");
		КонецЕсли;
		
		Отказ = Истина;
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
			ТекстВопроса, 
			РежимДиалогаВопрос.ДаНетОтмена);
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		ПеренестиВДокумент = Истина;
		АдресПартнеровВХранилище = ПоместитьВоВременноеХранилищеНаСервере();
		Закрыть(АдресПартнеровВХранилище);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиВДокумент = Истина;
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилищеНаСервере();
	Закрыть(АдресТоваровВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуПартнеров(Команда)
	
	ТекстВопроса = НСтр("ru = 'При перезаполнении все введенные вручную данные будут потеряны, продолжить?'");
	
	Если Партнеры.Количество() > 0 Тогда
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ЗаполнитьТаблицуПартнеровЗавершение", ЭтотОбъект),
			ТекстВопроса, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
	Иначе
		ЗаполнитьТаблицуПартнеровНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуПартнеровЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьТаблицуПартнеровНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыПартнеры

&НаКлиенте
Процедура ПартнерыПриИзменении(Элемент)
	
	КоличествоПодобранныхПартнеров = Партнеры.Количество();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщикСервер(НастройкаКомпоновки)
	
	СхемаКомпоновки = Обработки.ПодборПартнеровПоОтбору.ПолучитьМакет("ОтборПартнеров");
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки,УникальныйИдентификатор);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	
	Если НастройкаКомпоновки = Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаКомпоновки);
		КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПартнеровНаСервере(ПроверятьЗаполнение = Истина)
	
	Запрос = Новый Запрос;
	
	СхемаОтбора = Обработки.ПодборПартнеровПоОтбору.ПолучитьМакет("ОтборПартнеров");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	КомпоновщикНастроекРасчета = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекРасчета.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаОтбора));
	КомпоновщикНастроекРасчета.ЗагрузитьНастройки(КомпоновщикНастроек.Настройки);
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроекРасчета);
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаОтбора, КомпоновщикНастроекРасчета.ПолучитьНастройки(),,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	// Инициализация процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	Партнеры.Очистить();
	ТаблицаПартнеров = РеквизитФормыВЗначение("Партнеры");
	
	// Получение результата
	ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений =
		Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений.УстановитьОбъект(ТаблицаПартнеров);
	ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений.Вывести(ПроцессорКомпоновкиДанных);
	
	Если ПредназначенаДляЭлектронныхПисем Тогда
		ТаблицаПартнеров.ЗаполнитьЗначения(ВидКонтактнойИнформацииПартнераДляПисем, "ВидКИДляПисем");
	КонецЕсли;
	
	Если ПредназначенаДляSMS Тогда
		ТаблицаПартнеров.ЗаполнитьЗначения(ВидКонтактнойИнформацииПартнераДляSMS, "ВидКИТелефон");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ТаблицаПартнеров, "Партнеры");
	
	КоличествоПодобранныхПартнеров = Партнеры.Количество();
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Партнеры.Выгрузить(), ИдентификаторВызывающейФормы);
	
КонецФункции

&НаСервере
Процедура ОбработатьПереданныеПараметры(Параметры)

	ИдентификаторВызывающейФормы = Параметры.УникальныйИдентификатор;
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	Иначе
		ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
		                          ЭтотОбъект, "", НСтр("ru = 'Подбор контрагентов по отбору'"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.ЗаголовокКнопкиПеренести) Тогда
		Команды.ПеренестиВДокумент.Заголовок = Параметры.ЗаголовокКнопкиПеренести;
		Команды.ПеренестиВДокумент.Подсказка = Параметры.ЗаголовокКнопкиПеренести;
	КонецЕсли;
	
	ПредназначенаДляSMS                     = Параметры.ПредназначенаДляSMS;
	ПредназначенаДляЭлектронныхПисем        = Параметры.ПредназначенаДляЭлектронныхПисем;
	ВидКонтактнойИнформацииПартнераДляSMS   = Параметры.ВидКонтактнойИнформацииПартнераДляSMS;
	ВидКонтактнойИнформацииПартнераДляПисем = Параметры.ВидКонтактнойИнформацииПартнераДляПисем;
	
	ЗаполнитьСпискиВыбораКИ();
	
	УправлениеВидимостью();

КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()
	
	Элементы.ПартнерыВидКИДляПисем.Видимость = ПредназначенаДляЭлектронныхПисем;
	Элементы.ПартнерыВидКИТелефон.Видимость  = ПредназначенаДляSMS;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораКИ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.Ссылка,
	|	ВидыКонтактнойИнформации.Наименование,
	|	ВидыКонтактнойИнформации.Тип КАК Тип
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.Родитель = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.СправочникПартнеры)
	|	И (ВидыКонтактнойИнформации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	|			ИЛИ ВидыКонтактнойИнформации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))
	|ИТОГИ ПО
	|	Тип";
	
	ВыборкаТип = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаТип.Следующий() Цикл
			
			Если ВыборкаТип.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
					Список = Элементы.ПартнерыВидКИДляПисем.СписокВыбора;
				Иначе
					Список = Элементы.ПартнерыВидКИТелефон.СписокВыбора;
			КонецЕсли;
			
			ВыборкаДетали = ВыборкаТип.Выбрать();
			
			Пока ВыборкаДетали.Следующий() Цикл
				
				Список.Добавить(ВыборкаДетали.Ссылка, ВыборкаДетали.Наименование);
				
			КонецЦикла;
			
		КонецЦикла;

КонецПроцедуры

#КонецОбласти


#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
