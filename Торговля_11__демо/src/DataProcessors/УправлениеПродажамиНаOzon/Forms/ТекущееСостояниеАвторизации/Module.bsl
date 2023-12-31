
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УчетнаяЗапись = Параметры.УчетнаяЗапись;
	
	ШаблонИнформации = НСтр("ru = 'Для организации %1 авторизация на Ozon выполнена'");
	СтрокаИнформации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИнформации, УчетнаяЗапись);

	Элементы.ПодсказкаФормы.Заголовок = СтрокаИнформации;
	Элементы.ПодсказкаФормы.ЦветТекста = ЦветаСтиля.ЦветТекстаУспех;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)

	Закрыть(Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьНастройки(Команда)

	ИнтеграцияСМаркетплейсомOzonКлиент.ОчисткаНастроекАвторизацииВопрос(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОчиститьНастройкиЗавершение(Результат, Параметры) Экспорт 

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	ОчисткаУспешна = ОчиститьНастройкиНаСервере(УчетнаяЗапись);

	Если ОчисткаУспешна Тогда 
		Оповестить("ОбновитьСписокПодключений");
		Оповестить("УчетнаяЗаписьДеактивирована", УчетнаяЗапись);
		Закрыть(Истина);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ОчиститьНастройкиНаСервере(УчетнаяЗапись)

	ОчисткаУспешна = ИнтеграцияСМаркетплейсомOzonСервер.ОчиститьНастройкиУчетнойЗаписи(УчетнаяЗапись);

	Возврат ОчисткаУспешна;

КонецФункции

#КонецОбласти

