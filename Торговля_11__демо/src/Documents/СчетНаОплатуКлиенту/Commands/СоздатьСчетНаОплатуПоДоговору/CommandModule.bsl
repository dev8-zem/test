&НаСервере
Функция ПроверитьВозможностьСозданияСчетовНаОплату(Договор)
	
	ПорядокРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ПорядокРасчетов");
	Возврат ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если НЕ ПроверитьВозможностьСозданияСчетовНаОплату(ПараметрКоманды) Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ввод счета на оплату на основании договора %1 возможен только при детализации расчетов ""По договорам"".'"),
			ПараметрКоманды);
		ВызватьИсключение Текст;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ДокументОснование", ПараметрКоманды);
	
	ОткрытьФорму(
		"Документ.СчетНаОплатуКлиенту.Форма.ФормаСозданияСчетовНаОплату",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
