#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СформироватьЗаголовокРеквизиты();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Закрыть(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИспользованиеОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовУТКлиент.ПроверитьИспользованиеОбъекта(ЭтаФорма, ПараметрыОбработчикаОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	ЗапретРедактированияРеквизитовОбъектовУТКлиент.ПроверитьВыполнениеЗадания(
		ЭтаФорма,
		ФормаДлительнойОперации,
		ПараметрыОбработчикаОжидания);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовокРеквизиты()
	
	ТекстПартнер = ПартнерыИКонтрагенты.ЗаголовокРеквизитаПартнерВЗависимостиОтХозяйственнойОперации(Параметры.Объект.ХозяйственнаяОперация);
	
	ИспользоватьВариантОформленияЗакупок = ПолучитьФункциональнуюОпцию("ИспользоватьТоварыВПутиОтПоставщиков")
											Или ПолучитьФункциональнуюОпцию("ИспользоватьНеотфактурованныеПоставки");
	
	Если ИспользоватьВариантОформленияЗакупок Тогда
		ТекстЗаголовок = НСтр("ru = 'Тип взаимоотношений, %1, Контрагент, Организация,
			|Порядок оплаты, Валюта, Детализация расчетов, Оформление раздельной закупки'");
	Иначе
		ТекстЗаголовок = НСтр("ru = 'Тип взаимоотношений, %1, Контрагент, Организация,
			|Порядок оплаты, Валюта, Детализация расчетов'");
	КонецЕсли;
	
	ИспользоватьПриемкуТоваровНаСклад	= (Параметры.Объект.ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
												Или Параметры.Объект.ТипДоговора = Перечисления.ТипыДоговоров.ВвозИзЕАЭС
												Или Параметры.Объект.ТипДоговора = Перечисления.ТипыДоговоров.Импорт
												Или Параметры.Объект.ТипДоговора = Перечисления.ТипыДоговоров.СПоклажедателем)
											И (ИспользоватьВариантОформленияЗакупок
												Или ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриПоступлении"));
	
	ТекстЗаголовок = ТекстЗаголовок + ?(ИспользоватьПриемкуТоваровНаСклад,
										"," + Символы.НПП + НСтр("ru = 'Приемка товаров на склад'"),
										"");
	
	Элементы.ЗаголовокРеквизиты.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовок, ТекстПартнер);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
