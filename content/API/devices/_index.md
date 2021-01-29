---
title: "Устройство"
date: 2021-01-29T09:36:04+03:00
draft: false
weight: 5
typora-root-url: ../../static
---

Можно получить все данные о приборе.

## Метод devices - Получение информации об устройстве.

`POST https://plus.auto-scan.ru/api/devices`

Можно получить данные о последней геопозиции, скорости, времени.

### Параметры

| *Имя*        | *Тип* | *Описание*                                                  |
| ------------ | ----- | ----------------------------------------------------------- |
| device_ids\* | array | Массив из N-int, где каждое значение `device_id` устройства |
| load_io      | bool  | Загружать входы-выходы устройства (по умолчанию `False`)    |

\* - обозначены обязательные параметры.

### Результат

В случае успеха возвращает JSON вида:

```python
{
  "ok": True,
  "devices": [device],
  "device_tree": [device_tree],
}
```

### Тип device

| *Имя*             | *Тип*         | *Описание*                                                   |
| ----------------- | ------------- | ------------------------------------------------------------ |
| id                | int           | ID номер устройства в системе А+                             |
| online            | bool          | На связи ли устройство сейчас                                |
| serial            | str           | Серийный номер устройства                                    |
| firmware_version  | array         | Массив из двух чисел `[версия аппаратная, версия прошивки * 100]` |
| timezone          | int           | Часовая зона устройства                                      |
| work_state        | dict \| null  | Данные о пробеге [WorkState](/api/devices/#тип-workstate)    |
| sim_number        | str \| null   | Номер сим-карты **(ЗАПОЛНЯЕТСЯ ПОЛЬЗОВАТЕЛЕМ)**              |
| imei              | str           | IMEI устройства                                              |
| last_gps          | array \| null | Массив с последними 5 [GPS-точками](/api/devices/#тип-gpspoint) |
| autoscan_settings | dict \| null  | Настройки со старой версии ПО                                |

&nbsp;

{{< alert style="info" >}} Тип device описан не полностью и может меняться.{{< /alert >}}

### Тип WorkState

| *Имя*            | *Тип* | *Описание*                                                   |
| ---------------- | ----- | ------------------------------------------------------------ |
| mileage          | dict  | Словарь типа [WorkStateItem](/api/devices/#тип-workstateitem) с данными о пробеге |
| moto_houts       | dict  | Словарь типа [WorkStateItem](/api/devices/#тип-workstateitem) с данными о моточасах |
| day_in_operation | dict  | Словарь типа [WorkStateItem](/api/devices/#тип-workstateitem) с данными о днях в эксплуатации |

### Тип WorkStateItem

| *Имя*          | *Тип* | *Описание*                                                   |
| -------------- | ----- | ------------------------------------------------------------ |
| user_counted   | dict  | Данные, посчитанные для пользователя в виде `{"value": float, "time": Unixtime}`. Обновляются по запросу от пользователя и раз в сутки. |
| server_counted | dict  | Данные, посчитанные сервером в виде `{"value": float, "time": Unixtime}`. Обновляются раз в сутки. |
| edit_history   | array | Массив из dict'ов вида `{"time": Unixtime, "old_value": float, "value": float}`, где отображена история ручных изменений значения. |

&nbsp;

{{< alert style="info" >}} Тип WorkStateItem может измениться.{{< /alert >}}

### Тип GPSPoint

| *Имя*      | *Тип*         | *Описание*                                |
| ---------- | ------------- | ----------------------------------------- |
| time       | Unixtime      | Время записи GPS-точки                    |
| provider   | int           | Если GPS, то 0; Если GSM (LBS), то 1      |
| x          | float \| null | Значение градусов по долготе (longtitude) |
| y          | float         | Значение градусов по широте (latitude)    |
| speed      | float \| null | Скорость в км/ч                           |
| single     | bool          | Если точка не одиночная, то False.        |
| satellites | int \| null   | Количество спутников                      |

### Тип AutoscanSettings

| *Имя*  | *Тип*       | *Описание*                                                   |
| ------ | ----------- | ------------------------------------------------------------ |
| reg    | str \| null | Номер устройства в старой системе Автоскан                   |
| number | str         | Гос.номер устройства                                         |
| params | dict        | `{... "Model": str, ...}` Словарь с параметрами, в `Model ` лежит Марка ТС |

###

### Пример

```python
import requests

result = requests.post(
    'https://plus.auto-scan.ru/api/devices',
    auth=('demo', 'demo'),
    headers={'X-ZONT-Client': 'your@email', },
    json={"device_ids": [10778],}
).json()

device = result["devices"][0]

print(device)
# {
#	  ...
#     "id": 10778,
#     "online": True,
#     "serial": "demo-a200-3",
#     "firmware_version": [321, 221],
#     "timezone": 3,
#     "work_state": {
#         "mileage": {
#             "user_counted": {"value": 3855.4133551030004, "time": 1611819000},
#             "server_counted": {"value": 3356.31189432, "time": 1611819000},
#             "edit_history": [{"time": 1611045777, "old_value": 0.0, "value": 1000.0}],
#         },
#         "moto_hours": {
#             "user_counted": {"value": 201.0, "time": 1611819000},
#             "server_counted": {"value": 201.0, "time": 1611819000},
#             "edit_history": [
#                 {"time": 1611045800, "old_value": 0.0, "value": 100.0},
#                 {"time": 1611046518, "old_value": 100.0, "value": 101.0},
#             ],
#         },
#         "day_in_operation": {
#             "user_counted": {"value": 387.5998148136, "time": 1611897111},
#             "server_counted": {"value": 387.5998148136, "time": 1611897111},
#             "edit_history": [],
#         },
#     },
#     "sim_number": "+7(831)2207676",
#     "imei": "123456789012345",
#     "last_gps": [
#         {
#             "time": 1611903524,
#             "provider": 0,
#             "x": 46.10445,
#             "y": 51.58298333333333,
#             "speed": 7.0,
#             "single": False,
#             "satellites": None,
#         },
#         {
#             "time": 1611903521,
#             "provider": 0,
#             "x": 46.10431666666667,
#             "y": 51.58291666666667,
#             "speed": 13.0,
#             "single": False,
#             "satellites": None,
#         },
#         {
#             "time": 1611903518,
#             "provider": 0,
#             "x": 46.1042,
#             "y": 51.58283333333333,
#             "speed": 16.0,
#             "single": False,
#             "satellites": None,
#         },
#         {
#             "time": 1611903517,
#             "provider": 0,
#             "x": 46.104166666666664,
#             "y": 51.5828,
#             "speed": 13.0,
#             "single": False,
#             "satellites": None,
#         },
#         {
#             "time": 1611903515,
#             "provider": 0,
#             "x": 46.10415,
#             "y": 51.58273333333333,
#             "speed": 11.0,
#             "single": False,
#             "satellites": None,
#         },
#     ],
#     "autoscan_settings": {
#								...
#                              "reg": 2000000001,
#                              "number": "А123БВ",
#                              "params": {
#									...
#                                  "Model": "Автоскан А100",
#                              },
#                          }
#
```

