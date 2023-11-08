#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийФормыЭлемента

// Обработчик события ПриОткрытии формы элемента справочника Договоры
//
// Параметры:
//  Отказ - Булево - признак отказа.
//  Форма - ФормаКлиентскогоПриложения - форма, для которой выполняется обработчик.
//
Процедура ПриОткрытии(Отказ, Форма) Экспорт
	//++ Локализация
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	СПАРКРискиКлиент.ПриОткрытии(Форма, Неопределено);
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
	//-- Локализация
КонецПроцедуры

// Обработка оповещения.
// 
// Параметры:
//  ИмяСобытия - Произвольный - имя события;
//  Параметр   - Произвольный - параметр оповещения;
//  Источник   - Произвольный - источник оповещения.
//  Форма      - ФормаКлиентскогоПриложения -
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник, Форма) Экспорт
	//++ Локализация
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	СПАРКРискиКлиент.ОбработкаОповещения(Форма, Неопределено, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Обработка навигационной ссылки формы.
// 
// Параметры:
//  Элемент - ГруппаФормы, ТаблицаФормы, ПолеФормы, КнопкаФормы - ЭлементФормы
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - Навигационная ссылка форматированной строки
//  СтандартнаяОбработка - Булево -Стандартная обработка
//  Форма - ФормаКлиентскогоПриложения -
Процедура ОбработкаНавигационнойСсылкиФормы(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, Форма) Экспорт
	//++ Локализация
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "НастроитьГОЗ" Тогда
		НастроитьГОЗ(Форма);
	КонецЕсли;
	Если Элемент.Имя = "ДекорацияИндексыСПАРКРиски" Тогда
		СПАРКРискиКлиент.ОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

// При изменении реквизита.
// 
// Параметры:
//	Элемент - ГруппаФормы, ТаблицаФормы, ПолеФормы, КнопкаФормы - ЭлементФормы
//  Форма - ФормаКлиентскогоПриложения - 
Процедура ПриИзмененииРеквизита(Элемент, Форма) Экспорт
	//++ Локализация
	Если Элемент.Имя = "Контрагент" Тогда
		// ИнтернетПоддержкаПользователей.СПАРКРиски
		// Отображать не по ссылке, а по ИНН, НЕ сохраняя в кэше.
		Форма.ИндексыСПАРКРиски = Неопределено; // Сбросить полученные значения.
		ОбновитьОтображениеИндексыСПАРК(Форма);
		// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	КонецЕсли;

	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормыЭлемента

Процедура ВыполнитьКомандуЛокализации(Команда, Форма) Экспорт
	//++ Локализация
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиКомандФормы_Контрагенты_Служебные

//++ Локализация


// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - содержит:
// 		* Объект - ДанныеФормыСтруктура - Содержит:
// 			** Ссылка - СправочникСсылка.ДоговорыКонтрагентов
// 
Процедура НастроитьГОЗ(Форма)
	Объект = Форма.Объект;
	
	Попытка
		Форма.ЗаблокироватьДанныеФормыДляРедактирования();
	Исключение
		ПоказатьПредупреждение(Неопределено, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("НастроитьГОЗЗавершение", ЭтотОбъект, Новый Структура("Форма", Форма));
	ПараметрыОткрытияФормы = Новый Структура(ДоговорыКонтрагентовЛокализацияКлиентСервер.ИменаРеквизитовГОЗ());
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытияФормы, Форма);
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытияФормы, Объект);
	ПараметрыОткрытияФормы.ДоговорСсылка = Объект.Ссылка;
	Если ЗначениеЗаполнено(Объект.ГосударственныйКонтракт) Тогда
		ПараметрыОткрытияФормы.ПлатежиПо275ФЗ = Истина;
		ПараметрыОткрытияФормы.ДоговорСУчастникомГОЗ = Истина;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ФормаГК",
		ПараметрыОткрытияФормы,
		Форма,,,,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура НастроитьГОЗЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Если ЗначениеЗаполнено(Результат) 
		И ТипЗнч(Результат) = Тип("Структура") Тогда
		ОбщегоНазначенияУТКлиент.ПродолжитьВыполнениеКоманды(Форма,
			"ЗаполнитьДоговорПоДаннымФормыНастройкиГОЗ",
			Истина,
			Результат);
	КонецЕсли;
	
КонецПроцедуры

//-- Локализация
#КонецОбласти

//++ Локализация

// Обновляет отображение индексов СПАРК Риски.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма обработчика.
//
Процедура ОбновитьОтображениеИндексыСПАРК(Форма) Экспорт

	Если Форма.КонтрагентЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо")
		Или Форма.КонтрагентЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент") Тогда
			ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ЮридическоеЛицо");
	ИначеЕсли Форма.КонтрагентЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель") Тогда
		ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ИндивидуальныйПредприниматель");
	Иначе
		ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ВидыКонтрагентовСПАРКРиски.ПустаяСсылка");
	КонецЕсли;
	
	ПараметрыОтображения = Новый Структура("ВариантОтображения", "Однострочный");
	СПАРКРискиКлиент.ОтобразитьИндексыСПАРК(
		Форма.ИндексыСПАРКРиски,
		Неопределено,
		Форма.Объект.Контрагент, // Искать по ссылке
		ВидКонтрагента,
		Форма,
		ПараметрыОтображения,
		Истина);

КонецПроцедуры
//-- Локализация

#КонецОбласти


