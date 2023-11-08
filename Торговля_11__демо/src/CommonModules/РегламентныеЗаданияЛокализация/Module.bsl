
#Область ПрограммныйИнтерфейс

// Определяет следующие свойств регламентных заданий:
//  - зависимость от функциональных опций.
//  - возможность выполнения в различных режимах работы программы.
//  - прочие параметры.
//
// см. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	//++ Локализация
	
	//++ НЕ ГОСИС
	
	
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбменССайтом;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПроверкаКонтрагентов;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СборИОтправкаСтатистики;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют;
	Настройка.РаботаетСВнешнимиРесурсами = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПолучениеДанныхСмартвей;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьИнтеграциюСоСмартвей;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	// ОбменДанными
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СинхронизацияДанных;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	// Конец ОбменДанными
	
	//ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	//Конец ЭлектронноеВзаимодействие
	

	//-- НЕ ГОСИС

	//++ НЕ ГОСИС
	ИнтеграцияГИСМ.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	ИнтеграцияЕГАИС.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	ИнтеграцияВЕТИС.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	ИнтеграцияИСМП.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	ИнтеграцияЗЕРНО.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	//-- НЕ ГОСИС
	

	// РаспознаваниеДокументов
	РаспознаваниеДокументов.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	// Конец РаспознаваниеДокументов
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти