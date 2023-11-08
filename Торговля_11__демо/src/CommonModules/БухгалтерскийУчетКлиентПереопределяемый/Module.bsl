#Область ПрограммныйИнтерфейс

#Область ПроцедурыВыбораЗначенийПереопределяемыхТипов

// Открывает форму для выбора значения договора с установленными отборами.
//
// Параметры:
//	ПараметрыФормы - Структура - Содержит параметры, передаваемые в форму.
//	Элемент - ПолеФормы - Элемент формы, из которого вызвана форма выбора.
//	ФормаВыбора - Строка - Вариант формы выбора (ФормаВыбора или ФормаВыбораГруппы)
//	СтандартнаяОбработка - Булево - Флаг обработки выбора элемента формы
//
Процедура ОткрытьФормуВыбораДоговора(ПараметрыФормы, Элемент, ФормаВыбора = "ФормаВыбора", СтандартнаяОбработка = Истина) Экспорт
	
	СтандартнаяОбработка = Истина;
	
	НовыеПараметры = Новый Массив;
	Если ПараметрыФормы.Отбор.Свойство("Организация") Тогда
		НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Организация", ПараметрыФормы.Отбор.Организация));
	КонецЕсли;
	
	ИмяРеквизитаКонтрагент = БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьИмяРеквизитаКонтрагентДоговора();
	Контрагент = Неопределено;
	
	Если ПараметрыФормы.Отбор.Свойство(ИмяРеквизитаКонтрагент) Тогда
		НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор." + ИмяРеквизитаКонтрагент, ПараметрыФормы.Отбор[ИмяРеквизитаКонтрагент]));
		
		Если ЗначениеЗаполнено(ПараметрыФормы.Отбор[ИмяРеквизитаКонтрагент]) Тогда
			Контрагент = ПараметрыФормы.Отбор[ИмяРеквизитаКонтрагент];
		КонецЕсли;
	КонецЕсли;
	
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
	Элемент.ОграничениеТипа = БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьОписаниеТиповДоговора(Контрагент);
	
КонецПроцедуры

// Открывает форму для выбора значения банковского счета с установленными отборами.
//
// Параметры:
//	ПараметрыФормы - Структура - Содержит параметры, передаваемые в форму.
//	Элемент - ПолеФормы - Элемент формы, из которого вызвана форма выбора.
//
Процедура ОткрытьФормуВыбораБанковскогоСчетОрганизации(ПараметрыФормы, Элемент) Экспорт
	
	ОткрытьФорму("Справочник.БанковскиеСчетаОрганизаций.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

// Открывает форму для выбора значения подразделениям с установленными отборами.
//
// Параметры:
//	ПараметрыФормы - Структура - Содержит параметры, передаваемые в форму.
//	Элемент - ПолеФормы - Элемент формы, из которого вызвана форма выбора.
//
Процедура ОткрытьФормуВыбораПодразделения(ПараметрыФормы, Элемент) Экспорт
	
	ОткрытьФорму("Справочник.СтруктураПредприятия.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

Процедура ОткрытьСчетФактуру(Форма, СчетФактура, ВидСчетаФактуры) Экспорт


КонецПроцедуры

#КонецОбласти

#Область АктуализацияДанных

// Формирует список имен реквизитов формы отчета, содержащих идентификаторы фоновых заданий,
// которые нужно отменить при закрытии отчета.
//
// Возвращаемое значение:
//	Массив - Массив идентификаторов заданий.
//
Функция ЗаданияОтменяемыеПриЗакрытииОтчета() Экспорт
	
	ОтменяемыеЗадания = Новый Массив;
	ОтменяемыеЗадания.Добавить("ИдентификаторЗадания");
	
	Возврат ОтменяемыеЗадания;
	
КонецФункции

// Выполняет действия после вывода результата в табличный документ на форме отчета.
//
// Параметры:
//  Форма        - ФормаКлиентскогоПриложения - место вывода результата отчета.
//
Процедура ПослеФормированияОтчета(Форма) Экспорт

	Если Не ЗначениеЗаполнено(Форма.ИдентификаторЗаданияАктуализации) И Не ЗначениеЗаполнено(Форма.АдресХранилищаАктуализации) Тогда
		// Задание актуализации не запущено, результата выполнения задания тоже нет - значит не проверяем актуальность.
		СкрытьПанельАктуализацииАвтоматически(Форма);
		Возврат;
	КонецЕсли;
	
	Форма.ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеАктуализации");
	Форма.ОтключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеАктуализации");
	
	Если ЗначениеЗаполнено(Форма.ИдентификаторЗаданияАктуализации) Тогда
		
		Элементы = Форма.Элементы;
	
		БухгалтерскиеОтчетыКлиент.СброситьСостояниеАктуализации(Элементы);
		Элементы.Актуализация.Видимость = Истина;
		Элементы.ИдетПроверкаАктуальности.Видимость = Истина;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Форма.ПараметрыОбработчикаОжиданияАктуализации);
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеАктуализации", Форма.ПараметрыОбработчикаОжиданияАктуализации.ТекущийИнтервал, Истина);
		
		Возврат;
	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.АдресХранилищаАктуализации) Тогда
		БухгалтерскиеОтчетыКлиент.ОбработатьРезультатПроверкиАктуальности(Форма.АдресХранилищаАктуализации, Форма);
	КонецЕсли;

КонецПроцедуры

// Проверяет актуальность для формы отчета.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ПроверитьАктуальность(Форма, Организация, Период = Неопределено) Экспорт

	// Совместимость с БП.
	
КонецПроцедуры

// Запускает актуализацию для формы отчета.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура Актуализировать(Форма, Организация, Период = Неопределено) Экспорт
	
	// Совместимость с БП.
	
КонецПроцедуры

// Проверяет завершение актуализации для формы отчета.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ПроверитьВыполнениеАктуализацииОтчета(Форма, Организация, Период = Неопределено) Экспорт
	
	ПараметрыПроверки = БухгалтерскиеОтчетыКлиентСервер.ИнициализироватьПараметрыПроверкиАктуальности(Форма);
	
	ДанныеАктуализации = Новый Структура("ИдентификаторЗаданияАктуализации,АдресХранилищаАктуализации");
	ЗаполнитьЗначенияСвойств(ДанныеАктуализации, Форма);
	
	БухгалтерскиеОтчетыВызовСервера.ПроверитьВыполнениеАктуализацииОтчета(ПараметрыПроверки, ДанныеАктуализации);
	ЗаполнитьЗначенияСвойств(Форма, ДанныеАктуализации);
	
	Если Не ЗначениеЗаполнено(ДанныеАктуализации.ИдентификаторЗаданияАктуализации) Тогда
		БухгалтерскиеОтчетыКлиент.ОбработатьРезультатПроверкиАктуальности(ДанныеАктуализации.АдресХранилищаАктуализации, Форма);
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(Форма.ПараметрыОбработчикаОжиданияАктуализации);
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеАктуализации",
			Форма.ПараметрыОбработчикаОжиданияАктуализации.ТекущийИнтервал, Истина);
	КонецЕсли;

КонецПроцедуры

// Отменяет актуализации для формы отчета.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ОтменитьАктуализацию(Форма, Организация, Период = Неопределено) Экспорт
	
	// Совместимость с БП.
	
КонецПроцедуры

// Проверяет завершение актуализации для формы отчета.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ПроверитьЗавершениеАктуализации(Форма, Организация, Период = Неопределено) Экспорт
	
	ПараметрыПроверки = БухгалтерскиеОтчетыКлиентСервер.ИнициализироватьПараметрыПроверкиАктуальности(Форма);
	
	ДанныеАктуализации = Новый Структура("ИдентификаторЗаданияАктуализации,АдресХранилищаАктуализации", "", "");
	
	БухгалтерскиеОтчетыВызовСервера.ПроверитьВыполнениеАктуализацииОтчета(ПараметрыПроверки, ДанныеАктуализации, Истина);
	ЗаполнитьЗначенияСвойств(Форма, ДанныеАктуализации);
	
	Если ЗначениеЗаполнено(ДанныеАктуализации.ИдентификаторЗаданияАктуализации) Или ЗначениеЗаполнено(ДанныеАктуализации.АдресХранилищаАктуализации) Тогда
		ПослеФормированияОтчета(Форма);
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(Форма.ПараметрыОбработчикаОжиданияАктуализации);
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеАктуализации", Форма.ПараметрыОбработчикаОжиданияАктуализации.ТекущийИнтервал, Истина);
	КонецЕсли;
	
КонецПроцедуры
	
// Обработка оповещения об актуализации для формы отчета.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//	ИмяСобытия - Строка - Имя события оповещения.
//	Параметр - Произвольный - Параметр события оповещения.
//	Источник - Произвольный - Источник события оповещения.
//
Процедура ОбработкаОповещенияАктуализации(Форма, Организация, Период, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "НачалоРасчетаЗакрытияМесяца" Тогда
			
		Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "АдресХранилищаАктуализации")
			Или Не ЗначениеЗаполнено(Форма.АдресХранилищаАктуализации) Тогда
			// Будет не заполнен только когда задание актуализации не запускалось ни разу (то есть когда оно и не должно запускаться)
			Возврат;
		КонецЕсли;
		
		Если (Параметр.СписокОрганизаций.Количество() = 0
			Или Параметр.СписокОрганизаций.Найти(Организация) <> Неопределено)
			И Форма.ДатаАктуальности <= КонецМесяца(Параметр.Период) Тогда
			
			БухгалтерскиеОтчетыКлиент.ОтобразитьСостояниеАктуализации(Форма);
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Скрывает панель актуализации на форме отчета автоматически.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//
Процедура СкрытьПанельАктуализацииАвтоматически(Форма) Экспорт
	
	Если ЗначениеЗаполнено(Форма.ИдентификаторЗаданияАктуализации) Тогда
		Возврат;
	КонецЕсли;
		
	КонецПериода = '00010101';
	Если Не (Форма.Отчет.Свойство("КонецПериода", КонецПериода) Или Форма.Отчет.Свойство("Период", КонецПериода))
	 Или Не ЗначениеЗаполнено(КонецПериода) Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.ДатаАктуальности > КонецПериода Тогда
		СкрытьПанельАктуализации(Форма);
	КонецЕсли;
	
КонецПроцедуры

// Скрывает панель актуализации на форме отчета.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//
Процедура СкрытьПанельАктуализации(Форма) Экспорт

	Форма.Элементы.Актуализация.Видимость = Ложь;
	
КонецПроцедуры

// Обрабатывает навигационную ссылку, если данные не актуальны. Открывает форму обработки закрытия месяца.
//
//	Параметры:
//		ФормаОтчета - ФормаКлиентскогоПриложения - форма отчета, имеет основной реквизит "Отчет";
//		НавигационнаяСсылка - Строка - см. параметр обработки события формы "ОбработкаНавигационнойСсылки";
//		СтандартнаяОбработка - Булево - см. параметр обработки события формы "ОбработкаНавигационнойСсылки".
//
Процедура ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(ФормаОтчета, НавигационнаяСсылка, СтандартнаяОбработка) Экспорт
	
	ПараметрыАктуализации = Новый Структура("ПериодРегистрации, Организация", НачалоМесяца(ФормаОтчета.Отчет.КонецПериода), ФормаОтчета.Отчет.Организация);

	Если СтрНайти(НавигационнаяСсылка, "ЗакрытиеМесяца") <> 0 Тогда

		СтандартнаяОбработка = Ложь;
		
		Оповещение = Новый ОписаниеОповещения("ЗакрытиеМесяцаЗавершение", ФормаОтчета);
		ФормаЗакрытияМесяца = ОткрытьФорму("Обработка.ОперацииЗакрытияМесяца.Форма", ПараметрыАктуализации, ФормаОтчета, , , , Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВопросАктуализироватьЗавершение(ВыбранныйВариант, ДополнительныеПараметры) Экспорт


КонецПроцедуры

// Проверяет завершение проверки актуальности для формы отчета.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма отчета.
//
Процедура ПроверитьВыполнениеПроверкиАктуальностиОтчета(Форма) Экспорт

	// Совместимость с БП.

КонецПроцедуры

#КонецОбласти

#КонецОбласти
