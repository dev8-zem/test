
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

# Область ПрограммныйИнтерфейс

#Если НЕ МобильныйАвтономныйСервер Тогда

// Процедура сохраняет сформированный отчет в виде мокселя в регистр сведений ОбновляемыеРезультатыОтчетов
//
// Параметры:
//  РезультатОтчета - ТабличныйДокумент - моксель отчета
//  НастрокиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура СохранитьОфлайнОтчет(РезультатОтчета, НастройкиОтчета) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ОбновляемыеРезультатыОтчетов.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Пользователь = Пользователи.ТекущийПользователь();
	МенеджерЗаписи.Отчет = НастройкиОтчета.ОтчетСсылка;
	МенеджерЗаписи.Вариант = НастройкиОтчета.ВариантСсылка;
	
	МенеджерЗаписи.ХешПользовательскойНастройки = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(
		НастройкиОтчета.СвойстваРезультата.КомпоновщикНастроек.ПользовательскиеНастройки);
	МенеджерЗаписи.ПользовательскаяНастройка = Новый ХранилищеЗначения(НастройкиОтчета.СвойстваРезультата.КомпоновщикНастроек.ПользовательскиеНастройки);

	МенеджерЗаписи.РезультатОтчета = Новый ХранилищеЗначения(РезультатОтчета);
	МенеджерЗаписи.ДатаАктуальности = ТекущаяДатаСеанса();
	МенеджерЗаписи.ДатаПоследнегоПросмотра = ТекущаяДатаСеанса();
	
	МенеджерЗаписи.Записать();

КонецПроцедуры

// Процедура обновляет офлайн отчеты пользователя
//
// Параметры:
//  ПараметрыЗаполнения - Структура:
//   Пользователь - СправочникСсылка.Пользователи - пользователь, для которого обновляются офлайн отчеты
//   ОфлайнОтчеты - ТаблицаЗначений:
//    Пользователь - СправочникСсылка.Пользователи
//    Отчет - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//    Вариант - СправочникСсылка.ВариантыОтчетов
//    ХешПользовательскойНастройки - Число
//   ВыводитьДашбордыМЦП - Булево - если Истина, то обновляется отчет Монитор целевых показателей
//  АдресХранилища - Строка - Используется для возможности выполнения в фоновом задании.
Процедура ОбновитьОфлайнОтчетыПользователя(ПараметрыЗаполнения, АдресХранилища) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Замер = ОценкаПроизводительности.НачатьЗамерДлительнойОперации("ОбновитьОфлайнОтчетыПользователя");
	
	ОбновитьДашбордыМЦП = ПараметрыЗаполнения.Свойство("ОбновитьДашбордыМЦП")
		И ПараметрыЗаполнения.ОбновитьДашбордыМЦП;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", ПараметрыЗаполнения.Пользователь);
	Если ПараметрыЗаполнения.Свойство("ОфлайнОтчеты") Тогда
		Запрос.УстановитьПараметр("ОфлайнОтчеты", ПараметрыЗаполнения.ОфлайнОтчеты);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОфлайнОтчеты.Пользователь КАК Пользователь,
		|	ОфлайнОтчеты.Отчет КАК Отчет,
		|	ОфлайнОтчеты.Вариант КАК Вариант,
		|	ОфлайнОтчеты.ХешПользовательскойНастройки КАК ХешПользовательскойНастройки
		|ПОМЕСТИТЬ ОфлайнОтчеты
		|ИЗ
		|	&ОфлайнОтчеты КАК ОфлайнОтчеты
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Пользователь,
		|	Отчет,
		|	Вариант,
		|	ХешПользовательскойНастройки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОбновляемыеРезультатыОтчетов.Пользователь КАК Пользователь,
		|	ОбновляемыеРезультатыОтчетов.Отчет КАК Отчет,
		|	ОбновляемыеРезультатыОтчетов.Вариант КАК Вариант,
		|	ОбновляемыеРезультатыОтчетов.Вариант.КлючВарианта КАК КлючВарианта,
		|	ОбновляемыеРезультатыОтчетов.ХешПользовательскойНастройки КАК ХешПользовательскойНастройки,
		|	ОбновляемыеРезультатыОтчетов.ПользовательскаяНастройка КАК ПользовательскаяНастройка
		|ИЗ
		|	РегистрСведений.ОбновляемыеРезультатыОтчетов КАК ОбновляемыеРезультатыОтчетов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОфлайнОтчеты КАК ОфлайнОтчеты
		|		ПО ОбновляемыеРезультатыОтчетов.Пользователь = ОфлайнОтчеты.Пользователь
		|			И ОбновляемыеРезультатыОтчетов.Отчет = ОфлайнОтчеты.Отчет
		|			И ОбновляемыеРезультатыОтчетов.Вариант = ОфлайнОтчеты.Вариант
		|			И ОбновляемыеРезультатыОтчетов.ХешПользовательскойНастройки = ОфлайнОтчеты.ХешПользовательскойНастройки
		|ГДЕ
		|	ОбновляемыеРезультатыОтчетов.Пользователь = &Пользователь
		|	И ОбновляемыеРезультатыОтчетов.Вариант ССЫЛКА Справочник.ВариантыОтчетов";
	Иначе	
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбновляемыеРезультатыОтчетов.Пользователь КАК Пользователь,
		|	ОбновляемыеРезультатыОтчетов.Отчет КАК Отчет,
		|	ОбновляемыеРезультатыОтчетов.Вариант КАК Вариант,
		|	ОбновляемыеРезультатыОтчетов.Вариант.КлючВарианта КАК КлючВарианта,
		|	ОбновляемыеРезультатыОтчетов.ХешПользовательскойНастройки КАК ХешПользовательскойНастройки,
		|	ОбновляемыеРезультатыОтчетов.ПользовательскаяНастройка КАК ПользовательскаяНастройка
		|ИЗ
		|	РегистрСведений.ОбновляемыеРезультатыОтчетов КАК ОбновляемыеРезультатыОтчетов
		|ГДЕ
		|	ОбновляемыеРезультатыОтчетов.Пользователь = &Пользователь
		|	И ОбновляемыеРезультатыОтчетов.Вариант ССЫЛКА Справочник.ВариантыОтчетов";
	КонецЕсли;
	Если ОбновитьДашбордыМЦП Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВариантыОтчетов", "ДашбордыМЦП");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтруктураПараметров = Новый Структура;
	
	Пока Выборка.Следующий() Цикл
	
		МенеджерЗаписи = РегистрыСведений.ОбновляемыеРезультатыОтчетов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка, "Пользователь, Отчет, Вариант, ХешПользовательскойНастройки");
	
		СтруктураПараметров.Очистить();
		СтруктураПараметров.Вставить("СсылкаВарианта", Выборка.Вариант);
		СтруктураПараметров.Вставить("СсылкаОтчета", Выборка.Отчет);
		СтруктураПараметров.Вставить("КлючВарианта", Выборка.КлючВарианта);
		СтруктураПараметров.Вставить("ПользовательскиеНастройкиКД", Выборка.ПользовательскаяНастройка.Получить());
		Если ОбновитьДашбордыМЦП Тогда
			КлючВарианта = "МониторЦелевыхПоказателей";
			СтруктураПараметров.Вставить("КлючВарианта", КлючВарианта);
			СтруктураПараметров.Вставить("ВариантСсылка", ВариантыОтчетов.ВариантОтчета(Выборка.Отчет, КлючВарианта));
		КонецЕсли;
		
		Формирование = ВариантыОтчетов.СформироватьОтчет(СтруктураПараметров, Истина, Ложь);
		
		Если Не Формирование.Успех Тогда
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление офлайн-отчетов'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Выборка.Отчет),
			Выборка.Вариант,
			Формирование.ТекстОшибки);
		КонецЕсли;
		
		МенеджерЗаписи.РезультатОтчета = Новый ХранилищеЗначения(Формирование.ТабличныйДокумент, Новый СжатиеДанных);
		МенеджерЗаписи.ПользовательскаяНастройка = Выборка.ПользовательскаяНастройка;
		МенеджерЗаписи.ДатаАктуальности = ТекущаяДатаСеанса();
		МенеджерЗаписи.ДатаПоследнегоПросмотра = ТекущаяДатаСеанса();
		МенеджерЗаписи.ОшибкаОбновленияОтчета = Не Формирование.Успех;
		МенеджерЗаписи.Записать();
	
	КонецЦикла;
	
	ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(Замер, Выборка.Количество());

КонецПроцедуры

#КонецЕсли

// Функция возращает список офлайн отчетов пользователя
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - пользователь, для которого формируется список офлайн отчетов
//  ВыводитьДашбордыМЦП - Булево - Истина, если необходимо получить список офлайн отчетов по МЦП
// Возвращаемое значение:
//  ТаблицаЗначений:
//  * Пользователь - СправочникСсылка.Пользователи - пользователь офлайн отчета
//  * Отчет - СправочникСсылка.ИдентификаторыОбъектовМетаданных - идентификатор отчета
//  * Вариант - СправочникСсылка.ВариантыОтчетов, СправочникСсылка.ДашбордыМЦП - вариант отчета или дашборд МЦП
//  * НаименованиеВарианта - Строка - наименование варианта отчета или дашборда МЦП (для автономного режима)
//  * ХешПользовательскойНастройки - Число  - хеш-сумма пользовательской настройки
//
Функция СписокОфлайнОтчетовПользователя(Пользователь, ВыводитьДашбордыМЦП = Ложь) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбновляемыеРезультатыОтчетов.Пользователь КАК Пользователь,
	|	ОбновляемыеРезультатыОтчетов.Отчет КАК Отчет,
	|	ОбновляемыеРезультатыОтчетов.Вариант КАК Вариант,
	|	ОбновляемыеРезультатыОтчетов.Вариант.Наименование КАК НаименованиеВарианта,
	|	ОбновляемыеРезультатыОтчетов.ХешПользовательскойНастройки КАК ХешПользовательскойНастройки,
	|	ОбновляемыеРезультатыОтчетов.ДатаАктуальности КАК ДатаАктуальности
	|ИЗ
	|	РегистрСведений.ОбновляемыеРезультатыОтчетов КАК ОбновляемыеРезультатыОтчетов
	|ГДЕ
	|	ОбновляемыеРезультатыОтчетов.Пользователь = &Пользователь
	|	И ОбновляемыеРезультатыОтчетов.Вариант ССЫЛКА Справочник.ВариантыОтчетов
	|	И НЕ ОбновляемыеРезультатыОтчетов.Вариант.Наименование ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаАктуальности";
	Если ВыводитьДашбордыМЦП Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВариантыОтчетов", "ДашбордыМЦП");
	КонецЕсли;

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю, Отказ = Ложь) Экспорт

	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Сообщить();

	Отказ = Истина;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
