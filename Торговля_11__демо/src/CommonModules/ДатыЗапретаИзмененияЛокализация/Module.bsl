#Область ПрограммныйИнтерфейс

// Вызывается из переопределяемого модуля.
// см. ДатыЗапретаИзмененияПереопределяемый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения
//
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт

	//++ Локализация	
#Область Банк
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных,
										Метаданные.Документы.ОперацияПоЯндексКассе.ПолноеИмя(),
										"Дата",
										"Банк",
										"БанковскийСчет");
#КонецОбласти

#Область ВводОстатков
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных,
										Метаданные.Документы.ВводОстатковНДСПредъявленного.ПолноеИмя(),
										"Дата",
										"ВводОстатков",
										"Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных,
										Метаданные.Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.ПолноеИмя(),
										"Дата",
										"ВводОстатков",
										"Организация");
#КонецОбласти

#Область ВнутреннееТовародвижение
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных,
										Метаданные.Документы.КорректировкаОбособленногоУчетаЗапасов.ПолноеИмя(),
										"Дата",
										"ВнутреннееТовародвижение",
										"Организация");
										
#КонецОбласти

#Область Закупки
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных,
										Метаданные.Документы.УведомлениеОВвозеПрослеживаемыхТоваров.ПолноеИмя(),
										"Дата",
										"Закупки",
										"Организация");
#КонецОбласти
	
	

#Область Продажи
#КонецОбласти

#Область Производство
	
#КонецОбласти

#Область РегламентныеОперации
#КонецОбласти


	//-- Локализация

КонецПроцедуры

// Позволяет изменить работу интерфейса при встраивании.
// см. ДатыЗапретаИзмененияПереопределяемый.НастройкаИнтерфейса
//
Процедура НастройкаИнтерфейса(НастройкиРаботыИнтерфейса) Экспорт
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

// Заполняет разделы дат запрета изменения, используемые при настройке дат запрета.
// Если не указать ни одного раздела, тогда будет доступна только настройка общей даты запрета.
//
// см. ДатыЗапретаИзмененияПереопределяемый.ПриЗаполненииРазделовДатЗапретаИзменения
//
Процедура ПриЗаполненииРазделовДатЗапретаИзменения(Разделы) Экспорт
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры


// Позволяет переопределить выполнение проверки запрета изменения произвольным образом.
// см. ДатыЗапретаИзмененияПереопределяемый.ПередПроверкойЗапретаИзменения
//
Процедура ПередПроверкойЗапретаИзменения(Объект,
                                         ПроверкаЗапретаИзменения,
                                         УзелПроверкиЗапретаЗагрузки,
                                         ВерсияОбъекта) Экспорт
	
	//++ Локализация
	Если ОбщегоНазначения.ЭтоРегистр(Объект.Метаданные())
	 И Объект.Отбор.Найти("Регистратор") <> Неопределено Тогда
		ТипРегистратора = ТипЗнч(Объект.Отбор.Регистратор.Значение); // это набор записей документа-регистратора
	Иначе
		ТипРегистратора = Неопределено;
	КонецЕсли;
	
	ТипОбъекта = ТипЗнч(Объект);
		
	

	//-- Локализация
	
КонецПроцедуры

#КонецОбласти