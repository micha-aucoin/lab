import json
import logging.config
import pathlib
import sqlite3


def setup_logging():
    config_file = pathlib.Path("logging_configs/config.json")
    with open(config_file) as f:
        config = json.load(f)
    logging.config.dictConfig(config)


def cp(table_name: str, db_source: str, db_target: str) -> None:
    source_conn = sqlite3.connect(db_source)
    target_conn = sqlite3.connect(db_target)
    source_cursor = source_conn.cursor()
    target_cursor = target_conn.cursor()

    sql = f"SELECT * FROM {table_name}"
    yf_logger.debug(sql)
    rows = source_cursor.execute(sql).fetchall()

    if rows:
        col_names = ", ".join(desc[0] for desc in source_cursor.description)
        placeholders = ", ".join("?" for _ in source_cursor.description)
        for row in rows:
            sql = f"""
            INSERT OR IGNORE INTO {table_name}({col_names})
                VALUES({placeholders})
            """
            yf_logger.debug(sql)
            yf_logger.debug(row)
            target_cursor.execute(sql, row)
            target_conn.commit()
    else:
        raise ValueError(f"{table_name} probably doesn't exist in {db_source}")

    source_conn.close()
    target_conn.close()


def select(table: str, db: str) -> None:
    conn = sqlite3.connect(db)
    cursor = conn.cursor()

    sql = f"SELECT * FROM {table}"
    yf_logger.debug(sql)
    rows = cursor.execute(sql).fetchall()

    if rows:
        [print(row) for row in rows]
        print(tuple(desc[0] for desc in cursor.description))

    conn.close()


if __name__ == "__main__":
    yf_logger = logging.getLogger("yfinance")
    setup_logging()

    conn = sqlite3.connect("test.db")
    conn.execute("PRAGMA foreign_keys = ON;")
    cursor = conn.cursor()

    sql = """
    CREATE TABLE IF NOT EXISTS metadata(
        id TEXT PRIMARY KEY,
        created_at TEXT,
        updated_at TEXT,
        deleted_at TEXT,
        currency TEXT,
        exchange TEXT,
        quoteType TEXT,
        symbol UNIQUE,
        shortName UNIQUE,
        longName UNIQUE,
        financialCurrency TEXT
    );
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    sql = """
    CREATE TABLE IF NOT EXISTS market_info(
        id TEXT PRIMARY KEY,
        metadata_id INTEGER,
        created_at TEXT,
        updated_at TEXT,
        deleted_at TEXT,
        regularMarketPreviousClose REAL,
        regularMarketOpen REAL,
        regularMarketDayLow REAL,
        regularMarketDayHigh REAL,
        regularMarketVolume REAL,
        averageVolume INTEGER,
        averageVolume10days INTEGER,
        averageDailyVolume10Day INTEGER,
        bid REAL,
        ask REAL,
        bidSize INTEGER,
        askSize INTEGER,
        marketCap INTEGER,
        fiftyTwoWeekLow REAL,
        fiftyTwoWeekHigh REAL,
        fiftyDayAverage REAL,
        twoHundredDayAverage REAL,
        sharesOutstanding INTEGER,
        bookValue REAL,
        priceToBook REAL,
        foreign key(metadata_id) references metadata(id)
    );
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    sql = """
    CREATE INDEX IF NOT EXISTS idx_market_info_created_at
        ON market_info(created_at);
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    sql = """
    CREATE TABLE IF NOT EXISTS expirations(
        id TEXT PRIMARY KEY,
        created_at TEXT,
        expiration_date TEXT UNIQUE
    );
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    sql = """
    CREATE TABLE IF NOT EXISTS options_info(
        id TEXT PRIMARY KEY,
        option_type TEXT NOT NULL CHECK (option_type IN ('call', 'put')),
        expiration_id INTEGER,
        metadata_id INTEGER,
        market_info_id INTEGER,
        contractSymbol TEXT,
        lastTradeDate TEXT,
        strike INTEGER,
        lastPrice INTEGER,
        bid INTEGER,
        ask INTEGER,
        change INTEGER,
        percentChange INTEGER,
        volume INTEGER,
        openInterest INTEGER,
        impliedVolatility INTEGER,
        inTheMoney INTEGER,
        contractSize TEXT,
        currency TEXT,
        foreign key(expiration_id) references expirations(id),
        foreign key(metadata_id) references metadata(id),
        foreign key(market_info_id) references market_info(id)
    );
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    sql = """
    CREATE TABLE IF NOT EXISTS positions(
        id TEXT PRIMARY KEY,
        created_at TEXT,
        option_id TEXT,
        market_info_id TEXT,
        metadata_id TEXT,
        user_id TEXT,
        expiration_id TEXT UNIQUE,
        active BOOLEAN
    );
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    sql = """
    CREATE TABLE IF NOT EXISTS whoami(
        id TEXT PRIMARY KEY,
        username TEXT
    );
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    conn.close()

    cp(table_name="metadata", db_source="db.db", db_target="test.db")
    cp(table_name="market_info", db_source="db.db", db_target="test.db")
    cp(table_name="expirations", db_source="db.db", db_target="test.db")
    cp(table_name="options_info", db_source="db.db", db_target="test.db")

    select(table="metadata", db="test.db")
    select(table="market_info", db="test.db")
    select(table="expirations", db="test.db")
    select(table="options_info", db="test.db")

    conn = sqlite3.connect("test.db")
    cursor = conn.cursor()
    sql = "insert into whoami values(1, 'test-user');"
    rows = cursor.execute(sql)
    conn.close()
    select(table="whoami", db="test.db")
