# Demo Smart Place Languaje

## Theory of languages

> The project consists in the definition of a language called DSPL (Smart Place Scene Language) and in the implementation of a translator for said language.
>
> The translator will receive a program written in the DSPL language and generate a C ++ program that, with the help of a library (provided) called "dspl environment" will simulate the behavior of the different intelligent elements of the house

### Lenguaje structure

1. C++ Definitions
2. Zone 1
   1. Variables definition
   2. Variables asignations
   3. Sensors
   4. Actuators
3. Separation Token
4. Zone 2
   1. Behaviour

### Extensions

- The control structures may include other nested control structures.
  - The knotting of loops and even logical conditions is allowed. This is thanks to the design of the grammar
- The extension will consist of the storage of the arithmetic and logical expressions in an auxiliary control structure
  - A linked list has been used to store all the variables that are carried out within a scenario. This means that there is a table for each scenario.

### Data Structures

#### External Libraries

| Name       | Url                                      | Modifications   |
| ---------- | ---------------------------------------- | --------------- |
| HashMap    | https://github.com/chennqqi/map          | *Self Modified* |
| LinkedList | https://github.com/ivanseidel/LinkedList | *Raw*           |

#### HashMap

Making use of an open source C ++ library uploaded to the GitHub network, and with small modifications to be able to store custom values, it could be used for a very fast and effective storage of the data

> License: This library is free software; you can redistribute it and/or modify it under the terms of the MIT license

#### LinkedList

Making use of another open source library, a Linkdlist folder is added, where a single header file will have the necessary code

> License: The MIT License (MIT)
>
> Copyright (c) 2015 Ivan Seidel
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.

### Usage

```
// Clean all compilation files of the program
make clean

// It will show the help output provided by bison
make logger

// Only the program will compile
make

// Compile and run the program using ./translator example1.dsp
make run
```

### Output example

```
Nameless:gsiestos Guille$ make run
make
make[1]: `traductor' is up to date.
./traductor ejemplo1.dsp


******************************************************

] { ESCENA }----------------------------------------------------------------------------------------
0 | Comando: 0   | Parametro 1: indoorTemp   | Parametro 2: 18.2
1 | Comando: 1   | Parametro 1: Heat         | Parametro 2: ON
2 | Comando: 1   | Parametro 1: Whatsapp     | Parametro 2: "Calefacción encendida"
3 | Comando: 3   | Parametro 1: 3            | Parametro 2:
4 | Comando: 1   | Parametro 1: Whatsapp     | Parametro 2: OFF
5 | Comando: 0   | Parametro 1: indoorTemp   | Parametro 2: 28.2
6 | Comando: 1   | Parametro 1: Heat         | Parametro 2: OFF
7 | Comando: 1   | Parametro 1: Whatsapp     | Parametro 2: "Calefacción apagada"
8 | Comando: 1   | Parametro 1: Whatsapp     | Parametro 2: OFF
]----------------------------------------------------------------------------------------

] { ESCENA }----------------------------------------------------------------------------------------
0 | Comando: 0   | Parametro 1: indoorTemp   | Parametro 2: 18.2
1 | Comando: 1   | Parametro 1: Heat         | Parametro 2: ON
2 | Comando: 1   | Parametro 1: Whatsapp     | Parametro 2: "Calefacción encendida"
3 | Comando: 3   | Parametro 1: 3            | Parametro 2:
4 | Comando: 1   | Parametro 1: Whatsapp     | Parametro 2: OFF
5 | Comando: 0   | Parametro 1: indoorTemp   | Parametro 2: 28.2
6 | Comando: 1   | Parametro 1: Heat         | Parametro 2: OFF
7 | Comando: 1   | Parametro 1: Whatsapp     | Parametro 2: "Calefacción apagada"
8 | Comando: 1   | Parametro 1: Whatsapp     | Parametro 2: OFF
9 | Comando: 3   | Parametro 1: 1            | Parametro 2:
10| Comando: 0   | Parametro 1: S            | Parametro 2: 100
11| Comando: 1   | Parametro 1: Whatsapp     | Parametro 2: "Alarma. Alta probabilidad de incendio"
12| Comando: 4   | Parametro 1: 2            | Parametro 2:
13| Comando: 1   | Parametro 1: A            | Parametro 2: ON
14| Comando: 3   | Parametro 1: 1            | Parametro 2:
15| Comando: 1   | Parametro 1: Whatsapp     | Parametro 2: OFF
]----------------------------------------------------------------------------------------
******************************************************


------------- HashMap ------------------------------------------------------------------
Key:                f  | Type:   0 | Value:           20 | Posicion: <  0,  0> | Alias:
Key:                A  | Type:  20 | Value:              | Posicion: <  0,  0> | Alias:
Key:           Winter  | Type:  30 | Value:              | Posicion: <  0,  0> | Alias:
Key:                S  | Type:  12 | Value:              | Posicion: <250,250> | Alias: "SH"
Key:                c  | Type:   0 | Value:            4 | Posicion: <  0,  0> | Alias:
Key:       indoorTemp  | Type:  10 | Value:              | Posicion: < 25, 25> | Alias: "T1"
Key:       summerTemp  | Type:   1 | Value:    24.500000 | Posicion: <  0,  0> | Alias:
Key:       winterTemp  | Type:   1 | Value:    20.825001 | Posicion: <  0,  0> | Alias:
Key:              msg  | Type:   3 | Value: "Alarma. Alta probabilidad de incendio" | Posicion: <  0,  0> | Alias:
Key:         p_Sensor  | Type:   2 | Value:    < 25, 25> | Posicion: <  0,  0> | Alias:
Key:             Fire  | Type:  30 | Value:              | Posicion: <  0,  0> | Alias:
Key:         Whatsapp  | Type:  22 | Value:              | Posicion: <150,550> | Alias: "CA"
Key:             Heat  | Type:  21 | Value:              | Posicion: <150,550> | Alias: "CA"
----------------------------------------------------------------------------------------
```

### Conclusions

With this project we have learned how text recognizers work, how they detect errors, and how a compiler behaves. In addition, the organization and cleanliness of the code is essential in this type of project based on recursion. It helps us to have a more abstract and at the same time profound vision of the internal functioning of any program.
It has been a long but didactic project to reinforce what was studied in the theoretical classes of the subject.

### License

MIT License