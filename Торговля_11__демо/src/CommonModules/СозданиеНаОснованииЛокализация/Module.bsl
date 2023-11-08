
#Область ПрограммныйИнтерфейс

// Определяет список объектов конфигурации, в модулях менеджеров которых предусмотрена процедура 
// ДобавитьКомандыСозданияНаОсновании, формирующая команды создания на основании объектов.
// Синтаксис процедуры ДобавитьКомандыСозданияНаОсновании см. в документации.
//
// см. СозданиеНаОснованииПереопределяемый.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании
//   
Процедура ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Объекты) Экспорт
	
	//++ Локализация
	УчетПрослеживаемыхТоваровЛокализация.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Объекты);
	
	
	Объекты.Добавить(Метаданные.Документы.КорректировкаОбособленногоУчетаЗапасов);
	Объекты.Добавить(Метаданные.Документы.ЛистКассовойКниги);
	Объекты.Добавить(Метаданные.Документы.ТранспортнаяНакладная);
	Объекты.Добавить(Метаданные.Документы.УведомлениеОЗачисленииВалюты);
	Объекты.Добавить(Метаданные.Документы.ВводОстатковТМЦВЭксплуатации);
	Объекты.Добавить(Метаданные.Документы.ВводОстатковНДСПредъявленного);
	
	// ЭлектронноеВзаимодействие.ИнтеграцияСЯндексКассой
	Объекты.Добавить(Метаданные.Документы.ОперацияПоЯндексКассе);
	// Конец ЭлектронноеВзаимодействие.ИнтеграцияСЯндексКассой
	
	// ЭлектронноеВзаимодействие.КоммерческиеПредложения
	Объекты.Добавить(Метаданные.Документы.КоммерческоеПредложениеПоставщика);
	// Конец ЭлектронноеВзаимодействие.КоммерческиеПредложения

	// ЭлектронноеВзаимодействие.ОбменСГИСЭПД
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСГИСЭПД") Тогда
		МодульОбменСГИСЭПД = ОбщегоНазначения.ОбщийМодуль("ОбменСГИСЭПД");
		МодульОбменСГИСЭПД.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Объекты);
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ОбменСГИСЭПД
	
	//-- Локализация
	
КонецПроцедуры


// Вызывается для формирования списка команд создания на основании КомандыСозданияНаОсновании, однократно для при первой
// необходимости, а затем результат кэшируется с помощью модуля с повторным использованием возвращаемых значений.
// Здесь можно определить команды создания на основании, общие для большинства объектов конфигурации.
//
// см. СозданиеНаОснованииПереопределяемый.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании
//
Процедура ПередДобавлениемКомандСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры, СтандартнаяОбработка) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОснованииПисьмоОбменСБанками(КомандыСозданияНаОсновании) Экспорт

	//++ Локализация
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПисьмоОбменСБанками) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ПисьмоОбменСБанками.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ПисьмоОбменСБанками);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	//-- Локализация
	
	Возврат Неопределено;
КонецФункции

#КонецОбласти
