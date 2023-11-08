
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ПараметрКоманды") Тогда
		ВызватьИсключение НСтр("ru='Открытие отчета предусмотрено только из документов.'");
	КонецЕсли;
	
	ДокументСсылка = Параметры.ПараметрКоманды;
	
	Сформировать();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Сформировать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Параметры:
// 	ДеревоСкидок - см. СкидкиНаценкиСервер.Рассчитать
// 	МассивСкидок - Массив из СтрокаДереваЗначений - Массив из строк дерева скидок/наценок, содержит в том числе:
// 		* Ссылка - СправочникСсылка.СкидкиНаценки - 
&НаСервере
Процедура РекурсивныйОбходСкидок(ДеревоСкидок, МассивСкидок)
	
	Для Каждого СтрокаДерева Из ДеревоСкидок.Строки Цикл
		
		Если СтрокаДерева.ЭтоГруппа Тогда
			
			РекурсивныйОбходСкидок(СтрокаДерева, МассивСкидок);
			
		Иначе
			
			МассивСкидок.Добавить(СтрокаДерева);
		
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура Сформировать()
	
	ТабличныйДокумент.Очистить();
	
	ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	
	Макет = Отчеты.ПримененныеСкидкиВДокументе.ПолучитьМакет("Макет");
	
	СтруктураПараметры = СкидкиНаценкиЗаполнениеСервер.НовыйПараметрыРассчитать();
	СтруктураПараметры.ПрименятьКОбъекту				 = Ложь;
	СтруктураПараметры.ТолькоПредварительныйРасчет		 = Ложь;
	СтруктураПараметры.ВосстанавливатьУправляемыеСкидки	 = Истина;
	СтруктураПараметры.УправляемыеСкидки				 = УправляемыеСкидки;
	
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.АктВыполненныхРабот") Тогда
		ИмяТЧ = "Услуги";
	Иначе
		ИмяТЧ = "Товары";
	КонецЕсли;
	
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.РеализацияТоваровУслуг") Тогда
		
		ТабличнаяЧастьДокумента = ДокументОбъект.Товары.Выгрузить();
		ТабличнаяЧастьДокумента.Свернуть("ЗаказКлиента");
		
		Если ЗначениеЗаполнено(ДокументОбъект.ЗаказКлиента)
			ИЛИ (ТабличнаяЧастьДокумента.Количество() > 0 И ЗначениеЗаполнено(ТабличнаяЧастьДокумента[0].ЗаказКлиента)) Тогда
			ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("РеализацияПоЗаказуКлиента"));
			Возврат;
		КонецЕсли;
		
		СтруктураПараметры.РеализацияСверхЗаказа = ДокументОбъект.РеализацияПоЗаказам;
		
	КонецЕсли;
	
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.АктВыполненныхРабот") Тогда
		
		ТабличнаяЧастьДокумента = ДокументОбъект.Услуги.Выгрузить();
		ТабличнаяЧастьДокумента.Свернуть("ЗаказКлиента");
		
		Если ЗначениеЗаполнено(ДокументОбъект.ЗаказКлиента)
			ИЛИ (ТабличнаяЧастьДокумента.Количество() > 0 И ЗначениеЗаполнено(ТабличнаяЧастьДокумента[0].ЗаказКлиента)) Тогда
			ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("АктВыполненныхРаботПоЗаказуКлиента"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ИспользованиеХарактеристикНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	
	ПримененныеСкидки = СкидкиНаценкиЗаполнениеСервер.Рассчитать(ДокументОбъект, СтруктураПараметры);
	
	МассивСкидок = Новый Массив; // см. РекурсивныйОбходСкидок.МассивСкидок
	РекурсивныйОбходСкидок(ПримененныеСкидки.ДеревоСкидок, МассивСкидок);
	
	ОбластьШапкаНоменклатура              = Макет.ПолучитьОбласть("Шапка|Номенклатура");
	ОбластьШапкаХарактеристика            = Макет.ПолучитьОбласть("Шапка|Характеристика");
	ОбластьШапкаСкидкаНаценка             = Макет.ПолучитьОбласть("Шапка|СкидкаНаценка");
	ОбластьШапкаУсловие                   = Макет.ПолучитьОбласть("Шапка|Условие");
	ОбластьШапкаИтого                     = Макет.ПолучитьОбласть("Шапка|Итого");
	
	ОбластьСтрокаНоменклатура             = Макет.ПолучитьОбласть("Строка|Номенклатура");
	ОбластьСтрокаХарактеристика           = Макет.ПолучитьОбласть("Строка|Характеристика");
	ОбластьСтрокаСкидкаНаценка            = Макет.ПолучитьОбласть("Строка|СкидкаНаценка");
	ОбластьСтрокаУсловиеВыполнено         = Макет.ПолучитьОбласть("Строка|УсловиеВыполнено");
	ОбластьСтрокаУсловиеНеВыполнено       = Макет.ПолучитьОбласть("Строка|УсловиеНеВыполнено");
	ОбластьСтрокаСкидкаНаценкаЗачеркнута  = Макет.ПолучитьОбласть("Строка|СкидкаНаценкаЗачеркнута");
	ОбластьСтрокаСкидкаНаценкаНеНазначена = Макет.ПолучитьОбласть("Строка|СкидкаНаценкаНеНазначена");
	ОбластьСтрокаСкидкаНаценкаНазначена   = Макет.ПолучитьОбласть("Строка|СкидкаНаценкаНазначена");
	ОбластьСтрокаСкидкаНаценкаСкидкаНаценкаНеДействуетПоСовместномуПрименению = Макет.ПолучитьОбласть("Строка|СкидкаНаценкаНеДействуетПоСовместномуПрименению");
	ОбластьСтрокаИтого                    = Макет.ПолучитьОбласть("Строка|Итого");
	
	ОбластьИтогоНоменклатура              = Макет.ПолучитьОбласть("СтрокаИтого|Номенклатура");
	ОбластьИтогоХарактеристика            = Макет.ПолучитьОбласть("СтрокаИтого|Характеристика");
	ОбластьИтогоСкидкаНаценка             = Макет.ПолучитьОбласть("СтрокаИтого|СкидкаНаценка");
	ОбластьИтогоУсловие                   = Макет.ПолучитьОбласть("СтрокаИтого|Условие");
	ОбластьИтогоСкидкаНаценкаЗачеркнута   = Макет.ПолучитьОбласть("СтрокаИтого|СкидкаНаценкаЗачеркнута");
	ОбластьИтогоСкидкаНаценкаНеНазначена  = Макет.ПолучитьОбласть("СтрокаИтого|СкидкаНаценкаНеНазначена");
	ОбластьИтогоИтого                     = Макет.ПолучитьОбласть("СтрокаИтого|Итого");
	
	ОбластьЛегенда                        = Макет.ПолучитьОбласть("Легенда|Номенклатура");
	
	// Шапка отчета
	ТабличныйДокумент.Вывести(ОбластьШапкаНоменклатура);
	Если ИспользованиеХарактеристикНоменклатуры Тогда
		ТабличныйДокумент.Присоединить(ОбластьШапкаХарактеристика);
	КонецЕсли;
	Для каждого СтрокаДерева Из МассивСкидок Цикл
		
		ОбластьШапкаСкидкаНаценка.Параметры.СкидкаНаценка = СтрокаДерева.Ссылка;
		ТабличныйДокумент.Присоединить(ОбластьШапкаСкидкаНаценка);
		
		ТабличныйДокумент.НачатьГруппуКолонок("Условия", Ложь);
		Для каждого СтрокаУсловие Из СтрокаДерева.ПараметрыУсловий.ТаблицаУсловий Цикл
			ОбластьШапкаУсловие.Параметры.Условие = СтрокаУсловие.УсловиеПредоставления;
			ТабличныйДокумент.Присоединить(ОбластьШапкаУсловие);
		КонецЦикла;
		ТабличныйДокумент.ЗакончитьГруппуКолонок();
		
	КонецЦикла;
	ТабличныйДокумент.Присоединить(ОбластьШапкаИтого);
	
	СоответствиеВыполненияУсловий = Новый Соответствие;
	
	ДокументОбъектТабличнаяЧасть = ДокументОбъект[ИмяТЧ]; // ДокументТабличнаяЧасть.РеализацияТоваровУслуг.Товары - указано для типизации
	
	Для каждого СтрокаТовары Из ДокументОбъектТабличнаяЧасть Цикл
		
		ОбластьСтрокаНоменклатура.Параметры.Номенклатура = СтрокаТовары.Номенклатура;
		ОбластьСтрокаНоменклатура.Параметры.НомерСтроки  = СтрокаТовары.НомерСтроки;
		ТабличныйДокумент.Вывести(ОбластьСтрокаНоменклатура);
		Если ИспользованиеХарактеристикНоменклатуры Тогда
			ОбластьСтрокаХарактеристика.Параметры.Характеристика = СтрокаТовары.Характеристика;
			ТабличныйДокумент.Присоединить(ОбластьСтрокаХарактеристика);
		КонецЕсли;
		
		Для каждого СтрокаДерева Из МассивСкидок Цикл
			
			// Условия скидки
			ВсеУсловияВыполнены = Истина;
			Для каждого СтрокаУсловие Из СтрокаДерева.ПараметрыУсловий.ТаблицаУсловий Цикл
				
				Если СтрокаУсловие.ОбластьОграничения = Перечисления.ВариантыОбластейОграниченияСкидокНаценок.ВСтроке Тогда
					НайденныеСтрокиТаблицыПроверкиУсловий = СтрокаДерева.ПараметрыУсловий.УсловияПоСтроке.ТаблицаПроверкиУсловий.Найти(СтрокаТовары.КлючСвязи, "КлючСвязи");
					Если НайденныеСтрокиТаблицыПроверкиУсловий <> Неопределено Тогда
						СоответствиеУсловийКолонкамТаблицыПроверкиУсловий = СтрокаДерева.ПараметрыУсловий.УсловияПоСтроке.СоответствиеУсловийКолонкамТаблицыПроверкиУсловий; // Соответствие
						НазваниеКолонки = СоответствиеУсловийКолонкамТаблицыПроверкиУсловий.Получить(СтрокаУсловие.УсловиеПредоставления);
						Если НазваниеКолонки <> Неопределено Тогда
							УсловиеВыполнено = НайденныеСтрокиТаблицыПроверкиУсловий[НазваниеКолонки];
						КонецЕсли;
					Иначе
						УсловиеВыполнено = Ложь;
					КонецЕсли;
				Иначе
					УсловиеВыполнено = СтрокаУсловие.Выполнено;
				КонецЕсли;
				СоответствиеВыполненияУсловий.Вставить(СтрокаУсловие.УсловиеПредоставления, УсловиеВыполнено);
				
				Если Не УсловиеВыполнено Тогда
					ВсеУсловияВыполнены = Ложь;
				КонецЕсли;
				
			КонецЦикла;
			
			// Сумма скидки
			НайденнаяСтрока = СтрокаДерева.РезультатРасчета.Найти(СтрокаТовары.КлючСвязи, "КлючСвязи");
			Если НайденнаяСтрока <> Неопределено Тогда
				СуммаСкидки = НайденнаяСтрока.Сумма;
			Иначе
				СуммаСкидки = 0;
			КонецЕсли;
			Если ВсеУсловияВыполнены Тогда
				Если СтрокаДерева.Управляемая И НЕ СтрокаДерева.НазначенаПользователем Тогда
					ОбластьСтрокаСкидкаНаценкаНеНазначена.Параметры.Сумма = СуммаСкидки;
					ТабличныйДокумент.Присоединить(ОбластьСтрокаСкидкаНаценкаНеНазначена);
				ИначеЕсли СтрокаДерева.Управляемая И СтрокаДерева.НазначенаПользователем Тогда
					Если ДокументОбъект.СкидкиНаценки.НайтиСтроки(Новый Структура("КлючСвязи, СкидкаНаценка", СтрокаТовары.КлючСвязи, СтрокаДерева.Ссылка)).Количество() > 0 Тогда
						ОбластьСтрокаСкидкаНаценкаНазначена.Параметры.Сумма = СуммаСкидки;
						ТабличныйДокумент.Присоединить(ОбластьСтрокаСкидкаНаценкаНазначена);
					Иначе
						ОбластьСтрокаСкидкаНаценкаСкидкаНаценкаНеДействуетПоСовместномуПрименению.Параметры.Сумма = СуммаСкидки;
						ТабличныйДокумент.Присоединить(ОбластьСтрокаСкидкаНаценкаСкидкаНаценкаНеДействуетПоСовместномуПрименению);
					КонецЕсли;
				Иначе
					Если ДокументОбъект.СкидкиНаценки.НайтиСтроки(Новый Структура("КлючСвязи, СкидкаНаценка", СтрокаТовары.КлючСвязи, СтрокаДерева.Ссылка)).Количество() > 0 Тогда
						ОбластьСтрокаСкидкаНаценка.Параметры.Сумма = СуммаСкидки;
						ТабличныйДокумент.Присоединить(ОбластьСтрокаСкидкаНаценка);
					Иначе
						ОбластьСтрокаСкидкаНаценкаСкидкаНаценкаНеДействуетПоСовместномуПрименению.Параметры.Сумма = СуммаСкидки;
						ТабличныйДокумент.Присоединить(ОбластьСтрокаСкидкаНаценкаСкидкаНаценкаНеДействуетПоСовместномуПрименению);
					КонецЕсли;
				КонецЕсли;
			Иначе
				ОбластьСтрокаСкидкаНаценкаЗачеркнута.Параметры.Сумма = СуммаСкидки;
				ТабличныйДокумент.Присоединить(ОбластьСтрокаСкидкаНаценкаЗачеркнута);
			КонецЕсли;
			
			// Условия скидки, продолжение
			Для каждого СтрокаУсловие Из СтрокаДерева.ПараметрыУсловий.ТаблицаУсловий Цикл
				
				Если СоответствиеВыполненияУсловий.Получить(СтрокаУсловие.УсловиеПредоставления) Тогда
					ТабличныйДокумент.Присоединить(ОбластьСтрокаУсловиеВыполнено);
				Иначе
					ТабличныйДокумент.Присоединить(ОбластьСтрокаУсловиеНеВыполнено);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
		ОбластьСтрокаИтого.Параметры.Сумма = СтрокаТовары.СуммаАвтоматическойСкидки;
		ТабличныйДокумент.Присоединить(ОбластьСтрокаИтого);
		
	КонецЦикла;
	
	// Итого
	ТабличныйДокумент.Вывести(ОбластьИтогоНоменклатура);
	Если ИспользованиеХарактеристикНоменклатуры Тогда
		ТабличныйДокумент.Присоединить(ОбластьИтогоХарактеристика);
	КонецЕсли;
	Для каждого СтрокаДерева Из МассивСкидок Цикл
		
		// Сумма скидки
		СуммаСкидки = 0;
		НайденныеСтроки = ДокументОбъект.СкидкиНаценки.НайтиСтроки(Новый Структура("СкидкаНаценка", СтрокаДерева.Ссылка));
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			СуммаСкидки = СуммаСкидки + НайденнаяСтрока.Сумма;
		КонецЦикла;
		
		ОбластьИтогоСкидкаНаценка.Параметры.Сумма = СуммаСкидки;
		ТабличныйДокумент.Присоединить(ОбластьИтогоСкидкаНаценка);
		
		// Условия скидки, продолжение
		Для каждого СтрокаУсловие Из СтрокаДерева.ПараметрыУсловий.ТаблицаУсловий Цикл
			
			ТабличныйДокумент.Присоединить(ОбластьИтогоУсловие);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ОбластьИтогоИтого.Параметры.Сумма = ДокументОбъект[ИмяТЧ].Итог("СуммаАвтоматическойСкидки");
	ТабличныйДокумент.Присоединить(ОбластьИтогоИтого);
	
	ТабличныйДокумент.Вывести(ОбластьЛегенда);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
