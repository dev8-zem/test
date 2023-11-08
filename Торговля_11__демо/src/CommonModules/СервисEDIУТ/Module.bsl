#Область ПрограммныйИнтерфейс

// См. СервисEDIПереопределяемый.ПриОпределенииНастроекУчета.
//
Процедура ПриОпределенииНастроекУчета(НастройкиУчета) Экспорт
	
#Область СоответствиеДокументовEDIПрикладнымОбъектам
	
	НастройкиУчета.СоответствиеДокументовEDIПрикладнымОбъектам.Вставить(Перечисления.ТипыДокументовEDI.ЗаказКлиента,    Тип("ДокументСсылка.ЗаказКлиента"));
	НастройкиУчета.СоответствиеДокументовEDIПрикладнымОбъектам.Вставить(Перечисления.ТипыДокументовEDI.ЗаказПоставщику, Тип("ДокументСсылка.ЗаказПоставщику"));
	
#КонецОбласти
	
	НастройкиУчета.ТипИнтеграции = Перечисления.ТипыИнтеграцииEDI.ВыполненоВстраиваниеВДокументы;
	НастройкиУчета.ИспользуетсяОтменаСтрокЗаказовКлиента           = Истина;
	НастройкиУчета.ИспользуютсяПричиныОтменСтрокЗаказовКлиента     = ПолучитьФункциональнуюОпцию("ИспользоватьПричиныОтменыЗаказовКлиентов");
	НастройкиУчета.ИспользуетсяОтменаСтрокЗаказовПоставщикам       = Истина;
	НастройкиУчета.ИспользуютсяПричиныОтменСтрокЗаказовПоставщикам = ПолучитьФункциональнуюОпцию("ИспользоватьПричиныОтменыЗаказовПоставщикам");
	
#Область ЗаполнениеСкладаПриЗагрузкеДокументов

	НастройкиУчета.ИспользуютсяСклады = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	НастройкиУчета.ДоступноАвтоматическоеЗаполнениеСклада = Истина;
	НастройкиУчета.ПредставлениеНастройкиАвтоматическогоЗаполненияСклада = НСтр("ru = 'По статистике'");
	НастройкиУчета.ПояснениеМеханизмаАвтоматическогоЗаполненияСклада = НСтр("ru = 'Склад будет заполнен по данным статистики. При недостатке данных он может остаться незаполненным'");

#КонецОбласти	
	
КонецПроцедуры

#Область ФормыСписковПрикладныхДокументов

// См. СервисEDIПереопределяемый.ПриЗагрузкеДанныхИзНастроекНаСервереФормаСпискаПрикладногоДокумента.
//
Процедура ПриЗагрузкеДанныхИзНастроекНаСервереФормаСпискаПрикладногоДокумента(Форма, Настройки, СтандартнаяОбработка) Экспорт
	
	Если Форма.СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// См. СервисEDIПереопределяемый.ПриОпределенииДоступностиРазделаВиджетаПоПравам.
//
Процедура ПриОпределенииДоступностиРазделаВиджетаПоПравам(Раздел, Доступен) Экспорт
	
	Если Раздел = Перечисления.РазделыВиджетовEDI.АрхивЗакупки Тогда
		
		Доступен = ДоступенХотьОдинДокументЗакупки();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.ВРаботеЗакупки Тогда
		
		Доступен = ДоступенХотьОдинДокументЗакупки();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.ОтклоненияПриВыполненииЗакупки Тогда
		
		Доступен = ДоступенХотьОдинДокументЗакупки();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.ПоследниеСобытияЗакупки Тогда
		
		Доступен = ДоступенХотьОдинДокументЗакупки();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.АрхивПродажи Тогда
		
		Доступен = ДоступенХотьОдинДокументПродажи();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.ВРаботеПродажи Тогда
		
		Доступен = ДоступенХотьОдинДокументПродажи();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.ОтклоненияПриВыполненииПродажи Тогда
		
		Доступен = ДоступенХотьОдинДокументПродажи();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.ПоследниеСобытияПродажи Тогда
		
		Доступен = ДоступенХотьОдинДокументПродажи();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.СоздатьЗаказПоставщику Тогда
		
		Доступен = ИзменениеЗаказаПоставщикуДоступно();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.НайтиТорговоеПредложение Тогда
		
		Доступен = Ложь;
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.КонтрольОтгрузокЗавтра Тогда
		
		Доступен = ДоступенХотьОдинДокументПродажи();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.КонтрольОтгрузокНеделя Тогда
		
		Доступен = ДоступенХотьОдинДокументПродажи();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.КонтрольОтгрузокПросрочено Тогда
		
		Доступен = ДоступенХотьОдинДокументПродажи();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.КонтрольОтгрузокСегодня Тогда
		
		Доступен = ДоступенХотьОдинДокументПродажи();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.КонтрольОтгрузокТриДня Тогда
		
		Доступен = ДоступенХотьОдинДокументПродажи();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.КонтрольПоступленийЗавтра Тогда
		
		Доступен = ДоступенХотьОдинДокументЗакупки();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.КонтрольПоступленийНеделя Тогда
		
		Доступен = ДоступенХотьОдинДокументЗакупки();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.КонтрольПоступленийПросрочено Тогда
		
		Доступен = ДоступенХотьОдинДокументЗакупки();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.КонтрольПоступленийСегодня Тогда
		
		Доступен = ДоступенХотьОдинДокументЗакупки();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.КонтрольПоступленийТриДня Тогда
		
		Доступен = ДоступенХотьОдинДокументЗакупки();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.Контрагенты Тогда
		
		Доступен = ПравоДоступа("Чтение", Метаданные.Справочники.Контрагенты);
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.Номенклатура Тогда
		
		Доступен = ПравоДоступа("Чтение", Метаданные.Справочники.Номенклатура);
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.НоменклатураКонтрагентов Тогда
		
		Доступен = ПравоДоступа("Чтение", Метаданные.Справочники.Номенклатура);
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.Настройки Тогда
		
		 Доступен = ЧтениеНастроекДоступно();
		
	ИначеЕсли Раздел = Перечисления.РазделыВиджетовEDI.ЗаказыПоставщикуДоступныеДляОтправки Тогда
		
		Доступен = ИзменениеЗаказаПоставщикуДоступно()
			И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.НеОтправленныеПрикладныеОбъектыEDI);
		
	КонецЕсли;
	
КонецПроцедуры

// См. СервисEDIПереопределяемый.ЗаполнитьДанныеПрикладногоДокумента.
//
Процедура ЗаполнитьДанныеПрикладногоДокумента(СсылкаНаДокумент, ДанныеПрикладногоОбъектаEDI, ЗаполнениеНеВыполнялось) Экспорт
	
	Если ТипЗнч(СсылкаНаДокумент) <> Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаполнениеНеВыполнялось = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗаказПоставщику.Проведен       КАК Проведен,
	|	ЗаказПоставщику.Организация    КАК Организация,
	|	ЗаказПоставщику.Контрагент     КАК Контрагент,
	|	ЗаказПоставщику.Дата           КАК Дата,
	|	ЗаказПоставщику.Номер          КАК Номер,
	|	ЗаказПоставщику.СуммаДокумента КАК Сумма,
	|	ЗаказПоставщику.Менеджер       КАК Менеджер,
	|	ЗаказПоставщику.Валюта         КАК Валюта,
	|	ВЫБОР
	|		КОГДА ЗаказПоставщику.Статус НЕ В (ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПоставщикам.НеСогласован), ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПоставщикам.НеСогласован))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                          КАК Согласован
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	|ГДЕ
	|	ЗаказПоставщику.Ссылка = &СсылкаНаДокумент";
	
	Запрос.УстановитьПараметр("СсылкаНаДокумент", СсылкаНаДокумент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
	
		ЗаполнитьЗначенияСвойств(ДанныеПрикладногоОбъектаEDI, Выборка);
	
	КонецЕсли;
	
КонецПроцедуры

// См. СервисEDIПереопределяемый.ЗаполнитьПараметрыЗапретаРедактированияРеквизитовEDI.
//
Процедура ЗаполнитьПараметрыЗапретаРедактированияРеквизитовEDI(ТаблицаПараметров, ТипДокумента) Экспорт
	
	Если ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказКлиента Тогда
		
		Документы.ЗаказКлиента.ЗаполнитьТаблицуПараметровБлокировкиРеквизитовEDI(ТаблицаПараметров);
		
	ИначеЕсли ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказПоставщику Тогда
		
		Документы.ЗаказПоставщику.ЗаполнитьТаблицуПараметровБлокировкиРеквизитовEDI(ТаблицаПараметров);
	КонецЕсли;
	
КонецПроцедуры

// См. СервисEDIПереопределяемый.ПриАвтоматическомОпределенииСкладаПрикладногоДокумента.
//
Процедура ПриАвтоматическомОпределенииСкладаПрикладногоДокумента(Склад,
	Знач ТипПрикладногоДокумента, Знач КритерииПоиска) Экспорт
		
	РеквизитыПоиска = Новый Структура("Организация, Контрагент, Менеджер");
	ЗаполнитьЗначенияСвойств(РеквизитыПоиска, КритерииПоиска);
	РеквизитыПоиска.Менеджер = МенеджерКонтрагента(РеквизитыПоиска.Контрагент);
	
	МенеджерПрикладногоОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
		Метаданные.НайтиПоТипу(ТипПрикладногоДокумента).ПолноеИмя());
		
	ОписаниеРеквизитов = Новый Структура;
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьТолькоЗаполненные = "Организация, Контрагент, Менеджер";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов, "Склад", Параметры);
	
	ЗаполняемыеРеквизиты = ЗаполнениеОбъектовПоСтатистике.ПолучитьЗначенияРеквизитов(МенеджерПрикладногоОбъекта.ПустаяСсылка(),
		ОписаниеРеквизитов, РеквизитыПоиска);
	
	Склад = ЗаполняемыеРеквизиты.Склад;
	
КонецПроцедуры

// См. СервисEDIПереопределяемый.УстановитьСкладПоУмолчанию.
//
Процедура УстановитьСкладПоУмолчанию(Склад) Экспорт
	
	Склад = Справочники.Склады.СкладПоУмолчанию();

КонецПроцедуры

#Область ПриОпределенииВозможностиВыполненияКомандСервиса

// См. СервисEDIПереопределяемый.ПриОпределенииДоступностиКомандПриОтображении.
//
Процедура ПриОпределенииДоступностиКомандПриОтображении(ПрикладнойОбъект, КатегорииКоманд) Экспорт
	
	Если ТипЗнч(ПрикладнойОбъект) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ПриОпределенииДоступностиКомандПриОтображенииЗаказПоставщику(ПрикладнойОбъект, КатегорииКоманд);
		
	КонецЕсли;
	
КонецПроцедуры

// См. СервисEDIПереопределяемый.ПередВыполнениемКомандыСервиса.
//
Процедура ПередВыполнениемКомандыСервиса(ПараметрыВыполнения) Экспорт
	
	
	Если ТипЗнч(ПараметрыВыполнения.ПрикладнойОбъект) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ПередВыполнениеКомандыСервисаЗаказПоставщику(ПараметрыВыполнения);
		
	ИначеЕсли ТипЗнч(ПараметрыВыполнения.ПрикладнойОбъект) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		ПередВыполнениеКомандыСервисаЗаказКлиента(ПараметрыВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПриОбновленииРеестраДокументов

// См. СервисEDIПереопределяемый.ПриОбновленииЗаписиСостоянияДокументовПоДаннымСервиса.
//
Процедура ПриОбновленииЗаписиСостоянияДокументовПоДаннымСервиса(ПараметрыЗаписи) Экспорт
	
	Если ПараметрыЗаписи.ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказКлиента Тогда
		
		ПриОбновленииЗаписиСостоянияДокументовПоДаннымСервисаЗаказКлиента(ПараметрыЗаписи);
		
	ИначеЕсли ПараметрыЗаписи.ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказПоставщику Тогда
		
		 ПриОбновленииЗаписиСостоянияДокументовПоДаннымСервисаЗаказПоставщику(ПараметрыЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеДоступом

Процедура ДополнитьПрофильПравамиЧтенияДокументовEDI(ОписаниеПрофиля) Экспорт

	ОписаниеПрофиля.ВидыДоступа.Добавить("ТипыДокументовEDI", "Предустановленный");
	
	ОписаниеПрофиля.Роли.Добавить("РаботаСДокументамиEDI");
	
	Если ОписаниеПрофиля.ЗначенияДоступа.НайтиПоЗначению("ТипыДокументовEDI") = Неопределено Тогда
		Если ОписаниеПрофиля.Роли.Найти("ДобавлениеИзменениеЗаказовКлиентов") <> Неопределено 
			Или  ОписаниеПрофиля.Роли.Найти("ЧтениеЗаказовКлиентовЗаявокНаВозвратТоваровОтКлиента") <> Неопределено Тогда
			ОписаниеПрофиля.ЗначенияДоступа.Добавить("ТипыДокументовEDI", "Перечисление.ТипыДокументовEDI.ЗаказКлиента");
		КонецЕсли;
		
		Если ОписаниеПрофиля.Роли.Найти("ЧтениеЗаказовПоставщикам") <> Неопределено 
			Или ОписаниеПрофиля.Роли.Найти("ДобавлениеИзменениеЗаказовПоставщикам") <> Неопределено Тогда
			ОписаниеПрофиля.ЗначенияДоступа.Добавить("ТипыДокументовEDI", "Перечисление.ТипыДокументовEDI.ЗаказПоставщику");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСоСтатусами

Процедура ПроверитьКорректностьСтатусовСтатусамEDI(ВыборкаПроверки, НовыйСтатус, Отказ) Экспорт
	
	Если ТипЗнч(ВыборкаПроверки.Ссылка) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаказовПоставщикам[НовыйСтатус];
	
		Если ЗначениеЗаполнено(ВыборкаПроверки.СтатусEDI) Тогда
			
			Если ЗначениеНовогоСтатуса <> Перечисления.СтатусыЗаказовПоставщикам.Закрыт
				И Не ДокументыEDIКлиентСервер.МассивСтатусовАрхив().Найти(ВыборкаПроверки.СтатусEDI) = Неопределено
				И Перечисления.СтатусыЗаказовПоставщикам.СтатусЗакрытИспользуется() Тогда
				
				ТекстОшибки = НСтр("ru = 'У документа %Документ% статус ""%Статус%"" не установлен, т.к. заказ завершил процесс в 1С:EDI.'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ВыборкаПроверки.Ссылка);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", ВыборкаПроверки.ПредставлениеНовогоСтатуса);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ВыборкаПроверки.Ссылка);
				Отказ = Истина;
			КонецЕсли;
			
			Если Не Отказ
				И ДокументыEDIКлиентСервер.МассивСтатусовНаСторонеКонтрагента(Перечисления.КатегорииДокументовEDI.Закупка).Найти(ВыборкаПроверки.СтатусEDI) <> Неопределено
				И Не ВыборкаПроверки.СтатусEDI = Перечисления.СтатусыЗаказаEDI.Выполняется 
				И Не ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаказовПоставщикам.Подтвержден Тогда
				
				ТекстОшибки = НСтр("ru = 'У документа %Документ% статус ""%Статус%"" не установлен, т.к. заказ находится на стороне поставщика в 1С:EDI.'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ВыборкаПроверки.Ссылка);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", ВыборкаПроверки.ПредставлениеНовогоСтатуса);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ВыборкаПроверки.Ссылка);
				Отказ = Истина;
				
			КонецЕсли;
			
			Если Не Отказ
				И ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаказовПоставщикам.НеСогласован 
				И Не ВыборкаПроверки.СтатусEDI = Перечисления.СтатусыЗаказаEDI.ИзмененияПодтверждаютсяПокупателем
				И Не ВыборкаПроверки.СтатусEDI = Перечисления.СтатусыЗаказаEDI.СогласуетсяПокупателем
				И Не ВыборкаПроверки.СтатусEDI = Перечисления.СтатусыЗаказаEDI.Выполняется
				И Не ВыборкаПроверки.СтатусEDI = Перечисления.СтатусыЗаказаEDI.ПодтверждаетсяВыполнение Тогда
				
				ТекстОшибки = НСтр("ru = 'У документа %Документ% статус ""%Статус%"" не установлен, т.к. заказ не находится на согласовании покупателя в 1С:EDI.'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ВыборкаПроверки.Ссылка);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", ВыборкаПроверки.ПредставлениеНовогоСтатуса);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ВыборкаПроверки.Ссылка);
				Отказ = Истина;
				
			КонецЕсли;
			
			Если Не Отказ
				И ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаказовПоставщикам.Согласован 
				И Не ВыборкаПроверки.СтатусEDI = Перечисления.СтатусыЗаказаEDI.ИзмененияПодтверждаютсяПокупателем
				И Не ВыборкаПроверки.СтатусEDI = Перечисления.СтатусыЗаказаEDI.СогласуетсяПокупателем
				И Не ВыборкаПроверки.СтатусEDI = Перечисления.СтатусыЗаказаEDI.Выполняется
				И Не ВыборкаПроверки.СтатусEDI = Перечисления.СтатусыЗаказаEDI.ПодтверждаетсяВыполнение Тогда
				
				ТекстОшибки = НСтр("ru = 'У документа %Документ% статус ""%Статус%"" не установлен, т.к. заказ не находится на согласовании покупателя в 1С:EDI.'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ВыборкаПроверки.Ссылка);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", ВыборкаПроверки.ПредставлениеНовогоСтатуса);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ВыборкаПроверки.Ссылка);
				Отказ = Истина;
				
			КонецЕсли;
			
			Если Не Отказ
				И ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаказовПоставщикам.Подтвержден
				И Перечисления.СтатусыЗаказовПоставщикам.СтатусЗакрытИспользуется()
				И ДокументыEDIКлиентСервер.МассивСтатусовВыполняется().Найти(ВыборкаПроверки.СтатусEDI) = Неопределено Тогда
				
				ТекстОшибки = НСтр("ru = 'У документа %Документ% статус ""%Статус%"" не установлен, т.к. заказ не находится на выполнении в 1С:EDI.'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ВыборкаПроверки.Ссылка);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", ВыборкаПроверки.ПредставлениеНовогоСтатуса);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ВыборкаПроверки.Ссылка);
				Отказ = Истина;
				
			КонецЕсли;
			
			Если Не Отказ
				И ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаказовПоставщикам.Подтвержден
				И Не Перечисления.СтатусыЗаказовПоставщикам.СтатусЗакрытИспользуется()
				И ДокументыEDIКлиентСервер.МассивСтатусовВыполняется().Найти(ВыборкаПроверки.СтатусEDI) = Неопределено
				И ВыборкаПроверки.СтатусEDI <> Перечисления.СтатусыЗаказаEDI.Выполнен Тогда
				
				ТекстОшибки = НСтр("ru = 'У документа %Документ% статус ""%Статус%"" не установлен, т.к. заказ не находится на выполнении в 1С:EDI.'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ВыборкаПроверки.Ссылка);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", ВыборкаПроверки.ПредставлениеНовогоСтатуса);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ВыборкаПроверки.Ссылка);
				Отказ = Истина;
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли  ТипЗнч(ВыборкаПроверки.Ссылка) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		 ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаказовКлиентов[НовыйСтатус];
		
		Если ЗначениеЗаполнено(ВыборкаПроверки.СтатусEDI) Тогда
			
			Если ДокументыEDIКлиентСервер.МассивСтатусовАрхив().Найти(ВыборкаПроверки.СтатусEDI) = Неопределено
				И ЗначениеНовогоСтатуса <> Перечисления.СтатусыЗаказовКлиентов.Закрыт Тогда
				
				ТекстОшибки = НСтр("ru = 'У документа %Документ% статус ""%Статус%"" не установлен, т.к. заказ завершил процесс в 1С:EDI'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ВыборкаПроверки.Ссылка);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", ВыборкаПроверки.ПредставлениеНовогоСтатуса);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ВыборкаПроверки.Ссылка);
				Отказ = Истина;
			КонецЕсли;
			
			Если ДокументыEDIКлиентСервер.МассивСтатусовНаСторонеКонтрагента(Перечисления.КатегорииДокументовEDI.Продажа).Найти(ВыборкаПроверки.СтатусEDI) <> Неопределено Тогда
				
				ТекстОшибки = НСтр("ru = 'У документа %Документ% статус ""%Статус%"" не установлен, т.к. заказ находится на стороне клиента в 1С:EDI'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ВыборкаПроверки.Ссылка);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", ВыборкаПроверки.ПредставлениеНовогоСтатуса);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ВыборкаПроверки.Ссылка);
				Отказ = Истина;
				
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДоступностьПрикладныхОбъектов

Функция ДоступенХотьОдинДокументЗакупки()
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЗаказПоставщику)
		И ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам") Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ДоступенХотьОдинДокументПродажи()
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЗаказКлиента)
		И ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ИзменениеЗаказаПоставщикуДоступно()
	
	Возврат ПравоДоступа("Изменение", Метаданные.Документы.ЗаказПоставщику)
	        И ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам");
	
КонецФункции

Функция ЧтениеНастроекДоступно()
	
	Возврат ПравоДоступа("Чтение", Метаданные.РегистрыСведений.НастройкиПоставщикаEDI) 
			И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.НастройкиИнтеграцииEDI)
	
КонецФункции

#КонецОбласти

#Область ОбновлениеСтатусовПрикладныхДокументовПриПолученииДанныхСервиса

Процедура ПриОбновленииЗаписиСостоянияДокументовПоДаннымСервисаЗаказКлиента(ПараметрыЗаписи) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыЗаписи.ПрикладнойОбъект) Тогда
		
		Если ПараметрыЗаписи.СторонаВыполнившаяДействие = Перечисления.СтороныУчастникиСервисаEDI.Покупатель
			И ПараметрыЗаписи.ТекущийСтатус = Перечисления.СтатусыЗаказаEDI.Отменен
			И ПараметрыЗаписи.ПредыдущийСтатус <> Перечисления.СтатусыЗаказаEDI.Отменен Тогда
			
			НастройкиИнтеграции = НастройкиEDI.НастройкиИнтеграцииEDI(ПараметрыЗаписи.Организация);
			Если НастройкиИнтеграции.ОтменятьСтрокиЗаказаКлиентаПриОтмене Тогда
				 
				ИмяПроцедуры = "СервисEDIУТ.ПриОтменеЗаказаКлиента";
			
				ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор());
				ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Отмена заказа клиента при получении данных EDI.'");
				ПараметрыВыполнения.КлючФоновогоЗадания = Новый УникальныйИдентификатор();
				ПараметрыВыполнения.ОжидатьЗавершение = 0;
				ПараметрыВыполнения.ЗапуститьВФоне = Истина;
				
				ДлительныеОперации.ВыполнитьПроцедуру(
					ПараметрыВыполнения, 
					ИмяПроцедуры, 
					ПараметрыЗаписи.ПрикладнойОбъект,
					НастройкиИнтеграции.ПричинаОтменыСтрокЗаказовКлиента);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОбновленииЗаписиСостоянияДокументовПоДаннымСервисаЗаказПоставщику(ПараметрыЗаписи) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыЗаписи.ПрикладнойОбъект) Тогда
		
		Если ПараметрыЗаписи.СторонаВыполнившаяДействие = Перечисления.СтороныУчастникиСервисаEDI.Поставщик
			И ПараметрыЗаписи.ТекущийСтатус = Перечисления.СтатусыЗаказаEDI.Отменен
			И ПараметрыЗаписи.ПредыдущийСтатус <> Перечисления.СтатусыЗаказаEDI.Отменен Тогда
			
			НастройкиИнтеграции = НастройкиEDI.НастройкиИнтеграцииEDI(ПараметрыЗаписи.Организация);
			Если НастройкиИнтеграции.ОтменятьСтрокиЗаказаПоставщикуПриОтмене Тогда
				
				ИмяПроцедуры = "СервисEDIУТ.ПриОтменеЗаказаПоставщику";
			
				ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор());
				ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Отмена заказа поставщика при получении данных EDI.'");
				ПараметрыВыполнения.КлючФоновогоЗадания = Новый УникальныйИдентификатор();
				ПараметрыВыполнения.ОжидатьЗавершение = 0;
				ПараметрыВыполнения.ЗапуститьВФоне = Истина;
				
				ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения,
					ИмяПроцедуры, 
					ПараметрыЗаписи.ПрикладнойОбъект, 
					НастройкиИнтеграции.ПричинаОтменыСтрокЗаказаПоставщику);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ПараметрыЗаписи.СторонаВыполнившаяДействие = Перечисления.СтороныУчастникиСервисаEDI.Поставщик
			И ПараметрыЗаписи.ТекущийСтатус = Перечисления.СтатусыЗаказаEDI.Выполняется
			И ПараметрыЗаписи.ПредыдущийСтатус = Перечисления.СтатусыЗаказаEDI.СогласуетсяПоставщиком Тогда
			
			ИмяПроцедуры = "СервисEDIУТ.ПриПодтвержденииЗаказаПоставщику";
			
				ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор());
				ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Подтверждение заказа поставщика при получении данных EDI.'");
				ПараметрыВыполнения.КлючФоновогоЗадания = Новый УникальныйИдентификатор();
				ПараметрыВыполнения.ОжидатьЗавершение = 0;
				ПараметрыВыполнения.ЗапуститьВФоне = Истина;
				
				ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения,
					ИмяПроцедуры, 
					ПараметрыЗаписи.ПрикладнойОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОтменеЗаказаКлиента(Документ, ПричинаОтмены) Экспорт
	
	ИспользоватьПричиныОтменыЗаказовКлиентов =  ПолучитьФункциональнуюОпцию("ИспользоватьПричиныОтменыЗаказовКлиентов");
	
	Если ИспользоватьПричиныОтменыЗаказовКлиентов 
		И Не ЗначениеЗаполнено(ПричинаОтмены) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(Документ);
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заблокировать %1 при отмене строк после получения статуса ""Отменен"" из 1C:EDI. %2'"),
			Документ, 
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(ОбновлениеДанныхEDI.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			Документ.Метаданные(),
			Документ,
			ТекстОшибки);
		
	КонецПопытки;
	
	ДокументОбъект = Документ.ПолучитьОбъект();
	
	Попытка
		
		ПараметрыКорректировки = ЗаказыСервер.СтруктураКорректировкиСтрокЗаказа();
		ПараметрыКорректировки.ДокументОбъект                = ДокументОбъект;
		ПараметрыКорректировки.ИмяДокумента                  = "ЗаказКлиента";
		ПараметрыКорректировки.ПричинаОтмены                 = ПричинаОтмены;
		ПараметрыКорректировки.ОтменитьНеотработанныеСтроки  = Истина;
		
		ЗаказИзменен = ЗаказыСервер.СкорректироватьСтрокиЗаказа(ДокументОбъект, ПараметрыКорректировки);
		
		Если ЗаказИзменен Тогда
			
			ПараметрыПоиска = Новый Структура;
			ПараметрыПоиска.Вставить("Отменено", Ложь);
			
			НайденныеСтроки = ДокументОбъект.Товары.НайтиСтроки(ПараметрыПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось записать %1 при отмене строк после получения статуса ""Отменен"" из 1C:EDI. %2'"),
			Документ, 
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	
		ЗаписьЖурналаРегистрации(ОбновлениеДанныхEDI.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			Документ.Метаданные(),
			Документ,
			ТекстОшибки);
		
	КонецПопытки;
		
КонецПроцедуры

Процедура ПриОтменеЗаказаПоставщику(Документ, ПричинаОтмены) Экспорт
	
	ИспользоватьПричиныОтменыЗаказовПоставщикам =  ПолучитьФункциональнуюОпцию("ИспользоватьПричиныОтменыЗаказовПоставщикам");
	
	Если ИспользоватьПричиныОтменыЗаказовПоставщикам 
		И Не ЗначениеЗаполнено(ПричинаОтмены) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(Документ);
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заблокировать %1 при отмене строк после получения статуса ""Отменен"" из 1C:EDI. %2'"),
			Документ, 
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(ОбновлениеДанныхEDI.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			Документ.Метаданные(),
			Документ,
			ТекстОшибки);
		
	КонецПопытки;
	
	ДокументОбъект = Документ.ПолучитьОбъект();
	
	Попытка
		
		ПараметрыКорректировки = ЗаказыСервер.СтруктураКорректировкиСтрокЗаказа();
		ПараметрыКорректировки.ДокументОбъект                = ДокументОбъект;
		ПараметрыКорректировки.ИмяДокумента                  = "ЗаказПоставщику";
		ПараметрыКорректировки.ПричинаОтмены                 = ПричинаОтмены;
		ПараметрыКорректировки.ОтменитьНеотработанныеСтроки  = Истина;
		
		ЗаказИзменен = ЗаказыСервер.СкорректироватьСтрокиЗаказа(ДокументОбъект, ПараметрыКорректировки);
		
		Если ЗаказИзменен Тогда
			
			ПараметрыПоиска = Новый Структура;
			ПараметрыПоиска.Вставить("Отменено", Ложь);
			
			НайденныеСтроки = ДокументОбъект.Товары.НайтиСтроки(ПараметрыПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось записать %1 при отмене строк после получения статуса ""Отменен"" из 1C:EDI. %2'"),
			Документ, 
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	
		ЗаписьЖурналаРегистрации(ОбновлениеДанныхEDI.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			Документ.Метаданные(),
			Документ,
			ТекстОшибки);
		
	КонецПопытки;
		
КонецПроцедуры

Процедура ПриПодтвержденииЗаказаПоставщику(Документ) Экспорт
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(Документ);
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заблокировать %1 при подтверждении заказа поставщиком в 1C:EDI. %2'"),
			Документ, 
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(ОбновлениеДанныхEDI.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			Документ.Метаданные(),
			Документ,
			ТекстОшибки);
		
	КонецПопытки;
	
	ДокументОбъект = Документ.ПолучитьОбъект();
	
	Попытка
		
		ЗаказИзменен = ДокументОбъект.УстановитьСтатус("Подтвержден", Неопределено);
		Если ЗаказИзменен Тогда
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		КонецЕсли;
		
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось записать %1 при подтверждении заказа поставщиком в 1C:EDI. %2'"),
			Документ, 
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	
		ЗаписьЖурналаРегистрации(ОбновлениеДанныхEDI.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			Документ.Метаданные(),
			Документ,
			ТекстОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ПриОпределенииВозможностиВыполненияКомандСервиса

#Область ЗаказПоставщику

Процедура ПриОпределенииДоступностиКомандПриОтображенииЗаказПоставщику(ПрикладнойОбъект, КатегорииКоманд) Экспорт
	
	ИспользоватьСтатусыЗаказовПоставщикам = ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыЗаказовПоставщикам");
	
	ДанныеДокумента = ДанныеЗаказаПоставщикуДляПроверкиВыполненияКоманды(ПрикладнойОбъект);
	
	Для Каждого СтрокаТаблицы Из КатегорииКоманд Цикл
		
		Если СтрокаТаблицы.КатегорияКоманды = Перечисления.КатегорииКомандСервисаEDI.Согласование Тогда
			
			Если ПрикладнойОбъект.Пустая() Или Не ДанныеДокумента.Проведен Тогда
				
				СтрокаТаблицы.Доступно = Ложь;
				СтрокаТаблицы.ПояснениеНедоступности = ПояснениеДокументНеПроведен();
				Продолжить;
				
			КонецЕсли;
			
			Если ИспользоватьСтатусыЗаказовПоставщикам
				И (ПрикладнойОбъект.Пустая() Или ДанныеДокумента.Статус = Перечисления.СтатусыЗаказовПоставщикам.НеСогласован) Тогда
				
				СтрокаТаблицы.Доступно = Ложь;
				СтрокаТаблицы.ПояснениеНедоступности = ПояснениеЗаказПоставщикуНеСогласован();
				Продолжить;
				
			КонецЕсли;
			
		ИначеЕсли СтрокаТаблицы.КатегорияКоманды = Перечисления.КатегорииКомандСервисаEDI.ПодтверждениеВыполнения Тогда
			
			Если ПрикладнойОбъект.Пустая() Или Не ДанныеДокумента.Проведен Тогда
				
				СтрокаТаблицы.Доступно = Ложь;
				СтрокаТаблицы.ПояснениеНедоступности = ПояснениеДокументНеПроведен();
				Продолжить;
				
			КонецЕсли;
			
		КонецЕсли;
		
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередВыполнениеКомандыСервисаЗаказПоставщику(ПараметрыВыполнения) 
	
	ИспользоватьСтатусыЗаказовПоставщикам = ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыЗаказовПоставщикам");
	
	ДанныеДокумента = ДанныеЗаказаПоставщикуДляПроверкиВыполненияКоманды(ПараметрыВыполнения.ПрикладнойОбъект);
	
	КатегорияКоманды = ПараметрыВыполнения.КатегорияКоманды;
	
	Если КатегорияКоманды = Перечисления.КатегорииКомандСервисаEDI.Согласование Тогда
		
		Если Не ДанныеДокумента.Проведен Тогда
			
			ПараметрыВыполнения.Доступно = Ложь;
			ПараметрыВыполнения.ПояснениеНедоступности = ПояснениеДокументНеПроведен();
			Возврат;
			
		КонецЕсли;
		
		Если ИспользоватьСтатусыЗаказовПоставщикам
			И ДанныеДокумента.Статус = Перечисления.СтатусыЗаказовПоставщикам.НеСогласован Тогда
			
			ПараметрыВыполнения.Доступно = Ложь;
			ПараметрыВыполнения.ПояснениеНедоступности = ПояснениеЗаказПоставщикуНеСогласован();
			
		КонецЕсли;
		
	ИначеЕсли КатегорияКоманды = Перечисления.КатегорииКомандСервисаEDI.ПодтверждениеВыполнения Тогда
		
		Если Не ДанныеДокумента.Проведен Тогда
			
			ПараметрыВыполнения.Доступно = Ложь;
			ПараметрыВыполнения.ПояснениеНедоступности = ПояснениеДокументНеПроведен();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
	
Функция ДанныеЗаказаПоставщикуДляПроверкиВыполненияКоманды(ПрикладнойОбъект)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗаказПоставщику.Проведен КАК Проведен,
	|	ЗаказПоставщику.Статус   КАК Статус
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	|ГДЕ
	|	ЗаказПоставщику.Ссылка = &ПрикладнойОбъект";
	
	Запрос.УстановитьПараметр("ПрикладнойОбъект", ПрикладнойОбъект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

#КонецОбласти

#Область ЗаказКлиента

Процедура ПередВыполнениеКомандыСервисаЗаказКлиента(ПараметрыВыполнения) Экспорт
	
	ДанныеДокумента = ДанныеЗаказаКлиентаДляПроверкиВыполненияКоманды(ПараметрыВыполнения.ПрикладнойОбъект);
	
	КатегорияКоманды = ПараметрыВыполнения.КатегорияКоманды;
	
	Если КатегорияКоманды = Перечисления.КатегорииКомандСервисаEDI.Согласование Тогда
		
		Если Не ДанныеДокумента.Проведен Тогда
			
			ПараметрыВыполнения.Доступно = Ложь;
			ПараметрыВыполнения.ПояснениеНедоступности = ПояснениеДокументНеПроведен();
			Возврат;
			
		КонецЕсли;
		
		Если  ДанныеДокумента.Статус = Перечисления.СтатусыЗаказовКлиентов.НеСогласован Тогда
			
			Отказ = Ложь;
			ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ПараметрыВыполнения.ПрикладнойОбъект, Отказ);
			
			Если Отказ Тогда
				ПараметрыВыполнения.Доступно = Ложь;
				ПараметрыВыполнения.ПояснениеНедоступности = НСтр("ru = 'Нарушены условия продажи и нет прав на отклонение.'");
			КонецЕсли;

		КонецЕсли;
		
	ИначеЕсли КатегорияКоманды = Перечисления.КатегорииКомандСервисаEDI.ПодтверждениеВыполнения Тогда
		
		Если Не ДанныеДокумента.Проведен Тогда
			
			ПараметрыВыполнения.Доступно = Ложь;
			ПараметрыВыполнения.ПояснениеНедоступности = ПояснениеДокументНеПроведен();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДанныеЗаказаКлиентаДляПроверкиВыполненияКоманды(ПрикладнойОбъект)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗаказКлиента.Проведен КАК Проведен,
	|	ЗаказКлиента.Статус   КАК Статус
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка = &ПрикладнойОбъект";
	
	Запрос.УстановитьПараметр("ПрикладнойОбъект", ПрикладнойОбъект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

#КонецОбласти

Функция ПояснениеДокументНеПроведен()
	
	Возврат НСтр("ru = 'Документ не проведен, выполнение команды не доступно.'")
	
КонецФункции

Функция ПояснениеЗаказПоставщикуНеСогласован()
	
	Возврат НСтр("ru = 'Документ должен находится в статусе ""Согласован"", выполнение команды не доступно.'")
	
КонецФункции

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

Функция МенеджерКонтрагента(Знач Контрагент)
	
	Результат = Пользователи.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Контрагент);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА БизнесРегионы.ОсновнойМенеджер ЕСТЬ NULL
	|			ТОГДА Партнеры.ОсновнойМенеджер
	|		ИНАЧЕ БизнесРегионы.ОсновнойМенеджер
	|	КОНЕЦ КАК ОсновнойМенеджер
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БизнесРегионы КАК БизнесРегионы
	|			ПО Партнеры.БизнесРегион = БизнесРегионы.Ссылка
	|		ПО Контрагенты.Партнер = Партнеры.Ссылка
	|ГДЕ
	|	Контрагенты.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	ОсновнойМенеджер = РезультатЗапроса.Выгрузить()[0].ОсновнойМенеджер;
	Если ЗначениеЗаполнено(ОсновнойМенеджер) Тогда
		Результат = ОсновнойМенеджер;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти


