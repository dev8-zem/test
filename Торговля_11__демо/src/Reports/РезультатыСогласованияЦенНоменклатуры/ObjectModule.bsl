#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета. Содержит в том числе:
//   	* Параметры - Структура - Структура параметров, содержит в том числе:
//   		** ОписаниеКоманды - Структура:
//   			*** ДополнительныеПараметры - Структура:
//   				**** ИмяКоманды - Строка
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ОписаниеКоманды")
			И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда 
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "РезультатыСогласованияЦенНоменклатурыПоДокументу" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Предмет", Параметры.ПараметрКоманды);
		ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "РезультатыСогласованияЦенНоменклатуры" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("СогласованиеЦенНоменклатуры", Параметры.ПараметрКоманды);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли