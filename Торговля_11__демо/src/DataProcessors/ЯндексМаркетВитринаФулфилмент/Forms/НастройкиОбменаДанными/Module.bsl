
&НаСервере
Функция ПолучитьСписокСкладов(УчетнаяЗапись, ТолькоИзСервиса = Ложь) Экспорт   
	
	
	ТабСкладов = НоваяТаблицаСкладов();
	
	СопоставленныеСклады = ПолучитьСопоставленныеСклады(УчетнаяЗапись, Ложь, Ложь);  
	
	Для Каждого ДанныеСклада Из СопоставленныеСклады Цикл 
		НоваяСтрока = ТабСкладов.Добавить();  
		НоваяСтрока.ИдентификаторСкладаМаркетплейса = ДанныеСклада.ИдентификаторСклада;
		НоваяСтрока.НаименованиеСкладаМаркетплейса = ДанныеСклада.НаименованиеСклада;
		НоваяСтрока.Склад1С = ДанныеСклада.Склад;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ТабСкладов", ТабСкладов);
	
	Возврат Результат;
	
КонецФункции  

&НаСервере
Функция НоваяТаблицаСкладов()
	
	ТабСкладов = Новый ТаблицаЗначений;    
	ТабСкладов.Колонки.Добавить("ИдентификаторСкладаМаркетплейса", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(50)));
	ТабСкладов.Колонки.Добавить("НаименованиеСкладаМаркетплейса", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(250)));
	ТабСкладов.Колонки.Добавить("ЭтоRealFBS", Новый ОписаниеТипов("Булево"));
	ТабСкладов.Колонки.Добавить("Склад1С", Новый ОписаниеТипов("СправочникСсылка.Склады"));
	
	Возврат ТабСкладов;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеУчетнойЗаписи()
	
	УчетнаяЗаписьОбъект = УчетнаяЗапись.ПолучитьОбъект();
	УчетнаяЗаписьОбъект.ИсточникКатегории = ИсточникКатегории;
	ТабличнаяЧастьВидовЦен = УчетнаяЗаписьОбъект.ВидыЦен; 
	СтрЦенаПродажи = НСтр("ru = 'Цена продажи'");
	СтрокаЦеныПродажи = ТабличнаяЧастьВидовЦен.Найти(СтрЦенаПродажи,"ИмяНастройки");
	Если СтрокаЦеныПродажи = Неопределено Тогда
		СтрокаЦеныПродажи = ТабличнаяЧастьВидовЦен.Добавить();
		СтрокаЦеныПродажи.ИмяНастройки = СтрЦенаПродажи;
		СтрокаЦеныПродажи.ВидЦены = ЦенаПродажи;
	Иначе
		СтрокаЦеныПродажи.ВидЦены = ЦенаПродажи;
	КонецЕсли;
	УчетнаяЗаписьОбъект.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДанныеУчетнойЗаписиЯндексМаркет = ИнтеграцияСЯндексМаркетСервер.ДанныеУчетнойЗаписиЯндексМаркет();
	УчетнаяЗапись = ДанныеУчетнойЗаписиЯндексМаркет.УчетнаяЗапись;
	ЦенаПродажи = ДанныеУчетнойЗаписиЯндексМаркет.ЦенаПродажи;
	ИсточникКатегории = ДанныеУчетнойЗаписиЯндексМаркет.ИсточникКатегории;	
	ЗаполнитьДанныеПоУчетнойЗаписи();
	ОбновитьВидимостьКнопокНазадДалее();
	
КонецПроцедуры   

&НаСервере
Процедура ЗаполнитьДанныеПоУчетнойЗаписи()  	
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоответствияОбъектовМаркетплейсов.ИдентификаторОбъектаМаркетплейса КАК ИдентификаторОбъектаМаркетплейса,
		|	СоответствияОбъектовМаркетплейсов.НаименованиеОбъектаМаркетплейса КАК НаименованиеОбъектаМаркетплейса,
		|	СоответствияОбъектовМаркетплейсов.Объект1С КАК Склад
		|ИЗ
		|	РегистрСведений.СоответствияОбъектовМаркетплейсов КАК СоответствияОбъектовМаркетплейсов
		|ГДЕ
		|	СоответствияОбъектовМаркетплейсов.УчетнаяЗаписьМаркетплейса.ВидМаркетплейса = ЗНАЧЕНИЕ(Перечисление.ВидыМаркетплейсов.МаркетплейсЯндексМаркет)
		|	И СоответствияОбъектовМаркетплейсов.ВидОбъектаМаркетплейса = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовМаркетплейсов.Склад)";
	
	Запрос.УстановитьПараметр("ВидОбъектаМаркетплейса", Перечисления.ВидыОбъектовМаркетплейсов.Склад);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
	ТаблицаСкладов.Очистить();
	Пока РезультатЗапроса.Следующий() Цикл
		НовСтр = ТаблицаСкладов.Добавить();
		НовСтр.ИдентификаторСкладаМаркетплейса = РезультатЗапроса.ИдентификаторОбъектаМаркетплейса;
		НовСтр.НаименованиеСкладаМаркетплейса = РезультатЗапроса.НаименованиеОбъектаМаркетплейса;
		НовСтр.Склад1С = РезультатЗапроса.Склад;
	КонецЦикла;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПараметрыФормыНастройкиРегламентногоЗадания(ИмяМетаданных)
	
	УстановитьПривилегированныйРежим(Истина);
	Отбор = Новый Структура();
	Отбор.Вставить("Метаданные", ИмяМетаданных);
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	
	УникальныйИдентификаторРегламентногоЗадания = Неопределено;
	Если Задания.Количество() > 0 Тогда
		УникальныйИдентификаторРегламентногоЗадания = Задания[0].УникальныйИдентификатор;
		ПараметрыФормы = Новый Структура("Действие, Идентификатор","Изменить",УникальныйИдентификаторРегламентногоЗадания);
	Иначе
		УникальныйИдентификаторРегламентногоЗадания = Новый УникальныйИдентификатор;
		ПараметрыФормы = Новый Структура("Действие, Идентификатор","Добавить",УникальныйИдентификаторРегламентногоЗадания);	  	
	КонецЕсли;    
	УстановитьПривилегированныйРежим(Ложь);

	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьРасписаниеВыгрузкиЦен(Команда)  
	
	ИмяМетаданных =  "ВыгрузкаУстановленныхЦенВСервисЯндексМаркет";
	ПараметрыФормы = ПолучитьПараметрыФормыНастройкиРегламентногоЗадания(ИмяМетаданных);
	ОткрытьФорму("Обработка.ЯндексМаркетВитринаФулфилмент.Форма.РегламентноеЗадание",
	ПараметрыФормы,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);     
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеВыгрузкиОстатковТоваров(Команда)

	ИмяМетаданных =  "ВыгрузкаОстатковТоваровЯндексМаркет";
	ПараметрыФормы = ПолучитьПараметрыФормыНастройкиРегламентногоЗадания(ИмяМетаданных);
	ОткрытьФорму("Обработка.ЯндексМаркетВитринаФулфилмент.Форма.РегламентноеЗадание",
	ПараметрыФормы,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 

КонецПроцедуры


&НаКлиенте
Процедура ОткрытьРасписаниеОбновленияЦен(Команда)
	ОткрытьФорму("Справочник.ВидыЦен.Форма.ФормаНастройкиРасписанияАвтообновленияЦен",, ЭтотОбъект,,);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЦен(Команда)
	
	ОткрытьФорму(
	"Справочник.ВидыЦен.Форма.ФормаСписка",
	,,Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеПолученияРекомендованныхСвязей(Команда)
	
	ИмяМетаданных =  "ПолучениеРекомендацийПоСклейкеТовараЯндексМаркет";
	ПараметрыФормы = ПолучитьПараметрыФормыНастройкиРегламентногоЗадания(ИмяМетаданных);
	ОткрытьФорму("Обработка.ЯндексМаркетВитринаФулфилмент.Форма.РегламентноеЗадание",
	ПараметрыФормы,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеОтправкиНаМодерациюСвязейТоваров(Команда)
	
	ИмяМетаданных =  "ОтправкаНаМодерациюСвязейТоваровЯндексМаркет";
	ПараметрыФормы = ПолучитьПараметрыФормыНастройкиРегламентногоЗадания(ИмяМетаданных);
	ОткрытьФорму("Обработка.ЯндексМаркетВитринаФулфилмент.Форма.РегламентноеЗадание",
	ПараметрыФормы,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеПолученияСтатусовМодерации(Команда)
	
	ИмяМетаданных =  "ПолучениеСтатусовМодерацииТоваровЯндексМаркет";
	ПараметрыФормы = ПолучитьПараметрыФормыНастройкиРегламентногоЗадания(ИмяМетаданных);
	ОткрытьФорму("Обработка.ЯндексМаркетВитринаФулфилмент.Форма.РегламентноеЗадание",
	ПараметрыФормы,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСоответствиеСкладов()
	
	НаборЗаписей = РегистрыСведений.СоответствияОбъектовМаркетплейсов.СоздатьНаборЗаписей();   
	НаборЗаписей.Отбор.УчетнаяЗаписьМаркетплейса.Установить(УчетнаяЗапись);
	НаборЗаписей.Отбор.ВидОбъектаМаркетплейса.Установить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовМаркетплейсов.Склад"));  
			
	Для каждого Стр Из ТаблицаСкладов Цикл  	
		Если ЗначениеЗаполнено(Стр.Склад1С) Тогда 
			Запись = НаборЗаписей.Добавить();  
			Запись.УчетнаяЗаписьМаркетплейса = УчетнаяЗапись;	 	                                                
			Запись.ВидОбъектаМаркетплейса = ПредопределенноеЗначение("Перечисление.ВидыОбъектовМаркетплейсов.Склад"); 
			Запись.ИдентификаторОбъектаМаркетплейса = Стр.ИдентификаторСкладаМаркетплейса; 
			Запись.НаименованиеОбъектаМаркетплейса =  Стр.НаименованиеСкладаМаркетплейса; 
			Запись.Объект1С = Стр.Склад1С; 
			Запись.ДатаАктуальности = ТекущаяДатаСеанса();
		КонецЕсли; 
	КонецЦикла;
	
	НаборЗаписей.Записать();  
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСопоставленныеСклады(УчетнаяЗапись, ТолькоСсылки = Истина, ВыводитьПодчиненныеСклады = Истина) Экспорт

	СопоставленныеСклады = Новый ТаблицаЗначений;
	СопоставленныеСклады.Колонки.Добавить("Группа", Новый ОписаниеТипов("СправочникСсылка.Склады"));
	СопоставленныеСклады.Колонки.Добавить("Склад", Новый ОписаниеТипов("СправочникСсылка.Склады"));
	СопоставленныеСклады.Колонки.Добавить("ИдентификаторСклада", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50)));
	СопоставленныеСклады.Колонки.Добавить("НаименованиеСклада", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(250)));

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоответствияОбъектов.Объект1С КАК Склад,
	|	СоответствияОбъектов.ИдентификаторОбъектаМаркетплейса КАК ИдентификаторСклада,
	|	СоответствияОбъектов.НаименованиеОбъектаМаркетплейса КАК НаименованиеСклада,
	|	СоответствияОбъектов.Объект1С.ЭтоГруппа КАК ЭтоГруппаСкладов
	|ИЗ
	|	РегистрСведений.СоответствияОбъектовМаркетплейсов КАК СоответствияОбъектов
	|ГДЕ
	|	СоответствияОбъектов.УчетнаяЗаписьМаркетплейса = &УчетнаяЗаписьМаркетплейса
	|	И СоответствияОбъектов.ВидОбъектаМаркетплейса = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовМаркетплейсов.Склад)";
	Запрос.УстановитьПараметр("УчетнаяЗаписьМаркетплейса", УчетнаяЗапись);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Если ТолькоСсылки Тогда
			Возврат Новый Массив;
		Иначе
			Возврат СопоставленныеСклады;
		КонецЕсли;
	КонецЕсли;

	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл  
		Если ВыводитьПодчиненныеСклады И Выборка.ЭтоГруппаСкладов Тогда
			ПодчиненныеСклады = СкладыСервер.СписокПодчиненныхСкладов(Выборка.Склад);
			Для каждого Склад Из ПодчиненныеСклады Цикл
				НоваяСтрока = СопоставленныеСклады.Добавить();
				НоваяСтрока.Группа = Выборка.Склад;
				НоваяСтрока.Склад = Склад.Значение;
				НоваяСтрока.ИдентификаторСклада = Выборка.ИдентификаторСклада;
				НоваяСтрока.НаименованиеСклада = Выборка.НаименованиеСклада;
			КонецЦикла;
		Иначе
			НоваяСтрока = СопоставленныеСклады.Добавить();
			НоваяСтрока.Группа = Выборка.Склад;
			НоваяСтрока.Склад = Выборка.Склад;
			НоваяСтрока.ИдентификаторСклада = Выборка.ИдентификаторСклада;
			НоваяСтрока.НаименованиеСклада = Выборка.НаименованиеСклада;
		КонецЕсли;
	КонецЦикла;

	Если ТолькоСсылки Тогда
		СопоставленныеСклады.Свернуть("Склад");
		Возврат СопоставленныеСклады.ВыгрузитьКолонку("Склад");
	Иначе
		СопоставленныеСклады.Свернуть("Группа, Склад, ИдентификаторСклада, НаименованиеСклада");
		Возврат СопоставленныеСклады;
	КонецЕсли;

КонецФункции

&НаКлиенте 
Функция СоответствиеПереключенияСтраниц()
	
	СоответствиеПереключенияСтраниц = Новый Соответствие; 
	СоответствиеПереключенияСтраниц.Вставить("СтраницаСопоставлениеДанных_Далее", "СтраницаНастройкиОбновленияЦен");
	СоответствиеПереключенияСтраниц.Вставить("СтраницаНастройкиОбновленияЦен_Далее", "СтраницаНастройкиОбменаОстатками");
	СоответствиеПереключенияСтраниц.Вставить("СтраницаНастройкиОбновленияЦен_Назад", "СтраницаСопоставлениеДанных");
	СоответствиеПереключенияСтраниц.Вставить("СтраницаНастройкиОбменаОстатками_Назад", "СтраницаНастройкиОбновленияЦен");
	
	Возврат СоответствиеПереключенияСтраниц;
	
КонецФункции

&НаКлиенте
Процедура СменитьСтраницу(Постфикс) 
	
	СоответствиеПереключенияСтраниц = СоответствиеПереключенияСтраниц();
	Элементы.Страницы.ТекущаяСтраница = Элементы[СоответствиеПереключенияСтраниц[Элементы.Страницы.ТекущаяСтраница.Имя + Постфикс]];
	ОбновитьВидимостьКнопокНазадДалее();

КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)

	ОбновитьВидимостьКнопокНазадДалее();

КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьКнопокНазадДалее()
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаСопоставлениеДанных Тогда   
		Элементы.ФормаНазад.Видимость = Ложь;	
	Иначе
		Элементы.ФормаНазад.Видимость = Истина;	
	КонецЕсли;  
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаНастройкиОбменаОстатками Тогда
		Элементы.ФормаДалее.Видимость = Ложь;	
	Иначе
		Элементы.ФормаДалее.Видимость = Истина;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)  
	
	СменитьСтраницу("_Далее"); 
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)   
	
	СменитьСтраницу("_Назад");  

КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()
	
	ОбновитьДанныеУчетнойЗаписи();
	ЗаписатьСоответствиеСкладов();
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьНаСервере();
	ЭтаФорма.Закрыть();
	
КонецПроцедуры
