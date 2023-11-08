#Область СлужебныйПрограммныйИнтерфейс

#Область СерииНоменклатуры

// Формирует структуру, массив которых в дальнейшем будет передан в процедуру генерации серий.
//
// Параметры:
//  * ДанныеДляГенерацииСерии - Структура - Описание:
//  ** Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура, для которой будет генерироваться серия.
//  ** Серия        - ОпределяемыйТип.СерияНоменклатуры - В данное значение будет записана сгенерированная серия.
//  ** ЕстьОшибка   - Булево - Будет установлено в Истина, если по каким то причинам серия сгенерирована не будет.
//  ** ТекстОшибки  - Строка - причина, по которой серия не генерировалась.
//  ** МРЦ          - Число - только для табачной продукции, максимальная розничная цена.
//  * ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции, для которой получается структура данных
Процедура ПолучитьДанныеДляГенерацииСерии(ДанныеДляГенерацииСерии, ВидМаркируемойПродукции) Экспорт
	
	//++ НЕ ГОСИС
	ДанныеДляГенерацииСерии = ИнтеграцияИСМПУТКлиентСервер.СтруктураДанныхДляГенерацииСерии(ВидМаркируемойПродукции);
	//-- НЕ ГОСИС
	
	Возврат;

КонецПроцедуры

#КонецОбласти

#Область ОткрытиеФормыПроверкиИПодбора

// Заполняет специфичные параметры открытия форм проверки и подбора маркируемой продукции в зависимости от точки вызова
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из которой происходит открытие формы проверки и подбора
//  Параметры - (См. ПроверкаИПодборПродукцииИСМПКлиент.ПараметрыОткрытияФормыПроверкиИПодбора)
//
Процедура ПриУстановкеПараметровОткрытияФормыПроверкиИПодбора(Форма, Параметры) Экспорт

	//++ НЕ ГОСИС
	Если ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "РеализацияТоваровУслуг")
	 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "КорректировкаРеализации")
	 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ВозвратТоваровПоставщику")
	 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ВозвратТоваровОтКлиента")
	 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ПриобретениеТоваровУслуг")
	Тогда

		Параметры.ИмяРеквизитаДокументОснование = "";

	ИначеЕсли ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ПрочееОприходованиеТоваров")

	Тогда

		Параметры.ИмяРеквизитаДокументОснование = "";
		Параметры.ИмяРеквизитаКонтрагент = "";
	
	ИначеЕсли ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "РасходныйОрдерНаТовары")
	 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ОтборРазмещениеТоваров") Тогда
	 
		Параметры.ИмяРеквизитаДокументОснование = "";
		Параметры.ИмяРеквизитаОрганизация = "";
		Параметры.ИмяРеквизитаКонтрагент = "";
	 
	ИначеЕсли ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ПриходныйОрдерНаТовары") Тогда
		
		Параметры.ИмяРеквизитаДокументОснование = "Распоряжение";
	 	Параметры.ИмяРеквизитаОрганизация = "";
	 	Параметры.ИмяРеквизитаКонтрагент = "";
	
	ИначеЕсли ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ЧекККМ")
		ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ЧекККМВозврат") Тогда

		Параметры.ИмяРеквизитаДокументОснование = "";
		Параметры.ИмяРеквизитаКонтрагент = "";
		Параметры.ПроверятьМодифицированность   = Ложь;
		
		ПараметрыОповещенияПриЗакрытии = Новый Структура;
		ПараметрыОповещенияПриЗакрытии.Вставить("Форма", Форма);
		ПараметрыОповещенияПриЗакрытии.Вставить("ВидПродукции", Параметры.ВидМаркируемойПродукции);
		
		Параметры.ОписаниеОповещенияПриЗакрытии = Новый ОписаниеОповещения(
			"ПриЗакрытииФормыПроверкиИПодбора",
			ПроверкаИПодборПродукцииИСМПУТКлиент,
			ПараметрыОповещенияПриЗакрытии);
		
		ПараметрыСканирования = ШтрихкодированиеИСКлиент.ПараметрыСканирования(Форма,, Параметры.ВидМаркируемойПродукции);
		ПараметрыСканирования.СоздаватьШтрихкодУпаковки = Ложь;
		
		Параметры.АдресПроверяемыхДанных = ПроверкаИПодборПродукцииИСМПУТВызовСервера.АдресДанныхПроверкиМаркируемойПродукцииЧекККМ(
			ПараметрыСканирования,
			Форма.Объект,
			Форма.УникальныйИдентификатор,
			Параметры.ВидМаркируемойПродукции);

	КонецЕсли;
	
	Если ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ВозвратТоваровОтКлиента")
	 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ПриобретениеТоваровУслуг") Тогда
		
		Параметры.ИмяРеквизитаКонтрагент = "Контрагент";
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"ПараметрыИнтеграцииГосИС") Тогда
		
		НастройкиИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить(Параметры.ВидМаркируемойПродукции);
		Если Не(НастройкиИнтеграции = Неопределено) Тогда
			Параметры.ПроверкаЭлектронногоДокумента = НастройкиИнтеграции.ЕстьЭлектронныйДокумент;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ПрочееОприходованиеТоваров") Тогда
		Параметры.ДоступнаПечатьЭтикеток = Истина;
		Параметры.ДоступноСозданиеНовыхУпаковок = Истина;
	КонецЕсли;
	
	
	//-- НЕ ГОСИС
	Возврат;

КонецПроцедуры

// Выполняет специфичные действия после закрытия форм проверки и подбора маркируемой продукции в зависимости от точки вызова
//
// Параметры:
//  РезультатЗакрытия - Произвольный - результат закрытия формы проверки и подбора
//  ДополнительныеПараметры - Структура с реквизитом Форма (управляемая форма из которой происходил вызов)
//
Процедура ПриЗакрытииФормыПроверкиИПодбора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	//++ НЕ ГОСИС
	ДополнительныеПараметры.Форма.Прочитать();
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Выполняет специфичные действия перед открытием форм проверки и подбора маркируемой продукции в зависимости от точки вызова
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения       - форма из которой происходит открытие формы проверки и подбора
//  ПараметрыОткрытияФормыПроверки - Структура - параметры открытия формы проверки и подбора для формы-источника
//  ПараметрыФормыПроверки         - Структура - подготовленные параметры открытия формы проверки и подбора
//  Отказ                          - Булево    - отказ от открытия формы
//
Процедура ПередОткрытиемФормыПроверкиПодбора(Форма, ПараметрыОткрытияФормыПроверки, ПараметрыФормыПроверки, Отказ) Экспорт
	
	//++ НЕ ГОСИС
	Если ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "РеализацияТоваровУслуг")
	 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "КорректировкаРеализации")
	 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ВозвратТоваровПоставщику")
	 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ВозвратТоваровОтКлиента")
	 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ПриобретениеТоваровУслуг") Тогда
		
		ПараметрыИнтеграцииФормыПроверки = Форма.ПараметрыИнтеграцииГосИС.Получить(ПараметрыОткрытияФормыПроверки.ВидМаркируемойПродукции);
		
		СерииИспользуются = ПараметрыИнтеграцииФормыПроверки.СерииИспользуются;
		
		ПроверкаСклада = Истина;
		Если Форма.Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера")
		 ИЛИ Форма.Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровЧерезКомиссионера") Тогда
			ПроверкаСклада = Ложь;
		КонецЕсли;
		
		Если СерииИспользуются И (НЕ ЗначениеЗаполнено(ПараметрыФормыПроверки.Склад) И ПроверкаСклада
		 ИЛИ ТипЗнч(ПараметрыФормыПроверки.Склад) <> Тип("СправочникСсылка.Склады")) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Для проверки и подбора маркируемой продукции укажите склад'"),,
				ПараметрыОткрытияФормыПроверки.ИмяРеквизитаСклад,
				ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект,
				Отказ);
		КонецЕсли;
	
		Если ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "РеализацияТоваровУслуг")
		 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "КорректировкаРеализации")
		 ИЛИ ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ПриобретениеТоваровУслуг") Тогда
			Если СерииИспользуются И Форма.СкладГруппа Тогда
				ПараметрыФормыПроверки.Склад = ПроверкаИПодборПродукцииИСМПУТВызовСервера.СкладГруппыСОбщейПолитикойУчетаСерий(
					ПараметрыФормыПроверки.Склад,
					ПараметрыОткрытияФормыПроверки.ВидМаркируемойПродукции);
				Объект = Форма[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект];
				Если Объект.Товары.Количество() = 0 И Не ЗначениеЗаполнено(ПараметрыФормыПроверки.Склад) Тогда
					ОбщегоНазначенияКлиент.СообщитьПользователю(
						НСтр("ru = 'Для проверки и подбора маркируемой продукции укажите склад, а не группу'"),,
						ПараметрыОткрытияФормыПроверки.ИмяРеквизитаСклад,
						ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект,
						Отказ);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ПриходныйОрдерНаТовары") Тогда
		
		ПараметрыФормыПроверки.Вставить("Контрагент", Форма.КэшКонтрагентаРаспоряжения);
		ПараметрыФормыПроверки.РежимПодбораСуществующихУпаковок = Истина;
		ПараметрыФормыПроверки.ПриЗавершенииСохранятьРезультатыПроверки = Истина;
		
	КонецЕсли;
	
	Если ПараметрыОткрытияФормыПроверки.ВидМаркируемойПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПустаяСсылка") Тогда
		Отказ = Истина;
		Оповестить("ПроверитьКоличествоВДокументе", , Форма);
	Иначе
		Если НЕ ПустаяСтрока(ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект) Тогда
			 
			Если Форма.ИмяФормы = "Документ.ПриемкаТоваровИСМП.Форма.ФормаДокумента"
				И НЕ ПустаяСтрока(ПараметрыОткрытияФормыПроверки.ИмяРеквизитаДокументОснование) Тогда
				
				ДокументОснование = Форма[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект][ПараметрыОткрытияФормыПроверки.ИмяРеквизитаДокументОснование];
				Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
					ЗначениеСклада = Неопределено;
					ПараметрыФормыПроверки.Вставить(
						"Склад", ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(ДокументОснование, "Склад"));
				КонецЕсли;
			КонецЕсли;
		
		КонецЕсли;
	КонецЕсли;
	
	РазрешитьЗагрузкуПоОрдерам = Ложь;
	Если ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ПриобретениеТоваровУслуг") 
		Или ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ПриемкаТоваровИСМП") Тогда
		РазрешитьЗагрузкуПоОрдерам = ПроверкаИПодборПродукцииИСМПУТВызовСервера.ИспользоватьОрдернуюСхемуПриПоступлении(
			ПараметрыФормыПроверки.Склад, , Истина);
	ИначеЕсли ИнтеграцияИСУТКлиентСервер.ЭтоДокументПоНаименованию(Форма, "РеализацияТоваровУслуг") Тогда
		РазрешитьЗагрузкуПоОрдерам = ПроверкаИПодборПродукцииИСМПУТВызовСервера.ИспользоватьОрдернуюСхемуПриОтгрузке(
			ПараметрыФормыПроверки.Склад, , Истина);
	КонецЕсли;
	ПараметрыФормыПроверки.Вставить("РазрешитьЗагрузкуПоОрдерам", РазрешитьЗагрузкуПоОрдерам); 
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Добавляет возвможные варианты заполнения
// Параметры:
// Форма - ФормаКлиентскогоПриложения:
//	*ПроверкаНеПоДокументу - Булево
//	*РазрешитьЗагрузкуПоОрдерам - Булево
// ВариантыЗаполнения - СписокЗначений из Строка - возвращаемое значение
Процедура ПриОпределенииВариантовЗаполненияКодовМаркировки(Форма, ВариантыЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
		Если НЕ Форма.ПроверкаНеПоДокументу И Форма.РазрешитьЗагрузкуПоОрдерам Тогда
			ВариантыЗаполнения.Добавить("ПоОрдерам", НСтр("ru = 'По ордерам'"));
		КонецЕсли; 
	//-- НЕ ГОСИС

КонецПроцедуры


// Параметры:
// Форма - ФормаКлиентскогоПриложения:
//	*ПроверяемыйДокумент - ДокументСсылка
// ВариантЗаполнения - Строка
// ПараметрыОбработкиТСД - Структура
Процедура ПриОбработкеВариантаЗаполненияКодовМаркировки(Форма, ВариантЗаполнения, ПараметрыОбработкиТСД) Экспорт

	//++ НЕ ГОСИС
	Если ВариантЗаполнения = "ПоОрдерам" Тогда
	
		МаркиПоОрдерам = ПроверкаИПодборПродукцииИСМПУТВызовСервера.КодыМаркировкиПоОрдерам(Форма.ПроверяемыйДокумент);
		Если МаркиПоОрдерам.Успешно Тогда
			Форма.Подключаемый_ПолученыДанныеИзТСД(МаркиПоОрдерам.Штрихкоды, ПараметрыОбработкиТСД);
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(МаркиПоОрдерам.ТекстОшибки);
		КонецЕсли;
	
	КонецЕсли;
	//-- НЕ ГОСИС

КонецПроцедуры

#КонецОбласти

#Область ОткрытиеФормПрикладныхОбъектов

Процедура ОткрытьФормуАктаОРасхождениях(ДокументСсылка, ВладелецФормы) Экспорт
	
	//++ НЕ ГОСИС
	ПроверкаИПодборПродукцииИСМПУТКлиент.ОткрытьФормуАктаОРасхождениях(ДокументСсылка, ВладелецФормы);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти