
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем МассивУзловПланаОбмена, ОтборУзловПланаОбмена;
	
	Параметры.Свойство("МассивУзловПланаОбмена", МассивУзловПланаОбмена);
	Параметры.Свойство("ОтборУзловПланаОбмена", ОтборУзловПланаОбмена);
	
	Если ТипЗнч(МассивУзловПланаОбмена) = Тип("Массив") Тогда
		
		ЕстьДействующийОтбор = (ТипЗнч(ОтборУзловПланаОбмена) = Тип("Массив"));
		
		Для каждого Синхронизация Из МассивУзловПланаОбмена Цикл
			
			НоваяСтрока = СписокСинхронизаций.Добавить();
			НоваяСтрока.Синхронизация = Синхронизация;
			НоваяСтрока.Использование = (ЕстьДействующийОтбор И ОтборУзловПланаОбмена.Найти(Синхронизация) <> Неопределено);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОтборУзловПланаОбмена = Новый Массив;
	Для каждого СтрокаСинхронизации Из СписокСинхронизаций Цикл
		
		Если НЕ СтрокаСинхронизации.Использование Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ОтборУзловПланаОбмена.Добавить(СтрокаСинхронизации.Синхронизация);
		
	КонецЦикла;
	
	Закрыть(ОтборУзловПланаОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура Сбросить(Команда)
	
	Для каждого СтрокаТаблицы Из СписокСинхронизаций Цикл
		
		СтрокаТаблицы.Использование = Ложь;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
