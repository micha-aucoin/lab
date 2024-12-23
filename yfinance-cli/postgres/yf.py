import argparse
import codecs
import gzip
import os
import pickle
import sys
import textwrap
from datetime import datetime

import pandas as pd
import psycopg2
import yfinance as yf
from psycopg2 import DatabaseError, InterfaceError, OperationalError

from config import config


def connect_db():
    try:
        conn = psycopg2.connect(
            host=config.postgresql.host,
            database=config.postgresql.database,
            user=config.postgresql.user,
            password=config.postgresql.password,
        )
        return conn
    except OperationalError as e:
        print(f"Operational error: {e}")
        sys.exit(1)
    except InterfaceError as e:
        print(f"Interface error: {e}")
        sys.exit(1)
    except psycopg2.Error as e:
        print(f"An error occurred: {e}")
        sys.exit(1)


def run_sql_script(conn, sql_script):
    with open(sql_script, "r") as file:
        sql_file = file.read()
    try:
        with conn.cursor() as cursor:
            cursor.execute(sql_file)
            conn.commit()
    except (psycopg2.Error, DatabaseError) as e:
        print(f"Error executing script:{os.path.abspath(sql_file)}")
        print()
        print(f"Error executing query: {e}")
        conn.rollback()


def insert_data(conn, table, data):
    """
    Insert Into Table function that takes a dictionary,
    key:value column:value, and returns the last row id
    """

    columns = ", ".join(
        f'"{col}"' if col[0].isdigit() else f"{col}" for col in data.keys()
    )
    placeholders = ", ".join(["%s"] * len(data))
    values = tuple(data.values())

    insert_statement = f"""
        INSERT INTO {table} ({columns}) 
        VALUES ({placeholders})
        ON CONFLICT (id) DO NOTHING
    """
    insert_statement_id = f"""
        SELECT id FROM {table} 
        ORDER BY created_at DESC LIMIT 1
    """

    print()
    print(f"cursor.execute({insert_statement}, {values})")
    print(f"cursor.execute({insert_statement_id})")
    print()

    try:
        with conn.cursor() as cursor:
            cursor.execute(insert_statement, values)
            conn.commit()
            cursor.execute(insert_statement_id)
            return cursor.fetchone()[0]
    except psycopg2.Error as e:
        print(f"SQL Error: {e}")
        conn.rollback()


def get_options(conn, option, expiration_date, symbol):
    select_statement = f"""
        SELECT {option} FROM options 
        WHERE expiration_id = (SELECT id FROM expirations WHERE date = ?) 
        AND underline_info_id = (SELECT id FROM underline_info WHERE symbol = ?)
    """
    print()
    print(f"cursor.execute({query}, ({expiration_date}, {symbol}))")
    print()
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, (expiration_date, symbol))
            return decode_object(cursor.fetchone()[0])
    except psycopg2.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()


def get_expiration_dates(conn):
    cursor = conn.cursor()
    expirations = "SELECT date FROM expirations"
    print(f"cursor.execute({expirations})")
    try:
        with conn.cursor() as cursor:
            cursor.execute(expirations)
            for row in cursor.fetchall():
                print(row[0])
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()


def encode_object(data: object) -> str:
    """
    Serialize a Python object,
    compress it using gzip,
    and encode it to Base64.
    """
    my_pickle = pickle.dumps(data)
    my_zipper = gzip.compress(my_pickle, compresslevel=9)
    my_encoder = codecs.encode(my_zipper, "base64").decode()
    return my_encoder


def decode_object(data: str) -> object:
    """
    Decode a Base64-encoded string,
    decompress it using gzip,
    and deserialize it from a pickle.
    """
    decoder = codecs.decode(data.encode(), "base64")
    unzipper = gzip.decompress(decoder)
    depickle = pickle.loads(unzipper)
    return depickle


def main():
    parser = argparse.ArgumentParser(
        prog="yf",
        formatter_class=argparse.RawTextHelpFormatter,
        description="insert yahoo finance data into sqlite3 and query results",
        epilog=textwrap.dedent(
            """\
            Example usage:
            --------------
                python yf.py --pull_from_yahoo msft
            """
        ),
    )
    # fmt: off
    parser.add_argument("--get_calls", nargs=2, metavar=("EXPIRATION_DATE", "TICKER"), help="Returns calls for a stock and expiration date (format: YYYY-MM-DD)")
    parser.add_argument("--get_puts", nargs=2, metavar=("EXPIRATION_DATE", "TICKER"), help="Returns puts for a stock and expiration date (format: YYYY-MM-DD)")
    parser.add_argument("--get_expirations", action='store_true', help="Returns all expiration date (format: YYYY-MM-DD)")
    parser.add_argument("--pull_from_yahoo", nargs=1, metavar=("TICKER"), help="pull data from yahoo finance and insert into db")

    args = parser.parse_args()

    conn = connect_db()

    run_sql_script(conn, "create_tables.sql")

    # ===============================================================================
    if args.get_expirations:
        get_expiration_dates(conn)

    # ===============================================================================
    if args.get_calls:
        expiration_data, ticker = args.get_calls
        calls = get_options(conn=conn, option="calls", expiration_date=expiration_data, symbol=ticker.upper())
        print(calls)

    # ===============================================================================
    if args.get_puts:
        expiration_data, ticker = args.get_calls
        puts = get_options(conn=conn, option="puts", expiration_date=expiration_data, symbol=ticker.upper())
        print(puts)

    # ===============================================================================
    UNDERLINE_INFO_FIELDS = [ "currency", "exchange", "quoteType", "symbol", "underlyingSymbol", "shortName", "longName", "timeZoneFullName", "timeZoneShortName", "financialCurrency" ]
    UNDERLINE_INDICATORS_FIELDS = [ "regularMarketPreviousClose", "regularMarketOpen", "regularMarketDayLow", "regularMarketDayHigh", "dividendRate", "beta", "regularMarketVolume", "averageVolume", "averageVolume10days", "averageDailyVolume10Day", "bid", "ask", "bidSize", "askSize", "marketCap", "fiftyTwoWeekLow", "fiftyTwoWeekHigh", "fiftyDayAverage", "twoHundredDayAverage", "sharesOutstanding", "sharesShort", "sharesShortPriorMonth", "sharesShortPreviousMonthDate", "heldPercentInsiders", "heldPercentInstitutions", "shortRatio", "bookValue", "priceToBook", "enterpriseToRevenue", "enterpriseToEbitda", "52WeekChange", "SandP52WeekChange", "lastDividendValue", "lastDividendDate", "currentPrice", "targetHighPrice", "targetLowPrice", "targetMeanPrice", "targetMedianPrice", "recommendationMean", "recommendationKey", "numberOfAnalystOpinions", "totalCashPerShare", "quickRatio", "currentRatio", "debtToEquity", "revenuePerShare", "returnOnAssets", "returnOnEquity", "trailingPegRatio" ]

    if args.pull_from_yahoo:
        symbol = args.pull_from_yahoo[0].upper()
        yf_info = yf.Ticker(symbol).info
        yf_options = yf.Ticker(symbol).options
        yf_option_chain = yf.Ticker(symbol).option_chain

        underline_info_data = dict(filter(lambda data: data[0] in UNDERLINE_INFO_FIELDS, yf_info.items()))
        underline_info_data["created_at"] = datetime.now()
        underline_info_id = insert_data(conn=conn, table="underline_info", data=underline_info_data)

        underline_indicators_data = dict(filter(lambda data: data[0] in UNDERLINE_INDICATORS_FIELDS, yf_info.items()))
        underline_indicators_data["underline_info_id"] = underline_info_id
        underline_indicators_data["created_at"] = datetime.now()
        underline_indicators_data["lastDividendDate"] = datetime.fromtimestamp(underline_indicators_data["lastDividendDate"])
        underline_indicators_id = insert_data(conn=conn, table="underline_indicators", data=underline_indicators_data)

        for expiration in yf_options:
            expiration_data = {"created_at": datetime.now(), "date": expiration}
            expiration_id = insert_data(conn=conn, table="expirations", data=expiration_data)

            call_data = encode_object(yf_option_chain(expiration).calls)
            put_data = encode_object(yf_option_chain(expiration).puts)

            options_data = {
                "created_at": datetime.now(),
                "expiration_id": expiration_id,
                "underline_indicators_id": underline_indicators_id,
                "underline_info_id": underline_info_id,
                "calls": call_data,
                "puts": put_data,
            }
            insert_data(conn=conn, table="options", data=options_data)

        conn.close()
    # fmt: on


# ===============================================================================

if __name__ == "__main__":
    main()
