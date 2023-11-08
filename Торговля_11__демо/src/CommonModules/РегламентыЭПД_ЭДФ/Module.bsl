//@strict-types

#Область СлужебныеПроцедурыИФункции

#Область ДляВызоваИзМодуляРегламентыЭДО

// Возвращает состояние входящего электронного документа.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция СостояниеВходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента) Экспорт
	
	Состояние = Перечисления.СостоянияДокументовЭДО.ПустаяСсылка();
	
	Если ЗаполнитьСостояниеПоВходящейИнформацииОтправителя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		ИЛИ ЗначениеЗаполнено(Состояние) Тогда
		
		Возврат Состояние;
		
	ИначеЕсли ПараметрыДокумента.Исправлен Тогда
		
		Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершенСИсправлением;
		
	КонецЕсли;
	
	Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершен;
	
КонецФункции

// Возвращает состояние исходящего электронного документа.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция СостояниеИсходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента) Экспорт
	
	Состояние = Перечисления.СостоянияДокументовЭДО.ПустаяСсылка();
	
	Если ЗаполнитьСостояниеПоИсходящейИнформацииОтправителя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		Тогда
		
		Возврат Состояние;
		
	ИначеЕсли ПараметрыДокумента.Исправлен Тогда
		
		Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершенСИсправлением;
		
	КонецЕсли;
	
	Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершен;
	
КонецФункции

// Возвращает состояние сообщения.
//
// Параметры:
//  ПараметрыСообщения - См. РегламентыЭДО.НовыеПараметрыСообщенияДляОпределенияСостояния
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостоянияСообщения
//  ИспользоватьУтверждение  - Булево
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияСообщенийЭДО
//
Функция СостояниеСообщения(ПараметрыСообщения, ПараметрыДокумента, ИспользоватьУтверждение) Экспорт
	
	Состояние = Перечисления.СостоянияСообщенийЭДО.ПустаяСсылка();
	
	Статус = ПараметрыСообщения.Статус;
	
	Если Статус = Перечисления.СтатусыСообщенийЭДО.Получен Тогда
		
		Если ПараметрыДокумента.ОбменБезПодписи Тогда
			Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке;
		Иначе
			Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Утвержден Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Сформирован Тогда
		
		Если ПараметрыДокумента.ОбменБезПодписи Тогда
			Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке;
		Иначе
			Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание;
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.ЧастичноПодписан Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Подписан Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке;
				
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.ПодготовленКОтправке Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка;
		
	ИначеЕсли Статус = Перечисления.СтатусыСообщенийЭДО.Отправлен Тогда
		
		Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение; 

	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

// Возвращает коллекцию добавленных элементов схемы регламента.
// 
// Параметры:
//  СхемаРегламента - См. РегламентыЭДО.НоваяСхемаРегламента
//  НастройкиСхемыРегламента - См. РегламентыЭДО.НовыеНастройкиСхемыРегламента
//
// Возвращаемое значение:
//  См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
//
Функция ДобавитьЭлементыСхемыРегламента(СхемаРегламента, НастройкиСхемыРегламента) Экспорт
	
	ЭлементыСхемы = РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента();
	
	ДобавитьЭлементыРегламентаОтправителя(СхемаРегламента, НастройкиСхемыРегламента, ЭлементыСхемы);
	
	Возврат ЭлементыСхемы;
	
КонецФункции

// Параметры:
//  СхемаРегламента - см. РегламентыЭДО.НоваяСхемаРегламента
//  НастройкиСхемыРегламента - см. РегламентыЭДО.НовыеНастройкиСхемыРегламента
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
// 
// Возвращаемое значение:
//  См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
Функция ДобавитьЭлементыСхемыВложенногоРегламента(СхемаРегламента, НастройкиСхемыРегламента, ТипЭлементаРегламента) Экспорт
	
	Возврат РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента();
	
КонецФункции

// Возвращает тип извещения для элемента входящего документа.
// 
// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
Функция ТипИзвещенияДляЭлементаВходящегоДокумента(ТипЭлементаРегламента) Экспорт
	
	Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПустаяСсылка();
	
	Возврат Результат;
	
КонецФункции

// Возвращает тип извещения для элемента исходящего документа.
// 
// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
Функция ТипИзвещенияДляЭлементаИсходящегоДокумента(ТипЭлементаРегламента) Экспорт
	
	Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПустаяСсылка();
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак наличия информации получателя в регламенте.
// 
// Возвращаемое значение:
//  Булево
//
Функция ЕстьИнформацияПолучателя() Экспорт
	Возврат Истина;
КонецФункции

#КонецОбласти

#Область ДобавитьЭлементыСхемыРегламента

// Добавляет элементы по регламенту отправителя.
// 
// Параметры:
//  СхемаРегламента - См. РегламентыЭДО.НоваяСхемаРегламента
//  НастройкиСхемыРегламента - См. РегламентыЭДО.НовыеНастройкиСхемыРегламента
//  ЭлементыСхемы - См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
//
Процедура ДобавитьЭлементыРегламентаОтправителя(СхемаРегламента, НастройкиСхемыРегламента, ЭлементыСхемы)
	
	ЭДФ_Титул1 = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, СхемаРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул1);
		
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ЭДФ_Титул1,
			Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул2);		
		
	РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ЭДФ_Титул1,
		Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_ОткФщ);

КонецПроцедуры

#КонецОбласти

#Область СостояниеДокумента

// Возвращает признак успешности заполнения состояния по входящей информации отправителя.
// 
// Параметры:
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоВходящейИнформацииОтправителя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	ОбменЗавершен = Ложь;
	
	Если ЗаполнитьСостояниеПоОтклонению(ПараметрыДокумента, 
									СостоянияЭлементовРегламента, Состояние) Тогда
										
		Возврат Истина;
		
	ИначеЕсли РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул2, ЭлементРегламента) Тогда
			
			ОбменЗавершен = Истина;
		
	ИначеЕсли РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул1, ЭлементРегламента) Тогда
		
	Иначе
		
		Состояние = РегламентыЭДО.НачальноеСостояниеДокумента();
		Возврат Ложь;
		
	КонецЕсли;	
	
	Если ОбменЗавершен = Истина 
		И (ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение
			Или ЭтоВходящийЭлементРегламента(ЭлементРегламента)) Тогда
		Состояние = Перечисления.СостоянияДокументовЭДО.ОбменЗавершен;
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание;
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправка;
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправке;
	Иначе
		Если СостоянияЭлементовРегламента.Колонки.Найти("Ссылка") = Неопределено Тогда
			// Новый документ
			ТекущийДоступныйТитул = Неопределено;
		Иначе	
			ТекущийДоступныйТитул = ТекущийДоступныйТитул(ПараметрыДокумента, ЭлементРегламента);
		КонецЕсли;
		
		//ПараметрыДокумента.ТребуетсяИзвещение = Ложь;
		Если ЗаполнитьСостояниеДляИзвещения(ПараметрыДокумента, ЭлементРегламента, СостоянияЭлементовРегламента, Состояние) Тогда
			Возврат Истина;		
		ИначеЕсли ЗначениеЗаполнено(ТекущийДоступныйТитул)
			И ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание;
		Иначе	
			Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждение;	
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


Функция ЗаполнитьСостояниеДляИзвещения(ПараметрыДокумента, ЭлементРегламента, СостоянияЭлементовРегламента, Состояние)
	
	Если ПараметрыДокумента.ТребуетсяИзвещение = Истина Тогда 
		Если ЭлементРегламента.ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул1 Тогда
			ТипЭлементаРегламентаИзвещение = Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул1_ИОП;
		Иначе
			Возврат Ложь;
		КонецЕсли;
		ЭлементРегламентаИзвещение = Неопределено;
		Если ЭтоВходящийЭлементРегламента(ЭлементРегламента) Тогда		
			Если ЗаполнитьСостояниеПоИсходящемуИзвещениюОПолучении(
					ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние,
					ТипЭлементаРегламентаИзвещение) Тогда
				Возврат Истина;
			КонецЕсли;			
		ИначеЕсли Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
				ТипЭлементаРегламентаИзвещение, ЭлементРегламентаИзвещение) Тогда					
			Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяИзвещениеОПолучении;
			Возврат Истина;			
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции


// Возвращает признак успешности заполнения состояния по исходящему извещению о получении.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящемуИзвещениюОПолучении(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние, ТипЭлементаИзвещение)
	
	Если Не ПараметрыДокумента.ТребуетсяИзвещение Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		ТипЭлементаИзвещение, ЭлементРегламента) Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяИзвещениеОПолучении;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаИзвещения;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


Функция ТекущийДоступныйТитул(ПараметрыДокумента, ЭлементРегламента)
	
	ИдФайл = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементРегламента.Ссылка, "ОсновнойФайл.ПолноеИмяФайла");
	
	ИдентификаторОрганизации = Неопределено;
	Если ТипЗнч(ПараметрыДокумента) = Тип("Структура") Тогда
		ПараметрыДокумента.Свойство("ИдентификаторОрганизации", ИдентификаторОрганизации);
	ИначеЕсли ТипЗнч(ПараметрыДокумента) = Тип("ВыборкаИзРезультатаЗапроса") Тогда
		Если ПараметрыДокумента.Владелец().Колонки.Найти("ИдентификаторОрганизации") <> Неопределено Тогда
			ИдентификаторОрганизации = ПараметрыДокумента.ИдентификаторОрганизации;
		КонецЕсли;
	КонецЕсли;
	
	Адресаты = ОбменСГИСЭПДКлиентСервер.АдресатыПоИдФайл(ИдФайл);
	Если ИдентификаторОрганизации = Адресаты.Грузоотправитель Тогда
		РольУчастника = 3;
	ИначеЕсли ИдентификаторОрганизации = Адресаты.Грузоперевозчик Тогда 
		РольУчастника = 1;
	КонецЕсли;
	
	ТекущийДоступныйТитул = Неопределено;
	// Перевозчик
	Если РольУчастника = 1 Тогда	
		Если ЭлементРегламента.ТипЭлементаРегламента = ПредопределенноеЗначение("Перечисление.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул1") Тогда
			ТекущийДоступныйТитул = ПредопределенноеЗначение("Перечисление.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул2");	
		ИначеЕсли ЭлементРегламента.ТипЭлементаРегламента = ПредопределенноеЗначение("Перечисление.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул2")
			И ЭлементРегламента.Состояние <> Перечисления.СостоянияСообщенийЭДО.Хранение Тогда
				ТекущийДоступныйТитул = ЭлементРегламента.ТипЭлементаРегламента;
		КонецЕсли;			
	// Грузоотправитель
	ИначеЕсли РольУчастника = 3 Тогда	
		Если ЭлементРегламента.ТипЭлементаРегламента = ПредопределенноеЗначение("Перечисление.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул1")
			И ЭлементРегламента.Состояние <> Перечисления.СостоянияСообщенийЭДО.Хранение Тогда
			ТекущийДоступныйТитул = ЭлементРегламента.ТипЭлементаРегламента;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекущийДоступныйТитул;
	
КонецФункции


// Возвращает признак успешности заполнения состояния по исходящей информации отправителя.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящейИнформацииОтправителя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	ОбменЗавершен = Ложь;
	
	Если ЗаполнитьСостояниеПоОтклонению(ПараметрыДокумента, 
									СостоянияЭлементовРегламента, Состояние) Тогда
										
		Возврат Истина;
			
	ИначеЕсли РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул2, ЭлементРегламента) Тогда
			
			ОбменЗавершен = Истина;
		
	ИначеЕсли РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул1, ЭлементРегламента) Тогда
		
	Иначе
		
		Состояние = РегламентыЭДО.НачальноеСостояниеДокумента();
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ОбменЗавершен = Истина 
		И (ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение
			Или ЭтоВходящийЭлементРегламента(ЭлементРегламента)) Тогда
		Состояние = Перечисления.СостоянияДокументовЭДО.ОбменЗавершен;
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание;
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправка;
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправке;
	Иначе
		Если СостоянияЭлементовРегламента.Колонки.Найти("Ссылка") = Неопределено Тогда
			// Новый документ
			ТекущийДоступныйТитул = Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_Титул1;
		Иначе	
			ТекущийДоступныйТитул = ТекущийДоступныйТитул(ПараметрыДокумента, ЭлементРегламента);
		КонецЕсли;
		
		//ПараметрыДокумента.ТребуетсяИзвещение = Ложь;
		Если ЗаполнитьСостояниеДляИзвещения(ПараметрыДокумента, ЭлементРегламента, СостоянияЭлементовРегламента, Состояние) Тогда
			Возврат Истина;		
		ИначеЕсли ЗначениеЗаполнено(ТекущийДоступныйТитул)
			И ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание;
		Иначе
			Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждение;	
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЭтоВходящийЭлементРегламента(ЭлементРегламента)
	
	Если ЭлементРегламента.Владелец().Колонки.Найти("Ссылка") = Неопределено Тогда
		Результат = Ложь;
	Иначе
		СообщениеСсылка = ЭлементРегламента.Ссылка;
		Если ТипЗнч(СообщениеСсылка) = Тип("ДокументСсылка.СообщениеЭДО") Тогда
			Результат = СообщениеСсылка.Направление = Перечисления.НаправленияЭДО.Входящий;	
		Иначе
			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по исходящему отклонению.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоОтклонению(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если ПараметрыДокумента.Исправлен = Истина Тогда
		Результат = Ложь;	
	КонецЕсли;
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ЭДФ_ОткФщ, ЭлементРегламента)
		И Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ, ЭлементРегламента) Тогда
		
		Результат = Ложь;
		
	ИначеЕсли ЭтоВходящийЭлементРегламента(ЭлементРегламента) Тогда
		
		Если Не ПараметрыДокумента.Исправлен Тогда	
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяУточнение;	
		Иначе
			Результат = Ложь;	
		КонецЕсли;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеОтклонения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеОтклонения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаОтклонения;
		
	ИначеЕсли Не ПараметрыДокумента.Исправлен Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяИсправление;
		
	Иначе
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонением;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти