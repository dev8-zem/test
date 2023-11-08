///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДобавитьУдостоверяющийЦентрСертификатаВРазрешенные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ОбработчикОжиданияПоказатьВопросПользователю", 0.1, Истина);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Модифицированность = Элементы.ДекорацияНадпись.Видимость;
	ПодключитьОбработчикОжидания("ОбновитьКоличествоВЗаголовке", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
	Оповестить("Запись_НаборКонстант", Новый Структура, "РазрешенныеНеаккредитованныеУЦ");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РазрешенныеНеаккредитованныеУЦИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ПодключитьОбработчикОжидания("ОбновитьКоличествоВЗаголовке", 0.5, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьКоличествоВЗаголовке()

	Если ПустаяСтрока(Элементы.РазрешенныеНеаккредитованныеУЦ.ТекстРедактирования) Тогда
		Элементы.РазрешенныеНеаккредитованныеУЦ.Заголовок = НСтр("ru ='Разрешенные неаккредитованные УЦ'");
	Иначе
		РазрешенныеУЦ = СтрРазделить(Элементы.РазрешенныеНеаккредитованныеУЦ.ТекстРедактирования, ",;" + Символы.ПС, Ложь);
		Элементы.РазрешенныеНеаккредитованныеУЦ.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru ='Разрешенные неаккредитованные УЦ (%1)'"), РазрешенныеУЦ.Количество());
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияПоказатьВопросПользователю()
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Ложь);
	ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ПараметрыВопроса.Картинка = БиблиотекаКартинок.Предупреждение32;
	ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
	ПараметрыВопроса.Заголовок = НСтр("ru = 'Неаккредитованный удостоверяющий центр'");
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Неопределено, ТекстПредупреждения, РежимДиалогаВопрос.ОК, ПараметрыВопроса);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьУдостоверяющийЦентрСертификатаВРазрешенные()
	
	Элементы.ДекорацияНадпись.Видимость = Ложь;
	
	Если Не ЗначениеЗаполнено(Параметры.Сертификат) Тогда
		Возврат;
	КонецЕсли;
	
	МодульЭлектроннаяПодписьКлиентСерверЛокализация = ОбщегоНазначения.ОбщийМодуль(
		"ЭлектроннаяПодписьКлиентСерверЛокализация");
		
	Если МодульЭлектроннаяПодписьКлиентСерверЛокализация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Сертификат = Параметры.Сертификат;

	Если ТипЗнч(Сертификат) = Тип("Строка") И ЭтоАдресВременногоХранилища(Сертификат) Тогда

		Сертификат =  ПолучитьИзВременногоХранилища(Сертификат);

	ИначеЕсли ТипЗнч(Сертификат) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда

		Сертификат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сертификат, "ДанныеСертификата").Получить();

	КонецЕсли;

	Если ТипЗнч(Сертификат) <> Тип("ДвоичныеДанные") Тогда
		Возврат;
	КонецЕсли;

	Сертификат = Новый СертификатКриптографии(Сертификат);
	
	ДанныеДляПроверкиУдостоверяющегоЦентра = МодульЭлектроннаяПодписьКлиентСерверЛокализация.ДанныеДляПроверкиУдостоверяющегоЦентра(
			Сертификат);
	ЗначенияПоиска = ДанныеДляПроверкиУдостоверяющегоЦентра.ЗначенияПоиска;
	
	Если ЗначенияПоиска = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивПолейПоиска = СтрРазделить(ЗначенияПоиска, ",");
	
	ЗначениеДляДобавления = МассивПолейПоиска[0];
	
	РазрешенныеУЦ = СтрРазделить(НаборКонстант.РазрешенныеНеаккредитованныеУЦ, ",;" + Символы.ПС);
	Если РазрешенныеУЦ.Найти(ЗначениеДляДобавления) = Неопределено Тогда
		
		ПредставлениеИздателя = ЭлектроннаяПодписьСлужебныйКлиентСервер.ПредставлениеИздателя(Сертификат);
		
		Элементы.ДекорацияНадпись.Видимость = Истина;
		
		ЕстьПраваНаИзменение = ПравоДоступа("Изменение", Метаданные.Константы.РазрешенныеНеаккредитованныеУЦ);
		
		Если Не ЕстьПраваНаИзменение Тогда
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Обратитесь к администратору для добавления ОГРН %1 удостоверяющего центра ""%2"" в список разрешенных неаккредитованных УЦ.'"),
				ЗначениеДляДобавления, ПредставлениеИздателя);
			Возврат;
		КонецЕсли;
		
		РазрешенныеУЦ.Вставить(0, ЗначениеДляДобавления);
			НаборКонстант.РазрешенныеНеаккредитованныеУЦ = СтрСоединить(РазрешенныеУЦ, Символы.ПС);
		Элементы.ДекорацияНадпись.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Нажмите ""Записать и закрыть"", чтобы добавить ОГРН %1 удостоверяющего центра ""%2"" в список разрешенных.'"),
			ЗначениеДляДобавления, ПредставлениеИздателя);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти