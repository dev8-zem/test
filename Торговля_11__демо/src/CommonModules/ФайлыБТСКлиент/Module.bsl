//@strict-types

#Область ПрограммныйИнтерфейс

// Инициализирует структуру параметров для получения файла с сервера на клиент.
// Для использования в ФайлыБТСКлиент.ПолучитьФайлИнтерактивно.
//
// Возвращаемое значение:
//  Структура - Параметры получения файла:
//    * ИмяФайлаИлиАдрес - Строка - Адрес во временном хранилище, либо имя файла на сервере (без пути) для
//        получения клиентом. Если указан адрес во временном хранилище, то при попытке получения файлов
//        более 4Гб будет вызвано исключение.
//    * ПутьФайлаWindows - Строка - Путь к файлу при работе сеанса на Windows сервере. Значение игнорируется,
//        если в параметре ИмяФайлаИлиАдрес указан адрес во временном хранилище или указано имя зарегистрированного
//        файла временного хранилища.
//    * ПутьФайлаLinux - Строка - Путь к файлу при работе сеанса на Linux сервере. Значение игнорируется,
//        если в параметре ИмяФайлаИлиАдрес указан адрес во временном хранилище или указано имя зарегистрированного
//        файла временного хранилища.
//    * ОписаниеОповещенияОЗавершении - ОписаниеОповещения, Неопределено - Содержит описание процедуры, которая
//        будет вызвана после получения файла. Если указано Неопределено, никакой обработчик запускаться
//        не будет. Вызываемая процедура должна иметь параметры:
//           Результат - Структура, Неопределено - при отказе от получения файла, либо структура со свойствами:
//             ИмяФайлаИлиАдрес - Строка - Адрес во временном хранилище, либо имя файла на сервере (без пути)
//             ИмяФайлаНаКлиенте - Строка - полное имя клиентского файла, полученного клиентом
//           ДополнительныеПараметры - Произвольный - значение, которое было указано при создании
//            объекта ОписаниеОповещения.
//    * БлокируемаяФорма - ФормаКлиентскогоПриложения, Неопределено - Владелец формы получения файла для блокировки.
//        Если указано Неопределено, на время загрузки будет заблокирован весь интерфейс.
//    * ЗаголовокДиалогаСохранения - Строка, Неопределено - заголовок диалога выбора и формы загрузки файла.
//        Если указано Неопределено, заголовки будут сформированы автоматически.
//    * ЗаголовокОперацииПолучения - Строка, Неопределено - заголовок формы, отображающей длительную операцию.
//    * ФильтрДиалогаСохранения - Строка, Неопределено - фильтр диалога выбора файла для сохранения.
//        Если указано Неопределено, в диалоге можно будет выбрать любой файл.
//    * ИмяФайлаДиалогаСохранения - Строка - Имя клиентского файла, которое будет предложено в диалоге 
//        выбора файла для сохранения.
//    * ПоказатьВопросОткрытьСохранить - Булево - признак того, что при получении файла необходимо
//        дополнительно задать вопрос, и при положительном ответе сразу открыть файл. Если указано Ложь,
//        вопрос задаваться не будет. Если в параметре ИмяФайлаИлиАдрес указан адрес во временном хранилище,
//        то значение параметра игнорируется, а поведение регулируется платформой.
Функция ПараметрыПолученияФайла() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ИмяФайлаИлиАдрес", "");
	Результат.Вставить("ПутьФайлаWindows", "");
	Результат.Вставить("ПутьФайлаLinux", "");
	Результат.Вставить("ОписаниеОповещенияОЗавершении", Неопределено);
	Результат.Вставить("БлокируемаяФорма", Неопределено);
	Результат.Вставить("ЗаголовокДиалогаСохранения", Неопределено);
	Результат.Вставить("ЗаголовокОперацииПолучения", Неопределено);
	Результат.Вставить("ФильтрДиалогаСохранения", Неопределено);
	Результат.Вставить("ИмяФайлаДиалогаСохранения", "");
	Результат.Вставить("ПоказатьВопросОткрытьСохранить", Ложь);
	
	Возврат Результат;
	
КонецФункции

// Инициализирует структуру параметров для помещения файла из файловой системы клиента на сервер.
// Для использования в ФайлыБТСКлиент.ПоместитьФайлИнтерактивно.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//    * ИмяФайлаИлиАдрес - Строка - Адрес во временном хранилище, либо имя файла на сервере (без пути)
//        для помещения. Если указан адрес во временном хранилище, то при попытке помещения файлов более 4Гб
//        будет вызвано исключение, а для помещения файла более 100Мб потребуется расширение для работы с файлами.
//        Если указан путь к файлу на сервере, то результат будет записан в файл, а для успешной работы в веб 
//        так же потребуется установка расширения для работы с файлами.
//    * ПутьФайлаWindows - Строка - Путь к файлу при работе сеанса на Windows сервере. Значение игнорируется,
//        если в параметре ИмяФайлаИлиАдрес указан адрес во временном хранилище или указано имя зарегистрированного
//        файла временного хранилища.
//    * ПутьФайлаLinux - Строка - Путь к файлу при работе сеанса на Linux сервере. Значение игнорируется,
//        если в параметре ИмяФайлаИлиАдрес указан адрес во временном хранилище или указано имя зарегистрированного
//        файла временного хранилища.
//    * ОписаниеОповещенияОЗавершении - ОписаниеОповещения, Неопределено - Содержит описание процедуры, которая
//        будет вызвана после помещения файла. Если указано Неопределено, никакой обработчик запускаться не будет
//        Вызываемая процедура должна иметь параметры:
//           Результат - Структура, Неопределено - Неопределено при отказе, либо структура со свойствами:
//             ИмяФайлаИлиАдрес - Строка - Адрес во временном хранилище, либо имя файла на сервере (без пути)
//             ИмяФайлаНаКлиенте - Строка - полное имя клиентского файла, помещенного на сервер
//          ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта
//            ОписаниеОповещения.
//    * БлокируемаяФорма - ФормаКлиентскогоПриложения, Неопределено - Владелец формы загрузки файла для блокировки.
//        Если указано Неопределено, на время загрузки будет заблокирован весь интерфейс.
//    * ЗаголовокДиалогаВыбора - Строка, Неопределено - заголовок диалога выбора файла.
//    * ЗаголовокОперацииПомещения - Строка, Неопределено - заголовок формы, отображающей длительную операцию загрузки.
//    * ФильтрДиалогаВыбора - Строка, Неопределено - фильтр диалога выбора файла. Если указано Неопределено, в диалоге
//        можно будет выбрать любой файл.
//    * ИмяФайлаДиалогаВыбора - Строка - Имя клиентского файла, которое будет предложено в диалоге выбора файла
//    * МаксимальныйРазмер - Число, Неопределено - максимальный размер клиентского файла, доступного к помещению
//      на сервер. Если указано Неопределено, размер клиентсколго файла контролироваться не будет.
Функция ПараметрыПомещенияФайла() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ИмяФайлаИлиАдрес", "");
	Результат.Вставить("ПутьФайлаWindows", "");
	Результат.Вставить("ПутьФайлаLinux", "");
	Результат.Вставить("ОписаниеОповещенияОЗавершении", Неопределено);
	Результат.Вставить("БлокируемаяФорма", Неопределено);
	Результат.Вставить("ЗаголовокДиалогаВыбора", Неопределено);
	Результат.Вставить("ЗаголовокОперацииПомещения", Неопределено);
	Результат.Вставить("ФильтрДиалогаВыбора", Неопределено);
	Результат.Вставить("ИмяФайлаДиалогаВыбора", "");
	Результат.Вставить("МаксимальныйРазмер", Неопределено);
	
	Возврат Результат;
	
КонецФункции

// Получает размещенный во временном хранилище или на диске сервера файл, и сохраняет его на клиенте
// в локальной файловой системе пользователя.
//
// Параметры:
//   ПараметрыПолученияФайла - см. ПараметрыПолученияФайла
Процедура ПолучитьФайлИнтерактивно(ПараметрыПолученияФайла) Экспорт
	
	ВсеПараметры = ВсеПараметрыПолученияФайла();
	ЗаполнитьЗначенияСвойств(ВсеПараметры, ПараметрыПолученияФайла);
	
	Если Не ЗначениеЗаполнено(ВсеПараметры.ИмяФайлаИлиАдрес) Тогда
		ТекстОшибки = НСтр("ru = 'Не укано исходное хранение файла на сервере'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;

	Если ЭтоАдресВременногоХранилища(ВсеПараметры.ИмяФайлаИлиАдрес) 
		Или СтрНачинаетсяС(ВсеПараметры.ИмяФайлаИлиАдрес, "e1cib/data/") Тогда
		ИспользоватьПорционнуюПередачу = Ложь;
	Иначе
		ИспользоватьПорционнуюПередачу = Истина;
	КонецЕсли;
	ВсеПараметры.ИспользоватьПорционнуюПередачу = ИспользоватьПорционнуюПередачу;

	Оповещение = Новый ОписаниеОповещения("ПослеПодключенияРасширенияДляПолучения", ЭтотОбъект, ВсеПараметры);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, , Не ИспользоватьПорционнуюПередачу);

КонецПроцедуры

// Помещает выбранный на клиенте файл из локальной файловой системы пользователя во временное хранилище
// или в файл на диске сервера.
//
// Параметры:
//   ПараметрыПомещенияФайла - см. ПараметрыПомещенияФайла
Процедура ПоместитьФайлИнтерактивно(ПараметрыПомещенияФайла) Экспорт
	
	ВсеПараметры = ВсеПараметрыПомещенияФайла();
	ЗаполнитьЗначенияСвойств(ВсеПараметры, ПараметрыПомещенияФайла);

	Если Не ЗначениеЗаполнено(ВсеПараметры.ИмяФайлаИлиАдрес) Тогда
		ТекстОшибки = НСтр("ru = 'Не указано целевое хранение файла на сервере'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;

	Если ЭтоАдресВременногоХранилища(ВсеПараметры.ИмяФайлаИлиАдрес) Тогда
		ИспользоватьПорционнуюПередачу = Ложь;
		МаксимальныйРазмер = ФайлыБТСКлиентСервер.МаксимальныйРазмерВременногоХранилища();
		Если ВсеПараметры.МаксимальныйРазмер = Неопределено Тогда
			ВсеПараметры.МаксимальныйРазмер = МаксимальныйРазмер;
		Иначе
			ВсеПараметры.МаксимальныйРазмер = Мин(ПараметрыПомещенияФайла.МаксимальныйРазмер, МаксимальныйРазмер);
		КонецЕсли;
	Иначе
		ИспользоватьПорционнуюПередачу = Истина;
	КонецЕсли;

	ВсеПараметры.ИспользоватьПорционнуюПередачу = ИспользоватьПорционнуюПередачу;

	ТекстПредложения = СтрШаблон(НСтр("ru = 'Для загрузки файлов, размером более %1, требуется установить расширение для работы с 1С:Предприятием.
									  |С этим расширением работа в веб-клиенте станет удобней не только при работе с большими файлами.'"),
		ФайлыБТСКлиентСервер.ПредставлениеРазмераФайла(ФайлыБТСКлиентСервер.ПриемлемыйРазмерВременногоХранилища()));

	Оповещение = Новый ОписаниеОповещения("ПослеПодключенияРасширенияДляПомещения", ЭтотОбъект, ВсеПараметры);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстПредложения,
		Не ИспользоватьПорционнуюПередачу);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// После подключения расширения для работы с файлами для получения.
// 
// Параметры:
//  Подключено - Булево
//  ДополнительныеПараметры см. ВсеПараметрыПолученияФайла
Процедура ПослеПодключенияРасширенияДляПолучения(Подключено, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.РасширениеПодключено = Подключено;

	Если Не ДополнительныеПараметры.ИспользоватьПорционнуюПередачу Тогда

		Если Подключено Тогда

			Оповещение = Новый ОписаниеОповещения("ПослеПолученияФайлаИзХранилища", ЭтотОбъект, ДополнительныеПараметры);
			ПолучаемыеФайлы = Новый Массив; // Массив из ОписаниеПередаваемогоФайла
			ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ДополнительныеПараметры.ИмяФайлаДиалогаСохранения,
				ДополнительныеПараметры.ИмяФайлаИлиАдрес));
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			Диалог.Заголовок = ДополнительныеПараметры.ЗаголовокДиалогаСохранения;
			Диалог.ПолноеИмяФайла = ДополнительныеПараметры.ИмяФайлаДиалогаСохранения;
			Диалог.Фильтр = ДополнительныеПараметры.ФильтрДиалогаСохранения;
			НачатьПолучениеФайлов(Оповещение, ПолучаемыеФайлы, Диалог, Истина);

		Иначе

			ПолучитьФайл(ДополнительныеПараметры.ИмяФайлаИлиАдрес, ДополнительныеПараметры.ИмяФайлаДиалогаСохранения,
				Истина);

			ОписаниеФайла = Новый Структура;
			ОписаниеФайла.Вставить("ИмяФайлаИлиАдрес", ДополнительныеПараметры.ИмяФайлаИлиАдрес);
			ОписаниеФайла.Вставить("ИмяФайлаНаКлиенте", Неопределено);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, ОписаниеФайла);

		КонецЕсли;

		Возврат;

	КонецЕсли;

	Если Не Подключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
		Возврат;
	КонецЕсли;

	Если ДополнительныеПараметры.ПоказатьВопросОткрытьСохранить Тогда
		ПараметрыПолучения = Новый Структура;
		ПараметрыПолучения.Вставить("ИмяФайлаИлиАдрес", ДополнительныеПараметры.ИмяФайлаИлиАдрес);
		ПараметрыПолучения.Вставить("ПутьФайлаWindows", ДополнительныеПараметры.ПутьФайлаWindows);
		ПараметрыПолучения.Вставить("ПутьФайлаLinux", ДополнительныеПараметры.ПутьФайлаLinux);
		Если ЗначениеЗаполнено(ДополнительныеПараметры.ЗаголовокОперацииПолучения) Тогда
			ПараметрыПолучения.Вставить("ЗаголовокДиалога", ДополнительныеПараметры.ЗаголовокОперацииПолучения);
		Иначе
			ПараметрыПолучения.Вставить("ЗаголовокДиалога", ДополнительныеПараметры.ЗаголовокДиалогаСохранения);
		КонецЕсли;
		ПараметрыПолучения.Вставить("ФильтрДиалогаСохранения", ДополнительныеПараметры.ФильтрДиалогаСохранения);
		ПараметрыПолучения.Вставить("ИмяФайлаДиалогаСохранения", ДополнительныеПараметры.ИмяФайлаДиалогаСохранения);
		ОткрытьФорму("Обработка.ФайлыБТС.Форма.ПолучениеФайла", ПараметрыПолучения,
			ДополнительныеПараметры.БлокируемаяФорма, , , , ДополнительныеПараметры.ОписаниеОповещенияОЗавершении);
		Возврат;
	КонецЕсли;

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок = ДополнительныеПараметры.ЗаголовокДиалогаСохранения;
	Диалог.ПолноеИмяФайла = ДополнительныеПараметры.ИмяФайлаДиалогаСохранения;
	Диалог.Фильтр = ДополнительныеПараметры.ФильтрДиалогаСохранения;
	Диалог.Показать(Новый ОписаниеОповещения("ПослеВыбораИмениФайлаДляПолучения", ЭтотОбъект, ДополнительныеПараметры));

КонецПроцедуры

// После выбора имени файла для получения.
// 
// Параметры:
//  ВыбранныеФайлы - Массив из Строка, Неопределено - выбранные имена или Неопределено, если выбор не осуществлен
//  ДополнительныеПараметры см. ВсеПараметрыПолученияФайла
Процедура ПослеВыбораИмениФайлаДляПолучения(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
		Возврат;
	КонецЕсли;

	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ИмяФайлаИлиАдрес", ДополнительныеПараметры.ИмяФайлаИлиАдрес);
	ПараметрыПолучения.Вставить("ПутьФайлаWindows", ДополнительныеПараметры.ПутьФайлаWindows);
	ПараметрыПолучения.Вставить("ПутьФайлаLinux", ДополнительныеПараметры.ПутьФайлаLinux);
	Если ЗначениеЗаполнено(ДополнительныеПараметры.ЗаголовокОперацииПолучения) Тогда
		ПараметрыПолучения.Вставить("ЗаголовокДиалога", ДополнительныеПараметры.ЗаголовокОперацииПолучения);
	Иначе
		ПараметрыПолучения.Вставить("ЗаголовокДиалога", ДополнительныеПараметры.ЗаголовокДиалогаСохранения);
	КонецЕсли;
	ПараметрыПолучения.Вставить("ИмяФайлаНаКлиенте", ВыбранныеФайлы[0]);
	ОткрытьФорму("Обработка.ФайлыБТС.Форма.ПолучениеФайла", ПараметрыПолучения,
		ДополнительныеПараметры.БлокируемаяФорма, , , , ДополнительныеПараметры.ОписаниеОповещенияОЗавершении);

КонецПроцедуры

// После получения файла из хранилища.
// 
// Параметры:
//  ПолученныеФайлы - Массив из ОписаниеПереданногоФайла, Неопределено
//  ДополнительныеПараметры см. ВсеПараметрыПолученияФайла
Процедура ПослеПолученияФайлаИзХранилища(ПолученныеФайлы, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(ПолученныеФайлы) Тогда
		ОписаниеФайла = Новый Структура();
		ОписаниеФайла.Вставить("ИмяФайлаИлиАдрес", ДополнительныеПараметры.ИмяФайлаИлиАдрес);
		ОписаниеФайла.Вставить("ИмяФайлаНаКлиенте", ПолученныеФайлы[0].ПолноеИмя);
	Иначе
		ОписаниеФайла = Неопределено;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, ОписаниеФайла);

КонецПроцедуры

// После подключения расширения для работы с файлами для помещения.
// 
// Параметры:
//  Подключено - Булево
//  ДополнительныеПараметры см. ВсеПараметрыПомещенияФайла
Процедура ПослеПодключенияРасширенияДляПомещения(Подключено, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.РасширениеПодключено = Подключено;

	Если ДополнительныеПараметры.БлокируемаяФорма = Неопределено Тогда
		ИдФормы = Новый УникальныйИдентификатор;
	Иначе
		ИдФормы = ДополнительныеПараметры.БлокируемаяФорма.УникальныйИдентификатор;
	КонецЕсли;
	ДополнительныеПараметры.Вставить("ИдентификаторФормы", ИдФормы);

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = ДополнительныеПараметры.ЗаголовокДиалогаВыбора;
	Диалог.Фильтр = ДополнительныеПараметры.ФильтрДиалогаВыбора;
	Диалог.ПолноеИмяФайла = ДополнительныеПараметры.ИмяФайлаДиалогаВыбора;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	ДополнительныеПараметры.Вставить("ДиалогВыбораФайла", Диалог);

	Если ДополнительныеПараметры.ИспользоватьПорционнуюПередачу = Неопределено
		Или Не ДополнительныеПараметры.ИспользоватьПорционнуюПередачу Тогда

		ОповещениеПосле = Новый ОписаниеОповещения("ПослеПомещенияФайлаВХранилище", ЭтотОбъект, ДополнительныеПараметры);
		ОповещениеПеред = Новый ОписаниеОповещения("ПередПомещениемФайлаВХранилище", ЭтотОбъект,
			ДополнительныеПараметры);
		НачатьПомещениеФайла(ОповещениеПосле, Неопределено, Диалог, Истина, ДополнительныеПараметры.ИдентификаторФормы,
			ОповещениеПеред);

		Возврат;

	КонецЕсли;

	Если Не Подключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
		Возврат;
	КонецЕсли;

	Диалог.Показать(Новый ОписаниеОповещения("ПослеВыбораИмениФайлаВДиалоге", ЭтотОбъект, ДополнительныеПараметры));

КонецПроцедуры

// После помещения файла в хранилище.
// 
// Параметры:
//  ВыборВыполнен - Булево - Ложь, если пользователь отказался от выполнения операции в диалоге выбора файла
//  Адрес - Строка - расположение нового файла
//  ВыбранноеИмяФайла - Строка
//  ПараметрыЗагрузки см. ВсеПараметрыПомещенияФайла
Процедура ПослеПомещенияФайлаВХранилище(ВыборВыполнен, Адрес, ВыбранноеИмяФайла, ПараметрыЗагрузки) Экспорт
	
	Если ВыборВыполнен Тогда
		ОписаниеФайла = Новый Структура();
		ОписаниеФайла.Вставить("ИмяФайлаИлиАдрес", Адрес);
		ОписаниеФайла.Вставить("ИмяФайлаНаКлиенте", ВыбранноеИмяФайла);
	Иначе
		ОписаниеФайла = Неопределено;
	КонецЕсли;
	
	ДлительнаяОперация = ПараметрыЗагрузки.ДлительнаяОперация; // см. Обработка.ФайлыБТС.Форма.ДлительнаяОперация
	Если ДлительнаяОперация <> Неопределено Тогда
		Если ДлительнаяОперация.ОперацияПрервана Тогда
			УдалитьИзВременногоХранилища(Адрес);
			ОписаниеФайла = Неопределено;
		КонецЕсли;
		Если ДлительнаяОперация.Открыта() Тогда
			ДлительнаяОперация.ПрерываниеРазрешено = Истина;
			ДлительнаяОперация.Закрыть();
		КонецЕсли;
		ДлительнаяОперация = Неопределено;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ПараметрыЗагрузки.ОписаниеОповещенияОЗавершении, ОписаниеФайла);
	
КонецПроцедуры

// Перед помещением файла в хранилище.
// 
// Параметры:
//  СсылкаНаФайл - СсылкаНаФайл - ссылка на файл, готовый к помещению во временное хранилище.
//  Отказ - Булево - признак отказа от дальнейшего помещения файла
//  ПараметрыЗагрузки см. ВсеПараметрыПомещенияФайла
Процедура ПередПомещениемФайлаВХранилище(СсылкаНаФайл, Отказ, ПараметрыЗагрузки) Экспорт
	
	СвойстваФайла = НовыйСвойстваФайла(СсылкаНаФайл.Имя, СсылкаНаФайл.Расширение, СсылкаНаФайл.Размер());

	ПроверкаФайлаПередПомещением(СвойстваФайла, Отказ, ПараметрыЗагрузки);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	СвойстваОперации = Новый Структура;
	СвойстваОперации.Вставить("ЗаголовокДиалога", ПараметрыЗагрузки.ЗаголовокОперацииПомещения);
	СвойстваОперации.Вставить("ПрерываниеРазрешено", Истина);
	ПараметрыЗагрузки.ДлительнаяОперация = ОткрытьФорму("Обработка.ФайлыБТС.Форма.ДлительнаяОперация",
		СвойстваОперации, ПараметрыЗагрузки.БлокируемаяФорма);

КонецПроцедуры

// После выбора имени файла в диалоге.
// 
// Параметры:
//  ВыбранныеФайлы - Массив из Строка
//  ДополнительныеПараметры см. ВсеПараметрыПомещенияФайла
Процедура ПослеВыбораИмениФайлаВДиалоге(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
		Возврат;
	КонецЕсли;
	
	ИмяФайлаНаКлиенте = ВыбранныеФайлы[0];
	ДополнительныеПараметры.ИмяФайлаНаКлиенте = ИмяФайлаНаКлиенте;
	
	Оповещение = Новый ОписаниеОповещения("ПослеПроверкиСуществования", ЭтотОбъект, ДополнительныеПараметры);
	ОбъектФС = Новый Файл(ИмяФайлаНаКлиенте);
	ОбъектФС.НачатьПроверкуСуществования(Оповещение);
	
КонецПроцедуры

// После проверки существования.
// 
// Параметры:
//  Существует - Булево
//  ДополнительныеПараметры см. ВсеПараметрыПомещенияФайла
Процедура ПослеПроверкиСуществования(Существует, ДополнительныеПараметры) Экспорт
	
	Если НЕ Существует Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
		Возврат;
	КонецЕсли;
		
	Оповещение = Новый ОписаниеОповещения("ПослеПроверкиЭтоФайл", ЭтотОбъект, ДополнительныеПараметры);
	ОбъектФС = Новый Файл(ДополнительныеПараметры.ИмяФайлаНаКлиенте);
	ОбъектФС.НачатьПроверкуЭтоФайл(Оповещение);

КонецПроцедуры

// После проверки это файл.
// 
// Параметры:
//  ЭтоФайл - Булево
//  ДополнительныеПараметры см. ВсеПараметрыПомещенияФайла
Процедура ПослеПроверкиЭтоФайл(ЭтоФайл, ДополнительныеПараметры) Экспорт

	Если НЕ ЭтоФайл Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
		Возврат;
	КонецЕсли;

	Оповещение = Новый ОписаниеОповещения("ПослеПолученияРазмера", ЭтотОбъект, ДополнительныеПараметры);
	ОбъектФС = Новый Файл(ДополнительныеПараметры.ИмяФайлаНаКлиенте);
	ОбъектФС.НачатьПолучениеРазмера(Оповещение);
	
КонецПроцедуры

// После получения размера.
// 
// Параметры:
//  Размер - Число
//  ДополнительныеПараметры см. ВсеПараметрыПомещенияФайла
Процедура ПослеПолученияРазмера(Размер, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("РазмерФайла", Размер);

	ОбъектФС = Новый Файл(ДополнительныеПараметры.ИмяФайлаНаКлиенте);

	СвойстваФайла = НовыйСвойстваФайла(ОбъектФС.Имя, ОбъектФС.Расширение, Размер);

	Отказ = Ложь;
	ПроверкаФайлаПередПомещением(СвойстваФайла, Отказ, ДополнительныеПараметры);

	Если Отказ Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
		Возврат;
	КонецЕсли;

	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ИмяФайлаИлиАдрес", ДополнительныеПараметры.ИмяФайлаИлиАдрес);
	ПараметрыПолучения.Вставить("ПутьФайлаWindows", ДополнительныеПараметры.ПутьФайлаWindows);
	ПараметрыПолучения.Вставить("ПутьФайлаLinux", ДополнительныеПараметры.ПутьФайлаLinux);
	ПараметрыПолучения.Вставить("ЗаголовокДиалога", ДополнительныеПараметры.ЗаголовокОперацииПомещения);
	ПараметрыПолучения.Вставить("ИмяФайлаНаКлиенте", ДополнительныеПараметры.ИмяФайлаНаКлиенте);
	ПараметрыПолучения.Вставить("ПредставлениеФайла", ФайлыБТСКлиентСервер.ПредставлениеФайла(
		ДополнительныеПараметры.ИмяФайлаНаКлиенте, Размер));
	ПараметрыПолучения.Вставить("РазмерФайла", Размер);
	ОткрытьФорму("Обработка.ФайлыБТС.Форма.ПомещениеФайла", ПараметрыПолучения,
		ДополнительныеПараметры.БлокируемаяФорма, , , , ДополнительныеПараметры.ОписаниеОповещенияОЗавершении);

КонецПроцедуры

// Новый свойства файла
// 
// Параметры:
//  Имя - Строка
//  Расширение - Строка
//  Размер - Число
// 
// Возвращаемое значение:
//  Структура:
// * Имя - Строка
// * Расширение - Строка
// * Размер - Число
Функция НовыйСвойстваФайла(Имя, Расширение, Размер)
	
	СвойстваФайла = Новый Структура;
	СвойстваФайла.Вставить("Имя", Имя);
	СвойстваФайла.Вставить("Расширение", Расширение);
	СвойстваФайла.Вставить("Размер", Размер);
	
	Возврат СвойстваФайла;
	
КонецФункции

// Проверка файла перед помещением.
// 
// Параметры:
//  СсылкаНаФайл - см. НовыйСвойстваФайла
//  Отказ - Булево
//  ПараметрыПроверки см. ВсеПараметрыПомещенияФайла
Процедура ПроверкаФайлаПередПомещением(СсылкаНаФайл, Отказ, ПараметрыПроверки)
	
	Если СсылкаНаФайл = Неопределено Тогда
		ОбработатьОшибкуПроверки(Отказ, НСтр("ru = 'Не указана ссылка на файл'"));
		Возврат;
	КонецЕсли;

	СвойстваФильтра = СвойстваФильтраДиалога(ПараметрыПроверки.ФильтрДиалогаВыбора);
	Если СвойстваФильтра <> Неопределено И СвойстваФильтра.Расширения.Найти(НРег(СсылкаНаФайл.Расширение)) = Неопределено
		И СвойстваФильтра.Расширения.Найти("*") = Неопределено Тогда
		ОбработатьОшибкуПроверки(Отказ, СтрШаблон(НСтр("ru = 'Выбран неверный тип файла. Выберите:
													   |%1'"), СтрСоединить(СвойстваФильтра.Представления, Символы.ПС)));
		Возврат;
	КонецЕсли;

	Если Не ПараметрыПроверки.РасширениеПодключено Тогда
		МаксРазмерБезРасширения = ФайлыБТСКлиентСервер.ПриемлемыйРазмерВременногоХранилища();
		Если СсылкаНаФайл.Размер > МаксРазмерБезРасширения Тогда
			ОбработатьОшибкуПроверки(Отказ, СтрШаблон(НСтр("ru = 'Выбран файл %1 больше %2
				|Для работы в веб клиенте с такими файлами требуется установка расширения 1С:Предприятия.
				|Воспользуйтесь тонким клиентом, либо установите расширение'"),
				СсылкаНаФайл.Имя, ФайлыБТСКлиентСервер.ПредставлениеРазмераФайла(МаксРазмерБезРасширения)));
		КонецЕсли;
	КонецЕсли;

	МаксимальныйРазмер = ПараметрыПроверки.МаксимальныйРазмер;
	Если МаксимальныйРазмер = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если СсылкаНаФайл.Размер > МаксимальныйРазмер Тогда
		Если МаксимальныйРазмер <= 0 Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Размер файла должен быть равен %1'"),
				ФайлыБТСКлиентСервер.ПредставлениеРазмераФайла(0));
		Иначе
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Файл %1 слишком большой. Выберите файл менее %2'"), СсылкаНаФайл.Имя,
				ФайлыБТСКлиентСервер.ПредставлениеРазмераФайла(МаксимальныйРазмер));
		КонецЕсли;
		ОбработатьОшибкуПроверки(Отказ, ТекстОшибки);
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработатьОшибкуПроверки(Отказ, ТекстПредупреждения)
	
	Отказ = Истина;
	ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
	
КонецПроцедуры

Функция СвойстваФильтраДиалога(ФильтрДиалога)
	
	Если Не ЗначениеЗаполнено(ФильтрДиалога) Тогда
		Возврат Неопределено;
	КонецЕсли;

	Представления = Новый Массив; // Массив из Строка
	Маски = Новый Массив; // Массив из Строка
	Расширения = Новый Массив; // Массив из Строка
	Результат = Новый Структура("Представления, Маски, Расширения", Представления, Маски, Расширения);

	ЭлементыФильтра = СтрРазделить(ФильтрДиалога, "|");
	Пока ЭлементыФильтра.ВГраница() > 0 Цикл

		Представление = ЭлементыФильтра[0];
		Маска = ЭлементыФильтра[1];

		Результат.Представления.Добавить(Представление);
		Результат.Маски.Добавить(Маска);

		ЭлементыМаски = СтрРазделить(Маска, ";");
		Для Каждого ЭлементМаски Из ЭлементыМаски Цикл
			Если ЭлементМаски = "*.*" Или ЭлементМаски = "*" Тогда
				Результат.Расширения.Добавить("*");
				Прервать;
			Иначе
				Поз = СтрНайти(ЭлементМаски, ".", НаправлениеПоиска.СКонца);
				Если Поз > 0 Тогда
					Результат.Расширения.Добавить(НРег(Сред(ЭлементМаски, Поз)));
				Иначе
					Результат.Расширения.Добавить("");
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;

		ЭлементыФильтра.Удалить(0);
		ЭлементыФильтра.Удалить(0);

	КонецЦикла;

	Возврат Результат;

КонецФункции

// Все параметры получения файла.
//
// Возвращаемое значение:
//  Структура:
//    * ИмяФайлаИлиАдрес - Строка
//    * ПутьФайлаWindows - Строка
//    * ПутьФайлаLinux - Строка
//    * ОписаниеОповещенияОЗавершении - ОписаниеОповещения, Неопределено -
//    * БлокируемаяФорма - ФормаКлиентскогоПриложения, Неопределено -
//    * ЗаголовокДиалогаСохранения - Строка
//    * ЗаголовокОперацииПолучения - Строка
//    * ФильтрДиалогаСохранения - Строка
//    * ИмяФайлаДиалогаСохранения - Строка
//    * ПоказатьВопросОткрытьСохранить - Булево
//    * ИспользоватьПорционнуюПередачу - Булево 
//    * РасширениеПодключено - Булево
Функция ВсеПараметрыПолученияФайла()
	
	Результат = Новый Структура();
	Результат.Вставить("ИмяФайлаИлиАдрес", "");
	Результат.Вставить("ПутьФайлаWindows", "");
	Результат.Вставить("ПутьФайлаLinux", "");
	Результат.Вставить("ОписаниеОповещенияОЗавершении", Неопределено);
	Результат.Вставить("БлокируемаяФорма", Неопределено);
	Результат.Вставить("ЗаголовокДиалогаСохранения", "");
	Результат.Вставить("ЗаголовокОперацииПолучения", "");
	Результат.Вставить("ФильтрДиалогаСохранения", "");
	Результат.Вставить("ИмяФайлаДиалогаСохранения", "");
	Результат.Вставить("ПоказатьВопросОткрытьСохранить", Ложь);
	Результат.Вставить("ИспользоватьПорционнуюПередачу", Ложь);
	Результат.Вставить("РасширениеПодключено", Ложь);
	
	Возврат Результат;
	
КонецФункции

// Все параметры помещения файла.
// 
// Возвращаемое значение:
//  Структура:
// * ИмяФайлаИлиАдрес - Строка
// * ПутьФайлаWindows - Строка
// * ПутьФайлаLinux - Строка
// * ОписаниеОповещенияОЗавершении - ОписаниеОповещения, Неопределено -
// * БлокируемаяФорма - ФормаКлиентскогоПриложения, Неопределено -
// * ЗаголовокДиалогаВыбора - Строка
// * ЗаголовокОперацииПомещения - Строка
// * ФильтрДиалогаВыбора - Строка
// * ИмяФайлаДиалогаВыбора - Строка
// * МаксимальныйРазмер - Число, Неопределено -
// * ИспользоватьПорционнуюПередачу - Булево
// * РасширениеПодключено - Булево
// * ДлительнаяОперация - ФормаКлиентскогоПриложения, Неопределено -
// * ИмяФайлаНаКлиенте - Строка
Функция ВсеПараметрыПомещенияФайла()
	
	Результат = Новый Структура();
	Результат.Вставить("ИмяФайлаИлиАдрес", "");
	Результат.Вставить("ПутьФайлаWindows", "");
	Результат.Вставить("ПутьФайлаLinux", "");
	Результат.Вставить("ОписаниеОповещенияОЗавершении", Неопределено);
	Результат.Вставить("БлокируемаяФорма", Неопределено);
	Результат.Вставить("ЗаголовокДиалогаВыбора", "");
	Результат.Вставить("ЗаголовокОперацииПомещения", "");
	Результат.Вставить("ФильтрДиалогаВыбора", "");
	Результат.Вставить("ИмяФайлаДиалогаВыбора", "");
	Результат.Вставить("МаксимальныйРазмер", Неопределено);
	Результат.Вставить("ИспользоватьПорционнуюПередачу", Ложь);
	Результат.Вставить("РасширениеПодключено", Ложь);
	Результат.Вставить("ДлительнаяОперация", Неопределено);
	Результат.Вставить("ИмяФайлаНаКлиенте", "");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти