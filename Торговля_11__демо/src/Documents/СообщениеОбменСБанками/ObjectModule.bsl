#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ПометкаУдаления Тогда
		ОтвязатьОбъектыИБ();
		Возврат;
	КонецЕсли;
	
	НовоеСостояние = СостояниеСообщенияОбмена();
	Если НовоеСостояние <> Состояние Тогда
		Состояние = НовоеСостояние;
		ДополнительныеСвойства.Вставить("ОбновитьСостояниеОбъектовИБ");
		
		Если ОбменСБанкамиСлужебный.ДокументПодписываетсяПоМаршруту(ЭтотОбъект) Тогда
			СостоянияЗавершенияОбмена = Новый Массив;
			СостоянияЗавершенияОбмена.Добавить(Перечисления.СостоянияОбменСБанками.Аннулирован);
			СостоянияЗавершенияОбмена.Добавить(Перечисления.СостоянияОбменСБанками.Отклонен);
			Если Состояние = Перечисления.СостоянияОбменСБанками.НаПодписи Тогда
				ПараметрыОбмена = ОбменСБанкамиСлужебныйВызовСервера.ПараметрыОбменаПоВидуЭД(НастройкаОбмена, ВидЭД);
				
				Если ПараметрыОбмена.ТребуетсяПодпись И ЗначениеЗаполнено(ПараметрыОбмена.МаршрутПодписания) Тогда
					ВесМаршрута = 0;
					
					// Это может быть новый объект - нужно корректно получить ссылку
					СсылкаДокумента = ОбщегоНазначенияБЭД.ПолучитьСсылкуОбъектаБезопасно(ЭтотОбъект);
					
					// Сформируем маршрут
					МаршрутыПодписанияБЭД.СформироватьМаршрутПодписанияЭД(СсылкаДокумента,
						ПараметрыОбмена.МаршрутПодписания,,, ВесМаршрута);
						
					// Сформируем и запишем представление прогресса подписания
					ПредставлениеПрогрессаПодписания = ОбменСБанкамиСлужебный.ПредставлениеПрогрессаПодписания(
						ЭтотОбъект, ВесМаршрута);
				КонецЕсли;
			ИначеЕсли СостоянияЗавершенияОбмена.Найти(Состояние) <> Неопределено Тогда
				МаршрутыПодписанияБЭД.ОчиститьМаршрутПодписания(Ссылка);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Ссылка) ИЛИ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Статус") = Статус Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("ЗаписатьСобытиеЖР");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ДополнительныеСвойства.Свойство("ЗаписатьСобытиеЖР") Тогда
		ЗаписатьСобытиеВЖурнал();
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбновитьСостояниеОбъектовИБ") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	СостоянияОбменСБанками.СсылкаНаОбъект
		               |ИЗ
		               |	РегистрСведений.СостоянияОбменСБанками КАК СостоянияОбменСБанками
		               |ГДЕ
		               |	СостоянияОбменСБанками.СообщениеОбмена = &СообщениеОбмена";
		Запрос.УстановитьПараметр("СообщениеОбмена", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			НаборЗаписей = РегистрыСведений.СостоянияОбменСБанками.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.СсылкаНаОбъект.Установить(Выборка.СсылкаНаОбъект);
			НаборЗаписей.Прочитать();
			Для Каждого Запись Из НаборЗаписей Цикл
				Запись.Состояние = Состояние;
				Если НЕ ОбщегоНазначенияБЭД.КонфигурацияИспользуетНесколькоЯзыков() Тогда
					Если Состояние = Перечисления.СостоянияОбменСБанками.НаПодписи
						И ЗначениеЗаполнено(ПредставлениеПрогрессаПодписания) Тогда
							Запись.ПредставлениеСостояния = СтрШаблон("%1 %2", Состояние, ПредставлениеПрогрессаПодписания);
					Иначе
						Запись.ПредставлениеСостояния = "";
					КонецЕсли;
				Иначе
					Запись.ПредставлениеСостояния = "";
				КонецЕсли;
			КонецЦикла;
			НаборЗаписей.Записать();
			ОбменСБанкамиПереопределяемый.ПриИзмененииСостоянияЭД(Выборка.СсылкаНаОбъект, Состояние);
		КонецЦикла;
	КонецЕсли;
	
	// Для писем статус документа кэшируется в объекте для ускорения работы динамического списка.
	Если ВидЭД = Перечисления.ВидыЭДОбменСБанками.Письмо Тогда
		ПисьмоСсылка = ОбменСБанкамиСлужебныйВызовСервера.ДокументУчета(Ссылка);
		Если ЗначениеЗаполнено(ПисьмоСсылка) Тогда
			ПисьмоОбъект = ПисьмоСсылка.ПолучитьОбъект();
			Если Статус = Перечисления.СтатусыОбменСБанками.Сформирован Тогда
				ПисьмоОбъект.Статус = Перечисления.СтатусыОбменСБанками.Черновик;
			Иначе
				ПисьмоОбъект.Статус = Статус;
			КонецЕсли;
			ПисьмоОбъект.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтвязатьОбъектыИБ()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СостоянияОбменСБанками.СсылкаНаОбъект
	|ИЗ
	|	РегистрСведений.СостоянияОбменСБанками КАК СостоянияОбменСБанками
	|ГДЕ
	|	СостоянияОбменСБанками.СообщениеОбмена = &СообщениеОбмена";
	Запрос.УстановитьПараметр("СообщениеОбмена", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		МенеджерЗаписи = РегистрыСведений.СостоянияОбменСБанками.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.СсылкаНаОбъект = Выборка.СсылкаНаОбъект;
		МенеджерЗаписи.Удалить();
	КонецЕсли;
	
КонецПроцедуры

Функция СостояниеСообщенияОбмена()
	
	ВозвращаемоеЗначение = Неопределено;
	
	ТекущийСтатус = Статус;
	
	НастройкиОбмена = ПараметрыОбмена();
	
	Если ТекущийСтатус = Перечисления.СтатусыОбменСБанками.ОшибкаПередачи
		ИЛИ ТекущийСтатус = Перечисления.СтатусыОбменСБанками.ОтклоненБанком Тогда
		ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ОшибкаПередачи;
	ИначеЕсли ТекущийСтатус = Перечисления.СтатусыОбменСБанками.Отклонен Тогда
		ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.Отклонен;
	ИначеЕсли ТекущийСтатус = Перечисления.СтатусыОбменСБанками.Приостановлен Тогда
		ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ОжидаетсяИсполнение;
	ИначеЕсли ТекущийСтатус = Перечисления.СтатусыОбменСБанками.Аннулирован Тогда
		ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.Аннулирован;
	ИначеЕсли ТекущийСтатус = Перечисления.СтатусыОбменСБанками.НеПодтвержден Тогда
		Если ПрограммаБанка = Перечисления.ПрограммыБанка.FintechIntegration Тогда
			ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ТребуетсяПодтверждениеВБанке;
		ИначеЕсли ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн Тогда
			ДатаОтключенияПодписанияSMS = ОбменСБанкамиСлужебныйКлиентСервер.ДатаОтключенияПодписанияSMSСбербанк();
			Если НЕ НастройкиОбмена.ИспользоватьПодпись
				И НачалоДня(ТекущаяДатаСеанса()) > ДатаОтключенияПодписанияSMS Тогда
				ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ТребуетсяПодтверждениеВБанке;
			Иначе
				ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ТребуетсяПодтверждение;
			КонецЕсли;
		Иначе
			ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ТребуетсяПодтверждение;
		КонецЕсли;
	Иначе
		МассивСтатусов = ОбменСБанкамиСлужебный.МассивСтатусовЭД(НастройкиОбмена);
		Если МассивСтатусов.Количество() > 0 Тогда
				
			ИндексТекущегоСтатуса = МассивСтатусов.Найти(ТекущийСтатус);
			Если ИндексТекущегоСтатуса = Неопределено Тогда
			ИначеЕсли ИндексТекущегоСтатуса + 1 = МассивСтатусов.Количество() Тогда
				ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ПлатежИсполнен;
			Иначе
				СледующийСтатус = МассивСтатусов[ИндексТекущегоСтатуса + 1];
				Если СледующийСтатус = Перечисления.СтатусыОбменСБанками.Подписан
					ИЛИ СледующийСтатус = Перечисления.СтатусыОбменСБанками.ЧастичноПодписан Тогда
					ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.НаПодписи;
				ИначеЕсли СледующийСтатус = Перечисления.СтатусыОбменСБанками.Отправлен
					ИЛИ СледующийСтатус = Перечисления.СтатусыОбменСБанками.ПодготовленКОтправке Тогда
					ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ТребуетсяОтправка;
				ИначеЕсли СледующийСтатус = Перечисления.СтатусыОбменСБанками.Доставлен Тогда
					ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ОжидаетсяИзвещениеОПолучении;
				ИначеЕсли СледующийСтатус = Перечисления.СтатусыОбменСБанками.Исполнен
					ИЛИ СледующийСтатус = Перечисления.СтатусыОбменСБанками.Принят Тогда
					ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ОжидаетсяИсполнение;
				ИначеЕсли СледующийСтатус = Перечисления.СтатусыОбменСБанками.Подтвержден Тогда
					ВозвращаемоеЗначение = Перечисления.СостоянияОбменСБанками.ОжидаетсяВыписка;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПараметрыОбмена()
	
	НастройкиОбмена = Новый Структура;
	
	РеквизитыНастройкиОбмена = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		НастройкаОбмена, "СертификатыПодписейОрганизации, ПрограммаБанка, ИспользуетсяКриптография");
	НастройкиОбмена.Вставить("ПрограммаБанка", РеквизитыНастройкиОбмена.ПрограммаБанка);
	
	НастройкиОбмена.Вставить("Направление", Направление);
	НастройкиОбмена.Вставить("ВидЭД", ВидЭД);
	НастройкиОбмена.Вставить("ИспользоватьПодпись", Ложь);
	НастройкиОбмена.Вставить("Статус", Статус);
	
	ЗапросПоНастройкам = Новый Запрос;
	ЗапросПоНастройкам.УстановитьПараметр("НастройкаОбмена", НастройкаОбмена);
	ЗапросПоНастройкам.УстановитьПараметр("ВидЭД", ВидЭД);
	ЗапросПоНастройкам.Текст =
	"ВЫБРАТЬ
	|	НастройкиОбменСБанкамиИсходящиеДокументы.ИспользоватьЭП КАК ИспользоватьПодпись
	|ИЗ
	|	Справочник.НастройкиОбменСБанками.ИсходящиеДокументы КАК НастройкиОбменСБанкамиИсходящиеДокументы
	|ГДЕ
	|	НастройкиОбменСБанкамиИсходящиеДокументы.ИсходящийДокумент = &ВидЭД
	|	И НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка = &НастройкаОбмена
	|	И НастройкиОбменСБанкамиИсходящиеДокументы.Формировать";
		
	Результат = ЗапросПоНастройкам.Выполнить();
		
	Если НЕ Результат.Пустой() Тогда
		ТЗ = Результат.Выгрузить();
		ЗаполнитьЗначенияСвойств(НастройкиОбмена, ТЗ[0]);
	КонецЕсли;
	
	Возврат НастройкиОбмена;
	
КонецФункции

Процедура ЗаписатьСобытиеВЖурнал()
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		МенеджерЗаписи = РегистрыСведений.ЖурналСобытийОбменСБанками.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Сообщение = Ссылка;
		МенеджерЗаписи.Идентификатор = Новый УникальныйИдентификатор();
		МенеджерЗаписи.Статус = Статус;
		МенеджерЗаписи.Период = ТекущаяДатаСеанса();
		МенеджерЗаписи.Пользователь = Пользователи.АвторизованныйПользователь();
		МенеджерЗаписи.Записать();
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли