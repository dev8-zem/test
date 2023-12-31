
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		Возврат;	// Создание новых элементов из формы списка не предусмотрено.
	КонецЕсли;

	Элементы.ДекорацияАктивнаяУчетнаяЗапись.Видимость = НЕ Объект.ПометкаУдаления;
	Элементы.ДекорацияАрхивнаяУчетнаяЗапись.Видимость = Объект.ПометкаУдаления;
	Элементы.ВалютаУчета.Доступность = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");

КонецПроцедуры  

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ПараметрыФормыСопоставленияКатегорий = Новый Структура;
	ПараметрыФормыСопоставленияКатегорий.Вставить("УчетнаяЗапись", Объект.Ссылка);
	ПараметрыФормыСопоставленияКатегорий.Вставить("ИсточникКатегории", Объект.ИсточникКатегории);
	Оповестить("ИсточникКатегорииИзменен", ПараметрыФормыСопоставленияКатегорий);

КонецПроцедуры

#КонецОбласти
