
#Область ОбработчикиКомандФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаГраницы = ТекущаяДатаСеанса();
	ЗаполнитьСписокВыбораОрганизации();
КонецПроцедуры

&НаКлиенте
Процедура СкинутьГраницы(Команда)
	СкинутьГраницыНаСервере(ДатаГраницы, ГраницаПоОрганизации);
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораОрганизации()
	СписокВыбора = Элементы.ГраницаПоОрганизации.СписокВыбора;
	СписокВыбора.ЗагрузитьЗначения(Справочники.Организации.ДоступныеОрганизации(Истина));
	СписокВыбора.Вставить(0, Справочники.Организации.ПустаяСсылка(), НСтр("ru='<По всем организациям>'"));
КонецПроцедуры

&НаСервере
Процедура СкинутьГраницыНаСервере(ДатаГраницы, Организация)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ЗаданияПоОрганизации = Справочники.Организации.ДоступныеОрганизации(Истина);
	Иначе
		ЗаданияПоОрганизации = Организация;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		
		Элемент = Блокировка.Добавить("РегистрСведений.ЗаданияКРаспределениюРасчетовСПоставщиками");
		Элемент.Режим = РежимБлокировкиДанных.Исключительный;
		Если ТипЗнч(ЗаданияПоОрганизации) = Тип("СправочникСсылка.Организации") Тогда
			Элемент.УстановитьЗначение("Организация", ЗаданияПоОрганизации);
		Иначе // это массив организаций
			ТаблицаБлокировки = Новый ТаблицаЗначений;
			ТаблицаБлокировки.Колонки.Добавить("Организация");
			ТаблицаБлокировки.ЗагрузитьКолонку(ЗаданияПоОрганизации, "Организация");
			
			Элемент.ИсточникДанных = ТаблицаБлокировки;
			Элемент.ИспользоватьИзИсточникаДанных("Организация", "Организация");
		КонецЕсли;
		
		Элемент = Блокировка.Добавить("Константа.НомерЗаданияКРаспределениюРасчетовСПоставщиками");
		Элемент.Режим = РежимБлокировкиДанных.Исключительный;
		
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	1
		|ИЗ
		|	РегистрСведений.ЗаданияКРаспределениюРасчетовСПоставщиками КАК Задания
		|ГДЕ
		|	Задания.Организация В (&Организация)
		|	И Задания.Месяц < &НоваяДатаГраницы
		|;
		|//////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
		|	РасчетыСводно.АналитикаУчетаПоПартнерам,
		|	РасчетыСводно.Организация,
		|	РасчетыСводно.ОбъектРасчетов КАК ОбъектРасчетов
		|ИЗ
		|	(ВЫБРАТЬ РАЗЛИЧНЫЕ 
		|		Расчеты.АналитикаУчетаПоПартнерам,
		|		Расчеты.АналитикаУчетаПоПартнерам.Организация КАК Организация,
		|		Расчеты.ОбъектРасчетов КАК ОбъектРасчетов
		|	ИЗ
		|		РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
		|	ГДЕ
		|		Расчеты.АналитикаУчетаПоПартнерам.Организация В (&Организация)
		|		И Расчеты.Период >= &НоваяДатаГраницы
		|		И Расчеты.Сумма <> 0
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		РасчетыОфлайн.АналитикаУчетаПоПартнерам,
		|		РасчетыОфлайн.АналитикаУчетаПоПартнерам.Организация КАК Организация,
		|		РасчетыОфлайн.ЗаказПоставщику КАК ОбъектРасчетов
		|	ИЗ
		|		РегистрНакопления.РасчетыСПоставщикамиПоДокументам КАК РасчетыОфлайн
		|	ГДЕ
		|		РасчетыОфлайн.АналитикаУчетаПоПартнерам.Организация В (&Организация)
		|		И РасчетыОфлайн.Период >= &НоваяДатаГраницы
		|	) КАК РасчетыСводно
		|");
		
		Запрос.УстановитьПараметр("Организация", ЗаданияПоОрганизации);
		Запрос.УстановитьПараметр("НоваяДатаГраницы", ДатаГраницы);
		МассивЗапросов = Запрос.ВыполнитьПакет();
		
		ЕстьГраницыВПрошлом = МассивЗапросов[0].Пустой();
		Если НЕ ЕстьГраницыВПрошлом Тогда
			ТекстИсключения = НСтр("ru = 'Нельзя сдвигать границы в будущее, относительно старых границ.'");
			ВызватьИсключение ТекстИсключения;
		Иначе
			НомерЗадания = Константы.НомерЗаданияКРаспределениюРасчетовСПоставщиками.Получить();
			НовыеГраницы = МассивЗапросов[1].Выбрать();
			Пока НовыеГраницы.Следующий() Цикл
				Набор = РегистрыСведений.ЗаданияКРаспределениюРасчетовСПоставщиками.СоздатьНаборЗаписей();
				Набор.Отбор.АналитикаУчетаПоПартнерам.Установить(НовыеГраницы.АналитикаУчетаПоПартнерам);
				Набор.Отбор.Организация.Установить(НовыеГраницы.Организация);
				Набор.Отбор.ОбъектРасчетов.Установить(НовыеГраницы.ОбъектРасчетов);
				Набор.Отбор.Месяц.Установить(ДатаГраницы);
				Набор.Отбор.НомерЗадания.Установить(НомерЗадания);
				
				ЗаписьЗадания = Набор.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьЗадания, НовыеГраницы); 
				ЗаписьЗадания.Месяц = ДатаГраницы;
				ЗаписьЗадания.НомерЗадания = НомерЗадания;
				
				Набор.Записать(Истина);
			КонецЦикла;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ТекстСообщения = НСтр("ru = 'Не удалось перенести границы заданий по причине: %Причина%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			Метаданные.РегистрыСведений.ЗаданияКРаспределениюРасчетовСПоставщиками, ТекстСообщения);
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецПопытки
КонецПроцедуры

#КонецОбласти


