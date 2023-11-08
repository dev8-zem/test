
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Номенклатура",		Номенклатура);
	Параметры.Свойство("ДокументПередачи",	ДокументПродажиПередачи);
	
	Параметры.Отбор.Свойство("ТипНомераГТД", ТипНомераГТД);
	
	ОтборВключен = ЗначениеЗаполнено(ДокументПродажиПередачи);
	ИспользоватьУчетПрослеживаемыхИмпортныхТоваров = УчетПрослеживаемыхТоваровЛокализация.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров(
														Дата(1, 1, 1));
	
	УстановитьОтборыПоПараметрам();
	
	Элементы.ОтборВключен.Видимость						= ОтборВключен;
	Элементы.ГруппаДокументПродажиПередачи.Видимость	= ОтборВключен;
	
	Элементы.ТипНомераГТД.Видимость			= Не ЗначениеЗаполнено(ТипНомераГТД)
												И ИспользоватьУчетПрослеживаемыхИмпортныхТоваров;
	Элементы.СписокКомплектующие.Видимость	= ИспользоватьУчетПрослеживаемыхИмпортныхТоваров;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастроитьСписокКомплектующие();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборВключенПриИзменении(Элемент)
	
	УстановитьОтборПоДокументуПродажиПередачи();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипНомераГТДПриИзменении(Элемент)
	
	УстановитьОтборПоТипуНомераГТД(Список, ТипНомераГТД);
	НастроитьСписокКомплектующие();
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"СтранаПроисхождения",
		СтранаПроисхождения,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(СтранаПроисхождения));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Если ОтборВключен Тогда
		ОтборВключен = Ложь;
		
		УстановитьОтборПоДокументуПродажиПередачи();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	НастроитьСписокКомплектующие();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборыПоПараметрам()
	
	СтранаПроисхожденияНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "СтранаПроисхождения");
	
	Если Параметры.Отбор.Свойство("СтранаПроисхождения", СтранаПроисхождения) Тогда
		Если Не ЗначениеЗаполнено(СтранаПроисхождения) Тогда
			Параметры.Отбор.Удалить("СтранаПроисхождения");
			
			СтранаПроисхождения = СтранаПроисхожденияНоменклатуры;
		КонецЕсли;
		
		УстановитьОтборПоСтранеПроисхожденияСервер();
		
	ИначеЕсли ЗначениеЗаполнено(СтранаПроисхожденияНоменклатуры) Тогда
		СтранаПроисхождения = СтранаПроисхожденияНоменклатуры;
		
		УстановитьОтборПоСтранеПроисхожденияСервер();
	КонецЕсли;
	
	Если ОтборВключен Тогда
		УстановитьОтборПоДокументуПродажиПередачи();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипНомераГТД) Тогда
		УстановитьОтборПоТипуНомераГТД(Список, ТипНомераГТД);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСтранеПроисхожденияСервер()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"СтранаПроисхождения",
		СтранаПроисхождения,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(СтранаПроисхождения));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоДокументуПродажиПередачи()
	
	Если ОтборВключен Тогда
		
		ТекстыЗапроса			= Новый Массив;
		ТекстыВложенногоЗапроса	= Новый Массив;
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ВидыЗапасов.НомерГТД КАК Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.ВидыЗапасов КАК ВидыЗапасов
		|ГДЕ
		|	ВидыЗапасов.Ссылка = &ДокументПродажиПередачи
		|	И ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура = &Номенклатура
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВидыЗапасов.НомерГТД КАК Ссылка
		|ИЗ
		|	Документ.ОтчетОРозничныхПродажах.ВидыЗапасов КАК ВидыЗапасов
		|ГДЕ
		|	ВидыЗапасов.Ссылка = &ДокументПродажиПередачи
		|	И ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура = &Номенклатура
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВидыЗапасов.НомерГТД КАК Ссылка
		|ИЗ
		|	Документ.ПередачаТоваровМеждуОрганизациями.ВидыЗапасов КАК ВидыЗапасов
		|ГДЕ
		|	ВидыЗапасов.Ссылка = &ДокументПродажиПередачи
		|	И ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура = &Номенклатура";
		
		ТекстыВложенногоЗапроса.Добавить(ТекстЗапроса);
		
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВложенныйЗапрос.Ссылка КАК Ссылка
		|ИЗ
		|	&ТекстВложенногоЗапроса КАК ВложенныйЗапрос";
		
		ТекстЗапроса =СтрЗаменить(ТекстЗапроса,
									"&ТекстВложенногоЗапроса",
									"(" + СтрСоединить(ТекстыВложенногоЗапроса, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении()) + ")");
		
		ТекстыЗапроса.Добавить(ТекстЗапроса);
		
		Запрос = Новый Запрос;
		Запрос.Текст = СтрСоединить(ТекстыЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
		
		Запрос.УстановитьПараметр("Номенклатура",				Номенклатура);
		Запрос.УстановитьПараметр("ДокументПродажиПередачи",	ДокументПродажиПередачи);
		
		РезультатЗапроса	= Запрос.Выполнить();
		ВыборкаНомеровГТД	= РезультатЗапроса.Выбрать();
		СписокНомеровГТД	= Новый СписокЗначений;
		
		Пока ВыборкаНомеровГТД.Следующий() Цикл
			СписокНомеровГТД.Добавить(ВыборкаНомеровГТД.Ссылка);
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																				"Ссылка",
																				СписокНомеровГТД,
																				ВидСравненияКомпоновкиДанных.ВСписке,
																				,
																				Истина);
		
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", , , , Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоТипуНомераГТД(Список, ТипНомераГТД)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ТипНомераГТД",
		ТипНомераГТД,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ТипНомераГТД));
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСписокКомплектующие()
	
	Если Не ИспользоватьУчетПрослеживаемыхИмпортныхТоваров Тогда
		Элементы.СписокКомплектующие.Видимость = Ложь;
	Иначе
		ТекущиеДанные			= Элементы.Список.ТекущиеДанные;
		НомерГТДОтбора			= ?(ТекущиеДанные = Неопределено,
									ПредопределенноеЗначение("Справочник.НомераГТД.ПустаяСсылка"),
									ТекущиеДанные.Ссылка);
		КоличествоКомплектующих = ?(ТекущиеДанные = Неопределено, 0, ТекущиеДанные.КоличествоКомплектующих);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Комплектующие,
			"Ссылка",
			НомерГТДОтбора,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			КоличествоКомплектующих > 0);
		
		Элементы.СписокКомплектующие.Заголовок = ЗаголовокСпискаКомплектующие(КоличествоКомплектующих);
		Элементы.СписокКомплектующие.Видимость = КоличествоКомплектующих > 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокСпискаКомплектующие(КоличествоКомплектующих)
	
	ЗаголовокСписка = НСтр("ru = 'Комплектующие'");
	
	Если КоличествоКомплектующих > 0 Тогда
		ЗаголовокСписка = НСтр("ru = 'В состав комплекта входит %1 РНПТ'");
		ЗаголовокСписка = СтрШаблон(ЗаголовокСписка, КоличествоКомплектующих);
	КонецЕсли;
	
	Возврат ЗаголовокСписка;
	
КонецФункции

#КонецОбласти
