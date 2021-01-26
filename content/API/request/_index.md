---
title: "Формат запросов"
date: 2021-01-26T09:13:59+03:00
draft: false
weight: 1
typora-root-url: ../../static
---

Обращения к API производятся с помощью POST-запросов на адрес `https://plus.auto-scan.ru/api/method`, где *method* — названия метода API. Некоторые методы вызываются с помощью метода GET, это оговаривается отдельно в описании этих методов.

В каждом запросе должен быть указан заголовок `X-ZONT-Client`. Укажите в этом заголовке ваш e-mail или иной контакт, по которому мы сможем связаться с вами в случае планируемых изменений в API.

Параметры запроса передаются одним из способов:

- В теле запроса в формате [JSON](https://ru.wikipedia.org/wiki/JSON). Заголовок `Content-Type` при этом должен быть равен `application/json`. Этот способ является предпочтительным.
- В теле запроса в формате `имя1=значение1&имя2=значение2`. Это стандартный формат передачи параметров в POST-запросах. Заголовок `Content-Type` при этом должен быть равен `application/x-www-form-urlencoded`. Такой способ передачи параметров может использоваться только в тех случаях, когда параметры простые, без вложенности.
- В случае GET-запроса параметры передаются в URL, например: `https://plus.auto-scan.ru/api/method?arg1=value1&arg2=value2`.

```python
POST https://plus.auto-scan.ru/api/set_io_port HTTP/1.1
Host: zont-online.ru
Content-Type: application/json
Content-Length: 88
Authorization: Basic ZWxvbjptYXJzNGV2ZXI=
X-ZONT-Client: elon@tesla.com

{
  "device_id": 1209,
  "portname": "siren",
  "type": "bool",
  "value": true
}
```



## Результат запроса

Если не оговорено иное, сервер отвечает на запрос результатом в формате [JSON](https://ru.wikipedia.org/wiki/JSON). В возвращаемом объекте всегда присутствует поле `"ok"`, которое равно `true` в случае успеха или `false` в случае ошибки. Если поле `"ok"` равно `false`, то в ответе также будут присутствовать поля `"error"` с кодом ошибки и `"error_ui"` с её описанием на русском языке. `"error_ui"` может содержать либо строку, либо массив строк если возникло несколько ошибок.

```python
{
  "ok": false,
  "error": "no_such_device",
  "error_ui": "Устройство не найдено"
}
```

