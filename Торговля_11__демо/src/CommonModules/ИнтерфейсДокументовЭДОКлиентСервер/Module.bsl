#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработкаПредупрежденийКомпонентов

// Возвращает структуру данных предупреждения компонента.
// 
// Возвращаемое значение:
// 	Структура - параметры просмотра документооборота:
// 	* Вид - Строка - вид предупреждения.
// 	* ТекстОшибки - Строка - текст сообщения.
// 	* Блокирующее - Булево - признак невозможности дальнейших действий без устранения проблемы.
// 	* ДополнительныеДанные - Структура - дополнительные данные для обработки сообщения.
Функция НовыеДанныеПредупрежденияКомпонента() Экспорт
	
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("Вид", "");
	ПараметрыСообщения.Вставить("ТекстОшибки", "");
	ПараметрыСообщения.Вставить("Блокирующее", Ложь);
	ПараметрыСообщения.Вставить("ДополнительныеДанные", Новый Структура);	

	Возврат ПараметрыСообщения;

КонецФункции

// Возвращает структуру данных для открытия формы проблем при обработке документов.
// 
// Возвращаемое значение:
//  Структура - параметры просмотра документооборота:
//  * СписокДокументовКОтправке - Массив из ДокументСсылка - ссылки на обрабатываемые документы.
//  * АдресСведенийОбОшибках - Строка - адрес сведений об ошибках во временном хранилище.
//  * РежимПодписатьОтправить - Булево - режим "Подписать и отправить".
//  * ФормаВладелец - ФормаКлиентскогоПриложения
//
Функция НовыеПараметрыПроблемПриОбработкеДокументов() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("СписокДокументовКОтправке", Новый Массив);
	Параметры.Вставить("АдресСведенийОбОшибках", "");
	Параметры.Вставить("РежимПодписатьОтправить", Ложь);
	Параметры.Вставить("ИсправляемыйДокумент", Неопределено);
	Параметры.Вставить("ФормаВладелец", Неопределено);
	Параметры.Вставить("Предупреждения", Неопределено);
	
	Возврат Параметры;

КонецФункции

#КонецОбласти

#Область ОшибкиПриОбработкеДокументов

Функция ВидОшибкиНетПравДляНастройкиЭДО() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "НетПравДляНастройкиЭДО";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Не удалось сформировать электронный документ'");
	ВидОшибки.ОписаниеПроблемы = НСтр("ru = 'Нет прав для настройки электронного документооборота'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = 'Обратитесь к администратору'");

	Возврат ВидОшибки;
	
КонецФункции

Процедура ЗаполнитьСостояниеЭДО_ФормаДокумента(Параметры) Экспорт
	
	Форма = Параметры.Форма;
	ОбъектУчета = Параметры.ДокументСсылка;
	КонтроллерСостояниеЭДО = Параметры.КонтроллерСостояниеЭДО;
	ГруппаСостояниеЭДО = Параметры.ГруппаСостояниеЭДО;
	
	Если КонтроллерСостояниеЭДО = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОбъектаУчета = ИнтеграцияЭДОВызовСервера.ОписаниеОбъектаУчета(ОбъектУчета);
	Для каждого СтрокаОписания Из ОписаниеОбъектаУчета Цикл
		Если СтрокаОписания.Направление <> ПредопределенноеЗначение("Перечисление.НаправленияЭДО.Внутренний") Тогда
			Продолжить;
		КонецЕсли;
		
		ПризнакВидимости = ИнтерфейсДокументовЭДОВызовСервера.ИспользуетсяЭДОИВнутреннийЭДО();
		Если ГруппаСостояниеЭДО = Неопределено Тогда
			КонтроллерСостояниеЭДО.Видимость = ПризнакВидимости;
		Иначе
			ГруппаСостояниеЭДО.Видимость = ПризнакВидимости;
		КонецЕсли;
		
		Если Не ПризнакВидимости Тогда
			Возврат;
		КонецЕсли;
		
		Прервать;
	КонецЦикла;
	
	ДанныеСостоянияЭДО = ИнтеграцияЭДОВызовСервера.ДанныеСостоянияЭДОДляФормыОбъектаУчета(ОбъектУчета);
	
	Если ГруппаСостояниеЭДО = Неопределено Тогда
		КонтроллерСостояниеЭДО.Видимость = ДанныеСостоянияЭДО.ИспользуетсяОбменЭлектроннымиДокументами;
	Иначе
		ГруппаСостояниеЭДО.Видимость = ДанныеСостоянияЭДО.ИспользуетсяОбменЭлектроннымиДокументами;
	КонецЕсли;
	
	Если Не ДанныеСостоянияЭДО.ИспользуетсяОбменЭлектроннымиДокументами Тогда
		Возврат;
	КонецЕсли;
	
	СкрыватьСостояниеНеНачатогоЭДО = Ложь;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыОбменаСКонтрагентами") 
		И Форма.ПараметрыОбменаСКонтрагентами <> Неопределено Тогда
		Форма.ПараметрыОбменаСКонтрагентами.Вставить("ДанныеСостоянияЭДОИзначальные", ДанныеСостоянияЭДО);
		Форма.ПараметрыОбменаСКонтрагентами.Вставить("ДанныеСостоянияЭДОТекущие", ДанныеСостоянияЭДО);
		СкрыватьСостояниеНеНачатогоЭДО = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
			Форма.ПараметрыОбменаСКонтрагентами, "СкрыватьСостояниеНеНачатогоЭДО", Ложь);
	КонецЕсли;
	
	Если ПустаяСтрока(ДанныеСостоянияЭДО.ПредставлениеСостояния)
		ИЛИ СкрыватьСостояниеНеНачатогоЭДО И ДанныеСостоянияЭДО.ЭтоСостояниеНеНачатогоЭДО Тогда
		Если ГруппаСостояниеЭДО = Неопределено Тогда
			КонтроллерСостояниеЭДО.Видимость = Ложь;
		Иначе
			ГруппаСостояниеЭДО.Видимость = Ложь;
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(КонтроллерСостояниеЭДО) = Тип("ПолеФормы")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыОбменаСКонтрагентами") 
		И Форма.ПараметрыОбменаСКонтрагентами <> Неопределено		 
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.ПараметрыОбменаСКонтрагентами, "ПутьКДаннымКонтроллераСостояния") Тогда
		Форма[Форма.ПараметрыОбменаСКонтрагентами.ПутьКДаннымКонтроллераСостояния] = ДанныеСостоянияЭДО.ПредставлениеСостояния;
	ИначеЕсли ТипЗнч(КонтроллерСостояниеЭДО) = Тип("ДекорацияФормы") Тогда
		КонтроллерСостояниеЭДО.Заголовок = ДанныеСостоянияЭДО.ПредставлениеСостояния;
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьСостояниеЭДО_ФормаСправочника(Параметры) Экспорт
	
	Форма = Параметры.Форма;
	ОбъектУчета = Параметры.СправочникСсылка;
	КонтроллерСостояниеЭДО = Параметры.КонтроллерСостояниеЭДО;
	ГруппаСостояниеЭДО = Параметры.ГруппаСостояниеЭДО;
	
	Если КонтроллерСостояниеЭДО = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОбъектаУчета = ИнтеграцияЭДОВызовСервера.ОписаниеОбъектаУчета(ОбъектУчета);
	Для каждого СтрокаОписания Из ОписаниеОбъектаУчета Цикл
		Если СтрокаОписания.Направление <> ПредопределенноеЗначение("Перечисление.НаправленияЭДО.Внутренний") Тогда
			Продолжить;
		КонецЕсли;
		
		ПризнакВидимости = ИнтерфейсДокументовЭДОВызовСервера.ИспользуетсяЭДОИВнутреннийЭДО();
		Если ГруппаСостояниеЭДО = Неопределено Тогда
			КонтроллерСостояниеЭДО.Видимость = ПризнакВидимости;
		Иначе
			ГруппаСостояниеЭДО.Видимость = ПризнакВидимости;
		КонецЕсли;
		
		Если Не ПризнакВидимости Тогда
			Возврат;
		КонецЕсли;
		
		Прервать;
	КонецЦикла;
	
	ДанныеСостоянияЭДО = ИнтеграцияЭДОВызовСервера.ДанныеСостоянияЭДОДляФормыОбъектаУчета(ОбъектУчета);
	
	Если ГруппаСостояниеЭДО = Неопределено Тогда
		КонтроллерСостояниеЭДО.Видимость = ДанныеСостоянияЭДО.ИспользуетсяОбменЭлектроннымиДокументами;
	Иначе
		ГруппаСостояниеЭДО.Видимость = ДанныеСостоянияЭДО.ИспользуетсяОбменЭлектроннымиДокументами;
	КонецЕсли;
	
	Если Не ДанныеСостоянияЭДО.ИспользуетсяОбменЭлектроннымиДокументами Тогда
		Возврат;
	КонецЕсли;
	
	СкрыватьСостояниеНеНачатогоЭДО = Ложь;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыОбменаСКонтрагентами") 
		И Форма.ПараметрыОбменаСКонтрагентами <> Неопределено Тогда
		Форма.ПараметрыОбменаСКонтрагентами.Вставить("ДанныеСостоянияЭДОИзначальные", ДанныеСостоянияЭДО);
		Форма.ПараметрыОбменаСКонтрагентами.Вставить("ДанныеСостоянияЭДОТекущие", ДанныеСостоянияЭДО);
		СкрыватьСостояниеНеНачатогоЭДО = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
			Форма.ПараметрыОбменаСКонтрагентами, "СкрыватьСостояниеНеНачатогоЭДО", Ложь);
	КонецЕсли;
	
	Если ПустаяСтрока(ДанныеСостоянияЭДО.ПредставлениеСостояния)
		ИЛИ СкрыватьСостояниеНеНачатогоЭДО И ДанныеСостоянияЭДО.ЭтоСостояниеНеНачатогоЭДО Тогда
		Если ГруппаСостояниеЭДО = Неопределено Тогда
			КонтроллерСостояниеЭДО.Видимость = Ложь;
		Иначе
			ГруппаСостояниеЭДО.Видимость = Ложь;
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(КонтроллерСостояниеЭДО) = Тип("ПолеФормы")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыОбменаСКонтрагентами") 
		И Форма.ПараметрыОбменаСКонтрагентами <> Неопределено		 
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.ПараметрыОбменаСКонтрагентами, "ПутьКДаннымКонтроллераСостояния") Тогда
		Форма[Форма.ПараметрыОбменаСКонтрагентами.ПутьКДаннымКонтроллераСостояния] = ДанныеСостоянияЭДО.ПредставлениеСостояния;
	ИначеЕсли ТипЗнч(КонтроллерСостояниеЭДО) = Тип("ДекорацияФормы") Тогда
		КонтроллерСостояниеЭДО.Заголовок = ДанныеСостоянияЭДО.ПредставлениеСостояния;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

Функция НайтиЭлементСхемыИнформацияПолучателя(ЭлементСхемыРегламенты) Экспорт
	
	Результат = Неопределено;
	
	Если ЭлементСхемыРегламенты.ТипЭлементаРегламента =
		ПредопределенноеЗначение("Перечисление.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя") Тогда
		
		Для Каждого ЭлементСхемы Из ЭлементСхемыРегламенты.ПолучитьЭлементы() Цикл
			Если ЭлементСхемы.ТипЭлементаРегламента = ПредопределенноеЗначение("Перечисление.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя") Тогда
				Результат = ЭлементСхемы;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#Область ЕИС

// Возвращает приложение для ЕИС.
// 
// Параметры:
// 	ЭлементСхемыРегламенты - ДанныеФормыЭлементДерева - Элемент для которого нужно найти информацию отправителя.
// 	ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО - тип регламента элемента схемы.
//
// Возвращаемое значение:
//  ДанныеФормыЭлементДерева, Неопределено - Элемент информации отправителя.
//
Функция НайтиЭлементСхемыПриложениеДляЕИС(ЭлементСхемыРегламенты, ТипЭлементаРегламента) Экспорт
	
	Результат = Неопределено;
	
	Если ЭлементСхемыРегламенты.ТипЭлементаРегламента =
		ПредопределенноеЗначение("Перечисление.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя") Тогда
		
		Для Каждого ЭлементСхемы Из ЭлементСхемыРегламенты.ПолучитьЭлементы() Цикл
			Если ЭлементСхемы.ТипЭлементаРегламента = ТипЭлементаРегламента Тогда
				Результат = ЭлементСхемы;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

Процедура ОбновитьФормуПечатиДокументовБСП(Форма) Экспорт
	
	ОбъектыУчета = Форма.Параметры.ПараметрКоманды;
	
	Если Не ЗначениеЗаполнено(ОбъектыУчета) Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ОбъектыУчета) <> Тип("Массив") Тогда
		 ОбъектыУчета = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОбъектыУчета);
	КонецЕсли;
	
	ПараметрыЭД = Неопределено;
	ОписаниеОбъектаУчета = ИнтеграцияЭДОВызовСервера.ОписаниеОбъектаУчета(ОбъектыУчета[0]);
	Для каждого СтрокаОписания Из ОписаниеОбъектаУчета Цикл
		Если СтрокаОписания.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыДокументовЭДО.Внутренний") Тогда
			ПараметрыЭД = СтрокаОписания;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ПараметрыЭД) Тогда 
		Возврат;
	КонецЕсли;
		
	Команда = ИнтерфейсДокументовЭДОВызовСервера.КомандаПечатиОбъекта(ОбъектыУчета[0], Форма.НастройкиПечатныхФорм[0].ИмяМакета);
	Если Не ЗначениеЗаполнено(Команда) Тогда
		Форма.Элементы.ГруппаДополнительнаяИнформация.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	ВидВнутреннегоДокумента = ИнтерфейсДокументовЭДОВызовСервера.НайтиСоздатьВидВнутреннегоДокумента(ОбъектыУчета[0], Команда);

	Настройки = ИнтерфейсДокументовЭДОВызовСервера.СуществуюНастройкиВнутреннегоЭДО(ПараметрыЭД.Организация, ВидВнутреннегоДокумента); 
		
	ЭДОНачат = ИнтерфейсДокументовЭДОВызовСервера.ЕстьАктуальныеЭлектронныеДокументы(ОбъектыУчета, ВидВнутреннегоДокумента);
	ТекстСостоянияЭД = ИнтеграцияЭДОВызовСервера.ПредставлениеСостоянияВнутреннегоДокументаОбъектаУчета(ОбъектыУчета, ВидВнутреннегоДокумента);
	
	Форма.Элементы.ГруппаДополнительнаяИнформация.Видимость = Ложь;

	Если Настройки <> Неопределено И Настройки.Формировать Или ЭДОНачат Тогда 
		
		Форма.Элементы.ОтправитьНаПодписьКнопкаФормы.КнопкаПоУмолчанию = Истина;
		
		Если ЗначениеЗаполнено(ТекстСостоянияЭД) И ЭДОНачат Тогда
			
			Форма.Элементы.ПредставлениеПрогрессаПодписанияДекорация.Заголовок = Новый ФорматированнаяСтрока(ТекстСостоянияЭД,,,, "ВнутреннийЭДОПрогрессПодписания");
			
			Форма.Элементы.ЭмблемаСервиса1СЭДОПодписаниеКартинка.Видимость = Истина;
			Форма.Элементы.ПредставлениеПрогрессаПодписанияДекорация.Видимость = Истина;
			Форма.Элементы.ОтправитьНаПодписьКнопкаФормы.Видимость = Ложь;
			
		Иначе

			Форма.Элементы.ОтправитьНаПодписьКнопкаФормы.Видимость = ЗначениеЗаполнено(Форма.ОбъектыПечати);
			
		КонецЕсли;
		
		Форма.Элементы.КнопкаПечатьКоманднаяПанель.ЦветФона = Новый Цвет;
		Форма.Элементы.КнопкаПечатьКоманднаяПанель.Отображение = ОтображениеКнопки.Картинка;
		
	ИначеЕсли ЗначениеЗаполнено(ПараметрыЭД) И ПараметрыЭД.Направление = ПредопределенноеЗначение("Перечисление.НаправленияЭДО.Внутренний") 
		И Настройки = Неопределено Тогда 
		
		ТекстПриглашения = НСтр("ru = 'Хотите сэкономить на бумаге? Оформите документ в электронном виде.'");
		
		Форма.Элементы.ДополнительнаяИнформация.Заголовок = Новый ФорматированнаяСтрока(ТекстПриглашения,,,, "Реклама1СЭДОВнутренний"); 
		Форма.Элементы.ГруппаДополнительнаяИнформация.Видимость = ЗначениеЗаполнено(Форма.ОбъектыПечати);
		Форма.Элементы.КнопкаПечатьКоманднаяПанель.КнопкаПоУмолчанию = Истина;
		Форма.Элементы.КартинкаИнформации.Видимость = Истина;
		Форма.Элементы.КартинкаИнформации.Картинка = БиблиотекаКартинок.ЭмблемаСервиса1СЭДО;

	КонецЕсли;
	
КонецПроцедуры

Процедура РазблокироватьЗаблокированныеЭлементыФормы(Форма, СписокЭлементов) Экспорт

	Для Каждого ЗаблокированныйЭлементыФормы Из СписокЭлементов Цикл

		Форма.Элементы[ЗаблокированныйЭлементыФормы.Значение].Доступность = Истина;

	КонецЦикла;

	СписокЭлементов.Очистить();

КонецПроцедуры

Функция ДанныеТабличногоДокумента(Знач ТабличныйДокумент, Знач ТипФайла) Экспорт
	
	#Если ВебКлиент Тогда
		// Внимание! В веб-клиенте использование данного варианта недоступно.
		Возврат ИнтерфейсДокументовЭДОВызовСервера.ДанныеТабличногоДокумента(ТабличныйДокумент, ТипФайла);
	#КонецЕсли
	
	Поток = Новый ПотокВПамяти();
	ТабличныйДокумент.Записать(Поток, ТипФайла);
	Возврат Поток.ЗакрытьИПолучитьДвоичныеДанные();
	
КонецФункции

// См. ИнтерфейсДокументовЭДОКлиент.НовыеПараметрыОткрытияЭлектронногоДокумента
Функция НовыеПараметрыОткрытияЭлектронногоДокумента() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ВидДокумента", Неопределено);
	Параметры.Вставить("ДанныеКаталога", "");
	Параметры.Вставить("НовыйДокумент", Ложь);
	Параметры.Вставить("ЗначенияДополнительныхПолей", Неопределено);
	
	Возврат Параметры;
	
КонецФункции

#Область ФормированиеНеформализованныхЭДОИзПечатныхФорм

// Конструктор данных печатной формы для формирования неформализованного ЭДО
// 
// Возвращаемое значение:
//  Структура - Новые данные печатной формы для неформализованного ЭДО:
//    * ТабличныйДокумент - ТабличныйДокумент
//    * ДвоичныеДанныеФайла - Неопределено, ДвоичныеДанные - 
//    * НаименованиеФайла - Строка
//    * Расширение - Строка
//    * Уникальность - Строка
Функция НовыеДанныеПечатнойФормыДляНеформализованногоЭДО() Экспорт
	
	ДанныеПечатнойФормы = Новый Структура;
	ДанныеПечатнойФормы.Вставить("ТабличныйДокумент", Новый ТабличныйДокумент());
	ДанныеПечатнойФормы.Вставить("ДвоичныеДанныеФайла", Неопределено);
	ДанныеПечатнойФормы.Вставить("НаименованиеФайла", "");
	ДанныеПечатнойФормы.Вставить("Расширение", "");
	ДанныеПечатнойФормы.Вставить("Уникальность", "");
	
	Возврат ДанныеПечатнойФормы;
	
КонецФункции

// Новый контекст отправки печатных форм по ЭДО.
// 
// Возвращаемое значение:
//  Структура - Новый контекст отправки печатных форм по ЭДО:
// * ДокументОснование - Неопределено, ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО -
// * ДанныеПечатныхФорм - Массив Из см. НовыеДанныеПечатнойФормыДляНеформализованногоЭДО
Функция НовыйКонтекстОтправкиПечатныхФормПоЭДО() Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ДокументОснование", Неопределено);
	Контекст.Вставить("ДанныеПечатныхФорм", Новый Массив);
	
	Возврат Контекст;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаПредупрежденийКомпонентов

// Возвращает пустые настройки формирования электронного документа по объекту учета.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Направление - ПеречислениеСсылка.НаправленияЭДО - направление электронного документа.
// * НастройкиОтправки - Неопределено, См. НастройкиЭДО.НастройкиОтправки
// * НастройкиВнутреннегоЭДО - Неопределено, См. ИнтерфейсДокументовЭДО.НастройкиВнутреннегоЭДО
Функция НовыеНастройкиФормированияЭлектронногоДокументаОбъектаУчета() Экспорт
	НастройкиФормирования = Новый Структура;
	НастройкиФормирования.Вставить("Направление"); 
	НастройкиФормирования.Вставить("НастройкиОтправки");
	НастройкиФормирования.Вставить("НастройкиВнутреннегоЭДО", НастройкиЭДОКлиентСервер.НовоеОписаниеПолейКлючаНастройкиВнутреннегоЭДО());
	
	Возврат НастройкиФормирования;
КонецФункции

#КонецОбласти

#КонецОбласти