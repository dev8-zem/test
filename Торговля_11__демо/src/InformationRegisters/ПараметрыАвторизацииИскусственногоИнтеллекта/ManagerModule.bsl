#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция НачальныеНастройки() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("РазделениеВключено", Ложь);
	Результат.Вставить("ЗначениеРазделителяСеанса", 0);
	Результат.Вставить("АдресПриложения", "");
	
	Возврат Результат;
	
КонецФункции

Функция СохраненныеНастройки(Сервис) Экспорт
	
	Результат = НачальныеНастройки();
	
	МенеджерЗаписи = РегистрыСведений.ПараметрыАвторизацииИскусственногоИнтеллекта.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Сервис = Сервис;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		ЗаполнитьЗначенияСвойств(Результат, МенеджерЗаписи);
	Иначе
		Результат = РаспознаваниеДокументовСлужебный.ТекущиеПараметрыАвторизацииИИ();
		Установить(Сервис, Результат);
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(Результат);
	
КонецФункции

Процедура Установить(Сервис, Значения) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.ПараметрыАвторизацииИскусственногоИнтеллекта.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Сервис = Сервис;
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.Сервис = Сервис;
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Значения);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
