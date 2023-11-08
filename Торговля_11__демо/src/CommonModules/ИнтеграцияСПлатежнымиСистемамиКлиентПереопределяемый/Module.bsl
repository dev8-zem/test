///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ИнтеграцияСПлатежнымиСистемами".
// ОбщийМодуль.ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.
//
// Переопределяемые клиентские процедуры интеграции с Системой быстрых платежей:
//  - программное заполнение сообщения отправки платежной ссылки.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область РаботаССообщениями

// Заполняет параметры сообщения электронной почты, отправляемого без шаблона.
// Применяется в случае, если шаблоны сообщений не используются.
// 
// Параметры:
//  ПараметрыСообщения - Структура - Параметры сообщения электронной почты:
//    * Получатель - СписокЗначений - Список адресов электронной почты.
//    * Предмет - Произвольный - Ссылка на основание платежа.
//    * Тема - Строка - Тема сообщения.
//    * Текст - Строка - Текст сообщения.
//  ПараметрыОперации - Структура - Содержит дополнительные параметры для формирования текста сообщения:
//    * ПлатежнаяСсылка - Строка - Платежная ссылка, отправляемая в сообщении.
//    * ТорговаяТочка - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//      настройка интеграции с платежной системой.
//
//@skip-warning
Процедура ПриЗаполненииПараметровСообщенияБезШаблонаСБП(ПараметрыСообщения, ПараметрыОперации) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ФормаОтображенияQRКода

// Определяет алгоритм, выполняющийся при открытии формы QR кода на форме подготовки платежной ссылки СБП.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма отображения QR-кода.
//  ДанныеПлатежнойСсылки - Структура - содержит в себе описание платежной ссылки:
//    * ПлатежнаяСсылка - Строка - ссылка сформированная по данным документа операции.
//    * QRКод - ДвоичныеДанные - данные изображения QR-кода.
//  ОповещениеПослеЗавершенияНастройкиФормы - ОписаниеОповещения - оповещение,
//    вызывает метод "ПриОтображенииQRКода", рекомендуется использовать для подключения оборудования.
//    При этом свойство "ДополнительныеПараметры" имеет тип Структура, для передачи параметров в переопределяемый метод
//    ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриОтображенииQRКода.
//
Процедура ПриОткрытииФормыQRКода(Форма, ДанныеПлатежнойСсылки, ОповещениеПослеЗавершенияНастройкиФормы) Экспорт
	
	
КонецПроцедуры

// Определяет алгоритм, выполняющийся при отображении QR кода на форме подготовки платежной ссылки СБП.
//
// Параметры:
//   ДанныеПлатежнойСсылки - Структура - содержит в себе описание платежной ссылки:
//    * ПлатежнаяСсылка - Строка - ссылка сформированная по данным документа операции.
//    * QRКод - ДвоичныеДанные - данные изображения QR-кода.
//  Параметры - Структура - описание параметров переданных из метода
//   ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриОткрытииФормыQRКода.
//
// Пример:
//  Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ДисплеиПокупателя") Тогда
//
//     МодульОборудованиеДисплеиПокупателяКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеДисплеиПокупателяКлиент");
//
//       Если МодульОборудованиеДисплеиПокупателяКлиент.ПодключенныеДисплеиПокупателяВыводятQRКод() Тогда
//
//         ПараметрыОперации = МодульОборудованиеДисплеиПокупателяКлиент.ПараметрыОперацииДисплейПокупателя();
//         ПараметрыОперации.ЗначениеQRКода = ДанныеПлатежнойСсылки.ПлатежнаяСсылка;
//         ПараметрыОперации.КартинкаQRКода = Base64Строка(ДанныеПлатежнойСсылки.QRКод);
//
//         МодульОборудованиеДисплеиПокупателяКлиент.НачатьВыводQRКодаНаДисплейПокупателя(
//           Неопределено,
//           Новый УникальныйИдентификатор,
//           Неопределено,
//           ПараметрыОперации);
//
//         КонецЕсли;
//  КонецЕсли;
//
Процедура ПриОтображенииQRКода(ДанныеПлатежнойСсылки, Параметры) Экспорт
	
	
КонецПроцедуры

// Определяет алгоритм, выполняющийся при нажатии команды на форме QR-кода.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма отображения QR-кода.
//  Команда - КомандаФормы - выполняемая команда.
//  ДанныеПлатежнойСсылки - Структура - параметры выполнения команды:
//    * ПлатежнаяСсылка - Строка - ссылка сформированная по данным документа операции.
//    * QRКод - ДвоичныеДанные - данные изображения QR-кода.
//
Процедура ПриОбработкеНажатияКоманды(Форма, Команда, ДанныеПлатежнойСсылки) Экспорт
	
	
КонецПроцедуры

// Определяет алгоритм, выполняющийся при закрытии формы отображения QR-кода.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма отображения QR-кода.
//
Процедура ПриЗакрытииФормыQRКода(Форма) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ФормаПодключениеКассовойСсылки

// Определяет алгоритм, выполняющийся при открытии подключения кассовой ссылки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения кассовой ссылки.
//  Отказ - Булево - признак отказа от открытия формы.
//
Процедура ПриОткрытииФормыПодключенияСсылки(
		Форма,
		Отказ) Экспорт
	
	
	
КонецПроцедуры

// Определяет алгоритм, выполняющийся при закрытии формы подключения кассовой ссылки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения кассовой ссылки.
//  ЗавершениеРаботы - Булево - признак завершения работы.
//
Процедура ПриЗакрытииФормыПодключенияСсылки(
		Форма,
		ЗавершениеРаботы) Экспорт
	
	
	
КонецПроцедуры

// Определяет алгоритм, выполняющийся при открытии подключения кассовой ссылки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения кассовой ссылки.
//  ИмяСобытия - Строка - может быть использовано для идентификации сообщений
//    принимающими их формами.
//  Параметр - Произвольный - могут быть переданы любые необходимые данные для обработки.
//  Источник - Произвольный - источник события, например, в качестве источника может быть
//   указана другая форма.//
Процедура ОбработкаОповещенияФормыПодключенияСсылки(
		Форма,
		ИмяСобытия,
		Параметр,
		Источник) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
