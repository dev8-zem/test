#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ЦельИспользования = Параметры.ЦельИспользования;
	
	Если ЗначениеЗаполнено(Параметры.ДанныеДокументов) Тогда
		Для Каждого СтрокаКоллекции Из Параметры.ДанныеДокументов Цикл
			Если СтрокаКоллекции.ТипДокумента = Справочники.КлассификаторНСИЗЕРНО.ДокументНаПартиюДекларацияСоответствия Тогда
				УказатьДекларациюСоответствия = Истина;
				ДатаДекларации = СтрокаКоллекции.Дата;
				НомерДекларации = СтрокаКоллекции.Номер;
				СрокДействияДекларации = СтрокаКоллекции.СрокДействия;
			ИначеЕсли СтрокаКоллекции.ТипДокумента = Справочники.КлассификаторНСИЗЕРНО.ДокументНаПартиюФитосанитарныйСертификат Тогда
				УказатьФитосанитарныйСертификат = Истина;
				ДатаФитоСертификата = СтрокаКоллекции.Дата;
				НомерФитоСертификата = СтрокаКоллекции.Номер;
			ИначеЕсли СтрокаКоллекции.ТипДокумента = Справочники.КлассификаторНСИЗЕРНО.ДокументНаПартиюВетеринарныйСертификат Тогда
				УказатьВСД = Истина;
				ДатаВСД = СтрокаКоллекции.Дата;
				НомерВСД = СтрокаКоллекции.Номер;
				ЗаполнитьЗначенияСвойств(
					ЭтотОбъект,
					СтрокаКоллекции,
					"ИдентификаторПроисхожденияВЕТИС, ИдентификаторПроисхожденияВЕТИССтрокой, ВидДокументаВСД, СерияВСД");
			Иначе
				ВызватьИсключение(СтрШаблон(
					НСтр("ru = 'Неизвестный вид документа сертификации %1.'"), СтрокаКоллекции.ТипДокумента));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ТолькоПросмотр  = Параметры.ТолькоПросмотр;
	
	ПриСозданииЧтенииНаСервере();
	
	СброситьРазмерыИПоложениеОкна();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не УказатьВСД Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерВСД");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВСД");
		МассивНепроверяемыхРеквизитов.Добавить("ВидДокументаВСД");
		МассивНепроверяемыхРеквизитов.Добавить("СерияВСД");
		МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторПроисхожденияВЕТИССтрокой");
	ИначеЕсли ВидДокументаВСД <> "ELECTRONIC" Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторПроисхожденияВЕТИССтрокой");
	КонецЕсли;
	
	Если Не УказатьДекларациюСоответствия Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерДекларации");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаДекларации");
		МассивНепроверяемыхРеквизитов.Добавить("СрокДействияДекларации");
	КонецЕсли;
	
	Если Не УказатьФитосанитарныйСертификат Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерФитоСертификата");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаФитоСертификата");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УказатьВСДПриИзменении(Элемент)
	Элементы.ГруппаВСД.Видимость = УказатьВСД;
КонецПроцедуры

&НаКлиенте
Процедура УказатьДекларациюСоответствияПриИзменении(Элемент)
	Элементы.ГруппаДекларацияСоответствия.Видимость = УказатьДекларациюСоответствия;
КонецПроцедуры

&НаКлиенте
Процедура УказатьФитосанитарныйСертификатПриИзменении(Элемент)
	Элементы.ГруппаФитосанитарныйСертификат.Видимость = УказатьФитосанитарныйСертификат;
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторПроисхожденияВЕТИССтрокойПриИзменении(Элемент)
	
	ИдентификаторПроисхожденияВЕТИССтрокой = ИнтеграцияИСКлиентСервер.ПреобразоватьИдентификаторВСД(ИдентификаторПроисхожденияВЕТИССтрокой);
	
	Если ЗначениеЗаполнено(ИдентификаторПроисхожденияВЕТИССтрокой)
		И Не СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(ИдентификаторПроисхожденияВЕТИССтрокой) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный идентификатор ВСД'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаВСДПриИзменении(Элемент)
	
	Элементы.ИдентификаторПроисхожденияВЕТИССтрокой.Видимость = ВидДокументаВСД = "ELECTRONIC";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		Результат = Новый Массив;
		
		Если УказатьДекларациюСоответствия Тогда
			СтрокаДанных = ИнтеграцияЗЕРНОКлиентСервер.ИнициализироватьСтруктуруДанныеСертификации();
			СтрокаДанных.ТипДокумента = ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.ДокументНаПартиюДекларацияСоответствия");
			СтрокаДанных.Номер        = НомерДекларации;
			СтрокаДанных.Дата         = ДатаДекларации;
			СтрокаДанных.СрокДействия = СрокДействияДекларации;
			Результат.Добавить(СтрокаДанных);
		КонецЕсли;
		
		Если УказатьФитосанитарныйСертификат Тогда
			СтрокаДанных = ИнтеграцияЗЕРНОКлиентСервер.ИнициализироватьСтруктуруДанныеСертификации();
			СтрокаДанных.ТипДокумента = ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.ДокументНаПартиюФитосанитарныйСертификат");
			СтрокаДанных.Номер = НомерФитоСертификата;
			СтрокаДанных.Дата  = ДатаФитоСертификата;
			Результат.Добавить(СтрокаДанных);
		КонецЕсли;
		
		Если УказатьВСД Тогда
			СтрокаДанных = ИнтеграцияЗЕРНОКлиентСервер.ИнициализироватьСтруктуруДанныеСертификации();
			СтрокаДанных.ТипДокумента = ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.ДокументНаПартиюВетеринарныйСертификат");
			СтрокаДанных.Номер = НомерВСД;
			СтрокаДанных.Дата  = ДатаВСД;
			ЗаполнитьЗначенияСвойств(
					СтрокаДанных,
					ЭтотОбъект,
					"ИдентификаторПроисхожденияВЕТИС, ИдентификаторПроисхожденияВЕТИССтрокой, ВидДокументаВСД, СерияВСД");
			Результат.Добавить(СтрокаДанных);
		КонецЕсли;
		
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Если ТолькоПросмотр Тогда
		
		Элементы.ДокументыСертификацииСохранить.Видимость      = Ложь;
		Элементы.ДокументыСертификацииОтмена.КнопкаПоУмолчанию = Истина;
		Элементы.ДокументыСертификацииОтмена.Заголовок         = НСтр("ru = 'Закрыть'");
		
		Элементы.ГруппаРеквизитыДокументов.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	ВозможноУказаниеФитоСертификата = Не ЗначениеЗаполнено(ЦельИспользования) Или ЦельИспользования = Справочники.КлассификаторНСИЗЕРНО.ЦельИспользованияПартииПищевые;
	ВозможноУказаниеВСД             = Не ЗначениеЗаполнено(ЦельИспользования) Или ЦельИспользования = Справочники.КлассификаторНСИЗЕРНО.ЦельИспользованияПартииКормовые;
	
	Элементы.ГруппаДекларацияСоответствия.Видимость = УказатьДекларациюСоответствия;
	
	Элементы.УказатьФитосанитарныйСертификат.Видимость = ВозможноУказаниеФитоСертификата Или УказатьФитосанитарныйСертификат;
	Элементы.ГруппаФитосанитарныйСертификат.Видимость  = УказатьФитосанитарныйСертификат;
	
	Элементы.УказатьВСД.Видимость = ВозможноУказаниеВСД Или УказатьВСД;
	Элементы.ГруппаВСД.Видимость  = УказатьВСД;
	
	Если УказатьВСД Тогда
		Элементы.ИдентификаторПроисхожденияВЕТИССтрокой.Видимость = ВидДокументаВСД = "ELECTRONIC";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.ДокументыСертификацииЗЕРНО", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти
