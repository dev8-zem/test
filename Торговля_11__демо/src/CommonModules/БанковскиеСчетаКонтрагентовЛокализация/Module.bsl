
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	//++ Локализация
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не Объект.ОтдельныйСчетГОЗ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГосударственныйКонтракт");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ТекстОшибки = "";
	Если Не Объект.ИностранныйБанк
		И Не ДенежныеСредстваКлиентСерверЛокализация.ПроверитьКорректностьНомераСчета(Объект.НомерСчета,, ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект, "НомерСчета",, Отказ);
	КонецЕсли;
	//-- Локализация
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПередЗаписью(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - СправочникОбъект - Обрабатываемый объект
//  ОбъектКопирования - СправочникОбъект - Исходный справочник, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//++ Локализация

// Определяет свойства полей формы в зависимости от данных
// 
// Параметры:
//  Настройки - см. ДенежныеСредстваСервер.ИнициализироватьНастройкиПолейФормы.
// 
Процедура НастройкиПолейФормы(Настройки) Экспорт
	
	Финансы = ФинансоваяОтчетностьСервер;
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ОтдельныйСчетГОЗ");
	Финансы.НовыйОтбор(Элемент.Условие, "ИностранныйБанк", Ложь);
	Элемент.Свойства.Вставить("Доступность");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ИспользуетсяБанкДляРасчетов");
	Финансы.НовыйОтбор(Элемент.Условие, "ОтдельныйСчетГОЗ", Ложь);
	Элемент.Свойства.Вставить("Доступность");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ГосударственныйКонтракт");
	Финансы.НовыйОтбор(Элемент.Условие, "ОтдельныйСчетГОЗ", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "ИностранныйБанк", Ложь);
	Элемент.Свойства.Вставить("Доступность");
	Элемент.Свойства.Вставить("АвтоОтметкаНезаполненного");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ОтдельныйСчетГОЗ");
	Элемент.Поля.Добавить("ГосударственныйКонтракт");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.СчетФизЛица", Ложь);
	Элемент.Свойства.Вставить("Видимость");
	
	// Печать платежных поручений
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ИННКорреспондента");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользоватьИННКорреспондента", Истина);
	Элемент.Свойства.Вставить("Доступность");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("КППКорреспондента");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользоватьКППКорреспондента", Истина);
	Элемент.Свойства.Вставить("Доступность");
	
	ДенежныеСредстваСерверЛокализация.НастройкиЭлементовБанков(Настройки);
	
КонецПроцедуры
//-- Локализация

#КонецОбласти
