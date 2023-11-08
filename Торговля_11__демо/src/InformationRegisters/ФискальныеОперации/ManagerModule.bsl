#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.УправлениеДоступом
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
//
// Параметры:
//  Ограничение - Структура:
//    * Текст                             - Строка - ограничение доступа для пользователей.
//                                          Если пустая строка, значит, доступ разрешен.
//    * ТекстДляВнешнихПользователей      - Строка - ограничение доступа для внешних пользователей.
//                                          Если пустая строка, значит, доступ запрещен.
//    * ПоВладельцуБезЗаписиКлючейДоступа - Неопределено - определить автоматически.
//                                        - Булево - если Ложь, то всегда записывать ключи доступа,
//                                          если Истина, тогда не записывать ключи доступа,
//                                          а использовать ключи доступа владельца (требуется,
//                                          чтобы ограничение было строго по объекту-владельцу).
//   * ПоВладельцуБезЗаписиКлючейДоступаДляВнешнихПользователей - Неопределено, Булево - также
//                                          как у параметра ПоВладельцуБезЗаписиКлючейДоступа.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Менеджер = "РегистрСведений.ФискальныеОперации";
	МенеджерОборудованияВызовСервераПереопределяемый.ПриЗаполненииОграниченияДоступа(Менеджер, Ограничение);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОчиститьРегистрДоДаты(ДатаОчистки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// АПК: 1328-выкл
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФискальныеОперации.ИдентификаторЗаписи КАК ИдентификаторЗаписи
		|ИЗ
		|	РегистрСведений.ФискальныеОперации КАК ФискальныеОперации
		|ГДЕ
		|	ФискальныеОперации.Дата < &ДатаОчистки";
	
	Запрос.УстановитьПараметр("ДатаОчистки", ДатаОчистки);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ФискальныеОперации.СоздатьНаборЗаписей();
	Выборка      = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей.Очистить();
		НаборЗаписей.Отбор.ИдентификаторЗаписи.Установить(Выборка.ИдентификаторЗаписи);
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
	// АПК: 1328-вкл
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

