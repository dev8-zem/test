#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	КлючеваяОперация = "Обработка.ЖурналБилетовИБронирований.Команда.ЭлектронныеБилетыИБронирования";
	ОценкаПроизводительностиКлиент.ЗамерВремени(КлючеваяОперация);
	
	ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("Обработка.ЖурналБилетовИБронирований.Форма",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
КонецПроцедуры

#КонецОбласти