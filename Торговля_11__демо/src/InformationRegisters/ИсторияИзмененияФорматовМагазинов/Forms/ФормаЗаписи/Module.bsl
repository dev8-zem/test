
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
	Запись.Период = ТекущаяДатаСеанса();
	
	Если Запись.КонтролироватьАссортимент Тогда
	
		Элементы.ФорматМагазина.АвтоОтметкаНезаполненного = Истина;
		Элементы.ФорматМагазина.АвтоВыборНезаполненного = Истина;
	
	Иначе
	
		Элементы.ФорматМагазина.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ФорматМагазина.АвтоВыборНезаполненного = Ложь;
	
	КонецЕсли;
	
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Склад, "ТипСклада");
	ЭтоРозничныйСклад = (ТипСклада = Перечисления.ТипыСкладов.РозничныйМагазин);
	
	Если Запись.РозничныеЦеныИзФорматаМагазина Тогда
		РозничныеЦеныИзФорматаМагазинаПереключатель = "ФорматМагазина";
	Иначе
		РозничныеЦеныИзФорматаМагазинаПереключатель = "Склад";
	КонецЕсли;
	
	Элементы.КонтролироватьАссортимент.Доступность = ЭтоРозничныйСклад;

	ИспользуетсяЦенообразование25 = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25();
	
	ИзменитьНастройкиМестаХраненияРозничныхЦен();
	
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Склад, "ТипСклада");
	ЭтоРозничныйСклад = (ТипСклада = Перечисления.ТипыСкладов.РозничныйМагазин);
	Если Запись.РозничныеЦеныИзФорматаМагазина Тогда
		РозничныеЦеныИзФорматаМагазинаПереключатель = "ФорматМагазина";
	Иначе
		РозничныеЦеныИзФорматаМагазинаПереключатель = "Склад";
	КонецЕсли;
	
	Элементы.КонтролироватьАссортимент.Доступность = ЭтоРозничныйСклад;

	ИзменитьНастройкиМестаХраненияРозничныхЦен();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтролироватьАссортиментПриИзменении(Элемент)
	
	Если Запись.КонтролироватьАссортимент Тогда
	
		Элементы.ФорматМагазина.АвтоОтметкаНезаполненного = Истина;
		Элементы.ФорматМагазина.АвтоВыборНезаполненного = Истина;
	
	Иначе
	
		Элементы.ФорматМагазина.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ФорматМагазина.АвтоВыборНезаполненного = Ложь;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	СкладПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФорматМагазинаПриИзменении(Элемент)
	ФорматМагазинаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФорматМагазинаОчистка(Элемент, СтандартнаяОбработка)
	ФорматМагазинаОчисткаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РозничныеЦеныИзФорматаМагазинаПереключательПриИзменении(Элемент)
	
	Запись.РозничныеЦеныИзФорматаМагазина = (РозничныеЦеныИзФорматаМагазинаПереключатель = "ФорматМагазина");
	
	ОбновитьПредставленияВидовЦен();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СкладПриИзмененииНаСервере()
	
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Склад, "ТипСклада");
	ЭтоРозничныйСклад = (ТипСклада = Перечисления.ТипыСкладов.РозничныйМагазин);
	
	Элементы.КонтролироватьАссортимент.Доступность = ЭтоРозничныйСклад;

	Если Запись.КонтролироватьАссортимент И НЕ ЭтоРозничныйСклад Тогда
	
		Запись.КонтролироватьАссортимент = Ложь;
	
	КонецЕсли; 
	
	ОбновитьПредставленияВидовЦен();
	
КонецПроцедуры

&НаСервере
Процедура ФорматМагазинаПриИзмененииНаСервере()
	
	ИзменитьНастройкиМестаХраненияРозничныхЦен();	

КонецПроцедуры

&НаСервере
Процедура ФорматМагазинаОчисткаНаСервере()
	
	ИзменитьНастройкиМестаХраненияРозничныхЦен();
		
КонецПроцедуры

&НаСервере
Процедура ИзменитьНастройкиМестаХраненияРозничныхЦен()
	
	Если Не ИспользуетсяЦенообразование25 Тогда
		
		Элементы.ГруппаРозничныеЦены.Видимость = Ложь;
		Возврат;
		
	КонецЕсли;

	Элементы.ГруппаРозничныеЦены.Видимость = Истина;
	
	ФорматМагазинаЗаполнен = ЗначениеЗаполнено(Запись.ФорматМагазина);
	
	Элементы.ГруппаРозничныеЦены.Доступность = ФорматМагазинаЗаполнен;
	
	Если НЕ ФорматМагазинаЗаполнен Тогда

		Запись.РозничныеЦеныИзФорматаМагазина = Ложь;
		РозничныеЦеныИзФорматаМагазинаПереключатель = "Склад";
		
	КонецЕсли;
	
	ОбновитьПредставленияВидовЦен();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставленияВидовЦен()
	Если Запись.РозничныеЦеныИзФорматаМагазина Тогда
		ОбъектХраненияРозничныхЦен = Запись.ФорматМагазина;
	Иначе	
		ОбъектХраненияРозничныхЦен = Запись.Склад;
	КонецЕсли;
	
	ВидыЦен = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбъектХраненияРозничныхЦен, "РозничныйВидЦены, ИндивидуальныйВидЦены");
	
	Если ЗначениеЗаполнено(ВидыЦен.РозничныйВидЦены) Тогда
		РозничныйВидЦенПредставление = ВидыЦен.РозничныйВидЦены;
	Иначе	 
		РозничныйВидЦенПредставление = "<не указан>";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидыЦен.ИндивидуальныйВидЦены) Тогда
		ИндивидуальныйВидЦенПредставление = "<используется>";
	Иначе	 
		ИндивидуальныйВидЦенПредставление = "<не используется>";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

