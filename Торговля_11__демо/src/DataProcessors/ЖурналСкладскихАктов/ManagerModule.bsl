#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
//
//	Параметры:
//		КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// 
// Параметры:
// 	ТекущиеДела - см. ТекущиеДелаСервер.ТекущиеДела
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "Обработка.ЖурналСкладскихАктов.Форма.ФормаСписка";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Документы.СписаниеНедостачТоваров))
		И (ПравоДоступа("Добавление", Метаданные.Документы.СписаниеНедостачТоваров)
			ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.ОприходованиеИзлишковТоваров)
			ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.ПересортицаТоваров)
			ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.ПорчаТоваров))
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКОформлениюИзлишковНедостач);
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(1) КАК ОснованияКОформлениюСкладскихАктов
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ТоварыКОформлениюИзлишковНедостачОстатки.Номенклатура КАК Номенклатура,
	|		ТоварыКОформлениюИзлишковНедостачОстатки.Характеристика КАК Характеристика
	|	ИЗ
	|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(, ) КАК ТоварыКОформлениюИзлишковНедостачОстатки
	|	ГДЕ
	|		ТоварыКОформлениюИзлишковНедостачОстатки.КОформлениюАктовОстаток <> 0) КАК ОстаткиКОформлению";
	
	Результат = ТекущиеДелаСлужебный.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	// Заполнение дел.
	// ОформлениеСкладскихАктов
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "ОформлениеСкладскихАктов";
	ДелоРодитель.Представление  = НСтр("ru = 'Оформление складских актов'");
	ДелоРодитель.ЕстьДела       = Результат.ОснованияКОформлениюСкладскихАктов > 0;
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Склад;
	
	// ОснованияКОформлениюСкладскихАктов
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяТекущейСтраницы", "СтраницаОснования");
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ОснованияКОформлениюСкладскихАктов";
	Дело.ЕстьДела       = Результат.ОснованияКОформлениюСкладскихАктов > 0;
	Дело.Представление  = НСтр("ru = 'Товары к оформлению'");
	Дело.Количество     = Результат.ОснованияКОформлениюСкладскихАктов;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = ПараметрыФормы;
	Дело.Владелец       = "ОформлениеСкладскихАктов";
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеГиперссылкиВЖурналеЗакупок 

Функция ТекстЗапросаКОформлению() Экспорт
	
	Возврат
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ТоварыКОформлениюИзлишковНедостачОстатки.Номенклатура,
	|	ТоварыКОформлениюИзлишковНедостачОстатки.Характеристика,
	|	ТоварыКОформлениюИзлишковНедостачОстатки.Серия,
	|	ТоварыКОформлениюИзлишковНедостачОстатки.Назначение
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(
	|			,
	|			Склад = &Склад
	|				ИЛИ &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)) КАК ТоварыКОформлениюИзлишковНедостачОстатки
	|ГДЕ
	|	НЕ ТоварыКОформлениюИзлишковНедостачОстатки.КОформлениюАктовОстаток = 0";
	
КонецФункции

Функция СформироватьГиперссылкуКОформлению(Параметры) Экспорт
	
	Склад = Параметры.Склад;
	Если ЗначениеЗаполнено(Склад)
			И Не СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Параметры.Склад)
		Или Не СкладыСервер.ЕстьРазрешенныеСкладыОрдерныеПриОтраженииИзлишковНедостач()
		Или Не УправлениеДоступом.ЕстьРоль("ЧтениеТоваровКОформлениюИзлишковНедостач") Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапросаКОформлению());
	Запрос.УстановитьПараметр("Склад",Параметры.Склад);
	ТекстГиперссылки = НСтр("ru='Акты'");
	МассивСтрок = Новый Массив;
	Если Запрос.Выполнить().Пустой() Тогда
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(ТекстГиперссылки,,ЦветаСтиля.НезаполненноеПолеТаблицы,,
			"Отчет.ОформлениеИзлишковНедостачТоваров.Форма"));
		
	Иначе
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(ТекстГиперссылки,,,,
			"Отчет.ОформлениеИзлишковНедостачТоваров.Форма"));
		Если УправлениеДоступом.ЕстьРоль("ДобавлениеИзменениеСкладскихАктов") Тогда
			МассивСтрок.Добавить(",");
			МассивСтрок.Добавить(" ");
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='оформить'"),,,,
				"Обработка.ПомощникОформленияСкладскихАктов.Форма"));
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
