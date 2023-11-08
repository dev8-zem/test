
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Параметры.Подписчик) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Подписчик) = Тип("СправочникСсылка.Партнеры") Тогда
		Подписчик = Параметры.Подписчик;
	Иначе
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	ПравоИзменения = ПравоДоступа("Изменение", Метаданные.Справочники.ПодпискиНаРассылкиИОповещенияКлиентам);
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ТаблицаПодписокПодписаться");
	МассивЭлементов.Добавить("ТаблицаПодписокОтменитьПодписку");
	МассивЭлементов.Добавить("ТаблицаПодписокРедактировать");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Видимость", ПравоИзменения);
	
	ГруппыРассылокИОповещений.ЗагрузитьЗначения(Параметры.ГруппыРассылокИОповещений.ВыгрузитьЗначения());
	
	АвторизованВнешнийПользователь = ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь();
	УправлениеВидимостью();
	
	ЗаполнитьТаблицуПодписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПодпискиНаРассылкиИОповещенияКлиентам"
		И Параметр.Свойство("Подписчик")
		И Параметр.Подписчик = Подписчик Тогда
		ЗаполнитьТаблицуПодписок();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиТаблицаПодписок

&НаКлиенте
Процедура ТаблицаПодписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ТаблицаПодписок.НайтиПоИдентификатору(ВыбраннаяСтрока);
		
	РедактироватьПодписку(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьПодписку(ТекущиеДанные)

	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Принудительная Тогда
		ТекстПредупреждения = НСтр("ru = 'Для принудительных групп рассылок и оповещений подписки не настраиваются.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	РассылкиИОповещенияКлиентамКлиент.РедактироватьПодписку(ТекущиеДанные.ПодпискаСсылка,
	                                                        Подписчик,
	                                                        ТекущиеДанные.ГруппаРассылокИОповещений,
	                                                        ЭтотОбъект,
	                                                        Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПодписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПодписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подписаться(Команда)
	
	МассивКПодписке = Новый Массив;
	ВыделенныеСтроки = Элементы.ТаблицаПодписок.ВыделенныеСтроки;
	КоличествоКПодписке = ВыделенныеСтроки.Количество();
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		ТекущиеДанные = ТаблицаПодписок.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Если ТекущиеДанные = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		
		Если (НЕ ТекущиеДанные.Подписан) И НЕ ТекущиеДанные.Принудительная Тогда
			Если ТекущиеДанные.ПодпискаСсылка.Пустая() Тогда
				
				МассивКПодписке.Добавить(Новый Структура("Подписчик, ГруппаРассылокИОповещений",
				                                         Подписчик,
				                                         ТекущиеДанные.ГруппаРассылокИОповещений));
				
			Иначе
				МассивКПодписке.Добавить(ТекущиеДанные.ПодпискаСсылка);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивКПодписке.Количество() > 0 Тогда
		
		ОформитьПодпискуДляМассива(МассивКПодписке);
		
		ТекстОповещения = НСтр("ru = 'Подписка'");
		ТекстПояснения  = НСтр("ru = 'Подписка выполнена для %1 из %2 групп рассылок и оповещений.'");
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПояснения,
		                                                                         МассивКПодписке.Количество(),
		                                                                         КоличествоКПодписке);
		
	Иначе
		
		ТекстОповещения = НСтр("ru = 'Подписки не выполнены'");
		ТекстПояснения  = НСтр("ru = 'Нет групп рассылок и оповещений для которых необходимо выполнить подписку'");
		
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстОповещения, , ТекстПояснения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПодписку(Команда)
	
	МассивКОтменеПодписки = Новый Массив;
	
	ВыделенныеСтроки = Элементы.ТаблицаПодписок.ВыделенныеСтроки;
	КоличествоПодписокКОтмене = ВыделенныеСтроки.Количество();
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		ТекущиеДанные = ТаблицаПодписок.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Если ТекущиеДанные = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		
		Если ТекущиеДанные.Подписан И (НЕ ТекущиеДанные.Принудительная) Тогда
			МассивКОтменеПодписки.Добавить(ТекущиеДанные.ПодпискаСсылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивКОтменеПодписки.Количество() > 0 Тогда
		
		ОтменитьПодпискуДляМассива(МассивКОтменеПодписки);
		
		ТекстОповещения = НСтр("ru = 'Отмена подписок'");
		ТекстПояснения  = НСтр("ru = 'Подписка отменена для %1 из %2 групп рассылок и оповещений.'");
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПояснения,
		                                                                         МассивКОтменеПодписки.Количество(),
		                                                                         КоличествоПодписокКОтмене);
		
	Иначе
		
		ТекстОповещения = НСтр("ru = 'Подписки не отменены'");
		ТекстПояснения  = НСтр("ru = 'Нет групп рассылок и оповещений для которых необходимо отменять подписку'");
		
	КонецЕсли;
		
	ПоказатьОповещениеПользователя(ТекстОповещения, , ТекстПояснения);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьТаблицуПодписок();
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаПодписок.ТекущиеДанные;
	РедактироватьПодписку(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Принудительная и адресаты не настроены
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаПодписокАдресаты.Имя);
	
	ГруппаОтбораИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаПодписок.Принудительная");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаПодписок.Адресаты");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПодписок()

	ТаблицаПодписок.Очистить();
	
	Запрос = Новый Запрос;
	
	ТекстЗапросаПодписки = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГруппыРассылокИОповещений.Ссылка КАК ГруппаРассылокИОповещений,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПодпискиНаРассылкиИОповещенияКлиентам.ПодпискаДействует, ЛОЖЬ) = ИСТИНА
	|			ТОГДА &Действует
	|		ИНАЧЕ &Приостановлена
	|	КОНЕЦ КАК Подписка,
	|	ЕСТЬNULL(ПодпискиНаРассылкиИОповещенияКлиентам.КоличествоКонтактныхЛицАдресатов, 0) КАК КоличествоДопАдресатов,
	|	ЕСТЬNULL(ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьПартнеру, ЛОЖЬ) КАК ОтправлятьПартнеру,
	|	ЕСТЬNULL(ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьКонтактномуЛицуОбъектаОповещения, ЛОЖЬ) КАК ОтправлятьКонтактномуЛицуОбъектаОповещения,
	|	ЛОЖЬ КАК ОтравлятьКонтактнымЛицаРоли,
	|	"""" КАК НаименованиеРолиКонтактногоЛица,
	|	ВЫБОР
	|		КОГДА ГруппыРассылокИОповещений.ПредназначенаДляЭлектронныхПисем
	|				И ГруппыРассылокИОповещений.ПредназначенаДляSMS
	|			ТОГДА &ДляПисемИSMS
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ГруппыРассылокИОповещений.ПредназначенаДляЭлектронныхПисем
	|					ТОГДА &ДляПисем
	|				ИНАЧЕ &ДляSMS
	|			КОНЕЦ
	|	КОНЕЦ КАК СпособОтправки,
	|	ГруппыРассылокИОповещений.Наименование КАК Наименование,
	|	ГруппыРассылокИОповещений.Принудительная,
	|	ЕСТЬNULL(ПодпискиНаРассылкиИОповещенияКлиентам.Ссылка, ЗНАЧЕНИЕ(Справочник.ПодпискиНаРассылкиИОповещенияКлиентам.ПустаяСсылка)) КАК ПодпискаСсылка,
	|	ЕСТЬNULL(ПодпискиНаРассылкиИОповещенияКлиентам.ПодпискаДействует, ЛОЖЬ) КАК Подписан,
	|	ГруппыРассылокИОповещений.Описание
	|ИЗ
	|	Справочник.ГруппыРассылокИОповещений КАК ГруппыРассылокИОповещений
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодпискиНаРассылкиИОповещенияКлиентам КАК ПодпискиНаРассылкиИОповещенияКлиентам
	|		ПО (ПодпискиНаРассылкиИОповещенияКлиентам.ГруппаРассылокИОповещений = ГруппыРассылокИОповещений.Ссылка)
	|			И (ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = &Подписчик)
	|			И (НЕ ПодпискиНаРассылкиИОповещенияКлиентам.ПометкаУдаления)
	|ГДЕ
	|	НЕ ГруппыРассылокИОповещений.Принудительная
	|	И НЕ ГруппыРассылокИОповещений.ПометкаУдаления";
	
	ТекстОбъединить = "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|";
	
	ТекстЗапросаПринудительные = "
	|ВЫБРАТЬ
	|	ГруппыРассылокИОповещений.Ссылка,
	|	&Принудительная,
	|	0 КАК КоличествоДопАдресатов,
	|	ГруппыРассылокИОповещений.ОтправлятьПартнеру,
	|	ГруппыРассылокИОповещений.ОтправлятьКонтактномуЛицуОбъектаОповещения,
	|	ГруппыРассылокИОповещений.ОтправлятьКонтактнымЛицамРоли,
	|	ЕСТЬNULL(РолиКонтактныхЛицПартнеров.Наименование, """") КАК НаименованиеРолиКонтактногоЛица,
	|	ВЫБОР
	|		КОГДА ГруппыРассылокИОповещений.ПредназначенаДляЭлектронныхПисем
	|				И ГруппыРассылокИОповещений.ПредназначенаДляSMS
	|			ТОГДА &ДляПисемИSMS
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ГруппыРассылокИОповещений.ПредназначенаДляЭлектронныхПисем
	|					ТОГДА &ДляПисем
	|				ИНАЧЕ &ДляSMS
	|			КОНЕЦ
	|	КОНЕЦ КАК СпособОтправки,
	|	ГруппыРассылокИОповещений.Наименование,
	|	ГруппыРассылокИОповещений.Принудительная КАК Принудительная,
	|	ЗНАЧЕНИЕ(Справочник.ПодпискиНаРассылкиИОповещенияКлиентам.ПустаяСсылка) КАК ПодпискаСсылка,
	|	ЛОЖЬ КАК Подписан,
	|	ГруппыРассылокИОповещений.Описание
	|ИЗ
	|	Справочник.ГруппыРассылокИОповещений КАК ГруппыРассылокИОповещений
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиКонтактныхЛицПартнеров КАК РолиКонтактныхЛицПартнеров
	|		ПО ГруппыРассылокИОповещений.РольКонтактногоЛица = РолиКонтактныхЛицПартнеров.Ссылка
	|ГДЕ
	|	ГруппыРассылокИОповещений.Принудительная
	|	И НЕ ГруппыРассылокИОповещений.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГруппыРассылокИОповещений.Наименование";
	
	Запрос.Текст = ТекстЗапросаПодписки;
	Если Не АвторизованВнешнийПользователь Тогда
		Запрос.Текст = Запрос.Текст + ТекстОбъединить + ТекстЗапросаПринудительные;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Подписчик", Подписчик);
	Запрос.УстановитьПараметр("Действует",      НСтр("ru = 'Действует'"));
	Запрос.УстановитьПараметр("Принудительная", НСтр("ru = 'Принудительно'"));
	Запрос.УстановитьПараметр("Приостановлена", НСтр("ru = 'Приостановлена'"));
	Запрос.УстановитьПараметр("ДляПисемИSMS",   НСтр("ru = 'Email и SMS'"));
	Запрос.УстановитьПараметр("ДляПисем",       НСтр("ru = 'Email'"));
	Запрос.УстановитьПараметр("ДляSMS",         НСтр("ru = 'SMS'"));
	
	Выборка= Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	
		Если ГруппыРассылокИОповещений.Количество() > 0
			И ГруппыРассылокИОповещений.НайтиПоЗначению(Выборка.ГруппаРассылокИОповещений) = Неопределено Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		НоваяСтрока = ТаблицаПодписок.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		НоваяСтрока.Адресаты = РассылкиИОповещенияКлиентам.ТекстКомуБудутОтправленыСообщения(Выборка, Выборка.Принудительная);
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОтменитьПодпискуДляМассива(МассивПодписок)

	Если АвторизованВнешнийПользователь Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Справочники.ПодпискиНаРассылкиИОповещенияКлиентам.ОтменитьПодпискуДляМассива(МассивПодписок);
	
	ЗаполнитьТаблицуПодписок();

КонецПроцедуры

&НаСервере
Процедура ОформитьПодпискуДляМассива(МассивПодписок)
	
	Если АвторизованВнешнийПользователь Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Справочники.ПодпискиНаРассылкиИОповещенияКлиентам.ОформитьПодпискуДляМассиваСуществующихИНовыхПодписок(МассивПодписок);
	
	ЗаполнитьТаблицуПодписок();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()

	Если АвторизованВнешнийПользователь Тогда
		Элементы.ТаблицаПодписокПодписка.Видимость                  = Ложь;
		Элементы.ТаблицаПодписокГруппаРассылокИОповещений.Заголовок = НСтр("ru = 'Подписка'");
	Иначе
		Элементы.ТаблицаПодписокПодписан.Видимость        = Ложь;
	КонецЕсли;

КонецПроцедуры


#КонецОбласти


