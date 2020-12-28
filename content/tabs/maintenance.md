---
title: "Модуль технического обслуживания"
date: 2020-12-28T15:16:19+03:00
draft: false
---
Модуль технического обслуживания предназначен для ведения истории обслуживания транспортного средства, создания и ведения плана обслуживания, а также для уведомления о предстоящих операциях ТО. Модуль доступен с главной страницы и находится на вкладке «ТО».

![image-20201228110357226](/images/maintenance/image-20201228104715830.png )

## История обслуживания.

Это подмодуль, предназначенный для сохранения истории обслуживания ТС.

![image-20201228110357226](/images/maintenance/image-20201228110357226.png)

Можно назначить план обслуживания для данного ТС. Об этом ниже.

#### Актуальный пробег и моточасы.

Пробег считается на сервере исходя из передвижения прибора за день. Статистика обновляется ночью, между 00:00 и 02:00 (по московскому времени). Статистику можно обновить на текущий момент времени, нажав на кнопку под цифрой 1. Пробег пересчитается, и в поле 2 обновится дата и время.

![image-20201228111658725](/images/maintenance/image-20201228111658725.png)

Аналогично доступен правый клик мыши - всплывёт контекстное меню.

![image-20201228130656598](/images/maintenance/image-20201228130656598.png)

###### Изменения пробега

Если вы заметили большое расхождение пробега с Вашими данными, можно его переписать. Для этого нажмите на кнопку с иконкой карандаша и откроется новое диалоговое окно такого вида:

![image-20201228112604219](/images/maintenance/image-20201228112604219.png)

Введите новое значение пробега и нажмите клавишу изменить. Статистика будет считать данные уже от нового пробега.

Все изменения пробега «вручную» будут отражены в истории изменений в этом диалоге:

![image-20201228113151126](/images/maintenance/image-20201228113151126.png)

#### Ведение истории обслуживания.

Чтобы добавить новую запись в историю обслуживания необходимо нажать кнопку «внести». 

![image-20201228114430615](/images/maintenance/image-20201228114430615.png)

Откроется диалог создания операции ТО. Обязательным полем является «Название». 

![image-20201228114714973](/images/maintenance/image-20201228114714973.png)

Остальные поля заполните по собственному желанию, например так:

![image-20201228115144144](/images/maintenance/image-20201228115144144.png)

Нажмите кнопку создать и операция запишется в базу данных. В таблице истории появится новая запись.

![image-20201228115309476](/images/maintenance/image-20201228115309476.png)

Таблицу можно сортировать, фильтровать, искать по ней.

В столбце сделано будет отображена информация из полей Пробег, Моточасы и Дата (при их заполнении). Для более подробной информации наведите на иконку - появится подсказка. ![image-20201228115513882](/images/maintenance/image-20201228115513882.png)

Для того, чтобы отредактировать операцию - кликните на строку в таблице - откроется диалоговое окно редактирования. Из этого же диалога операцию можно удалить.

![image-20201228120016384](/images/maintenance/image-20201228120016384.png)



## Планы.

Это подмодуль, предназначенный для создания плана обслуживания ТС. Можно продублировать книгу по эксплуатации ТС, добавить свои операции. Если у Вас 10 одинаковых машин - создайте для них единый план обслуживания. Кликните на кнопку +, чтобы добавить план ТО.

![image-20201228120952377](/images/maintenance/image-20201228120952377.png)

Откроется диалог:

![image-20201228121258525](/images/maintenance/image-20201228121258525.png)

Введите желаемое название и кликните создать. Появится Ваш первый план ТО.

![image-20201228121415250](/images/maintenance/image-20201228121415250.png)

Кликните на добавить и откроется диалог создания операции ТО.

![image-20201228122646137](/images/maintenance/image-20201228122646137.png)

Например, у меня новая машина и я хочу не забыть провести на ней ТО-1. Создаю такую операцию:

![image-20201228123119648](/images/maintenance/image-20201228123119648.png)

ТО-1 мне нужно сделать на пробеге 10 тысяч км, или на 250 моточасов, или спустя год эксплуатации (начало даты эксплуатации задаётся в настройках). Хочу, чтобы пришло напоминание за 500 километров, или за 20 моточасов, или за 2 недели (что наступит раньше). В таблице появится запись такого вида:

![image-20201228123555876](/images/maintenance/image-20201228123555876.png)

#### Регулярные операции.

Допустим, я хочу менять масло чаще, чем по регламенту - раз в 5 тысяч километров. Можно сделать одну запись и она будет регулярно повторяться после выполнения (запись о выполнении производится вручную).

![image-20201228124346995](/images/maintenance/image-20201228124346995.png)

Начиная с общего пробега в 5000 км, я хочу менять масло раз в 5000 км, получая напоминания за 300 км до назначенного пробега. Аналогично для моточасов (каждый 250) и дней в эксплуатации. Что наступит раньше - по тому и уведомим. Допустим, не ездили на ТС пол-года, пробег не накручивался, а время заменить масло пришло - мы напомним об этом.

#### Дата начала эксплуатации.

Дата начала эксплуатации задаётся в настройках прибора на вкладке «Общие». Исходя из этой даты мы сможем считать запланированные и регулярные ТО по времени.

![image-20201228123909753](/images/maintenance/image-20201228123909753.png)

#### Изменения плана ТО.

Можно изменить название плана, удалить его или продублировать. Это доступно в подменю с 3 точками.

![image-20201228125352639](/images/maintenance/image-20201228125352639.png)

Аналогично, любую операцию можно отредактировать/удалить из по клику на строчку таблицы.



### Назначить ТС на план ТО.

Возвращаемся на вкладку «История обслуживания». Нажимаем на клавишу 1 и появляется список со всеми планами ТО. Кликнув на нужный, назначим это ТС обслуживаться по выбранному плану.

![image-20201228130056100](/images/maintenance/image-20201228130056100.png)

Появится новая строка с ближайшими операциями ТО.

![image-20201228130304982](/images/maintenance/image-20201228130304982.png)

Когда придёт срок ТО, Вам придёт напоминание о нём и станет доступно нажатие на это ТО, чтобы быстро внести его в историю обслуживания.