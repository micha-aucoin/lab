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
    metadata["currency"] = yf_info.get("currency")
    metadata["exchange"] = yf_info.get("exchange")
    metadata["quoteType"] = yf_info.get("quoteType")
    metadata["symbol"] = yf_info.get("symbol")
    metadata["shortName"] = yf_info.get("shortName")
    metadata["longName"] = yf_info.get("longName")
    metadata["financialCurrency"] = yf_info.get("financialCurrency")

    return metadata


def process_market_info(yf_info, metadata_id):
    market_info = {}

    market_info["id"] = str(uuid.uuid4())
    market_info["metadata_id"] = metadata_id
    market_info["created_at"] = datetime.now().isoformat()
    market_info["regularMarketPreviousClose"] = yf_info.get(
        "regularMarketPreviousClose")
    market_info["regularMarketOpen"] = yf_info.get("regularMarketOpen")
    market_info["regularMarketDayLow"] = yf_info.get("regularMarketDayLow")
    market_info["regularMarketDayHigh"] = yf_info.get("regularMarketDayHigh")
    market_info["regularMarketVolume"] = yf_info.get("regularMarketVolume")
    market_info["averageVolume"] = yf_info.get("averageVolume")
    market_info["averageVolume10days"] = yf_info.get("averageVolume10days")
    market_info["averageDailyVolume10Day"] = yf_info.get(
        "averageDailyVolume10Day")
    market_info["bid"] = yf_info.get("bid")
    market_info["ask"] = yf_info.get("ask")
    market_info["bidSize"] = yf_info.get("bidSize")
    market_info["askSize"] = yf_info.get("askSize")
    market_info["marketCap"] = yf_info.get("marketCap")
    market_info["fiftyTwoWeekLow"] = yf_info.get("fiftyTwoWeekLow")
    market_info["fiftyTwoWeekHigh"] = yf_info.get("fiftyTwoWeekHigh")
    market_info["fiftyDayAverage"] = yf_info.get("fiftyDayAverage")
    market_info["twoHundredDayAverage"] = yf_info.get("twoHundredDayAverage")
    market_info["sharesOutstanding"] = yf_info.get("sharesOutstanding")
    market_info["bookValue"] = yf_info.get("bookValue")
    market_info["priceToBook"] = yf_info.get("priceToBook")

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
    options_info["contractSymbol"] = option_data.get("contractSymbol")
    options_info["lastTradeDate"] = option_data.get("lastTradeDate")
    options_info["strike"] = option_data.get("strike")
    options_info["lastPrice"] = option_data.get("lastPrice")
    options_info["bid"] = option_data.get("bid")
    options_info["ask"] = option_data.get("ask")
    options_info["change"] = option_data.get("change")
    options_info["percentChange"] = option_data.get("percentChange")
    options_info["volume"] = option_data.get("volume")
    options_info["openInterest"] = option_data.get("openInterest")
    options_info["impliedVolatility"] = option_data.get("impliedVolatility")
    options_info["inTheMoney"] = option_data.get("inTheMoney")
    options_info["contractSize"] = option_data.get("contractSize")
    options_info["currency"] = option_data.get("currency")

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
        foreign key(expiration_id) references expirations(id)
        foreign key(metadata_id) references metadata(id)
        foreign key(market_info_id) references market_info(id)
    );
    """
    yf_logger.debug(sql)
    cursor.execute(sql)

    symbols = ['SPY', 'GLD', 'TLT', 'UNG', 'XLV',
               'VNQ', 'DBA', 'UUP', 'FXY', 'MSTR', 'XLE']
    for symbol in symbols:
        yf_info = yf.Ticker(symbol).info
        yf_expirations = yf.Ticker(symbol).options
        yf_option_chain = yf.Ticker(symbol).option_chain

        yf_logger.info(f"=== processing {symbol} yf info ===")

        metadata = process_metadata(yf_info)
        metadata_keys = ', '.join(metadata.keys())
        metadata_placeholders = ', '.join('?' for _ in metadata)
        metadata_values = tuple(metadata.values())
        sql = """
        SELECT id FROM metadata
            WHERE symbol = ?
        """
        metadata_id = cursor.execute(sql, (metadata["symbol"],)).fetchone()[0]
        # DEBUG
        # print(f'metadata_id: {metadata_id}')
        if metadata_id:
            metadata["id"] = metadata_id
            print(f'metadata_id: {metadata_id}')
        sql = f"""
        INSERT OR IGNORE INTO metadata({metadata_keys})
            VALUES({metadata_placeholders})
        """
        yf_logger.debug(sql)
        yf_logger.debug(metadata_values)
        cursor.execute(sql, metadata_values)
        conn.commit()

        market_info = process_market_info(yf_info, metadata["id"])
        market_info_keys = ', '.join(market_info.keys())
        market_info_placeholders = ', '.join('?' for _ in market_info)
        market_info_values = tuple(market_info.values())
        sql = f"""
        INSERT OR IGNORE INTO market_info({market_info_keys})
            VALUES({market_info_placeholders})
        """
        yf_logger.debug(sql)
        yf_logger.debug(market_info_values)
        cursor.execute(sql, market_info_values)
        conn.commit()

        for expiration in yf_expirations:
            yf_logger.info(f"====== {expiration} options =======")

            exp = process_expirations(expiration)
            exp_keys = ', '.join(exp.keys())
            exp_placeholders = ', '.join('?' for _ in exp)
            exp_values = tuple(exp.values())
            sql = """
            SELECT id FROM expirations
                WHERE date(expiration_date) = ?
            """
            exp_id = cursor.execute(sql, (expiration,)).fetchone()[0]
            # DEBUG
            # print(f'exp_id: {exp_id}')
            if exp_id:
                exp["id"] = exp_id
                print(f'exp_id: {exp_id}')
            sql = f"""
            INSERT OR IGNORE INTO expirations({exp_keys})
                VALUES({exp_placeholders})
            """
            yf_logger.debug(sql)
            yf_logger.debug(exp_values)
            cursor.execute(sql, exp_values)
            conn.commit()

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
                INSERT OR IGNORE INTO options_info({c_keys})
                    VALUES({c_placeholders})
                """
                yf_logger.debug(sql)
                yf_logger.debug(c_values)
                cursor.execute(sql, c_values)
                conn.commit()

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
                INSERT OR IGNORE INTO options_info({p_keys})
                    VALUES({p_placeholders})
                """
                yf_logger.debug(sql)
                yf_logger.debug(p_values)
                cursor.execute(sql, p_values)
                conn.commit()

    conn.close()
