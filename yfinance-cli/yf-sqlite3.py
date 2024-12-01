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
        print()
        print(f"============================= ({query}) =============================")
        try:
            cursor.execute(query)
            conn.commit()
            if query.strip().lower().startswith("select"):
                rows = cursor.fetchall()
                for row in rows:
                    print(row)
            else:
                print(f"I'm not executing this -> {query}")

        except sqlite3.Error as e:
            print(f"Error executing query: {e}")
            conn.rollback()


def check_tables_exist(conn):
    expiration_columns = """
        id integer primary key autoincrement,
        date text unique
    """
    option_columns = """
        id integer primary key autoincrement,
        expiration_id,
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
        currency,
        foreign key (expiration_id) references expiration (id)
    """
    cursor = conn.cursor()
    try:
        cursor.execute(f"CREATE TABLE IF NOT EXISTS expiration({expiration_columns})")
        cursor.execute(f"CREATE TABLE IF NOT EXISTS calls({option_columns})")
        cursor.execute(f"CREATE TABLE IF NOT EXISTS puts({option_columns})")
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()
    finally:
        cursor.close()


def two_dict(data):
    if isinstance(data, pd.DataFrame):
        for col in data.columns:
            if pd.api.types.is_datetime64_any_dtype(data[col]):
                data[col] = data[col].dt.strftime("%Y-%m-%d %H:%M:%S")
        return data.to_dict(orient="records")


def insert_options_data(conn, ticker):
    cursor = conn.cursor()
    values = """
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
    """
    columns = "\n\t".join([line.lstrip().strip(":") for line in values.splitlines()])
    try:
        dat = yf.Ticker(ticker)
        expirations = dat.options
        for expiration in expirations:
            cursor.execute("insert into expiration(date) values(?)", (expiration,))
            expiration_id = "(select id from expiration where date = ?)"

            calls = two_dict(dat.option_chain(expiration).calls)
            puts = two_dict(dat.option_chain(expiration).puts)
            cursor.executemany(f"insert into calls({columns}) values({values})", calls)
            cursor.executemany(f"insert into puts({columns}) values({values})", puts)

            cursor.execute(
                f"""
                    update calls
                    set expiration_id = {expiration_id}
                    where expiration_id is null
                """,
                (expiration,),
            )
            cursor.execute(
                f"""
                    update puts
                    set expiration_id = {expiration_id}
                    where expiration_id is null
                """,
                (expiration,),
            )

    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()
    finally:
        cursor.close()


def main():
    parser = argparse.ArgumentParser(
        prog="yf-cli",
        formatter_class=argparse.RawTextHelpFormatter,
        description="yfinance CLI Tool",
        epilog=textwrap.dedent(
            """\

Example usage:
--------------
python yf-sqlite3.py :memory: msft --options \\
    --selector "select * from expiration;" > output.txt \\
    --selector "select c.* from calls c join expiration e on c.expiration_id = e.id where e.date = '2025-01-17';" > output.txt
            """
        ),
    )
    parser.add_argument(
        "db",
        help="Create SQLite database file or use in :memory:",
    )
    parser.add_argument(
        "ticker",
        help="Query yahoo finance for this ticker",
    )
    parser.add_argument(
        "-s",
        "--selector",
        action="append",
        help="Execute custom select queries.",
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
