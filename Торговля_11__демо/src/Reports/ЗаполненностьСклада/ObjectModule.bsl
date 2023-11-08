#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);

	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.ТоварыВЯчейках.Запрос;

	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесУпаковки", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ТоварыВЯчейкахОстатки.Упаковка", "ТоварыВЯчейкахОстатки.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемУпаковки", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ТоварыВЯчейкахОстатки.Упаковка", "ТоварыВЯчейкахОстатки.Номенклатура"));

	СхемаКомпоновкиДанных.НаборыДанных.ТоварыВЯчейках.Запрос = ТекстЗапроса;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПараметризуемыеЗаголовкиПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)

	Настройка = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ОтображатьЗанятостьЗонПриемкиИОтгрузки");
	СписокГруппировок = КомпоновкаДанныхКлиентСервер.ПолучитьГруппировки(КомпоновщикНастроек);
	Для каждого Группировка Из СписокГруппировок  Цикл
		Если Группировка.Значение.Имя = "Зоны приемки / отгрузки" Тогда
			Группировка.Значение.Использование = Настройка.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПараметризуемыеЗаголовкиПолей()
	
	Возврат КомпоновкаДанныхСервер.СоответствиеЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	
КонецФункции

#КонецОбласти

#КонецЕсли