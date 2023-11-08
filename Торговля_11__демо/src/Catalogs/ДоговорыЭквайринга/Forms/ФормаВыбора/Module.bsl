#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	НастроитьСписок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьСписок()

	ТекстЗапроса = ТекстЗапросаСписка();
		
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса					= ТекстЗапроса;
	СвойстваСписка.ОсновнаяТаблица				= "Справочник.ДоговорыЭквайринга";
	СвойстваСписка.ДинамическоеСчитываниеДанных	= Истина;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
	НастроитьСписокЛокализация();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьСписокЛокализация()

	//++ Локализация
	Список.Параметры.УстановитьЗначениеПараметра("СписокДоговоров", 
				РегистрыСведений.НастройкиИнтеграцииСПлатежнымиСистемамиУТ.ДействующиеДоговораСНастройкамиИнтеграции().ВыгрузитьКолонку("Договор"));
	
	//-- Локализация
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстЗапросаСписка()

	ТекстЗапроса = "ВЫБРАТЬ
	               |	СправочникДоговорыЭквайринга.Ссылка КАК Ссылка,
	               |	СправочникДоговорыЭквайринга.ПометкаУдаления КАК ПометкаУдаления,
	               |	СправочникДоговорыЭквайринга.Код КАК Код,
	               |	СправочникДоговорыЭквайринга.Наименование КАК Наименование,
	               |	СправочникДоговорыЭквайринга.Номер КАК Номер,
	               |	СправочникДоговорыЭквайринга.Дата КАК Дата,
	               |	СправочникДоговорыЭквайринга.Статус КАК Статус,
	               |	СправочникДоговорыЭквайринга.Согласован КАК Согласован,
	               |	СправочникДоговорыЭквайринга.Организация КАК Организация,
	               |	СправочникДоговорыЭквайринга.Подразделение КАК Подразделение,
	               |	СправочникДоговорыЭквайринга.БанковскийСчет КАК БанковскийСчет,
	               |	СправочникДоговорыЭквайринга.Ответственный КАК Ответственный,
	               |	СправочникДоговорыЭквайринга.Партнер КАК Партнер,
	               |	СправочникДоговорыЭквайринга.Контрагент КАК Контрагент,
	               |	СправочникДоговорыЭквайринга.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента,
	               |	СправочникДоговорыЭквайринга.КонтактноеЛицо КАК КонтактноеЛицо,
	               |	СправочникДоговорыЭквайринга.ИспользуютсяЭквайринговыеТерминалы КАК ИспользуютсяЭквайринговыеТерминалы,
	               |	СправочникДоговорыЭквайринга.ДетальнаяСверкаТранзакций КАК ДетальнаяСверкаТранзакций,
	               |	СправочникДоговорыЭквайринга.РазрешитьПлатежиБезУказанияЗаявок КАК РазрешитьПлатежиБезУказанияЗаявок,
	               |	СправочникДоговорыЭквайринга.СрокИсполненияПлатежа КАК СрокИсполненияПлатежа,
	               |	СправочникДоговорыЭквайринга.ФиксированнаяСтавкаКомиссии КАК ФиксированнаяСтавкаКомиссии,
	               |	СправочникДоговорыЭквайринга.СтавкаКомиссии КАК СтавкаКомиссии,
	               |	СправочникДоговорыЭквайринга.СпособОтраженияКомиссии КАК СпособОтраженияКомиссии,
	               |	СправочникДоговорыЭквайринга.ВзимаетсяКомиссияПриВозврате КАК ВзимаетсяКомиссияПриВозврате,
	               |	СправочникДоговорыЭквайринга.СтатьяДвиженияДенежныхСредствПоступлениеОплаты КАК СтатьяДвиженияДенежныхСредствПоступлениеОплаты,
	               |	СправочникДоговорыЭквайринга.СтатьяДвиженияДенежныхСредствВозврат КАК СтатьяДвиженияДенежныхСредствВозврат,
	               |	СправочникДоговорыЭквайринга.СтатьяДвиженияДенежныхСредствКомиссия КАК СтатьяДвиженияДенежныхСредствКомиссия,
	               |	СправочникДоговорыЭквайринга.НаправлениеДеятельности КАК НаправлениеДеятельности,
	               |	СправочникДоговорыЭквайринга.СтатьяРасходов КАК СтатьяРасходов,
	               |	СправочникДоговорыЭквайринга.АналитикаРасходов КАК АналитикаРасходов,
	               |	СправочникДоговорыЭквайринга.ПодразделениеРасходов КАК ПодразделениеРасходов,
	               |	СправочникДоговорыЭквайринга.Комментарий КАК Комментарий,
	               |	СправочникДоговорыЭквайринга.СпособПроведенияПлатежа КАК СпособПроведенияПлатежа,
	               |	ЛОЖЬ КАК ЕстьНастройкаИнтеграции
	               |{ВЫБРАТЬ
	               |	ЕстьНастройкаИнтеграции}
	               |ИЗ
	               |	Справочник.ДоговорыЭквайринга КАК СправочникДоговорыЭквайринга
	               |{ГДЕ
	               |	(ЛОЖЬ) КАК ЕстьНастройкаИнтеграции}";
	
	ТекстЗапроса = ТекстЗапросаСпискаЛокализация(ТекстЗапроса);
	
    Возврат ТекстЗапроса
КонецФункции

&НаСервереБезКонтекста
Функция ТекстЗапросаСпискаЛокализация(ЗНАЧ ТекстЗапроса)

	//++ Локализация
	ТекстЗапроса = "ВЫБРАТЬ
	|	ДействующиеДоговораСНастройкамиИнтеграции.Ссылка КАК Договор,
	|	ИСТИНА КАК ЕстьНастройкаИнтеграции
	|ПОМЕСТИТЬ ДействующиеДоговораСНастройкамиИнтеграции
	|ИЗ
	|	Справочник.ДоговорыЭквайринга КАК ДействующиеДоговораСНастройкамиИнтеграции
	|ГДЕ
	|	ДействующиеДоговораСНастройкамиИнтеграции.Ссылка В (&СписокДоговоров)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Договор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СправочникДоговорыЭквайринга.Ссылка КАК Ссылка,
	|	СправочникДоговорыЭквайринга.ПометкаУдаления КАК ПометкаУдаления,
	|	СправочникДоговорыЭквайринга.Код КАК Код,
	|	СправочникДоговорыЭквайринга.Наименование КАК Наименование,
	|	СправочникДоговорыЭквайринга.Номер КАК Номер,
	|	СправочникДоговорыЭквайринга.Дата КАК Дата,
	|	СправочникДоговорыЭквайринга.Статус КАК Статус,
	|	СправочникДоговорыЭквайринга.Согласован КАК Согласован,
	|	СправочникДоговорыЭквайринга.Организация КАК Организация,
	|	СправочникДоговорыЭквайринга.Подразделение КАК Подразделение,
	|	СправочникДоговорыЭквайринга.БанковскийСчет КАК БанковскийСчет,
	|	СправочникДоговорыЭквайринга.Ответственный КАК Ответственный,
	|	СправочникДоговорыЭквайринга.Партнер КАК Партнер,
	|	СправочникДоговорыЭквайринга.Контрагент КАК Контрагент,
	|	СправочникДоговорыЭквайринга.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента,
	|	СправочникДоговорыЭквайринга.КонтактноеЛицо КАК КонтактноеЛицо,
	|	СправочникДоговорыЭквайринга.ИспользуютсяЭквайринговыеТерминалы КАК ИспользуютсяЭквайринговыеТерминалы,
	|	СправочникДоговорыЭквайринга.ДетальнаяСверкаТранзакций КАК ДетальнаяСверкаТранзакций,
	|	СправочникДоговорыЭквайринга.РазрешитьПлатежиБезУказанияЗаявок КАК РазрешитьПлатежиБезУказанияЗаявок,
	|	СправочникДоговорыЭквайринга.СрокИсполненияПлатежа КАК СрокИсполненияПлатежа,
	|	СправочникДоговорыЭквайринга.ФиксированнаяСтавкаКомиссии КАК ФиксированнаяСтавкаКомиссии,
	|	СправочникДоговорыЭквайринга.СтавкаКомиссии КАК СтавкаКомиссии,
	|	СправочникДоговорыЭквайринга.СпособОтраженияКомиссии КАК СпособОтраженияКомиссии,
	|	СправочникДоговорыЭквайринга.ВзимаетсяКомиссияПриВозврате КАК ВзимаетсяКомиссияПриВозврате,
	|	СправочникДоговорыЭквайринга.СтатьяДвиженияДенежныхСредствПоступлениеОплаты КАК
	|		СтатьяДвиженияДенежныхСредствПоступлениеОплаты,
	|	СправочникДоговорыЭквайринга.СтатьяДвиженияДенежныхСредствВозврат КАК СтатьяДвиженияДенежныхСредствВозврат,
	|	СправочникДоговорыЭквайринга.СтатьяДвиженияДенежныхСредствКомиссия КАК СтатьяДвиженияДенежныхСредствКомиссия,
	|	СправочникДоговорыЭквайринга.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	СправочникДоговорыЭквайринга.СтатьяРасходов КАК СтатьяРасходов,
	|	СправочникДоговорыЭквайринга.АналитикаРасходов КАК АналитикаРасходов,
	|	СправочникДоговорыЭквайринга.ПодразделениеРасходов КАК ПодразделениеРасходов,
	|	СправочникДоговорыЭквайринга.Комментарий КАК Комментарий,
	|	СправочникДоговорыЭквайринга.СпособПроведенияПлатежа КАК СпособПроведенияПлатежа,
	|	ЕСТЬNULL(НастройкиИнтеграции.ЕстьНастройкаИнтеграции, ЛОЖЬ) КАК ЕстьНастройкаИнтеграции
	|{ВЫБРАТЬ
	|	ЕстьНастройкаИнтеграции}
	|ИЗ
	|	Справочник.ДоговорыЭквайринга КАК СправочникДоговорыЭквайринга
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДействующиеДоговораСНастройкамиИнтеграции КАК НастройкиИнтеграции
	|		ПО СправочникДоговорыЭквайринга.Ссылка = НастройкиИнтеграции.Договор
	|{ГДЕ
	|	(ЕСТЬNULL(НастройкиИнтеграции.ЕстьНастройкаИнтеграции, ЛОЖЬ)) КАК ЕстьНастройкаИнтеграции}";
		
	//-- Локализация
    Возврат ТекстЗапроса
КонецФункции

#КонецОбласти