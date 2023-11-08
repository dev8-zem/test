#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДанныеЗаполненияШтрихкода() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("АдресПредыдущихШтрихкодов", "");
	Результат.Вставить("ТипШтрихкодаСтрокой",       "");
	Результат.Вставить("ТипУпаковки",  Перечисления.ТипыУпаковок.МонотоварнаяУпаковка);
	
	Результат.Вставить("ТипШтрихкода", Новый Массив);
	Результат.ТипШтрихкода.Добавить(Перечисления.ТипыШтрихкодов.GS1_128);
	Результат.ТипШтрихкода.Добавить(Перечисления.ТипыШтрихкодов.GS1_DataBarExpandedStacked);
	
	Результат.Вставить("GTIN", "");
	Результат.Вставить("Номенклатура",   Неопределено);
	Результат.Вставить("Характеристика", Неопределено);
	Результат.Вставить("Серия",          Неопределено);
	
	Возврат Результат;
	
КонецФункции

Функция СгенерироватьОчереднуюУпаковку(ДанныеЗаполнения) Экспорт
	
	Штрихкод = СгенерироватьОчереднойШтрихкод(ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(Штрихкод) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВозвращаемыеПараметры = Новый Структура;
	ВозвращаемыеПараметры.Вставить("Штрихкод",                    Штрихкод.ЗначениеШтрихкода);
	ВозвращаемыеПараметры.Вставить("ТипУпаковки",                 ДанныеЗаполнения.ТипУпаковки);
	ВозвращаемыеПараметры.Вставить("ТипШтрихкода",                ДанныеЗаполнения.ТипШтрихкода);
	ВозвращаемыеПараметры.Вставить("ТипШтрихкодаСтрокой",         ДанныеЗаполнения.ТипШтрихкодаСтрокой);
	
	Если ЭтоАдресВременногоХранилища(ДанныеЗаполнения.АдресПредыдущихШтрихкодов) Тогда
		ПоследниеШтрихкоды = ПолучитьИзВременногоХранилища(ДанныеЗаполнения.АдресПредыдущихШтрихкодов);
		ШтрихкодыПоGTIN = ПоследниеШтрихкоды.Получить("GTIN");
		Если ШтрихкодыПоGTIN = Неопределено Тогда
			ШтрихкодыПоGTIN = Новый Соответствие;
		КонецЕсли;
		ШтрихкодыПоGTIN.Вставить(ДанныеЗаполнения.GTIN, Штрихкод);
		ПоследниеШтрихкоды.Вставить("GTIN", ШтрихкодыПоGTIN);
		ДанныеЗаполнения.АдресПредыдущихШтрихкодов = ПоместитьВоВременноеХранилище(ПоследниеШтрихкоды, ДанныеЗаполнения.АдресПредыдущихШтрихкодов);
	Иначе
		ШтрихкодыПоGTIN = Новый Соответствие;
		ШтрихкодыПоGTIN.Вставить(ДанныеЗаполнения.GTIN, Штрихкод);
		ПоследниеШтрихкоды = Новый Соответствие;
		ПоследниеШтрихкоды.Вставить("GTIN", ШтрихкодыПоGTIN);
		ДанныеЗаполнения.АдресПредыдущихШтрихкодов = ПоместитьВоВременноеХранилище(ПоследниеШтрихкоды);
	КонецЕсли;
	
	ВозвращаемыеПараметры.Вставить("АдресПредыдущихШтрихкодов", ДанныеЗаполнения.АдресПредыдущихШтрихкодов);
		
	Возврат ВозвращаемыеПараметры;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ШтрихкодыУпаковокТоваров") Тогда
		
		ТабличныйДокумент = СформироватьПечатнуюФормуШтрихкодыУпаковки(ПараметрыПечати, ОбъектыПечати);
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ШтрихкодыУпаковокТоваров",
			НСтр("ru = 'Штрихкодов упаковок'"),
			ТабличныйДокумент);
			
	КонецЕсли;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуШтрихкодыУпаковки(ДанныеПечати, ОбъектыПечати)
	
	СвойстваОбъектовПечати = ДанныеПечати.ОбъектыПечати;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ШтрихкодыУпаковокТоваров_ШтрихкодыУпаковок";
	
	ПараметрыМакетов = Справочники.ШтрихкодыУпаковокТоваров.ПараметрыМакетовДляПечати();
	
	Для Каждого СвойстваОбъектаПечати Из СвойстваОбъектовПечати Цикл
		
		ПараметрыШтрихкодовУпаковок = Справочники.ШтрихкодыУпаковокТоваров.ПараметрыШтрихкодовУпаковокДляПечати();
		ЗаполнитьЗначенияСвойств(ПараметрыШтрихкодовУпаковок, СвойстваОбъектаПечати);
		
		Справочники.ШтрихкодыУпаковокТоваров.ДобавитьШтрихкодВТабличныйДокумент(
			ТабличныйДокумент,
			ПараметрыМакетов,
			ПараметрыШтрихкодовУпаковок);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ПриОпределенииКомандПодключенныхКОбъекту(Команды) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ГенерацияОчередногоШтрихкода

Функция СгенерироватьОчереднойШтрихкод(ДанныеЗаполнения)
	
	ШтрихкодПоGTIN = НайтиИПрочитатьПредыдущийШтрихкод(ДанныеЗаполнения);
	Если ШтрихкодПоGTIN = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ШтрихкодПоGTIN.СерийныйНомер = ШтрихкодПоGTIN.СерийныйНомер + 1;
	
	ПозицияНачалаСерийногоНомера = СтрНайти(ШтрихкодПоGTIN.ЗначениеШтрихкода, "(21)")+4;
	ЗначениеКодаНачало = Лев(ШтрихкодПоGTIN.ЗначениеШтрихкода, ПозицияНачалаСерийногоНомера - 1);
	ДлинаСерийногоНомера = СтрНайти(ШтрихкодПоGTIN.ЗначениеШтрихкода, "(",,ПозицияНачалаСерийногоНомера) - ПозицияНачалаСерийногоНомера;
	Если ДлинаСерийногоНомера < 0 Тогда
		ДлинаСерийногоНомера = СтрДлина(ШтрихкодПоGTIN.ЗначениеШтрихкода) - ПозицияНачалаСерийногоНомера + 1;
	КонецЕсли;
	ЗначениеКодаОкончание = Сред(ШтрихкодПоGTIN.ЗначениеШтрихкода, ПозицияНачалаСерийногоНомера + ДлинаСерийногоНомера);
	ОчереднойСерийныйНомерСтрокой = Формат(ШтрихкодПоGTIN.СерийныйНомер,"ЧГ=;");
	
	ВедущиеНули = СтрДлина(ОчереднойСерийныйНомерСтрокой) - ДлинаСерийногоНомера;
	Если ВедущиеНули<0 Тогда
		Возврат Неопределено; //коды партии закончились
	КонецЕсли;
	
	СтроковыеФункцииКлиентСервер.ДополнитьСтроку(ОчереднойСерийныйНомерСтрокой, ДлинаСерийногоНомера, "0", "Слева");
	
	ШтрихкодПоGTIN.ЗначениеШтрихкода = ЗначениеКодаНачало + ОчереднойСерийныйНомерСтрокой + ЗначениеКодаОкончание;
	Возврат ШтрихкодПоGTIN;
	
КонецФункции

Функция НайтиИПрочитатьПредыдущийШтрихкод(ДанныеШтрихкода)
	
	//Найти по GTIN
	Если ЭтоАдресВременногоХранилища(ДанныеШтрихкода.АдресПредыдущихШтрихкодов) Тогда
		
		Если ЗначениеЗаполнено(ДанныеШтрихкода.GTIN) Тогда
			ШтрихкодыПоТипам = ПолучитьИзВременногоХранилища(ДанныеШтрихкода.АдресПредыдущихШтрихкодов);
			ШтрихкодыПоGTIN = ШтрихкодыПоТипам.Получить("GTIN");
			Если ШтрихкодыПоGTIN <> Неопределено Тогда
				Значение = ШтрихкодыПоGTIN.Получить(ДанныеШтрихкода.GTIN);
				Если НЕ Значение = Неопределено Тогда
					Возврат Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	//Прочитать из справочника, по "номенклатура+характеристика"
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.ТипУпаковки       КАК ТипУпаковки,
	|	Таблица.ТипШтрихкода      КАК ТипШтрихкода,
	|	Таблица.ЗначениеШтрихкода КАК ЗначениеШтрихкода,
	|	Таблица.СерийныйНомер     КАК СерийныйНомер
	|ИЗ
	|	Справочник.ШтрихкодыУпаковокТоваров КАК Таблица
	|ГДЕ
	|	НЕ Таблица.ПометкаУдаления
	|	И Таблица.ТипУпаковки = &ТипУпаковки
	|	И Таблица.ТипШтрихкода В(&ТипШтрихкода)
	|	И Таблица.Номенклатура = &Номенклатура
	|	И Таблица.Характеристика = &Характеристика
	|
	|УПОРЯДОЧИТЬ ПО
	|	Таблица.ДатаУпаковки УБЫВ,
	|	Таблица.Ссылка УБЫВ";
	
	Запрос.УстановитьПараметр("ТипУпаковки",    ДанныеШтрихкода.ТипУпаковки);
	Запрос.УстановитьПараметр("ТипШтрихкода",   ДанныеШтрихкода.ТипШтрихкода);
	Запрос.УстановитьПараметр("Номенклатура",   ДанныеШтрихкода.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", ДанныеШтрихкода.Характеристика);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Выборка.ТипШтрихкода = Перечисления.ТипыШтрихкодов.GS1_128 Тогда
		ТипШтрихкодаСтрокой = "GS1128";
	ИначеЕсли Выборка.ТипШтрихкода = Перечисления.ТипыШтрихкодов.GS1_DataBarExpandedStacked Тогда
		ТипШтрихкодаСтрокой = "GS1DataBarExpandedStacked";
	КонецЕсли;
		
	Результат = Новый Структура;
	Результат.Вставить("ТипУпаковки", Выборка.ТипУпаковки);
	Результат.Вставить("ТипШтрихкода", Выборка.ТипШтрихкода);
	Результат.Вставить("ЗначениеШтрихкода", Выборка.ЗначениеШтрихкода);
	Результат.Вставить("ТипШтрихкодаСтрокой", ТипШтрихкодаСтрокой);
	Результат.Вставить("СерийныйНомер", Выборка.СерийныйНомер);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли