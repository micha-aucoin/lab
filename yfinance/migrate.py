import json
import logging.config
import pathlib
import sqlite3


def setup_logging():
    config_file = pathlib.Path("logging_configs/config.json")
    with open(config_file) as f:
        config = json.load(f)
    logging.config.dictConfig(config)


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
        stock_id TEXT,
        user_id TEXT,
        expiration_date TEXT UNIQUE
    );
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    sql = """
    CREATE TABLE IF NOT EXISTS user(
        id TEXT PRIMARY KEY,
        username TEXT
    );
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    conn.close()

    db_conn = sqlite3.connect("db.db")
    test_conn = sqlite3.connect("test.db")
    db_cursor = db_conn.cursor()
    test_cursor = test_conn.cursor()

    sql = "SELECT * FROM metadata"
    yf_logger.debug(sql)
    rows = db_cursor.execute(sql).fetchall()
    if rows:
        col_names = ", ".join(desc[0] for desc in db_cursor.description)
        placeholders = ", ".join("?" for _ in db_cursor.description)
        for row in rows:
            sql = f"""
            INSERT OR IGNORE INTO metadata({col_names})
                VALUES({placeholders})
            """
            yf_logger.debug(sql)
            yf_logger.debug(row)
            test_cursor.execute(sql, row)
            test_conn.commit()

    db_conn.close()
    test_conn.close()
