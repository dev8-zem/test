#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("Организация", Организация);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Если Параметры.Свойство("КонецПериода") Тогда
			ПолучитьПериодичностьВычетовИВосстановленийНДС(Организация, Параметры.КонецПериода);
		Иначе
			ПолучитьПериодичностьВычетовИВосстановленийНДС(Организация, ТекущаяДатаСеанса());
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("НачалоПериода") Тогда
		НачалоПериода = ?(ПериодичностьФормированияВычетовИВосстановленийНДС = Перечисления.Периодичность.Квартал,
									НачалоКвартала(Параметры.НачалоПериода) , НачалоМесяца(Параметры.НачалоПериода));
	Иначе
		НачалоПериода = ?(ПериодичностьФормированияВычетовИВосстановленийНДС = Перечисления.Периодичность.Квартал,
									НачалоКвартала(ТекущаяДатаСеанса()) , НачалоМесяца(ТекущаяДатаСеанса()));
	КонецЕсли;
	
	Если Параметры.Свойство("КонецПериода") Тогда
		КонецПериода = ?(ПериодичностьФормированияВычетовИВосстановленийНДС = Перечисления.Периодичность.Квартал,
									КонецКвартала(Параметры.КонецПериода) , КонецМесяца(Параметры.КонецПериода));
	Иначе
		КонецПериода = ?(ПериодичностьФормированияВычетовИВосстановленийНДС = Перечисления.Периодичность.Квартал,
									КонецКвартала(ТекущаяДатаСеанса()) , КонецМесяца(ТекущаяДатаСеанса()));
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ЗначениеЗаполнено(Организация) Тогда
		УстановитьОтборПоПериоду();
		ЗаполнитьЗаблокированныйНДС();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_БлокировкаВычетаНДС" Тогда
		ЗаполнитьЗаблокированныйНДС();
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ОрганизацияСохраненноеЗначение <> Организация Тогда
		СписокДокументов.Параметры.УстановитьЗначениеПараметра("Организация", Организация);
		ПолучитьПериодичностьВычетовИВосстановленийНДС(Организация, КонецПериода);
		УстановитьПериодПоПериодичностиВычетовИВосстановленийНДС();
		УстановитьОтборПоПериоду();
		ЗаполнитьЗаблокированныйНДС();
		ОтобразитьПоясненияКПериоду();
		ОрганизацияСохраненноеЗначение = Организация;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	Если НачалоПериода <> Дата(1,1,1) Тогда
		УстановитьПериодПоПериодичностиВычетовИВосстановленийНДС();
	КонецЕсли;
	УстановитьОтборПоПериоду();
	ЗаполнитьЗаблокированныйНДС();
	ОтобразитьПоясненияКПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	Если КонецПериода <> Дата(1,1,1) Тогда
		Если ЗначениеЗаполнено(Организация) Тогда
			ПолучитьПериодичностьВычетовИВосстановленийНДС(Организация, КонецПериода);
		КонецЕсли;
		УстановитьПериодПоПериодичностиВычетовИВосстановленийНДС();
	КонецЕсли;
	УстановитьОтборПоПериоду();
	ЗаполнитьЗаблокированныйНДС();
	ОтобразитьПоясненияКПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница.Имя = "СтраницаЗаблокированныйНДС" Тогда
		ЗаполнитьЗаблокированныйНДС();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаблокированныйНДС

&НаКлиенте
Процедура ЗаблокированныйНДСПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокированныйНДСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элемент.ТекущиеДанные.СчетФактура);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.СписокДокументов);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", 
		ПараметрыВыбора, 
		Элементы.ВыбратьПериод, 
		, 
		, 
		, 
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КонецПериода",  КонецПериода);
	ПараметрыФормы.Вставить("Организация",   Организация);
	ПараметрыФормы.Вставить("Добавление",    Истина);
	ПараметрыФормы.Вставить("ПериодичностьФормированияВычетовИВосстановленийНДС", ПериодичностьФормированияВычетовИВосстановленийНДС);
	
	ОткрытьФорму("Документ.БлокировкаВычетаНДС.Форма.ФормаПодбораУстановкаБлокировки", ПараметрыФормы, ЭтаФорма,,,,,);
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КонецПериода", КонецПериода);
	ПараметрыФормы.Вставить("Организация",  Организация);
	ПараметрыФормы.Вставить("Изменение",    Истина);
	
	ВыбранныеСчетаФактуры = Новый СписокЗначений;
	ВыбранныеСтроки = Элементы.ЗаблокированныйНДС.ВыделенныеСтроки;
	Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		ДанныеСтроки = Элементы.ЗаблокированныйНДС.ДанныеСтроки(ВыбраннаяСтрока);
		ВыбранныеСчетаФактуры.Добавить(ДанныеСтроки.СчетФактура);
	КонецЦикла;
	
	ПараметрыФормы.Вставить("ВыбранныеСчетаФактуры", ВыбранныеСчетаФактуры);
	
	ОткрытьФорму("Документ.БлокировкаВычетаНДС.Форма.ФормаПодбораУстановкаБлокировки", ПараметрыФормы, ЭтаФорма,,,, );
	
КонецПроцедуры


&НаКлиенте
Процедура Разблокировать(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КонецПериода", КонецПериода);
	ПараметрыФормы.Вставить("Организация",  Организация);
	ПараметрыФормы.Вставить("ПериодичностьФормированияВычетовИВосстановленийНДС", ПериодичностьФормированияВычетовИВосстановленийНДС);
	
	ВыбранныеСчетаФактуры = Новый СписокЗначений;
	ВыбранныеСтроки = Элементы.ЗаблокированныйНДС.ВыделенныеСтроки;
	Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		ДанныеСтроки = Элементы.ЗаблокированныйНДС.ДанныеСтроки(ВыбраннаяСтрока);
		ВыбранныеСчетаФактуры.Добавить(ДанныеСтроки.СчетФактура);
	КонецЦикла;
	
	ПараметрыФормы.Вставить("ВыбранныеСчетаФактуры", ВыбранныеСчетаФактуры);
	
	ОткрытьФорму("Документ.БлокировкаВычетаНДС.Форма.ФормаПодбораСнятиеБлокировки", ПараметрыФормы, ЭтаФорма,,,, );
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.СписокДокументов);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	Список = ?(Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗаблокированныйНДС,
		Элементы.ЗаблокированныйНДС, Элементы.СписокДокументов);
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьЗаблокированныйНДС()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура КАК СчетФактура,
	|	МАКСИМУМ(БлокировкаВычетаНДССчетаФактуры.Ссылка.Дата) КАК ДатаПоследнегоДокумента
	|ПОМЕСТИТЬ ДатыПоследнихОперацийПоБлокировке
	|ИЗ
	|	Документ.БлокировкаВычетаНДС.СчетаФактуры КАК БлокировкаВычетаНДССчетаФактуры
	|ГДЕ
	|	НЕ БлокировкаВычетаНДССчетаФактуры.Ссылка.ПометкаУдаления
	|	И БлокировкаВычетаНДССчетаФактуры.Ссылка.Дата <= &КонецПериода
	|	И БлокировкаВычетаНДССчетаФактуры.Ссылка.Организация = &Организация
	|СГРУППИРОВАТЬ ПО
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетФактура,
	|	ДатаПоследнегоДокумента
	|;
	|
	|ВЫБРАТЬ
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура КАК СчетФактура,
	|	МАКСИМУМ(БлокировкаВычетаНДССчетаФактуры.Ссылка) КАК Ссылка
	|ПОМЕСТИТЬ ВТ_СрезПоследнихДокументовБлокировки
	|ИЗ
	|	Документ.БлокировкаВычетаНДС.СчетаФактуры КАК БлокировкаВычетаНДССчетаФактуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДатыПоследнихОперацийПоБлокировке
	|		ПО ДатыПоследнихОперацийПоБлокировке.СчетФактура = БлокировкаВычетаНДССчетаФактуры.СчетФактура
	|			И ДатыПоследнихОперацийПоБлокировке.ДатаПоследнегоДокумента = БлокировкаВычетаНДССчетаФактуры.Ссылка.Дата
	|ГДЕ
	|	НЕ БлокировкаВычетаНДССчетаФактуры.Ссылка.ПометкаУдаления
	|СГРУППИРОВАТЬ ПО
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетФактура,
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаблокированныеСФ.Ссылка.Организация КАК Организация,
	|	ЗаблокированныеСФ.СчетФактура КАК СчетФактура,
	|	ЕСТЬNULL(СФПолученный.Ссылка.Дата, СФВыданный.Ссылка.Дата) КАК ДатаПолученияСчетаФактуры,
	|	ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(ДанныеПервичныхДокументов.ДатаРегистратора, КВАРТАЛ), КВАРТАЛ, 11) КАК ПравоНаВычетДо,
	|	ЗаблокированныеСФ.СрокБлокировки КАК СрокБлокировки,
	|	ЗаблокированныеСФ.НДС КАК НДС
	|ИЗ
	|	Документ.БлокировкаВычетаНДС.СчетаФактуры КАК ЗаблокированныеСФ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СрезПоследнихДокументовБлокировки КАК ВТ_СрезПоследнихДокументовБлокировки
	|		ПО ЗаблокированныеСФ.СчетФактура = ВТ_СрезПоследнихДокументовБлокировки.СчетФактура
	|			И ЗаблокированныеСФ.Ссылка = ВТ_СрезПоследнихДокументовБлокировки.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ПО ЗаблокированныеСФ.Ссылка.Организация = ДанныеПервичныхДокументов.Организация
	|			И ЗаблокированныеСФ.СчетФактура = ДанныеПервичныхДокументов.Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученный.ДокументыОснования КАК СФПолученный
	|		ПО ЗаблокированныеСФ.СчетФактура = СФПолученный.ДокументОснование
	|			И (СФПолученный.Ссылка.Проведен)
	|			И (НЕ СФПолученный.Ссылка.Исправление)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.ДокументыОснования КАК СФВыданный
	|		ПО ЗаблокированныеСФ.СчетФактура = СФВыданный.ДокументОснование
	|			И (СФВыданный.Ссылка.Проведен)
	|			И (НЕ СФВыданный.Ссылка.Исправление)
	|ГДЕ
	|	(ЗаблокированныеСФ.СрокБлокировки = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ ЗаблокированныеСФ.СрокБлокировки > &КонецПериода)
	|	И ЗаблокированныеСФ.Ссылка.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБлокировкиВычетаНДС.Установлена)";
	
	
	Запрос.УстановитьПараметр("КонецПериода",  КонецДня(КонецПериода));
	Запрос.УстановитьПараметр("Организация",   Организация);
	
	ЗаблокированныйНДС.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериоду()
	
	ГруппаЭлементовОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		СписокДокументов.Отбор.Элементы,
		Нстр("ru = 'Период'"),
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаЭлементовОтбора,
		"Дата",
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
		НачалоДня(НачалоПериода),
		Нстр("ru = 'Начало периода'"),
		ЗначениеЗаполнено(НачалоПериода));
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаЭлементовОтбора,
		"Дата",
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
		КонецДня(КонецПериода),
		Нстр("ru = 'Конец периода'"),
		ЗначениеЗаполнено(КонецПериода));
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПериодичностьВычетовИВосстановленийНДС(Организация, Период)
	
	ПериодичностьФормированияВычетовИВосстановленийНДС =
		УчетнаяПолитика.ПериодичностьФормированияВычетовИВосстановленийНДС(Организация, НачалоМесяца(Период));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодПоПериодичностиВычетовИВосстановленийНДС()
	
	НачалоПериода = ?(ПериодичностьФормированияВычетовИВосстановленийНДС =
						ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Перечисление.Периодичность.Квартал"),
						НачалоКвартала(НачалоПериода),
						НачалоМесяца(НачалоПериода));
	КонецПериода = ?(ПериодичностьФормированияВычетовИВосстановленийНДС =
						ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Перечисление.Периодичность.Квартал"),
						КонецКвартала(КонецПериода),
						КонецМесяца(КонецПериода));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачалоПериода = РезультатВыбора.НачалоПериода;
	КонецПериода = РезультатВыбора.КонецПериода;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ПолучитьПериодичностьВычетовИВосстановленийНДС(Организация, КонецПериода);
	КонецЕсли;
	УстановитьПериодПоПериодичностиВычетовИВосстановленийНДС();
	УстановитьОтборПоПериоду();
	ЗаполнитьЗаблокированныйНДС();
	ОтобразитьПоясненияКПериоду();
	
КонецПроцедуры

&НаСервере
// Отображает текстовое пояснение по корректности выбора периода.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения.
//
Процедура ОтобразитьПоясненияКПериоду()
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Элементы.ПояснениеПериодРасчета.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ПериодичностьФормированияВычетовИВосстановленийНДС = ОбщегоНазначения.ПредопределенныйЭлемент("Перечисление.Периодичность.Квартал")
		И НачалоПериода < НачалоКвартала(КонецПериода) Тогда
		Элементы.ПояснениеПериодРасчета.Видимость = Истина;
		ШаблонСообщения = НСтр("ru='По учетной политике вычеты рассчитываются ежеквартально. Редактируются блокировки для периода расчета ''%1'''");
		ТекстПояснения = СтрШаблон(
			ШаблонСообщения,
			Формат(КонецПериода, НСтр("ru='ДФ=''к ""квартал"" гггг ""года""'''")));
		Элементы.ПояснениеПериодРасчета.Заголовок = ТекстПояснения;
	ИначеЕсли ПериодичностьФормированияВычетовИВосстановленийНДС = ОбщегоНазначения.ПредопределенныйЭлемент("Перечисление.Периодичность.Месяц")
		И НачалоПериода < НачалоМесяца(КонецПериода) Тогда
		Элементы.ПояснениеПериодРасчета.Видимость = Истина;
		ШаблонСообщения = НСтр("ru='По учетной политике вычеты рассчитываются ежемесячно. Редактируются блокировки для периода расчета ''%1'''");
		ТекстПояснения = СтрШаблон(
			ШаблонСообщения,
			Формат(КонецПериода, НСтр("ru='ДФ=''ММММ гггг ""года""'''")));
		Элементы.ПояснениеПериодРасчета.Заголовок = ТекстПояснения;
	Иначе
		Элементы.ПояснениеПериодРасчета.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти