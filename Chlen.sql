USE Miromanov_Academiki;

-- Задание 1
CREATE TABLE Управление_Мирoманов
(
    ID    INT          PRIMARY KEY IDENTITY(1,1),
    Вид   VARCHAR(50)  NOT NULL DEFAULT 'Президентская республика'
);

-- Задание 2
CREATE TABLE Страны_Миромaнов
(
    ID             INT           PRIMARY KEY IDENTITY(1,1),
    Страна         VARCHAR(50)   NOT NULL,
    Столица        VARCHAR(50)   NOT NULL,
    Часть_света    VARCHAR(20)   NOT NULL,
    Население      DECIMAL(10,1) NOT NULL CHECK (Население > 0),
    Площадь        DECIMAL(10,1) NULL     CHECK (Площадь >= 0),
    Тип_управления INT           NOT NULL
);

-- Задание 3
CREATE TABLE Цветы_Мирoманов
(
    ID        INT         PRIMARY KEY IDENTITY(1,1),
    Название  VARCHAR(50) NOT NULL UNIQUE,
    Класс     VARCHAR(30) DEFAULT 'Двудольные',
    Семейство VARCHAR(50) NULL
);

-- Задание 4
CREATE TABLE Животные_Мирoманов
(
    ID        INT         PRIMARY KEY IDENTITY(1,1),
    Название  VARCHAR(50) NOT NULL UNIQUE,
    Отряд     VARCHAR(50) DEFAULT 'Хищные',
    Класс     VARCHAR(30) NULL
);
