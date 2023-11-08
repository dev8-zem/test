#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
// Метод выводит в табличный документ предупреждение,
// если отчет формируетя по неактуальным данным
// Параметры:
//	Макет - ТабличныйДокумент - Макет, в который выводится предупреждение
//	ПараметрыРасчета - Структура - Свойства, в которых указаны данные о границах расчета.
Процедура ВывестиАктуальностьРасчета(Макет, ПараметрыРасчета) Экспорт
	Если ЗначениеЗаполнено(ПараметрыРасчета) И ПараметрыРасчета.Свойство("ГраницаВзаиморасчетов") Тогда
		Если ЗначениеЗаполнено(ПараметрыРасчета.ГраницаВзаиморасчетов) Тогда
			ТаблицаПредупреждение = Новый ТабличныйДокумент;
			ОбластьПредупреждение = ТаблицаПредупреждение.Область(1,1,1,1);
			Если Константы.АктуализироватьВзаиморасчетыПриФормированииОтчетов.Получить() Тогда
				ТекстПредупреждения = НСтр("ru ='Распределение расчетов выполнено до %ДатаАктуальности%. 
										|Запущено задание по распределению расчетов с %ДатаНачалаРаспределения% (требуется распределить расчеты для %КоличествоДокументов%). 
										|После распределения Вам будет предложено переформировать отчет.'");
			Иначе
				ТекстПредупреждения = НСтр("ru ='Распределение расчетов выполнено до %ДатаАктуальности%. 
										|Необходимо восстановить взаиморасчеты из формы закрытия месяца (пункт ""Формирование движений по расчетам с партнерами (контрагентами)"",
										|либо запустить регламентное задание ""Выполнение отложенных движений по расчетам с клиентами\поставщиками"".'");
			КонецЕсли;
			ДатаАктуальности = КонецМесяца(ПараметрыРасчета.ГраницаВзаиморасчетов - 1);
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения,"%ДатаАктуальности%", Формат(ДатаАктуальности, "ДЛФ=D"));
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения,"%ДатаНачалаРаспределения%", Формат(ПараметрыРасчета.ГраницаВзаиморасчетов, "ДЛФ=D"));
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения,"%КоличествоДокументов%", ОбщегоНазначенияУТ.ЧислоДокументовПрописью(ПараметрыРасчета.КРасчету));
			ОбластьПредупреждение.Текст = ТекстПредупреждения;
			ОбластьПредупреждение.ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
			Макет.ВставитьОбласть(ОбластьПредупреждение, Макет.Область(1,1,1,1), ТипСмещенияТабличногоДокумента.ПоВертикали);
		Иначе
			ПараметрыРасчета.Удалить("ГраницаВзаиморасчетов");
			ПараметрыРасчета.Удалить("НомерЗадания");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Метод возвращает значение константы "Номер задания",
// считанной при разделяемой блокировке.
//
// Возвращаемое значение:
//	Число - Номер текущего задания из константы "Номер задания к распределению расчетов с клиентами".
Функция ПолучитьНомерЗадания() Экспорт
	Возврат Константы.НомерЗаданияКРаспределениюРасчетовСКлиентами.Получить();
КонецФункции

// Метод создает запись регистра на указанный период по всем аналитикам за месяц.
//
// Параметры:
//	ПериодЗадания   - Дата - Начало периода, для которого необходимо зарегистрировать задание к расчету.
//
Процедура СоздатьЗаписьРегистра(ПериодЗадания) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// В РИБ данный регистр обрабатывается только в главном узле.
		Возврат;
	КонецЕсли;
		
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КРасчету.Организация КАК Организация,
	|	КРасчету.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		Расчеты.АналитикаУчетаПоПартнерам,
	|		Ключи.Организация
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|		
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПоПартнерам КАК Ключи
	|		ПО Расчеты.АналитикаУчетаПоПартнерам = Ключи.Ссылка
	|	ГДЕ
	|		Расчеты.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|		И Расчеты.Активность
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		РасчетыОфлайн.АналитикаУчетаПоПартнерам,
	|		Ключи.Организация
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентамиПоДокументам КАК РасчетыОфлайн
	|		
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПоПартнерам КАК Ключи
	|		ПО РасчетыОфлайн.АналитикаУчетаПоПартнерам = Ключи.Ссылка
	|	ГДЕ
	|		РасчетыОфлайн.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|		И РасчетыОфлайн.Активность
	|	) КАК КРасчету
	|");
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ПериодЗадания));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодЗадания));
	ТаблицаАналитик = Запрос.Выполнить().Выгрузить();
	
	// Запишем задания
	НачатьТранзакцию();
	Попытка
		НомерЗадания = Константы.НомерЗаданияКРаспределениюРасчетовСКлиентами.Получить();
		Для Каждого ТекущаяАналитика Из ТаблицаАналитик Цикл
			НаборЗаписей = РегистрыСведений.ЗаданияКРаспределениюРасчетовСКлиентами.СоздатьМенеджерЗаписи();
			НаборЗаписей.Месяц = НачалоМесяца(ПериодЗадания);
			НаборЗаписей.Организация = ТекущаяАналитика.Организация;
			НаборЗаписей.АналитикаУчетаПоПартнерам = ТекущаяАналитика.АналитикаУчетаПоПартнерам;
			НаборЗаписей.НомерЗадания = НомерЗадания;
			НаборЗаписей.Записать(Истина);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Не удалось записать задания к распределению расчетов с клиентами'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка);
		ВызватьИсключение;
	КонецПопытки
	
КонецПроцедуры

// Добавляет описания регистров для их подключения к механизму дат запрета изменения.
//
Процедура ОписаниеРегистровДляКонтроляДатЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных,
										Метаданные.РегистрыНакопления.РасчетыСКлиентами.ПолноеИмя(),
										"Период",
										"РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных,
										Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоДокументам.ПолноеИмя(),
										"Период",
										"РегламентныеОперации");
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Т1 
	|	ПО Т.АналитикаУчетаПоПартнерам = Т1.КлючАналитики
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т1.Организация)
	|	И ЗначениеРазрешено(Т1.Партнер)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КоличествоНеактуальныхДокументов(НачалоРасчета, КонецРасчета, АналитикиРасчета = Неопределено) Экспорт
	Запрос = Новый Запрос("
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		КОЛИЧЕСТВО(Расчеты.Регистратор) КАК Количество
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|	ГДЕ
	|		Расчеты.Период МЕЖДУ &НачалоРасчета И &КонецРасчета
	|		И (Расчеты.АналитикаУчетаПоПартнерам В (&АналитикаУчетаПоПартнерам)
	|			ИЛИ Расчеты.АналитикаУчетаПоПартнерам = ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПоПартнерам.ПустаяСсылка)
	|			ИЛИ &ПоВсемАналитикам)
	|		И Расчеты.Активность
	|");
	
	Запрос.УстановитьПараметр("НачалоРасчета", НачалоРасчета);
	Запрос.УстановитьПараметр("КонецРасчета", КонецРасчета);
	Запрос.УстановитьПараметр("АналитикаУчетаПоПартнерам", АналитикиРасчета.АналитикиУчетаПоПартнерам);
	Запрос.УстановитьПараметр("ПоВсемАналитикам", НЕ Значениезаполнено(АналитикиРасчета.АналитикиУчетаПоПартнерам));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		КоличествоДокументов = 0;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		КоличествоДокументов = Выборка.Количество;
	КонецЕсли;
	Возврат КоличествоДокументов;
КонецФункции

#КонецОбласти

#КонецЕсли
