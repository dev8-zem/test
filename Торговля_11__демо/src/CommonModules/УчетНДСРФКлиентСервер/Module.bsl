
#Область ПрограммныйИнтерфейс

#Область ПроцедурыПроверкиКорректностиНомераТаможеннойДекларации

// Возвращает структуру регистрационного номера таможенной декларации по переданному полному номеру декларации на товары,
// а также проверяет корректность ввода номера таможенной декларации.
// Регистрационный номер не будет определен если "полный" номер таможенной декларации не соответствует структуре номера
// декларации, выдаваемой российскими таможенными органами.
//
// Регистрационный номер таможенной декларации может быть получен из "полного" номера таможенной декларации или
// регистрационного номера при условиях:
// 1. Длина номера таможенной декларации от 17 до 28 символов.
// 2. Количество элементов, разделенных знаком дробь ("/") 3 или 4.
// 3. Длина первого элемента 2, 5 или 8 символов, второго 6, третьего 7 или 8 (в этом случае первые два символа "ОБ" или
//    "ЗВ"), четвертого (при наличии) от 1 до 3 символов.
// 4. Второй элемент можно преобразовать в дату.
//
// Регистрационный номер таможенной декларации будет получен из "полного" номера таможенной декларации путем отсечения
// последнего (4-го) элемента номера.
//
// Параметры:
//	НомерТаможеннойДекларации - Строка - номер таможенной декларации или регистрационный номер таможенной декларации.
//	НачалоКорректногоПериода - Дата - дата начала периода проверки.
//	КонецКорректногоПериода - Дата - дата окончания периода проверки.
//
// Возвращаемое значение:
//	Структура:
//		* РегистрационныйНомер - Строка - регистрационный номер таможенной декларации либо пустая строка, если его
//											не удалось определить.
//		* ПорядковыйНомерТовара - Строка - порядковый номер товара из графы 32 ДТ.
//		* КодОшибки - Число - код ошибки, расшифровка см. ТекстОшибкиВНомереТаможеннойДекларации.
//
Функция ПроверитьКорректностьНомераТаможеннойДекларации(НомерТаможеннойДекларации,
														НачалоКорректногоПериода = Неопределено,
														КонецКорректногоПериода = Неопределено) Экспорт
	
	СтруктураНомера = Новый Структура("РегистрационныйНомер, ПорядковыйНомерТовара, КодОшибки", "", "", 0);

	НомерДекларацииНаТовары = СокрЛП(НомерТаможеннойДекларации);
	
	Если Не ЗначениеЗаполнено(НомерДекларацииНаТовары) Тогда
		// Пользователь еще ничего не ввел.
		Возврат СтруктураНомера;
	КонецЕсли;
	
	МассивТД = СтрРазделить(НомерДекларацииНаТовары, "/");
	
	Если МассивТД.Количество() > 4
		Или МассивТД.Количество() < 3 Тогда
		
		// Ошибочное количество элементов.
		СтруктураНомера.КодОшибки = 1;
		
		Возврат СтруктураНомера;
		
	КонецЕсли;
	
	КодТаможенногоОргана = СокрЛП(МассивТД[0]);
	
	Если СтрДлина(КодТаможенногоОргана) <> 2
		И СтрДлина(КодТаможенногоОргана) <> 5
		И СтрДлина(КодТаможенногоОргана) <> 8 Тогда
		
		// Ошибочная длина кода таможенного органа.
		СтруктураНомера.КодОшибки = 2;
		
		Возврат СтруктураНомера;
		
	КонецЕсли;
	
	ДатаПринятияДекларацииНаТовары = СокрЛП(МассивТД[1]);
	
	Если СтрДлина(ДатаПринятияДекларацииНаТовары) <> 6 Тогда
		// Ошибочная длина поля дата.
		СтруктураНомера.КодОшибки = 3;
		
		Возврат СтруктураНомера;
	Иначе
		// Проверим корректность указания даты.
		Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ДатаПринятияДекларацииНаТовары) Тогда
			// Длина поля верная, но дата указана ошибочно.
			СтруктураНомера.КодОшибки = 3;
			
			Возврат СтруктураНомера;
		КонецЕсли; 
		
		СтрокаВДату = СтроковыеФункцииКлиентСервер.СтрокаВДату(ДатаПринятияДекларацииНаТовары);
		
		Если Не ЗначениеЗаполнено(СтрокаВДату) Тогда
			// Длина поля верная, но дата указана ошибочно.
			СтруктураНомера.КодОшибки = 3;
			
			Возврат СтруктураНомера;
		Иначе
			Если Не НачалоКорректногоПериода = Неопределено
				И Не КонецКорректногоПериода = Неопределено Тогда
				
				// Проверим год на корректность указания.
				Если СтрокаВДату < НачалоКорректногоПериода 
					Или СтрокаВДату > КонецКорректногоПериода Тогда
					
					СтруктураНомера.КодОшибки = 4;
					
					Возврат СтруктураНомера;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ПорядковыйНомерДекларацииНаТовары = СокрЛП(МассивТД[2]);
	
	Если СтрДлина(ПорядковыйНомерДекларацииНаТовары) < 7
		Или СтрДлина(ПорядковыйНомерДекларацииНаТовары) > 8 Тогда
		
		// Ошибочная длина поля порядковый номер.
		СтруктураНомера.КодОшибки = 5;
		
		Возврат СтруктураНомера;
		
	КонецЕсли;
	
	Если СтрДлина(ПорядковыйНомерДекларацииНаТовары) = 7 Тогда
		ПервыйСимвол = ВРег(Лев(ПорядковыйНомерДекларацииНаТовары, 1));
		
		Если (ПервыйСимвол = "В"
				Или ПервыйСимвол = "B") Тогда
			
			Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Прав(ПорядковыйНомерДекларацииНаТовары,6)) Тогда
				// Ошибочный формат поля порядковый номер.
				СтруктураНомера.КодОшибки = 5;
				
				Возврат СтруктураНомера;
			КонецЕсли;
			
		Иначе
			Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПорядковыйНомерДекларацииНаТовары) Тогда
				// Ошибочный формат поля порядковый номер.
				СтруктураНомера.КодОшибки = 5;
				
				Возврат СтруктураНомера;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// В случае выпуска товаров до подачи таможенной декларации импортер представляет в налоговый орган
	// обязательство о подаче таможенной декларации (до 2018 года) 
	// или заявление о выпуске товаров (с 1 января 2018 года).
	// При этом порядковый номер декларации на товары состоит из 8 символов.
	// Порядковый принимает вид "ОБ123456" или "ЗВ123456".
	Если СтрДлина(ПорядковыйНомерДекларацииНаТовары) = 8 Тогда
		ПервыеДваСимвола = ВРег(Лев(ПорядковыйНомерДекларацииНаТовары, 2));
		
		Если ПервыеДваСимвола = "0Б" Тогда 
			// Вместо буквы "О" указана цифра ноль.
			СтруктураНомера.КодОшибки = 6;
			
			Возврат СтруктураНомера;
		ИначеЕсли ПервыеДваСимвола = "3В"
			Или ПервыеДваСимвола = "3B" Тогда
			
			// Вместо буквы "З" указана цифра три.
			СтруктураНомера.КодОшибки = 7;
			
			Возврат СтруктураНомера;
			
		ИначеЕсли ПервыеДваСимвола <> "ОБ"
				И ПервыеДваСимвола <> "OБ"
				И ПервыеДваСимвола <> "ЗВ"
				И ПервыеДваСимвола <> "ЗB" Тогда
			
			// Ошибочный формат поля порядковый номер.
			СтруктураНомера.КодОшибки = 5;
			
			Возврат СтруктураНомера;
			
		КонецЕсли;
		
		ПоследниеШестьСимволов = ВРег(Прав(ПорядковыйНомерДекларацииНаТовары, 6));
		
		Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПоследниеШестьСимволов) Тогда
			// Ошибочный формат поля порядковый номер.
			СтруктураНомера.КодОшибки = 5;
			
			Возврат СтруктураНомера;
		КонецЕсли;
	КонецЕсли;
	
	Если МассивТД.Количество() = 4 Тогда
		ПорядковыйНомерТовара = СокрЛП(МассивТД[3]);
		
		Если СтрДлина(ПорядковыйНомерТовара) > 3
			Или СтрДлина(ПорядковыйНомерТовара) < 1 Тогда
			
			// Ошибочная длина поля порядковый номер товара.
			СтруктураНомера.КодОшибки = 8;
			
			Возврат СтруктураНомера;
			
		КонецЕсли;
		
		СтруктураНомера.ПорядковыйНомерТовара = ПорядковыйНомерТовара;
		
		МассивТД.Удалить(3);
	КонецЕсли;
	
	СтруктураНомера.РегистрационныйНомер = СтрСоединить(МассивТД, "/");
	
	Возврат СтруктураНомера;
	
КонецФункции

// Возвращает текстовое описание ошибки при вводе номера таможенной декларации.
//
// Параметры:
//	КодОшибки - Число - код ошибки
//
// Возвращаемое значение:
//	Строка - текстовое описание ошибки в номере таможенной декларации.
//
Функция ТекстОшибкиВНомереТаможеннойДекларации(КодОшибки) Экспорт
	
	ТекстОшибки = "";
	
	Если КодОшибки = 1 Тогда
		ТекстОшибки = НСтр("ru='Номер должен состоять из трех или четырех блоков, разделенных дробью ""/""'");
	ИначеЕсли КодОшибки = 2 Тогда
		ТекстОшибки = НСтр("ru='Первый блок (код таможенного органа) в зависимости от страны ввоза должен состоять из 2, 5 или 8 цифр'");
	ИначеЕсли КодОшибки = 3 Тогда
		ТекстОшибки = НСтр("ru='Второй блок (дата регистрации декларации) должен быть в формате ДДММГГ'");
	ИначеЕсли КодОшибки = 4 Тогда
		ТекстОшибки = НСтр("ru='Во втором блоке (дата регистрации декларации) указанный год лежит за пределами допустимого периода'");
	ИначеЕсли КодОшибки = 5 Тогда
		ТекстОшибки = НСтр("ru='Третий блок (порядковый номер декларации) может состоять из (один из вариантов):
									|  1) 7 цифр
									|  2) двух букв (""ОБ"" или ""ЗВ"") и 6 цифр
									|  3) одной буквы (""В"") и 6 цифр'");
	ИначеЕсли КодОшибки = 6 Тогда
		ТекстОшибки = НСтр("ru='В третьем блоке вместо буквы ""О"" указана цифра ноль'");
	ИначеЕсли КодОшибки = 7 Тогда
		ТекстОшибки = НСтр("ru='В третьем блоке вместо буквы ""З"" указана цифра три'");
	ИначеЕсли КодОшибки = 8 Тогда
		ТекстОшибки = НСтр("ru='Четвертый блок (порядковый номер товара) должен содержать от 1 до 3 цифр'");
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции

#КонецОбласти

#КонецОбласти