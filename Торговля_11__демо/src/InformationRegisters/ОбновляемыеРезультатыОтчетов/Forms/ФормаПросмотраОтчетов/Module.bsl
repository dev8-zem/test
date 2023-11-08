
#Область ОбработчикиСобытийФормы
 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УИДПользователяИБ = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
	Пользователь = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ",
		Новый УникальныйИдентификатор(УИДПользователяИБ));
	
	Дашборд = Неопределено;
	Если Параметры.Свойство("Дашборд", Дашборд) Тогда
		Для Каждого ПодчиненныйЭлемент Из Элементы.ГруппаКнопокПросмотрОтчетов_.ПодчиненныеЭлементы Цикл
			Если ПодчиненныйЭлемент.Имя <> "ГруппаКнопокУдалитьРезультатОтчета" Тогда
				ПодчиненныйЭлемент.Доступность = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	ОбновитьСписокОфлайнОтчетов(Дашборд);

	Если СписокОфлайнОтчетов.Количество() > 0 Тогда
		ТекущийОфлайнОтчет = 1;
		ПрочитатьОфлайнОтчет();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокОфлайнОтчетов(Команда)
	
	ОткрытьФорму("РегистрСведений.ОбновляемыеРезультатыОтчетов.ФормаСписка",
				Новый Структура("Пользователь", Пользователь));
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиККонцу(Команда)
	
	ТекущийОфлайнОтчет = СписокОфлайнОтчетов.Количество();
	ПрочитатьОфлайнОтчет();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКНачалу(Команда)

	Если СписокОфлайнОтчетов.Количество() > 0 Тогда
		ТекущийОфлайнОтчет = 1;
		ПрочитатьОфлайнОтчет();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНазад(Команда)
	
	Если ТекущийОфлайнОтчет > 1 Тогда
		ТекущийОфлайнОтчет = ТекущийОфлайнОтчет - 1;
		ПрочитатьОфлайнОтчет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВперед(Команда)
	
	Если ТекущийОфлайнОтчет < СписокОфлайнОтчетов.Количество() Тогда
		ТекущийОфлайнОтчет = ТекущийОфлайнОтчет + 1;
		ПрочитатьОфлайнОтчет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРезультатОтчета(Команда)
	
	Если ТекущийОфлайнОтчет <> 0 Тогда
		УдалитьРезультатОтчетаНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокОфлайнОтчетов(Дашборд)
	
	ОфлайнОтчеты = РегистрыСведений.ОбновляемыеРезультатыОтчетов.СписокОфлайнОтчетовПользователя(Пользователь, ?(
		ЗначениеЗаполнено(Дашборд), Истина, Ложь));
	ОфлайнОтчеты.ЗаполнитьЗначения(Пользователь, "Пользователь");
	
	Если ЗначениеЗаполнено(Дашборд) Тогда
		н = 0;
		Пока н < ОфлайнОтчеты.Количество() Цикл
			Если ОфлайнОтчеты[н].Вариант = Дашборд Тогда
				н = н + 1;
			Иначе
				ОфлайнОтчеты.Удалить(н);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
	
	СписокОфлайнОтчетов.Загрузить(ОфлайнОтчеты);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьОфлайнОтчет()
	
	СтрокаОтчет = СписокОфлайнОтчетов[ТекущийОфлайнОтчет-1];
	
	ОтчетТабличныйДокумент.Очистить();
	ДатаАктуальности = Неопределено;
	
	МенеджерЗаписи = РегистрыСведений.ОбновляемыеРезультатыОтчетов.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтрокаОтчет);
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		Если МенеджерЗаписи.ОшибкаОбновленияОтчета Тогда
			РегистрыСведений.ОбновляемыеРезультатыОтчетов.СообщитьПользователю(НСтр(
				"ru = 'Результат отчета не был сформирован!'"));
		Иначе
			РезультатОтчета = МенеджерЗаписи.РезультатОтчета.Получить();
			Если ТипЗнч(РезультатОтчета) = Тип("ТабличныйДокумент") Тогда
				ОтчетТабличныйДокумент.Вывести(РезультатОтчета);
				МенеджерЗаписи.ДатаПоследнегоПросмотра = ТекущаяДатаСеанса();
				МенеджерЗаписи.Записать();
			Иначе
				РегистрыСведений.ОбновляемыеРезультатыОтчетов.СообщитьПользователю(НСтр(
					"ru = 'Ошибка при чтении результата отчета - некорректные данные'"));
			КонецЕсли;
		КонецЕсли;
		ДатаАктуальности = МенеджерЗаписи.ДатаАктуальности;
	Иначе
		РегистрыСведений.ОбновляемыеРезультатыОтчетов.СообщитьПользователю(НСтр(
			"ru = 'Ошибка при чтении результата отчета - отчет был удален'"));
	КонецЕсли;
	
	Заголовок = НСтр("ru = 'Актуальность: '") + ДатаАктуальности;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРезультатОтчетаНаСервере()
	
	СтрокаОтчет = СписокОфлайнОтчетов[ТекущийОфлайнОтчет-1];
	
	ОтчетТабличныйДокумент.Очистить();
	
	МенеджерЗаписи = РегистрыСведений.ОбновляемыеРезультатыОтчетов.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтрокаОтчет);
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Удалить();
	КонецЕсли;
	
	СписокОфлайнОтчетов.Удалить(СтрокаОтчет);
	
	Если ТекущийОфлайнОтчет > СписокОфлайнОтчетов.Количество() Тогда
		ТекущийОфлайнОтчет = СписокОфлайнОтчетов.Количество();
	КонецЕсли;
	
	Если ТекущийОфлайнОтчет > 0 Тогда
		ПрочитатьОфлайнОтчет();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти