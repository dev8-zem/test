#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если Параметры.Свойство("ТекущийЭлемент") Тогда
		ТекущаяСтрока = Параметры.ТекущийЭлемент;
		Если ТипЗнч(ТекущаяСтрока) = Тип("Строка") Тогда
			ТекущаяСтрока = Справочники.КлассификаторВидовЭкономическойДеятельности.НайтиПоКоду(ТекущаяСтрока);			
		КонецЕсли;
		Если ТипЗнч(ТекущаяСтрока) = Тип("СправочникСсылка.КлассификаторВидовЭкономическойДеятельности") И Не ТекущаяСтрока.Пустая() Тогда
			Элементы.Список.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ФормаПодборИзКлассификатора.Видимость = ПравоДоступа("Редактирование", Метаданные.Справочники.КлассификаторВидовЭкономическойДеятельности);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ДополнительныеПараметры.Вставить("Наименование", ТекДанные.Наименование);
		ДополнительныеПараметры.Вставить("Код", ТекДанные.Код);
		ДополнительныеПараметры.Вставить("НаименованиеПолное", ТекДанные.НаименованиеПолное);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстВопроса = НСтр("ru='Есть возможность подобрать услуги из классификатора.
	|Подобрать?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Подбор", Истина);
	ПараметрыФормы.Вставить("ИмяСправочника", "КлассификаторВидовЭкономическойДеятельности");
		
	ОткрытьФорму("ОбщаяФорма.ДобавлениеЭлементовВКлассификатор", ПараметрыФормы, ЭтаФорма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодобратьИзКлассификатора(ЭтаФорма.Команды.Найти("ПодобратьИзКлассификатора"));
	Иначе
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ДополнительныеПараметры);
		ОткрытьФорму("Справочник.КлассификаторВидовЭкономическойДеятельности.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
