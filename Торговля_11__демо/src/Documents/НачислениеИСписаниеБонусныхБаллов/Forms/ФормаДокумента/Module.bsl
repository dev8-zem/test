
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ПриСозданииЧтенииНаСервере();

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец Обработчик механизма "ДатыЗапретаИзменения"
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользоватьПравилоНачисления = 1 И Не ЗначениеЗаполнено(Объект.ПравилоНачисления) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Правило начисления"" не заполнено.'"),,"Объект.ПравилоНачисления",, Отказ);
		
	КонецЕсли;
	
	Если ИспользоватьПериодДействия = 2 И Не ЗначениеЗаполнено(Объект.ДатаОкончанияСрокаДействия) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Дата окончания срока действия"" не заполнено.'"),,"Объект.ДатаОкончанияСрокаДействия",, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ВариантРучногоРасчета = 1 Тогда
		ТекущийОбъект.ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Начисление;
	ИначеЕсли ВариантРучногоРасчета = 2 Тогда
		ТекущийОбъект.ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Списание;
	Иначе
		ТекущийОбъект.ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.ПустаяСсылка();
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПравилоНачисленияПриИзменении(Элемент)
	ПравилоНачисленияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПериодДействияПриИзменении(Элемент)
	
	Если ИспользоватьПериодДействия = 1 Тогда
		Объект.КоличествоПериодовДействия = 1;
	Иначе
		Объект.КоличествоПериодовДействия = 0;
	КонецЕсли;
	
	Если ИспользоватьПериодДействия <> 2 Тогда
		Объект.ДатаОкончанияСрокаДействия = Неопределено;
	КонецЕсли;
	
	ИзменитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтсрочкуНачалаДействияПриИзменении(Элемент)
	
	Объект.КоличествоПериодовОтсрочкиНачалаДействия = ИспользоватьОтсрочкуНачалаДействия;
	
	ИзменитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПравилоНачисленияПриИзменении(Элемент)
	
	ВариантРучногоРасчета = 0;
	
	Объект.ПравилоНачисления = ПредопределенноеЗначение("Справочник.ПравилаНачисленияИСписанияБонусныхБаллов.ПустаяСсылка");
	
	ПравилоНачисленияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПравилаПриИзменении()
	
	Списание = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Списание");
	Начисление = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Начисление");
	
	Если (Объект.ВидПравила = Списание) Тогда
		
		ИспользоватьПериодДействия                      = 0;
		Объект.КоличествоПериодовДействия               = 0;
		ИспользоватьОтсрочкуНачалаДействия              = 0;
		Объект.КоличествоПериодовОтсрочкиНачалаДействия = 0;
		Объект.ДатаОкончанияСрокаДействия               = Неопределено;
		
	КонецЕсли;
	
	Элементы.Начисления.Видимость = (Объект.ВидПравила = Начисление);
	Элементы.Списания.Видимость   = (Объект.ВидПравила = Списание);
	
	Элементы.ГруппаСрокиДействия.Видимость = (Объект.ВидПравила = Начисление);
	
	ИзменитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПравилоНачисленияРучноеНачислениеПриИзменении(Элемент)
	
	Объект.ПравилоНачисления = ПредопределенноеЗначение("Справочник.ПравилаНачисленияИСписанияБонусныхБаллов.ПустаяСсылка");
	ИспользоватьПравилоНачисления = 0;
	
	ПравилоНачисленияПриИзмененииНаСервере();
	
	Объект.ВидПравила = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Начисление");
	
	ВидПравилаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПравилоНачисленияРучноеСписаниеПриИзменении(Элемент)
	
	Объект.ПравилоНачисления = ПредопределенноеЗначение("Справочник.ПравилаНачисленияИСписанияБонусныхБаллов.ПустаяСсылка");
	ИспользоватьПравилоНачисления = 0;
	
	ПравилоНачисленияПриИзмененииНаСервере();
	
	Объект.ВидПравила = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Списание");
	
	ВидПравилаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДействияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтсрочкиНачалаДействияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияСрокаДействияПриИзменении(Элемент)
	
	Если Не ДатаОкончанияСрокаДействияВведенаКорректно() Тогда
		Объект.ДатаОкончанияСрокаДействия = '0001-01-01';
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияСрокаДействияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ДатаОкончанияСрокаДействияВведенаКорректно(ВыбранноеЗначение) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьДоступность(Форма)
	
	Начисление = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Начисление");
	Списание = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Списание");
	
	Если Форма.ИспользоватьПравилоНачисления = 1 Тогда
		Форма.Элементы.Начисления.Видимость = (Форма.ВидПравила = Начисление);
		Форма.Элементы.Списания.Видимость   = (Форма.ВидПравила = Списание);
		
		Форма.Элементы.ГруппаСрокиДействия.Видимость = (Форма.ВидПравила = Начисление);
	Иначе
		Форма.Элементы.Начисления.Видимость = (Форма.Объект.ВидПравила = Начисление);
		Форма.Элементы.Списания.Видимость   = (Форма.Объект.ВидПравила = Списание);
		
		Форма.Элементы.ГруппаСрокиДействия.Видимость = (Форма.Объект.ВидПравила = Начисление);
	КонецЕсли;
	
	Форма.Элементы.ПериодДействия.Доступность             = (Форма.ИспользоватьПериодДействия = 1);
	Форма.Элементы.КоличествоПериодовДействия.Доступность = (Форма.ИспользоватьПериодДействия = 1);
	
	Форма.Элементы.ДатаОкончанияСрокаДействия.Доступность = (Форма.ИспользоватьПериодДействия = 2);
	
	Форма.Элементы.КоличествоПериодовОтсрочкиНачалаДействия.Доступность = (Форма.ИспользоватьОтсрочкуНачалаДействия = 1);
	Форма.Элементы.ПериодОтсрочкиНачалаДействия.Доступность             = (Форма.ИспользоватьОтсрочкуНачалаДействия = 1);
	
	Форма.Элементы.ПравилоНачисления.Доступность           = (Форма.ИспользоватьПравилоНачисления = 1);
	Форма.Элементы.ПравилоНачисленияВидПравила.Доступность = (Форма.ИспользоватьПравилоНачисления = 1);
	
	Форма.Элементы.НачисленияЗаполнить.Видимость = (Форма.ИспользоватьПравилоНачисления = 1) И ЗначениеЗаполнено(Форма.Объект.ПравилоНачисления);
	Форма.Элементы.СписанияЗаполнить.Видимость   = (Форма.ИспользоватьПравилоНачисления = 1) И ЗначениеЗаполнено(Форма.Объект.ПравилоНачисления);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНастройкиФормы(Форма)
	
	Форма.ИспользоватьПравилоНачисления      = ?(ЗначениеЗаполнено(Форма.Объект.ПравилоНачисления), 1, 0);
	Форма.ИспользоватьОтсрочкуНачалаДействия = ?(Форма.Объект.КоличествоПериодовОтсрочкиНачалаДействия > 0, 1, 0);
	
	Начисление = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Начисление");
	Списание = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Списание");
	
	Если Форма.ИспользоватьПравилоНачисления = 0 Тогда
		Если Форма.Объект.ВидПравила = Начисление Тогда
			Форма.ВариантРучногоРасчета = 1;
		ИначеЕсли Форма.Объект.ВидПравила = Списание Тогда
			Форма.ВариантРучногоРасчета = 2;
		Иначе
			Форма.ВариантРучногоРасчета         = 0;
			Форма.ИспользоватьПравилоНачисления = 1;
		КонецЕсли;
	Иначе
		Форма.ВариантРучногоРасчета = 0;
	КонецЕсли;
	
	Если Форма.Объект.КоличествоПериодовДействия > 0 Тогда
		Форма.ИспользоватьПериодДействия = 1;
	ИначеЕсли ЗначениеЗаполнено(Форма.Объект.ДатаОкончанияСрокаДействия) Тогда
		Форма.ИспользоватьПериодДействия = 2;
	Иначе
		Форма.ИспользоватьПериодДействия = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПравилоНачисленияПриИзмененииНаСервере()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПравилаНачисленияИСписанияБонусныхБаллов.ПериодДействия                           КАК ПериодДействия,
	|	ПравилаНачисленияИСписанияБонусныхБаллов.КоличествоПериодовДействия               КАК КоличествоПериодовДействия,
	|	ПравилаНачисленияИСписанияБонусныхБаллов.КоличествоПериодовОтсрочкиНачалаДействия КАК КоличествоПериодовОтсрочкиНачалаДействия,
	|	ПравилаНачисленияИСписанияБонусныхБаллов.ПериодОтсрочкиНачалаДействия             КАК ПериодОтсрочкиНачалаДействия,
	|	ПравилаНачисленияИСписанияБонусныхБаллов.ВидПравила                               КАК ВидПравила
	|ИЗ
	|	Справочник.ПравилаНачисленияИСписанияБонусныхБаллов КАК ПравилаНачисленияИСписанияБонусныхБаллов
	|ГДЕ
	|	ПравилаНачисленияИСписанияБонусныхБаллов.Ссылка = &ПравилоНачисления
	|");
	
	Запрос.УстановитьПараметр("ПравилоНачисления", Объект.ПравилоНачисления);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ВидПравила = Выборка.ВидПравила;
		
		Объект.КоличествоПериодовДействия               = Выборка.КоличествоПериодовДействия;
		Объект.КоличествоПериодовОтсрочкиНачалаДействия = Выборка.КоличествоПериодовОтсрочкиНачалаДействия;
		Объект.ПериодОтсрочкиНачалаДействия             = Выборка.ПериодОтсрочкиНачалаДействия;
		Объект.ПериодДействия                           = Выборка.ПериодДействия;
		Объект.ДатаОкончанияСрокаДействия               = Неопределено;
		
	Иначе
		
		ВидПравила = Неопределено;
		
		Если (Объект.ВидПравила = ПредопределенноеЗначение("Перечисление.ВидыПравилНачисленияБонусныхБаллов.Списание")) Тогда
			
			ИспользоватьПериодДействия                      = 0;
			Объект.КоличествоПериодовДействия               = 0;
			ИспользоватьОтсрочкуНачалаДействия              = 0;
			Объект.КоличествоПериодовОтсрочкиНачалаДействия = 0;
			Объект.ДатаОкончанияСрокаДействия               = Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИзменитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Объект.Начисление.Очистить();
	Объект.Списание.Очистить();
	
	ВидПравила = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ПравилоНачисления, "ВидПравила");
	
	ТаблицаНачислениеИСписание = БонусныеБаллыСервер.ТаблицаНачислениеИСписание(Объект.ПравилоНачисления, Объект.Дата);
	Для Каждого СтрокаТЧ Из ТаблицаНачислениеИСписание Цикл
		
		Если ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Начисление Тогда
			НоваяСтрока = Объект.Начисление.Добавить();
		Иначе
			НоваяСтрока = Объект.Списание.Добавить();
		КонецЕсли;
		
		НоваяСтрока.Партнер = СтрокаТЧ.Партнер;
		НоваяСтрока.Баллы = СтрокаТЧ.СуммаНачисления;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ВидПравила = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ПравилоНачисления, "ВидПравила");
	
	ЗаполнитьНастройкиФормы(ЭтаФорма);
	
	ИзменитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДатаСеанса()
	
	Возврат ТекущаяДатаСеанса();
	
КонецФункции

&НаКлиенте
Функция ДатаОкончанияСрокаДействияВведенаКорректно(ВводимаяДатаОкончания = Неопределено)
	
	Если ВводимаяДатаОкончания = Неопределено Тогда
		ВводимаяДатаОкончания = Объект.ДатаОкончанияСрокаДействия;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		ДатаМинимум = НачалоДня(ДатаСеанса());
	Иначе
		ДатаМинимум = НачалоДня(Объект.Дата);
	КонецЕсли;
	
	Если ВводимаяДатаОкончания >= ДатаМинимум Тогда
		Возврат Истина;
	КонецЕсли;
	
	ШаблонТекстаПредупреждения = НСтр("ru = 'Дата окончания срока действия не может быть меньше %1.'");
	ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаПредупреждения, Формат(ДатаМинимум, "ДЛФ=D"));
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

