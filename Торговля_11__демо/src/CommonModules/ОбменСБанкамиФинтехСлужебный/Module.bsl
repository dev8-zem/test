
////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиФинтехСлужебный: обмен со Сбербанком через сервис fintech-integration.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Осуществляет получение ссылки для аутентификации в личном кабинете банка.
//
// Параметры:
//  Параметры - Структура - параметры выполнения, содержит поля:
//   * НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками - ссылка на настройку обмена, если она есть.
//   * ИдентификаторСессии - Строка - идентификатор текущей сессии 1С.
//  Адрес - Строка - адрес временного хранилища, содержащий структуру с полями:
//    * authorizationUrl - Строка - ссылка на договор оферты в личном кабинете банка.
//    * ТокенДоступа - Строка - токен доступа, полученный из сервиса Fintech Integration
//
Процедура ПолучитьСсылкуНаАутентификацию(Параметры, Адрес) Экспорт

	ПараметрыИнтернетПоддержки = ПараметрыИнтернетПоддержки();
	
	ЗаписьДанныхСообщения = НовыйJSON();
	
	scopes = Новый Массив;
	scopes.Добавить("GET_CLIENT_ACCOUNTS");
	scopes.Добавить("GET_STATEMENT_ACCOUNT");
	scopes.Добавить("PAY_DOC_RU");
	
	ДобавитьМассивJSON(ЗаписьДанныхСообщения, "scopes", scopes);
	ДобавитьПолеJSON(ЗаписьДанныхСообщения, "ticket", ПараметрыИнтернетПоддержки.Тикет);
	ДобавитьПолеJSON(ЗаписьДанныхСообщения, "userSessionId", Параметры.ИдентификаторСессии);
	
	СтрокаЗапроса =  СтрокаJSON(ЗаписьДанныхСообщения);

	АдресСервера = АдресFintechIntegration();
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	РезультатВыполнения = ОбменСБанкамиСлужебный.ОтправитьPOSTЗапрос(АдресСервера,
		"/sberbank/auth/v1/oauth/client-authorization/", Заголовки, СтрокаЗапроса, Истина, 30,
		Параметры.НастройкаОбмена);
	
	Если НЕ РезультатВыполнения.Статус Тогда
		СообщениеОбОшибке = РезультатВыполнения.СообщениеОбОшибке;
		Если ЗначениеЗаполнено(РезультатВыполнения.КодСостояния) Тогда
			Шаблон = НСтр("ru = 'При подключении к сервису Fintech Integration произошла ошибка.
								|Код ошибки: %1
								|Сообщение об ошибке %2
								|Тело ответа: %3'");
			ТекстОшибки = СтрШаблон(Шаблон, РезультатВыполнения.КодСостояния, СообщениеОбОшибке, РезультатВыполнения.Тело);
			Операция = НСтр("ru = 'Подключение к сервису Fintech Integration'");
			ТекстСообщения = ДетальноеСообщениеИзТекстаОшибки(
				РезультатВыполнения.Тело, РезультатВыполнения.КодСостояния);
			СообщениеОбОшибке = СформироватьДетальныйТекстСообщения(ТекстСообщения, СообщениеОбОшибке);
			ОбработатьОшибку(Операция, ТекстОшибки, ТекстСообщения, Параметры.НастройкаОбмена);
		КонецЕсли;
		
		ВызватьИсключение СообщениеОбОшибке;
	КонецЕсли;
	
	ПараметрыОтвета = ОбменСБанкамиСлужебный.ДанныеИзJSON(РезультатВыполнения.Тело);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("authorizationUrl", ПараметрыОтвета.authorizationUrl);
	СтруктураВозврата.Вставить("ТокенДоступа", ПараметрыОтвета.serviceUserToken.serviceUserTicket);
	ПоместитьВоВременноеХранилище(СтруктураВозврата, Адрес);
	
КонецПроцедуры

// Проверяет, прошел ли пользователь аутентификацию в личном кабинете банка по предоставленной ссылке.
//
// Параметры:
//  Параметры - Структура - параметры выполнения, содержит поля:
//   * НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками - ссылка на настройку обмена, если она есть.
//   * ИдентификаторСессии - Строка - идентификатор сессии 1С
//   * ТокенДоступа - Строка - токен, полученный из сервиса Fintech Integration
//  Адрес - Строка - адрес временного хранилища, содержащий структуру с полями:
//   * status - Строка - статус подключения
//
Процедура ПроверитьВыполнениеАутентификацииВЛичномКабинете(Параметры, Адрес) Экспорт
	
	ТокенАутентификации = Параметры.ИдентификаторСессии + ":" + Параметры.ТокенДоступа;
	ТокенАутентификацииBase64 = ОбменСБанкамиСлужебныйВызовСервера.СтрокаBase64БезBOM(ТокенАутентификации, , Истина);
	
	АдресСервера = АдресFintechIntegration() + "/sberbank/auth/v1/oauth/client-authorization/status";
	
	ПараметрыЖурналирования = ОбменСБанкамиСлужебныйВызовСервера.ПараметрыЖурналирования(Параметры.НастройкаОбмена);

	СтруктураЖурналирования = Неопределено;
	Если ПараметрыЖурналирования.ИспользоватьЖурналирование Тогда
		СтруктураЖурналирования = Новый Структура;
		СтруктураЖурналирования.Вставить("ОбщийМодуль", ОбщегоНазначения.ОбщийМодуль("ОбменСБанкамиСлужебный"));
		СтруктураЖурналирования.Вставить("НастройкаОбмена", Параметры.НастройкаОбмена);
	КонецЕсли;

	ПараметрыПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла();
	ПараметрыПолучения.Таймаут = 15;
	ПараметрыПолучения.Заголовки.Вставить("X-Auth-Token", ТокенАутентификацииBase64);
	
	Результат = ИнтернетСоединениеБЭД.СкачатьФайлВоВременноеХранилище(
		АдресСервера, ПараметрыПолучения, СтруктураЖурналирования);

	Если Не Результат.Статус Тогда
		Если ЗначениеЗаполнено(Результат.КодСостояния) Тогда
			Шаблон = НСтр("ru = 'При проверке статуса подключения сервиса Fintech Integration произошла ошибка.
								|Код ошибки: %1.
								|%2'");
			ТекстОшибки = СтрШаблон(Шаблон, Результат.КодСостояния, Результат.СообщениеОбОшибке);
		Иначе
			ТекстОшибки = Результат.СообщениеОбОшибке;
		КонецЕсли;
		ВидОперации = НСтр("ru = 'Получение статуса подключения.'");
		ОбработатьОшибку(ВидОперации, ТекстОшибки, , Параметры.НастройкаОбмена);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ДвоичныеДанныеТела = ПолучитьИзВременногоХранилища(Результат.Путь);
	
	ПотокВПамяти = ДвоичныеДанныеТела.ОткрытьПотокДляЧтения();
	ЧтениеДанных = Новый ЧтениеДанных(ПотокВПамяти, КодировкаТекста.UTF8);
	СтрокаJSON = ЧтениеДанных.ПрочитатьСтроку();
	
	ПараметрыОтвета = ОбменСБанкамиСлужебный.ДанныеИзJSON(СтрокаJSON);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("status", ПараметрыОтвета.status);
	ПоместитьВоВременноеХранилище(СтруктураВозврата, Адрес);
	
КонецПроцедуры

// Проверяет, соответствуют ли запрашиваемые данные доступным на сервере.
//
// Параметры:
//  Параметры - Структура - параметры выполнения, содержит поля:
//   * НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками - ссылка на настройку обмена, если она есть.
//   * Организация - ОпределяемыйТип.Организация - ссылка на организацию
//   * Банк - ОпределяемыйТип.БанкОбменСБанками - ссылка на банк.
//   * НомерСчета - Строка - номер счета, к которому нужен доступ.
//  Адрес - Строка - адрес временного хранилища, содержащий структуру с полями:
//   * Результат - Булево - если Истина, то есть доступ к требуемым данным.
//   * ДоступныеСчета - Массив из Строка - номера счетов, к которым есть доступ.
//
Процедура ПроверитьНаличиеДоступаКДанным(Параметры, Адрес) Экспорт
	
	ТокенАутентификации = Параметры.ИдентификаторСессии + ":" + Параметры.ТокенДоступа;
	ТокенАутентификацииBase64 = ОбменСБанкамиСлужебныйВызовСервера.СтрокаBase64БезBOM(ТокенАутентификации, , Истина);
	
	АдресСервера = АдресFintechIntegration();
	
	ЗаписьДанныхСообщения = НовыйJSON();
	
	ДобавитьПолеJSON(ЗаписьДанныхСообщения, "httpMethod", "GET");
	ДобавитьПолеJSON(ЗаписьДанныхСообщения, "httpPath", "/client-info");
	
	СтрокаЗапроса = СтрокаJSON(ЗаписьДанныхСообщения);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Auth-Token", ТокенАутентификацииBase64);
	
	РезультатВыполнения = ОбменСБанкамиСлужебный.ОтправитьPOSTЗапрос(АдресСервера, "/sberbank/business/v1/operations/",
		Заголовки, СтрокаЗапроса, Истина, , Параметры.НастройкаОбмена);
	
	Если НЕ РезультатВыполнения.Статус Тогда
		Если ЗначениеЗаполнено(РезультатВыполнения.КодСостояния) Тогда
			Шаблон = НСтр("ru = 'При получении данных об организации через сервис Fintech Integration произошла ошибка.
								|Код ошибки: %1
								|Сообщение об ошибке %2
								|Тело ответа: %3'");
			ТекстОшибки = СтрШаблон(Шаблон, РезультатВыполнения.КодСостояния, РезультатВыполнения.СообщениеОбОшибке,
				РезультатВыполнения.Тело);
			Операция = НСтр("ru = 'Получение данных через сервис Fintech Integration'");
			ОбработатьОшибку(Операция, ТекстОшибки, , Параметры.НастройкаОбмена);
		КонецЕсли;
		ВызватьИсключение РезультатВыполнения.СообщениеОбОшибке;
	КонецЕсли;
	
	ПараметрыОтвета = ОбменСБанкамиСлужебный.ДанныеИзJSON(РезультатВыполнения.Тело);
	
	Результат = РезультатПроверкиДоступаКДанным(
		ПараметрыОтвета, Параметры.Организация, Параметры.Банк, Параметры.НомерСчета);
	
	ПоместитьВоВременноеХранилище(Результат, Адрес);
	
КонецПроцедуры

// Получает из банка выписки за период по дням
//
// Параметры:
//   НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками - ссылка на настройку обмена, если она есть.
//   ТокенАутентификации - Строка - токен аутентификации в сервисе Fintech Integration
//   НомерСчета - Строка - номер счета
//   ДатаНачала - Дата - дата начала периода запроса выписки
//   ДатаОкончания - Дата - дата окончания периода запроса выписки
//   ДанныеВыписок - Соответствие - данные выписок по дням:
//    * Ключ - Дата - дата выписки
//    * Значение - Строка - данные выписки в формате JSON
//   ТребуетсяАутентификация - Булево - если Истина, то закончилось время жизни сессии
//   									  и нужно заново пройти процесс аутентификации.
//
Процедура ПолучитьВыписку(НастройкаОбмена,
						  ТокенАутентификации,
						  НомерСчета,
						  ДатаНачала,
						  ДатаОкончания,
						  ДанныеВыписок,
						  ТребуетсяАутентификация) Экспорт
	
	ТребуетсяАутентификация = Ложь;
	ДанныеВыписок = Новый Соответствие;
	
	Пока ДатаНачала <= ДатаОкончания Цикл
	
		ПолнаяВыписка = Неопределено;
		ПолучитьИтогиПоВыписке(
			НастройкаОбмена, ТокенАутентификации, НомерСчета, ДатаНачала, ПолнаяВыписка, ТребуетсяАутентификация);
			
		Если ТребуетсяАутентификация Тогда
			Возврат;
		КонецЕсли;
		
		Если ПолнаяВыписка = Неопределено Тогда
			Продолжить; // выписка формируется на стороне банка
		КонецЕсли;
		
		ВыпискиНет = Ложь;
		Операции = Новый Массив;
		ПолучитьОперацииЗаДень(
			НастройкаОбмена, ТокенАутентификации, НомерСчета, ДатаНачала, Операции, ТребуетсяАутентификация, ВыпискиНет);
		
		Если ТребуетсяАутентификация Тогда
			Возврат;
		КонецЕсли;
		
		Если ВыпискиНет Тогда
			ДатаНачала = ДатаНачала + 60 * 60 * 24; // добавить день
			Продолжить;
		КонецЕсли;
		
		ПолнаяВыписка.Вставить("transactions", Новый Массив);
		
		Для Каждого Операция Из Операции Цикл
			ПолнаяВыписка.transactions.Добавить(Операция);
		КонецЦикла;
		
		ДанныеВыписок.Вставить(ДатаНачала, ОбменСБанкамиСлужебный.ЗначениеВJSON(ПолнаяВыписка));
		
		ДатаНачала = ДатаНачала + 60 * 60 * 24; // добавить день
		
	КонецЦикла;

КонецПроцедуры

// Получает из банка выписки за период по дням
//
// Параметры:
//   НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками - ссылка на настройку обмена, если она есть.
//   ТокенАутентификацииBase64 - Строка - токен аутентификации в сервисе Fintech
//   ИдентификаторДокумента - Строка - идентификатор платежного документа
//   Результат - Структура - данные, полученные из сервиса Fintech.
//   ТребуетсяАутентификация - Булево - если Истина, то необходимо пройти процесс аутентификации.
//
Процедура ПолучитьСтатусДокумента(НастройкаОбмена,
								  ТокенАутентификацииBase64,
								  ИдентификаторДокумента,
								  Результат,
								  ТребуетсяАутентификация) Экспорт
	
	АдресСервера = АдресFintechIntegration();
	
	ЗаписьДанныхСообщения = НовыйJSON();
	
	ДобавитьПолеJSON(ЗаписьДанныхСообщения, "httpMethod", "GET");
	ДобавитьПолеJSON(ЗаписьДанныхСообщения, "httpPath", "/payments/" + ИдентификаторДокумента + "/state");
	
	СтрокаЗапроса = СтрокаJSON(ЗаписьДанныхСообщения);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Auth-Token", ТокенАутентификацииBase64);
	
	РезультатВыполнения = ОбменСБанкамиСлужебный.ОтправитьPOSTЗапрос(АдресСервера, "/sberbank/business/v1/operations/",
		Заголовки, СтрокаЗапроса, Истина, , НастройкаОбмена);
	
	Если НЕ РезультатВыполнения.Статус Тогда
		СообщениеОбОшибке = РезультатВыполнения.СообщениеОбОшибке;
		Если ЗначениеЗаполнено(РезультатВыполнения.КодСостояния) Тогда
			Если РезультатВыполнения.КодСостояния = 401 Тогда
				ПолученныеДанные = ОбменСБанкамиСлужебный.ДанныеИзJSON(РезультатВыполнения.Тело);
				Если ПолученныеДанные.Свойство("code") И ПолученныеДанные.code = "AUTH_TOKEN_IS_EXPIRED" Тогда
					ТребуетсяАутентификация = Истина;
					Возврат;
				КонецЕсли;
			КонецЕсли;
			
			Шаблон = НСтр("ru = 'При получении состояния документа через сервис Fintech Integration произошла ошибка.
								|Код ошибки: %1
								|Сообщение об ошибке: %2
								|Тело ответа: %3'");
			ТекстОшибки = СтрШаблон(Шаблон, РезультатВыполнения.КодСостояния, СообщениеОбОшибке, РезультатВыполнения.Тело);
			Операция = НСтр("ru = 'Получение данных через сервис Fintech Integration'");
			ТекстСообщения = ДетальноеСообщениеИзТекстаОшибки(
				РезультатВыполнения.Тело, РезультатВыполнения.КодСостояния);
			СообщениеОбОшибке = СформироватьДетальныйТекстСообщения(ТекстСообщения, СообщениеОбОшибке);
			ОбработатьОшибку(Операция, ТекстОшибки, ТекстСообщения, НастройкаОбмена);
		КонецЕсли;
		
		ВызватьИсключение СообщениеОбОшибке;
	КонецЕсли;
	
	Результат = ОбменСБанкамиСлужебный.ДанныеИзJSON(РезультатВыполнения.Тело);
	
КонецПроцедуры

// Отправляет в банк платежный документ.
// 
// Параметры:
// 	НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками - текущая настройка обмена с банком.
// 	ТокенАутентификацииBase64 - Строка - токен аутентификации на сервисе FintechAPI
// 	ДанныеЭД - ДвоичныеДанные - двоичные данные платежного поручения
// 	ОтветБанка - Структура - данные ответа из JSON
//	ТребуетсяАутентификация - Булево - если Истина, то требуется повторная аутентификация.
Процедура ОтправитьПлатежныйДокумент(НастройкаОбмена,
									 ТокенАутентификацииBase64,
									 ДанныеЭД,
									 ОтветБанка,
									 ТребуетсяАутентификация) Экспорт
	
	АдресСервера = АдресFintechIntegration();
	Путь = "/payments";
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Auth-Token", ТокенАутентификацииBase64);
	
	ДанныеСтрокой = ОбменСБанкамиСлужебныйВызовСервера.СтрокаИзДвоичныхДанных(ДанныеЭД);
	
	Тело = Новый Структура;
	Тело.Вставить("httpMethod", "POST");
	Тело.Вставить("httpPath", Путь);
	Тело.Вставить("httpBody", ОбменСБанкамиСлужебный.ДанныеИзJSON(ДанныеСтрокой));
	
	СтрокаЗапроса = ОбменСБанкамиСлужебный.ЗначениеВJSON(Тело);
		
	РезультатВыполнения = ОбменСБанкамиСлужебный.ОтправитьPOSTЗапрос(АдресСервера,
		"/sberbank/business/v1/operations/", Заголовки, СтрокаЗапроса, Истина, , НастройкаОбмена);

	Если НЕ РезультатВыполнения.Статус И РезультатВыполнения.КодСостояния <> 201 Тогда
		СообщениеОбОшибке = РезультатВыполнения.СообщениеОбОшибке;
		Если РезультатВыполнения.КодСостояния = 401 Тогда
			ПолученныеДанные = ОбменСБанкамиСлужебный.ДанныеИзJSON(РезультатВыполнения.Тело);
			Если ПолученныеДанные.Свойство("code") И ПолученныеДанные.code = "AUTH_TOKEN_IS_EXPIRED" Тогда
				ТребуетсяАутентификация = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатВыполнения.КодСостояния) Тогда
			Шаблон = НСтр("ru = 'При отправке платежного поручения произошла ошибка.
								|Код ошибки: %1
								|Сообщение об ошибке %2
								|Тело ответа: %3'");
			ТекстОшибки = СтрШаблон(Шаблон, РезультатВыполнения.КодСостояния, СообщениеОбОшибке, РезультатВыполнения.Тело);
			Операция = НСтр("ru = 'Отправка платежного поручения через сервис Fintech Integration'");
			ТекстСообщения = ДетальноеСообщениеИзТекстаОшибки(
				РезультатВыполнения.Тело, РезультатВыполнения.КодСостояния);
			СообщениеОбОшибке = СформироватьДетальныйТекстСообщения(ТекстСообщения, СообщениеОбОшибке);
			ОбработатьОшибку(Операция, ТекстОшибки, ТекстСообщения, НастройкаОбмена);
		КонецЕсли;
		
		ВызватьИсключение СообщениеОбОшибке;
	КонецЕсли;
	
	ОтветБанка = ОбменСБанкамиСлужебный.ДанныеИзJSON(РезультатВыполнения.Тело);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьДетальныйТекстСообщения(ТекстСообщения, Знач СообщениеОбОшибке)
	
	Результат = СообщениеОбОшибке;
	
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		Результат = Результат + ОбменСБанкамиСлужебныйКлиентСервер.ТекстСлужебногоМаркераВЖР();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция КодЗапрашиваемыйРесурсНеНайденНаСервере()
	
	Возврат 404;
	
КонецФункции

Функция ОбрабатываемыКоды()
	
	Результат = Новый Соответствие;
	Результат.Вставить(400, НСтр("ru = 'Запрос не может быть исполнен'"));
	Результат.Вставить(КодЗапрашиваемыйРесурсНеНайденНаСервере(),
		НСтр("ru = 'Запрашиваемый ресурс не найден на сервере'"));
	
	Возврат Результат;
	
КонецФункции

Функция ДетальноеСообщениеИзТекстаОшибки(Знач ТекстОшибки, КодСостояния)
	
	ТекстСообщения = "";
	
	// Детальное описание ошибки получаем только для определенных кодов сервера.
	ОбрабатываемыКоды = ОбрабатываемыКоды();
	
	Если Не ЗначениеЗаполнено(ОбрабатываемыКоды[КодСостояния]) Тогда
		Возврат ТекстСообщения;
	КонецЕсли;
	
	ОтветБанка = ОбменСБанкамиСлужебный.ДанныеИзJSON(ТекстОшибки);
	
	ДанныеСообщения = Новый Массив;
	ПоложитьДетальноеСообщениеВТестОтвета(ДанныеСообщения, ОтветБанка);
	Если ОтветБанка.Свойство("details") И ТипЗнч(ОтветБанка.details) = Тип("Массив") Тогда
		Для Каждого Детали Из ОтветБанка.details Цикл
			ПоложитьДетальноеСообщениеВТестОтвета(ДанныеСообщения, Детали);
		КонецЦикла;
	КонецЕсли;
	
	ТекстСообщения = СтрСоединить(ДанныеСообщения, ". ");
	
	Возврат ТекстСообщения;
	
КонецФункции

Процедура ПоложитьДетальноеСообщениеВТестОтвета(ДанныеСообщения, Данные)
	
	ТекстПоля = "";
	Если Данные.Свойство("fields") И ТипЗнч(Данные.fields) = Тип("Массив") Тогда
		Поля = Новый Массив;
		Для Каждого Поле Из Данные.fields Цикл
			Поля.Добавить(СокрЛП(Поле));
		КонецЦикла;
		
		Если Поля.Количество() > 0 Тогда
			ТекстПоля = СтрСоединить(Поля, " ,") + ":";
		КонецЕсли;
	КонецЕсли;
	
	Если Данные.Свойство("message") И ЗначениеЗаполнено(Данные.message) Тогда
		ДанныеСообщения.Добавить(ТекстПоля + СокрЛП(Данные.message));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьИтогиПоВыписке(НастройкаОбмена,
								 ТокенАутентификацииBase64,
								 НомерСчета,
								 Дата,
								 Итоги,
								 ТребуетсяАутентификация)
	
	АдресСервера = АдресFintechIntegration();
	Путь = "/statement/summary?accountNumber=" + НомерСчета + "&statementDate=" + Формат(Дата, "ДФ=yyyy-MM-dd");
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Auth-Token", ТокенАутентификацииBase64);
	
	ЗаписьДанныхСообщения = НовыйJSON();
	
	ДобавитьПолеJSON(ЗаписьДанныхСообщения, "httpMethod", "GET");
	ДобавитьПолеJSON(ЗаписьДанныхСообщения, "httpPath", Путь);
	
	СтрокаЗапроса = СтрокаJSON(ЗаписьДанныхСообщения);
	
	РезультатВыполнения = ОбменСБанкамиСлужебный.ОтправитьPOSTЗапрос(АдресСервера,
		"/sberbank/business/v1/operations/", Заголовки, СтрокаЗапроса, Истина, , НастройкаОбмена);
	
	Если НЕ РезультатВыполнения.Статус Тогда
		ТребуетсяВызватьИсключение = Истина;
		СообщениеОбОшибке = РезультатВыполнения.СообщениеОбОшибке;
		Если ЗначениеЗаполнено(РезультатВыполнения.КодСостояния) Тогда
			Если РезультатВыполнения.КодСостояния = 401 Тогда
				ПолученныеДанные = ОбменСБанкамиСлужебный.ДанныеИзJSON(РезультатВыполнения.Тело);
				Если ПолученныеДанные.Свойство("code") И ПолученныеДанные.code = "AUTH_TOKEN_IS_EXPIRED" Тогда
					ТребуетсяАутентификация = Истина;
					Возврат;
				КонецЕсли;
			КонецЕсли;
			Если РезультатВыполнения.КодСостояния = 202 Тогда
				Возврат; // выписка формируется на стороне банка.
			Иначе
				Шаблон = НСтр("ru = 'При получении итогов по выписке произошла ошибка.
									|Код ошибки: %1
									|Сообщение об ошибке %2
									|Тело ответа: %3'");
				ТекстОшибки = СтрШаблон(Шаблон, РезультатВыполнения.КодСостояния, СообщениеОбОшибке, РезультатВыполнения.Тело);
				Операция = НСтр("ru = 'Получение выписки через сервис Fintech Integration'");
				Если РезультатВыполнения.КодСостояния = КодЗапрашиваемыйРесурсНеНайденНаСервере() Тогда
					// Отдельно обрабатываем код отсутствия сформированной выписки за день.
					// Чтобы не прерывать загрузку выписки за другие дни периода,
					// выводим сообщение об ошибке, а не вызываем исключение.
					// Но т.к. сообщение будет выведено еще и в ПолучитьСтраницуВыписки(), тут его не выводим.
					ТекстСообщения = "";
					ТребуетсяВызватьИсключение = Ложь;
				Иначе
					ТекстСообщения = ДетальноеСообщениеИзТекстаОшибки(
						РезультатВыполнения.Тело, РезультатВыполнения.КодСостояния);
				КонецЕсли;
				
				СообщениеОбОшибке = СформироватьДетальныйТекстСообщения(ТекстСообщения, СообщениеОбОшибке);
				ОбработатьОшибку(Операция, ТекстОшибки, ТекстСообщения, НастройкаОбмена);
			КонецЕсли;
		КонецЕсли;
		
		Если ТребуетсяВызватьИсключение Тогда
			ВызватьИсключение СообщениеОбОшибке;
		КонецЕсли;
	КонецЕсли;
	
	Итоги = ОбменСБанкамиСлужебный.ДанныеИзJSON(РезультатВыполнения.Тело);
	
КонецПроцедуры

Процедура ПолучитьОперацииЗаДень(НастройкаОбмена,
								 ТокенАутентификацииBase64,
								 НомерСчета,
								 Дата,
								 Операции,
								 ТребуетсяАутентификация,
								 ВыпискиНет)
	
	ПараметрыЗапроса = Новый Структура("Дата, href");
	ПараметрыЗапроса.Дата = Дата;
	ПараметрыЗапроса.href =
		"?accountNumber=" + НомерСчета + "&statementDate=" + Формат(Дата, "ДФ=yyyy-MM-dd") + "&page=1";
	
	ВыпискаПолностьюПолучена = Ложь;
	
	Пока НЕ ВыпискаПолностьюПолучена Цикл
		
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("Content-Type", "application/json");
		Заголовки.Вставить("X-Auth-Token", ТокенАутентификацииBase64);
		
		Страница = Неопределено;
		ПолучитьСтраницуВыписки(НастройкаОбмена, Заголовки, ПараметрыЗапроса, Страница, ТребуетсяАутентификация, ВыпискиНет);
		Если ТребуетсяАутентификация Или ВыпискиНет Тогда
			Возврат;
		КонецЕсли;
		
		ЕстьСледующаяСтраница = Ложь;
		Если Страница.Свойство("cause") И Страница.cause = "STATEMENT_RESPONSE_PROCESSING" Тогда
			// Выписка еще не сформирована
			Продолжить;
		ИначеЕсли Страница._links.Количество() Тогда
			Для Каждого Элемент Из Страница._links Цикл
				Если Элемент.rel = "next" Тогда
					ЕстьСледующаяСтраница = Истина;
					ПараметрыЗапроса.href = Элемент.href;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если Не ЕстьСледующаяСтраница Тогда
				ВыпискаПолностьюПолучена = Истина;
			КонецЕсли;
		Иначе
			ВыпискаПолностьюПолучена = Истина;
		КонецЕсли;
		
		Для Каждого Операция Из Страница.transactions Цикл
			Операции.Добавить(Операция);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПолучитьСтраницуВыписки(НастройкаОбмена,
								  Заголовки,
								  ПараметрыЗапроса,
								  Страница,
								  ТребуетсяАутентификация,
								  ВыпискиНет)
	
	АдресСервера = АдресFintechIntegration();
	ЗаписьДанныхСообщения = НовыйJSON();
	
	ДобавитьПолеJSON(ЗаписьДанныхСообщения, "httpMethod", "GET");
	ДобавитьПолеJSON(ЗаписьДанныхСообщения, "httpPath", "/statement/transactions" + ПараметрыЗапроса.href);
	
	СтрокаЗапроса = СтрокаJSON(ЗаписьДанныхСообщения);
	
	РезультатВыполнения = ОбменСБанкамиСлужебный.ОтправитьPOSTЗапрос(АдресСервера,
		"/sberbank/business/v1/operations/", Заголовки, СтрокаЗапроса, Истина, , НастройкаОбмена);
	
	Если НЕ РезультатВыполнения.Статус Тогда
		СообщениеОбОшибке = РезультатВыполнения.СообщениеОбОшибке;
		Если ЗначениеЗаполнено(РезультатВыполнения.КодСостояния) Тогда
			Если РезультатВыполнения.КодСостояния = 401 Тогда
				ПолученныеДанные = ОбменСБанкамиСлужебный.ДанныеИзJSON(РезультатВыполнения.Тело);
				Если ПолученныеДанные.Свойство("code") И ПолученныеДанные.code = "AUTH_TOKEN_IS_EXPIRED" Тогда
					ТребуетсяАутентификация = Истина;
					Возврат;
				КонецЕсли;
			КонецЕсли;
			Шаблон = НСтр("ru = 'При получении выписки произошла ошибка.
								|Код ошибки: %1
								|Сообщение об ошибке %2
								|Тело ответа: %3'");
			ТекстОшибки = СтрШаблон(Шаблон, РезультатВыполнения.КодСостояния, СообщениеОбОшибке, РезультатВыполнения.Тело);
			Операция = НСтр("ru = 'Получение выписки через сервис Fintech Integration'");
			Если РезультатВыполнения.КодСостояния = КодЗапрашиваемыйРесурсНеНайденНаСервере() Тогда
				// Отдельно обрабатываем код отсутствия сформированной выписки за день.
				// Чтобы не прерывать загрузку выписки за другие дни периода,
				// выводим сообщение об ошибке, а не вызываем исключение.
				ШаблонСообщения =
					НСтр("ru = 'Выписка за %1 недоступна, пожалуйста, обратитесь в техническую поддержку банка'");
				ТекстСообщения = СтрШаблон(ШаблонСообщения, Формат(ПараметрыЗапроса.Дата, "ДЛФ=D"));
				ВыпискиНет = Истина;
			Иначе
				ТекстСообщения = ДетальноеСообщениеИзТекстаОшибки(
					РезультатВыполнения.Тело, РезультатВыполнения.КодСостояния);
			КонецЕсли;
			
			СообщениеОбОшибке = СформироватьДетальныйТекстСообщения(ТекстСообщения, СообщениеОбОшибке);
			ОбработатьОшибку(Операция, ТекстОшибки, ТекстСообщения, НастройкаОбмена);
		КонецЕсли;
		
		Если Не ВыпискиНет Тогда
			ВызватьИсключение СообщениеОбОшибке;
		КонецЕсли;
	КонецЕсли;
	
	Страница = ОбменСБанкамиСлужебный.ДанныеИзJSON(РезультатВыполнения.Тело);
	
КонецПроцедуры

Процедура ОбработатьОшибку(Операция, ТекстОшибки, ТекстСообщения = "", СсылкаОбъект = Неопределено)
	
	ЭлектронноеВзаимодействие.ОбработатьОшибку(
		Операция, ТекстОшибки, ТекстСообщения, "ОбменСБанками", СсылкаОбъект);
	
КонецПроцедуры

Функция АдресFintechIntegration()
	
	Возврат "https://fintech-integration.1c.ru/api";
	
КонецФункции

Функция ПараметрыИнтернетПоддержки()

	УстановитьПривилегированныйРежим(Истина);
	Результат = ИнтернетПоддержкаПользователей.ТикетАутентификацииНаПорталеПоддержки("DirectBank");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(Результат.КодОшибки) Тогда
		Если Результат.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
			ТекстСообщения = НСтр("ru = 'Неверный логин или пароль'");
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
		ВидОперации = НСтр("ru = 'Аутентификация на портале поддержки 1С'");
		ЭлектронноеВзаимодействие.ОбработатьОшибку(
			ВидОперации, Результат.ИнформацияОбОшибке, , "ОбменСБанками");
		
		ВызватьИсключение Результат.СообщениеОбОшибке;
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура("Тикет", Результат.Тикет);
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция РезультатПроверкиДоступаКДанным(ПараметрыОтвета, Организация, Банк, НомерСчета)
	
	ВозвращаемоеЗначение = Новый Структура("Успех", Ложь);
	
	ДоступныеСчета = Новый Массив;
	
	Для Каждого Элемент Из ПараметрыОтвета.accounts Цикл
		ДоступныеСчета.Добавить(Элемент.number)
	КонецЦикла;
	
	ВозвращаемоеЗначение.Вставить("ДоступныеСчета", ДоступныеСчета);
	
	Если ЗначениеЗаполнено(НомерСчета) Тогда
		ВозвращаемоеЗначение.Успех = ДоступныеСчета.Найти(НомерСчета) <> Неопределено;
	Иначе
		БИК = ОбменСБанкамиСлужебный.БИК(Банк);
		РеквизитИНН = ОбменСБанкамиСлужебный.ИмяПрикладногоРеквизита("ИННОрганизации");
		ИНН = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, РеквизитИНН);
		ЕстьДоступ = Ложь;
		Для Каждого Элемент Из ПараметрыОтвета.accounts Цикл
			БИКСовпадает = Ложь; ИННСовпадает = Ложь; ЕстьБИК = Ложь; ЕстьИНН = Ложь;
			Если Элемент.Свойство("bic") И ЗначениеЗаполнено(Элемент.bic) Тогда
				ЕстьБИК = Истина;
				Если БИК = Элемент.bic Тогда
					БИКСовпадает = Истина;
				КонецЕсли;
			КонецЕсли;
			Если Элемент.Свойство("inn") И ЗначениеЗаполнено(Элемент.inn) Тогда
				ЕстьИНН = Истина;
				Если ИНН = Элемент.inn Тогда
					ИННСовпадает = Истина;
				КонецЕсли;
			КонецЕсли;
			Если (БИКСовпадает И ИННСовпадает) ИЛИ (НЕ ЕстьБИК И НЕ ЕстьИНН)
				ИЛИ (НЕ ЕстьИНН И БИКСовпадает) ИЛИ (НЕ ЕстьБИК И ИННСовпадает) Тогда
					ЕстьДоступ = Истина;
					Прервать;
			КонецЕсли;
		КонецЦикла;
		ВозвращаемоеЗначение.Успех = ЕстьДоступ И ЗначениеЗаполнено(ДоступныеСчета);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение
	
КонецФункции

#Область JSON

Функция СтрокаJSON(ЗаписьДанныхСообщения)
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	Возврат ЗаписьДанныхСообщения.Закрыть();
	
КонецФункции

Процедура ДобавитьПолеJSON(ЗаписьДанныхСообщения, Наименование, Значение)
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства(Наименование);
	ЗаписьДанныхСообщения.ЗаписатьЗначение(Значение);
	
КонецПроцедуры

Процедура ДобавитьМассивJSON(ЗаписьДанныхСообщения, Наименование, Значение)
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства(Наименование);
	ЗаписьДанныхСообщения.ЗаписатьНачалоМассива();
	Для Каждого Элемент Из Значение Цикл
		ЗаписьДанныхСообщения.ЗаписатьЗначение(Элемент);
	КонецЦикла;
	ЗаписьДанныхСообщения.ЗаписатьКонецМассива();
	
КонецПроцедуры

Функция НовыйJSON()
	
	ЗаписьДанныхСообщения = Новый ЗаписьJSON;
	ЗаписьДанныхСообщения.УстановитьСтроку();
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	Возврат ЗаписьДанныхСообщения;
	
КонецФункции

#КонецОбласти

#КонецОбласти
