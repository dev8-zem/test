
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") ИЛИ НЕ Параметры.Свойство("ДоступныеХозяйственныеОперацииИДокументы") Тогда
		Возврат;
	КонецЕсли;
	
	АдресДоступныеХозяйственныеОперацииИДокументы = Параметры.ДоступныеХозяйственныеОперацииИДокументы;
	
	РежимСоздания = Ложь;
	Если Параметры.Свойство("РежимСоздания",РежимСоздания) Тогда
		Элементы.ФормаВыбратьСоздать.Заголовок = НСтр("ru = 'Создать'");
		Заголовок = НСтр("ru = 'Создание документа по хозяйственной операции'");
		Элементы.ДеревоПоХозяйственнымОперациямОтбор.Видимость = Ложь;
		Элементы.ДеревоПоДокументамОтбор.Видимость = Ложь;
		Элементы.ФормаСнятьПометки.Видимость = Ложь;
		Элементы.ФормаУстановитьПометки.Видимость = Ложь;
	КонецЕсли;
	
	Параметры.Свойство("КлючНастроек", КлючНастроек);
	Параметры.Свойство("КлючФормы", КлючФормы);
	Параметры.Свойство("ТолькоПоТипамДокументов", ТолькоПоТипамДокументов);
	
	Если ТолькоПоТипамДокументов Тогда
		
		Иерархия = "ПоДокументам";
		Заголовок = НСтр("ru = 'Выбор документов'");
		Элементы.ФормаПоХозяйственнымОперациям.Видимость = Ложь;
		Элементы.ПоДокументам.Видимость = Ложь;

	Иначе
		
		НастройкиФормы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючНастроек+КлючФормы, РежимСоздания);
		Если ЗначениеЗаполнено(НастройкиФормы) Тогда
			Иерархия = НастройкиФормы.Иерархия;
			ТекущаяХозОперация = НастройкиФормы.ХозяйственнаяОперация;
			ТекущийИдентификаторОбъектаМетаданных = НастройкиФормы.ИдентификаторОбъектаМетаданных;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Иерархия) Тогда
			Иерархия = "ПоДокументам";
		КонецЕсли;
	
	КонецЕсли;
	
	Если Иерархия = "ПоХозОперациям" Тогда
		Элементы.СтраницыДеревоОтборов.ТекущаяСтраница = Элементы.СтраницаПоХозяйственнымОперациям;
		ЗаполнитьДеревоПоХозяйственнымОперациям();
		Элементы.ФормаПоХозяйственнымОперациям.Пометка = Истина;
		Элементы.ПоДокументам.Пометка = Ложь;
	Иначе
		Элементы.СтраницыДеревоОтборов.ТекущаяСтраница = Элементы.СтраницаПоДокументам;
		ЗаполнитьДеревоПоДокументам();
		Элементы.ФормаПоХозяйственнымОперациям.Пометка = Ложь;
		Элементы.ПоДокументам.Пометка = Истина;
	КонецЕсли;
	
	Если РежимСоздания И ЗначениеЗаполнено(НастройкиФормы) Тогда
		Если Иерархия = "ПоХозОперациям" Тогда
			Для Каждого ЭлементДерева Из ДеревоПоХозяйственнымОперациям.ПолучитьЭлементы() Цикл
				Если ЭлементДерева.ХозяйственнаяОперация = ТекущаяХозОперация Тогда
					Для Каждого ЭлементЗначения Из ЭлементДерева.ПолучитьЭлементы() Цикл
						Если ЭлементЗначения.ИдентификаторОбъектаМетаданных = ТекущийИдентификаторОбъектаМетаданных Тогда
							Если ЭлементДерева.КоличествоЭлементов = 1 Тогда
								Элементы.ДеревоПоХозяйственнымОперациям.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
							Иначе
								Элементы.ДеревоПоХозяйственнымОперациям.ТекущаяСтрока = ЭлементЗначения.ПолучитьИдентификатор();
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли
			КонецЦикла;
		Иначе
			Для Каждого ЭлементДерева Из ДеревоПоДокументам.ПолучитьЭлементы() Цикл
				Если ЭлементДерева.ИдентификаторОбъектаМетаданных = ТекущийИдентификаторОбъектаМетаданных Тогда
					Для Каждого ЭлементЗначения Из ЭлементДерева.ПолучитьЭлементы() Цикл
						Если ЭлементЗначения.ХозяйственнаяОперация = ТекущаяХозОперация Тогда
							Если ЭлементДерева.КоличествоЭлементов = 1 Тогда
								Элементы.ДеревоПоДокументам.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
							Иначе
								Элементы.ДеревоПоДокументам.ТекущаяСтрока = ЭлементЗначения.ПолучитьИдентификатор();
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли
			КонецЦикла;
		КонецЕсли
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РазвернутьДерево();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоОтборПриИзменении(Элемент)
	
	Если Иерархия = "ПоХозОперациям" Тогда
		ТекущиеДанные = Элементы.ДеревоПоХозяйственнымОперациям.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.ДеревоПоДокументам.ТекущиеДанные;
	КонецЕсли;
	
	Родитель = ТекущиеДанные.ПолучитьРодителя();
	
	Если Родитель = Неопределено Тогда // выбрана строка-родитель
		
		ПодчиненныеЭлементыДерева = ТекущиеДанные.ПолучитьЭлементы();
		
		Для Каждого ЭлементДерева Из ПодчиненныеЭлементыДерева Цикл
			ЭлементДерева.Отбор = ТекущиеДанные.Отбор;
		КонецЦикла;
		
	Иначе
		
		Если ТекущиеДанные.Отбор Тогда
			Родитель.Отбор = Истина;
		Иначе
			ОтборУстановлен = Ложь;
			Для Каждого ЭлементДерева Из Родитель.ПолучитьЭлементы() Цикл
				ОтборУстановлен = ОтборУстановлен Или ЭлементДерева.Отбор;
			КонецЦикла;
			Родитель.Отбор = ОтборУстановлен;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПоХозяйственнымОперациямВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Иерархия = "ПоХозОперациям" Тогда
		ТекущиеДанные = Элементы.ДеревоПоХозяйственнымОперациям.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.ДеревоПоДокументам.ТекущиеДанные;
	КонецЕсли;
	
	Если РежимСоздания И (ТекущиеДанные.КоличествоЭлементов = 1
			Или ТекущиеДанные.КоличествоЭлементов = 0) Тогда
		СтандартнаяОбработка = Ложь;
		ЗавершитьСозданием();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПоДокументамВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Иерархия = "ПоХозОперациям" Тогда
		ТекущиеДанные = Элементы.ДеревоПоХозяйственнымОперациям.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.ДеревоПоДокументам.ТекущиеДанные;
	КонецЕсли;
	
	Если РежимСоздания И (ТекущиеДанные.КоличествоЭлементов = 1
			Или ТекущиеДанные.КоличествоЭлементов = 0) Тогда
		СтандартнаяОбработка = Ложь;
		ЗавершитьСозданием();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьСоздать(Команда)
	
	Если РежимСоздания Тогда
		ЗавершитьСозданием();
	Иначе
		
		СохранитьНастройкиФормы();
		СохранитьОтборы();
		ОповеститьОВыборе(АдресДоступныеХозяйственныеОперацииИДокументы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьСозданием()
	
	Если Иерархия = "ПоХозОперациям" Тогда
		ТекущиеДанные = Элементы.ДеревоПоХозяйственнымОперациям.ТекущиеДанные;
		ТекстПредупреждения = НСтр("ru = 'Выберите хозяйственную операцию.'");
	Иначе
		ТекущиеДанные = Элементы.ДеревоПоДокументам.ТекущиеДанные;
		ТекстПредупреждения = НСтр("ru = 'Выберите документ.'");
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,ТекстПредупреждения,,НСтр("ru = 'Ошибка выбора.'"));
		Возврат;
	КонецЕсли;
	
	Родитель = ТекущиеДанные.ПолучитьРодителя();
	
	Если Родитель = Неопределено Тогда
		
		Если ТекущиеДанные.КоличествоЭлементов > 1 Тогда
			ПоказатьПредупреждение(,ТекстПредупреждения,,НСтр("ru = 'Ошибка выбора.'"));
			Возврат;
		Иначе
			ТекущаяХозОперация = ТекущиеДанные.ПолучитьЭлементы()[0].ХозяйственнаяОперация;
			ТекущийИдентификатор = ТекущиеДанные.ПолучитьЭлементы()[0].ИдентификаторОбъектаМетаданных;
		КонецЕсли;
		
	Иначе
		
		ТекущаяХозОперация = ТекущиеДанные.ХозяйственнаяОперация;
		ТекущийИдентификатор = ТекущиеДанные.ИдентификаторОбъектаМетаданных;
				
	КонецЕсли;
	
	СтруктураСоздания = Новый Структура;
	СтруктураСоздания.Вставить("ХозяйственнаяОперация", ТекущаяХозОперация);
	СтруктураСоздания.Вставить("ИдентификаторОбъектаМетаданных", ТекущийИдентификатор);
	
	СохранитьНастройкиФормы(ТекущиеДанные.ХозяйственнаяОперация, ТекущиеДанные.ИдентификаторОбъектаМетаданных);
	
	Закрыть(СтруктураСоздания);

		
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	
	Если Иерархия = "ПоХозОперациям" Тогда
		Дерево = ДеревоПоХозяйственнымОперациям;
	Иначе
		Дерево = ДеревоПоДокументам;
	КонецЕсли;
	
	Для Каждого Строка Из Дерево.ПолучитьЭлементы() Цикл
		
		Строка.Отбор = Ложь;
		
		Для Каждого СтрокаПодчиненная Из Строка.ПолучитьЭлементы() Цикл
			СтрокаПодчиненная.Отбор = Ложь;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	
	Если Иерархия = "ПоХозОперациям" Тогда
		Дерево = ДеревоПоХозяйственнымОперациям;
	Иначе
		Дерево = ДеревоПоДокументам;
	КонецЕсли;
	
	Для Каждого Строка Из Дерево.ПолучитьЭлементы() Цикл
		
		Строка.Отбор = Истина;
		
		Для Каждого СтрокаПодчиненная Из Строка.ПолучитьЭлементы() Цикл
			СтрокаПодчиненная.Отбор = Истина;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоХозяйственнымОперациям(Команда)

	Если Иерархия = "ПоХозОперациям" Тогда
		Возврат;
	КонецЕсли;
	
	Иерархия = "ПоХозОперациям";
	
	ИерархияПриИзмененииНаСервере();
	
	РазвернутьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоДокументам(Команда)
	
	Если Иерархия = "ПоДокументам" Тогда
		Возврат;
	КонецЕсли;
	
	Иерархия = "ПоДокументам";
	
	ИерархияПриИзмененииНаСервере();
	
	РазвернутьДерево();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоХозяйственнымОперациямОтбор.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоХозяйственнымОперациям.Картинка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоДокументамОтбор.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоДокументам.Картинка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПоХозяйственнымОперациям()
	
	Дерево = РеквизитФормыВЗначение("ДеревоПоХозяйственнымОперациям"); 
	Дерево.Строки.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация КАК Перечисление.ХозяйственныеОперации) КАК ХозяйственнаяОперация,
	|	ДоступныеХозяйственныеОперацииИДокументы.ИдентификаторОбъектаМетаданных,
	|	ДоступныеХозяйственныеОперацииИДокументы.Отбор,
	|	ДоступныеХозяйственныеОперацииИДокументы.ДокументПредставление
	|ПОМЕСТИТЬ ДоступныеХозяйственныеОперацииИДокументы
	|ИЗ
	|	&ДоступныеХозяйственныеОперацииИДокументы КАК ДоступныеХозяйственныеОперацииИДокументы
	|ГДЕ
	|	ДоступныеХозяйственныеОперацииИДокументы.ДобавитьКнопкуСоздать ИЛИ &РежимВыбора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ПРЕДСТАВЛЕНИЕ(ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация) КАК ХозяйственнаяОперацияПредставление
	|ИЗ
	|	ДоступныеХозяйственныеОперацииИДокументы КАК ДоступныеХозяйственныеОперацииИДокументы";
	Запрос.УстановитьПараметр("ДоступныеХозяйственныеОперацииИДокументы", ПолучитьИзВременногоХранилища(АдресДоступныеХозяйственныеОперацииИДокументы));
	Запрос.УстановитьПараметр("РежимВыбора", Не РежимСоздания);
	ТаблицаХозОперацийПредставление = Запрос.Выполнить().Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДоступныеХозяйственныеОперацииИДокументы.ИдентификаторОбъектаМетаданных,
	|	ДоступныеХозяйственныеОперацииИДокументы.Отбор,
	|	ДоступныеХозяйственныеОперацииИДокументы.ДокументПредставление,
	|	ДоступныеХозяйственныеОперацииИДокументы.ПравоДоступаДобавление
	|ПОМЕСТИТЬ ДоступныеХозяйственныеОперацииИДокументы
	|ИЗ
	|	&ДоступныеХозяйственныеОперацииИДокументы КАК ДоступныеХозяйственныеОперацииИДокументы
	|ГДЕ
	|	ДоступныеХозяйственныеОперацииИДокументы.ДобавитьКнопкуСоздать ИЛИ &РежимВыбора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаХозОперацийПредставление.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ВЫРАЗИТЬ(ТаблицаХозОперацийПредставление.ХозяйственнаяОперацияПредставление КАК Строка(100)) КАК ХозяйственнаяОперацияПредставление
	|ПОМЕСТИТЬ ТаблицаХозОперацийПредставление
	|ИЗ
	|	&ТаблицаХозОперацийПредставление КАК ТаблицаХозОперацийПредставление
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДоступныеХозяйственныеОперацииИДокументы.ИдентификаторОбъектаМетаданных,
	|	ДоступныеХозяйственныеОперацииИДокументы.Отбор,
	|	ДоступныеХозяйственныеОперацииИДокументы.ДокументПредставление
	|ИЗ
	|	ДоступныеХозяйственныеОперацииИДокументы КАК ДоступныеХозяйственныеОперацииИДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаХозОперацийПредставление КАК ТаблицаХозОперацийПредставление
	|		ПО ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация = ТаблицаХозОперацийПредставление.ХозяйственнаяОперация
	|ГДЕ
	|	(&РежимВыбора
	|			ИЛИ (ДоступныеХозяйственныеОперацииИДокументы.Отбор И ДоступныеХозяйственныеОперацииИДокументы.ПравоДоступаДобавление))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаХозОперацийПредставление.ХозяйственнаяОперацияПредставление";
	
	Запрос.УстановитьПараметр("ТаблицаХозОперацийПредставление", ТаблицаХозОперацийПредставление);
	Запрос.УстановитьПараметр("ДоступныеХозяйственныеОперацииИДокументы", ПолучитьИзВременногоХранилища(АдресДоступныеХозяйственныеОперацииИДокументы));
	Запрос.УстановитьПараметр("РежимВыбора", Не РежимСоздания);
	
	ПараметрыФормированияПредставления = Новый Структура;
	ПараметрыФормированияПредставления.Вставить("ТолькоКомиссионныеПродажи25", ПолучитьФункциональнуюОпцию("ТолькоКомиссионныеПродажи25"));
	ПараметрыФормированияПредставления.Вставить("ОбъектКорректировкиРеализации", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.КорректировкаРеализации));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ХозяйственнаяОперация") Цикл
		
		СтрокаИерархии = Дерево.Строки.Добавить();
		СтрокаИерархии.ХозяйственнаяОперация = Выборка.ХозяйственнаяОперация;
		СтрокаИерархии.Представление = ПредставлениеХозяйственнойОперации(Выборка, ПараметрыФормированияПредставления);
		СтрокаИерархии.Картинка = 0;
		
		ОтборУстановлен = Ложь;
		
		Пока Выборка.Следующий() Цикл
			
			Если Не ПараметрыФормированияПредставления.ТолькоКомиссионныеПродажи25 Тогда
				Если Выборка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
					Или Выборка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера Тогда
					ДобавитьХозяйственнуюОперацииКомиссии25(Дерево, Выборка);
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			СтрокаЗначения = СтрокаИерархии.Строки.Добавить();
			СтрокаЗначения.ХозяйственнаяОперация = Выборка.ХозяйственнаяОперация;
			СтрокаЗначения.ИдентификаторОбъектаМетаданных = Выборка.ИдентификаторОбъектаМетаданных;
			СтрокаЗначения.Отбор = Выборка.Отбор;
			СтрокаЗначения.Представление = СокрЛП(Выборка.ДокументПредставление);
			СтрокаЗначения.Картинка = 1;
			
			СтрокаИерархии.КоличествоЭлементов = СтрокаИерархии.КоличествоЭлементов + 1;
			
			ОтборУстановлен = ОтборУстановлен Или Выборка.Отбор;
		КонецЦикла;
		
		Если ОтборУстановлен Тогда
			СтрокаИерархии.Отбор = Истина;
		
			Для Каждого СтрокаЗначения Из СтрокаИерархии.Строки Цикл
				СтрокаЗначения.Отбор = Истина;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево,"ДеревоПоХозяйственнымОперациям");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПоДокументам()
	
	Дерево = РеквизитФормыВЗначение("ДеревоПоДокументам"); 
	Дерево.Строки.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация                           КАК ХозяйственнаяОперация,
	|	ДоступныеХозяйственныеОперацииИДокументы.ИдентификаторОбъектаМетаданных                  КАК ИдентификаторОбъектаМетаданных,
	|	ДоступныеХозяйственныеОперацииИДокументы.Отбор                                           КАК Отбор,
	|	ДоступныеХозяйственныеОперацииИДокументы.Порядок                                         КАК ПорядокЖурнала,
	|	ВЫРАЗИТЬ(ДоступныеХозяйственныеОперацииИДокументы.ДокументПредставление КАК СТРОКА(100)) КАК ДокументПредставление,
	|	ДоступныеХозяйственныеОперацииИДокументы.ПравоДоступаДобавление                          КАК ПравоДоступаДобавление
	|ПОМЕСТИТЬ ДоступныеХозяйственныеОперацииИДокументы
	|ИЗ
	|	&ДоступныеХозяйственныеОперацииИДокументы КАК ДоступныеХозяйственныеОперацииИДокументы
	|ГДЕ
	|	ДоступныеХозяйственныеОперацииИДокументы.ДобавитьКнопкуСоздать ИЛИ &РежимВыбора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоступныеХозяйственныеОперацииИДокументы.ИдентификаторОбъектаМетаданных  КАК ИдентификаторОбъектаМетаданных,
	|	МИНИМУМ(ДоступныеХозяйственныеОперацииИДокументы.ПорядокЖурнала)         КАК ПорядокЖурналаГруппа
	|ПОМЕСТИТЬ ДоступныеХозяйственныеОперацииИДокументыГруппы
	|ИЗ
	|	ДоступныеХозяйственныеОперацииИДокументы КАК ДоступныеХозяйственныеОперацииИДокументы
	|СГРУППИРОВАТЬ ПО
	|	ДоступныеХозяйственныеОперацииИДокументы.ИдентификаторОбъектаМетаданных
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация          КАК ХозяйственнаяОперация,
	|	ДоступныеХозяйственныеОперацииИДокументы.ИдентификаторОбъектаМетаданных КАК ИдентификаторОбъектаМетаданных,
	|	ДоступныеХозяйственныеОперацииИДокументы.Отбор                          КАК Отбор,
	|	ДоступныеХозяйственныеОперацииИДокументыГруппы.ПорядокЖурналаГруппа     КАК ПорядокЖурналаГруппа,
	|	ДоступныеХозяйственныеОперацииИДокументы.ПорядокЖурнала                 КАК ПорядокЖурнала,
	|	ДоступныеХозяйственныеОперацииИДокументы.ДокументПредставление          КАК ДокументПредставление,
	|	ХозяйственныеОперации.Порядок                                           КАК Порядок,
	|	
	|	ВЫБОР
	|		КОГДА ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика)
	|			ТОГДА 0
	|		КОГДА ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо)
	|				ИЛИ ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаРеглУчет)
	|			ТОГДА 2
	|		КОГДА ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация В(&ХозОперацииЗакупкаУПоставщика)
	|			ТОГДА 1
	|		КОГДА ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация В(&ХозОперацииЗакупкаПоИмпорту)
	|			ТОГДА 3
	|		КОГДА ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация В(&ХозОперацииЗакупкаВСтранахЕАЭС)
	|			ТОГДА 4
	|		КОГДА ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация В(&ХозОперацииПриемНаКомиссию)
	|			ТОГДА 5
	|		ИНАЧЕ 6
	|	КОНЕЦ                                                                   КАК Номер
	|ИЗ
	|	ДоступныеХозяйственныеОперацииИДокументы КАК ДоступныеХозяйственныеОперацииИДокументы
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДоступныеХозяйственныеОперацииИДокументыГруппы КАК ДоступныеХозяйственныеОперацииИДокументыГруппы
	|		ПО ДоступныеХозяйственныеОперацииИДокументыГруппы.ИдентификаторОбъектаМетаданных = ДоступныеХозяйственныеОперацииИДокументы.ИдентификаторОбъектаМетаданных
	|	ЛЕВОЕ СОЕДИНЕНИЕ Перечисление.ХозяйственныеОперации КАК ХозяйственныеОперации
	|		ПО ХозяйственныеОперации.Ссылка = ДоступныеХозяйственныеОперацииИДокументы.ХозяйственнаяОперация
	|ГДЕ
	|	(&РежимВыбора
	|			ИЛИ (ДоступныеХозяйственныеОперацииИДокументы.Отбор И ДоступныеХозяйственныеОперацииИДокументы.ПравоДоступаДобавление))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПорядокЖурналаГруппа,
	|	ПорядокЖурнала,
	|	ДокументПредставление,
	|	Номер,
	|	Порядок";
	
	ПараметрПоУмолчанию = Новый Массив;
	
	ДоступныеХозяйственныеОперацииИДокументы = ПолучитьИзВременногоХранилища(АдресДоступныеХозяйственныеОперацииИДокументы); // см. ОбщегоНазначенияУТ.НоваяТаблицаХозяйственныеОперацииИДокументы
	
	Если ДоступныеХозяйственныеОперацииИДокументы.Колонки.Найти("Порядок") = Неопределено Тогда
		ДоступныеХозяйственныеОперацииИДокументы.Колонки.Добавить("Порядок",
			Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0)));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ДоступныеХозяйственныеОперацииИДокументы", ДоступныеХозяйственныеОперацииИДокументы);
	Запрос.УстановитьПараметр("РежимВыбора", Не РежимСоздания);
	
	Запрос.УстановитьПараметр("ХозОперацииЗакупкаУПоставщика",           ПараметрПоУмолчанию);
	Запрос.УстановитьПараметр("ХозОперацииЗакупкаПоИмпорту",             ПараметрПоУмолчанию);
	Запрос.УстановитьПараметр("ХозОперацииПриемНаКомиссию",              ПараметрПоУмолчанию);
	Запрос.УстановитьПараметр("ХозОперацииПриемНаОтветственноеХранение", ПараметрПоУмолчанию);
	Запрос.УстановитьПараметр("ХозОперацииЗакупкаВСтранахЕАЭС",          ПараметрПоУмолчанию);
	Запрос.УстановитьПараметр("ХозОперацииТоварыВПути",                  ПараметрПоУмолчанию);
	Запрос.УстановитьПараметр("ХозОперацииНеотфактурованныеПоставки",    ПараметрПоУмолчанию);
	Запрос.УстановитьПараметр("ХозОперацииНеРазделятьОформлениеЗакупок", ПараметрПоУмолчанию);
	
	ЗакупкиСервер.ЗаполнитьПараметрыЗапросаУпорядочиванияХозяйсвенныхОпераций(Запрос.Параметры);
	
	ПараметрыФормированияПредставления = Новый Структура;
	ПараметрыФормированияПредставления.Вставить("ТолькоКомиссионныеПродажи25", ПолучитьФункциональнуюОпцию("ТолькоКомиссионныеПродажи25"));
	ПараметрыФормированияПредставления.Вставить("ОбъектКорректировкиРеализации", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.КорректировкаРеализации));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ИдентификаторОбъектаМетаданных") Цикл
		
		СтрокаИерархии = Дерево.Строки.Добавить();
		СтрокаИерархии.ИдентификаторОбъектаМетаданных = Выборка.ИдентификаторОбъектаМетаданных;
		СтрокаИерархии.Представление = СокрЛП(Выборка.ДокументПредставление);
		СтрокаИерархии.Картинка = 1;
		
		ОтборУстановлен = Ложь;
		
		Пока Выборка.Следующий() Цикл
			
			Если НЕ ТолькоПоТипамДокументов Тогда
				
				СтрокаЗначения = СтрокаИерархии.Строки.Добавить();
				СтрокаЗначения.ИдентификаторОбъектаМетаданных = Выборка.ИдентификаторОбъектаМетаданных;
				СтрокаЗначения.ХозяйственнаяОперация = Выборка.ХозяйственнаяОперация;
				СтрокаЗначения.Отбор = Выборка.Отбор;
				СтрокаЗначения.Представление = ПредставлениеХозяйственнойОперации(Выборка, ПараметрыФормированияПредставления);
				СтрокаЗначения.Картинка = 0;
				
				СтрокаИерархии.КоличествоЭлементов = СтрокаИерархии.КоличествоЭлементов + 1;
			
			КонецЕсли;
			
			ОтборУстановлен = ОтборУстановлен Или Выборка.Отбор;
		КонецЦикла;
		
		Если ОтборУстановлен Тогда
			СтрокаИерархии.Отбор = Истина;
			
			Если НЕ ТолькоПоТипамДокументов Тогда
				
				Для Каждого СтрокаЗначения Из СтрокаИерархии.Строки Цикл
					СтрокаЗначения.Отбор = Истина;
				КонецЦикла;
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево,"ДеревоПоДокументам");
	
КонецПроцедуры

&НаСервере
Процедура ИерархияПриИзмененииНаСервере()
	Если Иерархия = "ПоХозОперациям" Тогда
		Элементы.СтраницыДеревоОтборов.ТекущаяСтраница = Элементы.СтраницаПоХозяйственнымОперациям;
		СохранитьОтборыПоДокументам();
		ЗаполнитьДеревоПоХозяйственнымОперациям();
		Элементы.ФормаПоХозяйственнымОперациям.Пометка = Истина;
		Элементы.ПоДокументам.Пометка = Ложь;
	Иначе
		Элементы.СтраницыДеревоОтборов.ТекущаяСтраница = Элементы.СтраницаПоДокументам;
		СохранитьОтборыПоХозОперациям();
		ЗаполнитьДеревоПоДокументам();
		Элементы.ФормаПоХозяйственнымОперациям.Пометка = Ложь;
		Элементы.ПоДокументам.Пометка = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьОтборыПоХозОперациям()
	
	Дерево = РеквизитФормыВЗначение("ДеревоПоХозяйственнымОперациям");
	
	ТаблицаОтборов = ПолучитьИзВременногоХранилища(АдресДоступныеХозяйственныеОперацииИДокументы);
	ТаблицаОтборов.ЗаполнитьЗначения(Ложь, "Отбор");
	
	Отбор = Новый Структура("ХозяйственнаяОперация, ИдентификаторОбъектаМетаданных");
	
	Для Каждого СтрокаИерархии Из Дерево.Строки Цикл
		
		Если СтрокаИерархии.Отбор Тогда
			
			Отбор.ХозяйственнаяОперация = СтрокаИерархии.ХозяйственнаяОперация;
			
			Для Каждого СтрокаЗначения Из СтрокаИерархии.Строки Цикл
				Если СтрокаЗначения.Отбор Тогда
					Отбор.ИдентификаторОбъектаМетаданных = СтрокаЗначения.ИдентификаторОбъектаМетаданных;
					
					ТаблицаОтборов.НайтиСтроки(Отбор)[0].Отбор = Истина;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТаблицаОтборов, АдресДоступныеХозяйственныеОперацииИДокументы);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьОтборыПоДокументам()
	
	Дерево = РеквизитФормыВЗначение("ДеревоПоДокументам");
	
	ТаблицаОтборов = ПолучитьИзВременногоХранилища(АдресДоступныеХозяйственныеОперацииИДокументы);
	ТаблицаОтборов.ЗаполнитьЗначения(Ложь, "Отбор");
	
	Отбор = Новый Структура("ХозяйственнаяОперация, ИдентификаторОбъектаМетаданных");
	
	Для Каждого СтрокаИерархии Из Дерево.Строки Цикл
		
		Если СтрокаИерархии.Отбор Тогда
			
			Отбор.ИдентификаторОбъектаМетаданных = СтрокаИерархии.ИдентификаторОбъектаМетаданных;
			
			Для Каждого СтрокаЗначения Из СтрокаИерархии.Строки Цикл
				Если СтрокаЗначения.Отбор Тогда
					Отбор.ХозяйственнаяОперация = СтрокаЗначения.ХозяйственнаяОперация;
					
					ТаблицаОтборов.НайтиСтроки(Отбор)[0].Отбор = Истина;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТаблицаОтборов, АдресДоступныеХозяйственныеОперацииИДокументы);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьОтборыТолькоПоДокументам()
	
	Дерево = РеквизитФормыВЗначение("ДеревоПоДокументам");
	
	ТаблицаОтборов = ПолучитьИзВременногоХранилища(АдресДоступныеХозяйственныеОперацииИДокументы);
	ТаблицаОтборов.ЗаполнитьЗначения(Ложь, "Отбор");
	
	Отбор = Новый Структура("ИдентификаторОбъектаМетаданных");
	
	Для Каждого СтрокаИерархии Из Дерево.Строки Цикл
		
		Если СтрокаИерархии.Отбор Тогда
			
			Отбор.ИдентификаторОбъектаМетаданных = СтрокаИерархии.ИдентификаторОбъектаМетаданных;
			НайденныеСтроки = ТаблицаОтборов.НайтиСтроки(Отбор);
			
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				НайденнаяСтрока.Отбор = Истина;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТаблицаОтборов, АдресДоступныеХозяйственныеОперацииИДокументы);
	
КонецПроцедуры


&НаСервере
Процедура СохранитьОтборы()
	
	Если Иерархия = "ПоХозОперациям" Тогда
		СохранитьОтборыПоХозОперациям();
	Иначе
		Если ТолькоПоТипамДокументов Тогда
			СохранитьОтборыТолькоПоДокументам();
		Иначе
			СохранитьОтборыПоДокументам();
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаОтборов = ПолучитьИзВременногоХранилища(АдресДоступныеХозяйственныеОперацииИДокументы);
	Если ТаблицаОтборов.НайтиСтроки(Новый Структура("Отбор", Истина)).Количество() = 0 Тогда
		ТаблицаОтборов.ЗаполнитьЗначения(Истина, "Отбор");
		ПоместитьВоВременноеХранилище(ТаблицаОтборов, АдресДоступныеХозяйственныеОперацииИДокументы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормы(ХозяйственнаяОперация = Неопределено, ИдентификаторОбъектаМетаданных = Неопределено)
	
	НастройкиФормы = Новый Структура();
	НастройкиФормы.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
	НастройкиФормы.Вставить("ИдентификаторОбъектаМетаданных", ИдентификаторОбъектаМетаданных);
	НастройкиФормы.Вставить("Иерархия", Иерархия);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючНастроек+КлючФормы, РежимСоздания, НастройкиФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево()
	
	#Если ВебКлиент Тогда
		Если Иерархия = "ПоХозОперациям" Тогда
			Для Каждого ЭлементДерева Из ДеревоПоХозяйственнымОперациям.ПолучитьЭлементы() Цикл
				Если ЭлементДерева.КоличествоЭлементов > 1 Тогда
					Элементы.ДеревоПоХозяйственнымОперациям.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для Каждого ЭлементДерева Из ДеревоПоДокументам.ПолучитьЭлементы() Цикл
				Если ЭлементДерева.КоличествоЭлементов > 1 Тогда
					Элементы.ДеревоПоДокументам.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеХозяйственнойОперации(Выборка, Параметры)
	
	ПредставлениеХозяйственнойОперации = Выборка.ХозяйственнаяОперация;
	
	Если Не Параметры.ТолькоКомиссионныеПродажи25 Тогда
		Если Выборка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию 
			Или Выборка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера Тогда
			ПредставлениеХозяйственнойОперации = СтрШаблон("%1 (%2)", Выборка.ХозяйственнаяОперация, КомиссионнаяТорговляСервер.ПостфиксСхемыКомиссии(Выборка.ИдентификаторОбъектаМетаданных));
		ИначеЕсли Выборка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера
			Или Выборка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности 
			Или Выборка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровЧерезКомиссионера Тогда
			ПредставлениеХозяйственнойОперации = СтрШаблон("%1 (%2)", Выборка.ХозяйственнаяОперация, КомиссионнаяТорговляСервер.ПостфиксСхемыКомиссии25());
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПредставлениеХозяйственнойОперации;
	
КонецФункции

&НаСервере
Процедура ДобавитьХозяйственнуюОперацииКомиссии25(Дерево, Выборка)
	
	Представление = СтрШаблон("%1 (%2)", Выборка.ХозяйственнаяОперация, КомиссионнаяТорговляСервер.ПостфиксСхемыКомиссии(Выборка.ИдентификаторОбъектаМетаданных));
	
	СтрокаИерархииКомиссии = Дерево.Строки.Найти(Представление, "Представление");

	Если СтрокаИерархииКомиссии = Неопределено Тогда
		
		СтрокаИерархииКомиссии = Дерево.Строки.Добавить();
		СтрокаИерархииКомиссии.ХозяйственнаяОперация = Выборка.ХозяйственнаяОперация;
		СтрокаИерархииКомиссии.Картинка = 0;
		СтрокаИерархииКомиссии.Представление = Представление;
		
	КонецЕсли;
	
	СтрокаЗначения = СтрокаИерархииКомиссии.Строки.Найти(Выборка.ИдентификаторОбъектаМетаданных, "ИдентификаторОбъектаМетаданных");
	
	Если СтрокаЗначения = Неопределено Тогда
		
		СтрокаЗначения = СтрокаИерархииКомиссии.Строки.Добавить();
		СтрокаЗначения.ХозяйственнаяОперация = Выборка.ХозяйственнаяОперация;
		СтрокаЗначения.ИдентификаторОбъектаМетаданных = Выборка.ИдентификаторОбъектаМетаданных;
		СтрокаЗначения.Отбор = Выборка.Отбор;
		СтрокаЗначения.Представление = СокрЛП(Выборка.ДокументПредставление);
		СтрокаЗначения.Картинка = 1;
		
		СтрокаИерархииКомиссии.Отбор = СтрокаЗначения.Отбор;
		СтрокаИерархииКомиссии.КоличествоЭлементов = СтрокаИерархииКомиссии.КоличествоЭлементов + 1;
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


