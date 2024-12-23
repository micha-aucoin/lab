import argparse
import codecs
import gzip
import json
import pickle
import re
import sqlite3
import sys
import textwrap
from datetime import datetime

import pandas as pd
import yfinance as yf


def connect_db(db_name):
    """Connect to the SQLite database or create it if it doesn't exist."""
    try:
        conn = sqlite3.connect(db_name)
        conn.execute("PRAGMA foreign_keys = ON;")
        return conn
    except sqlite3.Error as e:
        print(f"Error connecting to database: {e}")
        sys.exit(1)


def run_sql_script(conn, sql_script):
    with open(sql_script, "r") as file:
        sql_file = file.read()
    try:
        conn.executescript(sql_file)
    except sqlite3.Error as e:
        print(f"Error executing script:\n{sql_file}")
        print()
        print(f"Error executing query: {e}")
        conn.rollback()


def insert_data(conn, table, data):
    """Insert Into Table function that takes a dictionary, key:value column:value, and returns the last row id"""
    cursor = conn.cursor()
    columns = ", ".join(f"`{col}`" for col in data.keys())
    placeholders = ", ".join("?" * len(data))
    values = tuple(data.values())

    insert_statement = (
        f"INSERT OR IGNORE INTO {table} ({columns}) VALUES ({placeholders})"
    )
    insert_statement_id = f"SELECT id FROM {table} ORDER BY created_at DESC LIMIT 1"

    print()
    print(f"cursor.execute({insert_statement}, {values})")
    print(f"cursor.execute({insert_statement_id})")
    print()
    try:
        cursor.execute(insert_statement, values)
        return cursor.execute(insert_statement_id).fetchone()[0]
    except sqlite3.Error as e:
        print(f"SQL Error: {e}")
        conn.rollback()


def encode_object(data: object) -> str:
    """Serialize a Python object, compress it using gzip, and encode it in Base64."""
    my_pickle = pickle.dumps(data)
    my_zipper = gzip.compress(my_pickle, compresslevel=9)
    my_encoder = codecs.encode(my_zipper, "base64").decode()
    return my_encoder


def decode_object(data: str) -> object:
    """Decode a Base64-encoded string, decompress it using gzip, and deserialize it from a pickle."""
    decoder = codecs.decode(data.encode(), "base64")
    unzipper = gzip.decompress(decoder)
    depickle = pickle.loads(unzipper)
    return depickle


# fmt: off
def get_options(conn, option, expiration_date, symbol):
    cursor = conn.cursor()
    query = f"SELECT {option} FROM options WHERE expiration_id = (SELECT id FROM expirations WHERE date = ?) AND underline_info_id = (SELECT id FROM underline_info WHERE symbol = ?)"
    print()
    print(f'cursor.execute({query}, ({expiration_date}, {symbol}))')
    print()
    try:
        cursor.execute(query, (expiration_date, symbol))
        return decode_object(cursor.fetchone()[0])
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()
# fmt: on


def get_expiration_dates(conn):
    cursor = conn.cursor()
    query = "SELECT date FROM expirations"
    try:
        print(f"cursor.execute({query})")
        cursor.execute(query)
        rows = cursor.fetchall()
        for row in rows:
            print(row[0])
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()


def main():
    parser = argparse.ArgumentParser(
        prog="yf",
        formatter_class=argparse.RawTextHelpFormatter,
        description="insert yahoo finance data into sqlite3 and query results",
        epilog=textwrap.dedent(
            """\
            Example usage:
            --------------
                python yf.py :memory: --pull_from_yahoo msft
            """
        ),
    )
    # fmt: off
    parser.add_argument("db", help="SQLite database file or :memory:")
    parser.add_argument("--get_calls", nargs=2, metavar=("EXPIRATION_DATE", "TICKER"), help="Returns calls for a stock and expiration date (format: YYYY-MM-DD)")
    parser.add_argument("--get_puts", nargs=2, metavar=("EXPIRATION_DATE", "TICKER"), help="Returns puts for a stock and expiration date (format: YYYY-MM-DD)")
    parser.add_argument("--get_expirations", action='store_true', help="Returns all expiration date (format: YYYY-MM-DD)")
    parser.add_argument("--pull_from_yahoo", nargs=1, metavar=("TICKER"), help="pull data from yahoo finance and insert into db")
    # fmt: on

    args = parser.parse_args()

    conn = connect_db(args.db)

    run_sql_script(conn, "create_tables.sql")

    # ===============================================================================
    if args.get_expirations:
        get_expiration_dates(conn)

    # ===============================================================================
    if args.get_calls:
        expiration_data, ticker = args.get_calls
        calls = get_options(
            conn=conn,
            option="calls",
            expiration_date=expiration_data,
            symbol=ticker.upper(),
        )
        print(calls)

    # ===============================================================================
    if args.get_puts:
        expiration_data, ticker = args.get_calls
        puts = get_options(
            conn=conn,
            option="puts",
            expiration_date=expiration_data,
            symbol=ticker.upper(),
        )
        print(puts)

    # ===============================================================================
    # fmt: off
    UNDERLINE_INFO_FIELDS = [ "currency", "exchange", "quoteType", "symbol", "underlyingSymbol", "shortName", "longName", "timeZoneFullName", "timeZoneShortName", "financialCurrency" ]
    UNDERLINE_INDICATORS_FIELDS = [ "regularMarketPreviousClose", "regularMarketOpen", "regularMarketDayLow", "regularMarketDayHigh", "dividendRate", "beta", "regularMarketVolume", "averageVolume", "averageVolume10days", "averageDailyVolume10Day", "bid", "ask", "bidSize", "askSize", "marketCap", "fiftyTwoWeekLow", "fiftyTwoWeekHigh", "fiftyDayAverage", "twoHundredDayAverage", "sharesOutstanding", "sharesShort", "sharesShortPriorMonth", "sharesShortPreviousMonthDate", "heldPercentInsiders", "heldPercentInstitutions", "shortRatio", "bookValue", "priceToBook", "enterpriseToRevenue", "enterpriseToEbitda", "52WeekChange", "SandP52WeekChange", "lastDividendValue", "lastDividendDate", "currentPrice", "targetHighPrice", "targetLowPrice", "targetMeanPrice", "targetMedianPrice", "recommendationMean", "recommendationKey", "numberOfAnalystOpinions", "totalCashPerShare", "quickRatio", "currentRatio", "debtToEquity", "revenuePerShare", "returnOnAssets", "returnOnEquity", "trailingPegRatio" ]
    # fmt: on
    if args.pull_from_yahoo:
        symbol = args.pull_from_yahoo[0].upper()
        yf_info = yf.Ticker(symbol).info
        yf_options = yf.Ticker(symbol).options
        yf_option_chain = yf.Ticker(symbol).option_chain

        underline_info_data = dict(
            filter(
                lambda data: data[0] in UNDERLINE_INFO_FIELDS,
                yf_info.items(),
            )
        )
        underline_info_data["created_at"] = datetime.now()

        underline_info_id = insert_data(
            conn=conn,
            table="underline_info",
            data=underline_info_data,
        )

        underline_indicators_data = dict(
            filter(
                lambda data: data[0] in UNDERLINE_INDICATORS_FIELDS,
                yf_info.items(),
            )
        )
        underline_indicators_data["underline_info_id"] = underline_info_id
        underline_indicators_data["created_at"] = datetime.now()

        underline_indicators_id = insert_data(
            conn=conn,
            table="underline_indicators",
            data=underline_indicators_data,
        )

        for expiration in yf_options:

            expiration_data = {
                "created_at": datetime.now(),
                "date": expiration,
            }
            expiration_id = insert_data(
                conn=conn,
                table="expirations",
                data=expiration_data,
            )

            call_data = encode_object(
                yf_option_chain(expiration).calls,
            )
            put_data = encode_object(
                yf_option_chain(expiration).puts,
            )

            options_data = {
                "created_at": datetime.now(),
                "expiration_id": expiration_id,
                "underline_indicators_id": underline_indicators_id,
                "underline_info_id": underline_info_id,
                "calls": call_data,
                "puts": put_data,
            }

            insert_data(
                conn=conn,
                table="options",
                data=options_data,
            )

        conn.commit()
        conn.close()


# ===============================================================================

if __name__ == "__main__":
    main()


# obj = dat.history(period="1y")
# with open("no_comp.pikle", "wb") as f:
#     pickle.dump(obj, f)
# with gzip.open("gzip_test.gz", "wb") as f:
#     pickle.dump(obj, f)

# with gzip.open("call_data.gz", "ab") as f:
#     pickle.dump(call_data, f)
# with gzip.open("put_data.gz", "ab") as f:
#     pickle.dump(put_data, f)
