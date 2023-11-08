////////////////////////////////////////////////////////////////////////////////////////
// СопоставлениеНоменклатурыКонтрагентовСлужебныйКлиент:
// механизм сопоставления номенклатуры контрагентов с номенклатурой информационной базы.
//
///////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

//++ Локализация

// Обрабатывает результат проверки сопоставления номенклатуры контрагента.
// В случае обнаружения ошибок заполнения в документе сопоставления номенклатуры контрагента:
//  - при наличии колонки с типом НоменклатураКонтрагентов пользователю отображается сообщение с позиционированием на проблемной строке.
//  - при отсутствии колонки с типом НоменклатураКонтрагентов и передаче свойства ОткрыватьФормуДляИзмененияСопоставления = Истина
//    откроется форма для редактирования документов.
//
// Параметры:
//  НаборДокументов                - Массив Из ДокументСсылка - документы, в которых необходимо проверить сопоставление номенклатуры в терминах контрагента.
//  РезультатПроверкиСопоставления - см. СопоставлениеНоменклатурыКонтрагентовСлужебный.ПроверкаСопоставленияНоменклатурыКонтрагентовВДокументах.
//  ОповещениеОЗавершении          - ОписаниеОповещения - описание процедуры, которая будет вызвана после закрытии формы с параметрами;
//   * НаборДокументов         - Массив из ДокументСсылка - результат успешно сопоставленных документов.
//                             - Неопределено             - возвращается в случае отмены редактирования или если нет не одного сопоставленного документа.
//   * ДополнительныеПараметры - Произвольный             - значение, которое было указано при создании объекта ОписаниеОповещения.
//  НастройкиФормы                 - Структура - настройки для формы редактирования сопоставления:
//   * РежимОткрытияОкна - РежимОткрытияОкнаФормы     - режим открытия формы. По умолчанию БлокироватьОкноВладельца.
//   * ВладелецФормы     - ФормаКлиентскогоПриложения - владелец открываемой формы.
//
Процедура ОбработатьРезультатСопоставленияНоменклатурыКонтрагентовВДокументах(Знач НаборДокументов, РезультатПроверкиСопоставления = Неопределено,
	Знач ОповещениеОЗавершении = Неопределено, Знач НастройкиФормы = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	Если РезультатПроверкиСопоставления = Неопределено Тогда
		РезультатПроверкиСопоставления =
			СопоставлениеНоменклатурыКонтрагентовСлужебныйВызовСервера.ПроверкаСопоставленияНоменклатурыКонтрагентовВДокументах(НаборДокументов);
	КонецЕсли;
	
	Если Не РезультатПроверкиСопоставления.ЕстьОшибкиСопоставления Тогда
		Если ОповещениеОЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатПроверкиСопоставления);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	НаборСопоставлений = РезультатПроверкиСопоставления.НаборСопоставлений;
	
	Если ТипЗнч(НаборДокументов) = Тип("Массив") Тогда
		КоличествоПроверяемыхДокументов = НаборДокументов.Количество();
	Иначе
		КоличествоПроверяемыхДокументов = 1;
	КонецЕсли;
	
	ОткрыватьФормуДляИзмененияСопоставления = РезультатПроверкиСопоставления.ОткрыватьФормуДляИзмененияСопоставления;
	
	Если КоличествоПроверяемыхДокументов = 1 И Не ОткрыватьФормуДляИзмененияСопоставления Тогда
		
		ВывестиСообщениеОбОшибкиСПозиционированиемНаСтрокеДокумента(НаборСопоставлений);
		
	Иначе
		
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		ВладелецФормы     = Неопределено;
		Если НастройкиФормы <> Неопределено Тогда
			РежимОткрытияОкна = НастройкиФормы.РежимОткрытияОкна;
			ВладелецФормы     = НастройкиФормы.ВладелецФормы;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НаборСопоставлений", НаборСопоставлений);
		ПараметрыФормы.Вставить("ОткрыватьФормуДляИзмененияСопоставления", ОткрыватьФормуДляИзмененияСопоставления);
		
		ОткрытьФорму("Обработка.СопоставлениеНоменклатурыБЭД.Форма.РедактированиеСопоставленияНоменклатуры", 
			ПараметрыФормы, ВладелецФормы, , , , ОповещениеОЗавершении, РежимОткрытияОкна);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиСообщениеОбОшибкиСПозиционированиемНаСтрокеДокумента(НаборСопоставлений, УникальныйИдентификатор = Неопределено) Экспорт
	
	Для Каждого Сопоставление Из НаборСопоставлений Цикл
		
		Если Сопоставление.Сопоставлено Тогда
			Продолжить;
		ИначеЕсли ЗначениеЗаполнено(Сопоставление.НоменклатураКонтрагента)
			И Сопоставление.КоличествоНоменклатурыКонтрагентов = 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не совпадает сопоставление с данными документа в колонке ""%1"" в строке %2.'"),
				Сопоставление.ПредставлениеНоменклатурыКонтрагента, Сопоставление.НомерСтроки);
		Иначе
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2.'"),
				Сопоставление.ПредставлениеНоменклатурыКонтрагента, Сопоставление.НомерСтроки);
		КонецЕсли;
		
		ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
			Сопоставление.ИмяТабличнойЧасти, Сопоставление.НомерСтроки, Сопоставление.ИмяКолонкиНоменклатурыКонтрагента);
		
		СообщитьПользователюВФорму(ТекстСообщения, УникальныйИдентификатор, Сопоставление.СсылкаНаДокумент, ПутьКТабличнойЧасти, "Объект");

	КонецЦикла;
	
КонецПроцедуры

// Начинает создание номенклатуры информационной базы по данным контрагента.
//
// Параметры:
//  НаборНоменклатурыКонтрагентов - Массив             - номенклатура контрагентов, по которой нужно создать номенклатуру информационной базы.
//                                                       См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураКонтрагента.
//  ОповещениеОЗавершении         - ОписаниеОповещения - оповещение, которое нужно выполнить после создания номенклатуры с результатом,
//                                                       представляющим массив структур со свойствами;
//   * НоменклатураКонтрагента - Структура - элемент из параметра НаборНоменклатурыКонтрагентов, для которого создана номенклатура.
//   * НоменклатураИБ          - Структура - описание созданной номенклатуры.
//                                           См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураИнформационнойБазы.
//  Контекст - см. НовыйКонтекстСозданияНоменклатурыПоДаннымКонтрагента
//
Процедура НачатьСозданиеНоменклатурыПоДаннымКонтрагента(Знач НаборНоменклатурыКонтрагентов, Знач ОповещениеОЗавершении,
	Знач Контекст) Экспорт
	
	СтандартнаяОбработка = Истина;
	
	СопоставлениеНоменклатурыКонтрагентовКлиентПереопределяемый.ПриСозданииНоменклатурыПоДаннымКонтрагента(
		НаборНоменклатурыКонтрагентов, ОповещениеОЗавершении, Контекст, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Новый Массив);
	КонецЕсли;
	
КонецПроцедуры

// Метод-конструктор контекста создания номенклатуры по данным контрагента
// 
// Возвращаемое значение:
//  Структура:
//   * ОграничениеТипаНоменклатуры - Неопределено,ОписаниеТипов
//   * ДополнительныеПараметрыПоиска - Произвольный - контекст, полученный из переопределяемого кода при вызове 
//     см. СопоставлениеНоменклатурыКонтрагентовКлиент.ОткрытьСопоставлениеНоменклатуры
//
Функция НовыйКонтекстСозданияНоменклатурыПоДаннымКонтрагента() Экспорт
	
	Контекст = Новый Структура();
	Контекст.Вставить("ОграничениеТипаНоменклатуры", Неопределено);
	Контекст.Вставить("ДополнительныеПараметрыПоиска", Неопределено);
	
	Возврат Контекст;
	
КонецФункции

Процедура ИзменитьНаФормеДокументаПометкуКомандыУчитыватьНоменклатуруВладельца(ФормаДокумента) Экспорт
	
	СвойстваEDI = ФормаДокумента.СвойстваEDI;
	ПоследняяНастройкаВСервисе             = СвойстваEDI.ДанныеДокумента.ПоследняяНастройкаВариантаУказанияНоменклатуры;
	ПараметрыНоменклатурыКонтрагентаБЭД    = ФормаДокумента.ПараметрыНоменклатурыКонтрагентаБЭД;
	КомандаУчитыватьНоменклатуруВладельца  = ФормаДокумента.Элементы[ПараметрыНоменклатурыКонтрагентаБЭД.ИмяКомандыУчитыватьВладельцаНоменклатуры];
	ПоследняяНастройка                     = ПараметрыНоменклатурыКонтрагентаБЭД.ПоследняяНастройкаВариантаУказанияНоменклатуры;
	ВариантУказанияНоменклатурыВДокументе  = ПараметрыНоменклатурыКонтрагентаБЭД.ВариантУказанияНоменклатурыВДокументе;
	ДокументИспользуетсяВОбменеEDI         = ПараметрыНоменклатурыКонтрагентаБЭД.ДокументИспользуетсяВОбменеEDI;
	ВариантУказанияНоменклатурыВОбменеEDI  = ПараметрыНоменклатурыКонтрагентаБЭД.ВариантУказанияНоменклатурыВОбменеEDI;
	ЗначениеНастройкиКонтрагентаEDI        = ПараметрыНоменклатурыКонтрагентаБЭД.ЗначениеНастройкиКонтрагентаEDI;

	РазрешеноПриниматьВТерминахПоставщика            = Неопределено;
	РазрешеноПриниматьВТерминахПоставщикаИПокупателя = Неопределено;
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.СервисEDI") Тогда
	
		МодульДокументыEDIИнтеграцияКлиент =  ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументыEDIИнтеграцияКлиент");
		
		РазрешеноПриниматьВТерминахПоставщика            = МодульДокументыEDIИнтеграцияКлиент.РежимРаботыСЗаказамиВТерминахПоставщика();
		РазрешеноПриниматьВТерминахПоставщикаИПокупателя = МодульДокументыEDIИнтеграцияКлиент.РежимРаботыСЗаказамиВТерминахПоставщикаИПокупателя();
	
	КонецЕсли;
	
	ВариантУказанияНоменклатураКонтрагента = СопоставлениеНоменклатурыКонтрагентовКлиентСервер.ВариантУказанияНоменклатураКонтрагента();
	ВариантУказанияНоменклатураОрганизации = СопоставлениеНоменклатурыКонтрагентовКлиентСервер.ВариантУказанияНоменклатураОрганизации();
	
	Если ДокументИспользуетсяВОбменеEDI Тогда
		ФормаДокумента.ВариантУказанияНоменклатурыБЭД = ВариантУказанияНоменклатурыВОбменеEDI;
	ИначеЕсли ЗначениеЗаполнено(ВариантУказанияНоменклатурыВДокументе) Тогда
		ФормаДокумента.ВариантУказанияНоменклатурыБЭД = ВариантУказанияНоменклатурыВДокументе;
	Иначе
		Если ЗначениеНастройкиКонтрагентаEDI = РазрешеноПриниматьВТерминахПоставщикаИПокупателя Тогда
			Если ЗначениеЗаполнено(ПоследняяНастройкаВСервисе) Тогда
				ФормаДокумента.ВариантУказанияНоменклатурыБЭД = ПоследняяНастройка;
			Иначе
				ФормаДокумента.ВариантУказанияНоменклатурыБЭД = ВариантУказанияНоменклатураОрганизации;
			КонецЕсли;
		ИначеЕсли ЗначениеНастройкиКонтрагентаEDI = РазрешеноПриниматьВТерминахПоставщика Тогда
			ФормаДокумента.ВариантУказанияНоменклатурыБЭД = ВариантУказанияНоменклатураКонтрагента;
		ИначеЕсли ЗначениеЗаполнено(ПоследняяНастройка) Тогда
			ФормаДокумента.ВариантУказанияНоменклатурыБЭД = ПоследняяНастройка;
		Иначе
			ФормаДокумента.ВариантУказанияНоменклатурыБЭД = 
				ПараметрыНоменклатурыКонтрагентаБЭД.ВариантУказанияНоменклатурыПоУмолчанию;
		КонецЕсли;
	КонецЕсли;
	
	Если ФормаДокумента.ВариантУказанияНоменклатурыБЭД = ВариантУказанияНоменклатураОрганизации Тогда
		КомандаУчитыватьНоменклатуруВладельца.Пометка = Ложь;
	ИначеЕсли ФормаДокумента.ВариантУказанияНоменклатурыБЭД = ВариантУказанияНоменклатураКонтрагента Тогда
		КомандаУчитыватьНоменклатуруВладельца.Пометка = Истина;
	Иначе
		КомандаУчитыватьНоменклатуруВладельца.Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ Локализация

// Формирует и выводит сообщение, которое может быть связано с элементом 
// управления формы.
//
// Параметры:
//  ИдентификаторНазначения    - УникальныйИдентификатор, Неопределено - уникальный идентификатор формы для показа сообщения.
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных                 - ЛюбаяСсылка - объект или ключ записи информационной базы, к которому это сообщение относится.
//  Поле                       - Строка - наименование реквизита формы.
//  ПутьКДанным                - Строка - путь к данным (путь к реквизиту формы).
//  Отказ                      - Булево - выходной параметр, всегда устанавливается в значение Истина.
//
// Примеры : см ОбщегоНазначенияКлиентСервер.СообщитьПользователю.
//
Процедура СообщитьПользователюВФорму(
		Знач ТекстСообщенияПользователю,
		Знач ИдентификаторНазначения,
		Знач КлючДанных,
		Знач Поле = "",
		Знач ПутьКДанным = "",
		Отказ = Ложь)
	
	Сообщение = Новый СообщениеПользователю;
	Если ИдентификаторНазначения <> Неопределено Тогда
		Сообщение.ИдентификаторНазначения = ИдентификаторНазначения;
	КонецЕсли;
	
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	Сообщение.КлючДанных = КлючДанных;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
		
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

