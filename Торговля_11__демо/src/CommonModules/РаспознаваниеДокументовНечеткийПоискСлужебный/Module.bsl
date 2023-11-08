#Область СлужебныеПроцедурыИФункции

Функция ПараметрыНечеткогоПоиска() Экспорт 
	
	Результат = Новый Структура;
	Результат.Вставить("СоответствиеРеквизитов", Новый Структура);
	Результат.Вставить("ВесаРеквизитов", Новый Структура);
	Результат.Вставить("РеквизитыПолногоСоответствия", Новый Массив);
	Результат.Вставить("ВесаРеквизитовПредварительнойОценки", Новый Структура);
	Результат.Вставить("КоличествоКандидатовПредварительнойОценки", 200);
	Результат.Вставить("ВесКороткойНГраммы", 1);
	Результат.Вставить("ВесДлиннойНГраммы", 1);
	Результат.Вставить("ВажностьПолногоСоответствия", 0.5);
	Результат.Вставить("Сигма", 15);
	Результат.Вставить("ОтброситьДробнуюЧасть", Ложь);
	Результат.Вставить("ТекстЗапросаКандидаты", "");
	Результат.Вставить("КоличествоКандидатовБыстройОценки", 200);
	Результат.Вставить("МинимальнаяДлинаСтрокиДляПоиска", 2);
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыНечеткогоПоискаПеречислений() Экспорт 
	
	Результат = ПараметрыНечеткогоПоиска();
	
	Результат.СоответствиеРеквизитов.Вставить("Представление", "Представление");
	Результат.ВесаРеквизитов.Вставить("Представление", 1);
	Результат.РеквизитыПолногоСоответствия.Добавить("Представление");
	Результат.ВесаРеквизитовПредварительнойОценки.Вставить("Представление", 1);
	Результат.ОтброситьДробнуюЧасть = Истина;
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыНечеткогоПоискаОбщие() Экспорт 
	
	Результат = ПараметрыНечеткогоПоиска();
	
	Результат.СоответствиеРеквизитов.Вставить("Наименование", "Наименование");
	Результат.ВесаРеквизитов.Вставить("Наименование", 1);
	Результат.РеквизитыПолногоСоответствия.Добавить("Наименование");
	Результат.ВесаРеквизитовПредварительнойОценки.Вставить("Наименование", 1);
	
	Возврат Результат;
	
КонецФункции

Функция НечеткийПоиск(МетаданныеОбъекта, ЗначенияРаспознанныхРеквизитов, Отбор = Неопределено, ИдентификаторРезультата = "") Экспорт
	
	ЕстьОценкаПроизводительности = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности");
	Если ЕстьОценкаПроизводительности Тогда
		КлючеваяОперация = "РаспознаваниеДокументов.НечеткийПоиск";
		МодульОценкаПроизводительности = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительности");
		ВремяНачала = МодульОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	// Экранирование ЗначенияРаспознанныхРеквизитов от внутренних изменений.
	РаспознанныеРеквизиты = Новый Структура;
	Для Каждого ЭлементСтруктуры Из ЗначенияРаспознанныхРеквизитов Цикл
		РаспознанныеРеквизиты.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
	КонецЦикла;
	
	Если Метаданные.Перечисления.Содержит(МетаданныеОбъекта) Тогда 
		ПараметрыНечеткогоПоиска = ПараметрыНечеткогоПоискаПеречислений();
	Иначе
		ПараметрыНечеткогоПоиска = ПараметрыНечеткогоПоиска();
		
		РаспознаваниеДокументовПереопределяемый.ПриОпределенииПараметровНечеткогоПоиска(
			ПараметрыНечеткогоПоиска,
			МетаданныеОбъекта
		);
	КонецЕсли;
	
	// Предварительная очистка распознанных реквизитов.
	Если ПараметрыНечеткогоПоиска.ОтброситьДробнуюЧасть Тогда
		Для Каждого Реквизит Из РаспознанныеРеквизиты Цикл
			РаспознанныеРеквизиты[Реквизит.Ключ] = ОтброситьДробнуюЧасть(Реквизит.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Реквизит Из РаспознанныеРеквизиты Цикл
		РаспознанныеРеквизиты[Реквизит.Ключ] = ОчиститьСтроку(Реквизит.Значение);
	КонецЦикла;
	
	Кандидаты = КандидатыПоПредварительнойОценке(МетаданныеОбъекта, РаспознанныеРеквизиты, Отбор, ПараметрыНечеткогоПоиска);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Ссылка");
	Результат.Колонки.Добавить("ДополнительнаяСсылка");
	Результат.Колонки.Добавить("Коэффициент");
	
	Если Кандидаты.Количество() > 0 Тогда
		
		РанжированиеКандидатовПоСхожести(Кандидаты, РаспознанныеРеквизиты, ПараметрыНечеткогоПоиска);
		
		// 5 максимальных кандидатов в результат.
		Для Индекс = 0 По Мин(Кандидаты.Количество() - 1, 5) Цикл 
			НоваяСтрока = Результат.Добавить();
			НоваяСтрока.Ссылка = Кандидаты[Индекс].Ссылка;
			НоваяСтрока.ДополнительнаяСсылка = Кандидаты[Индекс].ДополнительнаяСсылка;
			НоваяСтрока.Коэффициент = Кандидаты[Индекс].Вес;
		КонецЦикла;
		
		Если Результат.Итог("Коэффициент") > 1 Тогда 
			НормализацияSoftmax(Результат, "Коэффициент", ПараметрыНечеткогоПоиска.Сигма);
		КонецЕсли;
		
		ИсключитьСтрокиСоЗначениемНиже(Результат, "Коэффициент", 0.04);
		
	КонецЕсли;
	
	Комментарий = Новый Структура;
	Комментарий.Вставить("ИдентификаторРезультата", ИдентификаторРезультата);
	Комментарий.Вставить("МетаданныеОбъекта", МетаданныеОбъекта.ПолноеИмя());
	Комментарий.Вставить("Распознано", ЗначенияРаспознанныхРеквизитов);
	Комментарий.Вставить("Результат", ТаблицаЗначенийВПримитивныйМассив(Результат));
	
	Если ЕстьОценкаПроизводительности Тогда
		МодульОценкаПроизводительности = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительности");
		МодульОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, , Комментарий);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция КандидатыПоПредварительнойОценке(МетаданныеОбъекта, РаспознанныеРеквизиты, Отбор, ПараметрыНечеткогоПоиска)
	
	Если Метаданные.Перечисления.Содержит(МетаданныеОбъекта) Тогда
		Запрос = ЗапросПредварительнойОценкиПеречислений(МетаданныеОбъекта, Отбор);
	Иначе
		КоличествоКандидатов = КоличествоЭлементовМетаданныхСОтбором(МетаданныеОбъекта, Отбор);
		Если КоличествоКандидатов <= ПараметрыНечеткогоПоиска.КоличествоКандидатовБыстройОценки Тогда
			Запрос = ЗапросПредварительнойОценкиБыстрый(МетаданныеОбъекта, РаспознанныеРеквизиты, Отбор, ПараметрыНечеткогоПоиска);
		Иначе
			Запрос = ЗапросПредварительнойОценки(МетаданныеОбъекта, РаспознанныеРеквизиты, Отбор, ПараметрыНечеткогоПоиска);
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(Запрос.Текст) Тогда 
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция КоличествоЭлементовМетаданныхСОтбором(МетаданныеОбъекта, Отбор)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(Кандидаты.Ссылка) КАК Количество
	|ИЗ
	|	&ИмяОбъектаМетаданного КАК Кандидаты
	|ГДЕ
	|	&ТекстОтбора";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИмяОбъектаМетаданного", МетаданныеОбъекта.ПолноеИмя());
	
	УстановитьОтбор(Запрос, Отбор, МетаданныеОбъекта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Количество;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Функция ЗапросПредварительнойОценкиБыстрый(МетаданныеОбъекта, РаспознанныеРеквизиты, Отбор, ПараметрыНечеткогоПоиска)
	
	Запрос = Новый Запрос;
	
	ВыбираемыеПоля = Новый Массив;
	
	ВыполнятьПоиск = Ложь;
	Для Каждого ВесРеквизита Из ПараметрыНечеткогоПоиска.ВесаРеквизитовПредварительнойОценки Цикл 
		ИмяРаспознанногоРеквизита = ПараметрыНечеткогоПоиска.СоответствиеРеквизитов[ВесРеквизита.Ключ];
		Если Не РаспознанныеРеквизиты.Свойство(ИмяРаспознанногоРеквизита) Тогда 
			Продолжить; // Свойство не было распознано и будет исключено из поиска.
		КонецЕсли;
		
		СтрокаПоиска = РаспознанныеРеквизиты[ИмяРаспознанногоРеквизита];
		Если СтрДлина(СтрокаПоиска) < ПараметрыНечеткогоПоиска.МинимальнаяДлинаСтрокиДляПоиска Тогда 
			Продолжить; // Слишком короткая строка для нечеткого поиска.
		КонецЕсли;
		
		Если ЭтоРеквизитНеограниченнойДлины(МетаданныеОбъекта, ВесРеквизита.Ключ) Тогда 
			ВыбираемыеПоля.Добавить(СтрШаблон("ВЫРАЗИТЬ(Кандидаты.%1 КАК Строка(1024)) КАК %1", ВесРеквизита.Ключ));
		Иначе
			ВыбираемыеПоля.Добавить(СтрШаблон("Кандидаты.%1 КАК %1", ВесРеквизита.Ключ))
		КонецЕсли;
		
		ВыполнятьПоиск = Истина;
	КонецЦикла;
	
	Если Не ВыполнятьПоиск Тогда
		Возврат Запрос;
	КонецЕсли;
	
	ТекстВыбираемыеПоля = СтрСоединить(ВыбираемыеПоля, ", " + Символы.ПС);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Кандидаты.Ссылка КАК Ссылка,
		|	НЕОПРЕДЕЛЕНО КАК ДополнительнаяСсылка,
		|	0 КАК Вес,
		|	&ТекстВыбираемыеПоля
		|ИЗ
		|	&ИмяОбъектаМетаданного КАК Кандидаты
		|ГДЕ
		|	&ТекстОтбора";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстВыбираемыеПоля", ТекстВыбираемыеПоля);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИмяОбъектаМетаданного", МетаданныеОбъекта.ПолноеИмя());
	
	УстановитьОтбор(Запрос, Отбор, МетаданныеОбъекта);
	
	Возврат Запрос;
	
КонецФункции

Функция ЭтоРеквизитНеограниченнойДлины(МетаданныеОбъекта, ИмяРеквизита)
	
	ОписаниеРеквизита = МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизита);
	Если ОписаниеРеквизита = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОписаниеТипа = ОписаниеРеквизита.Тип;
	Возврат ОписаниеТипа.СодержитТип(Тип("Строка")) И ОписаниеТипа.КвалификаторыСтроки.Длина = 0;
	
КонецФункции

Процедура УстановитьОтбор(Запрос, Отбор, МетаданныеОбъекта, УсловияПодобия = Неопределено)
	
	Если Отбор = Неопределено И МетаданныеОбъекта = Неопределено И УсловияПодобия = Неопределено Тогда
		ТекстОтбора = "ИСТИНА";
	Иначе
		
		Условия = Новый Массив;
		Условия.Добавить("НЕ ПометкаУдаления");
		Если ЭтоИерархическийОбъектМетаданных(МетаданныеОбъекта) Тогда 
			Условия.Добавить("НЕ ЭтоГруппа");
		КонецЕсли;
		Если ТипЗнч(УсловияПодобия) = Тип("Массив") Тогда
			Условия.Добавить(Символы.ПС + "(" + СтрСоединить(УсловияПодобия, Символы.ПС + "ИЛИ ") + ")");
		КонецЕсли;
		Если ТипЗнч(Отбор) = Тип("Массив") Тогда
			Для Каждого Условие Из Отбор Цикл
				Если ТипЗнч(Условие) = Тип("Структура") Тогда
					Поле = Условие.Свойство;
					СтрокаСравнения = Условие.ВидСравнения;
					ТребуемоеЗначение = Условие.Значение;
				ИначеЕсли ТипЗнч(Условие) = Тип("КлючИЗначение") Тогда
					Поле = Условие.Ключ;
					СтрокаСравнения = "=";
					ТребуемоеЗначение = Условие.Значение;
				Иначе
					ВызватьИсключение НСтр("ru = 'Неверный тип значения параметра Отбор, ожидалось <Структура> или <КлючИЗначение>'");
				КонецЕсли;
				
				Если СтрокаСравнения = "В" Тогда
					СтрокаУсловия = "Кандидаты." + Поле + " В (&" + Поле + ")";
				Иначе
					СтрокаУсловия = "Кандидаты." + Поле + " = &" + Поле;
				КонецЕсли;
				
				Условия.Добавить(СтрокаУсловия);
				Запрос.УстановитьПараметр(Поле, ТребуемоеЗначение);
			КонецЦикла;
		КонецЕсли;
		
		ТекстОтбора = СтрСоединить(Условия, " И ");
		
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстОтбора", ТекстОтбора);
	
КонецПроцедуры

Функция ЗапросПредварительнойОценкиПеречислений(МетаданныеОбъекта, Отбор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Кандидаты.Ссылка КАК Ссылка,
		|	НЕОПРЕДЕЛЕНО КАК ДополнительнаяСсылка,
		|	0 КАК Вес,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(Кандидаты.Ссылка) КАК Представление
		|ИЗ
		|	&ИмяОбъектаМетаданного КАК Кандидаты";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИмяОбъектаМетаданного", МетаданныеОбъекта.ПолноеИмя());
	
	Возврат Запрос;
	
КонецФункции

Функция ЗапросПредварительнойОценки(МетаданныеОбъекта, РаспознанныеРеквизиты, Отбор, ПараметрыНечеткогоПоиска) Экспорт
	
	// В общем случае подбор кандидатов с помощью LIKE работает плохо.
	//
	// Тем не менее можно получить приемлемый план запроса, выполнив предварительный отбор,
	// а затем уже выполнять ранжирование кандидатов по количеству вхождений НГрамм.
	//
	// Шаблон запроса имеет вид:
	//
	//	<...
	//	////////////////////////////////////////////////////////////////////////////////
	//	//
	//	// ТекстЗапросаНГраммы
	//	//
	//	ВЫБРАТЬ
	//		НГраммы.Значение КАК Значение,
	//		НГраммы.Вес КАК Вес
	//	ПОМЕСТИТЬ ВТ_НГраммы%Реквизит%
	//	ИЗ
	//		&НГраммы%Реквизит% КАК НГраммы
	//	;
	//	...>
	//	
	//	ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//		Кандидаты.Ссылка
	//		Неопределено КАК ДополнительнаяСсылка,
	//		<... Кандидаты.%Реквизит% КАК %Реквизит% ...> // ВыбираемыеПоля
	//		ПОМЕСТИТЬ ВТ_Кандидаты
	//	ИЗ
	//		%ИмяОбъектаМетаданного% Как Кандидаты
	//	ГДЕ
	//		(<... Кандидат.%Реквизит% ПОДОБНО %НГрамма% {ИЛИ} ...>) // УсловияПодобия
	//		{И НЕ ЭтоГруппа}
	//		{И НЕ ПометкаУдаления}
	//	;
	//	
	//	////////////////////////////////////////////////////////////////////////////////
	//	ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//		ВесаКандидатов.Ссылка КАК Ссылка,
	//		ВесаКандидатов.ДополнительнаяСсылка КАК ДополнительнаяСсылка,
	//		ВесаКандидатов.Вес КАК Вес
	//	ПОМЕСТИТЬ ВТ_ВесаКандидатов
	//	ИЗ
	//		(ВЫБРАТЬ ПЕРВЫЕ 200
	//			ВесаКандидатов.Ссылка КАК Ссылка,
	//			ВесаКандидатов.ДополнительнаяСсылка КАК ДополнительнаяСсылка,
	//			СУММА(ВесаКандидатов.Вес) КАК Вес
	//		ИЗ
	//			(
	//			<...
	//			//
	//			// ТекстЗапросаСуммаВесов
	//			//
	//			ВЫБРАТЬ
	//				СУММА(НГраммы.Вес) КАК Вес,
	//				Кандидаты.Ссылка КАК Ссылка,
	//				Кандидаты.ДополнительнаяСсылка КАК ДополнительнаяСсылка
	//			ИЗ
	//				ВТ_Кандидаты КАК Кандидаты
	//					ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НГраммы КАК НГраммы
	//					ПО (Кандидаты.%Реквизит% ПОДОБНО "%" + НГраммы%Реквизит%.Значение + "%")
	//			
	//			СГРУППИРОВАТЬ ПО
	//				Кандидаты.Ссылка
	//			
	//			{ОБЪЕДИНИТЬ ВСЕ}
	//			...>
	//			) КАК ВесаКандидатов
	//		ГДЕ
	//			ВесаКандидатов.Вес > 0
	//		СГРУППИРОВАТЬ ПО
	//			ВесаКандидатов.Ссылка,
	//			ВесаКандидатов.ДополнительнаяСсылка) КАК ВесаКандидатов
	//	;
	//	
	//	////////////////////////////////////////////////////////////////////////////////
	//	ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//		ВесаКандидатов.Ссылка КАК Ссылка,
	//		ВесаКандидатов.ДополнительнаяСсылка КАК ДополнительнаяСсылка,
	//		ВесаКандидатов.Вес КАК Вес,
	//		<... Кандидаты.%Реквизит% КАК %Реквизит% ...> // ВыбираемыеПоля
	//	ИЗ
	//		ВТ_ВесаКандидатов Как Кандидаты
	//			ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Кандидаты КАК Кандидаты
	//			ПО (Кандидаты.Ссылка = ВесаКандидатов.Ссылка)
	//				И (Кандидаты.ДополнительнаяСсылка = ВесаКандидатов.ДополнительнаяСсылка)

	Запрос = Новый Запрос;
	ТекстыЗапросов = Новый Массив;
	
	ВыбираемыеПоля = Новый Массив;
	УсловияПодобия = Новый Массив;
	ТекстыЗапросовСуммаВесов = Новый Массив;
	
	ВыполнятьПоиск = Ложь;
	Для Каждого ВесРеквизита Из ПараметрыНечеткогоПоиска.ВесаРеквизитовПредварительнойОценки Цикл 
		
		ИмяРаспознанногоРеквизита = ПараметрыНечеткогоПоиска.СоответствиеРеквизитов[ВесРеквизита.Ключ];
		Если Не РаспознанныеРеквизиты.Свойство(ИмяРаспознанногоРеквизита) Тогда 
			Продолжить; // Свойство не было распознано и будет исключено из поиска.
		КонецЕсли;
		
		СтрокаПоиска = РаспознанныеРеквизиты[ИмяРаспознанногоРеквизита];
		
		Если СтрДлина(СтрокаПоиска) < ПараметрыНечеткогоПоиска.МинимальнаяДлинаСтрокиДляПоиска Тогда 
			Продолжить; // Слишком короткая строка для нечеткого поиска.
		КонецЕсли;
		
		НГраммы = СтрокаВНГраммы(СтрокаПоиска, ПараметрыНечеткогоПоиска, Истина);
		
		Если НГраммы.Количество() = 0 Тогда 
			// Если нет больших НГрамм, то НГраммой выступает полная очищенная строка.
			Строка = НГраммы.Добавить();
			Строка.Значение = СтрокаПоиска;
			Строка.Вес = ПараметрыНечеткогоПоиска.ВесДлиннойНГраммы;
		КонецЕсли;
		
		Для Каждого НГрамма Из НГраммы Цикл 
			УсловияПодобия.Добавить(
				СтрШаблон(
					"%1 ПОДОБНО ""%%%2%%""", 
					ВесРеквизита.Ключ, 
					НГрамма.Значение
				)
			);
		КонецЦикла;
		
		Если ЭтоРеквизитНеограниченнойДлины(МетаданныеОбъекта, ВесРеквизита.Ключ) Тогда 
			ВыбираемыеПоля.Добавить(СтрШаблон("ВЫРАЗИТЬ(Кандидаты.%1 КАК Строка(1024)) КАК %1", ВесРеквизита.Ключ));
		Иначе
			ВыбираемыеПоля.Добавить(СтрШаблон("Кандидаты.%1 КАК %1", ВесРеквизита.Ключ))
		КонецЕсли;
		
		ТекстыЗапросов.Добавить(ТекстЗапросаНГраммы(ВесРеквизита.Ключ));
		Запрос.УстановитьПараметр(СтрШаблон("НГраммы%1", ВесРеквизита.Ключ), НГраммы);
		
		ТекстыЗапросовСуммаВесов.Добавить(ТекстЗапросаСуммаВесов(ВесРеквизита.Ключ));
		
		ВыполнятьПоиск = Истина;
	КонецЦикла;
	
	Если Не ВыполнятьПоиск Тогда 
		Возврат Запрос;
	КонецЕсли;
	
	ТекстВыбираемыеПоля = СтрСоединить(ВыбираемыеПоля, ", " + Символы.ПС);
	
	ТекстЗапросаКандидаты = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Кандидаты.Ссылка КАК Ссылка,
		|	&ТекстПоляДополнительнаяСсылка КАК ДополнительнаяСсылка,
		|	&ТекстВыбираемыеПоля
		|ПОМЕСТИТЬ ВТ_Кандидаты
		|ИЗ
		|	&ИмяОбъектаМетаданного КАК Кандидаты
		|ГДЕ
		|	&ТекстОтбора
		|;";
		
	Если ПустаяСтрока(ПараметрыНечеткогоПоиска.ТекстЗапросаКандидаты) Тогда
		
		ТекстЗапросаКандидаты = СтрЗаменить(
			ТекстЗапросаКандидаты,
			"&ТекстПоляДополнительнаяСсылка",
			"Неопределено"
		);
		
		ТекстЗапросаКандидаты = СтрЗаменить(
			ТекстЗапросаКандидаты,
			"&ИмяОбъектаМетаданного",
			МетаданныеОбъекта.ПолноеИмя()
		);
		
	Иначе 
		
		ТекстЗапросаКандидаты = СтрЗаменить(
			ТекстЗапросаКандидаты,
			"&ТекстПоляДополнительнаяСсылка",
			"Кандидаты.ДополнительнаяСсылка"
		);
		
		ТекстЗапросаКандидаты = СтрЗаменить(
			ТекстЗапросаКандидаты,
			"&ИмяОбъектаМетаданного",
			"(" + ПараметрыНечеткогоПоиска.ТекстЗапросаКандидаты + ")"
		);
		
	КонецЕсли;
	
	ТекстЗапросаКандидаты = СтрЗаменить(
		ТекстЗапросаКандидаты,
		"&ТекстВыбираемыеПоля",
		ТекстВыбираемыеПоля
	);
	
	ТекстыЗапросов.Добавить(ТекстЗапросаКандидаты);
	
	ТекстЗапросовСуммаВесов = СтрСоединить(ТекстыЗапросовСуммаВесов, Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС);
	
	ТекстЗапросаРанжирование = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВесаКандидатов.Ссылка КАК Ссылка,
		|	ВесаКандидатов.ДополнительнаяСсылка КАК ДополнительнаяСсылка,
		|	ВесаКандидатов.Вес КАК Вес
		|ПОМЕСТИТЬ ВТ_ВесаКандидатов
		|ИЗ
		|	(ВЫБРАТЬ ПЕРВЫЕ 200
		|		ВесаКандидатов.Ссылка КАК Ссылка,
		|		ВесаКандидатов.ДополнительнаяСсылка КАК ДополнительнаяСсылка,
		|		СУММА(ВесаКандидатов.Вес) КАК Вес
		|	ИЗ
		|		&ТекстЗапросовСуммаВесов КАК ВесаКандидатов
		|	ГДЕ
		|		ВесаКандидатов.Вес > 0
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ВесаКандидатов.Ссылка,
		|		ВесаКандидатов.ДополнительнаяСсылка
		|	
		|	УПОРЯДОЧИТЬ ПО
		|		Вес УБЫВ) КАК ВесаКандидатов
		|;";
	
	ТекстЗапросаРанжирование = СтрЗаменить(
		ТекстЗапросаРанжирование,
		"&ТекстЗапросовСуммаВесов",
		"(" + ТекстЗапросовСуммаВесов + ")"
	);
	
	ТекстыЗапросов.Добавить(ТекстЗапросаРанжирование);
	
	ТекстЗапросаРезультат = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВесаКандидатов.Ссылка КАК Ссылка,
		|	ВесаКандидатов.ДополнительнаяСсылка КАК ДополнительнаяСсылка,
		|	ВесаКандидатов.Вес КАК Вес,
		|	&ТекстВыбираемыеПоля
		|ИЗ
		|	ВТ_ВесаКандидатов КАК ВесаКандидатов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Кандидаты КАК Кандидаты
		|		ПО (Кандидаты.Ссылка = ВесаКандидатов.Ссылка)
		|			И (Кандидаты.ДополнительнаяСсылка = ВесаКандидатов.ДополнительнаяСсылка)";
	
	ТекстЗапросаРезультат = СтрЗаменить(
		ТекстЗапросаРезультат,
		"&ТекстВыбираемыеПоля",
		ТекстВыбираемыеПоля
	);
	
	ТекстыЗапросов.Добавить(ТекстЗапросаРезультат);
	
	Запрос.Текст = СтрСоединить(ТекстыЗапросов, Символы.ПС + Символы.ПС);
	
	УстановитьОтбор(Запрос, Отбор, МетаданныеОбъекта, УсловияПодобия);
	
	Возврат Запрос;
	
КонецФункции

Функция ЭтоИерархическийОбъектМетаданных(МетаданныеОбъекта)
	
	Если Метаданные.Справочники.Содержит(МетаданныеОбъекта) Тогда
		Результат = МетаданныеОбъекта.Иерархический
			И МетаданныеОбъекта.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов;
		
	ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеОбъекта) Тогда
		Результат = МетаданныеОбъекта.Иерархический;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТекстЗапросаНГраммы(ИмяРеквизита)
	
	Возврат СтрШаблон("
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НГраммы.Значение,
		|	НГраммы.Вес
		|ПОМЕСТИТЬ ВТ_НГраммы%1
		|ИЗ
		|	&НГраммы%1 КАК НГраммы
		|;",
		ИмяРеквизита);
	
КонецФункции

Функция ТекстЗапросаСуммаВесов(ИмяРеквизита)
	
	Возврат СтрШаблон("
		|////////////////////////////////////////////////////////////////////////////////
		|	ВЫБРАТЬ
		|	СУММА(НГраммы.Вес) КАК Вес,
		|	Кандидаты.Ссылка КАК Ссылка,
		|	Кандидаты.ДополнительнаяСсылка КАК ДополнительнаяСсылка
		|ИЗ
		|	ВТ_Кандидаты КАК Кандидаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НГраммы%1 КАК НГраммы
		|		ПО (Кандидаты.%1 ПОДОБНО ""%%"" + НГраммы.Значение + ""%%"")
		|СГРУППИРОВАТЬ ПО
		|	Кандидаты.Ссылка,
		|	Кандидаты.ДополнительнаяСсылка",
		ИмяРеквизита);
	
КонецФункции

Процедура РанжированиеКандидатовПоСхожести(Кандидаты, РаспознанныеРеквизиты, ПараметрыНечеткогоПоиска) Экспорт
	
	// Ожидается, что ко всем РаспознанныеРеквизиты уже применено ОчиститьСтроку.
	
	// Предварительный оптический хэш распознанных реквизитов.
	Для Каждого Реквизит Из РаспознанныеРеквизиты Цикл
		РаспознанныеРеквизиты[Реквизит.Ключ] = ОптическийХэш(Реквизит.Значение);
	КонецЦикла;
	
	НормировочныйКоэффициент = 0;
	Для Каждого Реквизит Из РаспознанныеРеквизиты Цикл 
		Если Не ПустаяСтрока(Реквизит.Значение) И ПараметрыНечеткогоПоиска.ВесаРеквизитов.Свойство(Реквизит.Ключ) Тогда 
			НормировочныйКоэффициент = НормировочныйКоэффициент
				+ ПараметрыНечеткогоПоиска.ВесаРеквизитов[Реквизит.Ключ];
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Кандидат Из Кандидаты Цикл 
		
		ОценкиПоРеквизитам = Новый Структура;
		
		Для Каждого Реквизит Из ПараметрыНечеткогоПоиска.СоответствиеРеквизитов Цикл 
			
			Если Не РаспознанныеРеквизиты.Свойство(Реквизит.Значение) Тогда
				Продолжить;  // Свойство не было распознано и будет исключено из поиска.
			КонецЕсли;
			
			Если Кандидаты.Колонки.Найти(Реквизит.Ключ) = Неопределено Тогда 
				Продолжить;  // Свойство не было выбрано из базы и будет исключено из поиска.
			КонецЕсли;
			
			ЗначениеРеквизитаКандидата = Кандидат[Реквизит.Ключ];
			Если Не ЗначениеЗаполнено(ЗначениеРеквизитаКандидата) Тогда
				// Пустую дату и т.д. заменяем на пустую строку
				ЗначениеРеквизитаКандидата = "";
			Иначе
				ЗначениеРеквизитаКандидата = ОптическийХэш(ОчиститьСтроку(ЗначениеРеквизитаКандидата));
			КонецЕсли;
			
			СтрокаПоиска = РаспознанныеРеквизиты[Реквизит.Значение];
			
			ЭтоРеквизитПолногоСоответствия =
				(ПараметрыНечеткогоПоиска.РеквизитыПолногоСоответствия.Найти(Реквизит.Ключ) <> Неопределено);
			
			Если ЭтоРеквизитПолногоСоответствия И ЗначениеРеквизитаКандидата = СтрокаПоиска Тогда 
				ОценкаПолногоСоответствия = ПараметрыНечеткогоПоиска.ВажностьПолногоСоответствия;
			Иначе
				ОценкаПолногоСоответствия = 0;
			КонецЕсли;
			
			Оценка = СимметричнаяСхожестьСтрок(
				ЗначениеРеквизитаКандидата,
				СтрокаПоиска,
				ПараметрыНечеткогоПоиска
			);
			Оценка = Оценка + ОценкаПолногоСоответствия * НормировочныйКоэффициент / ПараметрыНечеткогоПоиска.ВесаРеквизитов[Реквизит.Значение];
			
			Если ОценкиПоРеквизитам.Свойство(Реквизит.Значение) Тогда 
				Если ОценкиПоРеквизитам[Реквизит.Значение] < Оценка Тогда 
					ОценкиПоРеквизитам[Реквизит.Значение] = Оценка;
				КонецЕсли;
			Иначе 
				ОценкиПоРеквизитам.Вставить(Реквизит.Значение, Оценка);
			КонецЕсли;
			
		КонецЦикла;
		
		СуммарнаяОценка = 0;
		
		Для Каждого Оценка Из ОценкиПоРеквизитам Цикл 
			СуммарнаяОценка = СуммарнаяОценка
				+ Оценка.Значение * ПараметрыНечеткогоПоиска.ВесаРеквизитов[Оценка.Ключ];
		КонецЦикла;
		
		Если НормировочныйКоэффициент = 0 Тогда 
			Кандидат.Вес = 0;
		Иначе
			Кандидат.Вес = СуммарнаяОценка / НормировочныйКоэффициент;
		КонецЕсли;
		
	КонецЦикла;
	
	Кандидаты.Сортировать("Вес Убыв");
	
КонецПроцедуры

Функция СимметричнаяСхожестьСтрок(Строка1, Строка2, ПараметрыНечеткогоПоиска) Экспорт
	
	// Ожидается, что к Строка1 и Строка2 уже применено ОчиститьСтроку.
	
	Оценка = СхожестьСтрок(Строка1, Строка2, ПараметрыНечеткогоПоиска)
		   + СхожестьСтрок(Строка2, Строка1, ПараметрыНечеткогоПоиска);
	
	Возврат 0.5 * Оценка;
	
КонецФункции

Функция СхожестьСтрок(Знач Строка1, Знач Строка2, ПараметрыНечеткогоПоиска) Экспорт
	
	// Ожидается, что к Строка1 и Строка2 уже применено ОчиститьСтроку.
	
	Если ПустаяСтрока(Строка1) Или ПустаяСтрока(Строка2) Тогда 
		Возврат 0;
	КонецЕсли;
	
	НГраммы = СтрокаВНГраммы(Строка2, ПараметрыНечеткогоПоиска);
	
	ТолькоОднаНГрамма = (НГраммы.Количество() = 1);
	
	Оценка = 0;
	Для Каждого НГрамма Из НГраммы Цикл 
		
		Если СтрНайти(Строка1, НГрамма.Значение) Тогда 
			ДлинаСтроки = СтрДлина(Строка1);
			
			Если ДлинаСтроки > 2 Или ТолькоОднаНГрамма Тогда 
				Оценка = Оценка + НГрамма.Вес;
			ИначеЕсли ДлинаСтроки = 2 Тогда 
				Оценка = Оценка + 0.5*НГрамма.Вес;
			Иначе
				Оценка = Оценка + 0.1*НГрамма.Вес;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СуммаОценок = НГраммы.Итог("Вес");
	Если СуммаОценок = 0 Тогда 
		Возврат 0;
	КонецЕсли;
	Оценка = Оценка / СуммаОценок;
	
	Возврат Окр(Оценка*(1 - 1/(0.1 + СтрДлина(Строка2))), 6);
	
КонецФункции

Функция СтрокаВНГраммы(Строка, ПараметрыНечеткогоПоиска, ТолькоДлинныеНГраммы = Ложь) Экспорт
	
	// Ожидается, что к Строка уже применено ОчиститьСтроку.
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Значение", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(30)));
	Результат.Колонки.Добавить("Вес", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 2)));
	
	Слова = СтрРазделить(Строка, " ");
	
	Для Каждого Слово Из Слова Цикл 
		
		НГраммы = СловоВНГраммы(Слово);
		
		Если Не ТолькоДлинныеНГраммы Тогда 
			Для Каждого НГрамма Из НГраммы.КороткиеНГраммы Цикл 
				СтрокаТаблицы = Результат.Добавить();
				СтрокаТаблицы.Значение = НГрамма;
				СтрокаТаблицы.Вес = ПараметрыНечеткогоПоиска.ВесКороткойНГраммы;
			КонецЦикла;
		КонецЕсли;
		
		Для Каждого НГрамма Из НГраммы.ДлинныеНГраммы Цикл 
			СтрокаТаблицы = Результат.Добавить();
			СтрокаТаблицы.Значение = НГрамма;
			СтрокаТаблицы.Вес = ПараметрыНечеткогоПоиска.ВесДлиннойНГраммы;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СловоВНГраммы(Слово) Экспорт
	
	// "рога" -> ['рог', 'ога'], ['рога']
	// "копыта" -> ['коп', 'пыт', 'ыта'], ['копыт', 'пыта']
	// "василеостровская" -> ['васил', 'леост', 'тровс', 'вская'], ['василеост', 'леостровс', 'тровская']
	
	Результат = Новый Структура;
	Результат.Вставить("КороткиеНГраммы", Новый Массив);
	Результат.Вставить("ДлинныеНГраммы", Новый Массив);
	
	Если ПустаяСтрока(Слово) Тогда 
		Возврат Результат;
	КонецЕсли;
	
	ДлинаНГраммы = Цел(Pow(СтрДлина(Слово), 0.5));
	
	Индекс = 0;
	Пока Индекс + 2 * ДлинаНГраммы <= СтрДлина(Слово) Цикл 
		КороткаяНГрамма = Сред(Слово, Индекс + 1, ДлинаНГраммы + 1);
		ДлиннаяНГрамма  = Сред(Слово, Индекс + 1, 2*ДлинаНГраммы + 1);
		
		Если СтрДлина(КороткаяНГрамма) > 1 Тогда 
			Результат.КороткиеНГраммы.Добавить(КороткаяНГрамма);
		КонецЕсли;
		
		Если СтрДлина(ДлиннаяНГрамма) > 2 Тогда 
			Результат.ДлинныеНГраммы.Добавить(ДлиннаяНГрамма);
		КонецЕсли;
		
		Индекс = Индекс + ДлинаНГраммы;
	КонецЦикла;
	
	Если ДлинаНГраммы > 1 Тогда 
		Результат.КороткиеНГраммы.Добавить(Прав(Слово, ДлинаНГраммы + 1));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОптическийХэш(Строка) Экспорт
		
	СтроительСтроки = Новый Массив;
	
	Для Индекс = 1 По СтрДлина(Строка) Цикл
		
		КодТекущегоСимвола = КодСимвола(Строка, Индекс);
		ТекущийСимвол = Символ(КодТекущегоСимвола);
		
		Если ТекущийСимвол = "c" Или ТекущийСимвол = "с" Тогда
			СтроительСтроки.Добавить("c");
		ИначеЕсли ТекущийСимвол = "o" Или ТекущийСимвол = "о" Или ТекущийСимвол = "0"
			Или ТекущийСимвол = "q" Или ТекущийСимвол = "g" Тогда
			СтроительСтроки.Добавить("o");
		ИначеЕсли ТекущийСимвол = "t" Или ТекущийСимвол = "т" Тогда
			СтроительСтроки.Добавить("т");
		ИначеЕсли ТекущийСимвол = "е" Или ТекущийСимвол = "ё" Или ТекущийСимвол = "e" Тогда
			СтроительСтроки.Добавить("е");
		ИначеЕсли ТекущийСимвол = "н" Или ТекущийСимвол = "h" Тогда
			СтроительСтроки.Добавить("н");
		ИначеЕсли ТекущийСимвол = "n" Или ТекущийСимвол = "п" Или ТекущийСимвол = "л" Тогда
			СтроительСтроки.Добавить("п");
		ИначеЕсли ТекущийСимвол = "x" Или ТекущийСимвол = "х"
			Или ТекущийСимвол = "k" Или ТекущийСимвол = "к" Тогда
			СтроительСтроки.Добавить("x");
		ИначеЕсли ТекущийСимвол = "r" Или ТекущийСимвол = "г" Тогда
			СтроительСтроки.Добавить("г");
		ИначеЕсли ТекущийСимвол = "м" Или ТекущийСимвол = "m" Тогда
			СтроительСтроки.Добавить("м");
		ИначеЕсли ТекущийСимвол = "y" Или ТекущийСимвол = "у"
			Или ТекущийСимвол = "и" Или ТекущийСимвол = "й"
			Или ТекущийСимвол = "u" Или ТекущийСимвол = "ц" Тогда
			СтроительСтроки.Добавить("и");
		ИначеЕсли ТекущийСимвол = "w" Или ТекущийСимвол = "ш" Или ТекущийСимвол = "щ" Тогда
			СтроительСтроки.Добавить("ш");
		ИначеЕсли ТекущийСимвол = "b" Или ТекущийСимвол = "ь"
			Или ТекущийСимвол = "ъ" Или ТекущийСимвол = "б"
			Или ТекущийСимвол = "p" Или ТекущийСимвол = "р"
			Или ТекущийСимвол = "в" Или ТекущийСимвол = "з"
			Или ТекущийСимвол = "3" Или ТекущийСимвол = "э"
			Или ТекущийСимвол = "а" Или ТекущийСимвол = "a" Тогда
			СтроительСтроки.Добавить("э");
		ИначеЕсли ТекущийСимвол = "1" Или ТекущийСимвол = "l"
			Или ТекущийСимвол = "i" Или ТекущийСимвол = "j" Тогда
			СтроительСтроки.Добавить("1");
		Иначе
			СтроительСтроки.Добавить(ТекущийСимвол);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтрСоединить(СтроительСтроки);
	
КонецФункции

Функция ОтброситьДробнуюЧасть(Знач Строка) Экспорт
	
	Строка = СокрЛП(Строка); // Нужно брать строку до очистки (удаления запятых)
	Позиция = СтрНайти(Строка, ",");
	Если Позиция > 0 Тогда 
		Строка = Лев(Строка, Позиция - 1);
	КонецЕсли;
	Позиция = СтрНайти(Строка, ".");
	Если Позиция > 0 Тогда 
		Строка = Лев(Строка, Позиция - 1);
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

Функция ОчиститьСтроку(Строка) Экспорт
	
	СтрокаНРег = НРег(Строка);
	СтроительСтроки = Новый Массив;
	
	ДобавитьПробел = Истина;
	Для Индекс = 1 По СтрДлина(СтрокаНРег) Цикл
		
		КодТекущегоСимвола = КодСимвола(СтрокаНРег, Индекс);
		
		Если КодТекущегоСимвола >= 48 И КодТекущегоСимвола <= 57
			Или КодТекущегоСимвола >= 97 И КодТекущегоСимвола <= 122
			Или КодТекущегоСимвола >= 1072 И КодТекущегоСимвола <= 1103
			Или КодТекущегоСимвола = 1105 Тогда
			// a-zа-яё0-9
			
			СтроительСтроки.Добавить(Символ(КодТекущегоСимвола));
			ДобавитьПробел = Истина;
		Иначе 
			Если ДобавитьПробел Тогда 
				СтроительСтроки.Добавить(" ");
				ДобавитьПробел = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Результат = СтрСоединить(СтроительСтроки);
	
	Для Каждого Подстрока Из ИсключаемыеПодстроки() Цикл
		Результат = СтрЗаменить(Результат, " " + Подстрока + " ", " ");
		
		ДлинаЗамены = СтрДлина(Подстрока) + 1; // +1, т.к. добавляем пробел слева или справа
		Если Лев(Результат, ДлинаЗамены) = Подстрока + " " Тогда
			Результат = Сред(Результат, ДлинаЗамены + 1);
		КонецЕсли;
		Если Прав(Результат, ДлинаЗамены) = " " + Подстрока Тогда
			Результат = Лев(Результат, СтрДлина(Результат) - ДлинаЗамены);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СокрЛП(Результат);
	
КонецФункции

Функция ИсключаемыеПодстроки()
	
	ОрганизационныеФормы = РаспознаваниеДокументовСлужебный.ЮрФизЛицоПоОрганизационнойФорме();
	
	Результат = Новый Массив;
	Для Каждого Элемент Из ОрганизационныеФормы Цикл
		Результат.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура НормализацияSoftmax(Таблица, ИмяКолонки, Сигма)
	
	МаксимальноеЗначение = 0;
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если МаксимальноеЗначение < СтрокаТаблицы[ИмяКолонки] Тогда
			МаксимальноеЗначение = СтрокаТаблицы[ИмяКолонки];
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы[ИмяКолонки] = Exp((СтрокаТаблицы[ИмяКолонки] - МаксимальноеЗначение) * Сигма);
	КонецЦикла;
	
	СуммаКоэффициентов = Таблица.Итог(ИмяКолонки);
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы[ИмяКолонки] = СтрокаТаблицы[ИмяКолонки] / СуммаКоэффициентов;
	КонецЦикла;
	
КонецПроцедуры

Процедура ИсключитьСтрокиСоЗначениемНиже(Таблица, ИмяКолонки, Значение) Экспорт
	
	Количество = Таблица.Количество();
	Индекс = Количество;
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Если Таблица[Индекс][ИмяКолонки] <= Значение Тогда
			Таблица.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ТаблицаЗначенийВПримитивныйМассив(Таблица)
	
	ЗначенияВМассиве = ОбщегоНазначения.ТаблицаЗначенийВМассив(Таблица);
	Результат = Новый Массив;
	
	Для Индекс = 0 По Мин(ЗначенияВМассиве.ВГраница(), 2) Цикл
		Строка = ЗначенияВМассиве[Индекс];
		Для Каждого Колонка Из Строка Цикл 
			Если Не РаспознаваниеДокументовКлиентСервер.ЭтоПримитивныйТип(ТипЗнч(Колонка.Значение)) Тогда 
				Строка.Вставить(Колонка.Ключ, Представление100(Колонка.Значение));
			КонецЕсли;
			Если ТипЗнч(Колонка.Значение) = Тип("Число") Тогда 
				Строка.Вставить(Колонка.Ключ, Окр(Колонка.Значение, 3));
			КонецЕсли;
		КонецЦикла;
		Результат.Добавить(Строка);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция Представление100(Значение)
	
	Представление = Строка(Значение);
	Если СтрДлина(Представление) > 100 Тогда 
		Представление = Лев(Представление, 97) + "...";
	КонецЕсли;
	Возврат Представление;
	
КонецФункции

#КонецОбласти
