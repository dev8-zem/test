#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ВыводитьГруппировкуПоАналогамНоменклатуры = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек,
		"ВыводитьГруппировкуПоАналогамНоменклатуры");
	
	Если ВыводитьГруппировкуПоАналогамНоменклатуры <> Неопределено 
		И ВыводитьГруппировкуПоАналогамНоменклатуры.Использование
		И ВыводитьГруппировкуПоАналогамНоменклатуры.Значение Тогда
		
		НастройкиСервиса = СервисПрогнозирования.ПолучитьНастройкиСервиса();
		АналогСвойство = НастройкиСервиса.РеквизитАналогиТовараСвойство;
		Если ЗначениеЗаполнено(АналогСвойство) Тогда
			СтрокиКомпоновки = НастройкиОтчета.Структура[0].Строки;
			СтрокиКомпоновки.Очистить();
			
			ШаблонДопСвойства = "Номенклатура.[%1]";
			ПредставлениеСвойстваАналога = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АналогСвойство, "Представление");
			
			КомпоновкаДанныхКлиентСервер.ДобавитьГруппировку(НастройкиОтчета, СтрШаблон(ШаблонДопСвойства, ПредставлениеСвойстваАналога));
			КомпоновкаДанныхКлиентСервер.ДобавитьГруппировку(НастройкиОтчета, "Номенклатура");
		КонецЕсли;
	КонецЕсли;
	
	ТекстЗапросаТовары = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Элементы.НаборДанныхТовары.Запрос;
	ТекстЗапросаКатегории = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Элементы.НаборДанныхКатегории.Запрос;
	
	ПериодичностьОтчета = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ПериодичностьОтчета");
	Если ПериодичностьОтчета <> Неопределено Тогда
		Если ПериодичностьОтчета.Значение = Перечисления.Периодичность.Неделя Тогда
			ТекстЗапросаТовары = СтрЗаменить(ТекстЗапросаТовары, "ДЕНЬ)", "НЕДЕЛЯ)");
			ТекстЗапросаКатегории = СтрЗаменить(ТекстЗапросаКатегории, "ДЕНЬ)", "НЕДЕЛЯ)");
		ИначеЕсли ПериодичностьОтчета.Значение = Перечисления.Периодичность.Декада Тогда
			ТекстЗапросаТовары = СтрЗаменить(ТекстЗапросаТовары, "ДЕНЬ)", "ДЕКАДА)");
			ТекстЗапросаКатегории = СтрЗаменить(ТекстЗапросаКатегории, "ДЕНЬ)", "ДЕКАДА)");
		ИначеЕсли ПериодичностьОтчета.Значение = Перечисления.Периодичность.Месяц Тогда
			ТекстЗапросаТовары = СтрЗаменить(ТекстЗапросаТовары, "ДЕНЬ)", "МЕСЯЦ)");
			ТекстЗапросаКатегории = СтрЗаменить(ТекстЗапросаКатегории, "ДЕНЬ)", "МЕСЯЦ)");
		ИначеЕсли ПериодичностьОтчета.Значение = Перечисления.Периодичность.Квартал Тогда
			ТекстЗапросаТовары = СтрЗаменить(ТекстЗапросаТовары, "ДЕНЬ)", "КВАРТАЛ)");
			ТекстЗапросаКатегории = СтрЗаменить(ТекстЗапросаКатегории, "ДЕНЬ)", "КВАРТАЛ)");
		ИначеЕсли ПериодичностьОтчета.Значение = Перечисления.Периодичность.Полугодие Тогда
			ТекстЗапросаТовары = СтрЗаменить(ТекстЗапросаТовары, "ДЕНЬ)", "ПОЛУГОДИЕ)");
			ТекстЗапросаКатегории = СтрЗаменить(ТекстЗапросаКатегории, "ДЕНЬ)", "ПОЛУГОДИЕ)");
		ИначеЕсли ПериодичностьОтчета.Значение = Перечисления.Периодичность.Год Тогда
			ТекстЗапросаТовары = СтрЗаменить(ТекстЗапросаТовары, "ДЕНЬ)", "ГОД)");
			ТекстЗапросаКатегории = СтрЗаменить(ТекстЗапросаКатегории, "ДЕНЬ)", "ГОД)");
		КонецЕсли;
	КонецЕсли;

	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Элементы.НаборДанныхТовары.Запрос = ТекстЗапросаТовары;
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Элементы.НаборДанныхКатегории.Запрос = ТекстЗапросаКатегории;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
