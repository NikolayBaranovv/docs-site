---
title: "Баланс"
date: 2021-01-26T10:20:55+03:00
weight: 3
draft: false
typora-root-url: ../../static
---

В [ЛК Дилера](/dealer-ui/) можно устанавливать абонентскую плату для клиентов с помощью тарифов.

## Метод asp_billing/abacus_topup - Пополнение баланса клиента

`POST https://plus.auto-scan.ru/api/asp_billing/abacus_topup`

Используется для пополнение баланса клиента на сумму или количество дней.

### Параметры

| *Имя*            | *Тип* | *Описание*                                   |
| ---------------- | ----- | -------------------------------------------- |
| client_user_id\* | int   | ID клиента                                   |
| balance_x100     | int   | Значение денег на которое пополняется баланс |
| days             | int   | Значение дней на которое пополняется баланс  |
| comment          | str   | Комментарий к пополнению                     |

\* - обозначены обязательные параметры.

### Результат

В случае успеха возвращает JSON вида:

```python
{
  "ok": True,
  "abacus_state": {
      "change_no": int,
      "banned": bool,
      "ban_time": unixtime | Null,
      "ban_reason": 'balance' | 'days' | 'manual' | Null,
      'balance_x100': int,
      'days_left': int,
      'charged_up_to': unixtime | Null
  },
}
```

```python
import requests

result = requests.post(
    'https://plus.auto-scan.ru/api/asp_billing/abacus_topup',
    auth=('dealer_login', 'dealer_password'),
    headers={'X-ZONT-Client': 'your@email'},
    json={"client_user_id": 2,
         "balance_x100": 100,
         "days": 0,
         "comment": "Пополнить баланс клиента Демо на 100 рублей"
         }
).json()
```

