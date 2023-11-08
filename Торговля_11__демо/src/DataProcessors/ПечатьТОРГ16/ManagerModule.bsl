#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Формирует печатную форму ТОРГ-16 объектов.
//
// Параметры:
//	МассивОбъектов        - Массив           - массив ссылок на объекты которые нужно распечатать,
//	ПараметрыПечати       - Структура        - структура дополнительных параметров печати,
//	КоллекцияПечатныхФорм - ТаблицаЗначений  - сформированные табличные документы,
//	ОбъектыПечати         - СписокЗначений   - список объектов печати,
//	ПараметрыВывода       - Структура        - параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
		
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТОРГ16") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ТОРГ16",
			НСтр("ru = 'Акт о списании товаров (ТОРГ-16)'"),
			СформироватьПечатнуюФормуТОРГ16(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, СтруктураТипов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

// Функция формирует табличный документ печатной формы ТОРГ-16.
//
// Параметры:
//	МассивОбъектов  - Массив         - массив ссылок на объекты которые нужно распечатать,
//	ОбъектыПечати   - СписокЗначений - список объектов печати,
//	ПараметрыПечати - Структура      - структура дополнительных параметров печати.
//
// Возвращаемое значение:
//	ТабличныйДокумент - печатная форма ТОРГ-16 документов, которые нужно распечатать.
//
Функция СформироватьПечатнуюФормуТОРГ16(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	НомерДокумента = 0;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТОРГ16";
	
	Если ТипЗнч(МассивОбъектов) = Тип("Соответствие") Тогда
		СтруктураТипов = МассивОбъектов;
	Иначе
		СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	КонецЕсли;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		Если СтруктураОбъектов.Ключ <> "Документ.СписаниеНедостачТоваров"
			И СтруктураОбъектов.Ключ <> "Документ.ОтчетОСписанииТоваровСХранения"
			И СтруктураОбъектов.Ключ <> "Документ.ОтчетОСписанииТоваровУХранителя" Тогда
			
			ТекстСообщения = НСтр("ru = 'Формирование печатной формы ""ТОРГ-16"" доступно только для документов ""%СписаниеНедостач%"" и ""%СписаниеСХранения%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СписаниеСХранения%",
				Метаданные.Документы.ОтчетОСписанииТоваровСХранения.Синоним);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СписаниеНедостач%",
				Метаданные.Документы.СписаниеНедостачТоваров.Синоним);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
			Продолжить;
			
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначенияУТ.ПолучитьМодульЛокализации(СтруктураОбъектов.Ключ);
		Если МенеджерОбъекта = Неопределено Тогда
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		КонецЕсли;
		
		Для Каждого ДокументОснование Из СтруктураОбъектов.Значение Цикл
			
			НомерДокумента = НомерДокумента + 1;
			
			Если НомерДокумента > 1 Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыТОРГ16(ПараметрыПечати, ДокументОснование);
			
			Если Не ДанныеДляПечати = Неопределено Тогда
				ЗаполнитьТабличныйДокументТОРГ16(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ДокументОснование);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Заполняет табличный документ печатной формы ТОРГ-16 данными документа, которого нужно распечатать.
//
// Параметры:
//	ТабличныйДокумент - ТабличныйДокумент - табличный документ печатной формы ТОРГ-16,
//	ДанныеДляПечати   - Структура         - структура данных объекта печати:
// 		* РезультатПоШапке   - РезультатЗапроса
// 		* РезультатПоДатам   - РезультатЗапроса
// 		* РезультатПоТоварам - РезультатЗапроса
//	ОбъектыПечати     - СписокЗначений    - список объектов печати,
//	ДокументОснование - ДокументСсылка    - ссылка на документ, который нужно распечатать.
//
Процедура ЗаполнитьТабличныйДокументТОРГ16(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ДокументОснование)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТОРГ16.ПФ_MXL_ТОРГ16_ru");
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	
	ТабличныйДокумент.АвтоМасштаб        = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	
	Шапка                      = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ТабличнаяЧастьПервогоЛиста = ДанныеДляПечати.РезультатПоДатам.Выбрать();
	ТабличнаяЧастьВторогоЛиста = ДанныеДляПечати.РезультатПоТоварам.Выбрать();
	ТаблицаКурсовВалют         = ДанныеДляПечати.РезультатКурсыВалют;
	
	КоэффициентПересчета = ТаблицаКурсовВалют.Найти(ДокументОснование, "Ссылка");
	Если ЗначениеЗаполнено(КоэффициентПересчета) Тогда
		КурсВалюты = ?(КоэффициентПересчета.КурсЗнаменатель <> 0, КоэффициентПересчета.КурсЧислитель / КоэффициентПересчета.КурсЗнаменатель, 1);
	Иначе
		КурсВалюты = 1;
	КонецЕсли;
	
	ОбластьШапкаШтрихкод                = Макет.ПолучитьОбласть("ШапкаШтрихкод");
	ОбластьШапкаОснование               = Макет.ПолучитьОбласть("ШапкаОснование");
	ОбластьЗаголовокТаблицыПервогоЛиста = Макет.ПолучитьОбласть("ЗаголовокТаблицыПервогоЛиста");
	ОбластьСтрокаПервогоЛиста           = Макет.ПолучитьОбласть("СтрокаПервогоЛиста");
	ОбластьЗаголовокТаблицыВторогоЛиста = Макет.ПолучитьОбласть("ЗаголовокТаблицыВторогоЛиста");
	ОбластьСтрокаВторогоЛиста           = Макет.ПолучитьОбласть("СтрокаВторогоЛиста");
	ОбластьИтого                        = Макет.ПолучитьОбласть("Итого");
	ОбластьПодвал                       = Макет.ПолучитьОбласть("Подвал");
	
	Шапка.Следующий();
	
	ОбластьШапкаШтрихкод.Параметры.Заполнить(Шапка);
	
	ПодразделениеПредставление = СкладыСервер.ПолучитьПредставлениеСклада(Шапка.ПодразделениеПредставление);
	
	СтруктураДанныхШапкиШтрихкод = Новый Структура("ПодразделениеПредставление", ПодразделениеПредставление);
	ОбластьШапкаШтрихкод.Параметры.Заполнить(СтруктураДанныхШапкиШтрихкод);
	
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьШапкаШтрихкод,
		Шапка.Ссылка);
	ТабличныйДокумент.Вывести(ОбластьШапкаШтрихкод);
	
	
	НомерДокументаПечати       = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер);
	ОснованиеНомер             = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерОснования);
	ФИОРуководителя            = Шапка.Руководитель;
	
	СтруктураДанныхШапкиОснование = Новый Структура;
	СтруктураДанныхШапкиОснование.Вставить("ФИОРуководителя", ФИОРуководителя);
	СтруктураДанныхШапкиОснование.Вставить("НомерДокумента",  НомерДокументаПечати);
	СтруктураДанныхШапкиОснование.Вставить("ОснованиеНомер",  ОснованиеНомер);
	
	ОбластьШапкаОснование.Параметры.Заполнить(Шапка);
	
	Если ЗначениеЗаполнено(Шапка.ДокументОснование) Тогда
		ПредставлениеОснования = Шапка.ДокументОснование.ПолучитьОбъект().Метаданные().Синоним;
		
		СтруктураДанныхШапкиОснование.Вставить("ОснованиеПредставление", ПредставлениеОснования);
	КонецЕсли;
	
	ОбластьШапкаОснование.Параметры.Заполнить(СтруктураДанныхШапкиОснование);
	ТабличныйДокумент.Вывести(ОбластьШапкаОснование);
	
	НомерСтраницы = 0;
	НомерСтроки   = 0;
	
	МассивВыводимыхОбластей = Новый Массив;
	МассивВыводимыхОбластей.Добавить(ОбластьСтрокаПервогоЛиста);
	
	Пока ТабличнаяЧастьПервогоЛиста.Следующий() Цикл
		
		НомерСтроки                = НомерСтроки + 1;
		СтруктураСтрокПервогоЛиста = Новый Структура("ДатаСписанияТовара", Шапка.ДатаДокумента);
		
		ОбластьСтрокаПервогоЛиста.Параметры.Заполнить(СтруктураСтрокПервогоЛиста);
		
		Если НомерСтроки = 1 Тогда // первая строка
			
			НомерСтраницы             = НомерСтраницы + 1;
			СтруктураЗаголовкаТаблицы = Новый Структура("НомерСтраницы", "Страница " + НомерСтраницы);
			
			ОбластьЗаголовокТаблицыПервогоЛиста.Параметры.Заполнить(СтруктураЗаголовкаТаблицы);
			ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицыПервогоЛиста);
			
		ИначеЕсли НомерСтроки <> 1 И Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
			
			НомерСтраницы = НомерСтраницы + 1;
			СтруктураЗаголовкаТаблицы = Новый Структура("НомерСтраницы", "Страница " + НомерСтраницы);
			
			ОбластьЗаголовокТаблицыПервогоЛиста.Параметры.Заполнить(СтруктураЗаголовкаТаблицы);
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицыПервогоЛиста);
			
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьСтрокаПервогоЛиста);
		
	КонецЦикла;
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	ИтогоСтоимость = 0;
	
	// Выводим многострочную часть документа
	НомерСтроки     = 0;
	КоличествоСтрок = ТабличнаяЧастьВторогоЛиста.Количество();
	
	ДопПараметрыПредставлениеНоменклатуры = НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
	ДопПараметрыПредставлениеНоменклатуры.КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	
	Пока ТабличнаяЧастьВторогоЛиста.Следующий() Цикл
		
		НомерСтроки = НомерСтроки + 1;
		
		ОбластьСтрокаВторогоЛиста.Параметры.Заполнить(ТабличнаяЧастьВторогоЛиста);
		
		ТоварНаименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
			ТабличнаяЧастьВторогоЛиста.НоменклатураПредставление,
			ТабличнаяЧастьВторогоЛиста.ХарактеристикаПредставление,
			,
			,
			ДопПараметрыПредставлениеНоменклатуры);
		
		ЦенаНеЗадана = НЕ ЗначениеЗаполнено(ТабличнаяЧастьВторогоЛиста.Цена);
		Цена         = ?(ЦенаНеЗадана, 0, ТабличнаяЧастьВторогоЛиста.Цена * КурсВалюты);
		Стоимость    = ?(ЦенаНеЗадана, 0, ТабличнаяЧастьВторогоЛиста.Цена
			* ТабличнаяЧастьВторогоЛиста.КоличествоМест * КурсВалюты);
		
		СтруктураДанныхТовара = Новый Структура;
		СтруктураДанныхТовара.Вставить("ТоварНаименование", ТоварНаименование);
		СтруктураДанныхТовара.Вставить("Цена",              Цена);
		СтруктураДанныхТовара.Вставить("Стоимость",         Стоимость);
		
		ОбластьСтрокаВторогоЛиста.Параметры.Заполнить(СтруктураДанныхТовара);
		
		Если НомерСтроки = 1 Тогда // первая строка
			
			НомерСтраницы             = НомерСтраницы + 1;
			СтруктураЗаголовкаТаблицы = Новый Структура("НомерСтраницы", "Страница " + НомерСтраницы);
			
			ОбластьЗаголовокТаблицыВторогоЛиста.Параметры.Заполнить(СтруктураЗаголовкаТаблицы);
			ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицыВторогоЛиста);
			
		Иначе
			
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьСтрокаВторогоЛиста);
			
			Если НомерСтроки = КоличествоСтрок Тогда
				МассивВыводимыхОбластей.Добавить(ОбластьИтого);
			КонецЕсли;
			
			Если НомерСтроки <> 1 И Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
				
				НомерСтраницы             = НомерСтраницы + 1;
				СтруктураЗаголовкаТаблицы = Новый Структура("НомерСтраницы", "Страница " + НомерСтраницы);
				
				ОбластьЗаголовокТаблицыВторогоЛиста.Параметры.Заполнить(СтруктураЗаголовкаТаблицы);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицыВторогоЛиста);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьСтрокаВторогоЛиста);
		
		// Обновим итоги по документу
		ИтогоСтоимость = ИтогоСтоимость + ОбластьСтрокаВторогоЛиста.Параметры.Стоимость;
		
	КонецЦикла;
	
	// Выводим итоги по документу в общем
	СтруктураДанныхИтогов = Новый Структура("Итого", ИтогоСтоимость);
	
	ОбластьИтого.Параметры.Заполнить(СтруктураДанныхИтогов);
	ТабличныйДокумент.Вывести(ОбластьИтого);
	
	// Выводим подвал документа
	МассивВыводимыхОбластей.Очистить();
	МассивВыводимыхОбластей.Добавить(ОбластьПодвал);
	
	Если Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
		НомерСтраницы = НомерСтраницы + 1;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	КопеекЦифрами           = (ИтогоСтоимость - Цел(ИтогоСтоимость)) * 100;
	КопеекЦифрами           = Формат(КопеекЦифрами, "ЧЦ=2; ЧДЦ=0; ЧН='00'");
	СуммаСписанияПрописью   = РаботаСКурсамиВалютУТ.СформироватьСуммуПрописью(Цел(ИтогоСтоимость),
		Справочники.Валюты.ПустаяСсылка(), Истина);
	ДолжностьПредседателя   = Шапка.ДолжностьРуководителя;
	ФИОпредседателя         = Шапка.Руководитель;
	ДолжностьЧленаКомиссии2 = НСтр("ru='Главный бухгалтер'", Метаданные.Языки.Русский.КодЯзыка);
	ФИОЧленаКомиссии2       = Шапка.ГлавныйБухгалтер;
	ДолжностьМОЛ            = Шапка.ДолжностьКладовщика;
	ФИОМОЛ                  = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Шапка.Кладовщик, Шапка.ДатаДокумента);
	
	СтруктураДанныхПодвала = Новый Структура;
	СтруктураДанныхПодвала.Вставить("КопеекЦифрами",           КопеекЦифрами);
	СтруктураДанныхПодвала.Вставить("СуммаСписанияПрописью",   СуммаСписанияПрописью);
	СтруктураДанныхПодвала.Вставить("ДолжностьПредседателя",   ДолжностьПредседателя);
	СтруктураДанныхПодвала.Вставить("ФИОпредседателя",         ФИОпредседателя);
	СтруктураДанныхПодвала.Вставить("ДолжностьЧленаКомиссии2", ДолжностьЧленаКомиссии2);
	СтруктураДанныхПодвала.Вставить("ФИОЧленаКомиссии2",       ФИОЧленаКомиссии2);
	СтруктураДанныхПодвала.Вставить("ДолжностьМОЛ",            ДолжностьМОЛ);
	СтруктураДанныхПодвала.Вставить("ФИОМОЛ",                  ФИОМОЛ);
	
	ОбластьПодвал.Параметры.Заполнить(Шапка);
	ОбластьПодвал.Параметры.Заполнить(СтруктураДанныхПодвала);
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
