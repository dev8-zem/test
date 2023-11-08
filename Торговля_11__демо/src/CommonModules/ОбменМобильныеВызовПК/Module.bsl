#Область ПрограммныйИнтерфейс

Функция НачатьОбмен(КодУзла, НаименованиеМобильногоКомпьютера, НомерОтправленного, НомерПринятого) Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.ПланыОбмена.Мобильные) Тогда
		
		ВызватьИсключение(НСтр("ru='У пользователя нет прав на синхронизацию данных с мобильным приложением'"));
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелОбмена = ПланыОбмена.Мобильные.ЭтотУзел().ПолучитьОбъект();
	Если НЕ ЗначениеЗаполнено(УзелОбмена.Код) Тогда
		
		УзелОбмена.Код = "001";
		УзелОбмена.Наименование = НСтр("ru='Центральный'");
		УзелОбмена.Записать();
		
	КонецЕсли;
	
	УзелОбмена = ПланыОбмена.Мобильные.НайтиПоКоду(КодУзла); 
	Если УзелОбмена.Пустая() Тогда
		
		НовыйУзел = ПланыОбмена.Мобильные.СоздатьУзел();
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Константа.КодНовогоУзлаПланаОбмена");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			КодНовогоУзла = Константы.КодНовогоУзлаПланаОбмена.Получить();
			Если КодНовогоУзла = 0 Тогда 
				КодНовогоУзла = 2;
			КонецЕсли;	
			Константы.КодНовогоУзлаПланаОбмена.Установить(КодНовогоУзла + 1);
			
			ЗафиксироватьТранзакцию();
		
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;
		
		Если СтрДлина(КодНовогоУзла) < 3 Тогда
			НовыйУзел.Код = Формат(КодНовогоУзла, "ЧЦ=3; ЧВН=");
		Иначе
			НовыйУзел.Код = КодНовогоУзла;
		КонецЕсли;
		НовыйУзел.Наименование = НаименованиеМобильногоКомпьютера;
		НовыйУзел.НомерОтправленного = НомерОтправленного;
		НовыйУзел.НомерПринятого = НомерПринятого;
		НовыйУзел.Записать();
		ОбменМобильныеПереопределяемый.ЗарегистрироватьИзмененияДанных(НовыйУзел.Ссылка);
		УзелОбмена = НовыйУзел.Ссылка;
		
	Иначе
		
		Если УзелОбмена.ПометкаУдаления ИЛИ            
			УзелОбмена.Наименование <> НаименованиеМобильногоКомпьютера Тогда
			
			Узел = УзелОбмена.ПолучитьОбъект();
			Узел.ПометкаУдаления = Ложь;
			Узел.Наименование = НаименованиеМобильногоКомпьютера;
			Узел.Записать();
			
		КонецЕсли;
		
		Если УзелОбмена.НомерОтправленного <> НомерОтправленного ИЛИ
			УзелОбмена.НомерПринятого <> НомерПринятого Тогда
			
			Узел = УзелОбмена.ПолучитьОбъект();
			Узел.НомерОтправленного = НомерОтправленного;
			Узел.НомерПринятого = НомерПринятого;
			Узел.Записать();
			ОбменМобильныеПереопределяемый.ЗарегистрироватьИзмененияДанных(УзелОбмена);
			
		КонецЕсли;
		
	КонецЕсли;
	Возврат УзелОбмена.Код;
	
КонецФункции

// Операция обмена данными
// получает пакет изменений предназначенных для данного узла
// записывает пакет изменений принятых от данного узла
//
// Параметры:
//  КодУзла - Строка - код узла, с которым идет обмен
//  ДанныеМобильногоПриложения - ХранилищеЗначения - хранилище в которое помещен пакет обмена
//
// Возвращаемое значение:
//  ХранилищеЗначения
//
Функция ВыполнитьОбменДанными(КодУзла, ДанныеМобильногоПриложения) Экспорт
	
	УзелОбмена = ПланыОбмена.Мобильные.НайтиПоКоду(КодУзла); 
	
	Если УзелОбмена.Пустая() Тогда
		ВызватьИсключение(НСтр("ru='Неизвестное устройство - '") + КодУзла);
	КонецЕсли;
	
	ОбменМобильныеОбщее.ПринятьПакетОбмена(УзелОбмена, ДанныеМобильногоПриложения);
	Возврат ОбменМобильныеОбщее.СформироватьПакетОбмена(УзелОбмена);
	
КонецФункции

Функция ТребуетсяОбменДаннымиСАвтономнымПриложением() Экспорт
	
	Возврат РольДоступна("ИспользованиеАвтономногоРежима");
	
КонецФункции

#КонецОбласти