import argparse
import json
import sqlite3
import sys
import textwrap

import pandas as pd
import yfinance as yf


def connect_db(db_name):
    """Connect to the SQLite database or create it if it doesn't exist."""
    try:
        conn = sqlite3.connect(db_name)
        return conn
    except sqlite3.Error as e:
        print(f"Error connecting to database: {e}")
        sys.exit(1)


def run_selector(conn, queries):
    """Run custom SQL select queries."""
    cursor = conn.cursor()
    for query in queries:
        try:
            cursor.execute(query)
            conn.commit()
            if query.strip().lower().startswith("select"):
                rows = cursor.fetchall()
                for row in rows:
                    print()
                    print(f"======== ({query}) ========")
                    print(row)
            else:
                print()
                print(f"I'm not executing this -> {query}")

        except sqlite3.Error as e:
            print(f"Error executing query: {e}")
            conn.rollback()


def check_tables_exist(conn):
    cursor = conn.cursor()
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS calls(
            contractSymbol,
            lastTradeDate,
            strike,
            lastPrice,
            bid,
            ask,
            change,
            percentChange,
            volume,
            openInterest,
            impliedVolatility,
            inTheMoney,
            contractSize,
            currency
        )
        """
    )
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS puts(
            contractSymbol,
            lastTradeDate,
            strike,
            lastPrice,
            bid,
            ask,
            change,
            percentChange,
            volume,
            openInterest,
            impliedVolatility,
            inTheMoney,
            contractSize,
            currency
        )
        """
    )


def two_dict(data):
    if isinstance(data, pd.DataFrame):
        for col in data.columns:
            if pd.api.types.is_datetime64_any_dtype(data[col]):
                data[col] = data[col].dt.strftime("%Y-%m-%d %H:%M:%S")
        return data.to_dict(orient="records")


def insert_options_data(conn, ticker):
    cursor = conn.cursor()

    dat = yf.Ticker(ticker)
    expirations = dat.options
    for expiration in expirations:
        calls = two_dict(dat.option_chain(expiration).calls)
        puts = two_dict(dat.option_chain(expiration).puts)

        cursor.executemany(
            """
            insert into calls values(
                :contractSymbol,
                :lastTradeDate,
                :strike,
                :lastPrice,
                :bid,
                :ask,
                :change,
                :percentChange,
                :volume,
                :openInterest,
                :impliedVolatility,
                :inTheMoney,
                :contractSize,
                :currency
            )
            """,
            calls,
        )
        cursor.executemany(
            """
            insert into puts values(
                :contractSymbol,
                :lastTradeDate,
                :strike,
                :lastPrice,
                :bid,
                :ask,
                :change,
                :percentChange,
                :volume,
                :openInterest,
                :impliedVolatility,
                :inTheMoney,
                :contractSize,
                :currency
            )
            """,
            puts,
        )


def main():
    parser = argparse.ArgumentParser(
        prog="yf-cli",
        formatter_class=argparse.RawTextHelpFormatter,
        description="yfinance CLI Tool",
        epilog=textwrap.dedent(
            """\

Example usage:
--------------
python yf-sqlite3.py :memory: msft\\
    --options \\
    --selector 'select * from calls;' \\
    --selector 'select * from puts;'
            """
        ),
    )
    parser.add_argument(
        "db",
        help="SQLite database file or :memory:",
    )
    parser.add_argument(
        "ticker",
        help="Query yahoo finance for ticker",
    )
    parser.add_argument(
        "-s",
        "--selector",
        action="append",
        help="Execute custom SQL select queries.",
    )
    parser.add_argument(
        "-o",
        "--options",
        action="store_true",
        help="insert options data into calls/puts tables",
    )

    args = parser.parse_args()
    conn = connect_db(args.db)
    check_tables_exist(conn)

    ticker = args.ticker.upper()

    if args.options:
        insert_options_data(conn, ticker)

    if args.selector:
        run_selector(conn, args.selector)

    print()
    conn.close()


if __name__ == "__main__":
    main()
