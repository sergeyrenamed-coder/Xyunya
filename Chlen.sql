USE Miromanov_Academiki;
GO

/* 1) Удаляем старые FK, если они есть */
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql +=
    N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name) +
    N' DROP CONSTRAINT ' + QUOTENAME(fk.name) + N';' + CHAR(13)
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id
WHERE fk.name IN
(
    N'FK_Кафедра_Заведующий',
    N'FK_Кафедра_Факультеты',
    N'FK_Специальность_Кафедра',
    N'FK_Студент_Специальность',
    N'FK_Сотрудник_Кафедра',
    N'FK_Сотрудник_Руководитель',
    N'FK_Преподаватель_Сотрудник',
    N'FK_Экзамен_Студент',
    N'FK_Экзамен_Сотрудник',
    N'FK_Экзамен_Дисциплина'
);

IF @sql <> N'' EXEC sp_executesql @sql;
GO

/* 2) Удаляем таблицы */
IF OBJECT_ID(N'dbo.Экзамен', N'U') IS NOT NULL DROP TABLE dbo.Экзамен;
IF OBJECT_ID(N'dbo.Преподаватель', N'U') IS NOT NULL DROP TABLE dbo.Преподаватель;
IF OBJECT_ID(N'dbo.Студент', N'U') IS NOT NULL DROP TABLE dbo.Студент;
IF OBJECT_ID(N'dbo.Сотрудник', N'U') IS NOT NULL DROP TABLE dbo.Сотрудник;
IF OBJECT_ID(N'dbo.Дисциплина', N'U') IS NOT NULL DROP TABLE dbo.Дисциплина;
IF OBJECT_ID(N'dbo.Специальность', N'U') IS NOT NULL DROP TABLE dbo.Специальность;
IF OBJECT_ID(N'dbo.Кафедра', N'U') IS NOT NULL DROP TABLE dbo.Кафедра;
IF OBJECT_ID(N'dbo.Факультеты', N'U') IS NOT NULL DROP TABLE dbo.Факультеты;
GO

/* 3) Создание таблиц */
CREATE TABLE dbo.Факультеты
(
    Аббревиатура NVARCHAR(10) NOT NULL PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE dbo.Кафедра
(
    Шифр NVARCHAR(10) NOT NULL PRIMARY KEY,
    Факультет NVARCHAR(10) NOT NULL,
    Название NVARCHAR(100) NOT NULL,
    Заведующий INT NULL
);
GO

CREATE TABLE dbo.Специальность
(
    Номер INT NOT NULL PRIMARY KEY,
    Шифр NVARCHAR(10) NOT NULL,
    Направление NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE dbo.Студент
(
    Рег_номер INT NOT NULL PRIMARY KEY,
    Фамилия NVARCHAR(50) NOT NULL,
    Номер INT NOT NULL
);
GO

CREATE TABLE dbo.Сотрудник
(
    Таб_номер INT NOT NULL PRIMARY KEY,
    Фамилия NVARCHAR(50) NOT NULL,
    Должность NVARCHAR(50) NOT NULL,
    Зарплата DECIMAL(10,2) NOT NULL,
    Шифр NVARCHAR(10) NOT NULL,
    Шеф INT NULL
);
GO

CREATE TABLE dbo.Преподаватель
(
    Таб_номер INT NOT NULL PRIMARY KEY,
    Степень NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.Дисциплина
(
    Код INT NOT NULL PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE dbo.Экзамен
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Рег_номер INT NOT NULL,
    Таб_номер INT NOT NULL,
    Код INT NOT NULL,
    Оценка INT NOT NULL,
    Дата DATE NOT NULL,
    Аудитория NVARCHAR(20) NOT NULL
);
GO

/* 4) Внешние ключи. Кафедра -> Сотрудник не связываем, чтобы не было цикла */
ALTER TABLE dbo.Кафедра
ADD CONSTRAINT FK_Кафедра_Факультеты
FOREIGN KEY (Факультет) REFERENCES dbo.Факультеты(Аббревиатура);
GO

ALTER TABLE dbo.Специальность
ADD CONSTRAINT FK_Специальность_Кафедра
FOREIGN KEY (Шифр) REFERENCES dbo.Кафедра(Шифр);
GO

ALTER TABLE dbo.Студент
ADD CONSTRAINT FK_Студент_Специальность
FOREIGN KEY (Номер) REFERENCES dbo.Специальность(Номер);
GO

ALTER TABLE dbo.Сотрудник
ADD CONSTRAINT FK_Сотрудник_Кафедра
FOREIGN KEY (Шифр) REFERENCES dbo.Кафедра(Шифр);
GO

ALTER TABLE dbo.Сотрудник
ADD CONSTRAINT FK_Сотрудник_Руководитель
FOREIGN KEY (Шеф) REFERENCES dbo.Сотрудник(Таб_номер);
GO

ALTER TABLE dbo.Преподаватель
ADD CONSTRAINT FK_Преподаватель_Сотрудник
FOREIGN KEY (Таб_номер) REFERENCES dbo.Сотрудник(Таб_номер);
GO

ALTER TABLE dbo.Экзамен
ADD CONSTRAINT FK_Экзамен_Студент
FOREIGN KEY (Рег_номер) REFERENCES dbo.Студент(Рег_номер);
GO

ALTER TABLE dbo.Экзамен
ADD CONSTRAINT FK_Экзамен_Сотрудник
FOREIGN KEY (Таб_номер) REFERENCES dbo.Сотрудник(Таб_номер);
GO

ALTER TABLE dbo.Экзамен
ADD CONSTRAINT FK_Экзамен_Дисциплина
FOREIGN KEY (Код) REFERENCES dbo.Дисциплина(Код);
GO

/* 5) Данные */
INSERT INTO dbo.Факультеты (Аббревиатура, Название)
VALUES
(N'ит', N'Информационные технологии'),
(N'эко', N'Экономика и управление');
GO

INSERT INTO dbo.Кафедра (Шифр, Факультет, Название, Заведующий)
VALUES
(N'ИТ-01', N'ит', N'Кафедра информационных систем', 101),
(N'ИТ-02', N'ит', N'Кафедра программной инженерии', 102),
(N'ЭК-01', N'эко', N'Кафедра экономики', 105);
GO

INSERT INTO dbo.Специальность (Номер, Шифр, Направление)
VALUES
(1, N'ИТ-01', N'Прикладная информатика'),
(2, N'ИТ-02', N'Информатика и вычислительная техника'),
(3, N'ЭК-01', N'Экономика');
GO

INSERT INTO dbo.Студент (Рег_номер, Фамилия, Номер)
VALUES
(1, N'Смирнов', 1),
(2, N'Кузнецов', 1),
(3, N'Иванова', 2),
(4, N'Петрова', 3),
(5, N'Орлов', 2);
GO

INSERT INTO dbo.Сотрудник (Таб_номер, Фамилия, Должность, Зарплата, Шифр, Шеф)
VALUES
(101, N'Иванов', N'профессор', 45000, N'ИТ-01', NULL),
(102, N'Петров', N'инженер', 18000, N'ИТ-02', 101),
(103, N'Сидорова', N'преподаватель', 22000, N'ИТ-01', 101),
(104, N'Орлова', N'инженер', 19000, N'ИТ-02', 102),
(105, N'Климов', N'профессор', 30000, N'ЭК-01', NULL);
GO

UPDATE dbo.Кафедра
SET Заведующий = CASE Шифр
    WHEN N'ИТ-01' THEN 101
    WHEN N'ИТ-02' THEN 102
    WHEN N'ЭК-01' THEN 105
END;
GO

INSERT INTO dbo.Преподаватель (Таб_номер, Степень)
VALUES
(101, N'д.т.н.'),
(102, N'к.т.н.'),
(103, N'к.п.н.'),
(105, N'д.э.н.');
GO

INSERT INTO dbo.Дисциплина (Код, Название)
VALUES
(1, N'Базы данных'),
(2, N'Программирование'),
(3, N'Математика');
GO

INSERT INTO dbo.Экзамен (Рег_номер, Таб_номер, Код, Оценка, Дата, Аудитория)
VALUES
(1, 101, 1, 5, '2026-05-10', N'А-101'),
(2, 102, 2, 4, '2026-05-10', N'А-101'),
(3, 101, 3, 3, '2026-05-12', N'А-102'),
(1, 103, 2, 4, '2026-05-12', N'А-102'),
(1, 101, 3, 5, '2026-05-15', N'А-101'),
(2, 102, 1, 5, '2026-05-15', N'А-101'),
(3, 101, 2, 4, '2026-05-20', N'А-201'),
(2, 103, 3, 4, '2026-05-20', N'А-201'),
(5, 101, 1, 5, '2026-05-20', N'А-101'),
(5, 103, 2, 4, '2026-05-20', N'А-101');
GO
