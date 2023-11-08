////////////////////////////////////////////////////////////////////////////////
// Расширение подсистемы "Физические лица" для УТ, КА2, УП2.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет, что серия документа для переданного вида документа указана правильно.
//
// Параметры:
//	ВидДокумента - СправочникСсылка.ВидыДокументовФизическихЛиц	- вид документа, для которого необходимо
//																проверить правильность серии
//	Серия - Строка												- серия документа
//	ТекстОшибки - Строка										- текст ошибки, если серия указана неправильно.
//
// Возвращаемое значение:
//	Булево - результат проверки, Истина - правильно, Ложь - нет.
//
Функция СерияДокументаУказанаПравильно(ВидДокумента, Знач Серия , ТекстОшибки) Экспорт
	
	БезОшибки = Истина;
	
	ФизическиеЛицаКлиентСерверУТЛокализация.СерияДокументаУказанаПравильно(ВидДокумента, Серия, ТекстОшибки, БезОшибки);
	
	Возврат БезОшибки;
	
КонецФункции

// Проверяет, что номер документа для переданного вида документа указан правильно.
//
// Параметры:
//	ВидДокумента - СправочникСсылка.ВидыДокументовФизическихЛиц	- вид документа, для которого необходимо
//																проверить правильность номера
//	Номер - Строка												- номер документа
//	ТекстОшибки - Строка										- текст ошибки, если номер указан неправильно.
//
// Возвращаемое значение:
//	Булево - результат проверки, Истина - правильно, Ложь - нет.
//
Функция НомерДокументаУказанПравильно(ВидДокумента, Знач Номер, ТекстОшибки) Экспорт
	
	БезОшибки = Истина;
	
	ФизическиеЛицаКлиентСерверУТЛокализация.НомерДокументаУказанПравильно(ВидДокумента, Номер, ТекстОшибки, БезОшибки);
	
	Возврат БезОшибки;
	
КонецФункции

// Возвращает тип серии документа удостоверяющего личность
//
// Параметры:
//	ВидДокумента - СправочникСсылка.ВидыДокументовФизическихЛиц
//
// Возвращаемое значение:
//	Число	- тип серии для документа, 0 - требований к серии нет.
//
Функция ТипСерииДокументаУдостоверяющегоЛичность(ВидДокумента) Экспорт
	
	ТипДокумента = 0;
	
	ФизическиеЛицаКлиентСерверУТЛокализация.ТипСерииДокументаУдостоверяющегоЛичность(ВидДокумента, ТипДокумента);
	
	Возврат ТипДокумента;
	
КонецФункции

// Возвращает тип номера документа удостоверяющего личность
//
// Параметры:
//	ВидДокумента - СправочникСсылка.ВидыДокументовФизическихЛиц
//
// Возвращаемое значение:
//	Число	- тип номера для документа, 0 - требований к номеру нет.
//
Функция ТипНомераДокументаУдостоверяющегоЛичность(ВидДокумента) Экспорт
	
	ТипДокумента = 0;
	
	ФизическиеЛицаКлиентСерверУТЛокализация.ТипНомераДокументаУдостоверяющегоЛичность(ВидДокумента, ТипДокумента);
	
	Возврат ТипДокумента;
	
КонецФункции

#КонецОбласти

