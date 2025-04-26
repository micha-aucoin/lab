import uuid
import json
import sqlite3
import logging.config
import pathlib
from datetime import datetime

import yfinance as yf


def setup_logging():
    config_file = pathlib.Path("logging_configs/config.json")
    with open(config_file) as f:
        config = json.load(f)
    logging.config.dictConfig(config)


def process_metadata(yf_info):
    metadata = {}

    metadata["id"] = str(uuid.uuid4())
    metadata["created_at"] = datetime.now().isoformat()
    metadata["currency"] = yf_info["currency"]
    metadata["exchange"] = yf_info["exchange"]
    metadata["quoteType"] = yf_info["quoteType"]
    metadata["symbol"] = yf_info["symbol"]
    metadata["shortName"] = yf_info["shortName"]
    metadata["longName"] = yf_info["longName"]
    metadata["financialCurrency"] = yf_info["financialCurrency"]

    return metadata


def process_market_info(yf_info, metadata_id):
    market_info = {}

    market_info["id"] = str(uuid.uuid4())
    market_info["metadata_id"] = metadata_id
    market_info["created_at"] = datetime.now().isoformat()
    market_info["regularMarketPreviousClose"] = yf_info["regularMarketPreviousClose"]
    market_info["regularMarketOpen"] = yf_info["regularMarketOpen"]
    market_info["regularMarketDayLow"] = yf_info["regularMarketDayLow"]
    market_info["regularMarketDayHigh"] = yf_info["regularMarketDayHigh"]
    market_info["regularMarketVolume"] = yf_info["regularMarketVolume"]
    market_info["averageVolume"] = yf_info["averageVolume"]
    market_info["averageVolume10days"] = yf_info["averageVolume10days"]
    market_info["averageDailyVolume10Day"] = yf_info["averageDailyVolume10Day"]
    market_info["bid"] = yf_info["bid"]
    market_info["ask"] = yf_info["ask"]
    market_info["bidSize"] = yf_info["bidSize"]
    market_info["askSize"] = yf_info["askSize"]
    market_info["marketCap"] = yf_info["marketCap"]
    market_info["fiftyTwoWeekLow"] = yf_info["fiftyTwoWeekLow"]
    market_info["fiftyTwoWeekHigh"] = yf_info["fiftyTwoWeekHigh"]
    market_info["fiftyDayAverage"] = yf_info["fiftyDayAverage"]
    market_info["twoHundredDayAverage"] = yf_info["twoHundredDayAverage"]
    market_info["sharesOutstanding"] = yf_info["sharesOutstanding"]
    market_info["bookValue"] = yf_info["bookValue"]
    market_info["priceToBook"] = yf_info["priceToBook"]

    return market_info


def process_expirations(date):
    d = datetime.strptime
    expiration_date = d(date, "%Y-%m-%d")
    expiration = {}

    expiration["id"] = str(uuid.uuid4())
    expiration["created_at"] = datetime.now().isoformat()
    expiration["expiration_date"] = expiration_date.isoformat()

    return expiration


def process_options_info(option_data, option_type, expiration_id, metadata_id, market_info_id):
    options_info = {}

    options_info["id"] = str(uuid.uuid4())
    options_info["option_type"] = option_type
    options_info["expiration_id"] = expiration_id
    options_info["metadata_id"] = metadata_id
    options_info["market_info_id"] = market_info_id
    options_info["contractSymbol"] = option_data["contractSymbol"]
    options_info["lastTradeDate"] = option_data["lastTradeDate"]
    options_info["strike"] = option_data["strike"]
    options_info["lastPrice"] = option_data["lastPrice"]
    options_info["bid"] = option_data["bid"]
    options_info["ask"] = option_data["ask"]
    options_info["change"] = option_data["change"]
    options_info["percentChange"] = option_data["percentChange"]
    options_info["volume"] = option_data["volume"]
    options_info["openInterest"] = option_data["openInterest"]
    options_info["impliedVolatility"] = option_data["impliedVolatility"]
    options_info["inTheMoney"] = option_data["inTheMoney"]
    options_info["contractSize"] = option_data["contractSize"]
    options_info["currency"] = option_data["currency"]

    return options_info


if __name__ == "__main__":

    yf_logger = logging.getLogger("yfinance")
    setup_logging()

    conn = sqlite3.connect('db.db')
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
        expiration_date TEXT unique
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
        foreign key(expiration_id) references expirations(id)
        foreign key(metadata_id) references metadata(id)
        foreign key(market_info_id) references market_info(id)
    );
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    symbol = 'SPY'
    yf_info = yf.Ticker(symbol).info
    yf_expirations = yf.Ticker(symbol).options
    yf_option_chain = yf.Ticker(symbol).option_chain

    yf_logger.info(f"=== processing {symbol} yf info ===")

    metadata = process_metadata(yf_info)
    metadata_keys = ', '.join(metadata.keys())
    metadata_placeholders = ', '.join('?' for _ in metadata)
    metadata_values = tuple(metadata.values())
    sql = f"""
    INSERT INTO metadata({metadata_keys})
        VALUES({metadata_placeholders})
    """
    yf_logger.debug(sql)
    yf_logger.debug(metadata_values)
    cursor.execute(sql, metadata_values)

    market_info = process_market_info(yf_info, metadata["id"])
    market_info_keys = ', '.join(market_info.keys())
    market_info_placeholders = ', '.join('?' for _ in market_info)
    market_info_values = tuple(market_info.values())
    sql = f"""
    INSERT INTO market_info({market_info_keys})
        VALUES({market_info_placeholders})
    """
    yf_logger.debug(sql)
    yf_logger.debug(market_info_values)
    cursor.execute(sql, market_info_values)

    for expiration in yf_expirations:
        yf_logger.info(f"====== {expiration} options =======")

        exp = process_expirations(expiration)
        exp_keys = ', '.join(exp.keys())
        exp_placeholders = ', '.join('?' for _ in exp)
        exp_values = tuple(exp.values())
        sql = f"""
        INSERT INTO expirations({exp_keys})
            VALUES({exp_placeholders})
        """
        yf_logger.debug(sql)
        yf_logger.debug(exp_values)
        cursor.execute(sql, exp_values)

        calls = json.loads(yf_option_chain(
            expiration
        ).calls.to_json(orient='records'))
        for call in calls:
            c = process_options_info(
                call, 'call', exp["id"], metadata["id"], market_info["id"]
            )
            c_keys = ', '.join(c.keys())
            c_placeholders = ', '.join('?' for _ in c)
            c_values = tuple(c.values())
            sql = f"""
            INSERT INTO options_info({c_keys})
                VALUES({c_placeholders})
            """
            yf_logger.debug(sql)
            yf_logger.debug(c_values)
            cursor.execute(sql, c_values)

        puts = json.loads(yf_option_chain(
            expiration
        ).puts.to_json(orient='records'))
        for put in puts:
            p = process_options_info(
                put, 'put', exp["id"], metadata["id"], market_info["id"]
            )
            p_keys = ', '.join(p.keys())
            p_placeholders = ', '.join('?' for _ in p)
            p_values = tuple(p.values())
            sql = f"""
            INSERT INTO options_info({p_keys})
                VALUES({p_placeholders})
            """
            yf_logger.debug(sql)
            yf_logger.debug(p_values)
            cursor.execute(sql, p_values)

    conn.commit()
    conn.close()
