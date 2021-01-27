---
title: "Геопозиция"
date: 2021-01-27T09:34:01+03:00
draft: false
weight: 4
typora-root-url: ../../static
---

Наш сервис получает данные с прибором и строит маршруты на карте по координатам.

## Метод reverse_geocode - Запрос адреса по координатам.

`POST https://plus.auto-scan.ru/api/reverse_geocode`

Используется для того, чтобы получить адрес по координатам (геокодинг). Используется база адресов [OpenStreetMap](https://www.openstreetmap.org/about).

### Параметры

| *Имя*                                   | *Тип* | *Описание*                                                   |
| --------------------------------------- | ----- | ------------------------------------------------------------ |
| points\*: [{x: …, y: …}, {x: …, y: …},] | array | Массив из N-словарей, где *x*: float это Долгота - longtitude, *y*: float это Широта - latitude |

\* - обозначены обязательные параметры.

### Результат

В случае успеха возвращает JSON вида:

```python
{
  "ok": True,
  "addresses": [str, str, ..., str],
  "errors": [null, null, ..., null],
}
```

Если какую-то точку не смог декодировать, на этом месте в массиве addresses будет null, а в errors str, то есть:

```python
{
  "ok": True,
  "addresses": [str, null, ..., str],
  "errors": [null, str, ..., null],
}
```

```python
import requests

result = requests.post(
    'https://plus.auto-scan.ru/api/reverse_geocode',
    auth=('login', 'password'),
    headers={'X-ZONT-Client': 'your@email', },
    json={"points": [{'x': 43.865720, 'y': 56.165796}, {'x': 44.002595, 'y': 56.328376}],}
).json()

address = result["address"]
errors = result["errors"]

print(address) //['Заводская, с2', 'Кремль, Нижегородский кремль']
print(errors) //[None, None]
```



## Метод load_data - Запрос маршрутов устройства

`POST https://plus.auto-scan.ru/api/load_data`

Используется для того, чтобы получить все GPS-точки в указанной дате.

{{< alert style="warning" >}} Запрашивайте промежуток времени не более недели.

 Если промежуток увеличить, то это приведёт к большой нагрузке на сервер и выходной json будет порядка сотни МБ.{{< /alert >}}

### Параметры

| *Имя*      | *Тип*    | *Описание*                                                   |
| ---------- | -------- | ------------------------------------------------------------ |
| requests\* | array    | Массив с запросами вида {device_id: …, data_types: […], mintime: …, maxtime: …} |
| device_id  | int      | ID-устройства в системе                                      |
| data_types | array    | ["gps"] - запросим GPS-точки                                 |
| mintime    | unixtime | Время в секундах от начала [эпохи Unix](https://ru.wikipedia.org/wiki/Unix-%D0%B2%D1%80%D0%B5%D0%BC%D1%8F), значение от которого запрашивается маршрут |
| maxtime    | unixtime | Время в секундах от начала [эпохи Unix](https://ru.wikipedia.org/wiki/Unix-%D0%B2%D1%80%D0%B5%D0%BC%D1%8F), значение до которого запрашивается маршрут |

\* - обозначены обязательные параметры.

### Результат

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
},]
}
```

### 

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

Наш сервис получает данные с прибором и строит маршруты на карте по координатам.

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
        		"data_types": ["gps"],
        		"mintime": 1611739095,
        		"maxtime": 1611739133
            }
        ]
         }
).json()

gps_point = result["responses"][0]["gps"]
print(gps_point) 
//[
   // [1611739095, 38.492817, 55.278583, 56, 0, False, None, None, None, None, None], 
   // [1611739103, 38.49165, 55.279567, 50, 0, False, None, None, None, None, None],
   // [1611739118, 38.489783, 55.281133, 61, 0, False, None, None, None, None, None],
   // [1611739124, 38.488817, 55.281933, 71, 0, False, None, None, None, None, None],
   // [1611739133, 38.48715, 55.2833, 82, 0, False, None, None, None, None, None]
//]
```
