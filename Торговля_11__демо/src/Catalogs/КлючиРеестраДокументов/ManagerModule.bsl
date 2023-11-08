#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Соотвествие со списком реквизитов, по которым определяется уникальность ключа
// 
// Возвращаемое значение:
//   Соответствие - ключ - имя реквизита 
//
Функция КлючевыеРеквизиты() Экспорт
	
	Результат = Новый Соответствие;
	Результат.Вставить("Ключ");
	
	Возврат Результат;
	
КонецФункции

// Вычисляет какие ключи реестра нужно создать (обновить) и обновляет их
//
// Параметры:
//  ОбъектыМетаданных			 - Соответствие	 - объекты метаданных:
//  	* Ключ		- ОбъектМетаданныхДокумент	 - объект метаданных документа.
//  	* Значение	- Неопределено					- пустое значение.
//  ЭлементДляОбновленияКлюча	 - ЛюбаяСсылка - ссылка на элемент справочника, по которой нужно создать или обновить ключ
//                                               если параметр передан, то первый параметр игнорируется
//
Процедура СоздатьОбновитьКлючиРеестра(ОбъектыМетаданных = Неопределено, ЭлементДляОбновленияКлюча = Неопределено) Экспорт
	
	Если ЭлементДляОбновленияКлюча <> Неопределено Тогда
		
		ОбъектыМетаданных = Новый Соответствие;
		ОбъектыМетаданных.Вставить(Метаданные.НайтиПоТипу(ТипЗнч(ЭлементДляОбновленияКлюча)));
		
	ИначеЕсли ОбъектыМетаданных = Неопределено Тогда
		
		ОбъектыМетаданных = ОбъектыМетаданныхЗакешированныеВКлючахРеестра();
		
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Истина);
		
	ЕстьКлючиДляГенерации = Истина;
	
	Пока ЕстьКлючиДляГенерации Цикл
		
		ТаблицаКлючей = КлючиРеестраДляОбновления(ОбъектыМетаданных, Истина, ,ЭлементДляОбновленияКлюча);
		
		ЕстьКлючиДляГенерации = ТаблицаКлючей.Количество() > 0; 
		
		Если Не ЕстьКлючиДляГенерации Тогда
			Возврат;
		КонецЕсли;
	
		НачатьТранзакцию();
		
		Попытка
			
			Если Не МонопольныйРежим() Тогда
				// При работе в немонопольном режиме нужно гарантировать, что по
				// ключам в параллельном сеансе не были изменены ключи.
				
				Блокировка = Новый БлокировкаДанных;
				
				ЭлементБлокировки = Блокировка.Добавить("Справочник.КлючиРеестраДокументов");
				ЭлементБлокировки.ИсточникДанных = ТаблицаКлючей;
				ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ключ", "Ключ");
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
				
				Блокировка.Заблокировать();
				
			КонецЕсли;
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТаблицаКлючей.Ключ КАК Ключ,
			|	ТаблицаКлючей.Организация КАК Организация,
			|	ТаблицаКлючей.ИНН КАК ИНН,
			|	ТаблицаКлючей.Наименование КАК Наименование
			|ПОМЕСТИТЬ ТаблицаКлючей
			|ИЗ
			|	&ТаблицаКлючей КАК ТаблицаКлючей
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТаблицаКлючей.Ключ КАК Ключ,
			|	ТаблицаКлючей.Организация КАК Организация,
			|	ТаблицаКлючей.ИНН КАК ИНН,
			|	ТаблицаКлючей.Наименование КАК Наименование,
			|	ЕСТЬNULL(КлючиРеестраДокументов.Ссылка, ЗНАЧЕНИЕ(Справочник.КлючиРеестраДокументов.ПустаяСсылка)) КАК Ссылка
			|ИЗ
			|	ТаблицаКлючей КАК ТаблицаКлючей
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументов
			|		ПО ТаблицаКлючей.Ключ = КлючиРеестраДокументов.Ключ
			|ГДЕ
			|	(КлючиРеестраДокументов.Ссылка ЕСТЬ NULL
			|			ИЛИ ТаблицаКлючей.Организация <> КлючиРеестраДокументов.Организация
			|			ИЛИ ТаблицаКлючей.ИНН <> КлючиРеестраДокументов.ИНН
			|			ИЛИ ТаблицаКлючей.Наименование <> КлючиРеестраДокументов.Наименование)";
			
			Запрос.УстановитьПараметр("ТаблицаКлючей", ТаблицаКлючей);
			
			ВыборкаСсылок = Запрос.Выполнить().Выбрать();
			
			Пока ВыборкаСсылок.Следующий() Цикл
				
				Если ЗначениеЗаполнено(ВыборкаСсылок.Ссылка) Тогда
					КлючОбъект = ВыборкаСсылок.Ссылка.ПолучитьОбъект();
				Иначе
					КлючОбъект = Справочники.КлючиРеестраДокументов.СоздатьЭлемент();
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(КлючОбъект, ВыборкаСсылок);
				КлючОбъект.Записать();
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать ключи реестра документов: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Создание ключей аналитики реестра документов'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.КлючиРеестраДокументов,
				,
				ТекстСообщения);
		
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Возвращает признак, того элемент справочника входит в ключи реестра документов,
// поэтому по нему нужно создавать или обновлять элемент технологического справочника.
//
// Параметры:
//	Объект - Произвольный - объект базы данных, например, СправочникОбъект.Организации.
//
// Возвращаемое значение:
//	Булево - Истина, если полученный объект отражается в реестре документов через технологический ключ.
//
Функция ОбъектЯвляетсяКлючомРеестра(Объект) Экспорт
	
	Если Не ЗначениеЗаполнено(Объект) Тогда
		Возврат Ложь;
	ИначеЕсли Не ОбщегоНазначения.ЭтоСправочник(Объект.Метаданные()) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СправочникСсылка	= Объект.Ссылка;
	ТипСсылки		= ТипЗнч(СправочникСсылка);
	
	МетаданныеКлючей	= Метаданные.НайтиПоПолномуИмени("Справочник.КлючиРеестраДокументов");
	ТипыИсточника		= МетаданныеКлючей.Реквизиты.Ключ.Тип.Типы();
	
	ОбработатьОбъект = ТипыИсточника.Найти(ТипСсылки) <> Неопределено;
	
	Возврат ОбработатьОбъект;
	
КонецФункции

// Функция - Объекты метаданных закешированные в ключах реестра
// 
// Возвращаемое значение:
//  Соответствие - в ключах лежат объекты типа ОбъектМетаданных.
//
Функция ОбъектыМетаданныхЗакешированныеВКлючахРеестра() Экспорт 
	ОбъектыМетаданных = Новый Соответствие;
	
	Для каждого ТипКлюча Из Метаданные.Справочники.КлючиРеестраДокументов.Реквизиты.Ключ.Тип.Типы() Цикл
		
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипКлюча);
		ОбъектыМетаданных.Вставить(МетаданныеОбъекта);
		
	КонецЦикла;
	
	Возврат ОбъектыМетаданных;
	
КонецФункции

// Получает ключи реестра по значениям справочников
//
// Параметры:
//    Значения - Массив, Произвольный - ссылка(и) на справочники базы данных, например, СправочникСсылка.Склад.
// 
// Возвращаемое значение:
//    Массив - ключи реестра
//
Функция КлючиПоЗначениям(Значения) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	Справочник.КлючиРеестраДокументов
	|ГДЕ
	|	Ключ В (&Ключи)
	|");
	
	Запрос.УстановитьПараметр("Ключи", Значения);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Находит дубли ключей реестра документов, удаляет их. 
// При этом удаляются записи реестра документов. Если остался ключ, по которому
// в реестре не было записей, а по удаленным ключам были - то записи восстанавливаются
// с "правильными" ключами.
//
Процедура НайтиИУдалитьДубли() Экспорт
	
	РезультатЗапроса = ДублирующиеКлючи(Истина);
	УдалитьДубли(РезультатЗапроса, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КлючиРеестраДляОбновления(ОбъектыМетаданных, Порциями, ПустыеСсылки = "ВключатьВсе", ЭлементДляОбновленияКлюча = Неопределено)

	ТекстЗапроса =
	ТекстЗапросаВТДанныеПоОбъектам(ОбъектыМетаданных) +
	"ВЫБРАТЬ &Порциями,
	|	ВложенныйЗапрос.Ключ КАК Ключ,
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	ВложенныйЗапрос.ИНН КАК ИНН,
	|	ВложенныйЗапрос.Наименование КАК Наименование,
	|	СУММА(ВложенныйЗапрос.Контроль) КАК Контроль
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДанныеПоОбъектам.Ключ КАК Ключ,
	|		ДанныеПоОбъектам.Организация КАК Организация,
	|		ДанныеПоОбъектам.ИНН КАК ИНН,
	|		ДанныеПоОбъектам.Наименование КАК Наименование,
	|		1 КАК Контроль,
	|		ЕСТЬNULL(КлючиРеестраДокументов.Ссылка, ЗНАЧЕНИЕ(Справочник.КлючиРеестраДокументов.ПустаяСсылка)) КАК СсылкаНаКлюч
	|	ИЗ
	|		ДанныеПоОбъектам КАК ДанныеПоОбъектам
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументов
	|			ПО (КлючиРеестраДокументов.Ключ = ДанныеПоОбъектам.Ключ)
	|	ГДЕ
	|	    &БезОтбораПоСсылке
	|	    ИЛИ ДанныеПоОбъектам.Ключ = &ЭлементДляОбновленияКлюча 
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КлючиРеестраДокументов.Ключ,
	|		КлючиРеестраДокументов.Организация,
	|		КлючиРеестраДокументов.ИНН,
	|		КлючиРеестраДокументов.Наименование,
	|		-1,
	|		КлючиРеестраДокументов.Ссылка
	|	ИЗ
	|		Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументов
	|	ГДЕ
	|	    &БезОтбораПоСсылке
	|	    ИЛИ КлючиРеестраДокументов.Ключ = &ЭлементДляОбновленияКлюча) КАК ВложенныйЗапрос 
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Организация,
	|	ВложенныйЗапрос.Ключ,
	|	ВложенныйЗапрос.Наименование,
	|	ВложенныйЗапрос.ИНН
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВложенныйЗапрос.Контроль) > 0";
	
	Если Порциями Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Порциями,", "ПЕРВЫЕ 1000");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Порциями,", "");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Если ЭлементДляОбновленияКлюча = Неопределено Тогда
		Запрос.УстановитьПараметр("ВключатьНеПустые", ПустыеСсылки = "ВключатьВсе" Или ПустыеСсылки = "ВключатьНепустые");
		Запрос.УстановитьПараметр("ВключатьПустые", ПустыеСсылки = "ВключатьВсе" Или ПустыеСсылки = "ВключатьПустые");
	Иначе
		Запрос.УстановитьПараметр("ВключатьНеПустые", Истина);
		Запрос.УстановитьПараметр("ВключатьПустые", Ложь);
	КонецЕсли;	
		
	Запрос.УстановитьПараметр("БезОтбораПоСсылке", ЭлементДляОбновленияКлюча = Неопределено);
	Запрос.УстановитьПараметр("ЭлементДляОбновленияКлюча", ЭлементДляОбновленияКлюча);
	Запрос.Текст = ТекстЗапроса;
	
	ТаблицаКлючей = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаКлючей;
		
КонецФункции

Функция ТекстЗапросаВТДанныеПоОбъектам(ОбъектыМетаданных)
	ТекстыЗапроса = Новый Массив;
	
	Если ТипЗнч(ОбъектыМетаданных) = Тип("Соответствие") Тогда
		
		Для Каждого ОписаниеОбъекта Из ОбъектыМетаданных Цикл
			ТекстЗапроса = ТекстЗапросаДанныхПоСправочнику(ОписаниеОбъекта.Ключ);
			ТекстыЗапроса.Добавить(ТекстЗапроса);
		КонецЦикла;
		
		ШаблонЗапросаОбъединения = "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|";
		
		ТекстЗапросаПоОбъектам = СтрСоединить(ТекстыЗапроса, ШаблонЗапросаОбъединения);
		
	ИначеЕсли ТипЗнч(ОбъектыМетаданных) = Тип("ОбъектМетаданных") Тогда	
		
		ТекстЗапросаПоОбъектам = ТекстЗапросаДанныхПоСправочнику(ОбъектыМетаданных);
		
	Иначе
		
		ТекстИсключения = НСтр("ru = 'Тип %Тип% не поддерживается функцией'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%Тип%", Строка(ТипЗнч(ОбъектыМетаданных)));
		
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
		
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Ключ КАК Ключ,
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	ВложенныйЗапрос.ИНН КАК ИНН,
	|	ВложенныйЗапрос.Наименование КАК Наименование
	|ПОМЕСТИТЬ ДанныеПоОбъектам
	|ИЗ
	|	&ТекстЗапросаПоОбъектам КАК ВложенныйЗапрос
	|ИНДЕКСИРОВАТЬ ПО Ключ
	|;";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстЗапросаПоОбъектам", "(" + ТекстЗапросаПоОбъектам + ")");
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДанныхПоСправочнику(ОбъектМетаданных)
	ШаблонТекстаЗапроса =
	"ВЫБРАТЬ
	|		СправочникИсточник.Ссылка КАК Ключ,
	|		&ТекстПоляОрганизация КАК Организация,
	|		&ТекстПоляИНН КАК ИНН,
	|		СправочникИсточник.Наименование КАК Наименование
	|	ИЗ
	|		ПолноеИмяОбъекта КАК СправочникИсточник
	|	ГДЕ
	|		&ВключатьНепустые
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ПолноеИмяОбъекта.ПустаяСсылка),
	|		ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка),
	|		"""",
	|		""""
	|	ГДЕ
	|		&ВключатьПустые";
				
	ТекстЗапроса = СтрЗаменить(ШаблонТекстаЗапроса, "ПолноеИмяОбъекта", ОбъектМетаданных.ПолноеИмя());
	
	ЕстьВладелецОрганизация = Ложь;
	
	Для Каждого Реквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
		Если Реквизит.Имя = "Владелец" Тогда
			
			Если Реквизит.Тип.ПривестиЗначение() = Справочники.Организации.ПустаяСсылка() Тогда
				ЕстьВладелецОрганизация = Истина;
			КонецЕсли;
			
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьВладелецОрганизация Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстПоляОрганизация", "СправочникИсточник.Владелец");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстПоляОрганизация", "ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)");
	КонецЕсли;
	
	Если ОбъектМетаданных.Реквизиты.Найти("ИНН") <> Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстПоляИНН", "ЕСТЬNULL(СправочникИсточник.ИНН,"""")");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстПоляИНН", """""");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ДублирующиеКлючи(ИтогиПоКлючу)
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 	
	"ВЫБРАТЬ
	|	КлючиРеестраДокументов.Ключ КАК Ключ,
	|	СУММА(1) КАК Контроль
	|ПОМЕСТИТЬ ВТДубли
	|ИЗ
	|	Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументов
	|
	|СГРУППИРОВАТЬ ПО
	|	КлючиРеестраДокументов.Ключ
	|
	|ИМЕЮЩИЕ
	|	СУММА(1) > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КлючиРеестраДокументов.Ссылка КАК Ссылка,
	|	КлючиРеестраДокументов.Ключ КАК Ключ
	|ИЗ
	|	ВТДубли КАК ВТДубли
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументов
	|		ПО ВТДубли.Ключ = КлючиРеестраДокументов.Ключ";
	
	Если ИтогиПоКлючу Тогда
		ТекстЗапроса = 	ТекстЗапроса + "
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ключ,
		|	Ссылка
		|ИТОГИ ПО
		|	Ключ";
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();
КонецФункции

Процедура УдалитьДубли(РезультатЗапроса, ЭтоОбновлениеИБ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЭтоОбновлениеИБ", ЭтоОбновлениеИБ);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Ссылка КАК Ссылка,
	|	ИСТИНА КАК ЗаписьОстается
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	РегистрСведений.РеестрДокументов
	|ГДЕ
	|	&ОстающийсяКлюч В (МестоХранения, Контрагент)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Ссылка,
	|	ЛОЖЬ
	|ИЗ
	|	РегистрСведений.РеестрДокументов
	|ГДЕ
	|	МестоХранения В (&УдаляемыеКлючи)
	|	ИЛИ Контрагент В (&УдаляемыеКлючи)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Ссылка КАК Ссылка,
	|	Ссылка ССЫЛКА Документ.Сторно КАК ЭтоСторно,
	|	1 КАК Порядок,
	|	МАКСИМУМ(ЗаписьОстается) КАК ЗаписьОстается
	|ИЗ
	|	ТаблицаДокументов
	|СГРУППИРОВАТЬ ПО
	|	Ссылка,
	|	Ссылка ССЫЛКА Документ.Сторно
	|ИМЕЮЩИЕ
	|	МАКСИМУМ(ЗаписьОстается) = ЛОЖЬ
	|	ИЛИ &ЭтоОбновлениеИБ
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Ссылка,
	|	Ссылка ССЫЛКА Документ.Сторно,
	|	2,
	|	ЛОЖЬ
	|ИЗ
	|	РегистрСведений.РеестрДокументов
	|ГДЕ
	|	НЕ ДополнительнаяЗапись
	|СГРУППИРОВАТЬ ПО
	|	Ссылка,
	|	Ссылка ССЫЛКА Документ.Сторно
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) > 1
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	ЭтоСторно";
	
	ВыборкаКлючам = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаКлючам.Следующий() Цикл
		
		ВыборкаПоСсылкам = ВыборкаКлючам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		НачатьТранзакцию();
		
		Попытка
			
			ПерваяСсылка = Истина;
			ОстающийсяКлюч = Неопределено;
			УдаляемыеКлючи = Новый Массив;
			
			Пока ВыборкаПоСсылкам.Следующий() Цикл
				
				Если ЭтоОбновлениеИБ Тогда
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ВыборкаПоСсылкам.Ссылка);
				КонецЕсли;
				
				Если ПерваяСсылка Тогда
					ОстающийсяКлюч = ВыборкаПоСсылкам.Ссылка;
					ПерваяСсылка = Ложь;
				Иначе
					УдаляемыеКлючи.Добавить(ВыборкаПоСсылкам.Ссылка);
				КонецЕсли;
				
			КонецЦикла;
			
			Запрос.УстановитьПараметр("ОстающийсяКлюч", ОстающийсяКлюч);
			Запрос.УстановитьПараметр("УдаляемыеКлючи", УдаляемыеКлючи);
			
			ДокументыДляПереотражения = Запрос.Выполнить().Выбрать();
			
			Для Каждого КлючДляУдаления Из УдаляемыеКлючи Цикл
				
				КлючОбъект = КлючДляУдаления.ПолучитьОбъект();
				
				УстановитьПривилегированныйРежим(Истина);
				КлючОбъект.Удалить();
				УстановитьПривилегированныйРежим(Ложь);
				
			КонецЦикла;
			
			Пока ДокументыДляПереотражения.Следующий() Цикл
				
				НаборЗаписей = РегистрыСведений.РеестрДокументов.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Ссылка.Установить(ДокументыДляПереотражения.Ссылка);
				
				Если ДокументыДляПереотражения.ЗаписьОстается Тогда
					
					Если ЭтоОбновлениеИБ Тогда
						ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
					КонецЕсли;
					
				Иначе
					
					УстановитьПривилегированныйРежим(Истина);
					
					ТаблицыДанных = ПроведениеДокументов.ДанныеДокументаДляПроведения(
						ДокументыДляПереотражения.Ссылка,
						"РеестрДокументов"
					);
					НаборЗаписей.ЗагрузитьСОбработкой(ТаблицыДанных["Таблица" + "РеестрДокументов"]);
					
					Если ЭтоОбновлениеИБ Тогда
						ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
						Очередь = ОбновлениеИнформационнойБазы.ОчередьОтложенногоОбработчикаОбновления(
						"РегистрыСведений.РеестрДокументов.ОбработатьДанныеДляПереходаНаНовуюВерсию");
						Если Очередь <> Неопределено Тогда
							ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей,, Очередь);
						КонецЕсли;
					Иначе
						НаборЗаписей.Записать();
					КонецЕсли;
					
					УстановитьПривилегированныйРежим(Ложь);
					
					Если ЭтоОбновлениеИБ Тогда		
						ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей,,
							ОбновлениеИнформационнойБазы.ОчередьОтложенногоОбработчикаОбновления(
								"РегистрыСведений.РеестрДокументов.ОбработатьДанныеДляПереходаНаНовуюВерсию"
							)
						);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось удалить дубли ключа реестра документов %1 по причине: %2'"),
				ВыборкаКлючам.Ключ,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			);
			
			Если ЭтоОбновлениеИБ Тогда
				СобытиеЖурнала = ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации();
			Иначе
				СобытиеЖурнала = ИмяСобытияЖурналаУдаленияДублей();
			КонецЕсли;
			
			ЗаписьЖурналаРегистрации(СобытиеЖурнала,
				УровеньЖурналаРегистрации.Предупреждение,
				ВыборкаКлючам.Ключ.Метаданные(),
				ВыборкаКлючам.Ключ,
				ТекстСообщения
			);
			
		КонецПопытки;
	
	КонецЦикла;
	
КонецПроцедуры

Функция ИмяСобытияЖурналаУдаленияДублей() Экспорт
	
	Возврат НСтр("ru = 'Удаление ключей реестра документов'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());	
	
КонецФункции

Функция ЕстьДубли() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлючиРеестраДокументов.Ключ КАК Ключ,
	|	СУММА(1) КАК Проверка
	|ИЗ
	|	Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументов
	|
	|СГРУППИРОВАТЬ ПО
	|	КлючиРеестраДокументов.Ключ
	|
	|ИМЕЮЩИЕ
	|	СУММА(1) > 1";
	
	УстановитьПривилегированныйРежим(Истина);
	ЕстьДубли = Не Запрос.Выполнить().Пустой();

	Если ЕстьДубли Тогда
		Если СтандартныеПодсистемыПовтИсп.ИспользуетсяРИБ() Тогда
			Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
				Возврат "ЕстьДублиВПодчиненномУзлеРИБ";
			Иначе
				Возврат "ЕстьДублиВГлавномУзлеРИБ";
			КонецЕсли;
		Иначе
			Возврат "ЕстьДублиВГлавномУзлеРИБ";
		КонецЕсли;
	Иначе
		Возврат "Нет";
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);

КонецФункции

Функция ЕстьКлючиДляГенерации() Экспорт
	
	ОбъектыМетаданных = ОбъектыМетаданныхЗакешированныеВКлючахРеестра();
	УстановитьПривилегированныйРежим(Истина);
	ЕстьКлючиДляГенерации = КлючиРеестраДляОбновления(ОбъектыМетаданных, Истина).Количество() > 0; 
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЕстьКлючиДляГенерации Тогда
		Если СтандартныеПодсистемыПовтИсп.ИспользуетсяРИБ() Тогда
			Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
				Возврат "ЕстьЭлементыБезКлючейВПодчиненномУзлеРИБ";
			Иначе
				Возврат "ЕстьЭлементыБезКлючейВГлавномУзлеРИБ";
			КонецЕсли;
		Иначе
			Возврат "ЕстьЭлементыБезКлючейВГлавномУзлеРИБ";
		КонецЕсли;
	Иначе
		Возврат "Нет";
	КонецЕсли;

КонецФункции

Функция РезультатФоновыхЗаданий()
	                                       
	Результат = Новый Структура();
	Результат.Вставить("ЕстьДубли");
	Результат.Вставить("ЕстьЭлементыСправочниковБезКлючей");
	Результат.Вставить("ЕстьДокументыКПереотражениюВРеестре");
	
	Возврат Результат;
	
КонецФункции

Процедура НайтиИУдалитьДублиВФормеСписка(Параметры, АдресВременногоХранилища) Экспорт
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Неопределено, "РегистрСведений.РеестрДокументов") Тогда
		ТекстИсключения = НСтр("ru = 'По реестру документов есть невыполненные обработчики обновления. Перед запуском процедуры необходимо дождаться окончания их выполнения.'");
	    ВызватьИсключение ТекстИсключения;
	КонецЕсли;

	Результат = РезультатФоновыхЗаданий();
	
	НайтиИУдалитьДубли();
	
	Если ЕстьДубли() <> "Нет" Тогда
		Результат.ЕстьДубли = "Ошибка";
	Иначе
		Результат.ЕстьДубли = "Нет";
	КонецЕсли;	
	
	ПоместитьВоВременноеХранилище(Результат, АдресВременногоХранилища);
	
КонецПроцедуры

Процедура СоздатьКлючиВФормеСписка(Параметры, АдресВременногоХранилища) Экспорт
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Неопределено, "РегистрСведений.РеестрДокументов") Тогда
		ТекстИсключения = НСтр("ru = 'По реестру документов есть невыполненные обработчики обновления. Перед запуском процедуры необходимо дождаться окончания их выполнения.'");
	    ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Результат = РезультатФоновыхЗаданий();
	
	СоздатьОбновитьКлючиРеестра();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеестрДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.Проведен
	|	И РеестрДокументов.МестоХранения = ЗНАЧЕНИЕ(Справочник.КлючиРеестраДокументов.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Отказ = Ложь;
		Попытка
			ТаблицыДанных = ПроведениеДокументов.ДанныеДокументаДляПроведения(Выборка.Ссылка, "РеестрДокументов");
			РегистрыСведений.РеестрДокументов.ЗаписатьДанные(
				ТаблицыДанных,
				Выборка.Ссылка,
				Неопределено,
				Отказ);
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Переотражение документов в реестре документов'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегистрыСведений.РеестрДокументов,
				Выборка.Ссылка,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЦикла;
	
	Если ЕстьКлючиДляГенерации() <> "Нет" Тогда  
		Результат.ЕстьЭлементыСправочниковБезКлючей = "Ошибка";
	Иначе
		Результат.ЕстьЭлементыСправочниковБезКлючей = "Нет";
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресВременногоХранилища);
	
КонецПроцедуры

Процедура ПроверитьНеобходимостьПереотраженияДокументовВРеестре(Параметры, АдресВременногоХранилища) Экспорт
	
	Типы = РегистрыСведений.РеестрДокументов.ТипыДокументовРеестра();
	ЕстьОшибки = Ложь;
	
	Для каждого ТипДокумента Из Типы Цикл
		
		ПолноеИмяДокумента = Метаданные.НайтиПоТипу(ТипДокумента).ПолноеИмя();
		
		НеиспользуемыеПоля = Новый Массив;
		НеиспользуемыеПоля.Добавить("Дополнительно");
		НеиспользуемыеПоля.Добавить("РазделительЗаписи");
		НеиспользуемыеПоля.Добавить("НомерПервичногоДокумента");
		
		УстановитьПривилегированныйРежим(Истина);
		
		ИмяДокумента = СтрРазделить(ПолноеИмяДокумента, ".")[1];
		РезультатАдаптацииЗапроса = Документы[ИмяДокумента].АдаптированныйТекстЗапросаДвиженийПоРегистру("РеестрДокументов");
		Регистраторы = ОбновлениеИнформационнойБазыУТ.ДанныеНезависимогоРегистраДляПерепроведения(
							РезультатАдаптацииЗапроса, 
							"РегистрСведений.РеестрДокументов", 
							ПолноеИмяДокумента, 
							НеиспользуемыеПоля);
		
		УстановитьПривилегированныйРежим(Ложь);
							
		Если Регистраторы.Количество() > 0 Тогда
			ЕстьОшибки = Истина;						
		 	Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Результат = РезультатФоновыхЗаданий();
	
	Если ЕстьОшибки Тогда
		Результат.ЕстьДокументыКПереотражениюВРеестре = "Есть";
	Иначе
		Результат.ЕстьДокументыКПереотражениюВРеестре = "Нет";
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресВременногоХранилища);
	
КонецПроцедуры

Процедура ИсправитьОшибкиОтраженияДокументовВРеестре(Параметры, АдресВременногоХранилища) Экспорт
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Неопределено, "РегистрСведений.РеестрДокументов") Тогда
		ТекстИсключения = НСтр("ru = 'По реестру документов есть невыполненные обработчики обновления. Перед запуском процедуры необходимо дождаться окончания их выполнения.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Типы = РегистрыСведений.РеестрДокументов.ТипыДокументовРеестра();
	ЕстьОшибки = Ложь;
	
	Для каждого ТипДокумента Из Типы Цикл
		
		ПолноеИмяДокумента = Метаданные.НайтиПоТипу(ТипДокумента).ПолноеИмя();
		
		НеиспользуемыеПоля = Новый Массив;
		НеиспользуемыеПоля.Добавить("Дополнительно");
		НеиспользуемыеПоля.Добавить("РазделительЗаписи");
		НеиспользуемыеПоля.Добавить("НомерПервичногоДокумента");
		
		УстановитьПривилегированныйРежим(Истина);
		
		ИмяДокумента = СтрРазделить(ПолноеИмяДокумента, ".")[1];
		РезультатАдаптацииЗапроса = Документы[ИмяДокумента].АдаптированныйТекстЗапросаДвиженийПоРегистру("РеестрДокументов");
		ДанныеРеестраДокументов = ОбновлениеИнформационнойБазыУТ.ДанныеНезависимогоРегистраДляПерепроведения(
									РезультатАдаптацииЗапроса,
									"РегистрСведений.РеестрДокументов",
									ПолноеИмяДокумента,
									НеиспользуемыеПоля);
		Регистраторы = ДанныеРеестраДокументов.ВыгрузитьКолонку("Ссылка");
		
		Для Каждого Регистратор из Регистраторы Цикл
			
			Отказ = Ложь;
			
			Попытка
				ТаблицыДанных = ПроведениеДокументов.ДанныеДокументаДляПроведения(Регистратор, "РеестрДокументов");
				РегистрыСведений.РеестрДокументов.ЗаписатьДанные(
					ТаблицыДанных,
					Регистратор,
					Неопределено,
					Отказ);
				Если Отказ Тогда
					ЕстьОшибки = Истина;
				КонецЕсли;
			Исключение
				ЕстьОшибки = Истина;
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Переотражение документов в реестре документов'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.РегистрыСведений.РеестрДокументов,
					Регистратор,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;;
			
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЦикла;
	
	Если ЕстьОшибки Тогда
		Результат = РезультатФоновыхЗаданий();
		Результат.ЕстьДокументыКПереотражениюВРеестре = "Ошибка";
		ПоместитьВоВременноеХранилище(Результат, АдресВременногоХранилища);
	Иначе
		ПроверитьНеобходимостьПереотраженияДокументовВРеестре(Параметры, АдресВременногоХранилища);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)

	Если Данные.Наименование = "" Тогда
		СтандартнаяОбработка = Ложь;
		Представление = "";
	КонецЕсли;

КонецПроцедуры

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
