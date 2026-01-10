-- =====================================================================
-- 1. SCHEMA A TABULKY
-- =====================================================================

CREATE SCHEMA auto_sales;

DROP VIEW saled_cars;

DROP TABLE IF EXISTS car_log;
DROP TABLE IF EXISTS client_bonus;
DROP TABLE IF EXISTS deal;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS manager;
DROP TABLE IF EXISTS autosalon;
DROP TABLE IF EXISTS car_model;
DROP TABLE IF EXISTS car_manufacturer;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS country;

-- COUNTRY
CREATE TABLE auto_sales.country
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- CLIENT
CREATE TABLE auto_sales.client
(
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    surname      VARCHAR(100) NOT NULL,
    phone        VARCHAR(30),
    pass_number  VARCHAR(15)  NOT NULL,
    citizenship  INT REFERENCES auto_sales.country(id)
);

-- CITY
CREATE TABLE auto_sales.city
(
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(30) NOT NULL,
    country INT NOT NULL REFERENCES auto_sales.country(id)
);

-- AUTOSALON
CREATE TABLE auto_sales.autosalon
(
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(30) NOT NULL,
    phone   VARCHAR(30) NOT NULL,
    city    INT NOT NULL REFERENCES auto_sales.city(id),
    adress  VARCHAR(50)
);

-- MANAGER
CREATE TABLE auto_sales.manager
(
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    surname      VARCHAR(100) NOT NULL,
    phone        VARCHAR(30)  NOT NULL,
    pass_number  VARCHAR(15)  NOT NULL,
    citizenship  INT REFERENCES auto_sales.country(id),
    autosalon    INT REFERENCES auto_sales.autosalon(id)
);

-- MANUFACTURER
CREATE TABLE auto_sales.car_manufacturer
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

-- CAR MODEL
CREATE TABLE auto_sales.car_model
(
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(30) NOT NULL,
    car_manufacturer INT REFERENCES auto_sales.car_manufacturer(id)
);

-- CAR
CREATE TABLE auto_sales.car
(
    vin                 VARCHAR(20) PRIMARY KEY,
    model               INT NOT NULL REFERENCES auto_sales.car_model(id),
    year_of_manufacture INT NOT NULL,
    color               VARCHAR(20) NOT NULL,
    price_czk           INT NOT NULL,
    autosalon           INT REFERENCES auto_sales.autosalon(id)
);

-- DEAL
CREATE TABLE auto_sales.deal
(
    deal_number SERIAL PRIMARY KEY,
    deal_date   DATE NOT NULL,
    manager     INT REFERENCES auto_sales.manager(id),
    client      INT REFERENCES auto_sales.client(id),
    car         VARCHAR(20) REFERENCES auto_sales.car(vin)
);

-- =====================================================================
-- 2. DATA
-- =====================================================================

-- COUNTRY
INSERT INTO auto_sales.country (name) VALUES
('Cesko'),
('USA'),
('Estonsko'),
('Italie'),
('Norsko'),
('Lotyssko'),
('Nemecko'),
('Slovensko');

-- CITY
INSERT INTO auto_sales.city (name, country) VALUES
('Praha', 1),
('Usti nad Labem', 1);

-- CLIENT
INSERT INTO auto_sales.client (name, surname, phone, pass_number, citizenship) VALUES
('Jan', 'Novotny', '+420 773 693 895', 'T6548537', 1),
('Marek', 'Kvapil', '+420 703 928 869', 'P2931786', 1),
('Leonardo', 'DiCaprio', '+1 646 712 9440', 'U92842617', 2),
('Andres', 'Kork', '+372 341 2785', 'S8305716', 3),
('Marketa', 'Pekarova-Adamova', '+420 772 737 469', 'L7491358', 1),
('Beatrice', 'Kovalli', '+39 324 6879011', 'GA3871631', 4),
('Magnus', 'Karlsen', '+47 624 37 814', 'T4381631', 5),
('Aldonis', 'Blaus', '+371 661 645544', 'T672903', 6),
('Ulrike', 'Meinhof', '+49 155 102 5045', 'T43005596', 7),
('Andres', 'Schmidt', '+49 178 491 2960', 'K84195924', 7),
('Sebastiano', 'Danielli', '+39 080504 6361', 'AP1136731', 4),
('Joanna', 'Stingray', '+1 425 484 9524', 'C4869253', 2),
('Pavel', 'Nedved', '+420 777 839 287', 'D3851037', 1),
('Lili', 'Huhn', '+49 286 294 9382', 'YR7341937', 7),
('Marek', 'Holly', '+421 456 233 836', 'K7281704', 8),
('Lucie', 'Kodrasova', '+49 286 294 9382', 'YK3811489', 8),
('Vojtech', 'Klaus', '+420 722 658 911', 'FE469310', 1),
('Petr', 'Cech', '+420 744 381 472', 'PA384721', 1),
('Vaclav', 'Klaus', '+420 711 859 573', 'UR948503', 1),
('Zuzana', 'Bergrova', '+420 704 693 485', 'TN958726', 1),
('Martin', 'Jurecka', '+420 734 958 378', 'KV745342', 1),
('Pavel', 'Kafka', '+420 706 485 823', 'BL382618', 1),
('Jim', 'Morrison', '+1 387 274 8576', 'R5738496', 2);

-- AUTOSALON
INSERT INTO auto_sales.autosalon (name, phone, city, adress) VALUES
('Auto Palace', '+420 771 356 726', 1, 'Vodickova 116/7'),
('Auto World', '+420 727 353 134', 1, 'Mezinarodni 361/11'),
('Auto Dream', '+420 778 285 629', 2, 'Nademlejnska 339/13'),
('Auto Zone', '+420 706 273 726', 2, 'Prazska 277/17');

-- MANAGER
INSERT INTO auto_sales.manager (name, surname, phone, pass_number, citizenship, autosalon) VALUES
('Petr', 'Svoboda', '+420 775 284 336', 'UT738419', 1, 1),
('Jana', 'Novackova', '+420 755 287 332', 'KP374189', 1, 1),
('Pavel', 'Dvorak', '+420 713 639 366', 'YR782942', 1, 2),
('Andrea', 'Prochazkova', '+420 733 691 225', 'JP480138', 1, 3),
('Ludvik', 'Krejci', '+420 718 991 641', 'MO791035', 1, 4),
('Jan', 'Marek', '+420 721 782 297', 'HL375910', 1, 4);

-- CAR MANUFACTURER
INSERT INTO auto_sales.car_manufacturer (name) VALUES
('Volvo'),
('Ford'),
('Huyndai'),
('Skoda'),
('BMV'),
('Audi'),
('Mercedes');

-- CAR MODEL
INSERT INTO auto_sales.car_model (name, car_manufacturer) VALUES
('S90', 1),
('Kuga', 2),
('Elantra N', 3),
('XC40', 1),
('Edge', 2),
('EX30', 1),
('Explorer', 2),
('Fabia', 4),
('Scala', 4),
('Bayon', 3),
('Z4', 5),
('Octavia', 4),
('X2', 5),
('A5 Sportback', 6),
('A6 Allroad quattro', 6),
('Superb', 4),
('S7 Sportback', 6),
('AMG GT', 7),
('X3', 5),
('Kodiaq', 4),
('Karoq', 4),
('CLA', 7),
('GLS', 7),
('Tucson', 3),
('8 Series Cabrio', 5);

-- CAR (всё как у тебя, только это уже валидный PostgreSQL)
INSERT INTO auto_sales.car (vin, model, year_of_manufacture, color, price_czk, autosalon) VALUES
('JB3AL3894LF501412', 1, 2022, 'Bila', 1559000, 1),
('MU3KI1076LP152364', 2, 2023, 'Modra', 1058700, 2),
('KT6BA8211NG112507', 3, 2022, 'Cerna', 1015190, 2),
('FO9AT2275HP251106', 2, 2024, 'Zelena', 1050100, 3),
('KU6BT2415LK244804', 4, 2023, 'Cerna', 1139900, 2),
('UV7CN5673LC518591', 5, 2023, 'Cervena', 845500, 4),
('ME6BT5035OM537911', 6, 2024, 'Seda', 853000, 2),
('BK3TR4366KP272169', 3, 2024, 'Bila', 1005000, 1),
('YS6CM5714FT831280', 7, 2022, 'Modra', 2000000, 3),
('SR2DP1595KR549179', 8, 2023, 'Cerna', 537000, 1),
('PU3VC7491AT782194', 9, 2024, 'Zelena', 600000, 4),
('UE9TK2804DR783925', 10, 2022, 'Modra', 625000, 4),
('SF1US7495ER390582', 9, 2024, 'Bila', 611500, 3),
('CR7AD7832BM495017', 11, 2023, 'Cerna', 1975000, 2),
('GU5AD6729MV413489', 12, 2024, 'Cervena', 769800, 1),
('BG4DL9381FB102849', 13, 2022, 'Modra', 1299000, 1),
('MC5DR8471KT290117', 11, 2023, 'Zelena', 1960500, 3),
('AS6GL4892MK304918', 13, 2023, 'Seda', 1320000, 2),
('RU9UP9715FR039211', 1, 2024, 'Seda', 1580000, 3),
('AJ4ST8713KO139811', 15, 2022, 'Cerna', 2269000, 2),
('DU5ME9937NK390036', 16, 2023, 'Cervena', 1302500, 1),
('OU5SC8371BK978253', 14, 2023, 'Bila', 788500, 2),
('PY1CF3982PD492819', 17, 2022, 'Cerna', 2252900, 4),
('VL2SG3847JM483618', 18, 2024, 'Zelena', 4939220, 4),
('OK6KR2942PE671932', 19, 2022, 'Cerna', 1483110, 3),
('YD3UA6130DR827102', 17, 2023, 'Modra', 2237800, 3),
('DT2BO8925RF904711', 20, 2023, 'Cervena', 459900, 4),
('FK4JD4016YP792005', 21, 2024, 'Bila', 883900, 1),
('BR8EO6711TU671834', 18, 2024, 'Seda', 4900500, 1),
('AU2KT9102GL901367', 19, 2022, 'Zelena', 1445500, 2),
('BL4TK7398JU221367', 22, 2024, 'Bila', 986150, 3),
('DA4RV7398KF866194', 23, 2024, 'Cerna', 2317150, 3),
('KF7FC3311EU394301', 1, 2024, 'Modra', 1561000, 4),
('RC6MH7321DS384421', 24, 2024, 'Seda', 599900, 1),
('RA2VS7825RL493628', 17, 2022, 'Seda', 2249300, 1),
('JL7RV5892OZ495322', 15, 2023, 'Cervena', 2289000, 4),
('AC3GP3948SN384755', 25, 2024, 'Cerna', 3019000, 1),
('UD7SC7833RZ971557', 13, 2024, 'Cervena', 1280300, 3),
('EK5TF5832RS274994', 1, 2023, 'Bila', 1537400, 2),
('TP6FS6221AD742119', 19, 2022, 'Zelena', 1466330, 4),
('RB2UZ7112CA588825', 4, 2024, 'Cerna', 1147800, 4),
('EZ4UL8284KA837116', 25, 2024, 'Seda', 3044500, 3),
('VP1SZ8437EL585742', 24, 2024, 'Seda', 621300, 2),
('AV5RJ7442TA663700', 5, 2023, 'Modra', 838500, 1),
('CP4AM6901SK400277', 18, 2023, 'Bila', 502400, 3),
('RN2TK5539MP691832', 5, 2022, 'Cervena', 831000, 2),
('DT8KO2899RP938271', 7, 2023, 'Zelena', 2050000, 1),
('YD1KZ5866UZ698521', 25, 2024, 'Cervena', 3050000, 2),
('MG7VP8044BR283052', 6, 2024, 'Cerna', 844000, 1),
('GF8RL2837BF503817', 13, 2022, 'Bila', 1310400, 3),
('KS9MU3281UZ582934', 17, 2022, 'Cervena', 2231700, 2),
('SB2UL6814GM993716', 7, 2023, 'Cerna', 1993600, 4),
('ZC7KP5722BO611563', 20, 2024, 'Modra', 464800, 3),
('LD4RZ6128PV471885', 14, 2023, 'Bila', 779000, 4),
('BG8ST6306DM703926', 22, 2023, 'Bila', 975100, 2),
('GM7KR7038TV748172', 20, 2022, 'Cerna', 471250, 1),
('ZL9AM5766RK394427', 24, 2024, 'Seda', 631000, 4),
('UG8IT4922PG399144', 2, 2022, 'Cerna', 1063200, 1),
('GV2BU8237LS481637', 18, 2024, 'Bila', 4903300, 3),
('RA2CK4682UP492281', 9, 2024, 'Cervena', 594000, 2),
('FP3AO5710KR932816', 3, 2023, 'Modra', 1025770, 4),
('FP4DN3049VU283752', 20, 2024, 'Bila', 4765500, 2),
('US7CA3894DP485721', 10, 2024, 'Zelena', 630000, 1),
('MR2LS1034BP392822', 20, 2023, 'Cerna', 471000, 3),
('YS8RM7028FT737557', 7, 2022, 'Cerna', 2013300, 2),
('BE2DP3872MS372513', 4, 2024, 'Cerna', 1139500, 3),
('DA3RL6884ME395731', 4, 2023, 'Bila', 1156700, 1),
('JS5AL9586UD382193', 8, 2024, 'Modra', 533000, 2),
('GP9AR5968MP493812', 9, 2023, 'Cervena', 600000, 1),
('SY1DM3675VL607427', 10, 2023, 'Modra', 630000, 3),
('KZ8EL2417HC495866', 12, 2024, 'Cerna', 764500, 2),
('PC6AT1682UM258617', 15, 2022, 'Cerna', 2258000, 1),
('UC6PL1286MR394822', 16, 2023, 'Cervena', 1310000, 4),
('FU7SP8211NG112507', 3, 2022, 'Cerna', 1027220, 3),
('PA8SN5831PZ384765', 2, 2024, 'Bila', 1065500, 4),
('YM6PH3827ZR384445', 22, 2023, 'Cervena', 981550, 1),
('BR3CG4832PD383221', 14, 2023, 'Bila', 780000, 1);

-- DEAL
INSERT INTO auto_sales.deal (deal_date, manager, client, car) VALUES
('2024-04-01', 2, 1, 'JB3AL3894LF501412'),
('2024-04-03', 3, 2, 'KT6BA8211NG112507'),
('2024-04-04', 4, 3, 'GV2BU8237LS481637'),
('2024-04-07', 3, 4, 'KU6BT2415LK244804'),
('2024-04-07', 1, 5, 'BK3TR4366KP272169'),
('2024-04-10', 5, 6, 'PU3VC7491AT782194'),
('2024-04-14', 3, 7, 'ME6BT5035OM537911'),
('2024-04-16', 4, 2, 'BL4TK7398JU221367'),
('2024-04-18', 3, 7, 'CR7AD7832BM495017'),
('2024-04-19', 2, 8, 'GU5AD6729MV413489'),
('2024-04-21', 1, 9, 'PC6AT1682UM258617'),
('2024-04-23', 4, 10, 'RU9UP9715FR039211'),
('2024-04-24', 5, 11, 'UV7CN5673LC518591'),
('2024-04-26', 1, 4, 'DT8KO2899RP938271'),
('2024-04-27', 3, 4, 'YD1KZ5866UZ698521'),
('2024-04-29', 2, 5, 'GM7KR7038TV748172'),
('2024-05-02', 4, 12, 'YS6CM5714FT831280'),
('2024-05-03', 3, 1, 'OU5SC8371BK978253'),
('2024-05-06', 6, 13, 'SB2UL6814GM993716'),
('2024-05-06', 1, 3, 'RA2VS7825RL493628'),
('2024-05-08', 5, 14, 'PY1CF3982PD492819'),
('2024-05-11', 6, 15, 'DT2BO8925RF904711'),
('2024-05-13', 4, 2, 'OK6KR2942PE671932'),
('2024-05-14', 3, 3, 'AS6GL4892MK304918'),
('2024-05-17', 4, 5, 'YD3UA6130DR827102'),
('2024-05-17', 4, 16, 'CP4AM6901SK400277'),
('2024-05-19', 3, 17, 'EK5TF5832RS274994'),
('2024-05-22', 1, 18, 'FK4JD4016YP792005'),
('2024-05-24', 5, 14, 'ZL9AM5766RK394427'),
('2024-05-26', 4, 2, 'UD7SC7833RZ971557'),
('2024-05-27', 4, 10, 'MC5DR8471KT290117'),
('2024-05-30', 3, 19, 'KS9MU3281UZ582934'),
('2024-06-01', 3, 20, 'AU2KT9102GL901367'),
('2024-06-04', 2, 1, 'DA3RL6884ME395731'),
('2024-06-06', 4, 11, 'ZC7KP5722BO611563'),
('2024-06-07', 6, 21, 'FP3AO5710KR932816'),
('2024-06-10', 6, 7, 'LD4RZ6128PV471885'),
('2024-06-12', 1, 22, 'MG7VP8044BR283052'),
('2024-06-13', 4, 23, 'FO9AT2275HP251106'),
('2024-06-15', 3, 13, 'RA2CK4682UP492281'),
('2024-06-16', 3, 23, 'FP4DN3049VU283752'),
('2024-06-17', 2, 9, 'US7CA3894DP485721'),
('2024-06-18', 6, 15, 'TP6FS6221AD742119'),
('2024-06-21', 4, 7, 'GF8RL2837BF503817'),
('2024-06-23', 2, 5, 'AV5RJ7442TA663700'),
('2024-06-24', 3, 19, 'BG8ST6306DM703926'),
('2024-06-27', 4, 1, 'SY1DM3675VL607427'),
('2024-06-29', 5, 11, 'UC6PL1286MR394822'),
('2024-06-30', 2, 3, 'YM6PH3827ZR384445');

-- =====================================================================
-- 3. VIEW
-- =====================================================================

CREATE OR REPLACE VIEW auto_sales.saled_cars AS
SELECT
    cmn.name AS brand,
    cm.name AS model,
    c.year_of_manufacture,
    CONCAT(m.name, ' ', m.surname) AS manager,
    CONCAT(cl.name, ' ', cl.surname) AS client
FROM auto_sales.deal d
JOIN auto_sales.car c ON c.vin = d.car
JOIN auto_sales.car_model cm ON cm.id = c.model
JOIN auto_sales.car_manufacturer cmn ON cmn.id = cm.car_manufacturer
JOIN auto_sales.client cl ON cl.id = d.client
JOIN auto_sales.manager m ON m.id = d.manager;

SELECT * FROM saled_cars

-- ===================================================================
-- 4. REKURZE
-- ===================================================================

ALTER TABLE auto_sales.manager
ADD COLUMN boss_id INT NULL;

ALTER TABLE auto_sales.manager
ADD CONSTRAINT fk_manager_boss
FOREIGN KEY (boss_id) REFERENCES auto_sales.manager(id);

UPDATE auto_sales.manager
SET boss_id = 1
WHERE id IN (2,3,4,5,6);

-- ===================================================================
-- 5. SELECTY
-- ===================================================================

SELECT
    ROUND(AVG(cnt), 1) AS avg_rows_per_table
FROM (
    SELECT COUNT(*) AS cnt FROM auto_sales.country
    UNION ALL
    SELECT COUNT(*) FROM auto_sales.city
    UNION ALL
    SELECT COUNT(*) FROM auto_sales.autosalon
    UNION ALL
    SELECT COUNT(*) FROM auto_sales.manager
    UNION ALL
    SELECT COUNT(*) FROM auto_sales.client
    UNION ALL
    SELECT COUNT(*) FROM auto_sales.car_manufacturer
    UNION ALL
    SELECT COUNT(*) FROM auto_sales.car_model
    UNION ALL
    SELECT COUNT(*) FROM auto_sales.car
    UNION ALL
    SELECT COUNT(*) FROM auto_sales.deal
) t;

WITH RECURSIVE sub AS (
  SELECT id, name, surname, boss_id, 0 AS level
  FROM auto_sales.manager
  WHERE id = 1

  UNION ALL

  SELECT m.id, m.name, m.surname, m.boss_id, sub.level + 1
  FROM auto_sales.manager m
  JOIN sub ON m.boss_id = sub.id
)
SELECT *
FROM sub
ORDER BY level, id;

SELECT *
FROM (
  SELECT
    d.client,
    CONCAT(cl.name, ' ', cl.surname) AS client_name,
    SUM(c.price_czk) AS total_spent
  FROM auto_sales.deal d
  JOIN auto_sales.car c ON c.vin = d.car
  JOIN auto_sales.client cl ON cl.id = d.client
  GROUP BY d.client, cl.name, cl.surname
) t
WHERE t.total_spent >
  (SELECT AVG(total_spent) FROM (
     SELECT SUM(c2.price_czk) AS total_spent
     FROM auto_sales.deal d2
     JOIN auto_sales.car c2 ON c2.vin = d2.car
     GROUP BY d2.client
   ) x)
ORDER BY t.total_spent DESC;

-- ===================================================================
-- 6. INDEXY
-- ===================================================================

CREATE UNIQUE INDEX IF NOT EXISTS ux_client_pass_number
ON auto_sales.client(pass_number);

CREATE INDEX IF NOT EXISTS ix_autosalon_fulltext
ON auto_sales.autosalon
USING GIN (to_tsvector('simple', COALESCE(name,'') || ' ' || COALESCE(adress,'')));

SELECT *
FROM auto_sales.autosalon
WHERE to_tsvector('simple', COALESCE(name,'') || ' ' || COALESCE(adress,'')) @@ plainto_tsquery('simple', 'Dream');

INSERT INTO auto_sales.client (name, surname, phone, pass_number, citizenship) VALUES
('Igor', 'Blokhin', '+420 703 994 889', 'AP1136731', 4)

select * from auto_sales.client where pass_number = 'AP1136731'\

-- ===================================================================
-- 7. FUNKCE 
-- ===================================================================

DROP FUNCTION auto_sales.client_total_spent
CREATE OR REPLACE FUNCTION auto_sales.client_total_spent(client_pass_number VARCHAR)
RETURNS INT
LANGUAGE sql
AS $$
  SELECT COALESCE(SUM(c.price_czk), 0)::INT
  FROM auto_sales.deal d
  JOIN auto_sales.car c ON c.vin = d.car
  JOIN auto_sales.client cli on cli.id = d.client
  WHERE cli.pass_number = client_pass_number;
$$;

SELECT auto_sales.client_total_spent('AP1136731') AS total_client_1;

-- ===================================================================
-- 8. PROCEDURA A TRANSAKCE
-- ===================================================================

DROP TABLE client_bonus;

CREATE TABLE IF NOT EXISTS auto_sales.client_bonus (
    client_id    INT NOT NULL REFERENCES auto_sales.client(id) PRIMARY KEY,
    bonus_czk    INT NOT NULL CHECK (bonus_czk >= 0),
    generated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE OR REPLACE PROCEDURE auto_sales.generate_client_bonuses(p_commit BOOLEAN)
LANGUAGE plpgsql
AS $$
DECLARE
    cur_clients CURSOR FOR
        SELECT id
        FROM auto_sales.client
        ORDER BY id;

    v_client_id INT;
    v_bonus     INT;
BEGIN
    OPEN cur_clients;

    LOOP
        FETCH cur_clients INTO v_client_id;
        EXIT WHEN NOT FOUND;

        v_bonus := (random() * 50000)::INT;

        INSERT INTO auto_sales.client_bonus (client_id, bonus_czk, generated_at)
        VALUES (v_client_id, v_bonus, now())
        ON CONFLICT (client_id)
        DO UPDATE
           SET bonus_czk    = EXCLUDED.bonus_czk,
               generated_at = EXCLUDED.generated_at;
    END LOOP;

    CLOSE cur_clients;

    -- ТРАНЗАКЦИЯ — ВОТ ОНА
    IF p_commit THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END;
$$;

CALL auto_sales.generate_client_bonuses(TRUE);


CALL auto_sales.generate_client_bonuses(FALSE);

SELECT *
FROM auto_sales.client_bonus

-- =============================================================
-- 9. TRIGGER
-- ==============================================================

DROP TABLE auto_sales.car_log;

CREATE TABLE auto_sales.car_log (
    car_vin      VARCHAR(20) PRIMARY KEY,
    created_by   TEXT,
    created_at   TIMESTAMPTZ DEFAULT now()
);

CREATE OR REPLACE FUNCTION auto_sales.log_new_car()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO auto_sales.car_log (car_vin, created_by)
    VALUES (NEW.vin, current_user);

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_log_car_insert ON auto_sales.car;

CREATE TRIGGER trg_log_car_insert
AFTER INSERT
ON auto_sales.car
FOR EACH ROW
EXECUTE FUNCTION auto_sales.log_new_car();

DELETE FROM auto_sales.car WHERE vin = 'TESTVIN1234567890';

INSERT INTO auto_sales.car (vin, model, year_of_manufacture, color, price_czk, autosalon)
VALUES ('TESTVIN1234567890', 1, 2024, 'Bila', 999999, 1);

SELECT * FROM auto_sales.car_log;
SELECT * FROM auto_sales.car c 

-- ==================================================
-- 10. ROLE
-- ==================================================

-- РОЛЬ
-- 1) роль
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'auto_sales_readonly') THEN
    CREATE ROLE auto_sales_readonly;
  END IF;
END
$$;

-- 2) CONNECT на текущую БД (правильно через EXECUTE)
DO $$
BEGIN
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO auto_sales_readonly', current_database());
END
$$;

-- 3) доступ к схеме
GRANT USAGE ON SCHEMA auto_sales TO auto_sales_readonly;

-- 4) SELECT на уже существующие таблицы
GRANT SELECT ON ALL TABLES IN SCHEMA auto_sales TO auto_sales_readonly;
GRANT UPDATE ON ALL TABLES IN SCHEMA auto_sales TO auto_sales_readonly;
REVOKE SELECT ON ALL TABLES IN SCHEMA auto_sales FROM auto_sales_readonly;

-- 5) SELECT по умолчанию на будущие таблицы (замени postgres на владельца схемы/таблиц)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA auto_sales
GRANT SELECT ON TABLES TO auto_sales_readonly;

-- ПОЛЬЗОВАТЕЛЬ С РОЛЬЮ
-- создаём пользователя
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'auto_sales_user') THEN
    CREATE USER auto_sales_user WITH PASSWORD '5432';
  END IF;
END
$$;

-- выдаём роль пользователю
GRANT auto_sales_readonly TO auto_sales_user;

SELECT current_user, session_user, current_database();

-- Удаление прав
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA auto_sales FROM auto_sales_readonly;
REVOKE ALL PRIVILEGES ON SCHEMA auto_sales FROM auto_sales_readonly;
REVOKE CONNECT ON DATABASE auto_sales FROM auto_sales_readonly;

DROP OWNED BY auto_sales_readonly;

-- Удаление роли у пользователя
REVOKE auto_sales_readonly FROM auto_sales_user;

-- Удаление пользователя
DROP USER auto_sales_user;

-- Удаление роли
DROP ROLE auto_sales_readonly;

-- ========================================================
-- 11. LOCK
-- ========================================================

BEGIN;

LOCK TABLE auto_sales.client IN EXCLUSIVE MODE;

ROLLBACK 


BEGIN;
SELECT *
FROM auto_sales.client
WHERE id = 1
FOR UPDATE;

ROLLBACK 

-- ВЫПОЛНИТЬ ДЛЯ ВТОРОГО ПОЛЬЗОВАТЕЛЯ
SELECT current_user, current_database();

UPDATE auto_sales.client
SET phone = '000'
WHERE id = 1
RETURNING *;
-- ВЫПОЛНИТЬ ДЛЯ ВТОРОГО ПОЛЬЗОВАТЕЛЯ

ALTER USER postgres WITH PASSWORD '5432';


SELECT * FROM saled_cars sc 
