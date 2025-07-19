drop view if exists client_deals;
drop table if exists discount;
drop table if exists deal_log;
drop table if exists deal;
drop table if exists car;
drop table if exists model;
drop table if exists manufacturer;
drop table if exists client;
drop table if exists country_manager;
drop table if exists manager;
drop table if exists autosalon;
drop table if exists city;
drop table if exists country;

create table public.country
(
country_id serial primary key,
country_name varchar(100) not null
);

create unique index country_name on country(country_name);

create table public.client
(
client_id serial primary key,
client_name varchar(100) not null,
client_surname varchar(100) not null,
client_phone varchar(30),
client_pass_number varchar(15) not null,
country_id int, 
constraint fr_country_client foreign key(country_id) references public.country(country_id)
);

create table public.city
(
city_id serial primary key,
city_name varchar(30) not null,
country_id int not null,
constraint fr_country_city foreign key(country_id) references public.country(country_id)
);

create table public.autosalon
(
autosalon_id serial primary key,
autosalon_name varchar(30) not null,
autosalon_phone varchar(30) not null,
city_id int not null,
constraint fr_city_autosalon foreign key(city_id) references public.city(city_id),
autosalon_adress varchar(50)
);

create table public.manager
(
manager_id serial primary key,
manager_name varchar(100) not null,
manager_surname varchar(100) not null,
manager_phone varchar(30) not null,
manager_pass_number varchar(15) not null,
autosalon_id int,
constraint fr_autosalon_manager foreign key(autosalon_id) references public.autosalon(autosalon_id)
);

create table public.country_manager
(
country_id serial,
constraint fr_country_manager foreign key(country_id) references public.country(country_id),
manager_id serial,
constraint fr_manager_country foreign key(manager_id) references public.manager(manager_id),
constraint country_manager_pkey primary key (country_id, manager_id)
);

create table public.manufacturer
(
manufacturer_id serial primary key,
manufacturer_name varchar(30) not null,
country_id int,
constraint fr_country_car_manufacturer foreign key(country_id) references public.country(country_id)
);

create table public.model
(
model_id serial primary key,
model_name varchar(30) not null,
manufacturer_id int,
constraint fr_car_manufacturer_car_model foreign key(manufacturer_id) references public.manufacturer(manufacturer_id)
);

create table public.car
(
car_vin varchar(20) primary key,
model_id int not null,
constraint fr_model_car foreign key(model_id) references public.model(model_id),
car_year_of_manufacture int not null,
car_color varchar(20) not null,
car_price_czk int not null,
autosalon_id int,
constraint fr_autosalon_car foreign key(autosalon_id) references public.autosalon(autosalon_id),
image_url varchar(255)
);

create index image_url on car(image_url);

create table public.deal
(
deal_id serial primary key,
deal_date date not null,
manager_id int,
constraint fr_manager_deal foreign key(manager_id) references public.manager(manager_id),
client_id int,
constraint fr_client_deal foreign key(client_id) references public.client(client_id),
car_vin varchar(20),
constraint fr_car_deal foreign key(car_vin) references public.car(car_vin)
);


create table deal_log (
id serial primary key,
deal_id INT not null,
inserted_at timestamp default current_timestamp,
inserted_by text not null
);



create or replace function log_insert()
returns trigger as $$
begin
    insert into deal_log (deal_id, inserted_at, inserted_by)
    values (new.deal_id, now(), current_user);
    return new;
end;
$$ language plpgsql;

create trigger after_insert_deal
after insert on deal
for each row
execute function log_insert();



insert into public.country (country_name) values
('Cesko'),
('USA'),
('Estonsko'),
('Svedsko'),
('Japonsko'),
('Nemecko'),
('Italie'),
('Norsko'),
('Lotyssko'),
('Slovensko');

insert into public.city (city_name, country_id) values
('Praha', 1),
('Usti nad Labem', 1),
('Brno', 1);

insert into public.client (client_name, client_surname, client_phone, client_pass_number, country_id) values
('Jan', 'Novotny', '+420 773 693 895', 'T6548537', 1),
('Marek', 'Kvapil', '+420 703 928 869', 'P2931786', 1),
('Leonardo', 'DiCaprio', '+420 429 764 673', 'U92842617', 2),
('Andres', 'Kork', '+420 793 653 264', 'S8305716', 3),
('Marketa', 'Pekarova-Adamova', '+420 772 737 469', 'L7491358', 1),
('Beatrice', 'Kovalli', '+420 385 651 843', 'GA3871631', 7),
('Magnus', 'Karlsen', '+420 963 579 453', 'T4381631', 8),
('Aldonis', 'Blaus', '+420 536 732 690', 'T672903', 9),
('Ulrike', 'Meinhof', '+420 155 102 547', 'T43005596', 6),
('Andres', 'Schmidt', '+420 178 491 260', 'K84195924', 6),
('Sebastiano', 'Danielli', '+420 504 661 689', 'AP1136731', 7),
('Joanna', 'Stingray', '+420 425 484 954', 'C4869253', 2),
('Pavel', 'Nedved', '+420 777 839 287', 'D3851037', 1),
('Lili', 'Huhn', '+49 286 294 9382', 'YR7341937', 6),
('Marek', 'Holly', '+420 456 233 836', 'K7281704', 10),
('Lucie', 'Kodrasova', '+420 286 294 932', 'YK3811489', 1),
('Vojtech', 'Klaus', '+420 722 658 911', 'FE469310', 1),
('Petr', 'Cech', '+420 744 381 472', 'PA384721', 1),
('Vaclav', 'Klaus', '+420 711 859 573', 'UR948503', 1),
('Zuzana', 'Bergrova', '+420 704 693 485', 'TN958726', 1),
('Martin', 'Jurecka', '+420 734 958 378', 'KV745342', 1),
('Pavel', 'Kafka', '+420 706 485 823', 'BL382618', 1),
('Jim', 'Morrison', '+420 501 266 892', 'R5738496', 2),
('Fumio', 'Kishida', '+420 778 931 636', 'TM8374610', 5),
('Lorenzo', 'Zurzolo', '+420 407 756 381', 'PA679236', 7),
('Kristjan', 'Saar', '+420 572 847 376', 'LB3849267', 9),
('Imamura', 'Atsuko', '+420 378 746 785', 'MS738940', 5),
('Vladimir', 'Polak', '+420 847 639 063', 'DB837594', 1),
('Dita', 'Simackova', '+420 593 857 362', 'RZ847508', 1),
('Jaroslav', 'Harcar', '+420 299 304 762', 'UD939821', 1),
('Matej', 'Cibak', '+420 367 827 172', 'KA372510', 10);

insert into public.autosalon (autosalon_name, autosalon_phone, city_id, autosalon_adress) values
('Auto Palace', '+420 771 356 726', 1, 'Vodickova 86/7'),
('Auto Dream', '+420 578 285 629', 2, 'Nademlejnska 339/13'),
('Urban Wheels', '+420 357 938 536', 3, 'Husova 41/2'),
('Auto Zone', '+420 481 273 726', 2, 'Prazska 277/17'),
('Auto World', '+420 682 573 284', 1, 'Hronovicka 594/21');

insert into public.manager (manager_name, manager_surname, manager_phone, manager_pass_number, autosalon_id) values
('Petr', 'Svoboda', '+420 775 284 336', 'UT738419', 1),
('Jana', 'Novackova', '+420 755 287 332', 'KP374189', 1),
('Pavel', 'Dvorak', '+420 713 639 366', 'YR782942', 2),
('Andrea', 'Prochazkova', '+420 733 691 225', 'JP480138', 3),
('Ludvik', 'Krejci', '+420 718 991 641', 'MO791035', 4),
('Jan', 'Marek', '+420 721 782 297', 'HL375910', 4),
('Pavel', 'Vesely', '+420 803 847 231', 'OF377842', 5);

insert into public.country_manager (country_id, manager_id) values
(1, 1),
(1, 2),
(1, 3),
(2, 3),
(1, 4),
(1, 5),
(3, 5),
(1, 6),
(1, 7);

insert into public.manufacturer (manufacturer_name, country_id) values
('Volvo', 4),
('Ford', 2),
('Hyundai', 5),
('Skoda', 1),
('BMW', 6),
('Audi', 6),
('Mercedes', 6),
('Alfa Romeo', 5),
('Cadillac', 2);

insert into public.model (model_name, manufacturer_id) values
('S90', 1),
('Kuga', 2),
('Elantra N', 3),
('XC40', 1),
('Edge', 2), --5
('XC60', 1),
('Explorer', 2),
('Fabia', 4),
('Scala', 4),
('Creta', 3), --10
('Z4', 5),
('Octavia', 4),
('X2', 5),
('A5 Sportback', 6),
('A6 Allroad quattro', 6), --15
('Superb', 4),
('S7 Sportback', 6),
('AMG GT', 7),
('X3', 5),
('Kodiaq', 4), --20
('Karoq', 4),
('CLA', 7),
('GLS', 7),
('i30 Fastback', 3),
('8 Series Cabrio', 5), --25
('Santa Fe', 5),
('Stelvio Quadrifoglio', 8),
('Enyaq RS', 4),
('Escalade ESV Sport Platinum', 9),
('XT6', 9), --30
('Giulia 2.0 Turbo', 8),
('Q5 S Line', 6);

insert into public.car (car_vin, model_id, car_year_of_manufacture, car_color, car_price_czk, autosalon_id, image_url) values
('JB3AL3894LF501412', 1, 2022, 'Bila', 1559000, 1, 'images/5328130711825279784.jpg'),
('MU3KI1076LP152364', 2, 2023, 'Modra', 1058700, 2, 'images/5328130711825279785.jpg'),
('KT6BA8211NG112507', 3, 2022, 'Cerna', 1015190, 2, 'images/5328130711825279794.jpg'),
('FO9AT2275HP251106', 2, 2024, 'Zelena', 1050100, 3, 'images/5332652711092546084.jpg'),
('KU6BT2415LK244804', 4, 2023, 'Cerna', 1139900, 2, 'images/5328130711825279844.jpg'),
('UV7CN5673LC518591', 5, 2023, 'Cervena', 845500, 4, 'images/5328130711825279793.jpg'),
('ME6BT5035OM537911', 6, 2024, 'Seda', 1498200, 2, 'images/5328130711825279787.jpg'),
('BK3TR4366KP272169', 3, 2024, 'Bila', 1005000, 1, 'images/5328130711825279788.jpg'),
('YS6CM5714FT831280', 7, 2022, 'Modra', 2000000, 3, 'images/5328130711825279861.jpg'),
('GO2NA8710HU854377', 4, 2022, 'Zelena', 1167000, 5, 'images/5328130711825279790.jpg'),
('LH3AL6501AN637984', 1, 2023, 'Cerna', 1550300, 5, 'images/5328130711825279791.jpg'),
('SR2DP1595KR549179', 8, 2023, 'Cerna', 537000, 1, 'images/5328130711825279792.jpg'),
('PU3VC7491AT782194', 9, 2024, 'Zelena', 600000, 4, 'images/5334598013450053057.jpg'),
('UE9TK2804DR783925', 10, 2022, 'Cervena', 625000, 4, 'images/5336849813263738258.jpg'),
('SF1US7495ER390582', 9, 2024, 'Bila', 611500, 3, 'images/5328130711825279802.jpg'),
('CR7AD7832BM495017', 11, 2023, 'Cerna', 1975000, 2, 'images/5328130711825279803.jpg'),
('GU5AD6729MV413489', 12, 2024, 'Cervena', 769800, 1, 'images/5328130711825279805.jpg'),
('BG4DL9381FB102849', 11, 2022, 'Modra', 1959300, 1, 'images/5328130711825279806.jpg'),
('MC5DR8471KT290117', 11, 2023, 'Zelena', 1960500, 3, 'images/5328130711825279804.jpg'),
('AS6GL4892MK304918', 13, 2023, 'Seda', 1320000, 2, 'images/5328130711825279808.jpg'),
('RU9UP9715FR039211', 1, 2024, 'Seda', 1580000, 3, 'images/5328130711825279807.jpg'),
('QQ8AJ6163HK967028', 14, 2023, 'Modra', 741000, 5, 'images/5328130711825279809.jpg'),
('AJ4ST8713KO139811', 15, 2022, 'Cerna', 2269000, 2, 'images/5328130711825279810.jpg'),
('DU5ME9937NK390036', 16, 2023, 'Cervena', 1302500, 1, 'images/5328130711825279811.jpg'),
('OU5SC8371BK978253', 14, 2023, 'Bila', 788500, 2, 'images/5328130711825279812.jpg'),
('PY1CF3982PD492819', 17, 2022, 'Cerna', 2252900, 4, 'images/5328130711825279813.jpg'),
('VL2SG3847JM483618', 8, 2024, 'Zelena', 520000, 4, 'images/5328130711825279815.jpg'),
('YD3UA6130DR827102', 17, 2023, 'Modra', 2237800, 3, 'images/5328130711825279817.jpg'),
('DF0RX5396HR211921', 15, 2024, 'Cerna', 2260000, 5, 'images/5334598013450053058.jpg'),
('BR8EO6711TU671834', 18, 2024, 'Seda', 4900500, 1, 'images/5328130711825279821.jpg'),
('OK6KR2942PE671932', 19, 2022, 'Cerna', 1483110, 3, 'images/5328130711825279816.jpg'),
('AU2KT9102GL901367', 19, 2022, 'Zelena', 1445500, 2, 'images/5328130711825279822.jpg'),
('DT2BO8925RF904711', 20, 2023, 'Cervena', 459900, 4, 'images/5328130711825279818.jpg'),
('FK4JD4016YP792005', 21, 2024, 'Bila', 883900, 1, 'images/5328130711825279820.jpg'),
('BL4TK7398JU221367', 22, 2024, 'Bila', 986150, 3, 'images/5328130711825279823.jpg'),
('DA4RV7398KF866194', 23, 2024, 'Cerna', 2317150, 3, 'images/5328130711825279824.jpg'),
('KF7FC3311EU394301', 1, 2024, 'Modra', 1561000, 4, 'images/5328130711825279825.jpg'),
('RC6MH7321DS384421', 24, 2024, 'Seda', 599900, 1, 'images/5334598013450053060.jpg'),
('BE9SL7230MX187446', 11, 2024, 'Bila', 1945000, 5, 'images/5328130711825279836.jpg'),
('AP3HP4988ZZ590751', 21, 2023, 'Modra', 840000, 5, 'images/5328130711825279837.jpg'),
('RA2VS7825RL493628', 17, 2022, 'Seda', 2249300, 1, 'images/5328130711825279838.jpg'),
('JL7RV5892OZ495322', 15, 2023, 'Cervena', 2289000, 4, 'images/5328130711825279839.jpg'),
('AC3GP3948SN384755', 25, 2024, 'Cerna', 3019000, 1, 'images/5328130711825279840.jpg'),
('UD7SC7833RZ971557', 12, 2024, 'Cervena', 775000, 3, 'images/5328130711825279841.jpg'),
('EK5TF5832RS274994', 1, 2023, 'Bila', 1537400, 2, 'images/5328130711825279842.jpg'),
('TP6FS6221AD742119', 19, 2022, 'Zelena', 1466330, 4, 'images/5328130711825279843.jpg'),
('RB2UZ7112CA588825', 4, 2024, 'Cerna', 1147800, 4, 'images/5328130711825279844.jpg'),
('EZ4UL8284KA837116', 25, 2024, 'Seda', 3044500, 3, 'images/5328130711825279845.jpg'),
('EL5KA9012TD738821', 25, 2024, 'Cerna', 3010500, 5, 'images/5328130711825279846.jpg'),
('VP1SZ8437EL585742', 24, 2024, 'Bila', 621300, 2, 'images/5336849813263738261.jpg'),
('AV5RJ7442TA663700', 5, 2023, 'Modra', 838500, 1, 'images/5328130711825279861.jpg'),
('CP4AM6901SK400277', 15, 2023, 'Bila', 2230000, 3, 'images/5328130711825279862.jpg'),
('RN2TK5539MP691832', 5, 2022, 'Cervena', 831000, 2, 'images/5328130711825279863.jpg'),
('DT8KO2899RP938271', 7, 2023, 'Zelena', 2050000, 1, 'images/5328130711825279864.jpg'),
('YD1KZ5866UZ698521', 21, 2024, 'Cervena', 879000, 2, 'images/5328130711825279865.jpg'),
('MG7VP8044BR283052', 6, 2024, 'Cerna', 1522000, 1, 'images/5328130711825279866.jpg'),
('GF8RL2837BF503817', 13, 2022, 'Bila', 1310400, 3, 'images/5328130711825279867.jpg'),
('ZZ8LC0260CF239674', 8, 2023, 'Cervena', 527000, 5, 'images/5328130711825279868.jpg'),
('KS9MU3281UZ582934', 17, 2022, 'Cervena', 2231700, 2, 'images/5328130711825279869.jpg'),
('QR8ST9012UV890123', 25, 2024, 'Bila', 3050000, 4, 'images/5328130711825279870.jpg'),
('SB2UL6814GM993716', 7, 2023, 'Cerna', 1993600, 4, 'images/5328130711825279871.jpg'),
('ZC7KP5722BO611563', 24, 2024, 'Modra', 580000, 3, 'images/5334598013450053061.jpg'),
('LD4RZ6128PV471885', 14, 2023, 'Bila', 779000, 4, 'images/5332652711092546012.jpg'),
('BG8ST6306DM703926', 21, 2023, 'Bila', 860600, 3, 'images/5332652711092546014.jpg'),
('MN3OP9012QR345678', 19, 2022, 'Modra', 1470500, 5, 'images/5332652711092546014.jpg'),
('GM7KR7038TV748172', 20, 2022, 'Cerna', 471250, 1, 'images/5332652711092546017.jpg'),
('ZL9AM5766RK394427', 24, 2024, 'Seda', 631000, 4, 'images/5334598013450053060.jpg'),
('UG8IT4922PG399144', 2, 2022, 'Cerna', 1063200, 1, 'images/5334598013450053062.jpg'),
('GV2BU8237LS481637', 18, 2024, 'Bila', 4903300, 3, 'images/5332652711092546020.jpg'),
('RA2CK4682UP492281', 9, 2024, 'Cervena', 594000, 2, 'images/5332652711092546022.jpg'),
('LB9YZ3456AB901234', 12, 2023, 'Cervena', 751000, 5, 'images/5332652711092546021.jpg'),
('FP3AO5710KR932816', 3, 2023, 'Modra', 1025770, 4, 'images/5332652711092546023.jpg'),
('FP4DN3049VU283752', 20, 2024, 'Bila', 4765500, 2, 'images/5332652711092546024.jpg'),
('ST4UV3456WX456789', 22, 2023, 'Modra', 997300, 5, 'images/5336849813263738259.jpg'),
('US7CA3894DP485721', 10, 2024, 'Zelena', 630000, 1, 'images/5332652711092546082.jpg'),
('MR2LS1034BP392822', 20, 2023, 'Cerna', 471000, 3, 'images/5332652711092546083.jpg'),
('GC4RY8969EL865972', 2, 2022, 'Zelena', 1073500, 5, 'images/5332652711092546083.jpg'),
('YS8RM7028FT737557', 7, 2022, 'Cerna', 2013300, 2, 'images/5332652711092546085.jpg'),
('BE2DP3872MS372513', 4, 2024, 'Cerna', 1139500, 3, 'images/5332652711092546087.jpg'),
('YZ5AB7890CD567890', 18, 2024, 'Modra', 4920000, 5, 'images/5332652711092546086.jpg'),
('DA3RL6884ME395731', 4, 2023, 'Bila', 1156700, 1, 'images/5334598013450053065.jpg'),
('JS5AL9586UD382193', 8, 2024, 'Modra', 533000, 2, 'images/5332652711092546086.jpg'),
('GH2IJ5678KL234567', 3, 2023, 'Zelena', 1043000, 5, 'images/5332652711092546091.jpg'),
('GP9AR5968MP493812', 9, 2023, 'Cervena', 600000, 1, 'images/5332652711092546092.jpg'),
('SY1DM3675VL607427', 10, 2023, 'Modra', 630000, 3, 'images/5332652711092546081.jpg'),
('EF6GH1234IJ678901', 17, 2023, 'Cervena', 2220000, 5, 'images/5334904510906230989.jpg'),
('KL7MN5678OP789012', 20, 2024, 'Bila', 499000, 5, 'images/5334904510906230619.jpg'),
('KZ8EL2417HC495866', 12, 2024, 'Cerna', 764500, 2, 'images/5334904510906230620.jpg'),
('PC6AT1682UM258617', 15, 2022, 'Cerna', 2258000, 1, 'images/5334904510906230621.jpg'),
('EM5YQ9388NE338406', 5, 2023, 'Modra', 837900, 5, 'images/5334904510906230622.jpg'),
('UC6PL1286MR394822', 16, 2023, 'Cervena', 1310000, 4, 'images/5334904510906230623.jpg'),
('RN1SF3700TP874153', 9, 2024, 'Cervena', 570000, 5, 'images/5334904510906230624.jpg'),
('FU7SP8211NG112507', 3, 2022, 'Cerna', 1027220, 3, 'images/5334904510906230625.jpg'),
('PA8SN5831PZ384765', 2, 2024, 'Bila', 1065500, 4, 'images/5334904510906230626.jpg'),
('YM6PH3827ZR384445', 22, 2023, 'Cervena', 981550, 1, 'images/5334904510906230628.jpg'),
('UT8AY9012BD890123', 26, 2024, 'Bila', 617400, 5, 'images/5334598013450053055.jpg'),
('BR3CG4832PD383221', 14, 2023, 'Bila', 780000, 1, 'images/5334904510906230630.jpg'),
('VS5KA8872UM172638', 27, 2024, 'Modra', 2299000, 2, 'images/5334904510906230990.jpg'),
('TU3IG4027QE269668', 7, 2024, 'Bila', 2100500, 5, 'images/5334904510906230991.jpg'),
('EL4PZ0327KD958463', 25, 2024, 'Cervena', 3099000, 2, 'images/5334904510906230992.jpg'),
('PZ2US8872MT192638', 27, 2024, 'Cerna', 2310000, 4, 'images/5334904510906230993.jpg'),
('GU8LX3762SP764329', 28, 2024, 'Zelena', 1660000, 3, 'images/5334904510906230994.jpg'),
('UR8OA6419KS805421', 6, 2023, 'Bila', 1510000, 5, 'images/5336849813263738257.jpg'),
('TC6RM8536OD765768', 29, 2023, 'Cerna', 3689290, 3, 'images/5334904510906230996.jpg'),
('AK1VH7434EL902436', 30, 2024, 'Cervena', 1571790, 4, 'images/5334904510906230997.jpg'),
('ZG7YF3563DU750982', 18, 2024, 'Modra', 4955000, 4, 'images/5334904510906230998.jpg'),
('EO6BT2648KG873300', 27, 2024, 'Bila', 1534400, 1, 'images/5334904510906230999.jpg'),
('HO3DP1573TN358753', 31, 2024, 'Cervena', 1015000, 3, 'images/5334904510906231000.jpg'),
('AB6MT8031AL735764', 32, 2024, 'Cerna', 1314000, 1, 'images/5334904510906231008.jpg'),
('KB4OD9583PD844329', 32, 2024, 'Cerna', 1330000, 3, 'images/5334904510906231009.jpg'),
('TL2NR3540ZU897642', 32, 2024, 'Modra', 1349000, 2, 'images/5334904510906231010.jpg'),
('RL9OZ4099SK409387', 6, 2024, 'Cervena', 1535500, 3, 'images/5336849813263738260.jpg'),
('RM5AL7800UC200658', 13, 2022, 'Modra', 1299000, 1, 'images/5334904510906231011.jpg');

insert into public.deal (deal_date, manager_id, client_id, car_vin) values
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
('2024-06-30', 2, 3, 'YM6PH3827ZR384445'),
('2024-07-01', 1, 24, 'UR8OA6419KS805421'),
('2024-07-02', 6, 25, 'PA8SN5831PZ384765'),
('2024-07-04', 3, 19, 'TL2NR3540ZU897642'),
('2024-07-04', 2, 26, 'BG4DL9381FB102849'),
('2024-07-05', 1, 22, 'SR2DP1595KR549179'),
('2024-07-07', 5, 25, 'AB6MT8031AL735764'),
('2024-07-09', 4, 27, 'EZ4UL8284KA837116'),
('2024-07-10', 5, 8, 'RB2UZ7112CA588825'),
('2024-07-12', 2, 11, 'RM5AL7800UC200658'),
('2024-07-13', 6, 17, 'UE9TK2804DR783925'),
('2024-07-15', 3, 28, 'RN2TK5539MP691832'),
('2024-07-16', 1, 25, 'UG8IT4922PG399144'),
('2024-07-18', 4, 29, 'RL9OZ4099SK409387'),
('2024-07-19', 3, 9, 'AJ4ST8713KO139811'),
('2024-07-21', 2, 15, 'DU5ME9937NK390036'),
('2024-07-22', 5, 20, 'AK1VH7434EL902436'),
('2024-07-22', 4, 19, 'SF1US7495ER390582'),
('2024-07-24', 6, 14, 'JL7RV5892OZ495322'),
('2024-07-25', 1, 26, 'RC6MH7321DS384421'),
('2024-07-26', 3, 30, 'JS5AL9586UD382193'),
('2024-07-28', 5, 24, 'ZG7YF3563DU750982'),
('2024-07-30', 4, 31, 'TC6RM8536OD765768'),
('2024-07-31', 2, 28, 'BR3CG4832PD383221')



select avg(row_count) as average_row_count
from (
    select count(*) as row_count
    from country
    union all
    select count(*) as row_count
    from city
    union all
    select count(*) as row_count
    from manager
    union all
    select count(*) as row_count
    from country_manager
    union all
    select count(*) as row_count
    from manufacturer
    union all
    select count(*) as row_count
    from model
    union all
    select count(*) as row_count
    from car
    union all
    select count(*) as row_count
    from deal
    union all
    select count(*) as row_count
    from autosalon
    union all
    select count(*) as row_count
    from client
) as counts;

select autosalon_name, average,
	case when average < 1500000 then 'low value'
		 when average > 2500000 then 'high value'
		 else 'middle value'
	end as estimation
from
(select autosalon_id, round(avg(car_price_czk)) as average from 
(select car_vin, car_price_czk, autosalon_id
from car
except
select car_vin, car_price_czk, autosalon_id
from deal
join car using(car_vin))
group by autosalon_id)
join autosalon using(autosalon_id)
order by average

select round(avg(car_price_czk)) from deal
join car using(car_vin)
group by autosalon_id

alter table manager add column boss_id int references manager(manager_id);

update manager set boss_id = null where manager_id = 1; -- Менеджер 1 не имеет начальника
update manager set boss_id = 1 where manager_id = 2; -- Менеджер 2 подчиняется менеджеру 1
update manager set boss_id = null where manager_id = 3; -- Менеджер 3 не имеет начальника
update manager set boss_id = null where manager_id = 4; -- Менеджер 4 не имеет начальника
update manager set boss_id = null where manager_id = 5; -- Менеджер 4 не имеет начальника
update manager set boss_id = 5 where manager_id = 6; -- Менеджер 6 подчиняется менеджеру 5
update manager set boss_id = null where manager_id = 7; -- Менеджер 7 не имеет начальника

select
    concat(m1.manager_name, ' ', m1.manager_surname) as manager, 
    concat(m2.manager_name, ' ', m2.manager_surname) as boss
from manager m1
left join manager m2 on m1.boss_id = m2.manager_id; -- self join



create view client_deals as -- view
select c.client_name, c.client_surname, d.deal_date, ca.car_vin, ca.car_price_czk
from client c
join deal d on c.client_id = d.client_id
join car ca on d.car_vin = ca.car_vin;

drop view client_deals
select * from client_deals;

select * from deal_log



create function total_sales_by_date(p_deal_date date) returns numeric as $$ -- функция
declare 
    total_sales numeric;
begin 
    select sum(car_price_czk) into total_sales
    from deal d
    join car c on c.car_vin = d.car_vin
    where p_deal_date = deal_date;
    
    return total_sales;
end;
$$ language plpgsql;

select total_sales_by_date('2024-07-22')

drop function total_sales_by_date(date) 



drop table if exists discount;

create table public.discount
(
discount_id serial primary key,
client_id int,
constraint client_to_discount foreign key(client_id) references public.client(client_id),
discount_percent numeric(5,2) not null,  
created_at timestamp default now()
)

create or replace procedure generate_random_discounts() -- procedura
language plpgsql
as $$
declare
    cur cursor for select d.client_id, 
                          sum(c.car_price_czk) as total_spent 
                   from deal d
                   join car c on c.car_vin = d.car_vin
                   group by d.client_id;  -- суммируем покупки каждого клиента

    v_client_id int;
    total_spent numeric;
    discount_value numeric;
begin
    open cur;
    loop
        fetch cur into v_client_id, total_spent;
        exit when not found;

        -- Логика расчёта скидки
        discount_value := case 
            when total_spent > 2000000 then round((random() * 10 + 20)::numeric, 2) -- VIP (20-30%)
            when total_spent between 1000000 and 2000000 then round((random() * 10 + 10)::numeric, 2) -- Обычные (10-20%)
            else round((random() * 5 + 5)::numeric, 2) -- Новые (5-10%)
        end;

        -- Добавляем скидку в таблицу
        begin
            insert into discount (client_id, discount_percent, created_at)
            values (v_client_id, discount_value, now());
        exception
            when others then
                raise notice 'Ошибка при добавлении скидки для клиента %', v_client_id;
        end;
    end loop;

    close cur;
end;
$$;

call generate_random_discounts();

select * from discount



create or replace procedure sell_car( -- tranzakce
    date_deal date,
    id_manager int,
    id_client int,
    vin_number text
) language plpgsql as $$
declare
    car_price decimal(10,2);
    salon_id int;
    manager_salon_id int;
    client_exists int;
begin
	-- Zamykani tabulky deal
	lock table deal in exclusive mode;
	
    -- Overeni zda klient existuje
    select count(*) into client_exists from client where client_id = id_client;
    if client_exists = 0 then
        raise exception 'chyba: klient s id % nenalezen', id_client;
    end if;

    -- Overeni zda je auto jeste v autosalonu
    select car_price_czk, autosalon_id
    into car_price, salon_id
    from car
    where car_vin = vin_number
    and not exists (select 1 from deal where car_vin = vin_number);

    -- Pripad kdyz auto nebylo nalezeno nebo je prodano
    if car_price is null then
        raise exception 'chyba: auto s VIN % nenalezeno nebo jiz prodano', vin_number;
    end if;

    -- Overeni zda manazer pracuje ve stejnem autosalonu kde se nachazi auto
    select autosalon_id into manager_salon_id from manager where manager_id = id_manager;
    if manager_salon_id is null then
        raise exception 'chyba: manazer s id % nenalezen', id_manager;
    elsif manager_salon_id <> salon_id then
        raise exception 'chyba: manazer s id % nepracuje v salonu s id %, kde se nachazi auto', id_manager, salon_id;
    end if;

    -- Pokud vse je v poradku, vytvorime radek v tabulce deal o novem prodeje
    insert into deal (deal_date, manager_id, client_id, car_vin)
    values (date_deal, id_manager, id_client, vin_number);

    raise notice 'Auto bylo uspesne prodano!';

exception
    when others then
        -- kdyz chyba, vsechny zmeny jsou pryc
        raise;
end;
$$;


call sell_car('2024-08-01', 4, 10, 'WVWZZZ1JZXW000001') -- neexistujici ci prodane auto
call sell_car('2024-08-01', 5, 22, 'FU7SP8211NG112507') -- neschoda auta a manazera
call sell_car('2024-08-01', 9, 20, 'FU7SP8211NG112507') -- neexistujici manazer
call sell_car('2024-08-01', 4, 33, 'FU7SP8211NG112507') -- neexistujici klient
call sell_car('2024-08-01', 4, 17, 'FU7SP8211NG112507') -- uspesny prodej

create or replace user Igor with password '1111'


select car_vin, car_price_czk 
from car where car_price_czk > (select avg(car_price_czk)
                               from deal
                               join car using(car_vin))
except
select car_vin, car_price_czk 
from deal
join car using(car_vin)
