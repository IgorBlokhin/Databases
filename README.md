# Auto Sales Database

Semestrální projekt v PostgreSQL pro předmět **Relační databázové systémy (UJEP)**.

Databáze **auto_sales** slouží jako jednoduchý informační systém pro síť autosalonů.

---

## Použité technologie

- PostgreSQL 16  
- DBeaver  
- Python + SQLAlchemy (ukázka ORM)

---

## Stručný popis

Databáze ukládá informace o:

- státech a městech  
- autosalonech  
- manažerech a klientech  
- výrobcích, modelech a autech (VIN)  
- prodejích (deal)  
- bonusech pro klienty  

---

## Hlavní tabulky

- `country`, `city`, `autosalon`
- `manager`, `client`
- `car_manufacturer`, `car_model`, `car`
- `deal`
- `client_bonus`

---

## Funkcionalita

Projekt obsahuje:

- VIEW `auto_sales.saled_cars` pro přehled prodaných aut  
- unikátní a fulltextový index  
- funkci `client_total_spent(...)` pro výpočet útraty klienta  
- proceduru `generate_client_bonuses(p_commit BOOLEAN)` s kurzorem a transakcí  
- trigger pro logování vložení nového auta  
- roli `auto_sales_readonly` s právy pouze pro čtení  
- ukázky zamykání (LOCK)  
- jednoduchou ukázku ORM pomocí SQLAlchemy  

---

## Autor

Igor Blokhin

---

## Licence

Pouze pro studijní účely.
