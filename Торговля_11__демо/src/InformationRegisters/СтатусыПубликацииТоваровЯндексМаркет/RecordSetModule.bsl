#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.ИдентификаторПубликации = "" Тогда
			 ИдентификаторПубликации = Строка(Новый УникальныйИдентификатор());
			 Запись.ИдентификаторПубликации =  ИдентификаторПубликации;
			 Если Не Отказ Тогда
				 Номенклатура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Номенклатура, "Наименование");
				 Характеристика = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Характеристика, "Наименование");
				 Упаковка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Упаковка, "Наименование");
				 ПредставлениеТовара = Номенклатура.Наименование + "," + Характеристика.Наименование;
				 Если ЗначениеЗаполнено(Упаковка.Наименование) Тогда
					 ПредставлениеТовара = ПредставлениеТовара + "," + Упаковка.Наименование;
				 КонецЕсли;
				 Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.Новый; 
				 Запись.ТоварнаяКатегория = Запись.Номенклатура.ТоварнаяКатегория.Наименование; 
				 Запись.ИдентификаторПубликации = ИдентификаторПубликации; 
				 Запись.ПредставлениеТовара = ПредставлениеТовара; 
			 КонецЕсли;
		КонецЕсли;

				
		Если Запись.Статус =  Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.Новый 
			ИЛИ Запись.Статус =  Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.СозданиеНового Тогда
			
			Запись.МаркерСтатуса = 2;
			
		ИначеЕсли  Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.ПолученаРекомендация 
			ИЛИ Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.УтвержденаРекомендация 
			ИЛИ Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.НаМодерации 
			ИЛИ Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.ОжидаетМодерации  Тогда
				
			Запись.МаркерСтатуса = 1;
			
		ИначеЕсли Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.МодерацияПройдена Тогда
			
			Запись.МаркерСтатуса = 3;
			
		Иначе
				
			 Запись.МаркерСтатуса = 0;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Запись.ИдентификаторТовараПлощадки) Тогда
			Запись.ГиперссылкаНаРекомендованныеТовар = "https://pokupki.market.yandex.ru/product/"+СокрЛП(СтрЗаменить(Запись.ИдентификаторТовараПлощадки,Символ(160),""));
		КонецЕсли;

	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
