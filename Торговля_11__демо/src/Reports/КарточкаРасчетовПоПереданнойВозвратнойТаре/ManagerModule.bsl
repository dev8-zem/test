#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
// Возвращаемое значение:
//  Неопределено, СтрокаТаблицыЗначений - команда отчета
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.КарточкаРасчетовПоПереданнойВозвратнойТаре) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьМногооборотнуюТару") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.КарточкаРасчетовПоПереданнойВозвратнойТаре.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Карточка расчетов по таре'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьМногооборотнуюТару";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли