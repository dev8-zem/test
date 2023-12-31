#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ОшибкиЗагрузки = "";
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	//++ Локализация


	//-- Локализация
	Возврат;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		МетаданныеОбъекта = Метаданные();
		Для Каждого ПараметрЗаполнения Из ДанныеЗаполнения Цикл
			Если МетаданныеОбъекта.Реквизиты.Найти(ПараметрЗаполнения.Ключ)<>Неопределено Тогда
				ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
			Иначе
				Если ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеРеквизиты, ПараметрЗаполнения.Ключ) Тогда
					ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если ТипЗнч(ПервичныйДокумент) = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств") Тогда
			ХозяйственнаяОперация = ПервичныйДокумент.ХозяйственнаяОперация;
		Иначе
			ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыПоЗарплатномуПроекту;
		КонецЕсли;
		
		Если ПервичныйДокумент <> Неопределено
			И ПервичныйДокумент.Метаданные().Реквизиты.Найти("Подразделение") <> Неопределено
			И ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплатыУТ") Тогда
			Подразделение = ПервичныйДокумент.Подразделение;
		КонецЕсли;
		
		//++ Локализация


		//-- Локализация
		
		Если ДанныеЗаполнения.Свойство("Сотрудники") Тогда
			
			Сотрудники.Очистить();
			
			Для Каждого СтрокаЗначенийЗаполнения Из ДанныеЗаполнения.Сотрудники Цикл
				
				НоваяСтрока = Сотрудники.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗначенийЗаполнения);
				
				Если Не ЗначениеЗаполнено(НоваяСтрока.РезультатЗачисленияЗарплаты) Тогда
					
					Если ДанныеЗаполнения.Сотрудники.Колонки.Найти("РезультатЗачисленияЗарплаты") <> Неопределено
						И ТипЗнч(СтрокаЗначенийЗаполнения.РезультатЗачисленияЗарплаты) = Тип("Строка") Тогда
						НоваяСтрока.РезультатЗачисленияЗарплаты = Перечисления.РезультатыЗачисленияЗарплаты[СтрокаЗначенийЗаполнения.РезультатЗачисленияЗарплаты];
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если ДанныеЗаполнения.Сотрудники.Колонки.Найти("КодВалюты") <> Неопределено Тогда
				Валюта = Справочники.Валюты.НайтиПоКоду(ДанныеЗаполнения.Сотрудники[0].КодВалюты);
			Иначе
				Валюта = Справочники.Валюты.НайтиПоКоду("643");
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств") Тогда
		ЗаполнитьПоСписаниюБезналичныхДенежныхСредств(ДанныеЗаполнения);
	КонецЕсли;
	
	СтатьяДвиженияДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьСтатьюДвиженияДенежныхСредств(ХозяйственнаяОперация);
	
	Если Не ЗначениеЗаполнено(СтатьяДвиженияДенежныхСредств) Тогда
		СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредствПервичногоДокумента();
	КонецЕсли;
	
	СуммаДокумента = Сотрудники.Итог("Сумма");
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтандартнаяОбработка = Истина;
	
	ДополнительныеСвойства.Вставить("ОшибкиЗаполнения", "");
	//++ Локализация


	//-- Локализация
	
	Если СтандартнаяОбработка Тогда
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ПервичныйДокумент", ПервичныйДокумент);
		Запрос.УстановитьПараметр("Сотрудники", Сотрудники.Выгрузить());
		Запрос.УстановитьПараметр("ХешФайла", ХешФайла);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодтверждениеЗачисленияЗарплаты.Ссылка
		|ИЗ
		|	Документ.ПодтверждениеЗачисленияЗарплаты КАК ПодтверждениеЗачисленияЗарплаты
		|ГДЕ
		|	ПодтверждениеЗачисленияЗарплаты.ПервичныйДокумент = &ПервичныйДокумент
		|	И ПодтверждениеЗачисленияЗарплаты.Ссылка <> &Ссылка
		|	И ПодтверждениеЗачисленияЗарплаты.Проведен
		|	И ПодтверждениеЗачисленияЗарплаты.ХешФайла = &ХешФайла";
		
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		Если НЕ Результат.Пустой() Тогда
			ТекстОшибки = НСтр("ru = 'Подтверждение по первичному документу уже зарегистрировано.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "ПервичныйДокумент", , Отказ);
			ДенежныеСредстваСервер.ДобавитьОшибкуЗаполнения(ДополнительныеСвойства.ОшибкиЗаполнения, ТекстОшибки);
		КонецЕсли;
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику Тогда
			
			МассивДокументов = Новый Массив;
			МассивДокументов.Добавить(ПервичныйДокумент);
			Если ДополнительныеСвойства.Свойство("ОшибкиЗаполнения") Тогда
				ДенежныеСредстваСервер.ПроверитьЗаполнениеЛицевыхСчетовПоИсточникам(
					ЭтотОбъект, "Сотрудники", МассивДокументов, Отказ, Истина, ДополнительныеСвойства.ОшибкиЗаполнения);
			Иначе
				ДенежныеСредстваСервер.ПроверитьЗаполнениеЛицевыхСчетовПоИсточникам(ЭтотОбъект, "Сотрудники", МассивДокументов, Отказ);
			КонецЕсли;
			
			НепроверяемыеРеквизиты = Новый Массив;
			НепроверяемыеРеквизиты.Добавить("ЗарплатныйПроект");
			ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
			
		//++ Локализация


		//-- Локализация
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОшибкиЗагрузки = "";
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПодсистемы") Тогда
		ЗаполнитьКраткийСоставДокумента();
	КонецЕсли;
	
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОчиститьДвиженияДокумента(ЭтотОбъект, "ПрочиеАктивыПассивы");
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
		
	//++ Локализация


	//-- Локализация
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ Локализация


//-- Локализация

#Область ПроцедурыИФункцииДляПолученияФайлаПодтверждения

//++ Локализация

Процедура ЗаполнитьДокументИзОбъектаXDTO(ОбъектXDTO, ХешСумма, СсылкаНаПервичныйДокумент, Отказ) Экспорт
	
	ПервичныйДокумент = СсылкаНаПервичныйДокумент;
	ХозОперацияПервичногоДокумента = Неопределено;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ХозяйственнаяОперация", ПервичныйДокумент.Метаданные()) Тогда
		ХозОперацияПервичногоДокумента =
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПервичныйДокумент, "ХозяйственнаяОперация");
	КонецЕсли;
	
	Если ХозОперацияПервичногоДокумента = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику Тогда
		СтруктураДанныхДляЗаполненияДокумента = ОбменСБанкамиУТ.ДанныеПодтвержденияЗачисленияИзXDTO(ОбъектXDTO);
	КонецЕсли;
	
	Сотрудники.Очистить();
	Заполнить(СтруктураДанныхДляЗаполненияДокумента);
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

Процедура ЗаполнитьПоСписаниюБезналичныхДенежныхСредств(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику Тогда
		ПолучитьДанныеЗаполненияПоВыплатеПодотчетникам(ДанныеЗаполнения, ДанныеЗаполнения);
	//++ Локализация


	//-- Локализация
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПолучитьДанныеЗаполненияПоВыплатеПодотчетникам(Знач Основание, ДанныеЗаполнения) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СписаниеБезналичныхДС.Ссылка КАК Ссылка,
		|	СписаниеБезналичныхДС.Ссылка КАК ПервичныйДокумент,
		|	СписаниеБезналичныхДС.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	СписаниеБезналичныхДС.Организация КАК Организация,
		|	СписаниеБезналичныхДС.Подразделение КАК Подразделение,
		|	СписаниеБезналичныхДС.Валюта КАК Валюта,
		|	СписаниеБезналичныхДС.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента,
		|	СписаниеБезналичныхДС.БанковскийСчетКонтрагента.Банк КАК Банк,
		|	СписаниеБезналичныхДС.НомерДоговораСБанком КАК НомерДоговораСБанком
		|ПОМЕСТИТЬ ОсновныеДанныеДокумента
		|ИЗ
		|	Документ.СписаниеБезналичныхДенежныхСредств КАК СписаниеБезналичныхДС
		|ГДЕ
		|	СписаниеБезналичныхДС.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОсновныеДанныеДокумента.Ссылка КАК Ссылка,
		|	ОсновныеДанныеДокумента.ПервичныйДокумент КАК ПервичныйДокумент,
		|	ОсновныеДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ОсновныеДанныеДокумента.Организация КАК Организация,
		|	ОсновныеДанныеДокумента.Подразделение КАК Подразделение,
		|	ОсновныеДанныеДокумента.Валюта КАК Валюта,
		|	ОсновныеДанныеДокумента.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента,
		|	ОсновныеДанныеДокумента.Банк КАК Банк,
		|	ОсновныеДанныеДокумента.НомерДоговораСБанком КАК НомерДоговора
		|ИЗ
		|	ОсновныеДанныеДокумента КАК ОсновныеДанныеДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЛицевыеСчетаСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ЛицевыеСчетаСотрудников.ЛицевойСчет.НомерСчета КАК НомерЛицевогоСчета,
		|	СУММА(ЛицевыеСчетаСотрудников.Сумма) КАК Сумма,
		|	ЗНАЧЕНИЕ(Перечисление.РезультатыЗачисленияЗарплаты.Зачислено) КАК РезультатЗачисленияЗарплаты
		|ИЗ
		|	ОсновныеДанныеДокумента КАК ОсновныеДанныеДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеБезналичныхДенежныхСредств.ЛицевыеСчетаСотрудников КАК ЛицевыеСчетаСотрудников
		|		ПО ОсновныеДанныеДокумента.Ссылка = ЛицевыеСчетаСотрудников.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ЛицевыеСчетаСотрудников.ФизическоеЛицо,
		|	ЛицевыеСчетаСотрудников.ЛицевойСчет.НомерСчета";
	
	Запрос.УстановитьПараметр("Ссылка", Основание);
	
	МассивРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеЗаполнения = Новый Структура;
	
	Для каждого Колонка Из МассивРезультатовЗапроса[МассивРезультатовЗапроса.ВГраница() - 1].Колонки Цикл
		ДанныеЗаполнения.Вставить(Колонка.Имя);
	КонецЦикла;
	
	ОсновныеДанные = МассивРезультатовЗапроса[МассивРезультатовЗапроса.ВГраница() - 1].Выбрать();
	ДанныеТабличнойЧасти = МассивРезультатовЗапроса[МассивРезультатовЗапроса.ВГраница()].Выбрать();
	
	ОсновныеДанные.Следующий();
	ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, ОсновныеДанные);
	
	РезультатЗапросаПоРасшифровкеПлатежа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "РасшифровкаПлатежа"); // РезультатЗапроса
	РасшифровкаПлатежа = РезультатЗапросаПоРасшифровкеПлатежа.Выбрать();
	
	Если РасшифровкаПлатежа.Следующий() Тогда
		ДанныеЗаполнения.Вставить("СтатьяДвиженияДенежныхСредств", РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств);
	КонецЕсли;
	
	
	Пока ДанныеТабличнойЧасти.Следующий() Цикл
		
		НоваяСтрока = Сотрудники.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеТабличнойЧасти);
		
	КонецЦикла;

КонецПроцедуры

//++ Локализация


//-- Локализация

Функция СтатьяДвиженияДенежныхСредствПервичногоДокумента()
	
	Результат = Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка();
	
	Если Не ЗначениеЗаполнено(ПервичныйДокумент) Тогда
		Возврат Результат;
	КонецЕсли;
	
	МетаданныеДокумента = ПервичныйДокумент.Метаданные();
	ИмяДокумента = МетаданныеДокумента.ПолноеИмя();
	ТаблицаРасшифровкаПлатежа = МетаданныеДокумента.ТабличныеЧасти.Найти("РасшифровкаПлатежа");
	
	Если ТаблицаРасшифровкаПлатежа = Неопределено Тогда
		Возврат Результат;
	Иначе
		ИмяДокументаСТабличнойЧастью = СтрЗаменить(ТаблицаРасшифровкаПлатежа.ПолноеИмя(), "ТабличнаяЧасть.", "");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВЫБОР
		|		КОГДА ПлатежныйДокумент.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)
		|			ТОГДА ПлатежныйДокументРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств
		|		ИНАЧЕ ПлатежныйДокумент.СтатьяДвиженияДенежныхСредств
		|	КОНЕЦ КАК СтатьяДвиженияДенежныхСредств
		|ИЗ
		|	&Документ КАК ПлатежныйДокумент
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ &РасшифровкаПлатежа КАК ПлатежныйДокументРасшифровкаПлатежа
		|		ПО ПлатежныйДокумент.Ссылка = ПлатежныйДокументРасшифровкаПлатежа.Ссылка
		|ГДЕ
		|	ПлатежныйДокумент.Ссылка = &Ссылка";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Документ", ИмяДокумента);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&РасшифровкаПлатежа", ИмяДокументаСТабличнойЧастью);
	Запрос.УстановитьПараметр("Ссылка", ПервичныйДокумент);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока РезультатЗапроса.Следующий() Цикл
		Результат = РезультатЗапроса.СтатьяДвиженияДенежныхСредств;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьКраткийСоставДокумента()
	
	СписокСокращенныхФИО = Новый Массив;
	МаксимальноеКоличествоСимволов = 100;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ СписокФизическихЛиц
		|ИЗ
		|	&Сотрудники КАК Сотрудники
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФИОФизическихЛицСрезПоследних.Фамилия КАК Фамилия,
		|	ФИОФизическихЛицСрезПоследних.Имя КАК Имя,
		|	ФИОФизическихЛицСрезПоследних.Отчество КАК Отчество
		|ИЗ
		|	РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
		|			&НаДату,
		|			ФизическоеЛицо В
		|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|					СписокФизическихЛиц.ФизическоеЛицо КАК ФизическоеЛицо
		|				ИЗ
		|					СписокФизическихЛиц КАК СписокФизическихЛиц)) КАК ФИОФизическихЛицСрезПоследних";
	
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники.Выгрузить());
	Запрос.УстановитьПараметр("НаДату", Дата);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		
		Инициалы = "";
		
		Если Не ПустаяСтрока(РезультатЗапроса.Имя) Тогда
			Инициалы = Лев(РезультатЗапроса.Имя, 1) + ".";
		КонецЕсли;
		
		Если Не ПустаяСтрока(РезультатЗапроса.Отчество) Тогда
			Инициалы = Инициалы + " " + Лев(РезультатЗапроса.Отчество, 1) + ".";
		КонецЕсли;
		
		ФамилияИнициалы = РезультатЗапроса.Фамилия + ?(Инициалы <> "", " " + Инициалы, "");
		
		Если СтрДлина(ФамилияИнициалы) <= МаксимальноеКоличествоСимволов Тогда
			СписокСокращенныхФИО.Добавить(ФамилияИнициалы);
			МаксимальноеКоличествоСимволов = МаксимальноеКоличествоСимволов - СтрДлина(ФамилияИнициалы);
		Иначе
			Прервать;
		КонецЕсли; 
		
	КонецЦикла;
	
	Если СписокСокращенныхФИО.Количество() <> 0 Тогда
		КраткийСоставДокумента = СтрСоединить(СписокСокращенныхФИО, ", ");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли