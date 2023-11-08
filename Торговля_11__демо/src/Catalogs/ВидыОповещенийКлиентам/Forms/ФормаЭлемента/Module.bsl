#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НеобходимаНастройкаРегламентногоЗадания Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("Расписание", Расписание);
		ТекущийОбъект.ДополнительныеСвойства.Вставить("Использование", РегламентноеЗаданиеИспользуется);
	Иначе
		Если Объект.РегламентноеЗадание <> Неопределено Тогда
			ТекущийОбъект.ДополнительныеСвойства.Вставить("УдалениеРегламентногоЗадания", Истина);
		КонецЕсли;
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаРассылокИОповещенийПриИзменении(Элемент)
	
	ГруппаРассылокИОповещенийПриИзмененииНаСервере();
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСобытияПриИзменении(Элемент)
	
	ТипСобытияПриИзмененииНаСервере(Истина);
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяУсловиеОтправкиПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредназначенаДляЭлектронныхПисемПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредназначенаДляSMSПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ДиалогРасписания.Показать(Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект, Новый Структура("ДиалогРасписания", ДиалогРасписания)));
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание1, ДополнительныеПараметры) Экспорт
	
	ДиалогРасписания = ДополнительныеПараметры.ДиалогРасписания;
	
	Если Расписание1 <> Неопределено Тогда
		
		Модифицированность = Истина;
		Расписание         = ДиалогРасписания.Расписание;
		Если РазделениеВключено 
			И Расписание.ПериодПовтораВТечениеДня > 0
			И Расписание.ПериодПовтораВТечениеДня < 3600 Тогда
			
			Расписание.ПериодПовтораВТечениеДня = 3600;
			
		КонецЕсли;
		РасписаниеСтрокой  = Строка(Расписание);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФормулу(Команда)
	
	Если Не ДанныеДляРасчетаФормулыИнициализированы Тогда
		ПостроитьДеревоОператоров();
		ДанныеДляРасчетаФормулыИнициализированы = Истина;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДеревоОперандов", ДеревоОперандовКонструктораФормул());
	
	ПараметрыФормы.Вставить("Формула", Объект.УсловиеОтправки);
	ПараметрыФормы.Вставить("Операторы", АдресХранилищаДереваОператоров);
	ПараметрыФормы.Вставить("ТипРезультата", Новый ОписаниеТипов("Булево"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОткрытияКонструктораУстановитьФормулуУсловия",ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ОткрытьФорму("ОбщаяФорма.КонструкторФормул", ПараметрыФормы, ЭтаФорма,,,,ОписаниеОповещения,Режим);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДеревоОперандовКонструктораФормул()
	
	Дерево = РаботаСФормулами.ПолучитьПустоеДеревоОперандов();
	
	ТипСобытийОповещений = Объект.ТипСобытия;
	МакетСКД = Перечисления.ТипыСобытийОповещений.ПолучитьМакет(
		ТипСобытийОповещений.Метаданные().ЗначенияПеречисления.Получить(Перечисления.ТипыСобытийОповещений.Индекс(ТипСобытийОповещений)).Имя);
	
	ДопОграничения = РаботаСФормулами.ОграниченияРазверткиОперандов();
	ДопОграничения.РекурсивноРазворачиватьОперандыСхемыКомпоновки = Ложь;
	
	ТипыЭлементов = РаботаСФормулами.ТипыЭлементовДереваОперандов();
	
	ГруппаСтрок = РаботаСФормулами.НоваяСтрокаДереваОперанда(Дерево);
	ГруппаСтрок.Идентификатор = "ПредыдущееСообщение";
	ГруппаСтрок.Представление = НСтр("ru = 'Предыдущее сообщение'");
	ГруппаСтрок.ТипЭлементаДерева = ТипыЭлементов.ГруппаСтрокВерхнегоУровня;
	ГруппаСтрок.РазрешаетсяВыборОперанда = Ложь;
	ГруппаСтрок.ВключаетсяВИдентификатор = Истина;
	
	РаботаСФормулами.ДобавитьВДеревоДоступныеПоляПоСхемеКомпоновки(ГруппаСтрок, МакетСКД, ДопОграничения);
	
	
	ГруппаСтрок = РаботаСФормулами.НоваяСтрокаДереваОперанда(Дерево);
	ГруппаСтрок.Идентификатор = "ТекущееСообщение";
	ГруппаСтрок.Представление = НСтр("ru = 'Текущее сообщение'");
	ГруппаСтрок.ТипЭлементаДерева = ТипыЭлементов.ГруппаСтрокВерхнегоУровня;
	ГруппаСтрок.РазрешаетсяВыборОперанда = Ложь;
	ГруппаСтрок.ВключаетсяВИдентификатор = Истина;
	
	РаботаСФормулами.ДобавитьВДеревоДоступныеПоляПоСхемеКомпоновки(ГруппаСтрок, МакетСКД, ДопОграничения);
	
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Дерево, УникальныйИдентификатор);
	Возврат АдресХранилища;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЗаполнитьСписокВыбораСобытий();
	ГруппаРассылокИОповещенийПриИзмененииНаСервере(Истина);
	ТипСобытияПриИзмененииНаСервере(Ложь);
	СегментыСервер.ПолучитьРасписаниеРегламентногоЗадания(ЭтаФорма);
	
	УправлениеДоступностью(ЭтаФорма);
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ИспользоватьПрочиеВзаимодействия       = ПолучитьФункциональнуюОпцию("ИспользоватьПрочиеВзаимодействия");
	Элементы.ПредназначенаДляSMS.Видимость = ИспользоватьПрочиеВзаимодействия;
	Элементы.ШаблонСообщенияSMS.Видимость  = ИспользоватьПрочиеВзаимодействия;
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.ШаблоныСообщений) Тогда
		
		Элементы.СтраницыНазначение.ТекущаяСтраница = Элементы.СтраницаНетПравНаШаблоны;
		ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)

	Форма.Элементы.ИспользуетсяУсловиеОтправки.Доступность = ЗначениеЗаполнено(Форма.Объект.ТипСобытия);
	Форма.Элементы.СтраницаРасписание.Доступность          = Форма.НеобходимаНастройкаРегламентногоЗадания;
	Форма.Элементы.УсловиеОтправки.Доступность             = Форма.Объект.ИспользуетсяУсловиеОтправки;
	Форма.Элементы.ИзменитьФормулу.Доступность             = Форма.Объект.ИспользуетсяУсловиеОтправки;
	
	ДоступностьЭлементовПочта = Форма.ДоступнаОтправкаПоПочте ИЛИ Форма.Объект.ПредназначенаДляЭлектронныхПисем;
	ДоступностьЭлементовSMS   = Форма.ДоступнаОтправкаПоSMS   ИЛИ Форма.Объект.ПредназначенаДляSMS;
	
	Форма.Элементы.ПредназначенаДляЭлектронныхПисем.Доступность = ДоступностьЭлементовПочта;
	Форма.Элементы.ШаблонЭлектронногоПисьма.Доступность         = ДоступностьЭлементовПочта 
	                                                              И Форма.Объект.ПредназначенаДляЭлектронныхПисем;
	
	Форма.Элементы.ПредназначенаДляSMS.Доступность = ДоступностьЭлементовSMS;
	Форма.Элементы.ШаблонСообщенияSMS.Доступность  = ДоступностьЭлементовSMS
	                                                 И Форма.Объект.ПредназначенаДляSMS;

КонецПроцедуры

&НаСервере
Процедура ГруппаРассылокИОповещенийПриИзмененииНаСервере(ЧтениеСуществующего = Ложь)
	
	Если ЗначениеЗаполнено(Объект.ГруппаРассылокИОповещений) Тогда
		РеквизитыГруппы = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ГруппаРассылокИОповещений, "ПредназначенаДляЭлектронныхПисем, ПредназначенаДляSMS");
		ДоступнаОтправкаПоПочте = РеквизитыГруппы.ПредназначенаДляЭлектронныхПисем;
		ДоступнаОтправкаПоSMS   = РеквизитыГруппы.ПредназначенаДляSMS;
	Иначе
		ДоступнаОтправкаПоПочте = Ложь;
		ДоступнаОтправкаПоSMS   = Ложь;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() ИЛИ НЕ ЧтениеСуществующего  Тогда 
		Если ДоступнаОтправкаПоSMS И Не ДоступнаОтправкаПоПочте Тогда
			Объект.ПредназначенаДляSMS = Истина;
			Объект.ПредназначенаДляЭлектронныхПисем = Ложь;
		ИначеЕсли ДоступнаОтправкаПоПочте И НЕ ДоступнаОтправкаПоSMS Тогда
			Объект.ПредназначенаДляSMS = Ложь;
			Объект.ПредназначенаДляЭлектронныхПисем = Истина;
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Процедура ТипСобытияПриИзмененииНаСервере(ПроверятьИзменениеТипаСобытия)
	
	ПредыдущееПолноеИмяТипаСобытия = ПолноеИмяТипаСобытия;
	
	НеобходимаНастройкаРегламентногоЗадания = Перечисления.ТипыСобытийОповещений.ТребуетсяНастройкаРегламентногоЗадания(Объект.ТипСобытия);
	Если ЗначениеЗаполнено(Объект.ТипСобытия) Тогда
		МетаданныеПеречисления = Объект.ТипСобытия.Метаданные();
		ПолноеИмяТипаСобытия = МетаданныеПеречисления.ЗначенияПеречисления.Получить(Перечисления.ТипыСобытийОповещений.Индекс(Объект.ТипСобытия)).Имя;
	Иначе
		ПолноеИмяТипаСобытия = "";
	КонецЕсли;
	
	Если ПроверятьИзменениеТипаСобытия И ПредыдущееПолноеИмяТипаСобытия <> ПолноеИмяТипаСобытия Тогда
		Объект.ШаблонСообщенияSMS = Справочники.ШаблоныСообщений.ПустаяСсылка();
		Объект.ШаблонЭлектронногоПисьма = Справочники.ШаблоныСообщений.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияКонструктораУстановитьФормулуУсловия(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> Объект.УсловиеОтправки Тогда
		Объект.УсловиеОтправки = Результат;
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПостроитьДеревоОператоров()
	
	ПараметрыОператоров = Новый Структура;
	ПараметрыОператоров.Вставить("СтандартныеОператоры", Истина);
	ПараметрыОператоров.Вставить("ЛогическиеОператоры", Истина);
	ПараметрыОператоров.Вставить("Функции", Истина);
	
	АдресХранилищаДереваОператоров = РаботаСФормулами.ПостроитьДеревоОператоров(ПараметрыОператоров, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораСобытий()

	Для Каждого ЗначениеПеречисления Из Перечисления.ТипыСобытийОповещений.ИзменениеСостоянияЗаказа.Метаданные().ЗначенияПеречисления Цикл
		
		Если Объект.ТипСобытия <> Перечисления.ТипыСобытийОповещений[ЗначениеПеречисления.Имя] Тогда
			Если НЕ Перечисления.ТипыСобытийОповещений.ДанныеДляОбработкиОчередиОповещений(Перечисления.ТипыСобытийОповещений[ЗначениеПеречисления.Имя]).ДоступноДляИспользования Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
			
		Элементы.ТипСобытия.СписокВыбора.Добавить(Перечисления.ТипыСобытийОповещений[ЗначениеПеречисления.Имя],ЗначениеПеречисления.Синоним);
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

