
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Валюта = Параметры.Валюта;
	Дата = Параметры.Дата;
	Контрагент = Параметры.Контрагент;
	Организация = Параметры.Организация;
	Партнер = Параметры.Партнер;
	СуммаТоваров = Параметры.СуммаТоваров;
	ИдентификаторВызывающейФормы = Параметры.ИдентификаторВызывающейФормы;
	Документ = Параметры.Документ;
	Проведен = Параметры.Проведен;
	ЭтоРасчетыСКлиентами = Параметры.ЭтоРасчетыСКлиентами;
	ТолькоПросмотр = Параметры.ТолькоПросмотр;
	
	ПартнерПрочиеОтношения = Параметры.ПартнерПрочиеОтношения;
	ПодборТолькоБезусловнойЗадолженности = Параметры.ПодборТолькоБезусловнойЗадолженности;
	ИмяВызывающегоЭлемента = Параметры.ИмяВызывающегоЭлемента;
	
	ПолучитьРасшифровкуПлатежаИзХранилища(Параметры.АдресПлатежейВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать'"));
		
		Отказ = Истина;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru = 'Все измененные данные будут потеряны. Закрыть форму?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = "Закрыть" Тогда
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаРасшифровки Из РасшифровкаПлатежа Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаРасшифровки.Сумма) Тогда
			
			ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Сумма"" в строке %НомерСтроки% списка ""Взаиморасчеты""'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", СтрокаРасшифровки.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,
				"РасшифровкаПлатежа["+(СтрокаРасшифровки.НомерСтроки-1)+"].Сумма",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если РасшифровкаПлатежа.Количество() > 0 И СуммаТоваров < РасшифровкаПлатежа.Итог("Сумма") Тогда
		ТекстСообщения = НСтр("ru = 'Сумма по строкам в табличной части превышает сумму документа %СуммаТоваров% %Валюта%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СуммаТоваров%", Формат(СуммаТоваров, "ЧДЦ=2; ЧН=0,00"));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Валюта%", Валюта);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"РасшифровкаПлатежа[0].Сумма",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОбъектыРасчетов.Форма.ПодборОбъектовРасчетов" Тогда
		ПолучитьРасшифровкуПлатежаИзХранилища(ВыбранноеЗначение.АдресПлатежейВХранилище);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасшифровкаПлатежа

&НаКлиенте
Процедура РасшифровкаПлатежаПриИзменении(Элемент)
	
	ПронумероватьТаблицу(РасшифровкаПлатежа);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТаблицы = Элементы.РасшифровкаПлатежа.ТекущиеДанные;
	
	Если НоваяСтрока И Не Копирование Тогда
		
		СуммаОстаток = СуммаТоваров - РасшифровкаПлатежа.Итог("Сумма");
		СтрокаТаблицы.Сумма = СуммаОстаток;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСуммаПриИзменении(Элемент)

	СтрокаТаблицы = Элементы.РасшифровкаПлатежа.ТекущиеДанные;
	СтрокаТаблицы.СуммаВзаиморасчетов = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОбъектРасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыМеханизма  = ОбщегоНазначенияУТКлиентСервер.ПолучитьДанныеМеханизмаИзКэшаФормы(ВладелецФормы, "Взаиморасчеты");
	СтруктураПараметров = ПараметрыМеханизма.МассивПараметров[0];
	
	ТаблицаФормы = ОбщегоНазначенияУТКлиентСервер.ТаблицаФормыЭлемента(Элемент);
	ИдентификаторСтроки = Неопределено;
	Если ТаблицаФормы <> Неопределено Тогда 
		ИдентификаторСтроки = ТаблицаФормы.ТекущаяСтрока;
	КонецЕсли;
	
	Контрагент                = ОбщегоНазначенияУТКлиентСервер.ДанныеПоПути(ВладелецФормы, СтруктураПараметров.Контрагент, ИдентификаторСтроки);
	Организация               = ОбщегоНазначенияУТКлиентСервер.ДанныеПоПути(ВладелецФормы, СтруктураПараметров.Организация);
	Валюта                    = ОбщегоНазначенияУТКлиентСервер.ДанныеПоПути(ВладелецФормы, СтруктураПараметров.ВалютаДокумента);
	ТипРасчетов               = СтруктураПараметров.ТипРасчетов;
	ПлатежиПо275ФЗ            = ОбщегоНазначенияУТКлиентСервер.ДанныеПоПути(ВладелецФормы, СтруктураПараметров.ПлатежиПо275ФЗ, , Ложь);
	
	ЭлементРасшифровкаПлатежа = Элементы.РасшифровкаПлатежа;
	Сумма                     = ЭлементРасшифровкаПлатежа.ТекущиеДанные.Сумма;
	ОбъектРасчетов            = ЭлементРасшифровкаПлатежа.ТекущиеДанные.ОбъектРасчетов;
	
	ЗначенияОтбора = Новый Структура;
	ЗначенияОтбора.Вставить("ТипРасчетов", ТипРасчетов);
	ЗначенияОтбора.Вставить("Организация", Организация);
	ЗначенияОтбора.Вставить("Контрагент",  Контрагент);
	ЗначенияОтбора.Вставить("ПлатежиПо275ФЗ" , ПлатежиПо275ФЗ);
	
	Если ТипЗнч(Контрагент) = Тип("СправочникСсылка.Организации") Тогда
		ЗначенияОтбора.Вставить("Партнер", ПредопределенноеЗначение("Справочник.Партнеры.НашеПредприятие"));
	КонецЕсли;
	
	НастройкиВыбора = Новый Структура;
	НастройкиВыбора.Вставить("ВыборОснованияПлатежа", Ложь);
	НастройкиВыбора.Вставить("РедактируемыйДокумент", Документ);
	НастройкиВыбора.Вставить("Валюта", Валюта);
	НастройкиВыбора.Вставить("Сумма", Сумма);
	НастройкиВыбора.Вставить("Отбор", ЗначенияОтбора);
	НастройкиВыбора.Вставить("ВернутьСтруктуру", Истина);
	НастройкиВыбора.Вставить("ПодборДебиторскойЗадолженности", ТипРасчетов = ПредопределенноеЗначение("Перечисление.ТипыРасчетовСПартнерами.РасчетыСКлиентом"));
	НастройкиВыбора.Вставить("ТекущееЗначение", ОбъектРасчетов);
	
	ОткрытьФорму("Справочник.ОбъектыРасчетов.ФормаВыбора", НастройкиВыбора, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОбъектРасчетовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = Элементы.РасшифровкаПлатежа.ТекущиеДанные;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыбранноеЗначение);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаВалютаВзаиморасчетовПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.РасшифровкаПлатежа.ТекущиеДанные;
	СтрокаТаблицы.СуммаВзаиморасчетов = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОбъектРасчетовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ВзаиморасчетыКлиент.ОбъектРасчетовОснованиеПлатежаАвтоПодбор(ВладелецФормы, ВладелецФормы.Элементы.УменьшенДолгСтрокой, Текст, ДанныеВыбора, СтандартнаяОбработка,, Истина);
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОбъектРасчетовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ВзаиморасчетыКлиент.ОбъектРасчетовОснованиеПлатежаАвтоПодбор(ВладелецФормы, ВладелецФормы.Элементы.УменьшенДолгСтрокой, Текст, ДанныеВыбора, СтандартнаяОбработка,, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ЗакэшироватьПараметры(ПараметрыМеханизма)
	
	ТЗ = РасшифровкаПлатежа.Выгрузить();
	АдресРасшифровкаПлатежа = ПоместитьВоВременноеХранилище(ТЗ, Новый УникальныйИдентификатор());
	
	Для Каждого СтруктураПараметров Из ПараметрыМеханизма.МассивПараметров Цикл
		Если ЗначениеЗаполнено(СтруктураПараметров.ПутьКДаннымТЧРасшифровкаПлатежа) Тогда
			СтруктураПараметров.АдресРасшифровкаПлатежа = АдресРасшифровкаПлатежа;
			СтруктураПараметров.Ссылка = Документ;
			СтруктураПараметров.Контрагент = Контрагент;
			СтруктураПараметров.Организация = Организация;
			СтруктураПараметров.ВалютаДокумента = Валюта;
			СтруктураПараметров.СуммаДокумента = СуммаТоваров;
			СтруктураПараметров.Дата = Дата;
			СтруктураПараметров.ИдентификаторПлатежа = "";
			СтруктураПараметров.ТипРасчетов = ?(ТипЗнч(Документ)=Тип("ДокументСсылка.ВозвратТоваровОтКлиента"),
												Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом,
												Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком);
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияУТ.СохранитьДанныеМеханизмаВКэшФормы(ЭтаФорма, "Взаиморасчеты", ПараметрыМеханизма);
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОстаткам(Команда)
	
	ПараметрыМеханизма = ОбщегоНазначенияУТКлиентСервер.ПолучитьДанныеМеханизмаИзКэшаФормы(ВладелецФормы, "Взаиморасчеты");
	ЗакэшироватьПараметры(ПараметрыМеханизма);
	
	ВзаиморасчетыКлиент.ПодборВРасшифровкуПлатежа(ЭтаФорма, ИмяВызывающегоЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		Закрыть(ПоместитьРасшифровкуПлатежаВХранилище());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьРасшифровкуПлатежаИзХранилища(АдресПлатежейВХранилище)
	
	РасшифровкаПлатежа.Очистить();
	
	ВременнаяТаблица = ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище);
	
	Для Каждого СтрокаРасшифровки Из ВременнаяТаблица Цикл
		НоваяСтрока = РасшифровкаПлатежа.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРасшифровки);
	КонецЦикла;
	
	ПронумероватьТаблицу(РасшифровкаПлатежа);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьРасшифровкуПлатежаВХранилище()
	
	ВременнаяТаблица = РасшифровкаПлатежа.Выгрузить(,"ОбъектРасчетов, Сумма, ВалютаВзаиморасчетов, СуммаВзаиморасчетов");
	СуммаКомпенсации = СуммаТоваров - РасшифровкаПлатежа.Итог("Сумма");
	Если СуммаКомпенсации > 0 Тогда
		НоваяСтрока = ВременнаяТаблица.Добавить();
		НоваяСтрока.Сумма = СуммаКомпенсации;
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(ВременнаяТаблица, ИдентификаторВызывающейФормы);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПронумероватьТаблицу(РасшифровкаПлатежа)
	
	НомерСтроки = 1;
	Для каждого СтрокаРасшифровки Из РасшифровкаПлатежа Цикл
		СтрокаРасшифровки.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
