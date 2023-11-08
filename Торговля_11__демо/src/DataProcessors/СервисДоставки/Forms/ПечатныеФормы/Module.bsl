#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не СервисДоставки.ПравоРаботыССервисомДоставки(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТипГрузоперевозки", ТипГрузоперевозки);
	
	Если НЕ ЗначениеЗаполнено(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выбран тип грузоперевозки'"));
		Отказ = Истина;
		Возврат;
	ИначеЕсли НЕ СервисДоставки.ТипГрузоперевозкиДоступен(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Выбранный тип грузоперевозки не доступен'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоТипуГрузоперевозки();
	
	Параметры.Свойство("ПараметрыЗаказа", ПараметрыЗаказа);
	Если Параметры.Свойство("ИдентификаторЗаказа", ИдентификаторЗаказа) Тогда
		ИдентификаторыЗаказов.Очистить();
		ИдентификаторыЗаказов.Добавить(ИдентификаторЗаказа);
	Иначе
		Параметры.Свойство("ИдентификаторыЗаказов", ИдентификаторыЗаказов);
	КонецЕсли;
	Параметры.Свойство("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	СервисДоставкиСлужебный.ПроверитьОрганизациюБизнесСети(ОрганизацияБизнесСетиСсылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Запуск фонового задания для загрузки доступных форм.
	ФоновоеЗаданиеПолучитьДоступныеПечатныеФормы = ПолучитьДоступныеПечатныеФормыВФоне();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ФоновоеЗаданиеПолучитьДоступныеПечатныеФормы) Тогда
		
		ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
		ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДоступныеПечатныеФормы();
		ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение списка доступных печатных форм.'");
		
		ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПометкаПриИзменении(Элемент)
	
	Элементы.ФормаЗагрузить.Доступность = ЕстьОтмеченныеПечатныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЗагрузкиПечатныхФормНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбратьКаталогЗагрузки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьПометкуДляВсехЭлементовСписка(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьПометкуДляВсехЭлементовСписка(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОчиститьСообщения();
	
	Если ЕстьОтмеченныеПечатныеФормы()
		И КаталогЗагрузкиПечатныхФорм = "" Тогда 
		ВыбратьКаталогЗагрузки(Истина);
	Иначе
		ЗагрузитьПечатныеФормыВКаталогНаДиске();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФормуПоТипуГрузоперевозки()
	
	Если ТипГрузоперевозки = 1 Тогда
		Заголовок = НСтр("ru = '1C:Доставка: Документы по перевозке'");
	Иначе
		Заголовок = НСтр("ru = '1C:Курьер: Документы по перевозке'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЕстьОтмеченныеПечатныеФормы()
	
	Результат = Ложь;
	
	Для Каждого ПечатнаяФорма Из СписокПечатныхФорм Цикл
		Если ПечатнаяФорма.Пометка Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#Область ЗапросыКСервису

&НаКлиенте
Процедура ЗагрузитьПечатныеФормыВКаталогНаДиске()
	
	ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
	ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьФайлыПечатныхФорм();
	ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение заказов на доставку.'");
	ПараметрыОперации.ВыводитьОкноОжидания = Истина;
	
	ВыполнитьЗапрос(ПараметрыОперации);
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнитьЗапрос

&НаКлиенте
Процедура ВыполнитьЗапрос(ПараметрыОперации)
	
	ИнтернетПоддержкаПодключена = Ложь;
	ОчиститьСообщения();
	
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ПараметрыОперации);
	ЭтотОбъект[ИмяФоновогоЗадания] = ФоновоеЗадание;
	
	Если ИнтернетПоддержкаПодключена = Ложь Тогда
		
		// Загрузка с проверкой подключения интернет-поддержки.
		Оповещение = Новый ОписаниеОповещения("ВыполнитьЗапросПродолжение", ЭтотОбъект, ПараметрыОперации);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(Оповещение, ЭтотОбъект);
		Возврат;
		
	Иначе
		
		ПараметрыОперации.Вставить("ФоновоеЗадание", ФоновоеЗадание);
		ВыполнитьЗапросПродолжение(Истина, ПараметрыОперации);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ИмяФоновогоЗадания = "ФоновоеЗадание"+ ДополнительныеПараметры.ИмяПроцедуры;
	
	Если Результат = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Отсутствует подключение к Интернет-поддержке пользователей.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("Логин") Тогда
		// Повторный вызов метода после подключения к Интернет-поддержке.
		ИнтернетПоддержкаПодключена = Ложь;
		ЭтотОбъект[ИмяФоновогоЗадания] = ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ДополнительныеПараметры);
		ДополнительныеПараметры.Добавить("ФоновоеЗадание", ЭтотОбъект[ИмяФоновогоЗадания]);
	КонецЕсли;
	
	Если ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект[ИмяФоновогоЗадания].Статус = "Выполняется" Тогда
		
		ОжидатьЗавершениеВыполненияЗапроса(ДополнительныеПараметры);
		
	ИначеЕсли ЭтотОбъект[ИмяФоновогоЗадания].Статус = "Выполнено" Тогда
		
		ВыполнитьЗапросЗавершение(ЭтотОбъект[ИмяФоновогоЗадания], ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации)
	
	ВыводитьОкноОжидания = ?(ЗначениеЗаполнено(ПараметрыОперации.ВыводитьОкноОжидания), 
																	ПараметрыОперации.ВыводитьОкноОжидания,
																	Ложь);
	// Установка картинки длительной операции.
	Если Не ВыводитьОкноОжидания Тогда
		
		Если ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДоступныеПечатныеФормы() Тогда
			
			Элементы.ДекорацияОжидание.Видимость = Истина;
			Элементы.ДекорацияСостояние.Заголовок = НСтр("ru='Идет загрузка...'");
			
		ИначеЕсли ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьФайлыПечатныхФорм() Тогда
			
			Элементы.ДекорацияОжидание.Видимость = Истина;
			Элементы.ДекорацияСостояние.Заголовок = НСтр("ru='Идет загрузка...'");
			УстановитьБлокировкуЭлементовФормы(Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Инициализация обработчик ожидания завершения.
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	ПараметрыОперации.Вставить("ФоновоеЗадание", ФоновоеЗадание);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = ПараметрыОперации.НаименованиеОперации;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = ВыводитьОкноОжидания;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	ПараметрыОжидания.Вставить("ИдентификаторЗадания", ФоновоеЗадание.ИдентификаторЗадания);
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ВыполнитьЗапросЗавершение",
		ЭтотОбъект, ПараметрыОперации);
		
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, ОбработкаЗавершения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	// Инициализация.
	Отказ = Ложь;
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ДополнительныеПараметры.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	
	// Скрыть элементы ожидания на форме
	Элементы.ДекорацияОжидание.Видимость = Ложь;
	СостояниеВыполненияЗапроса = НСтр("ru = 'Выберите требуемые документы'");
	УстановитьБлокировкуЭлементовФормы(Ложь);
	
	// Вывод сообщений из фонового задания.
	СервисДоставкиКлиент.ОбработатьРезультатФоновогоЗадания(Результат, ДополнительныеПараметры, Отказ);
	Если Результат = Неопределено ИЛИ ФоновоеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка результата поиска.
	Если Не Отказ И Результат.Статус = "Выполнено" Тогда
		Если ЗначениеЗаполнено(Результат.АдресРезультата)
			И ЭтоАдресВременногоХранилища(Результат.АдресРезультата) 
			И ДополнительныеПараметры.ФоновоеЗадание.ИдентификаторЗадания 
			= ЭтотОбъект[ИмяФоновогоЗадания].ИдентификаторЗадания Тогда
			
			Если ДополнительныеПараметры.ИмяПроцедуры 
				= СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДоступныеПечатныеФормы() Тогда
				
				// Загрузка результатов запроса.
				ОперацияВыполнена = Истина;
				ЗагрузитьРезультатЗапросаПолучитьДоступныеПечатныеФормы(Результат.АдресРезультата, ОперацияВыполнена);
				ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено;
				
			ИначеЕсли ДополнительныеПараметры.ИмяПроцедуры 
				= СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьФайлыПечатныхФорм() Тогда
				
				// Загрузка результатов поиска.
				Элементы.ДекорацияСостояние.Заголовок = НСтр("ru='Обработка результата...'");
				Элементы.ДекорацияОжидание.Видимость = Истина;
				
				ОперацияВыполнена = Истина;
				ЗагрузитьРезультатЗапросаПолучитьФайлыПечатныхФорм(Результат.АдресРезультата, ОперацияВыполнена);
				ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено;
				
				УстановитьПометкуДляВсехЭлементовСписка(Ложь);
				
				Элементы.ДекорацияСостояние.Заголовок = "";
				Элементы.ДекорацияОжидание.Видимость = Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	КоличествоСтрок = СписокПечатныхФорм.Количество();
	Если КоличествоСтрок = 0 Тогда
		СостояниеВыполненияЗапроса = НСтр("ru = 'Нет доступных печатных форм'");
	КонецЕсли;
	
	Элементы.ДекорацияСостояние.Заголовок = СостояниеВыполненияЗапроса;
	Элементы.ФормаЗагрузить.Доступность = ЕстьОтмеченныеПечатныеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнитьЗапросВФоне

&НаСервере
Функция ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ПараметрыОперации)
	
	// Проверка подключения Интернет-поддержки пользователей.
	ИнтернетПоддержкаПодключена = ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	Если Не ИнтернетПоддержкаПодключена Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отказ = Ложь;
	ПараметрыЗапроса = ПараметрыЗапроса(ПараметрыОперации, Отказ);
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	Если ФоновоеЗадание <> Неопределено Тогда
		ОтменитьВыполнениеЗадания(ФоновоеЗадание.ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = Новый Структура("ИмяПроцедуры, Наименование, ПараметрыПроцедуры");
	Задание.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '1С:Доставка. %1.'"), 
		ПараметрыОперации.НаименованиеОперации);
	Задание.ИмяПроцедуры = "СервисДоставки." + ПараметрыОперации.ИмяПроцедуры;
	Задание.ПараметрыПроцедуры = ПараметрыЗапроса;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Задание.Наименование;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(Задание.ИмяПроцедуры,
		Задание.ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДоступныеПечатныеФормыВФоне()
	
	ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
	ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДоступныеПечатныеФормы();
	ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение списка доступных печатных форм.'");
	
	Возврат ВыполнитьЗапросВФоне(Ложь, ПараметрыОперации);
	
КонецФункции

#КонецОбласти

#Область ПараметрыЗапроса

&НаСервере
Функция ПараметрыЗапроса(ПараметрыОперации, Отказ)
	
	ПараметрыЗапроса = Новый Структура();
	
	ИмяПроцедуры = ПараметрыОперации.ИмяПроцедуры;
	
	Если ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДоступныеПечатныеФормы() Тогда
		ПараметрыЗапроса = ПараметрыЗапросаПолучитьДоступныеПечатныеФормы(ПараметрыОперации, Отказ);
	ИначеЕсли ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьФайлыПечатныхФорм() Тогда
		ПараметрыЗапроса = ПараметрыЗапросаПолучитьФайлыПечатныхФорм(ПараметрыОперации, Отказ);
	КонецЕсли;
	
	ПараметрыЗапроса.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

&НаСервере
Функция ПараметрыЗапросаПолучитьДоступныеПечатныеФормы(ПараметрыОперации, Отказ)
	
	ПараметрыЗапроса = СервисДоставки.НовыйПараметрыЗапросаПолучитьДоступныеПечатныеФормы();
	
	ПараметрыЗапроса.ИдентификаторыЗаказов = ИдентификаторыЗаказов.ВыгрузитьЗначения();

	Возврат ПараметрыЗапроса;
	
КонецФункции

&НаСервере
Функция ПараметрыЗапросаПолучитьФайлыПечатныхФорм(ПараметрыОперации, Отказ)
	
	ПараметрыЗапроса = СервисДоставки.НовыйПараметрыЗапросаЗагрузитьФайлыПечатныхФорм();
	
	Для Каждого ИдентификаторЗаказа Из ИдентификаторыЗаказов Цикл
		Для Каждого ПечатнаяФорма Из СписокПечатныхФорм Цикл
			Если Не ПечатнаяФорма.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			НайденныеСтроки = Список.НайтиСтроки(Новый Структура("Наименование, ИдентификаторЗаказа", ПечатнаяФорма.Наименование, ИдентификаторЗаказа));
			Если НайденныеСтроки.Количество() > 0 Тогда
	
				ЭлементПараметраЗапроса = СервисДоставки.НовыйЭлементПараметровЗапросаЗагрузитьФайлыПечатныхФорм();
				ЭлементПараметраЗапроса.Вставить("ИдентификаторЗаказа", ИдентификаторЗаказа);
		
				Для Каждого ТекущаяСтрока Из НайденныеСтроки Цикл
					
					ПараметрыФормы = СервисДоставки.НовыйПечатнаяФормаДляЗапроса();
					ПараметрыФормы.ИдентификаторДокумента = ТекущаяСтрока.ИдентификаторДокумента;
					ПараметрыФормы.ИдентификаторПечатнойФормы = ТекущаяСтрока.Идентификатор;
		
					ЭлементПараметраЗапроса.Список.Добавить(ПараметрыФормы);
					
				КонецЦикла;
				
				ПараметрыЗапроса.Параметры.Добавить(ЭлементПараметраЗапроса);
				
			КонецЕсли;
		КонецЦикла;
			
	КонецЦикла;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

#КонецОбласти

#Область ЗагрузитьРезультаты

&НаСервере
Процедура ЗагрузитьРезультатЗапросаПолучитьДоступныеПечатныеФормы(АдресРезультата, ОперацияВыполнена)
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если ЗначениеЗаполнено(Результат) 
			И ТипЗнч(Результат) = Тип("Структура") Тогда
			
			Список.Очистить();
			СписокПечатныхФорм.Очистить();
			
			Если Результат.Свойство("Список") Тогда
				Если ТипЗнч(Результат.Список) = Тип("Массив") Тогда
					Для Каждого ТекущаяСтрока Из Результат.Список Цикл
						НоваяСтрока = Список.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
						НоваяСтрока.НомерКартинки = ПолучитьИндексПиктограммыФайла(ВРег(НоваяСтрока.Расширение));
					КонецЦикла;
				КонецЕсли;
			Иначе
				ОперацияВыполнена = Ложь;
			КонецЕсли;
			
			Если ИдентификаторыЗаказов.Количество() > 1 И ТипГрузоперевозки = 2 Тогда
				
				ВременнаяТаблица = Список.Выгрузить(Новый Структура("Идентификатор", 10));
				
				ВременнаяТаблица.Свернуть("Наименование, Идентификатор");
				Для Каждого ПечатнаяФорма Из ВременнаяТаблица Цикл
					
					НайденныеСтроки = Список.НайтиСтроки(Новый Структура("Наименование, Идентификатор", ПечатнаяФорма.Наименование, ПечатнаяФорма.Идентификатор));
					НайденныеЗначения = Новый Структура("НомерКартинки, Расширение");
					ЗаполнитьЗначенияСвойств(НайденныеЗначения, НайденныеСтроки[0]);
					
					МодифицироватьЗначения = Истина;
					Для Каждого НайденнаяПечатнаяФорма Из НайденныеСтроки Цикл
						Если Не НайденныеЗначения.НомерКартинки = НайденнаяПечатнаяФорма.НомерКартинки 
							Или Не НайденныеЗначения.Расширение = НайденнаяПечатнаяФорма.Расширение Тогда
							МодифицироватьЗначения = Ложь;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					
					Если МодифицироватьЗначения Тогда
						ЗаполнитьЗначенияСвойств(ПечатнаяФорма, НайденныеЗначения);
					КонецЕсли;
					
				КонецЦикла;
				
			Иначе

				ВременнаяТаблица = Список.Выгрузить();
				ВременнаяТаблица.Свернуть("Наименование, НомерКартинки, Расширение, Идентификатор");
				
			КонецЕсли;
			
			СписокПечатныхФорм.Загрузить(ВременнаяТаблица);
			
			СервисДоставки.ОбработатьБлокОшибок(Результат, ОперацияВыполнена);
		Иначе
			ОперацияВыполнена = Ложь;
		КонецЕсли;
	Иначе
		ОперацияВыполнена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультатЗапросаПолучитьФайлыПечатныхФорм(АдресРезультата, ОперацияВыполнена)
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если ЗначениеЗаполнено(Результат) 
			И ТипЗнч(Результат) = Тип("Структура") Тогда
			
			Если Результат.Свойство("Список") Тогда
				Если ТипЗнч(Результат.Список) = Тип("Массив") Тогда
					Для Каждого ТекущийФайл Из Результат.Список Цикл
						
						ИмяФайла = ТекущийФайл.ИдентификаторЗаказа + " " + ТекущийФайл.Наименование + "." + ТекущийФайл.Расширение;
						Если НРег(ТекущийФайл.Кодировка) = "base64" Тогда
							Попытка
								ДвоичныеДанныеФайла = Base64Значение(ТекущийФайл.Данные);
							Исключение
								ОперацияВыполнена = Ложь;
								ОбщегоНазначенияКлиент.СообщитьПользователю(
									СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'Ошибка извлечения данных файла: %1'"),
										ИмяФайла));
								
							КонецПопытки;
						КонецЕсли;
						
						ТекущийФайл.Удалить("Данные");
						ПутьКФайлу = КаталогЗагрузкиПечатныхФорм + "\" + ИмяФайла;
						ТекущийФайл.Вставить("ПутьКФайлу", ПутьКФайлу);
						
						Оповещение = Новый ОписаниеОповещения("КопированиеФайлаЗавершение", ЭтаФорма, ТекущийФайл);
						ДвоичныеДанныеФайла.НачатьЗапись(Оповещение, ПутьКФайлу);
						
					КонецЦикла;
				КонецЕсли;
			Иначе
				ОперацияВыполнена = Ложь;
			КонецЕсли;
			СервисДоставкиКлиент.ОбработатьБлокОшибок(Результат, ОперацияВыполнена);
		Иначе
			ОперацияВыполнена = Ложь;
		КонецЕсли;
	Иначе
		ОперацияВыполнена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура УстановитьПометкуДляВсехЭлементовСписка(Пометка)
	
	Для Каждого ТекущаяПечатнаяФорма Из СписокПечатныхФорм Цикл
		ТекущаяПечатнаяФорма.Пометка = Пометка;
	КонецЦикла;
	
	Элементы.ФормаЗагрузить.Доступность = ЕстьОтмеченныеПечатныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКаталогЗагрузки(ВыполнитьЗагрузкуПослеВыбора = Ложь)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполнитьЗагрузкуПослеВыбора", ВыполнитьЗагрузкуПослеВыбора);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКаталогЗагрузкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ФайловаяСистемаКлиент.ВыбратьКаталог(ОписаниеОповещения, НСтр("ru = 'Выберите каталог'"), КаталогЗагрузкиПечатныхФорм);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКаталогЗагрузкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено
		И Результат <> "" Тогда
		
		КаталогЗагрузкиПечатныхФорм = Результат;
		Если ДополнительныеПараметры.Свойство("ВыполнитьЗагрузкуПослеВыбора")
			И ДополнительныеПараметры.ВыполнитьЗагрузкуПослеВыбора Тогда
			ЗагрузитьПечатныеФормыВКаталогНаДиске();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КопированиеФайлаЗавершение(ДополнительныеПараметры) Экспорт
	
	Если ОткрытьПечатныеФормыПослеЗагрузки Тогда
		ФайловаяСистемаКлиент.ОткрытьФайл(ДополнительныеПараметры.ПутьКФайлу);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьБлокировкуЭлементовФормы(НеДоступно = Истина)
	
	Элементы.СписокУстановитьФлажки.Доступность = Не НеДоступно;
	Элементы.СписокСнятьФлажки.Доступность = Не НеДоступно;
	Элементы.СписокПечатныхФорм.Доступность = Не НеДоступно;
	Элементы.ОткрытьПечатныеФормыПослеЗагрузки.Доступность = Не НеДоступно;
	Элементы.ФормаЗагрузить.Доступность = Не НеДоступно;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИндексПиктограммыФайла(Знач РасширениеФайла)
	
	Если ТипЗнч(РасширениеФайла) <> Тип("Строка")
		ИЛИ ПустаяСтрока(РасширениеФайла) Тогда
		Возврат 0;
	КонецЕсли;
	
	РасширениеФайла = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
	
	Расширение = "." + НРег(РасширениеФайла) + ";";
	
	Если СтрНайти(".dt;.1cd;.cf;.cfu;", Расширение) <> 0 Тогда
		Возврат 6; // Файлы 1С.
		
	ИначеЕсли Расширение = ".mxl;" Тогда
		Возврат 8; // Табличный Файл.
		
	ИначеЕсли СтрНайти(".txt;.log;.ini;", Расширение) <> 0 Тогда
		Возврат 10; // Текстовый Файл.
		
	ИначеЕсли Расширение = ".epf;" Тогда
		Возврат 12; // Внешние обработки.
		
	ИначеЕсли СтрНайти(".ico;.wmf;.emf;",Расширение) <> 0 Тогда
		Возврат 14; // Картинки.
		
	ИначеЕсли СтрНайти(".htm;.html;.url;.mht;.mhtml;",Расширение) <> 0 Тогда
		Возврат 16; // HTML.
		
	ИначеЕсли СтрНайти(".doc;.dot;.rtf;",Расширение) <> 0 Тогда
		Возврат 18; // Файл Microsoft Word.
		
	ИначеЕсли СтрНайти(".xls;.xlw;",Расширение) <> 0 Тогда
		Возврат 20; // Файл Microsoft Excel.
		
	ИначеЕсли СтрНайти(".ppt;.pps;",Расширение) <> 0 Тогда
		Возврат 22; // Файл Microsoft PowerPoint.
		
	ИначеЕсли СтрНайти(".vsd;",Расширение) <> 0 Тогда
		Возврат 24; // Файл Microsoft Visio.
		
	ИначеЕсли СтрНайти(".mpp;",Расширение) <> 0 Тогда
		Возврат 26; // Файл Microsoft Visio.
		
	ИначеЕсли СтрНайти(".mdb;.adp;.mda;.mde;.ade;",Расширение) <> 0 Тогда
		Возврат 28; // База данных Microsoft Access.
		
	ИначеЕсли СтрНайти(".xml;",Расширение) <> 0 Тогда
		Возврат 30; // xml.
		
	ИначеЕсли СтрНайти(".msg;.eml;",Расширение) <> 0 Тогда
		Возврат 32; // Письмо электронной почты.
		
	ИначеЕсли СтрНайти(".zip;.rar;.arj;.cab;.lzh;.ace;",Расширение) <> 0 Тогда
		Возврат 34; // Архивы.
		
	ИначеЕсли СтрНайти(".exe;.com;.bat;.cmd;",Расширение) <> 0 Тогда
		Возврат 36; // Исполняемые файлы.
		
	ИначеЕсли СтрНайти(".grs;",Расширение) <> 0 Тогда
		Возврат 38; // Графическая схема.
		
	ИначеЕсли СтрНайти(".geo;",Расширение) <> 0 Тогда
		Возврат 40; // Географическая схема.
		
	ИначеЕсли СтрНайти(".jpg;.jpeg;.jp2;.jpe;",Расширение) <> 0 Тогда
		Возврат 42; // jpg.
		
	ИначеЕсли СтрНайти(".bmp;.dib;",Расширение) <> 0 Тогда
		Возврат 44; // bmp.
		
	ИначеЕсли СтрНайти(".tif;.tiff;",Расширение) <> 0 Тогда
		Возврат 46; // tif.
		
	ИначеЕсли СтрНайти(".gif;",Расширение) <> 0 Тогда
		Возврат 48; // gif.
		
	ИначеЕсли СтрНайти(".png;",Расширение) <> 0 Тогда
		Возврат 50; // png.
		
	ИначеЕсли СтрНайти(".pdf;",Расширение) <> 0 Тогда
		Возврат 52; // pdf.
		
	ИначеЕсли СтрНайти(".odt;",Расширение) <> 0 Тогда
		Возврат 54; // Open Office writer.
		
	ИначеЕсли СтрНайти(".odf;",Расширение) <> 0 Тогда
		Возврат 56; // Open Office math.
		
	ИначеЕсли СтрНайти(".odp;",Расширение) <> 0 Тогда
		Возврат 58; // Open Office Impress.
		
	ИначеЕсли СтрНайти(".odg;",Расширение) <> 0 Тогда
		Возврат 60; // Open Office draw.
		
	ИначеЕсли СтрНайти(".ods;",Расширение) <> 0 Тогда
		Возврат 62; // Open Office calc.
		
	ИначеЕсли СтрНайти(".mp3;",Расширение) <> 0 Тогда
		Возврат 64;
		
	ИначеЕсли СтрНайти(".erf;",Расширение) <> 0 Тогда
		Возврат 66; // Внешние отчеты.
		
	ИначеЕсли СтрНайти(".docx;",Расширение) <> 0 Тогда
		Возврат 68; // Файл Microsoft Word docx.
		
	ИначеЕсли СтрНайти(".xlsx;",Расширение) <> 0 Тогда
		Возврат 70; // Файл Microsoft Excel xlsx.
		
	ИначеЕсли СтрНайти(".pptx;",Расширение) <> 0 Тогда
		Возврат 72; // Файл Microsoft PowerPoint pptx.
		
	ИначеЕсли СтрНайти(".p7s;",Расширение) <> 0 Тогда
		Возврат 74; // Файл подписи.
		
	ИначеЕсли СтрНайти(".p7m;",Расширение) <> 0 Тогда
		Возврат 76; // зашифрованное сообщение.
	Иначе
		Возврат 4;
	КонецЕсли;
	
КонецФункции

#КонецОбласти