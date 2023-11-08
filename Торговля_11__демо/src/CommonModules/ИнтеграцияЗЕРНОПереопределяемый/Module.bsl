#Область ПрограммныйИнтерфейс

//Дополнительные действия прикладной конфигурации при изменении статуса документа ЗЕРНО.
//
//Параметры:
//   ДокументСсылка   - ДокументСсылка     - ссылка на документ с изменением статуса.
//   ПредыдущийСтатус - ПеречислениеСсылка - предыдущий статус обработки.
//   НовыйСтатус      - ПеречислениеСсылка - новый статус обработки.
//   ПараметрыОбновленияСтатуса - Структура, Неопределено - (См. ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыОбновленияСтатуса).
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса = Неопределено) Экспорт

	Возврат;

КонецПроцедуры

// Процедура определяет использование транспортных средств
//
// Параметры:
//  Указывается - Булево - Признак использования транспортных средств.
Процедура УказываетсяТранспортноеСредство(Указывается) Экспорт
	
	//++ НЕ ГОСИС
	
	Указывается = ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоставкой");
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Заполняет данные транспортного средства
//
// Параметры:
//  Реквизиты - Структура - возможные реквизиты транспортного средства
//  ТранспортноеСредство - ОпределяемыйТип.ТранспортныеСредстваИС - транспортное средство
Процедура ПриОпределенииРеквизитовТранспортногоСредства(Реквизиты, ТранспортноеСредство) Экспорт
	
	//++ НЕ ГОСИС
	
	Если ЗначениеЗаполнено(ТранспортноеСредство) Тогда
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТранспортноеСредство, "Код, ГосударственныйНомерПрицепа");
		
		// Группы символов, разделяемые пробелами для ВЕТИС
		ГруппаСимволовЦифры = "0123456789";
		ГруппаСимволовРусские = "АВЕКМНОРСТУХ";
		
		// Латинские символы в российских госномерах, подменяемые русскими
		Замена = Новый Соответствие;
		Замена.Вставить("A","А");
		Замена.Вставить("B","В");
		Замена.Вставить("E","Е");
		Замена.Вставить("K","К");
		Замена.Вставить("M","М");
		Замена.Вставить("H","Н");
		Замена.Вставить("O","О");
		Замена.Вставить("P","Р");
		Замена.Вставить("C","С");
		Замена.Вставить("T","Т");
		Замена.Вставить("Y","У");
		Замена.Вставить("X","Х");
		
		НомерДоРазбиенияПоГруппам = СтрЗаменить(ВРег(ЗначенияРеквизитов.Код), " ", "");
		ЭтоРоссийскийНомер = Прав(НомерДоРазбиенияПоГруппам,3) = "RUS";
		Номер = "";
		ВидСимволаГруппы = -1;
		Для Индекс = 1 По СтрДлина(НомерДоРазбиенияПоГруппам) Цикл
			Символ = Сред(НомерДоРазбиенияПоГруппам, Индекс, 1);
			Если ЭтоРоссийскийНомер И Замена.Получить(Символ)<>Неопределено Тогда
				Символ = Замена.Получить(Символ);
			КонецЕсли;
			ВидСимвола = 0;
			Если СтрНайти(ГруппаСимволовЦифры, Символ)>0 Тогда
				ВидСимвола = 1;
			ИначеЕсли СтрНайти(ГруппаСимволовРусские, Символ)>0 Тогда
				ВидСимвола = 2;
			КонецЕсли;
			Номер = Номер + ?(ВидСимволаГруппы = ВидСимвола,""," ") + Символ;
			ВидСимволаГруппы = ВидСимвола;
		КонецЦикла;
		Реквизиты.НомерТранспортногоСредства = Сред(Номер, 2);
		
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#Область ПересчетКоличества

// Заполняет количество номенклатуры по количеству ЗЕРНО:
//   * Имя колонки с количеством ЗЕРНО откуда идет пересчет: <Количество[суффикс]ЗЕРНО>,
//   * Имя колонки с прикладным количеством: <Количество[суффикс]>.
//
// Параметры:
//  ОбъектыПересчета - ДанныеФормыЭлементКоллекции, Массив Из СтрокаТабличнойЧасти - объекты для пересчета.
//  Суффикс - Строка - Окончание наименования колонки, содержащей количество.
Процедура ЗаполнитьКоличествоПоКоличествуЗЕРНО(ОбъектыПересчета, Суффикс = "") Экспорт
	
	//++ НЕ ГОСИС
	СтрокиВМассиве = ОбъектыПересчета;
	Если ТипЗнч(ОбъектыПересчета) <> Тип("Массив") Тогда
		СтрокиВМассиве = Новый Массив;
		СтрокиВМассиве.Добавить(ОбъектыПересчета);
	КонецЕсли;
	Коэффициенты = ИнтеграцияЗЕРНОУТ.КоэффициентыЕдиницИзмеренияЗЕРНО(СтрокиВМассиве);
	
	Для Каждого ЭлементМассива Из СтрокиВМассиве Цикл
		Если Не ЗначениеЗаполнено(Коэффициенты.Получить(ЭлементМассива.Номенклатура)) Тогда
			ЭлементМассива["Количество" + Суффикс] = 0;
		Иначе
			ЭлементМассива["Количество" + Суффикс] = ЭлементМассива["Количество" + Суффикс + "ЗЕРНО"] / Коэффициенты.Получить(ЭлементМассива.Номенклатура).Коэффициент;
		КонецЕсли;
	КонецЦикла;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийДокументов

//Вызывается при вводе документа на основании, при выполнении метода Заполнить или при интерактивном вводе нового.
//
//Параметры:
//   ДокументОбъект - ДокументОбъект - заполняемый документ,
//   ДанныеЗаполнения - Произвольный - значение, которое используется как основание для заполнения,
//   ТекстЗаполнения - Строка, Неопределено - текст, используемый для заполнения документа,
//   СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполненияДокумента(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	//++ НЕ ГОСИС
	
	ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
	ТипОбъекта = ТипЗнч(ДокументОбъект);
	Если ТипОбъекта = Тип("ДокументОбъект.ФормированиеПартийЗЕРНО") Тогда
		ИнтеграцияЗЕРНОУТ.ОбработкаЗаполненияДокументаФормированиеПартийЗЕРНО(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипОбъекта = Тип("ДокументОбъект.СписаниеПартийЗЕРНО") Тогда
		ИнтеграцияЗЕРНОУТ.ОбработкаЗаполненияДокументаСписаниеПартийЗЕРНО(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипОбъекта = Тип("ДокументОбъект.ОформлениеСДИЗЗЕРНО") Тогда
		ИнтеграцияЗЕРНОУТ.ОбработкаЗаполненияДокументаОформлениеСДИЗЗЕРНО(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипОбъекта = Тип("ДокументОбъект.ВнесениеСведенийОСобранномУрожаеЗЕРНО") Тогда
		ИнтеграцияЗЕРНОУТ.ОбработкаЗаполненияДокументаВнесениеСведенийОСобранномУрожаеЗЕРНО(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипОбъекта = Тип("ДокументОбъект.ПогашениеСДИЗЗЕРНО") Тогда
		ИнтеграцияЗЕРНОУТ.ОбработкаЗаполненияДокументаПогашениеСДИЗЗЕРНО(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипОбъекта = Тип("ДокументОбъект.ФормированиеПартийПриПроизводствеЗЕРНО") Тогда
		ИнтеграцияЗЕРНОУТ.ОбработкаЗаполненияДокументаФормированиеПартийПриПроизводствеЗЕРНО(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
	Возврат;

КонецПроцедуры

// В процедуре необходимо реализовать запись сопоставления ключей адресов и ключей реквизитов организаций ЗЕРНО 
//   с прикладными справочниками конфигурации
//
// Параметры:
//  ДокументОснование - ДокументСсылка, ДокументОбъект - прикладной документ конфигурации,
//  ДокументОбъект    - ДокументСсылка, ДокументОбъект - связанный с ним документ библиотеки.
//
Процедура ЗаполнитьСоответствиеШапкиОбъектов(ДокументОснование, ДокументОбъект) Экспорт
	
	//++ НЕ ГОСИС
	
	ИнтеграцияЗЕРНОУТ.ЗаполнитьСоответствиеШапкиОбъектов(ДокументОснование, ДокументОбъект);
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// В процедуре реализуется заполнение обособленных подразделений для коллекции организаций. В переданной таблице
// необходимо заполнить колонки ОрганизацияКонтрагент, Подразделение.
//
// Параметры:
//  КоллекцияОрганизаций - ТаблицаЗначений - массив ссылок, по которым нужно получить реквизиты
//  ТаблицаПодразделенйОрганизации - см. ИнтеграцияЗЕРНО.НоваяТаблицаОрганизацияКонтрагентПодразделение
Процедура ПриОпределенииОбособленныхПодразделенийОрганизации(КоллекцияОрганизаций, ТаблицаПодразделенйОрганизации) Экспорт
	
	//++ НЕ ГОСИС
	
	Если КоллекцияОрганизаций.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КоллекцияОрганизаций", КоллекцияОрганизаций);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегистрацииВНалоговомОргане.Организация   КАК ОрганизацияКонтрагент,
	|	РегистрацииВНалоговомОргане.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.РегистрацииВНалоговомОргане.СрезПоследних() КАК РегистрацииВНалоговомОргане
	|ГДЕ
	|	РегистрацииВНалоговомОргане.Организация В (&КоллекцияОрганизаций)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Организации.Ссылка,
	|	НЕОПРЕДЕЛЕНО
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ОбособленноеПодразделение
	|	И Организации.ГоловнаяОрганизация В (&КоллекцияОрганизаций)
	|	И Не Организации.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаТаблицы = ТаблицаПодразделенйОрганизации.Добавить();
		СтрокаТаблицы.ОрганизацияКонтрагент = Выборка.ОрганизацияКонтрагент;
		Если ЗначениеЗаполнено(Выборка.Подразделение) Тогда
			СтрокаТаблицы.Подразделение = Выборка.Подразделение;
		КонецЕсли;
	КонецЦикла;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// В процедуре требуется дополнить в переданной таблице по Организации/контрагенту и подразделению
// данные ИНН/КПП/ОГРН/Наименование/ТипОрганизации/КодАльфа3/ЮридическийАдрес/Фамилия/Имя/Отчество из информационной базы.
// КоллекцияОрганизацийПодразделений индексирован по "ОрганизацияКонтрагент, Подразделение".
//
// Параметры:
//  КоллекцияОрганизацийПодразделений - см. ИнтеграцияЗЕРНО.НоваяТаблицаОрганизацияКонтрагентПодразделение
Процедура ПриОпределенииРеквизитовОрганизацийКонтрагентов(КоллекцияОрганизацийПодразделений) Экспорт
	
	//++ НЕ ГОСИС
	
	Если КоллекцияОрганизацийПодразделений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьПравоДоступаЧтениеОрганизации = ПравоДоступа("Чтение", Метаданные.Справочники.Организации);
	ЕстьПравоДоступаЧтениеКонтрагенты = ПравоДоступа("Чтение", Метаданные.Справочники.Контрагенты);
	
	ТекстЗапроса = "";
	
	Если ЕстьПравоДоступаЧтениеКонтрагенты Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.ИНН                  КАК ИНН,
		|	Контрагенты.КПП                  КАК КПП,
		|	Контрагенты.РегистрационныйНомер КАК ОГРН,
		|	Контрагенты.НаименованиеПолное   КАК Наименование,
		|	ВЫБОР
		|		КОГДА Контрагенты.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ИностраннаяОрганизация)
		|		КОГДА Контрагенты.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
		|		ИЛИ Контрагенты.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ИндивидульныйПредприниматель)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ЮридическоеЛицо)
		|	КОНЕЦ КАК ТипОрганизации,
		|	ЕСТЬNULL(Контрагенты.СтранаРегистрации.КодАльфа3, """") КАК КодАльфа3,
		|	Контрагенты.Ссылка          КАК Ссылка,
		|	ТаблицаОтбора.Подразделение КАК Подразделение,
		|	НЕОПРЕДЕЛЕНО КАК ИндивидуальныйПредприниматель
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОтбора КАК ТаблицаОтбора
		|		ПО Контрагенты.Ссылка = ТаблицаОтбора.ОрганизацияКонтрагент
		|";
	КонецЕсли;
	
	Если ЕстьПравоДоступаЧтениеОрганизации Тогда
		Если ЕстьПравоДоступаЧтениеКонтрагенты Тогда
			Префикс =
			"ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|";
		Иначе
			Префикс =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + Префикс +
		"	Организации.ИНН КАК ИНН,
		|	ЕСТЬNULL(РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане.КПП, Организации.КПП) КАК КПП,
		|	Организации.ОГРН КАК ОГРН,
		|	Организации.НаименованиеПолное КАК Наименование,
		|	ВЫБОР
		|		КОГДА Организации.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ИностраннаяОрганизация)
		|		КОГДА Организации.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
		|				ИЛИ Организации.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ИндивидульныйПредприниматель)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ЮридическоеЛицо)
		|	КОНЕЦ КАК ТипОрганизации,
		|	ЕСТЬNULL(Организации.СтранаРегистрации.КодАльфа3, """") КАК КодАльфа3,
		|	Организации.Ссылка КАК Ссылка,
		|	ТаблицаОтбора.Подразделение КАК Подразделение,
		|	ЕСТЬNULL(Организации.ИндивидуальныйПредприниматель.ФИО, """") КАК ИндивидуальныйПредприниматель
		|
		|ИЗ
		|	Справочник.Организации КАК Организации
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОтбора КАК ТаблицаОтбора
		|		ПО Организации.Ссылка = ТаблицаОтбора.ОрганизацияКонтрагент
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацииВНалоговомОргане.СрезПоследних() КАК РегистрацииВНалоговомОргане
		|		ПО ТаблицаОтбора.Подразделение = РегистрацииВНалоговомОргане.Подразделение
		|		И ТаблицаОтбора.ОрганизацияКонтрагент = РегистрацииВНалоговомОргане.Организация
		|";
	КонецЕсли;
	
	Если ТекстЗапроса = "" Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаОтбора.ОрганизацияКонтрагент КАК ОрганизацияКонтрагент,
	|	ТаблицаОтбора.Подразделение         КАК Подразделение
	|ПОМЕСТИТЬ ТаблицаОтбора
	|ИЗ
	|	&ТаблицаОтбора КАК ТаблицаОтбора
	|;
	|" + ТекстЗапроса;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаОтбора", КоллекцияОрганизацийПодразделений);
	Запрос.Текст = ТекстЗапроса;
	
	ПоддерживаетсяФИОВСправочникеФизическиеЛица = Ложь;
	
	
	Если Не ПоддерживаетсяФИОВСправочникеФизическиеЛица Тогда
		Запрос.Текст = СтрЗаменить(
			Запрос.Текст,
			"ЕСТЬNULL(Организации.ИндивидуальныйПредприниматель.ФИО, """")",
			"ЕСТЬNULL(Организации.ИндивидуальныйПредприниматель.Наименование, """")");
	КонецЕсли;
	
	КоллекцияКонтактнаяИнформация = Новый Массив();
	Выборка = Запрос.Выполнить().Выбрать();
	
	Отбор = Новый Структура("ОрганизацияКонтрагент, Подразделение");
	Пока Выборка.Следующий() Цикл
		
		Отбор.ОрганизацияКонтрагент = Выборка.Ссылка;
		Отбор.Подразделение         = Выборка.Подразделение;
		
		НайденныеСтроки = КоллекцияОрганизацийПодразделений.НайтиСтроки(Отбор);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
			ЗаполнитьЗначенияСвойств(НайденнаяСтрока, Выборка);
			Если Выборка.ТипОрганизации = Перечисления.ТипыОрганизацийЗЕРНО.ИндивидульныйПредприниматель Тогда
				
				Если ТипЗнч(Выборка.Ссылка) = Тип("СправочникСсылка.Организации")
					И ЗначениеЗаполнено(Выборка.ИндивидуальныйПредприниматель) Тогда
					ПолноеНаименование = Выборка.ИндивидуальныйПредприниматель;
				Иначе
					ПолноеНаименование = Выборка.Наименование;
				КонецЕсли;
				
				ПоисковаяСтрока = НСтр("ru = 'Индивидуальный предприниматель'");
				Если ВРег(Лев(ПолноеНаименование, 3))  = "ИП " Тогда 
					ПолноеНаименование = Сред(ПолноеНаименование, 4);
				ИначеЕсли ВРег(Прав(ПолноеНаименование, 3))  = " ИП" Тогда 
					ПолноеНаименование = Лев(ПолноеНаименование, СтрДлина(ПолноеНаименование) - 3);
				ИначеЕсли ВРег(Лев(ПолноеНаименование, СтрДлина(ПоисковаяСтрока))) = ВРег(ПоисковаяСтрока) Тогда
					ПолноеНаименование = Прав(ПолноеНаименование, СтрДлина(ПолноеНаименование) - СтрДлина(ПоисковаяСтрока));
				КонецЕсли;
				
				ЧастиИмени = ФизическиеЛицаКлиентСервер.ЧастиИмени(ПолноеНаименование);
				НайденнаяСтрока.Фамилия  = ЧастиИмени.Фамилия;
				НайденнаяСтрока.Имя      = ЧастиИмени.Имя;
				НайденнаяСтрока.Отчество = ЧастиИмени.Отчество;
				
			КонецЕсли;
			
		КонецЦикла;
		
		КоллекцияКонтактнаяИнформация.Добавить(Выборка.Ссылка);
		
	КонецЦикла;
	
	ВидыКонтактнойИнформации = Новый Массив();
	ВидыКонтактнойИнформации.Добавить(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
	ВидыКонтактнойИнформации.Добавить(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
	ТаблицаКИ = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
		КоллекцияКонтактнаяИнформация,, ВидыКонтактнойИнформации, ТекущаяДатаСеанса());
	
	Отбор = Новый Структура("ОрганизацияКонтрагент");
	Для Каждого СтрокаТаблицы Из ТаблицаКИ Цикл
		
		Отбор.ОрганизацияКонтрагент = СтрокаТаблицы.Объект;
		НайденныеСтроки = КоллекцияОрганизацийПодразделений.НайтиСтроки(Отбор);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.ЮридическийАдрес = СтрокаТаблицы.Представление;
		КонецЦикла;
		
	КонецЦикла;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Определение ссылок на организации и контрагенты по реквизитам. Переданной таблице реквизитов необходимо заполнить
// колонки:
//  - Организация - Ссылка на организацию, найденную по переданным реквизитам
//  - Контрагент  - Ссылка на контрагент, найденного по переданным реквизитам,
//  - Подразделение - Ссылка на обособленное подразделение, найденного по переданным реквизитам.
// Параметры:
//  ТаблицаРеквизитов - см. Справочники.КлючиРеквизитовОрганизацийЗЕРНО.НоваяТаблицаРеквизитовКлючейРеквизитовОрганизаций
Процедура ПриОпределенииКонтрагентовОрганизацийПоРеквизитам(ТаблицаРеквизитов) Экспорт
	
	//++ НЕ ГОСИС
	
	Если ТаблицаРеквизитов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ТаблицаРеквизитов.Колонки.Найти("ИндексИсходнойСтроки") = Неопределено Тогда
		ТаблицаРеквизитов.Колонки.Добавить("ИндексИсходнойСтроки", ОбщегоНазначения.ОписаниеТипаЧисло(5));
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТаблицаРеквизитов Цикл
		СтрокаТаблицы.ИндексИсходнойСтроки = ТаблицаРеквизитов.Индекс(СтрокаТаблицы);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаРеквизитов);
	
	Запрос.Текст  = "ВЫБРАТЬ
	|	ТаблицаОтбора.ИНН  КАК ИНН,
	|	ТаблицаОтбора.КПП  КАК КПП,
	|	ТаблицаОтбора.ОГРН КАК ОГРН,
	|	ТаблицаОтбора.Наименование КАК Наименование,
	|	ТаблицаОтбора.ТипОрганизации КАК ТипОрганизации,
	|	ТаблицаОтбора.ИндексИсходнойСтроки
	|ПОМЕСТИТЬ ТаблицаОтбора
	|ИЗ
	|	&ТаблицаОтбора КАК ТаблицаОтбора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Контрагенты.Ссылка                  КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО                        КАК Организация,
	|	НЕОПРЕДЕЛЕНО                        КАК Подразделение,
	|	ТаблицаОтбора.ИндексИсходнойСтроки  КАК ИндексИсходнойСтроки
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОтбора КАК ТаблицаОтбора
	|		ПО Контрагенты.ИНН = ТаблицаОтбора.ИНН
	|			И Контрагенты.КПП = ТаблицаОтбора.КПП
	|			И ТаблицаОтбора.ТипОрганизации В (ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ЮридическоеЛицо),
	|			                                  ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ИностраннаяОрганизация))
	|	И НЕ Контрагенты.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Контрагенты.Ссылка,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	ТаблицаОтбора.ИндексИсходнойСтроки
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОтбора КАК ТаблицаОтбора
	|		ПО Контрагенты.ИНН = ТаблицаОтбора.ИНН
	|			И Контрагенты.РегистрационныйНомер = ТаблицаОтбора.ОГРН
	|			И ТаблицаОтбора.ТипОрганизации = ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ИндивидульныйПредприниматель)
	|	И НЕ Контрагенты.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Контрагенты.Ссылка,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	ТаблицаОтбора.ИндексИсходнойСтроки
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОтбора КАК ТаблицаОтбора
	|		ПО Контрагенты.Наименование = ТаблицаОтбора.Наименование
	|			И ТаблицаОтбора.ТипОрганизации = ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ИностраннаяОрганизацияБезРегистрацииВРФ)
	|	И НЕ Контрагенты.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НЕОПРЕДЕЛЕНО,
	|	Организации.Ссылка,
	|	НЕОПРЕДЕЛЕНО,
	|	ТаблицаОтбора.ИндексИсходнойСтроки
	|ИЗ
	|	Справочник.Организации КАК Организации
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОтбора КАК ТаблицаОтбора
	|		ПО Организации.ИНН = ТаблицаОтбора.ИНН
	|			И Организации.КПП = ТаблицаОтбора.КПП
	|			И ТаблицаОтбора.ТипОрганизации В (ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ЮридическоеЛицо),
	|			                                  ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ИностраннаяОрганизация))
	|	И НЕ Организации.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НЕОПРЕДЕЛЕНО,
	|	Организации.Ссылка,
	|	НЕОПРЕДЕЛЕНО,
	|	ТаблицаОтбора.ИндексИсходнойСтроки
	|ИЗ
	|	Справочник.Организации КАК Организации
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОтбора КАК ТаблицаОтбора
	|		ПО Организации.ИНН = ТаблицаОтбора.ИНН
	|			И Организации.ОГРН = ТаблицаОтбора.ОГРН
	|			И ТаблицаОтбора.ТипОрганизации = ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ИндивидульныйПредприниматель)
	|	И НЕ Организации.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НЕОПРЕДЕЛЕНО,
	|	Организации.Ссылка,
	|	НЕОПРЕДЕЛЕНО,
	|	ТаблицаОтбора.ИндексИсходнойСтроки
	|ИЗ
	|	Справочник.Организации КАК Организации
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОтбора КАК ТаблицаОтбора
	|		ПО Организации.Наименование = ТаблицаОтбора.Наименование
	|			И ТаблицаОтбора.ТипОрганизации = ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЗЕРНО.ИностраннаяОрганизацияБезРегистрацииВРФ)
	|	И НЕ Организации.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НЕОПРЕДЕЛЕНО,
	|	РегистрацииВНалоговомОргане.Организация,
	|	РегистрацииВНалоговомОргане.Подразделение,
	|	ТаблицаОтбора.ИндексИсходнойСтроки
	|ИЗ
	|	ТаблицаОтбора КАК ТаблицаОтбора
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацииВНалоговомОргане.СрезПоследних() КАК РегистрацииВНалоговомОргане
	|		ПО ТаблицаОтбора.ИНН = РегистрацииВНалоговомОргане.Организация.ИНН
	|		И ТаблицаОтбора.КПП = РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане.КПП
	|";
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
		СтрокаИсходнойТаблицы = ТаблицаРеквизитов.Получить(СтрокаДанных.ИндексИсходнойСтроки);
		Если ЗначениеЗаполнено(СтрокаДанных.Контрагент) Тогда
			СтрокаИсходнойТаблицы.Контрагент = СтрокаДанных.Контрагент;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаДанных.Организация) Тогда
			СтрокаИсходнойТаблицы.Организация = СтрокаДанных.Организация;
			Если ЗначениеЗаполнено(СтрокаДанных.Подразделение) Тогда
				СтрокаИсходнойТаблицы.Подразделение = СтрокаДанных.Подразделение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#Область ОКПД2

// В данной процедуре требуется переопределить текст запроса, помещающий выборку из прикладного классификатора ОКПД2
// во временную таблицу ВременнаяТаблица.
//   Требования к тексту запроса:
//     Если классификатор ОКПД2 не используется, переопределение также не заполнять.
//     Результат запроса обязательно должен содержать следующие поля:
//   Колонки временной таблицы "ДанныеШтрихкодовУпаковок":
//     Ссылка             - ОпределяемыйТип.ОКПД2ИС - ссылка на элемент классификатора ОКПД2.
//     Код                - Строка - код.
//     НаименованиеПолное - Строка - наименование.
// Параметры:
//  ТекстЗапроса - Строка - Переопределяемый текст запроса.
Процедура ПриОпределенииТекстаЗапросаКлассификатораОКПД2(ТекстЗапроса) Экспорт
	
	//++ НЕ ГОСИС
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	КлассификаторОКПД2.Ссылка КАК Ссылка,
	|	КлассификаторОКПД2.Код КАК Код,
	|	КлассификаторОКПД2.НаименованиеПолное КАК НаименованиеПолное
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.КлассификаторОКПД2 КАК КлассификаторОКПД2
	|";
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Предназначена для поиска по коду элемента в Классификаторе ОКПД2.
// Если элемент не найден, то, при использовании классификатора, создать элемент справочника в соответствии с классификатором ОКПД2.
// 
// Параметры:
//  ОКПД2 - Строка - Строка с кодом классификатора ОКПД2.
//  ЭлементСправочника - Произвольный - Переопределяемый параметр, ссылка на элемент классификатора.
Процедура ПриОпределенииСопоставленногоКлассификатораОКПД2(ОКПД2, ЭлементСправочника) Экспорт
	
	//++ НЕ ГОСИС
	
	ЭлементСправочника = Справочники.КлассификаторОКПД2.НайтиСоздатьПоКоду(ОКПД2);
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#Область ТНВЭД

// В данной процедуре требуется переопределить текст запроса, помещающий выборку из прикладного классификатора ТН ВЭД
// во временную таблицу ВременнаяТаблица.
//   Требования к тексту запроса:
//     Если классификатор ТН ВЭД не используется, переопределение также не заполнять.
//     Результат запроса обязательно должен содержать следующие поля:
//   Колонки временной таблицы "ДанныеШтрихкодовУпаковок":
//     Ссылка             - Произвольный - ссылка на элемент классификатора ТН ВЭД.
//     Код                - Строка - код.
//     НаименованиеПолное - Строка - наименование.
// Параметры:
//  ТекстЗапроса - Строка - Переопределяемый текст запроса.
Процедура ПриОпределенииТекстаЗапросаКлассификатораТНВЭД(ТекстЗапроса) Экспорт
	
	//++ НЕ ГОСИС
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	КлассификаторТНВЭД.Ссылка КАК Ссылка,
	|	КлассификаторТНВЭД.Код КАК Код,
	|	КлассификаторТНВЭД.НаименованиеПолное КАК НаименованиеПолное
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.КлассификаторТНВЭД КАК КлассификаторТНВЭД
	|";
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Предназначена для поиска по коду элемента в Классификаторе ТН ВЭД.
// Если элемент не найден, то, при использовании классификатора, создать элемент справочника в соответствии с классификатором ТН ВЭД ЕАЭС.
// 
// Параметры:
//  ТНВЭД - Строка - Строка с кодом классификатора ТН ВЭД.
//  Наименование - Строка - наименование элемента классификатора ТН ВЭД.
//  ЭлементСправочника - Произвольный - Переопределяемый параметр, ссылка на элемент классификатора.
Процедура ПриОпределенииСопоставленногоКлассификатораТНВЭД(ТНВЭД, Наименование, ЭлементСправочника) Экспорт
	
	//++ НЕ ГОСИС
	
	ЭлементСправочника = ИнтеграцияИСМПУТ.ПриОпределенииСопоставленногоКлассификатораТНВЭД(ТНВЭД, Наименование);
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

// Процедура заполняет признак использования договоров контрагентов.
//
// Параметры:
//  Используется - Булево - Признак использования договоров контрагентов.
Процедура ПриОпределенииИспользованияДоговоровКонтрагентов(Используется) Экспорт

	//++ НЕ ГОСИС
	
	Используется = Истина;
	
	//-- НЕ ГОСИС
	
	Возврат;

КонецПроцедуры

// Процедура заполняет признак использования договоров между организациями.
//
// Параметры:
//  Используется - Булево - Признак использования договоров между организациями.
Процедура ПриОпределенииИспользованияДоговоровОрганизаций(Используется) Экспорт

	//++ НЕ ГОСИС
	
	Используется = Ложь;
	
	//-- НЕ ГОСИС
	
	Возврат;

КонецПроцедуры

// Заполняет соответствие договору дату и номер договора.
//
// Параметры:
//  МассивСсылок - Массив Из ОпределяемыйТип.ДоговорКонтрагентаИС - массив ссылок договоры.
//  
//  ВозвращаемоеСоответствие - Соответствие из ОпределяемыйТип.ДоговорКонтрагентаИС:
//                             * Ключ - ОпределяемыйТип.ДоговорКонтрагентаИС - ссылка на выгружаемый учетный документ.
//                             * Значение - Структура:
//                               ** НомерДоговора - Строка.
//                               ** ДатаДоговора - Дата.
//
Процедура ПриОпределенииНомераДатыДоговораДокументов(МассивСсылок, ВозвращаемоеСоответствие) Экспорт
	
	//++ НЕ ГОСИС
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоговорыКонтрагентов.ДатаДоговора КАК ДатаДоговора,
	|	ДоговорыКонтрагентов.НомерДоговора КАК НомерДоговора,
	|	ДоговорыКонтрагентов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Ссылка В (&МассивСсылок)");
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВозвращаемоеСоответствие.Вставить(
			Выборка.Ссылка, Новый Структура("НомерДоговора, ДатаДоговора", Выборка.НомерДоговора, Выборка.ДатаДоговора));
	КонецЦикла;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Заполняет соответствие госконтракту  дату, номер и номер закупки ЕИС.
//
// Параметры:
//  МассивСсылок - Массив Из ОпределяемыйТип.ГосударственныеКонтрактыИС - массив ссылок государственные контракты.
//  
//  ВозвращаемоеСоответствие - Соответствие из ОпределяемыйТип.ГосударственныеКонтрактыИС:
//                             * Ключ - ОпределяемыйТип.ГосударственныеКонтрактыИС - ссылка на ссылка на гос.контракт.
//                             * Значение - Структура:
//                               ** НомерГосКонтракта - Строка.
//                               ** ДатаГосКонтракта  - Дата.
//                               ** НомерЗакупкиЕИС   - Строка.
//
Процедура ПриОпределенииРеквизитовГосКонтракта(МассивСсылок, ВозвращаемоеСоответствие) Экспорт
	
	//++ НЕ ГОСИС
	
	ВозвращаемоеСоответствие = ИнтеграцияЗЕРНОУТ.ДанныеГосударственногоКонтракта(МассивСсылок);
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Предназначена для получения площади земельного участка если в качестве определяемого типа ЗемльныйУчастокИС
// используется тип, отличный от СправочникСсылка.ЗемельныеУчасткиИС.
//
// Параметры:
//  ЗемельныйУчасток - ОпределяемыйТип.ЗемельныйУчастокИС - Ссылка на земельный участок.
//  ПлощадьЗемельногоУчастка - Число - Площадь земельного участка в гектарах.
//
Процедура ПриОпределенииПлощадиЗемельногоУчастка(ЗемельныйУчасток, ПлощадьЗемельногоУчастка) Экспорт
	
	//++ НЕ ГОСИС
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается расширением формы при необходимости проверки заполнения реквизитов при записи или при проведении документа в форме,
// а также при выполнении метода ПроверитьЗаполнение.
//
// Параметры:
//  ДокументОбъект - ДокументОбъект - проверяемый документ,
//  Отказ - Булево - признак отказа от проведения документа,
//  ПроверяемыеРеквизиты - Массив из Строка- массив путей к реквизитам, для которых будет выполнена проверка заполнения,
//  МассивНепроверяемыхРеквизитов - Массив из Строка - массив путей к реквизитам, для которых не будет выполнена проверка заполнения.
Процедура ПриОпределенииОбработкиПроверкиЗаполнения(ДокументОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов) Экспорт
	
	//++ НЕ ГОСИС
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ФормированиеПартийЗЕРНО")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.СписаниеПартийЗЕРНО")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ВнесениеСведенийОСобранномУрожаеЗЕРНО")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ОформлениеСДИЗЗЕРНО")
		Или ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПогашениеСДИЗЗЕРНО") Тогда
		
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ДокументОбъект, МассивНепроверяемыхРеквизитов, Отказ);
		ПараметрыУказанияСерий = Документы[ДокументОбъект.Метаданные().Имя].ПараметрыУказанияСерий(ДокументОбъект);
		НоменклатураСервер.ПроверитьЗаполнениеСерий(ДокументОбъект, ПараметрыУказанияСерий, Отказ, МассивНепроверяемыхРеквизитов);
		
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ФормированиеПартийИзДругихПартийЗЕРНО") Тогда
			
		// Проверка характеристки в шапке.
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Или Не Справочники.Номенклатура.ХарактеристикиИспользуются(ДокументОбъект.Номенклатура) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ФормированиеПартийПриПроизводствеЗЕРНО") Тогда
		
		ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
		ПараметрыПроверки.ИмяТЧ = "Сырье";
		
		// Проверка характеристки в шапке.
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Или Не Справочники.Номенклатура.ХарактеристикиИспользуются(ДокументОбъект.Номенклатура) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
		КонецЕсли;
		
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ДокументОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверки);
		ПараметрыУказанияСерий = Документы[ДокументОбъект.Метаданные().Имя].ПараметрыУказанияСерий(ДокументОбъект).Сырье;
		НоменклатураСервер.ПроверитьЗаполнениеСерий(ДокументОбъект, ПараметрыУказанияСерий, Отказ, МассивНепроверяемыхРеквизитов);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти