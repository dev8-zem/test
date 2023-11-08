
#Область ПрограммныйИнтерфейс

// Формирует текст запроса для получения указанного реквизита объекта расчетов
//
// Параметры:
//	РеквизитИсточника - Строка - Имя реквизита источника содержащего объект расчетов
//                             состоящее из имени таблицы и через точку имени реквизита.
//                             Например: ДанныеРегистра.Заказ
//	РеквизитОбъектаРасчетов - Строка - Имя реквизита объекта расчетов
//	ПолноеИмяМетаданныхРеквизита - Строка - Полный путь к метаданным реквизита как в дереве метаданных.
//                                          Например: "Документы.ПоступлениеБезналичныхДенежныхСредств.ТабличныеЧасти.РасшифровкаПлатежа.Реквизиты.Заказ"
//                                                или "РегистрыНакопления.ДвиженияКонтрагентДоходыРасходы.Измерения.ОбъектРасчетов".
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстЗапросаРеквизитаОбъектаРасчетов(
			РеквизитИсточника = "Т.ОбъектРасчетов",
			РеквизитОбъектаРасчетов = "Договор",
			ПолноеИмяМетаданныхРеквизита = "ОпределяемыеТипы.ОбъектРасчетов") Экспорт
	
	ТекстПоля = "ВЫБОР" + Символы.ПС; //@Query-part
	ШаблонУсловия = "		КОГДА ТИПЗНАЧЕНИЯ(%1) = ТИП(%2)
					|			ТОГДА ВЫРАЗИТЬ(%1 КАК %2).%3";
	ШаблонДоговора = "		КОГДА ТИПЗНАЧЕНИЯ(%1) = ТИП(%2)
					 |			ТОГДА %1";
	УсловияВыбора = Новый Массив;
	ТипыДоговоров = Метаданные.Справочники.КлючиАналитикиУчетаПоПартнерам.Реквизиты.Договор.Тип.Типы();
	ТипыДоговоров.Добавить(Тип("СправочникСсылка.ПодарочныеСертификаты"));
	
	ТипыОбъектовРасчета = ОбщегоНазначенияУТ.МетаданныеПоИмени(ПолноеИмяМетаданныхРеквизита).Тип.Типы();
	Для Каждого ТипОбъектаРасчета Из ТипыОбъектовРасчета Цикл
		
		Если ТипОбъектаРасчета = Тип("NULL") ИЛИ ТипОбъектаРасчета = Тип("НЕОПРЕДЕЛЕНО") Тогда
			Продолжить;
		КонецЕсли;
		
		ПолноеИмяТипа = Метаданные.НайтиПоТипу(ТипОбъектаРасчета).ПолноеИмя();
		
		Если СтрНайти(ПолноеИмяТипа, "Перечисление") > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВРег(РеквизитОбъектаРасчетов) = "ДОГОВОР" И ТипыДоговоров.Найти(ТипОбъектаРасчета) <> Неопределено Тогда
			ТекстУсловия = СтрШаблон(ШаблонДоговора, РеквизитИсточника, ПолноеИмяТипа);
		Иначе
			РеквизитДляПодстановки = РеквизитОбъектаРасчетов;
			Если ПолноеИмяМетаданныхРеквизита = "ОпределяемыеТипы.ОбъектРасчетовСПоставщиками"
				И РеквизитДляПодстановки = "ГруппаФинансовогоУчета"
				И (ПолноеИмяТипа = "Документ.ПередачаТоваровМеждуОрганизациями" ИЛИ
					ПолноеИмяТипа = "Справочник.ДоговорыМеждуОрганизациями") Тогда
				РеквизитДляПодстановки = "ГруппаФинансовогоУчетаПолучателя";
			КонецЕсли;
			ТекстУсловия = СтрШаблон(ШаблонУсловия, РеквизитИсточника, ПолноеИмяТипа, РеквизитДляПодстановки);
		КонецЕсли;
		УсловияВыбора.Добавить(ТекстУсловия);
		
	КонецЦикла;
	ТекстУсловия = СтрСоединить(УсловияВыбора, Символы.ПС);
	Возврат ТекстПоля + ТекстУсловия + Символы.ПС + "КОНЕЦ"; //@Query-part
	
КонецФункции

// Получение фабрики XDTO в соответствии с версией схемы .
//
// Параметры:
//  ВерсияФормата - Строка - версия схемы.
// 
// Возвращаемое значение:
//  ФабрикаXDTO - фабрика, созданная на основании схемы.
//
Функция ФабрикаISO20022(ВерсияФормата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДвоичныеДанныеСхемы = Обработки.КлиентБанк.ПолучитьМакет(СтрЗаменить(ВерсияФормата, ".", "_"));
	ВремФайлСхемы = ПолучитьИмяВременногоФайла("xsd");
	ДвоичныеДанныеСхемы.Записать(ВремФайлСхемы);
	Фабрика = СоздатьФабрикуXDTO(ВремФайлСхемы);
	ФайловаяСистема.УдалитьВременныйФайл(ВремФайлСхемы);
	Возврат Фабрика;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаКэшРеквизитовПлатежа(ИмяТаблицы, ПоляГрафика) Экспорт
	
	СхемаЗапроса = Новый СхемаЗапроса;
	ЗапросВыбора = СхемаЗапроса.ПакетЗапросов[0];
	Оператор = СхемаЗапроса.ПакетЗапросов[0].Операторы[0];
	
	Если Оператор.Источники.НайтиПоИмени(ИмяТаблицы) = Неопределено Тогда
		ИсточникСхемы = Оператор.Источники.Добавить(ИмяТаблицы);
		
		Для каждого Поле Из ПоляГрафика Цикл
			Если ИсточникСхемы.Источник.ДоступныеПоля.Найти(Поле.Ключ) <> Неопределено Тогда
				ВыражениеСхемы = Оператор.ВыбираемыеПоля.Добавить(Поле.Ключ);
				Если ЗначениеЗаполнено(Поле.Значение) Тогда
					КолонкаСхемы = ЗапросВыбора.Колонки.Найти(ВыражениеСхемы);
					Если КолонкаСхемы <> Неопределено И ЗапросВыбора.Колонки.Найти(Поле.Значение) = Неопределено Тогда
						КолонкаСхемы.Псевдоним = Поле.Значение;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если ИсточникСхемы.Источник.ДоступныеПоля.Найти("Договор") <> Неопределено Тогда
			Оператор.ВыбираемыеПоля.Добавить("Договор.СтатьяДвиженияДенежныхСредств");
		КонецЕсли;
		Если ИсточникСхемы.Источник.ДоступныеПоля.Найти("Соглашение") <> Неопределено Тогда
			Оператор.ВыбираемыеПоля.Добавить("Соглашение.СтатьяДвиженияДенежныхСредств");
		КонецЕсли;
	КонецЕсли;
	
	Оператор.Отбор.Добавить("Ссылка В (&Ссылка)");
	
	Возврат СхемаЗапроса.ПолучитьТекстЗапроса();
	
КонецФункции

Функция КоэффициентКонвертации(ТекущаяВалюта, НоваяВалюта, Дата) Экспорт
	
	КоэффициентКонвертации = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ТекущаяВалюта, НоваяВалюта, Дата);
	
	Возврат ?(КоэффициентКонвертации = 0, 1, КоэффициентКонвертации);
	
КонецФункции

#КонецОбласти
