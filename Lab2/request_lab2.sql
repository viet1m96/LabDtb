--ex1
SELECT "Н_ЛЮДИ"."ИД", "Н_СЕССИЯ"."УЧГОД" FROM
    "Н_ЛЮДИ" LEFT JOIN "Н_СЕССИЯ"
                       ON "Н_ЛЮДИ"."ИД" = "Н_СЕССИЯ"."ЧЛВК_ИД"
WHERE "Н_ЛЮДИ"."ОТЧЕСТВО" = 'Георгиевич' AND "Н_СЕССИЯ"."ИД" < 1975 AND "Н_СЕССИЯ"."ИД" < 32199;
--end


--ex2
SELECT "Н_ЛЮДИ"."ИМЯ", "Н_ОБУЧЕНИЯ"."НЗК", "Н_УЧЕНИКИ"."ИД" FROM
    "Н_ЛЮДИ"
        RIGHT JOIN "Н_ОБУЧЕНИЯ" ON "Н_ЛЮДИ"."ИД" = "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД"
        RIGHT JOIN "Н_УЧЕНИКИ" ON "Н_ЛЮДИ"."ИД" = "Н_УЧЕНИКИ"."ЧЛВК_ИД"
WHERE "Н_ЛЮДИ"."ФАМИЛИЯ" > 'Соколов' AND "Н_ОБУЧЕНИЯ"."НЗК" > '933232';
--end


--ex3
WITH BirthDayTable AS (
    SELECT "Н_ЛЮДИ"."ДАТА_РОЖДЕНИЯ" AS "ДЕНЬ"
    FROM
        "Н_ЛЮДИ" GROUP BY "Н_ЛЮДИ"."ДАТА_РОЖДЕНИЯ"
)
SELECT count("ДЕНЬ") AS "ЧИСЛО_РОЖДЕНИЯ_БЕЗ_ПОВТОРЕНИЙ"
FROM BirthDayTable;
--end

--ex4
WITH
    RemoteLearningForm AS (
    SELECT
        "Н_ЛЮДИ"."ИД" AS PersonID,
        "Н_ЛЮДИ"."ИМЯ" AS PersonName
    FROM
        "Н_ЛЮДИ"
            JOIN "Н_СЕССИЯ" ON "Н_СЕССИЯ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД"
            JOIN "Н_СОДЕРЖАНИЯ_ЭЛЕМЕНТОВ_СТРОК" ON "Н_СЕССИЯ"."СЭС_ИД" = "Н_СОДЕРЖАНИЯ_ЭЛЕМЕНТОВ_СТРОК"."ИД"
            JOIN "Н_ЭЛЕМЕНТЫ_СТРОК" ON "Н_СОДЕРЖАНИЯ_ЭЛЕМЕНТОВ_СТРОК"."ЭСТ_ИД" = "Н_ЭЛЕМЕНТЫ_СТРОК"."ИД"
            JOIN "Н_СТРОКИ_ПЛАНОВ" ON "Н_ЭЛЕМЕНТЫ_СТРОК"."СПЛ_ИД" = "Н_СТРОКИ_ПЛАНОВ"."ИД"
            JOIN "Н_ПЛАНЫ" ON "Н_СТРОКИ_ПЛАНОВ"."ПЛАН_ИД" = "Н_ПЛАНЫ"."ИД"
            JOIN "Н_ФОРМЫ_ОБУЧЕНИЯ" ON "Н_ПЛАНЫ"."ФО_ИД" = "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИД"
    WHERE
        "Н_ФОРМЫ_ОБУЧЕНИЯ"."НАИМЕНОВАНИЕ" = 'Заочная'
),
     NonStudents AS (
         SELECT
             PersonID,
             PersonName
         FROM
             RemoteLearningForm
         WHERE NOT EXISTS (
             SELECT 1
             FROM "Н_УЧЕНИКИ"
             WHERE "Н_УЧЕНИКИ"."ЧЛВК_ИД" = RemoteLearningForm.PersonID
         )
     )
SELECT
    PersonName,
    COUNT(*) AS Number_Of_People
FROM
    NonStudents
GROUP BY
    PersonName
HAVING
    COUNT(*) > 50;
--end

--ex5
WITH
    CalculateAge AS (
        SELECT
            "Н_УЧЕНИКИ"."ГРУППА",
            date_part('year', NOW()) - date_part('year', "Н_ЛЮДИ"."ДАТА_РОЖДЕНИЯ") AS Age
        FROM
            "Н_УЧЕНИКИ"
                JOIN "Н_ЛЮДИ" ON "Н_ЛЮДИ"."ИД" = "Н_УЧЕНИКИ"."ЧЛВК_ИД"
    ),
    AverageAgeGroup1101 AS (
        SELECT avg(Age) AS AverageAge
        FROM CalculateAge
        WHERE "ГРУППА" = '1101'
    )
SELECT
    "ГРУППА",
    avg(Age) AS СРЕДНИЙ_ВОЗРАСТ
FROM
    CalculateAge
GROUP BY
    "ГРУППА"
HAVING
    avg(Age) < (
        SELECT
            AverageAge
        FROM
            AverageAgeGroup1101
    );
--end

--ex6
WITH DischargedStudents AS (
    SELECT ПОСЛЕ_УЧЕНИКИ."ИД"
    FROM "Н_УЧЕНИКИ" AS ПОСЛЕ_УЧЕНИКИ
    WHERE ПОСЛЕ_УЧЕНИКИ."ПРИЗНАК" = 'отчисл'
      AND ПОСЛЕ_УЧЕНИКИ."СОСТОЯНИЕ" = 'утвержден'
      AND DATE(ПОСЛЕ_УЧЕНИКИ."КОНЕЦ") > '2012-09-01'
)
SELECT ПРЕ_УЧЕНИКИ."ГРУППА",
       ПРЕ_УЧЕНИКИ."ИД",
       "Н_ЛЮДИ"."ФАМИЛИЯ",
       "Н_ЛЮДИ"."ИМЯ",
       "Н_ЛЮДИ"."ОТЧЕСТВО",
       ПРЕ_УЧЕНИКИ."П_ПРКОК_ИД"
FROM "Н_УЧЕНИКИ" AS ПРЕ_УЧЕНИКИ
         JOIN "Н_ЛЮДИ" ON "Н_ЛЮДИ"."ИД" = ПРЕ_УЧЕНИКИ."ЧЛВК_ИД"
         JOIN "Н_ПЛАНЫ" ON ПРЕ_УЧЕНИКИ."ПЛАН_ИД" = "Н_ПЛАНЫ"."ИД"
         JOIN "Н_ФОРМЫ_ОБУЧЕНИЯ" ON "Н_ПЛАНЫ"."ФО_ИД" = "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИД" AND
                                    ("Н_ФОРМЫ_ОБУЧЕНИЯ"."НАИМЕНОВАНИЕ" = 'Заочная' OR "Н_ФОРМЫ_ОБУЧЕНИЯ"."НАИМЕНОВАНИЕ" = 'Очная')
WHERE ПРЕ_УЧЕНИКИ."ИД" IN (SELECT "ИД" FROM DischargedStudents);
--end

--ex7
WITH DuplicateLastNames AS (
    SELECT ВНУТР_ЛЮДИ."ФАМИЛИЯ"
    FROM "Н_ЛЮДИ" AS ВНУТР_ЛЮДИ
             JOIN "Н_УЧЕНИКИ" ON "Н_УЧЕНИКИ"."ЧЛВК_ИД" = ВНУТР_ЛЮДИ."ИД"
    GROUP BY ВНУТР_ЛЮДИ."ФАМИЛИЯ"
    HAVING COUNT(*) > 1
)
SELECT "Н_УЧЕНИКИ"."ИД",
       ВНЕ_ЛЮДИ.*
FROM "Н_ЛЮДИ" AS ВНЕ_ЛЮДИ
         JOIN "Н_УЧЕНИКИ" ON "Н_УЧЕНИКИ"."ЧЛВК_ИД" = ВНЕ_ЛЮДИ."ИД"
WHERE ВНЕ_ЛЮДИ."ФАМИЛИЯ" IN (SELECT "ФАМИЛИЯ" FROM DuplicateLastNames)
ORDER BY "ФАМИЛИЯ";
--end


