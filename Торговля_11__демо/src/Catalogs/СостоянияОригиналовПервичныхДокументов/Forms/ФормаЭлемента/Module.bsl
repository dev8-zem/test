///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если Не Объект.Ссылка = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен") 
		И Не Объект.Ссылка = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ФормаНапечатана")
		И Объект.Ссылка.Пустая() Тогда
		Объект.РеквизитДопУпорядочивания = РассчитатьПорядокЭлемента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция РассчитатьПорядокЭлемента()

	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ ПЕРВЫЕ 1
	              |	СостоянияОригиналовПервичныхДокументов.РеквизитДопУпорядочивания КАК Порядок
	              |ИЗ
	              |	Справочник.СостоянияОригиналовПервичныхДокументов КАК СостоянияОригиналовПервичныхДокументов
	              |ГДЕ
	              |	СостоянияОригиналовПервичныхДокументов.Предопределенный = ЛОЖЬ
	              |
	              |УПОРЯДОЧИТЬ ПО
	              |	РеквизитДопУпорядочивания УБЫВ" ;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	Если Не Выборка.Порядок = Неопределено Тогда 
		ПорядокПоУмолчанию = Выборка.Порядок + 1;
	Иначе
		ПорядокПоУмолчанию = 2;
	КонецЕсли;

	Возврат ПорядокПоУмолчанию; 

КонецФункции

#КонецОбласти