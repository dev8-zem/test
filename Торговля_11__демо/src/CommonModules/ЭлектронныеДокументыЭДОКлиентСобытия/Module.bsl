
#Область СлужебныйПрограммныйИнтерфейс

// ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

// Событие вызывается при просмотре результата проверки подписи по МЧД из формы обработки ошибок диагностики.
// 
// Параметры:
//  КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
//  ПараметрыОшибки - см. ЭлектронныеДокументыЭДО.НовыеПараметрыОшибкиПроверкиПодписиПоМЧД
Процедура ПриПросмотреРезультатаПроверкиПодписиПоМЧД(КонтекстДиагностики, ПараметрыОшибки) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СвойстваПодписи", ПараметрыОшибки.СвойстваПодписи); 
	ПараметрыФормы.Вставить("СвойстваДоверенности", ПараметрыОшибки.СвойстваДоверенности); 
	ПараметрыФормы.Вставить("РезультатПроверки", ПараметрыОшибки.РезультатПроверки);			
						
	ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
			
	МашиночитаемыеДоверенностиКлиент.ОткрытьРезультатыПроверкиПодписи(ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

#КонецОбласти