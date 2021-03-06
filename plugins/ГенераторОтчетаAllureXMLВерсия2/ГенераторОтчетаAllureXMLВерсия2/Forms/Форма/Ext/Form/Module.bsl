﻿&НаКлиенте
Перем КонтекстЯдра;

// { Plugin interface

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
КонецПроцедуры

&НаКлиенте
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(ВозможныеТипыПлагинов);
КонецФункции
// } Plugin interface

// { Report generator interface
&НаКлиенте
Функция СоздатьОтчет(Знач КонтекстЯдра, Знач РезультатыТестирования) Экспорт
	Объект.ТипыУзловДереваТестов = КонтекстЯдра.Плагин("ПостроительДереваТестов").Объект.ТипыУзловДереваТестов;
	Объект.ИконкиУзловДереваТестов = КонтекстЯдра.Плагин("ПостроительДереваТестов").Объект.ИконкиУзловДереваТестов;
	Объект.СостоянияТестов = КонтекстЯдра.Объект.СостоянияТестов;
	Возврат СоздатьОтчетНаСервере(РезультатыТестирования);
КонецФункции

&НаСервере
Функция СоздатьОтчетНаСервере(Знач РезультатыТестирования)
	Результат = ЭтотОбъектНаСервере().СоздатьОтчетНаСервере(РезультатыТестирования);
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура Показать(Отчет) Экспорт
	Отчет.Показать();
КонецПроцедуры

&НаКлиенте
Процедура Экспортировать(Отчет, ПолныйПутьФайла) Экспорт

	СтрокаJSON = Отчет.ПолучитьТекст();
	
	ИмяФайла = ПолныйПутьФайла;
	
	ИмяФайла = ПолучитьУникальноеИмяФайла(ИмяФайла); 
	
	ПроверитьИмяФайлаРезультатаAllureСервер(ИмяФайла);
	
	// Запись файла с кодировкой "UTF-8", а не "UTF-8 with BOM"
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.ANSI);
	ЗаписьТекста.Закрыть();
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла,,, Истина);
	ЗаписьТекста.Записать(СтрокаJSON);
	ЗаписьТекста.Закрыть();

КонецПроцедуры
// } Report generator interface

&НаКлиенте
Процедура НачатьЭкспорт(ОбработкаОповещения, Отчет, ПолныйПутьФайла) Экспорт

	Экспортировать(Отчет, ПолныйПутьФайла);
	ВыполнитьОбработкуОповещения(ОбработкаОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРезультатТеста(Знач КонтекстЯдра, Знач РезультатТеста, Знач ПолныйПутьФайла) Экспорт
	Объект.СостоянияТестов = КонтекстЯдра.Объект.СостоянияТестов;
	ЗаписатьРезультатТестаНаСервере(РезультатТеста, ПолныйПутьФайла);
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРезультатТестаНаСервере(Знач РезультатТеста, Знач ПолныйПутьФайла) Экспорт
	ЭтотОбъектНаСервере().ЗаписатьРезультатТестаНаСервере(РезультатТеста, ПолныйПутьФайла);	
КонецПроцедуры

// { Helpers

&НаКлиенте
// задаю уникальное имя для возможности получения одного отчета allure по разным тестовым наборам
Функция ПолучитьУникальноеИмяФайла(Знач ИмяФайла)
	Файл = Новый Файл(ИмяФайла);
	ГУИД = Новый УникальныйИдентификатор;
	ИмяФайла = СтрЗаменить("%1-result.json", "%1", ГУИД);
	//ИмяФайла = СтрЗаменить(ИмяФайла, "%2", Файл.ИмяБезРасширения);
	ИмяФайла = Файл.Путь + "/"+ ИмяФайла; 
	Возврат ИмяФайла;
КонецФункции

&НаСервере
Процедура ПроверитьИмяФайлаРезультатаAllureСервер(ИмяФайла) Экспорт
	
	Сообщение = "Уникальное имя файла " + ИмяФайла;
	ЗаписьЖурналаРегистрации("xUnitFor1C.ГенераторОтчетаAllureXMLВерсия2", УровеньЖурналаРегистрации.Информация, , , Сообщение);
	
	ЭтотОбъектНаСервере().ПроверитьИмяФайлаРезультатаAllure(ИмяФайла);
КонецПроцедуры

&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
// } Helpers

