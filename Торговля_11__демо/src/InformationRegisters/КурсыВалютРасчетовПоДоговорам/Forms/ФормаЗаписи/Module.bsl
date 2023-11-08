
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Запись.Договор) Тогда
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Договор, "Организация, ВалютаВзаиморасчетов");
		БазоваяВалюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(РеквизитыДоговора.Организация);
		Валюта = РеквизитыДоговора.ВалютаВзаиморасчетов;
		Элементы.Договор.Видимость = Ложь;
	Иначе
		Элементы.ДоговорНадпись.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоговорНадписьНажатие(Элемент, СтандартнаяОбработка)
	ПараметрыОткрытия = Новый Структура("Ключ", Запись.Договор);
	Если ТипЗнч(Запись.Договор) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
		ОткрытьФорму("Справочник.ДоговорыМеждуОрганизациями.ФормаОбъекта", ПараметрыОткрытия);
	Иначе
		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", ПараметрыОткрытия);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
