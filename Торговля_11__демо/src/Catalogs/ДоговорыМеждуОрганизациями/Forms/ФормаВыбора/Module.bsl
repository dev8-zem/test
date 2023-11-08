
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьНедоступныеОтборыИзПараметров(Параметры.Отбор, Параметры.ОтборОрганизацийПоИли);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Процедура устанавливает отборы, переданные в структуре. Отборы недоступны для изменения.
//
// Параметры:
//	СтруктураОтбора - Структура - Ключ: имя поля компоновки данных, Значение: значение отбора.
//
&НаСервере
Процедура УстановитьНедоступныеОтборыИзПараметров(СтруктураОтбора, ОтборОрганизацийПоИЛИ)
	
	Если СтруктураОтбора.Свойство("Владелец") Тогда
		СтруктураОтбора.Удалить("Владелец");
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("Организация")
		И СтруктураОтбора.Свойство("ОрганизацияПолучатель") Тогда
		
		Если (СтруктураОтбора.Организация = СтруктураОтбора.ОрганизацияПолучатель
				И ТипЗнч(СтруктураОтбора.Организация) = Тип("СправочникСсылка.Организации")) Тогда
			// Устанавливаемые отборы по организациям равны, а значит необходимо применить к ним условие "ИЛИ".
			ОтборОрганизаций = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
								Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы,
								"ОтборОрганизаций",
								ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборОрганизаций,
																"Организация",
																СтруктураОтбора.Организация);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборОрганизаций,
																"ОрганизацияПолучатель",
																СтруктураОтбора.Организация);
			
			СтруктураОтбора.Удалить("Организация");
			СтруктураОтбора.Удалить("ОрганизацияПолучатель");
			
		ИначеЕсли ОтборОрганизацийПоИЛИ Тогда
			
			МассивОрганизации = Новый СписокЗначений;
			МассивОрганизации.Добавить(СтруктураОтбора.Организация);
			МассивОрганизации.Добавить(СтруктураОтбора.ОрганизацияПолучатель);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
				"Организация",
				МассивОрганизации,
				ВидСравненияКомпоновкиДанных.ВСписке);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
				"ОрганизацияПолучатель",
				МассивОрганизации,
				ВидСравненияКомпоновкиДанных.ВСписке);
				
			СтруктураОтбора.Удалить("Организация");
			СтруктураОтбора.Удалить("ОрганизацияПолучатель");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ЭлементОтбора Из СтруктураОтбора Цикл
		
		Если ЭлементОтбора.Ключ = "Контрагент"
			Или ЭлементОтбора.Ключ = "Партнер" Тогда
			
			Продолжить;
			
		КонецЕсли;
				
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																				ЭлементОтбора.Ключ,
																				ЭлементОтбора.Значение);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
