from sqlalchemy import create_engine, text

# подключение к DB
engine = create_engine(
    "postgresql://postgres:5432@localhost:5432/auto_sales"
)

query = text("""
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
""")

# ORM-сессия не нужна, просто engine
with engine.connect() as conn:
    result = conn.execute(query)
    for row in result:
        print(row)