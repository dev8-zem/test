#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("БазаПодключена") Тогда
		БазаПодключена = Параметры.БазаПодключена;
	КонецЕсли;
	
	Если БазаПодключена Тогда
		
		ДанныеНастроекИнтеграцииСУСП = ИнформационныйЦентрСервер.ДанныеНастроекИнтеграцииСУСП();
		АдресУСП = ДанныеНастроекИнтеграцииСУСП.АдресВнешнегоАнонимногоИнтерфейсаУСП;
		Email = ДанныеНастроекИнтеграцииСУСП.АдресПочтыАбонентаДляИнтеграцииСУСП;
		
		Элементы.ДекорацияИнформация.Заголовок = НСтр("ru='Информационная база подключена к службе поддержки со следующими параметрами:'");
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		
		ПараметрыЗадания = ДлительныеОперации.ВыполнитьВФоне(
			"ИнформационныйЦентрСервер.ОпределитьСостояниеПодключенияВФоне", , ПараметрыВыполнения);
		
		Элементы.ЗначокСостояниеПодключения.Картинка = БиблиотекаКартинок.ДлительнаяОперация16;
		
		КодРегистрации = ИнформационныйЦентрСервер.КодРегистрацииВУСП();
		СведенияОбИБ = ИнформационныйЦентрСервер.СведенияОбИБДляИнтеграции();
		ИдентификаторИБ = СведенияОбИБ.ИдентификаторИБ;
		
	Иначе
		
		Элементы.ДекорацияИнформация.Заголовок = НСтр("ru='Информационная база не подключена к службе поддержки. Подключить базу можно сейчас.'");
		
		Email = ПользователиСлужебный.ОписаниеПользователя(Пользователи.АвторизованныйПользователь()).АдресЭлектроннойПочты;
		СведенияОбИБ = ИнформационныйЦентрСервер.СведенияОбИБДляИнтеграции();
		ИмяКонфигурации = СведенияОбИБ.ИмяКонфигурации;
		ВерсияКонфигурации = СведенияОбИБ.ВерсияКонфигурации;
		ВерсияПлатформы = СведенияОбИБ.ВерсияПлатформы;
		ИдентификаторКлиента = СведенияОбИБ.ИдентификаторКлиента;
		ИдентификаторИБ = СведенияОбИБ.ИдентификаторИБ;
		
	КонецЕсли;
	
	Элементы.КодРегистрации.Видимость = Не БазаПодключена;
	Элементы.ВвестиКодРегистрации.Видимость = Не БазаПодключена;
	Элементы.ПерейтиНаСтраницуРегистрации.Видимость = Не БазаПодключена;
	Элементы.ОтменитьПодключение.Видимость = БазаПодключена;
	Элементы.ОтменитьПодключение.Доступность = Ложь;
	
	Элементы.АдресУСП.ТолькоПросмотр = БазаПодключена;
	Элементы.Email.ТолькоПросмотр = БазаПодключена;
	Элементы.ГруппаСостояниеПодключения.Видимость = БазаПодключена;
	
	Элементы.ГруппаВводТокенаДляПодключения.Видимость = Не БазаПодключена;
	
	Элементы.ПерейтиНаСтраницуЗапросаКодовПользователей.Видимость = БазаПодключена;
	Элементы.ПерейтиНаСтраницуЗапросаКодовПользователей.Доступность = Ложь;
	
	Элементы.ДекорацияНадписьПодключитьБазу.Видимость = Не БазаПодключена;
	Элементы.ДекорацияНадписьПриПомощиКода.Видимость = Не БазаПодключена;
	Элементы.ГруппаРазделитель.Видимость = Не БазаПодключена;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если БазаПодключена Тогда
		ПодключитьОбработчикОжидания("ОпределитьСостояниеПодключенияВФонеОжидание", 1, Истина);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиНаСтраницуРегистрации(Команда)
	
	Если Не ЗначениеЗаполнено(АдресУСП) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Необходимо указать адрес службы поддержки'"), , "АдресУСП");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Email) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Необходимо указать e-mail пользователя'"), , "Email");
		Возврат;
	КонецЕсли;
	
	ШаблонАдресаСтраницы = "%1/v1/StartLocalRegistration?email=%2&appname=%3&appversion=%4&platf=%5&ibid=%6&clid=%7";
	СсылкаНаСтраницу = СтрШаблон(ШаблонАдресаСтраницы, 
		АдресУСП, Email, ИмяКонфигурации, ВерсияКонфигурации, ВерсияПлатформы, ИдентификаторИБ, ИдентификаторКлиента);
	
	#Если ВебКлиент Тогда
		ПерейтиПоНавигационнойСсылке(СсылкаНаСтраницу);
	#Иначе
		ЗапуститьПриложение(СсылкаНаСтраницу);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиКодРегистрации(Команда)
	Результат = ВвестиКодРегистрацииНаСервере();
	Если Не Результат.Успешно Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКОбращениям(Команда)
	
	Закрыть();
	ИнформационныйЦентрКлиент.ОткрытьОбращенияВСлужбуПоддержки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПодключение(Команда)

	Оповещение = Новый ОписаниеОповещения("ОтменитьПодключениеПриПроверкеОтвета", ЭтаФорма);
	
	ТекстВопроса = НСтр("ru = 'После отмены подключения работа с обращениями в службу поддержки будет невозможна. Продолжить?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьКодыПользователей(Команда)
	
	Если Не ПроверкаПередОтправкойЗапросовКодов() Тогда
		Возврат;
	КонецЕсли;

	РезультатЗапроса = ЗапроситьКодыПользователейНаСервере();
	
	Если Не РезультатЗапроса.ЗапросОтправлен Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатЗапроса.ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если РезультатЗапроса.Свойство("ИдентификаторЗапроса")
		И ЗначениеЗаполнено(РезультатЗапроса.ИдентификаторЗапроса)
		И РезультатЗапроса.Свойство("ЕстьСтраницаСЗащитой")
		И РезультатЗапроса.ЕстьСтраницаСЗащитой Тогда
		ОткрытьСтраницуПолученияКодовПользователейСЗащитой(РезультатЗапроса.ИдентификаторЗапроса);
		Возврат;
	КонецЕсли;
	
	Если РезультатЗапроса.Свойство("ЕстьСтраницаСЗащитой")
		И Не РезультатЗапроса.ЕстьСтраницаСЗащитой Тогда
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru='Отправлено писем: %1.'"),
			РезультатЗапроса.КоличествоОтправленных);
			
		ТекстСообщения = ТекстСообщения 
			+ Символы.ПС 
			+ НСтр("ru='Код, отправленный в письме, пользователи могут использовать для работы с обращениями.'");
		
		Если РезультатЗапроса.Свойство("АдресаНетПользователяУАбонента") Тогда
			ПроверитьИВывестиОшибкиОтправкиПисем(РезультатЗапроса.АдресаНетПользователяУАбонента);
		КонецЕсли;

		Если ЗначениеЗаполнено(РезультатЗапроса.ТекстСообщения) Тогда
			ТекстСообщения = ТекстСообщения + Символы.ПС + РезультатЗапроса.ТекстСообщения;
		КонецЕсли;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуЗапросаКодовПользователей(Команда)
	ПерейтиНаСтраницуЗапросаКодовПользователейНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВвестиТокенДляРегистрации(Команда)
	
	ТекстНеверныйТокен = НСтр("ru='Неверный токен для регистрации.'");
	
	Если Не ЗначениеЗаполнено(ТокенДляРегистрации) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстНеверныйТокен,
			,
			"ТокенДляРегистрации");
		Возврат;
	КонецЕсли;
	
	ДанныеРасшифровкиТокена = ДанныеРасшифровкиТокена(ТокенДляРегистрации);
	
	Если Не ДанныеРасшифровкиТокена.Расшифровано Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстНеверныйТокен,
			,
			"ТокенДляРегистрации");
		Возврат;
	КонецЕсли;
	
	Если Не ДанныеРасшифровкиТокена.Данные.Свойство("email") Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстНеверныйТокен,
			,
			"ТокенДляРегистрации");
		Возврат;
	КонецЕсли;
	
	Если ДанныеРасшифровкиТокена.Данные.email <> Email Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Токен предназначен для пользователя с другим адресом электронной почты.'"),
			,
			"ТокенДляРегистрации");
		Возврат;
	КонецЕсли;

	АдресУСП = ДанныеРасшифровкиТокена.Данные.url;
	Email = ДанныеРасшифровкиТокена.Данные.email;
	КодРегистрации = ДанныеРасшифровкиТокена.Данные.code;
	
	Результат = ВвестиКодРегистрацииНаСервере();
	Если Не Результат.Успешно Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВвестиКодРегистрацииНаСервере()
	
	Результат = новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Успешно", Ложь);
	
	АдресСервиса = АдресУСП + "/v1/FinishLocalRegistration";
	
	Попытка
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресСервиса);
		Хост = СтруктураURI.Хост;
		ПутьНаСервере = СтруктураURI.ПутьНаСервере;
		Порт = СтруктураURI.Порт;
		
		Если НРег(СтруктураURI.Схема) = НРег("https") Тогда
			ЗащищенноеСоединение = 
				ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение(, Новый СертификатыУдостоверяющихЦентровОС);
		Иначе
			ЗащищенноеСоединение = Неопределено;
		КонецЕсли;
		
		Соединение = Новый HTTPСоединение(
			Хост,
			Порт,
			,
			,
			,
			,
			ЗащищенноеСоединение);
		
		ДанныеЗапроса = Новый Структура;
		ДанныеЗапроса.Вставить("email", Email);
		ДанныеЗапроса.Вставить("appname", ИмяКонфигурации);
		ДанныеЗапроса.Вставить("appversion", ВерсияКонфигурации);
		ДанныеЗапроса.Вставить("platf", ВерсияПлатформы);
		ДанныеЗапроса.Вставить("ibid", ИдентификаторИБ);
		ДанныеЗапроса.Вставить("clid", ИдентификаторКлиента);
		ДанныеЗапроса.Вставить("code", КодРегистрации);
		ДанныеЗапроса.Вставить("method_name", "FinishLocalRegistration");
		
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, ДанныеЗапроса);
		
		СтрокаЗапроса = ЗаписьJSON.Закрыть();
		
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
		Заголовки.Вставить("Accept", "application/json");
		
		Запрос = Новый HTTPЗапрос(ПутьНаСервере, Заголовки);
		Запрос.УстановитьТелоИзСтроки(СтрокаЗапроса);
		
		Ответ = Соединение.ОтправитьДляОбработки(Запрос);
		
		Если Ответ.КодСостояния <> 200 Тогда
			
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка %1'", ОбщегоНазначения.КодОсновногоЯзыка()), Строка(Ответ.КодСостояния));
			ЗафиксироватьОшибку(Результат, ТекстОшибки);
			Возврат Результат;
			
		КонецЕсли;
		
		ЧтениеJSON = Новый ЧтениеJSON;
		
		СтрокаТелаОтвета = Ответ.ПолучитьТелоКакСтроку();
		ЧтениеJSON.УстановитьСтроку(СтрокаТелаОтвета);
		
		Попытка
			ДанныеОтвета = ПрочитатьJSON(ЧтениеJSON, Ложь);	
		Исключение
			ЗафиксироватьОшибку(Результат, СтрокаТелаОтвета);
			Возврат Результат;
		КонецПопытки;
		
		Если Не ДанныеОтвета.success Тогда
			ЗафиксироватьОшибку(Результат, ДанныеОтвета.response_text);
			Возврат Результат;
		КонецЕсли;
		
		АдресИнформационногоЦентра = ДанныеОтвета.info_center_address;
		
		ПриУспешномВводеКодаРегистрации();
		
		Результат.Успешно = Истина;
		Возврат Результат;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ЗафиксироватьОшибку(Результат, 
			ИнформационныйЦентрСлужебный.ПодробныйТекстОшибки(ИнформацияОбОшибке), 
			ИнформационныйЦентрСлужебный.КраткийТекстОшибки(ИнформацияОбОшибке));
			
		Возврат Результат;
		
	КонецПопытки;
	
КонецФункции

&НаСервере
Процедура ЗафиксироватьОшибку(Результат, ПодробныйТекстОшибки, Знач КраткийТекстОшибки = "")
	
	Если Не ЗначениеЗаполнено(КраткийТекстОшибки) Тогда
		КраткийТекстОшибки = ПодробныйТекстОшибки;
	КонецЕсли;
	
	Результат.Успешно = Ложь;
	Результат.ТекстСообщения = КраткийТекстОшибки;
	
	ЗаписьЖурналаРегистрации(
		СтрШаблон("%1.%2", ИмяСобытияЖурналаРегистрации(), 
			НСтр("ru = 'Ввод кода регистрации'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробныйТекстОшибки);
				
	Результат.Успешно = Ложь;
	Результат.ТекстСообщения = КраткийТекстОшибки;
	
КонецПроцедуры

&НаСервере
Процедура ПриУспешномВводеКодаРегистрации()
	
	Элементы.ДекорацияУспешноеПодключение.Заголовок = СтрЗаменить(
		Элементы.ДекорацияУспешноеПодключение.Заголовок,
		"[Email]",
		Email);
	
	ИнформационныйЦентрСервер.ЗаписатьДанныеНастроекИнтеграцииСУСП(
		АдресУСП,
		Истина,
		Email,
		КодРегистрации,
		АдресИнформационногоЦентра);
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаУспешноеПодключение;
	
КонецПроцедуры

&НаСервере
Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
	
КонецФункции

&НаКлиенте
Процедура ОпределитьПоддерживаемыеБазыВФонеЗавершение(Операция, ДополнительныеПараметры) Экспорт
	
	Если Операция.Статус = "Выполнено" Тогда
		
		Результат = ПолучитьИзВременногоХранилища(Операция.АдресРезультата);
		
		Если Результат.Успешно Тогда
			Элементы.НадписьСостояниеПодключения.Заголовок = НСтр("ru='Подключено'");
			Элементы.ЗначокСостояниеПодключения.Картинка = БиблиотекаКартинок.ОформлениеЗнакФлажок;
			Элементы.ОтменитьПодключение.Доступность = Истина;
			Элементы.ПерейтиНаСтраницуЗапросаКодовПользователей.Доступность = Истина;
		Иначе
			Элементы.НадписьСостояниеПодключения.Заголовок = НСтр("ru='Ошибка подключения: '") + Результат.ТекстСообщения;
			Элементы.ЗначокСостояниеПодключения.Картинка = БиблиотекаКартинок.ОформлениеЗнакВоcклицательныйЗнак;
			Элементы.ПерейтиНаСтраницуЗапросаКодовПользователей.Доступность = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьСостояниеПодключенияВФонеОжидание()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ОпределитьПоддерживаемыеБазыВФонеЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ПараметрыЗадания, Обработчик, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПодключениеНаСервере()
	
	ИнформационныйЦентрСервер.ОчиститьДанныеНастроекИнтеграцииСУСП();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПодключениеПриПроверкеОтвета(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОтменитьПодключениеНаСервере();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеРасшифровкиТокена(Токен)
	
	Возврат ИнформационныйЦентрСервер.РасшифроватьТокенДляРегистрацииВСлужбеПоддержки(Токен);
	
КонецФункции

&НаСервере
Процедура ПерейтиНаСтраницуЗапросаКодовПользователейНаСервере()
	
	ЗаполнитьСписокПользователейИБ();
	Заголовок = НСтр("ru='Запросить коды пользователей'");
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапроситьКодПользователей;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователейИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПользователиКонтактнаяИнформация.Ссылка КАК Пользователь,
	|	МИНИМУМ(ПользователиКонтактнаяИнформация.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ ПользователиСНомерамиСтрокКИ
	|ИЗ
	|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	|ГДЕ
	|	НЕ ПользователиКонтактнаяИнформация.Ссылка.Недействителен
	|	И НЕ ПользователиКонтактнаяИнформация.Ссылка.Служебный
	|	И ПользователиКонтактнаяИнформация.АдресЭП <> """"
	|
	|СГРУППИРОВАТЬ ПО
	|	ПользователиКонтактнаяИнформация.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПользователиСНомерамиСтрокКИ.Пользователь КАК Пользователь,
	|	ПользователиКонтактнаяИнформация.АдресЭП КАК Email,
	|	ИСТИНА КАК ЗапроситьКод
	|ИЗ
	|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПользователиСНомерамиСтрокКИ КАК ПользователиСНомерамиСтрокКИ
	|		ПО ПользователиКонтактнаяИнформация.Ссылка = ПользователиСНомерамиСтрокКИ.Пользователь
	|			И (ПользователиСНомерамиСтрокКИ.НомерСтроки = ПользователиКонтактнаяИнформация.НомерСтроки)";
	
	ПользователиДляЗапросаКодов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСтраницуПолученияКодовПользователейСЗащитой(ИдентификаторЗапроса)
	
	ШаблонАдресаСтраницы = 
		"%1/v1/RequestLocalUserCodesContinue?rid=%2&register_code=%3&ibid=%4";
	СсылкаНаСтраницу = СтрШаблон(ШаблонАдресаСтраницы, 
		АдресУСП, ИдентификаторЗапроса, КодРегистрации, ИдентификаторИБ);
		
	#Если ВебКлиент Тогда
		ПерейтиПоНавигационнойСсылке(СсылкаНаСтраницу);
	#Иначе
		ЗапуститьПриложение(СсылкаНаСтраницу);
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ЗапроситьКодыПользователейНаСервере()
	
	ДанныеПользователей = Новый Массив;
	Для Каждого СтрокаПользователя Из ПользователиДляЗапросаКодов Цикл
		Если Не СтрокаПользователя.ЗапроситьКод Тогда
			Продолжить;
		КонецЕсли;
		ДанныеПользователей.Добавить(
			Новый Структура(
				"username, email",
				Строка(СтрокаПользователя.Пользователь),
				СтрокаПользователя.Email));
	КонецЦикла;
	
	РезультатЗапроса = ИнформационныйЦентрСервер.ЗапроситьКодыПользователей(ДанныеПользователей);
	
	Возврат РезультатЗапроса;
	
КонецФункции

&НаСервере
Функция ПроверкаПередОтправкойЗапросовКодов()
	
	Для Индекс = 0 По ПользователиДляЗапросаКодов.Количество() - 1 Цикл
		СтрокаПользователя = ПользователиДляЗапросаКодов[Индекс];
		Если Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(СтрокаПользователя.Email) Тогда
			ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Адрес электронной почты содержит ошибки'"),
			,
			"ПользователиДляЗапросаКодов["+Строка(Индекс)+"].Email");
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ПроверитьИВывестиОшибкиОтправкиПисем(АдресаНетПользователяУАбонента)
	
	Если АдресаНетПользователяУАбонента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонСообщения = 
		НСтр("ru='Пользователя с адресом %1 нет в базе службы поддержки, поэтому ему не отправлено письмо.'");
	
	Для Каждого Адрес Из АдресаНетПользователяУАбонента Цикл
		
		СтрокиПользователя = ПользователиДляЗапросаКодов.НайтиСтроки(Новый Структура("Email", Адрес));
		Если СтрокиПользователя.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПользователя = СтрокиПользователя[0];
		ИндексСтроки = ПользователиДляЗапросаКодов.Индекс(СтрокаПользователя);
		
		ТекстСообщения = СтрШаблон(ШаблонСообщения, Адрес);
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения, 
			, 
			"ПользователиДляЗапросаКодов["+Строка(ИндексСтроки)+"].Email");
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
