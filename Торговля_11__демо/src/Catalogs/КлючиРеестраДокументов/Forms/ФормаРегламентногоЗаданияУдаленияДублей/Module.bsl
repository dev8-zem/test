
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	УстановитьПривилегированныйРежим(Истина);
	РегламентноеЗадание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Метаданные.РегламентныеЗадания.УдалениеДублейКлючейРеестраДокументов);
	УстановитьПривилегированныйРежим(Ложь);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РегламентноеЗадание, "Использование, Расписание, Наименование, ИнтервалПовтораПриАварийномЗавершении, КоличествоПовторовПриАварийномЗавершении");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбработчикОповещения = Новый ОписаниеОповещения("КомандаЗаписатьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОбработчикОповещения, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ЗаписатьРегламентноеЗадание();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Значение = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаписатьРегламентноеЗадание();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ОбработчикОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	Диалог.Показать(ОбработчикОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура КомандаЗаписатьИЗакрытьЗавершение(Значение = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаписатьРегламентноеЗадание();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Значение, ДополнительныеПараметры) Экспорт
	
	Если Значение <> Неопределено Тогда
		
		Расписание = Значение;
		Модифицированность = Истина;
		
		Если РазделениеВключено
			И Расписание.ПериодПовтораВТечениеДня > 0
			И Расписание.ПериодПовтораВТечениеДня < 3600 Тогда
			
			Расписание.ПериодПовтораВТечениеДня = 3600;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРегламентноеЗадание()
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегламентноеЗадание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Метаданные.РегламентныеЗадания.УдалениеДублейКлючейРеестраДокументов);
	ЗаполнитьЗначенияСвойств(РегламентноеЗадание, ЭтотОбъект, "Использование, Расписание, Наименование, ИнтервалПовтораПриАварийномЗавершении, КоличествоПовторовПриАварийномЗавершении");
	РегламентноеЗадание.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Модифицированность = Ложь;
	
КонецПроцедуры

#КонецОбласти
