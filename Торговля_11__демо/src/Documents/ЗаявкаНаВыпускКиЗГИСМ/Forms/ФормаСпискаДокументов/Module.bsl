
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПереопределитьТекстЗапросаСпискаРаспоряженийНаОформление();
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СобытияФормГИСМ.ПриСозданииНаСервереФормыСпискаДокументов(ЭтотОбъект);
	
	Элементы.ОрганизацияОтбор.Видимость = ИнтеграцияГИСМ.ИспользоватьНесколькоОрганизаций();
	Элементы.ОрганизацияКОформлениюОтбор.Видимость = ИнтеграцияГИСМ.ИспользоватьНесколькоОрганизаций();
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокКОформлению, "СтатусГИСМКОформлению", СтатусГИСМКОформлению, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокКОформлению, "Организация", Организация, СтруктураБыстрогоОтбора);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "СтатусГИСМ", СтатусГИСМ, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Организация", Организация, СтруктураБыстрогоОтбора);
	
	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПриСозданииНаСервере(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияГИСМ.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.ДальнейшееДействиеГИСМОтбор.СписокВыбора,
		ВсеТребующиеДействия(),
		ВсеТребующиеОжидания());
	
	Если Параметры.ОткрытьРаспоряжения Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗаявкаНаВыпускКиЗГИСМ" Тогда
		Элементы.Список.Обновить();
		Элементы.СписокКОформлению.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "#ГИСМ#ИзменениеСостоянияГИСМ"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.ЗаявкаНаВыпускКиЗГИСМ") Тогда
		
		Элементы.Список.Обновить();
		Элементы.СписокКОформлению.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "#ГИСМ#ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		Элементы.Список.Обновить();
		Элементы.СписокКОформлению.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокКОформлению,
	                                                                     "СтатусГИСМКОформлению",
	                                                                     СтатусГИСМКОформлению,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                     "СтатусГИСМ",
	                                                                     СтатусГИСМ,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПередЗагрузкойИзНастроек(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                     "Ответственный",
	                                                                     Ответственный,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	ЗначОрганизация = Настройки.Получить("Организация"); 
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокКОформлению,
	                                                                     "Организация",
	                                                                     Организация,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	Если ЗначОрганизация <> Неопределено Тогда
		Настройки.Вставить("Организация", ЗначОрганизация);
	КонецЕсли;
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                     "Организация",
	                                                                     Организация,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКОформлению,
	                                                                        "Организация",
	                                                                        Организация,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Организация));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Организация",
	                                                                        Организация,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМКОформлениюОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКОформлению,
	                                                                        "СтатусГИСМКОформлению",
	                                                                        СтатусГИСМКОформлению,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(СтатусГИСМКОформлению));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "СтатусГИСМ",
	                                                                        СтатусГИСМ,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(СтатусГИСМ));
	
КонецПроцедуры

&НаКлиенте
Процедура ДальнейшееДействиеОтборПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ДальнейшееДействиеГИСМ Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
			Элементы.Список,
			Элемент.ДанныеСтроки(ВыбраннаяСтрока).ДальнейшееДействиеГИСМ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ОформитьЗаявкуНаВыпускКиЗ(Команда)
	
	ОчиститьСообщения();
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.СписокКОформлению) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Основание", Элементы.СписокКОформлению.ТекущиеДанные.Ссылка);
	ОткрытьФорму("Документ.ЗаявкаНаВыпускКиЗГИСМ.Форма.ФормаДокумента",ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьЗаявку(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ЗакройтеЗаявку"));
	
КонецПроцедуры

&НаКлиенте
Процедура Аннулировать(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.Аннулируйте"));
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияГИСМКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура Архивировать(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьРаспоряжения(
		ЭтотОбъект,
		Элементы.СписокКОформлению,
		ИнтеграцияГИСМКлиент,
		ПредопределенноеЗначение("Документ.ЗаявкаНаВыпускКиЗГИСМ.ПустаяСсылка"),
		"Документ");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПолучение(Команда)
	
	ИнтеграцияГИСМКлиент.ПодтвердитьПолучениеДляДокументовИзСписка(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СписокСтатусовОтказ = Новый СписокЗначений;
	СписокСтатусовОтказ.Добавить(Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ОтклоненаГИСМ);
	СписокСтатусовОтказ.Добавить(Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ОтклоненаЭмитентом);
	СписокСтатусовОтказ.Добавить(Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ОтклоненаФНС);
	
#Область УсловноеОформлениеСписокЗаявок
	
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеСтатусДальнейшееДействиеГИСМ(
		УсловноеОформление,
		Элементы,
		Элементы.СтатусГИСМ.Имя,
		Элементы.ДальнейшееДействиеГИСМ.Имя,
		"Список.СтатусГИСМ",
		"Список.ДальнейшееДействиеГИСМ");
	
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеНомерГИСМ(
		УсловноеОформление,
		Элементы,
		Элементы.НомерГИСМ.Имя,
		"Список.НомерГИСМ");
		
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусГИСМ.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных("Список.СтатусГИСМ");
	ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение  = СписокСтатусовОтказ;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
	
	// Статус закрыто ГИСМ
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусГИСМ.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных("Список.СтатусГИСМ");
	ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение  = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.Закрыта;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
		
#КонецОбласти

#Область УсловноеОформлениеСписокРаспоряжений
	
	СписокУсловноеОформление = СписокКОформлению.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	// Цвет текста проблема
	Элемент = СписокУсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусГИСМКОформлению.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СтатусГИСМКОформлению");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСтатусовОтказ;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
	
	// Цвет текста проблема
	Элемент = СписокУсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусГИСМКОформлению.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СтатусГИСМКОформлению");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.Отсутствует;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
#КонецОбласти

#Область УсловноеОформлениеКолонкиДата
	
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокКОформлению", "СписокКОформлениюЗаказПоставщикуДата");
	
#КонецОбласти

КонецПроцедуры

&НаКлиенте
Процедура СписокКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокКОформлению.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент.Имя = "СписокКОформлениюТекущаяЗаявкаНаВыпускКиЗ"
		И ЗначениеЗаполнено(ТекущиеДанные.ТекущаяЗаявкаНаВыпускКиЗ)Тогда
		
		ПоказатьЗначение( ,ТекущиеДанные.ТекущаяЗаявкаНаВыпускКиЗ);
		
	Иначе
		
		ПоказатьЗначение( ,ТекущиеДанные.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОтборДальнейшиеДействия


// Возвращает массив дальнейших действий с документом, требующих участия пользователя
// 
// Возвращаемое значение:
// 	Массив дальшейних действий
//
&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	МассивДействий = Новый Массив();
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПолучитеСчетНаОплату);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОплатитеСчет);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПодтвердитеПолучение);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ЗакройтеЗаявку);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.Аннулируйте);
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен);
	КонецЕсли;
	
	Возврат МассивДействий;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	МассивДействий = Новый Массив();
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	КонецЕсли;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеУтверждениеФНС);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеФормированиеСчетаНаОплату);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеУведомлениеОВыпускеКиЗ);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПоступлениеТоваров);
	
	Возврат МассивДействий;
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияГИСМ.УстановитьОтборПоДальнейшемуДействию(Список,
	                                                    ДальнейшееДействиеГИСМ,
	                                                    ВсеТребующиеДействия(),
	                                                    ВсеТребующиеОжидания());
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПереопределитьТекстЗапросаСпискаРаспоряженийНаОформление()
	
	ТекстЗапроса = "";
	ИнтеграцияГИСМПереопределяемый.ТекстЗапросаДинамическогоСпискаРаспоряженийЗаявкаНаВыпускКиЗ(ТекстЗапроса);
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокКОформлению, СвойстваСписка);
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти
