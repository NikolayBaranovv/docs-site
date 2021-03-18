---
title: "Сырые данные"
date: 2021-03-18T14:06:41+03:00
draft: false
typora-root-url: ../../static
---

# Метод load_data - Запрос сырых данных

`POST https://plus.auto-scan.ru/api/load_data`

Используется для того, чтобы получить все сырые данные за указанный период.

{{< alert style="warning" >}} Запрашивайте промежуток времени не более недели.

 Если промежуток увеличить, то это приведёт к большой нагрузке на сервер и выходной json будет порядка сотни МБ.{{< /alert >}}

## Параметры

| *Имя*      | *Тип* | *Описание*                                                   |
| ---------- | ----- | ------------------------------------------------------------ |
| requests\* | array | Массив с запросами вида [{Request}](/api/geo/#тип-request), см. [пример](/api/geo/#пример-1). |

\* - обозначены обязательные параметры.

### Тип Request

Для каждого устройства можно составить словарь такого вида:

| *Имя*      | *Тип*    | *Описание*                                                   |
| ---------- | -------- | ------------------------------------------------------------ |
| device_id  | int      | ID-устройства в системе                                      |
| data_types | array    | ["gps", "events", "autoscan", "autoscan_foreign", "autoscan_misc"] - запросим все типы сырых данных |
| mintime    | unixtime | Время в секундах от начала [эпохи Unix](https://ru.wikipedia.org/wiki/Unix-%D0%B2%D1%80%D0%B5%D0%BC%D1%8F), значение начала периода |
| maxtime    | unixtime | Время в секундах от начала [эпохи Unix](https://ru.wikipedia.org/wiki/Unix-%D0%B2%D1%80%D0%B5%D0%BC%D1%8F), значение конца периода |

## Результат

В случае успеха возвращает JSON вида:

```python
{
 "ok": True,
 "responses":[{
  "ok": True,
  "device_id": int,
  "gps": [
          [time, x, y, speed, provider, single, accuracy, satellites, hdop, altitude, avg_va],
          ...
      ],
  "events": [
          [event_name-time, time, event_name, x, y, duration, data, important],
          ...
      ],
  "autoscan": {
		  acc: [[Unixtime, value], ...],
		  brake: [[Unixtime, value], ...],
		  run: [[Unixtime, value], ...],
		  ignition: [[Unixtime, value], ...],
		  spent: [[Unixtime, value], ...],
		  turn: [[Unixtime, value], ...],
		  angle: [[Unixtime, value], ...],
      
		  fuel: [[[Unixtime, value]], ...],
		  term: [[[Unixtime, value]], ...],
		  counter: [[[Unixtime, value]], ...],
  	  },
  "autoscan_misc": [
          [[time, [type, param, data]], ...],
          ...
      ],
  "autoscan_foreign": [
          [[time, [type, p1, p2, data]], ...],
          ...
      ],
},]
}
```

### Тип GPS array

| *Имя*      | *Тип*         | *Описание*                                |
| ---------- | ------------- | ----------------------------------------- |
| time       | unixtime      | Время записи этой координатной точки      |
| x          | float         | Значение градусов по долготе (longtitude) |
| y          | float         | Значение градусов по широте (latitude)    |
| speed      | float \| null | Скорость в км/ч                           |
| provider   | int           | Если GPS, то 0; Если GSM (LBS), то 1      |
| single     | bool          | Если точка не одиночная, то False.        |
| accuracy   | int \| null   | Точность в метрах                         |
| satellites | int \| null   | Количество спутников                      |
| hdop       | int \| null   | Горизонтальная точность (HDOP)            |
| altitude   | int \| null   | Высота над уровнем моря (м)               |
| avg_va     | float \| null | Усреднённое вертикальное ускорение        |

### Тип Event

| *Имя*           | *Тип*        | *Описание*                                                   |
| --------------- | ------------ | ------------------------------------------------------------ |
| event_name-time | string       | Строка с названием события и временем                        |
| time            | Unixtime     | Время события                                                |
| event_name      | string       | Название события ("connected", "disconnected", "reconnected", "GPSLost", "GPSFound", "GSMLost", "GSMFound", "Unknown" и т.д.) |
| x               | float        | Значение градусов по долготе (longtitude)                    |
| y               | float        | Значение градусов по широте (latitude)                       |
| duration        | int \| null  | Продолжительность события в секундах (Парковка 3600 секунд)  |
| data            | dict \| null | Дополнительная дата, вида: {reason: string} \| {label: string} \| {s: string}… |
| important       | boolean      | Важное событие?                                              |

### Тип Autoscan

Это словарь с данными от устройства.

| *Имя*    | *Тип* | Тип элемента                                                 | *Описание*                                                 |
| -------- | ----- | ------------------------------------------------------------ | ---------------------------------------------------------- |
| acc      | Array | [Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null> | Ускорение, 1g = 100                                        |
| brake    | Array | [Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null> | Торможение, 1g = 100                                       |
| run      | Array | [Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null> | Пробег, м                                                  |
| ignition | Array | [Delta-time-Array](api/raw_data/#формат-delta-time-array)<boolean \| null> | Зажигание                                                  |
| spent    | Array | [Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null> | Расход                                                     |
| turn     | Array | [Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null> | Поворот                                                    |
| angle    | Array | [Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null> | Угол поворота, в градусах                                  |
| fuel     | Array | [[Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null>, [Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null>, …] | Топливо в вольтах /100, таких массивов может быть до 8     |
| term     | Array | [[Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null>, [Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null>, …] | Температура в вольтах /100, таких массивов может быть до 5 |
| counter  | Array | [[Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null>, [Delta-time-Array](api/raw_data/#формат-delta-time-array)<number \| null>, …] | Счётчики, таких массивов может быть до 8                   |

### Формат Delta-time-Array

При передаче сохранённых данных как правило нужно закодировать набор значений, каждое из которых привязано к моменту времени. Например это могут быть GPS-координаты, значения температуры, события. Если при передаче таких данных в формате JSON каждую метку времени передавать в виде полного значения времени, то эти временные метки будут занимать значительный объём данных, иногда превышающий объём самих значений. Для экономии трафика мы используем простой способ дельта-кодирования временных меток, который в дальнейшем называем Delta-time Array.

Delta-time Array — это массив массивов следующей структуры:

```
[ [time1, ...], [time2, ...], ... [timeN, ...] ]
```

Первым элементом каждого массива является метка времени. Остальные элементы зависят от характера кодируемых данных.

Метки времени являются целыми числами подчинаются следующему правилу:

- Если метка времени — положительное число, то она обозначает время в формате unix time, то есть в целых секундах с 1970-01-01 00:00:00 (UTC). Например, `1495098587` обозначает 18.05.2017 12:09:47 (UTC+03) (московское время).
- Если метка времени — отрицательное число, то её абсолютное значение означает разницу в секундах от предыдущей метки. Например, `-60` означает предыдущую метку времени плюс одна минута. Отрицательные значения меток могут идти друг за другом, и тогда каждая кодирует время, прошедшее от предыдущей.

Первая метка времени в массиве — всегда положительная. Последующие могут быть как положительными, так и отрицательными.

### Тип Autoscan Misc

Разные данные, включая CAN

| *Имя* | *Тип*  | *Описание*                            |
| ----- | ------ | ------------------------------------- |
| type  | int    | Строка с названием события и временем |
| param | int    | Параметры                             |
| data  | string | Битовая строка с данным               |

### Тип Autoscan Foreign

Иностранные 

| *Имя* | *Тип*  | *Описание*              |
| ----- | ------ | ----------------------- |
| type  | int    | Тип разных данных       |
| p1    | int    | Параметры 1             |
| p2    | int    | Параметры 2             |
| data  | string | Битовая строка с данным |

### Пример

```python
import requests

result = requests.post(
    'https://plus.auto-scan.ru/api/load_data',
    auth=('demo', 'demo'),
    headers={'X-ZONT-Client': 'your@email', },
    json={
        "requests":[
            {
                "device_id": 10779,
        		"data_types": ["gps", "events", "autoscan", "autoscan_foreign", "autoscan_misc"],
        		"mintime": 1616068800,
        		"maxtime": 1616069159
            },
        ]
         }
).json()

print(result["responses"][0]) 
{
    "device_id":10779,
    "ok": true,
    "events":[],
    "gps":[
        [1616068803,128.089917,51.3878,28,0,false,null,null,null,null,null],
        [1616068809,128.0898,51.388233,30,0,false,null,null,null,null,null],
        [1616068820,128.0896,51.389067,31,0,false,null,null,null,null,null],
        [1616068825,128.089533,51.38945,32,0,false,null,null,null,null,null],
        [1616068835,128.089417,51.390283,34,0,false,null,null,null,null,null], ...
    ],
    "autoscan":{
        "spent":[
            [1616068800,0],[-300,0]
        ],
        "turn":[
            [1616068800,0],[-300,0]
        ],
        "run":[
            [1616068800,3161],
            [-60,4888],
            [-60,6009],
            [-60,5215],
            [-60,5998],
            [-60,5800]
        ],
        "acc":[
            [1616068800,3],
            [-60,2],
            [-120,4],
            [-120,3]
        ],
        "brake":[
            [1616068800,1],
            [-120,3],
            [-60,2],
            [-60,3],
            [-60,2]
        ],
        "ignition":[
            [1616068800,true],
            [-300,true]
        ],
        "angle":[
            [1616068800,51],
            [-60,59],
            [-60,60],
            [-60,65],
            [-60,51],
            [-60,57]
        ],
        "term":[
            [],
            [],
            [],
            [],
            []
        ],
        "fuel":[
            [
                [1616068800,119.49],
                [-60,119.33],
                [-60,119.2],
                [-60,119.08],
                [-60,119.02],
                [-60,118.91]
            ],
            [],[],[],[],[],[],[]
        ],
        "counter":[
            [],[],[],[],[],[],[],[]
        ]
    },
    "autoscan_misc":[
        [
            1616068803,
            [4,0,"BwAR0AA="]
        ],
        [-6,[4,0,"BwAR0QA="]],
        [-11,[4,0,"BwAS0gA="]],
        [-5,[4,0,"BwAR0gA="]],
        [-10,[4,0,"BwAR0AA="]],
    ],
    "autoscan_foreign":[]
}
```

