---
title: "Аутентификация"
date: 2021-01-26T09:18:33+03:00
draft: false
weight: 2
typora-root-url: ../../static
---

Большинство запросов к API требуют аутентификации. В данный момент поддерживается два метода аутентификации: с помощью пароля, и с помощью аутентификационного токена.

Предпочтительная схема взаимодействия с API выглядит так:

1. Получить аутентификационный токен с помощью метода [`get_authtoken`](/api/authentication/#mетод-get_authtoken---получение-аутентификационного-токена). Этот запрос подтвердить логином и паролем пользователя.
2. Дальнейшие запросы аутентифицировать полученным токеном, а пароль пользователя больше не использовать и не хранить.
3. Если запрос к API провалился с кодом 403, то возможно токен был отозван пользователем. В этом случае нужно предложить пользователю снова ввести логин и пароль, получить новый токен с помощью `get_authtoken` и в дальнешем использовать его.

## Аутентификация паролем

Просто укажите логин и пароль пользователя с помощью HTTP Basic Authentication. Это можно сделать либо встроенными средствами вашей http-библиотеки, либо указав заголовок: `Authorization: Basic XXX`, где `XXX` — это строка `логин:пароль`, закодированная в [Base64](https://ru.wikipedia.org/wiki/Base64).

{{< alert style="info" >}} Хотя пароль пользователя указывается в открытом виде, тем не менее это безопасно, так как API доступно только по зашифрованному протоколу HTTPS. {{< /alert >}}

```python
import requests

result = requests.post(
    'https://plus.auto-scan.ru/api/get_authtoken',
    auth=('login', 'password'),
    headers={'X-ZONT-Client': 'your@email'},
    json={"client_name": "My cool app"}
).json()
```



## Аутентификация с помощью токена

Укажите аутентификационный токен в заголовке `X-ZONT-Token`.

Пример:

```python
import requests

result = requests.post(
    'https://plus.auto-scan.ru/api/some_method',
    headers={'X-ZONT-Client': 'your@email',
             'X-ZONT-Token': 'xxxxxxxxx'}
).json()
```

## Mетод get_authtoken - Получение аутентификационного токена

`POST https://plus.auto-scan.ru/api/get_authtoken`

Возвращает аутентификационный токен для использования в дальнейшем для запросов от имени указанного пользователя.

Этот метод должен отправляться с [аутентификацией по паролю](/api/authentication/#аутентификация-паролем).

### Параметры

| Имя           | Тип    | Описание                                    |
| :------------ | :----- | :------------------------------------------ |
| `client_name` | string | человекопонятное название вашего приложения |

### Результат

В поле `token` будет строка — аутентификационный токен, который нужно указывать в заголовке `X-ZONT-Token` в последующих запросах.

```python
import requests

result = requests.post(
    'https://plus.auto-scan.ru/api/get_authtoken',
    auth=('login', 'password'),
    headers={'X-ZONT-Client': 'your@email'},
    json={"client_name": "My cool app"}
).json()

token = result['token']
```
