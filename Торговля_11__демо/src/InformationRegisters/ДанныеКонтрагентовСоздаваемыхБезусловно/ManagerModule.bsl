
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Ложь;
	
	НачатьТранзакцию();
	Попытка
		ДатаПоследнегоИзменения = ТекущаяДатаСеанса();
		КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	
		ДвоичныеДанныеКэша = РегистрыСведений.ДанныеКонтрагентовСоздаваемыхБезусловно.ПолучитьМакет("ДанныеКонтрагентовСоздаваемыхБезусловно");
		
		ДанныеКэша = СервисНастроекЭДО.ОбработкаРезультатаДанныеКонтрагентовСоздаваемыхБезусловно(ДвоичныеДанныеКэша);
		
		Если ДанныеКэша <> Неопределено Тогда
			СервисНастроекЭДО.ОбновитьКонтрагентовСоздаваемыхБезусловно(ДанныеКэша, ДатаПоследнегоИзменения, КонтекстДиагностики);
		КонецЕсли;
		
		ОбработкаЗавершена = Истина;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = НСтр("ru = 'Не удалось заполнить кеши контрагентов создаваемых безусловно по причине:'") + Символы.ПС 
			+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,,, ТекстСообщения);
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюНачальноеЗаполнение(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК ЕстьЗаписи
		|ИЗ
		|	РегистрСведений.ДанныеКонтрагентовСоздаваемыхБезусловно КАК ДанныеКонтрагентовСоздаваемыхБезусловно";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#КонецЕсли
