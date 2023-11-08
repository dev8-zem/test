
#Область СлужебныйПрограммныйИнтерфейс

Функция НеобходимВызовСервера(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт

	Перем ПараметрыДействия;
	
	//++ Локализация
	
	Если СтруктураДействий.Свойство("ЗаполнитьСчетФактуруПолученнуюВОтчетеКомитентуОЗакупках")
		И ЗначениеЗаполнено(ТекущаяСтрока.ДокументПриобретения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьСчетФактуруПеревыставленнуюВОтчетеКомитентуОЗакупках")
		И ЗначениеЗаполнено(ТекущаяСтрока.ДокументПриобретения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьДанныеПоДокументуПриобретенияВОтчетеКомитентуОЗакупках") Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Если СтруктураДействий.Свойство("ЗаполнитьВидПродукцииИС")
		И ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьАлкогольнуюПродукцию")
		И ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьПродукциюВЕТИС")
		И ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		Возврат Истина;
	КонецЕсли;
	
	УпаковкаНоменклатура = Неопределено;
	Если СтруктураДействий.Свойство("ПересчитатьКоличествоЕдиницВЕТИС", УпаковкаНоменклатура)
		Или СтруктураДействий.Свойство("ПересчитатьКоличествоЕдиницПоВЕТИС", УпаковкаНоменклатура) Тогда
		
		ПараметрыПересчета = ОбработкаТабличнойЧастиКлиентСервер.НормализоватьПараметрыПересчетаЕдиниц(ТекущаяСтрока, УпаковкаНоменклатура);
		
		КлючКоэффициента = ОбработкаТабличнойЧастиКлиентСервер.КлючКэшаУпаковки(ПараметрыПересчета.Номенклатура, ПараметрыПересчета.Упаковка);
		
		Если ЗначениеЗаполнено(ПараметрыПересчета.Упаковка)
			И ЗначениеЗаполнено(ПараметрыПересчета.Номенклатура)
			И КэшированныеЗначения.КоэффициентыУпаковок[КлючКоэффициента] = Неопределено Тогда
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьКодОКПД2")
		И ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		Возврат Истина;
	КонецЕсли;
	
	УпаковкаНоменклатура = Неопределено;
	Если СтруктураДействий.Свойство("ПересчитатьКоличествоЕдиницПоЗЕРНО", УпаковкаНоменклатура) Тогда
		
		ПараметрыПересчета = ОбработкаТабличнойЧастиКлиентСервер.НормализоватьПараметрыПересчетаЕдиниц(ТекущаяСтрока, УпаковкаНоменклатура);
		
		Если ЗначениеЗаполнено(ПараметрыПересчета.Упаковка)
			И ЗначениеЗаполнено(ПараметрыПересчета.Номенклатура)
			И КэшированныеЗначения.КоэффициентыУпаковок[ПараметрыПересчета.Номенклатура] = Неопределено Тогда
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	//-- Локализация

	Возврат Ложь;
	
КонецФункции

Процедура ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт

	//++ Локализация
	
	АкцизныеМаркиКлиентСервер.ЗаполнитьИндексАкцизнойМаркиДляСтрокиТабличнойЧасти(ТекущаяСтрока, СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиентСерверЛокализация.ПересчитатьКоличествоЕдиницВЕТИСВСтрокеТЧ(
		ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	ОбработкаТабличнойЧастиКлиентСерверЛокализация.ПересчитатьКоличествоЕдиницПоВЕТИСВСтрокеТЧ(
		ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	ОбработкаТабличнойЧастиКлиентСерверЛокализация.ПересчитатьКоличествоЕдиницПоЗЕРНОВСтрокеТЧ(
		ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- Локализация
	
КонецПроцедуры

Процедура ПолучитьТекущуюСтрокуСтруктурой(СтруктураДействий, СтруктураПолейТЧ) Экспорт

	//++ Локализация
	Перем СтруктураПараметровДействия;
	
	Если СтруктураДействий.Свойство("ЗаполнитьИндексАкцизнойМарки", СтруктураПараметровДействия) Тогда
		
		СтруктураПолейТЧ.Вставить("МаркируемаяПродукция");
		СтруктураПолейТЧ.Вставить("ИндексАкцизнойМарки");
		СтруктураПолейТЧ.Вставить("КоличествоАкцизныхМарок");
		СтруктураПолейТЧ.Вставить("Количество");
		
		Если ТипЗнч(СтруктураПараметровДействия) = Тип("Структура") Тогда
			Если СтруктураПараметровДействия.Свойство("ИмяКолонкиКоличество") Тогда
				СтруктураПолейТЧ.Вставить(СтруктураПараметровДействия.ИмяКолонкиКоличество);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьПризнакАвтоматическийОСУИС", СтруктураПараметровДействия) Тогда
		
		СтруктураПолейТЧ.Вставить("АвтоматическийОСУИС");
		СтруктураПолейТЧ.Вставить("ВидПродукцииИС");
		СтруктураПолейТЧ.Вставить("Номенклатура");
		СтруктураПолейТЧ.Вставить("Характеристика");
		
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьНоменклатуруЕГАИС", СтруктураПараметровДействия) Тогда
		
		СтруктураПолейТЧ.Вставить("НоменклатураЕГАИС");
		СтруктураПолейТЧ.Вставить("МаркируемаяПродукция");
		СтруктураПолейТЧ.Вставить("АлкогольнаяПродукция");
		СтруктураПолейТЧ.Вставить("Номенклатура");
		СтруктураПолейТЧ.Вставить("Характеристика");
		СтруктураПолейТЧ.Вставить("Серия");
		СтруктураПолейТЧ.Вставить("Упаковка");
		СтруктураПолейТЧ.Вставить("НоменклатураДляВыбора");
		СтруктураПолейТЧ.Вставить("СопоставлениеАлкогольнаяПродукция");
		
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьАлкогольнуюПродукцию", СтруктураПараметровДействия) Тогда
		
		СтруктураПолейТЧ.Вставить("АлкогольнаяПродукция");
		СтруктураПолейТЧ.Вставить("Номенклатура");
		СтруктураПолейТЧ.Вставить("Характеристика");
		СтруктураПолейТЧ.Вставить("Серия");
		СтруктураПолейТЧ.Вставить("НоменклатураДляВыбора");
		СтруктураПолейТЧ.Вставить("СопоставлениеАлкогольнаяПродукция");
		
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьПродукциюВЕТИС", СтруктураПараметровДействия) Тогда
		
		СтруктураПолейТЧ.Вставить("Продукция");
		СтруктураПолейТЧ.Вставить("Номенклатура");
		СтруктураПолейТЧ.Вставить("Характеристика");
		СтруктураПолейТЧ.Вставить("Серия");
		СтруктураПолейТЧ.Вставить("НоменклатураДляВыбора");
		СтруктураПолейТЧ.Вставить("СопоставлениеТекст");
		СтруктураПолейТЧ.Вставить("ЕдиницаИзмеренияВЕТИС");
		
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ПересчитатьКоличествоЕдиницВЕТИС", СтруктураПараметровДействия)
		Или СтруктураДействий.Свойство("ПересчитатьКоличествоЕдиницПоВЕТИС", СтруктураПараметровДействия) Тогда
		СтруктураПолейТЧ.Вставить("Номенклатура");
		СтруктураПолейТЧ.Вставить("ЕдиницаИзмеренияВЕТИС");
		СтруктураПолейТЧ.Вставить("Количество" + СтруктураПараметровДействия.Суффикс + "ВЕТИС", 0);
		СтруктураПолейТЧ.Вставить("Количество" + СтруктураПараметровДействия.Суффикс, 0);
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ПересчитатьКоличествоЕдиницПоЗЕРНО", СтруктураПараметровДействия) Тогда
		СтруктураПолейТЧ.Вставить("Номенклатура");
		СтруктураПолейТЧ.Вставить("КоличествоЗЕРНО", 0);
		СтруктураПолейТЧ.Вставить("Количество", 0);
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьКодОКПД2") Тогда
		СтруктураПолейТЧ.Вставить("Номенклатура");
		СтруктураПолейТЧ.Вставить("ОКПД2");
		СтруктураПолейТЧ.Вставить("ОКПД2Представление");
	КонецЕсли;
		
	Если СтруктураДействий.Свойство("ЗаполнитьПризнакМаркируемаяАлкогольнаяПродукция", СтруктураПараметровДействия)
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		Для Каждого Поле Из СтруктураПараметровДействия Цикл
			СтруктураПолейТЧ.Вставить(Поле.Ключ);
			СтруктураПолейТЧ.Вставить(Поле.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьВидПродукцииИС", СтруктураПараметровДействия)
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		Для Каждого Поле Из СтруктураПараметровДействия Цикл
			СтруктураПолейТЧ.Вставить(Поле.Ключ);
			СтруктураПолейТЧ.Вставить(Поле.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьПризнакТребуетВзвешивания", СтруктураПараметровДействия)
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		Для Каждого Поле Из СтруктураПараметровДействия Цикл
			СтруктураПолейТЧ.Вставить(Поле.Ключ);
			СтруктураПолейТЧ.Вставить(Поле.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьПризнакПроизвольнаяЕдиницаУчета", СтруктураПараметровДействия)
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		Для Каждого Поле Из СтруктураПараметровДействия Цикл
			СтруктураПолейТЧ.Вставить(Поле.Ключ);
			СтруктураПолейТЧ.Вставить(Поле.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьПризнакСкоропортящаясяПродукция", СтруктураПараметровДействия)
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		Для Каждого Поле Из СтруктураПараметровДействия Цикл
			СтруктураПолейТЧ.Вставить(Поле.Ключ);
			СтруктураПолейТЧ.Вставить(Поле.Значение);
		КонецЦикла;
	КонецЕсли;
	Если СтруктураДействий.Свойство("ЗаполнитьПризнакМаркируемаяПродукция", СтруктураПараметровДействия) 
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		Для Каждого Поле Из СтруктураПараметровДействия Цикл
			СтруктураПолейТЧ.Вставить(Поле.Ключ);
			СтруктураПолейТЧ.Вставить(Поле.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьСчетФактуруПеревыставленнуюВОтчетеКомитентуОЗакупках", СтруктураПараметровДействия) Тогда
		
		СтруктураПолейТЧ.Вставить("СчетФактураПолученный");
		СтруктураПолейТЧ.Вставить("СчетФактураВыданныйКомитенту");
		
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьСчетФактуруПеревыставленнуюВОтчетеКомитентуОЗакупках") Тогда
		
		СтруктураПолейТЧ.Вставить("СчетФактураПолученный");
		СтруктураПолейТЧ.Вставить("СчетФактураВыданныйКомитенту");
		СтруктураПолейТЧ.Вставить("ДокументПриобретения");
		
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьКодОКПД2", СтруктураПараметровДействия)
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		Для Каждого Поле Из СтруктураПараметровДействия Цикл
			СтруктураПолейТЧ.Вставить(Поле.Ключ);
			СтруктураПолейТЧ.Вставить(Поле.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьКодОКПД2Представление", СтруктураПараметровДействия)
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		Для Каждого Поле Из СтруктураПараметровДействия Цикл
			СтруктураПолейТЧ.Вставить(Поле.Ключ);
			СтруктураПолейТЧ.Вставить(Поле.Значение);
		КонецЦикла;
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВСтрокеТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт
	
	//++ Локализация
	
	Если СтруктураДействий.Свойство("ЗаполнитьВидПродукцииИС") Тогда
		ТекущаяСтрока.МаркируемаяПродукция = Ложь;
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьВидПродукцииИС") Тогда
		ТекущаяСтрока.ВидПродукцииИС = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПустаяСсылка");
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьПризнакПодакцизныйТовар") Тогда
		ТекущаяСтрока.ПодакцизныйТовар = Ложь;
	КонецЕсли;
	
	//-- Локализация
	Возврат;
	
КонецПроцедуры

#КонецОбласти
