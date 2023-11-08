#Область СлужебныйПрограммныйИнтерфейс  

// Возврращает имя регламентного задания
// 
// Возвращаемое значение:
//    Строка - имя регламентного задания
Функция ИмяРегламентногоЗадания() Экспорт
	
	ИмяРегламентногоЗадания = "";
	
	//++ Локализация
	ИмяРегламентногоЗадания = НСтр("ru = 'ИнтеграцияСЯндексМаркетСервер.ЗагрузитьРекомендованныеЦеныЯндексМаркет'");	
	//-- Локализация
	
	Возврат ИмяРегламентногоЗадания;
	
КонецФункции    

// Возвращает имя формы выбора
// 
// Возвращаемое значение:
//    Строка - имя формы выбора
Функция ИмяФормыВыбора() Экспорт

	ИмяФормыВыбора = "";

	//++ Локализация
	ИмяФормыВыбора = НСтр("ru = 'Справочник.УчетныеЗаписиМаркетплейсов.Форма.ВыборЗагружаемыхВидовЦен'");
	//-- Локализация

	Возврат ИмяФормыВыбора;

КонецФункции

// Возврращает значение функциональной опции ИспользоватьИнтеграциюСЯндексМаркет
// для функционала, который не локализуется
// 
// Возвращаемое значение:
//    Булево - значение функциональной опции ИспользоватьИнтеграциюСЯндексМаркет
Функция ФункциональнаяОпцияИспользоватьИнтеграциюСЯндексМаркет() Экспорт
	
	ИспользоватьИнтеграциюСЯндексМаркет = Ложь;
	
	//++ Локализация
	ИспользоватьИнтеграциюСЯндексМаркет = ПолучитьФункциональнуюОпцию("ИспользоватьИнтеграциюСЯндексМаркет");	
	//-- Локализация
	
	Возврат ИспользоватьИнтеграциюСЯндексМаркет;
	
КонецФункции

// Возврращает значение функциональной опции ИспользоватьИнтеграциюСOzon
// для функционала, который не локализуется
// 
// Возвращаемое значение:
//    Булево - значение функциональной опции ИспользоватьИнтеграциюСOzon
Функция ФункциональнаяОпцияИспользоватьИнтеграциюСOzon() Экспорт
	
	ИспользоватьИнтеграциюСOzon = Ложь;
	
	//++ Локализация
	ИспользоватьИнтеграциюСOzon = ПолучитьФункциональнуюОпцию("ИспользоватьИнтеграциюСOzon");
	//-- Локализация
	
	Возврат ИспользоватьИнтеграциюСOzon;
	
КонецФункции

// Возвращает описание регламентного задания
// 
// Параметры:
//     ИдентификаторЗадания - Строка - Идентификатор задания
//
// Возвращаемое значение:
//         Структура - структура с параметрами задания
Функция ДополнительныйОтборСпискаЗаданий(ИдентификаторЗадания) Экспорт
	
	ДопОтбор = "";
	
	//++ Локализация
	Если ИдентификаторЗадания = Неопределено Тогда 
		ДопОтбор = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.ЗагрузитьРекомендованныеЦеныЯндексМаркет);
	Иначе	
		ДопОтбор = Новый Структура("УникальныйИдентификатор",Новый УникальныйИдентификатор(ИдентификаторЗадания));
	КонецЕсли;	
	//-- Локализация
	
	Возврат ДопОтбор;
	
КонецФункции

// Возвращает описание регламентного задания, если список содержит
// значения только со способом задания цены Загружается из Яндекс.Маркет
//
// Параметры:
//     ВидыЦен - Массив Из СправочникСсылка.ВидыЦен- Массив видов цен, выбанных в форме настройки регламентного
//              задания
//     ВариантОбновленияЦен - Число - номер выбранного варианта обновления цен
//
// Возвращаемое значение:
//         Структура:
//                  *ИмяМетаданных - Строка  - имя метеданных
//                  *СинонимМетаданных - Строка  - синоним метеданных
//                  *ИмяМетодаМетаданных - Строка  - имя метода метеданных
//                  *Отказ - Булево - отказ
Функция СписокСодержитВидыЦенДляРазныхРегламентов(ВидыЦен, ВариантОбновленияЦен) Экспорт

	Отказ = Ложь;
	ОписаниеЗадания = Новый Структура("ИмяМетаданных, СинонимМетаданных, ИмяМетодаМетаданных, Отказ");
	
	//++ Локализация
	Если ВидыЦен.Количество()>0
		И (ВариантОбновленияЦен<>0) Тогда
		Запрос = Новый Запрос();
		Запрос.Параметры.Вставить("СписокЦен",ВидыЦен);
		Запрос.Текст = "ВЫБРАТЬ
		|	СУММА(ВЫБОР КОГДА ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗагружаетсяИзЯндексМаркет) ТОГДА 1 ИНАЧЕ 0 КОНЕЦ) КАК  КоличествоВидовЦенЗагужаетсяИзЯндексМаркет,
		|	СУММА(ВЫБОР КОГДА ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗагружаетсяИзЯндексМаркет) ТОГДА 0 ИНАЧЕ 1 КОНЕЦ) КАК  КоличествоДругихВидовЦен
		|ИЗ
		|	Справочник.ВидыЦен КАК ВидыЦен
		|ГДЕ ВидыЦен.Ссылка В(&СписокЦен) И НЕ ВидыЦен.ПометкаУдаления";
		
		Результат = Запрос.Выполнить().Выбрать();
		
		Пока Результат.Следующий() Цикл
			Если Результат.КоличествоВидовЦенЗагужаетсяИзЯндексМаркет>0
				И НЕ ВариантОбновленияЦен=3
				И Результат.КоличествоДругихВидовЦен=0 Тогда
				
				Расписание = Новый РасписаниеРегламентногоЗадания;
				Задание = Метаданные.РегламентныеЗадания.ЗагрузитьРекомендованныеЦеныЯндексМаркет;
				
				ОписаниеЗадания.ИмяМетаданных       = Задание.Имя;
				ОписаниеЗадания.СинонимМетаданных   = Задание.Синоним;
				ОписаниеЗадания.ИмяМетодаМетаданных = Задание.ИмяМетода;
				
			ИначеЕсли Результат.КоличествоВидовЦенЗагужаетсяИзЯндексМаркет>0
				И Результат.КоличествоДругихВидовЦен>0 Тогда
					Отказ = Истина;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	//-- Локализация
	
	ОписаниеЗадания.Отказ = Отказ;

	Возврат ОписаниеЗадания;

КонецФункции

// Возвращает настройки по способу задания цены
//
// Возвращаемое значение:
//                         Структура:
//                                   *ИмяПараметра - Строка - имя параметра 
//                                   *СписокВыбора - Строка - список выбора (строка с разделителем)
//                                   *ЗначениеПараметра - Строка - значение параметра
Функция НастройкиПоСпособуЗаданияЦеныЯндексМаркет() Экспорт
	
	НастройкиПоСпособуЗаданияЦены = Неопределено;
	
	//++ Локализация
	НастройкиПоСпособуЗаданияЦены = ИнтеграцияСЯндексМаркетСервер.СтруктураПараметровСпособаЗаданияЦены();
	//-- Локализация
	
	Возврат НастройкиПоСпособуЗаданияЦены;
	
КонецФункции

// Вызывает локализуемую процедуру ЗагрузитьРекомендованныеЦеныЯндексМаркет
//
// Параметры:
//         ПараметрыЗадания - Структура:
//                  *НемедленноеОбновление - Булево  - признак, определяющий
//                                         запуск по инициативе пользователя
//                  *ТаблицаВидовЦен - ТаблицаЗначений  - таблица видов цен
Процедура ЗагрузитьРекомендованныеЦеныЯндексМаркет(ПараметрыЗадания) Экспорт

	//++ Локализация
	ИнтеграцияСЯндексМаркетСервер.ЗагрузитьРекомендованныеЦеныЯндексМаркет(ПараметрыЗадания);
	//-- Локализация

КонецПроцедуры

// Вызывает локализуемую процедуру ЗагрузитьЦеныOzon
//
// Параметры:
//  УчетнаяЗаписьМаркетплейса - СправочникСсылка.УчетныеЗаписиМаркетплейсов - Учетная запись для загрузки
//  ВидыЦен                   - Массив - Загружаемые цены
Процедура ЗагрузитьЦеныOzon(УчетнаяЗаписьМаркетплейса, ВидыЦен) Экспорт

	//++ Локализация
	ТаблицаТоваров = ИнтеграцияСМаркетплейсомOzonСервер.СведенияОВыгруженныхДанных();
	ИнтеграцияСМаркетплейсомOzonСервер.ЗагрузитьЦеныТоваров(УчетнаяЗаписьМаркетплейса, ТаблицаТоваров, ВидыЦен);
	//-- Локализация

КонецПроцедуры

// Возвращает настройки по способу задания цены
//
// Возвращаемое значение:
//                         Структура:
//                                   *ИмяПараметра - Строка - имя параметра 
//                                   *СписокВыбора - Строка - список выбора (строка с разделителем)
//                                   *ЗначениеПараметра - Строка - значение параметра
Функция НастройкиПоСпособуЗаданияЦеныOzon() Экспорт
	
	НастройкиПоСпособуЗаданияЦены = Неопределено;
	
	//++ Локализация
	НастройкиПоСпособуЗаданияЦены = ИнтеграцияСМаркетплейсомOzonСервер.СтруктураПараметровСпособаЗаданияЦены();
	//-- Локализация
	
	Возврат НастройкиПоСпособуЗаданияЦены;
	
КонецФункции

// Возвращает список значений выбора для способа задания цены
//
// Возвращаемое значение:
//                         СписокЗначений:
//                                   *Значение - Строка - идентификатор формулы 
//                                   *Представление - Строка - значение для списка выбора
//
Функция ЗагружаемыеТипыЦенНаOzon() Экспорт
	
	СписокТиповЦенНаOzon = Новый СписокЗначений;
	
	//++ Локализация
	СписокТиповЦенНаOzon = ИнтеграцияСМаркетплейсомOzonСервер.ЗагружаемыеТипыЦенНаOzon();
	//-- Локализация
	
	Возврат СписокТиповЦенНаOzon;
	
КонецФункции

// Возвращает детальную информацию по типам цен, используемым учетными записями Ozon.
//
// Параметры:
//  ВключатьВыгружаемые - Булево - Признак включения в результат функции выгружаемых типов цен.
//  ВключатьЗагружаемые - Булево - Признак включения в результат функции загружаемых типов цен.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. описание в ИнтеграцияСМаркетплейсомOzonСервер.ТипыЦенOzon().
//
	Функция ТипыЦенOzon(ВключатьВыгружаемые = Истина, ВключатьЗагружаемые = Истина) Экспорт

	СписокТиповЦенНаOzon = Новый СписокЗначений;
	
	//++ Локализация
	СписокТиповЦенНаOzon = ИнтеграцияСМаркетплейсомOzonСервер.ТипыЦенOzon(ВключатьВыгружаемые, ВключатьЗагружаемые);
	//-- Локализация
	
	Возврат СписокТиповЦенНаOzon;

КонецФункции

// Возвращает список настроек подключения к маркетплейсу Ozon.
//
// Возвращаемое значение:
//  СписокЗначений:
// 	 * Значение - СправочникСсылка.УчетныеЗаписиМаркетплейсов - учетная запись 
//   * Представление - Строка - представление учетной записи
//
Функция СписокНастроекПодключенияКСервису() Экспорт
	
	СписокНастроек = Новый СписокЗначений;
	
	//++ Локализация
	СписокНастроек = ИнтеграцияСМаркетплейсомOzonСервер.СписокНастроекПодключенияКСервису();
	//-- Локализация
	
	Возврат СписокНастроек;
	
КонецФункции  

// Возвращает типы цен, для которых необходима детализация по учетной записи.
//
// Возвращаемое значение:
//  Массив
//
Функция ПолучитьТипыЦенНаOzonДляУчетныхЗаписей() Экспорт

	ТипыЦенНаOzonДляУчетныхЗаписей = Новый Массив;
	
	//++ Локализация
	ТипыЦенНаOzonДляУчетныхЗаписей = ИнтеграцияСМаркетплейсомOzonСервер.ПолучитьТипыЦенНаOzonДляУчетныхЗаписей();
	//-- Локализация
	
	Возврат ТипыЦенНаOzonДляУчетныхЗаписей;

КонецФункции

// Вызывает локализуемую процедуру ДобавитьЗаполнитьУчетнуюЗапись
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Изменяемая форма.
//
Процедура ДобавитьЗаполнитьУчетнуюЗапись(Форма) Экспорт

	//++ Локализация
	Если Форма.Параметры.Свойство("УчетнаяЗаписьМаркетплейса") Тогда
		ИнтеграцияСМаркетплейсомOzonСервер.ДобавитьЗаполнитьУчетнуюЗапись(Форма);
	КонецЕсли;
	//-- Локализация

КонецПроцедуры

// Вызывает локализуемую процедуру ДобавитьЗаполнитьУчетнуюЗапись
//
// Параметры:
//  СтруктураНастроек - Структура - данные, структура настроек.
//  Компоновщик       - КомпоновщикНастроек - компоновщик макета компоновки данных.
//
Процедура ЗаполнитьУчетнуюЗапись(СтруктураНастроек, Компоновщик) Экспорт

	//++ Локализация
	ИнтеграцияСМаркетплейсомOzonСервер.ЗаполнитьУчетнуюЗапись(СтруктураНастроек, Компоновщик);
	//-- Локализация

КонецПроцедуры

// Заполняет учетную запись в настройках компоновщика данных.
//
// Параметры:
//  Форма                 - ФормаКлиентскогоПриложения - Изменяемая форма.
//  НастройкиКомпоновщика - НастройкиКомпоновкиДанных - настройки компоновки данных.
//
Процедура УстановитьУчетнуюЗапись(Форма, НастройкиКомпоновщика) Экспорт

	//++ Локализация
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "УчетнаяЗаписьМаркетплейса") Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиКомпоновщика, "УчетнаяЗаписьМаркетплейса", Форма.УчетнаяЗаписьМаркетплейса);
	КонецЕсли;
	//-- Локализация

КонецПроцедуры

// Добавляет учетную запись в структуру настроек.
//
// Параметры:
//  Форма             - ФормаКлиентскогоПриложения - Изменяемая форма.
//  СтруктураНастроек - Структура - данные, структура настроек.
//
Процедура ДополнитьСтруктуруНастроекДляМаркетплейсов(Форма, СтруктураНастроек) Экспорт

	//++ Локализация
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "УчетнаяЗаписьМаркетплейса") Тогда
		СтруктураНастроек.Вставить("УчетнаяЗаписьМаркетплейса", Форма.УчетнаяЗаписьМаркетплейса);
	КонецЕсли;
	//-- Локализация

КонецПроцедуры

// Дополняет текст запроса СКД для ценообразования. Вызывается из обработки ПодборТоваровПоОтбору.
//
// Параметры:
//  СхемаКомпоновкиДанных - СхемаКомпоновкиДанных - Модифицируемая схема.
//
Процедура ДополнитьСКДДляМаркетплейсов(Форма, СхемаКомпоновкиДанных) Экспорт

	//++ Локализация
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "УчетнаяЗаписьМаркетплейса") Тогда
		ИнтеграцияСМаркетплейсомOzonСервер.ДополнитьСКДДляМаркетплейсов(СхемаКомпоновкиДанных);
	КонецЕсли;
	//-- Локализация

КонецПроцедуры

// Дополняет текст запроса для подбора товаров. Вызывается из обработки ПодборТоваровВДокументПродажи.
//
// Параметры:
//  ШаблонТекстЗапроса - Строка - Текст запроса для динамического списка;
//  ТипСписка          - Строка - Может принимать значения: СписокНоменклатура, СписокХарактеристики, СписокНоменклатураПартнера.
//
Процедура ДополнитьТекстЗапросаДляМаркетплейсов(Форма, ШаблонТекстЗапроса, ТипСписка) Экспорт

	//++ Локализация
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "УчетнаяЗаписьМаркетплейса") Тогда
		ИнтеграцияСМаркетплейсомOzonСервер.ДополнитьТекстЗапросаДляМаркетплейсов(ШаблонТекстЗапроса, ТипСписка);
	КонецЕсли;
	//-- Локализация

КонецПроцедуры

// Дополняет условное оформление динамического списка.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Изменяемая форма.
//
Процедура УстановитьУсловноеОформлениеДинамическихСписков(Форма) Экспорт

	//++ Локализация
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "УчетнаяЗаписьМаркетплейса") Тогда
		ИнтеграцияСМаркетплейсомOzonСервер.УстановитьУсловноеОформлениеДинамическихСписков(Форма);
	КонецЕсли;
	//-- Локализация

КонецПроцедуры

// Устанавливает параметры динамических списков формы подбора номенклатуры.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Изменяемая форма.
//  СписокНоменклатура - ДинамическийСписок - реквизит формы СписокНоменклатура.
//  СписокХарактеристики - ДинамическийСписок - реквизит формы СписокХарактеристики.
//
Процедура УстановитьПараметрыДинамическогоСписка(Форма, СписокНоменклатура, СписокХарактеристики) Экспорт

	//++ Локализация
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "УчетнаяЗаписьМаркетплейса") Тогда
		ПодборТоваровКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНоменклатура, "УчетнаяЗаписьМаркетплейса", Форма.УчетнаяЗаписьМаркетплейса);
		ПодборТоваровКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокХарактеристики, "УчетнаяЗаписьМаркетплейса", Форма.УчетнаяЗаписьМаркетплейса);
	КонецЕсли;
	//-- Локализация

КонецПроцедуры

// Сведения о выгруженных данных
//
// Возвращаемое значение:
//  ТаблицаЗначений - пустая таблица для заполнения выгруженными данными.
//
Функция СведенияОВыгруженныхДанных() Экспорт

	ТаблицаТоваров = Новый ТаблицаЗначений;

	//++ Локализация
	ТаблицаТоваров = ИнтеграцияСМаркетплейсомOzonСервер.СведенияОВыгруженныхДанных();
	//-- Локализация

	Возврат ТаблицаТоваров;

КонецФункции

// Вызывает локализуемую процедуру ЗагрузитьЦеныТоваров
//
// Параметры:
//  УчетнаяЗаписьМаркетплейса - СправочникСсылка.УчетныеЗаписиМаркетплейсов - Учетная запись для загрузки.
//  ТаблицаТоваров            - ТаблицаЗначений - Обрабатываемые товарные позиции.
//                                                Подробнее см.СведенияОВыгруженныхДанных()
//  ВидыЦен                   - Массив - Загружаемые цены.
//
Процедура ЗагрузитьЦеныТоваров(УчетнаяЗаписьМаркетплейса, ТаблицаТоваров, ВидыЦен = Неопределено) Экспорт

	//++ Локализация
	ИнтеграцияСМаркетплейсомOzonСервер.ЗагрузитьЦеныТоваров(УчетнаяЗаписьМаркетплейса, ТаблицаТоваров, ВидыЦен);
	//-- Локализация

КонецПроцедуры

// Возвращает значение произвольного типа параметра способа задания цены.
//
// Возвращаемое значение:
//  Справочник.УчетныеЗаписиМаркетплейсов, Неопределено - значение пустая ссылка или Неопределено.
//
Функция ПараметрыСпособаЗаданияЦеныПроизвольныйТипПоУмолчанию() Экспорт

	ЗначениеПоУмолчанию = Неопределено;

	//++ Локализация
	ЗначениеПоУмолчанию = ПредопределенноеЗначение("Справочник.УчетныеЗаписиМаркетплейсов.ПустаяСсылка");
	//-- Локализация

	Возврат ЗначениеПоУмолчанию;

КонецФункции

#КонецОбласти
