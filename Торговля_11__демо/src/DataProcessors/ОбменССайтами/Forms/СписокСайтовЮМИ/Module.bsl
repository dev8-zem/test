
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 
	ОбновитьСодержание();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ОткрытьСписок(Элемент)
	
	ОткрытьФорму("Справочник.Сайты.ФормаСписка");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСайтовПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ДанныеСобытия) И (
		(ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеСобытия.Element,"text") И ДанныеСобытия.Element.text="Настроить")
		ИЛИ (ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеСобытия.Element,"innerText") И ДанныеСобытия.Element.innerText="Настроить")
		ИЛИ (ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеСобытия.Element,"textContent") И ДанныеСобытия.Element.textContent="Настроить")
		ИЛИ (ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеСобытия.Element,"outerText") И ДанныеСобытия.Element.outerText="Настроить")) Тогда
		ОткрытьФорму("Справочник.Сайты.ФормаОбъекта", 
			Новый Структура("Ключ", ПолучитьСсылкуПоКоду(ДанныеСобытия.Element.nameProp))
			,ЭтотОбъект,,,, 
			Новый ОписаниеОповещения("ПослеНастройкиСайта", ЭтотОбъект));
	ИначеЕсли ЗначениеЗаполнено(ДанныеСобытия) И ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ДанныеСобытия.Href);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеНастройкиСайта(Результат, ДополнительныеПараметры) Экспорт

	ОбновитьСодержание();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСодержание()

	ТекстСтраницы = "
	|<html>
	|<head>
	|<meta http-equiv=Content-Type content=""text/html; charset=windows-1251"">
	|<style>
	|html { overflow:  auto; }
	|</style>
	|</head>
	|<body>
	|<div>
	|<table border=0 cellspacing=0 cellpadding=0 width=""80%""
	|style='border-collapse:collapse'>
	
	|<tr>
	|<td width=""25%"">
	|<p  align=center style='text-align:center'><span
	|style='font-size:16pt'></span></p>
	|</td>
	|<td width=""50%"">
	|<p  align=center style='text-align:center'><span
	|style='font-size:16pt'>Сайт</span></p>
	|</td>
	|<td width=""25%"">
	|<p  align=center style='text-align:center'><span
	|style='font-size:16pt'></span></p>
	|</td>
	|</tr>
	|";
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеСайта.Организация,
	|	ДанныеСайта.Ссылка КАК Ссылка,
	|	ДанныеСайта.АдресСайта КАК АдресСайта,
	|	ДанныеСайта.Наименование КАК Наименование,
	|	ДанныеСайта.Код,
	|	ДанныеСайта.ИмяПользователя,
	|	ДанныеСайта.ТипСайта,
	|	ДанныеСайта.URLАдминЗоны,
	|	ДанныеСайта.ПометкаУдаления КАК СайтСоздан
	|ИЗ
	|	Справочник.Сайты КАК ДанныеСайта
	|ГДЕ
	|	НЕ ДанныеСайта.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		Если Выборка.ТипСайта = 4 Тогда
			НадписьТипСайта = НСтр("ru = 'Интернет-магазин'");
		ИначеЕсли Выборка.ТипСайта = 3 Тогда
			НадписьТипСайта = НСтр("ru = 'Лендинг'");
		ИначеЕсли Выборка.ТипСайта = 2 Тогда
			НадписьТипСайта = НСтр("ru = 'Сайт компании'");
		ИначеЕсли Выборка.ТипСайта = 1 Тогда			
			НадписьТипСайта = НСтр("ru = 'Сайт специалиста'");
		КонецЕсли;
		
		ТекстНастроить = НСтр("ru = 'Настроить'");
		ТекстПерейтиВАдминзону = НСтр("ru = 'Перейти в админзону'");
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(Выборка.АдресСайта);
		Протокол = "";
		Если ПустаяСтрока(СтруктураURI.Схема) Тогда 
			Протокол = "http://";
		КонецЕсли;
		
		ТекстСтраницы = ТекстСтраницы + "
		|<tr>
		|<td height=40 width=""25%"" style='width:25%;padding:0cm 5pt 0cm 5pt'>
		|<p><span style='font-size:12pt'>"+НадписьТипСайта+"</span></p>
		|</td>
		|<td height=40 width=""50%"" style='width:50%;padding:0cm 5pt 0cm 5pt'>
		|<p  align=center style='text-align:center'>
		|<a  href="""+Протокол+Выборка.АдресСайта+""">"+СокрЛП(Выборка.Наименование)+"</a></p>
		|</td>
		|<td height=40 width=""25%"" style='width:25%;padding:0cm 5pt 0cm 5pt'>
		|<p  align=center style='text-align:center'>
		|<a  href="""+?(СокрЛП(Выборка.URLАдминЗоны)="", Выборка.Ссылка.УникальныйИдентификатор(), Выборка.URLАдминЗоны)+
		""">"+?(СокрЛП(Выборка.URLАдминЗоны)="",ТекстНастроить,ТекстПерейтиВАдминзону)+"</a></p>
		|</td>
		|</tr>
		|";

	КонецЦикла;
	
	ТекстСтраницы = ТекстСтраницы + "
	|</table>
	|<p><o:p>&nbsp;</p>
	|<p><o:p>&nbsp;</p>
	|</div>
	|</body>
	|</html>";
	
	СтраницаТипыСайтов = ТекстСтраницы;
	
	ЭлОткрытьСписок = ЭтотОбъект.Элементы.Найти("ОткрытьСписок");
	Если ЭлОткрытьСписок <> Неопределено Тогда
		ЭтотОбъект.Элементы.Удалить(ЭлОткрытьСписок);
	КонецЕсли; 
	ПолеМетки = ЭтотОбъект.Элементы.Добавить("ОткрытьСписок", Тип("ДекорацияФормы"));
	ПолеМетки.Заголовок = НСтр("ru = 'Редактировать данные сайтов'");
	ПолеМетки.РастягиватьПоГоризонтали = Истина;
	ПолеМетки.УстановитьДействие("Нажатие", "Подключаемый_ОткрытьСписок");
	
	ПолеМетки.Гиперссылка = Истина;
	Шрифт = ШрифтыСтиля.КрупныйШрифтТекста;
	ПолеМетки.Шрифт = Шрифт;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСсылкуПоКоду(КодСайта)
	
	УИДСайта = Новый УникальныйИдентификатор(КодСайта);
	Возврат Справочники.Сайты.ПолучитьСсылку(УИДСайта);
	
КонецФункции

#КонецОбласти
