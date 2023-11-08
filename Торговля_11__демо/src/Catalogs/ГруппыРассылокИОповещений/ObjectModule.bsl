
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ПредназначенаДляЭлектронныхПисем И Не ПредназначенаДляSMS Тогда
		
		ТекстОшибки = НСтр("ru = 'Не указан ни один вид доставки сообщений.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ПредназначенаДляЭлектронныхПисем",
			,
			Отказ);
		
	КонецЕсли;
	
	Если Не ПредназначенаДляЭлектронныхПисем Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("УчетнаяЗапись");
		МассивНепроверяемыхРеквизитов.Добавить("ВидКонтактнойИнформацииПартнераДляПисем");
		МассивНепроверяемыхРеквизитов.Добавить("ВидКонтактнойИнформацииКонтактногоЛицаДляПисем");
		
	КонецЕсли;
	
	Если Не ПредназначенаДляSMS Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидКонтактнойИнформацииПартнераДляSMS");
		МассивНепроверяемыхРеквизитов.Добавить("ВидКонтактнойИнформацииКонтактногоЛицаДляSMS");
		
	КонецЕсли;
	
	Если Принудительная И Не ОтправлятьПартнеру Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидКонтактнойИнформацииПартнераДляПисем");
		МассивНепроверяемыхРеквизитов.Добавить("ВидКонтактнойИнформацииПартнераДляSMS");
		
	КонецЕсли;
	
	Если Принудительная И (Не ОтправлятьКонтактнымЛицамРоли) И (Не ОтправлятьКонтактномуЛицуОбъектаОповещения) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидКонтактнойИнформацииКонтактногоЛицаДляПисем");
		МассивНепроверяемыхРеквизитов.Добавить("ВидКонтактнойИнформацииКонтактногоЛицаДляSMS");
		
	КонецЕсли;
	
	Если Не ОтправлятьКонтактнымЛицамРоли Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РольКонтактногоЛица");
		
	КонецЕсли;
	
	Если Принудительная Тогда
		
		Если Не ОтправлятьПартнеру 
			 И Не ОтправлятьКонтактномуЛицуОбъектаОповещения 
			 И Не ОтправлятьКонтактнымЛицамРоли Тогда
			
			ТекстОшибки = НСтр("ru = 'Необходимо указать хотя бы один вид адресатов.'");
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"ОтправлятьПартнеру",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не Принудительная Тогда
		
		ОтправлятьПартнеру                         = Ложь;
		ОтправлятьКонтактномуЛицуОбъектаОповещения = Ложь;
		ОтправлятьКонтактнымЛицамРоли              = Ложь;
		
	КонецЕсли;
	
	Если Не ОтправлятьКонтактнымЛицамРоли Тогда
		РольКонтактногоЛица = Справочники.РолиКонтактныхЛицПартнеров.ПустаяСсылка();
	КонецЕсли;
	
	ТребуетсяУказаниеКИПартнера        = Не Принудительная Или ОтправлятьПартнеру;
	ТребуетсяУказаниеКИКонтактногоЛица = Не Принудительная Или ОтправлятьКонтактномуЛицуОбъектаОповещения Или ОтправлятьКонтактнымЛицамРоли;
	
	Если Не ПредназначенаДляЭлектронныхПисем И ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка();
	КонецЕсли;
	
	Если (Не ПредназначенаДляЭлектронныхПисем) Или (Не ТребуетсяУказаниеКИПартнера) 
		И ЗначениеЗаполнено(ВидКонтактнойИнформацииПартнераДляПисем) Тогда
		ВидКонтактнойИнформацииПартнераДляПисем = Справочники.ВидыКонтактнойИнформации.ПустаяСсылка();
	КонецЕсли;
	
	Если (Не ПредназначенаДляЭлектронныхПисем) Или (Не ТребуетсяУказаниеКИКонтактногоЛица) 
		И ЗначениеЗаполнено(ВидКонтактнойИнформацииКонтактногоЛицаДляПисем) Тогда
		ВидКонтактнойИнформацииКонтактногоЛицаДляПисем = Справочники.ВидыКонтактнойИнформации.ПустаяСсылка();
	КонецЕсли;
	
	Если (Не ПредназначенаДляSMS) Или (Не ТребуетсяУказаниеКИКонтактногоЛица)
		И ЗначениеЗаполнено(ВидКонтактнойИнформацииКонтактногоЛицаДляSMS) Тогда
		ВидКонтактнойИнформацииКонтактногоЛицаДляSMS = Справочники.ВидыКонтактнойИнформации.ПустаяСсылка();
	КонецЕсли;
	
	Если (Не ПредназначенаДляSMS) Или (Не ТребуетсяУказаниеКИПартнера) 
		И ЗначениеЗаполнено(ВидКонтактнойИнформацииПартнераДляSMS) Тогда
		ВидКонтактнойИнформацииПартнераДляSMS = Справочники.ВидыКонтактнойИнформации.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

