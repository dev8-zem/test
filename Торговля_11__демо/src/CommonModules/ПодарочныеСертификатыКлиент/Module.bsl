////////////////////////////////////////////////////////////////////////////////
// Модуль "ПодарочныеСертификатыКлиент", содержит процедуры и функции для 
// обработки действий пользователя в процессе работы с подарочными сертификатами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура обработки выбора подарочного сертификата.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма.
//  ТекущиеДанные - Структура - Данные выбранного подарочного сертификата, содержит:
//  	* Ссылка - СправочникСсылка.ПодарочныеСертификаты
//  ТипКода - ПеречислениеСсылка.ТипыКодовКарт - Тип кода карты.
//  РегистрироватьНовые - Булево - Оповещать форму владельца вместо формы.
//  УпрощеннаяРегистрация - Булево - 
//
Процедура ОбработатьВыборПодарочногоСертификата(Форма, ТекущиеДанные, ТипКода, РегистрироватьНовые = Истина, УпрощеннаяРегистрация = Истина) Экспорт
	
	ИдентификаторФормы = Форма.УникальныйИдентификатор;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		
		Оповестить(
			"СчитанПодарочныйСертификат",
			Новый Структура("ПодарочныйСертификат, ФормаВладелец", ТекущиеДанные.Ссылка, ИдентификаторФормы),
			Неопределено);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Считан подарочный сертификат'"),
			ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка),
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Считан подарочный сертификат %1'"), ТекущиеДанные.Ссылка),
			БиблиотекаКартинок.Информация32);
			
	ИначеЕсли РегистрироватьНовые Тогда
		// Карта не зарегистрирована.
		
		Если УпрощеннаяРегистрация Тогда
			ТекущиеДанные.Ссылка = ПодарочныеСертификатыВызовСервера.ЗарегистрироватьПодарочныйСертификатУпрощенно(ТекущиеДанные.ВидПодарочногоСертификата, 
																												   ТипКода,
																												   ТекущиеДанные.МагнитныйКод, 
																												   ТекущиеДанные.Штрихкод);
		Иначе
			СтруктураДанныхПодарочногоСертификата = ПодарочныеСертификатыВызовСервера.ИнициализироватьОписаниеПодарочногоСертификата();
			ЗаполнитьЗначенияСвойств(СтруктураДанныхПодарочногоСертификата, ТекущиеДанные);
			ТекущиеДанные.Ссылка = ПодарочныеСертификатыВызовСервера.ЗарегистрироватьПодарочныйСертификат(СтруктураДанныхПодарочногоСертификата);
		КонецЕсли;	
		
		Оповестить(
			"Запись_ПодарочныйСертификат",
			Новый Структура,
			ТекущиеДанные.Ссылка);
		
		Оповестить(
			"СчитанПодарочныйСертификат",
			Новый Структура("ПодарочныйСертификат, ФормаВладелец", ТекущиеДанные.Ссылка, ИдентификаторФормы),
			Неопределено);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Считан подарочный сертификат'"),
			ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка),
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Считан подарочный сертификат %1'"), ТекущиеДанные.Ссылка),
			БиблиотекаКартинок.Информация32);
			
	Иначе

		ТекстСообщения = НСтр("ru = 'В этом режиме регистрация подарочного сертификата не разрешена.'");
		ПоказатьОповещениеПользователя(
			ТекстСообщения,
			ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка),
			ТекстСообщения,
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет обработку полученного кода подарочного сертификата.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма.
//  КодКарты - Строка - Полученный код подарочного сертификата.
//  ТипКода - ПеречислениеСсылка.ТипыКодовКарт - Тип кода полученного подарочного сертификата.
//	ДополнительныеПараметры - Структура - Дополнительные параметры для обработки полученного кода; см. ПодарочныеСертификатыВызовСервера.ПараметрыОбработкиПолученногоКода.
//
Процедура ОбработатьПолученныйКодНаКлиенте(Форма, КодКарты, ТипКода, ДополнительныеПараметры) Экспорт
	
	Отборы = ДополнительныеПараметры.Отборы;
	НайденныеПодарочныеСертификаты = ПодарочныеСертификатыВызовСервера.ОбработатьПолученныйКодНаСервере(КодКарты, ТипКода, ДополнительныеПараметры);
	Если НайденныеПодарочныеСертификаты.Количество() = 0 Тогда
		СообщитьПользователюЧтоПодарочныйСертификатНеНайден(КодКарты, ТипКода, Отборы);
		Возврат;
	ИначеЕсли НайденныеПодарочныеСертификаты.Количество() > 1 Тогда
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТипКода", ТипКода);
		ПараметрыОткрытия.Вставить("КодКарты", КодКарты);
		ПараметрыОткрытия.Вставить("Отбор", Отборы);
		ПараметрыОткрытия.Вставить("РегистрироватьНовые", ДополнительныеПараметры.РегистрироватьНовые);
		ОткрытьФорму("Справочник.ПодарочныеСертификаты.Форма.СчитываниеПодарочногоСертификата", ПараметрыОткрытия, Форма);
	ИначеЕсли НайденныеПодарочныеСертификаты.Количество() = 1 Тогда
		ОбработатьВыборПодарочногоСертификата(Форма, НайденныеПодарочныеСертификаты[0], ТипКода, ДополнительныеПараметры.РегистрироватьНовые);
	КонецЕсли;
	
КонецПроцедуры

// Процедура открывает форму для подбора подарочных сертификатов.
//
// Параметры:
//  КодКарты - Строка, Массив Из Строка - Полученный код подарочного сертификата.
//  ТипКода - ПеречислениеСсылка.ТипыКодовКарт - Тип кода полученного подарочного сертификата.
//  Отборы - Структура - Данные об использованных отборах.
//
Процедура СообщитьПользователюЧтоПодарочныйСертификатНеНайден(КодКарты, ТипКода, Знач Отборы) Экспорт
	
	Предобработка = ПодарочныеСертификатыКлиентСервер.НеобходимаПредобработкаДанных(КодКарты, ТипКода);
	ТекстыСообщения = Новый Массив;

	Если ТипЗнч(Отборы) = Тип("Структура") И Отборы.Количество() Тогда
		
		ПредставленияОтборов = Новый Массив;
		Для Каждого Отбор Из Отборы Цикл
			Если Отбор.Ключ = "ТипОперации" Тогда
				Продолжить;
			КонецЕсли;
			ЗначенияОтборов = Новый Массив();
			Если ТипЗнч(Отбор.Значение) = Тип("Массив") Тогда
				ЗначенияОтборов = Отбор.Значение;
			Иначе
				ЗначенияОтборов.Добавить(Отбор.Значение);
			КонецЕсли;
			Если ЗначенияОтборов.Количество() Тогда
				ПредставленияОтборов.Добавить(Символы.Таб + Отбор.Ключ + ":");
				Для Каждого ЗначениеОтбора Из ЗначенияОтборов Цикл
					ПредставленияОтборов.Добавить(Символы.Таб + Символы.Таб + ЗначениеОтбора);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			ТекстСообщения = НСтр("ru = 'Подарочный сертификат со штрихкодом ""%1"" не найден. Использовался отбор по:'");
		Иначе
			Если Предобработка Тогда
				ТекстСообщения = НСтр("ru = 'Подарочный сертификат со считанным магнитным кодом не найден. Использовался отбор по:'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Подарочный сертификат с магнитным кодом ""%1"" не найден. Использовался отбор по:'");
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			ТекстСообщения = НСтр("ru = 'Подарочный сертификат со штрихкодом ""%1"" не зарегистрирован.'");
		Иначе
			Если Предобработка Тогда
				ТекстСообщения = НСтр("ru = 'Подарочный сертификат со считанным магнитным кодом не зарегистрирован.'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Подарочный сертификат с магнитным кодом ""%1"" не зарегистрирован.'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ТекстыСообщения.Добавить(ТекстСообщения);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ТекстыСообщения, ПредставленияОтборов);
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрСоединить(ТекстыСообщения, Символы.ПС), КодКарты));
	
КонецПроцедуры

// Процедура открывает форму для подбора подарочных сертификатов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма.
//  ПараметрыФормыПодбора - Структура - Данные для открытия формы подбора.
//
Процедура ОткрытьФормуПодбораПодарочныхСертификатов(Форма, ПараметрыФормыПодбора) Экспорт

	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("АдресВХранилище", ПараметрыФормыПодбора.АдресВХранилище);
	ПараметрыОткрытияФормы.Вставить("Валюта", ПараметрыФормыПодбора.Валюта);
	ПараметрыОткрытияФормы.Вставить("Организация", ПараметрыФормыПодбора.Организация);
	ПараметрыОткрытияФормы.Вставить("Доплатить", ПараметрыФормыПодбора.Доплатить);
	ПараметрыОткрытияФормы.Вставить("ПоказыватьИтогОсталосьДоплатить", ПараметрыФормыПодбора.ПоказыватьИтогОсталосьДоплатить);
	ПараметрыОткрытияФормы.Вставить("Отбор", ПараметрыФормыПодбора.Отбор);
	ПараметрыОткрытияФормы.Вставить("РегистрироватьНовые", ПараметрыФормыПодбора.РегистрироватьНовые);
	
	РежимОткрытияДоплата = Ложь;
	ПараметрыФормыПодбора.Свойство("РежимОткрытияДоплата", РежимОткрытияДоплата);
	// По умолчанию форма открывается в режиме подбора доплаты, если не передано свойство РежимОткрытияДоплата.
	РежимОткрытияДоплата = ?(РежимОткрытияДоплата = Неопределено, Истина, РежимОткрытияДоплата);
	ПараметрыОткрытияФормы.Вставить("РежимОткрытияДоплата", РежимОткрытияДоплата);
	
	ПараметрыОткрытияФормы.Вставить("ИндексТекущейСтроки", Неопределено);
	ПараметрыФормыПодбора.Свойство("ИндексТекущейСтроки", ПараметрыОткрытияФормы.ИндексТекущейСтроки);
	
	Если ПараметрыФормыПодбора.Свойство("АдресВХранилищеТовары") Тогда
		ПараметрыОткрытияФормы.Вставить("АдресВХранилищеТовары", ПараметрыФормыПодбора.АдресВХранилищеТовары);
	КонецЕсли;

	ОткрытьФорму(
		"Документ.ЧекККМ.Форма.ТабличнаяЧастьПодарочныеСертификаты",
		ПараметрыОткрытияФормы,
		Форма,,,,
		ПараметрыФормыПодбора.ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьВопросОНеобходимостиНепроведенногоДокумента(Форма, ОписаниеОповещенияЗавершения) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияЗавершения", ОписаниеОповещенияЗавершения);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПослеОтветаНаВопросОПроведенииДокумента", ЭтотОбъект, ДополнительныеПараметры),
		НСтр("ru = 'Операция возможна только с непроведенным документом, отменить проведение документа?'"),
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

// Параметры:
//  Форма - ФормаКлиентскогоПриложения - 
//  ПроверятьСтатусПроведения - Булево -
//  
// Возвращаемое значение:
//  Булево -
&НаКлиенте
Функция ПроверитьВозможностьДобавленияПодарочногоСертификата(Форма, ПроверятьСтатусПроведения = Истина) Экспорт
	Результат = Истина;
	
	ОчиститьСообщения();
	Если Не ЗначениеЗаполнено(Форма.Объект.Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Перед добавлением подарочного сертификата необходимо выбрать организацию.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"Организация", "Объект.Организация");
		Результат = Ложь;
	КонецЕсли;
	
	Если ПроверятьСтатусПроведения И Форма.Объект.Проведен Тогда
		ТекстСообщения = НСтр("ru = 'Перед добавлением подарочного сертификата необходимо отменить проведение документа.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,);
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат
КонецФункции

#Область ДокументыОплатыНаОснованииПодарочногоСертификата

// Обработчик подключенной команды.
//
// Параметры:
//   МассивСсылок - Массив Из ЛюбаяСсылка - ссылки выбранных объектов, для которых выполняется команда.
//   ПараметрыВыполнения - см. ПодключаемыеКомандыКлиент.ПараметрыВыполненияКоманды
//
Процедура ВыбратьКонтрагентаДляВводаДокументаОплатыНаОснованииПодарочногоСертификата(МассивСсылок, ПараметрыВыполнения) Экспорт

	Если ЗначениеЗаполнено(ПараметрыВыполнения.ОписаниеКоманды.ИмяФормы) Тогда

		ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
		ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
		
		ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаВыбора" 
					,Новый Структура("ТекущаяСтрока", ПредопределенноеЗначение("Справочник.Контрагенты.РозничныйПокупатель"))
					,ПараметрыВыполненияКоманды.Источник
					,ПараметрыВыполненияКоманды.Уникальность
					,ПараметрыВыполненияКоманды.Окно
					,ПараметрыВыполненияКоманды.НавигационнаяСсылка
					,Новый ОписаниеОповещения("ВыбратьКонтрагентаДляВводаДокументаОплатыНаОснованииПодарочногоСертификатаЗавершение", ЭтотОбъект, ПараметрыВыполнения)
					,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
					
	КонецЕсли;
				
КонецПроцедуры

Процедура ВыбратьКонтрагентаДляВводаДокументаОплатыНаОснованииПодарочногоСертификатаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
		ОписаниеКоманды = ДополнительныеПараметры.ОписаниеКоманды; // Структура
		ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Основание", Новый Структура("ПодарочныйСертификат,Контрагент", ДополнительныеПараметры.МассивСсылок, Результат));
		
		ОткрытьФорму(
			ДополнительныеПараметры.ОписаниеКоманды.ИмяФормы,
			ПараметрыОткрытия,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно,
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеОтветаНаВопросОПроведенииДокумента(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОтветаНаВопросОПроведенииДокументаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПодключаемоеОборудованиеУТКлиент.ЗаписатьОбъект(
			ДополнительныеПараметры.Форма,
			РежимЗаписиДокумента.ОтменаПроведения,
			ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОПроведенииДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	// Возвращается результат выполнения метода формы управляемого приложения Записать
	Если Результат = Истина Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершения, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
