
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		Партнер = Параметры.ПараметрКоманды;
	ИначеЕсли Параметры.Свойство("Партнер") Тогда
		Партнер = Параметры.Партнер;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Элементы.АктуализироватьРасчеты.Видимость = НЕ ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		Заголовок = НСтр("ru = 'Досье контрагента'");
	Иначе
		Заголовок = НСтр("ru = 'Досье партнера'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер) Тогда 
		
		Если ТипЗнч(Партнер) = Тип("СправочникСсылка.Партнеры") Тогда
			Партнеры.Добавить(Партнер);
		ИначеЕсли ТипЗнч(Партнер) = Тип("Массив") Тогда
			Партнеры.ЗагрузитьЗначения(Партнер);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		Отчет.ВариантКлассификацииЗадолженности = ОбщегоНазначенияУТВызовСервера.ВариантКлассификацииЗадолженностиПоУмолчанию(Истина);
		
		ЗагрузитьНастройки();
		УправлениеВидимостью();
		СформироватьОтчет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройки();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Отчет.ДосьеПартнера.ФормаОтчета.Команда.Сформировать");
	
	ОчиститьСообщения();
	
	СформироватьОтчет();
	
КонецПроцедуры 

&НаКлиенте
Процедура АктуализироватьРасчеты(Команда)
	
	КодОтвета = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("АктуализироватьРасчетыЗавершение", ЭтотОбъект), НСтр("ru = 'Актуализировать расчеты с клиентами?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьРасчетыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    КодОтвета = РезультатВопроса;
    Если КодОтвета = КодВозвратаДиалога.Да Тогда
        
        АктуализироватьРасчетыОбновитьОтчет();
        ПоказатьОповещениеПользователя(
        НСтр("ru = 'Расчеты актуализированы'"),
        , // НавигационнаяСсылка
        НСтр("ru = 'Расчеты с клиентами актуализированы'"));
        
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет()
	
	ТаблицаОтчета.Очистить();
	ОбъектОтчет =  РеквизитФормыВЗначение("Отчет");
	
	Для каждого Партнер Из Партнеры Цикл
		
		ОбъектОтчет.СформироватьОтчет(ТаблицаОтчета,Партнер.Значение)
		
	КонецЦикла;
	
	Отчет.ЕстьНеактуальныеРасчетыСКлиентами 	= ОбъектОтчет.ЕстьНеактуальныеРасчетыСКлиентами;
	Отчет.ЕстьНеактуальныеРасчетыСПоставщиками 	= ОбъектОтчет.ЕстьНеактуальныеРасчетыСПоставщиками;
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()

	Перем Настройки;
	
	Настройки = Новый Структура;
	Настройки.Вставить("Контакты",Отчет.Контакты);
	Настройки.Вставить("ТекущаяАктивность",Отчет.ТекущаяАктивность);
	Настройки.Вставить("ДанныеКлиента",Отчет.ДанныеКлиента);
	Настройки.Вставить("ДанныеПоставщика",Отчет.ДанныеПоставщика);
	Настройки.Вставить("Классификация",Отчет.Классификация);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Отчет.КарточкаПартнера", "ФормаОтчета", Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройки()

	Перем ЗначениеНастроек;
	
	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Отчет.КарточкаПартнера", "ФормаОтчета");
	Если ЗначениеНастроек = Неопределено Тогда
		
		Отчет.Контакты			= Истина;
		Отчет.ДанныеКлиента		= Истина;
		Отчет.ДанныеПоставщика	= Истина;
		Отчет.ТекущаяАктивность	= Истина;
		Отчет.Классификация		= Истина;
		
	ИначеЕсли ТипЗнч(ЗначениеНастроек) = Тип("Структура") Тогда
		
		ЗначениеНастроек.Свойство("Контакты",Отчет.Контакты);
		ЗначениеНастроек.Свойство("ТекущаяАктивность",Отчет.ТекущаяАктивность);
		ЗначениеНастроек.Свойство("ДанныеКлиента",Отчет.ДанныеКлиента);
		ЗначениеНастроек.Свойство("ДанныеПоставщика",Отчет.ДанныеПоставщика);
		ЗначениеНастроек.Свойство("Классификация",Отчет.Классификация);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()
	
	Если Не ПравоДоступа("Чтение",Метаданные.Справочники.КонтактныеЛицаПартнеров)
	     И Не ПравоДоступа("Чтение",Метаданные.Справочники.Контрагенты) Тогда
		
		Отчет.Контакты = Ложь;
		Элементы.Контакты.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение",Метаданные.Справочники.СделкиСКлиентами)
	     И Не ПравоДоступа("Чтение",Метаданные.Документы.ЗаказКлиента)
	     И Не ПравоДоступа("Чтение",Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоДокументам)
	     И Не ПравоДоступа("Чтение",Метаданные.Справочники.СоглашенияСКлиентами) Тогда
		
		Отчет.ДанныеКлиента = Ложь;
		Элементы.ДанныеКлиента.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение",Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПоДокументам)
		И Не ПравоДоступа("Чтение",Метаданные.Справочники.СоглашенияСПоставщиками)
		И Не ПравоДоступа("Чтение",Метаданные.Документы.ЗаказПоставщику) Тогда
		
		Отчет.ДанныеПоставщика = Ложь;
		Элементы.ДанныеПоставщика.Видимость = Ложь;
		
	КонецЕсли;
	
	ТекущаяАктивностьНедоступнаПоФО = Не ПолучитьФункциональнуюОпцию("ИспользоватьПочтовыйКлиент")
	                                 И Не ПолучитьФункциональнуюОпцию("ИспользоватьМаркетинговыеМероприятия")
	                                 И Не ПолучитьФункциональнуюОпцию("ИспользоватьПроекты");
	
	
	Если ТекущаяАктивностьНедоступнаПоФО 
	     Или (Не ПравоДоступа("Чтение",Метаданные.Документы.ЗапланированноеВзаимодействие)
	          И Не ПравоДоступа("Чтение",Метаданные.Документы.Встреча)
	          И Не ПравоДоступа("Чтение",Метаданные.Документы.ТелефонныйЗвонок)
	          И Не ПравоДоступа("Чтение",Метаданные.Документы.ЭлектронноеПисьмоВходящее)
	          И Не ПравоДоступа("Чтение",Метаданные.Документы.ЭлектронноеПисьмоИсходящее)
	          И Не ПравоДоступа("Чтение",Метаданные.Справочники.МаркетинговыеМероприятия)
	          И Не ПравоДоступа("Чтение",Метаданные.Справочники.Проекты)) Тогда
	
		Отчет.ТекущаяАктивность = Ложь;
		Элементы.ТекущаяАктивность.Видимость = Ложь;
	
	КонецЕсли;
	
	КлассификацияНедоступнаПоФО = (Не ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоВаловойПрибыли")
	                             И Не ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоВыручке")
	                             И Не ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоКоличествуПродаж") 
	                             И Не ПолучитьФункциональнуюОпцию("ИспользоватьСегментыПартнеров"));
	
	Если КлассификацияНедоступнаПоФО 
	    Или (Не ПравоДоступа("Чтение",Метаданные.РегистрыСведений.ABCXYZКлассификацияКлиентов) 
		И Не ПравоДоступа("Чтение",Метаданные.РегистрыСведений.ПартнерыСегмента)) Тогда
		
		Отчет.Классификация = Ложь;
		Элементы.Классификация.Видимость = Ложь;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностью()

	Элементы.АктуализироватьРасчеты.Доступность = Отчет.ЕстьНеактуальныеРасчетыСКлиентами ИЛИ Отчет.ЕстьНеактуальныеРасчетыСПоставщиками;

КонецПроцедуры

&НаСервере
Функция АналитикаДляАктуализацииРасчетов()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	АналитикаУчетаПоПартнерам.КлючАналитики
	|ИЗ
	|	РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
	|ГДЕ
	|	АналитикаУчетаПоПартнерам.Партнер В(&МассивПартнеров)";
	
	Запрос.УстановитьПараметр("МассивПартнеров", Партнеры.ВыгрузитьЗначения());
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("КлючАналитики");
	
КонецФункции

&НаСервере
Процедура АктуализироватьРасчетыОбновитьОтчет()
	
	Если Отчет.ЕстьНеактуальныеРасчетыСКлиентами ИЛИ Отчет.ЕстьНеактуальныеРасчетыСПоставщиками Тогда
		МассивАналитикДляАктуализации = АналитикаДляАктуализацииРасчетов();
	КонецЕсли;
	
	Если Отчет.ЕстьНеактуальныеРасчетыСКлиентами И МассивАналитикДляАктуализации.Количество() > 0 Тогда
		ОкончаниеРасчета = КонецМесяца(ТекущаяДатаСеанса()) + 1;
		АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
		АналитикиРасчета.АналитикиУчетаПоПартнерам = МассивАналитикДляАктуализации;
		РаспределениеВзаиморасчетовВызовСервера.РаспределитьВсеРасчетыСКлиентами(ОкончаниеРасчета, АналитикиРасчета);
		Отчет.ЕстьНеактуальныеРасчетыСКлиентами = Ложь;
	КонецЕсли;
	
	Если Отчет.ЕстьНеактуальныеРасчетыСПоставщиками И МассивАналитикДляАктуализации.Количество() > 0 Тогда
		ОкончаниеРасчета = КонецМесяца(ТекущаяДатаСеанса()) + 1;
		АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
		АналитикиРасчета.АналитикиУчетаПоПартнерам = МассивАналитикДляАктуализации;
		РаспределениеВзаиморасчетовВызовСервера.РаспределитьВсеРасчетыСПоставщиками(ОкончаниеРасчета, АналитикиРасчета);
		Отчет.ЕстьНеактуальныеРасчетыСПоставщиками = Ложь;
	КонецЕсли;
	
	СформироватьОтчет();
	
КонецПроцедуры

#КонецОбласти
