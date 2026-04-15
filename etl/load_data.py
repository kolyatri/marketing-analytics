import pandas as pd
from sqlalchemy import create_engine, text

# ---------- CONFIG ----------
DB_CONFIG = {
    "user": "postgres",
    "password": "kolyatrizubrik59",
    "host": "localhost",
    "port": "5432",
    "database": "marketing_analytics"
}

DATA_PATH = "data"

# ---------- CONNECTION ----------
def get_engine():
    url = (
        f"postgresql+psycopg2://{DB_CONFIG['user']}:{DB_CONFIG['password']}"
        f"@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"
    )
    return create_engine(url)


# ---------- CREATE SCHEMA ----------
def create_schema(engine):
    with engine.connect() as conn:
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw;"))
        conn.commit()


# ---------- LOAD CSV ----------
def load_csv(engine, file_name, table_name):
    file_path = f"{DATA_PATH}/{file_name}"
    
    df = pd.read_csv(file_path)

    # basic cleaning (мінімум для raw)
    df.columns = [col.strip().lower() for col in df.columns]

    df.to_sql(
        name=table_name,
        con=engine,
        schema="raw",
        if_exists="replace",  # для dev нормально
        index=False
    )

    print(f"Loaded {file_name} → raw.{table_name} ({len(df)} rows)")


# ---------- MAIN ----------
def main():
    engine = get_engine()

    print("Connected to DB")

    create_schema(engine)
    print("Schema raw created")

    load_csv(engine, "users.csv", "users")
    load_csv(engine, "sessions.csv", "sessions")
    load_csv(engine, "orders.csv", "orders")
    load_csv(engine, "ads_data.csv", "ads_data")

    print("All data loaded successfully")


if __name__ == "__main__":
    main()