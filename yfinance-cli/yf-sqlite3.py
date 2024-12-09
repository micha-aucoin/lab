import argparse
import json
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


def run_selector(conn, queries):
    """Run custom SQL select queries."""
    cursor = conn.cursor()
    for query in queries:
        print()
        print(f"============================= ({query}) =============================")
        try:
            cursor.execute(query)
            if query.strip().lower().startswith("select"):
                rows = cursor.fetchall()
                for row in rows:
                    print(row)
            else:
                print(f"I'm not executing this -> {query}")

        except sqlite3.Error as e:
            print(f"Error executing query: {e}")
            conn.rollback()


def run_sql_script(cursor, sql_script):
    with open(sql_script, "r") as file:
        sql_file = file.read()
    try:
        cursor.executescript(sql_file)
    except sqlite3.Error as e:
        print(f"Error executing script:\n{sql_file}")
        print()
        print(f"Error executing query: {e}")
        conn.rollback()


def create_sql_insert(table, columns, params=None):
    if params is not None:
        return f"INSERT INTO {table}({columns}) VALUES({params})"
    return f"INSERT INTO {table}({columns}) VALUES(?)"


def create_sql_update_fk(table, foreign_table, conditional):
    return f"""UPDATE {table}
               SET {foreign_table}_id = (
                   SELECT ID FROM {foreign_table} 
                   WHERE {conditional} = ?
               )
               WHERE {foreign_table}_id IS NULL
            """


def insert_underline_indicator_data(conn, dat, columns, params):
    cursor = conn.cursor()
    info = dat.info
    info["date"] = datetime.now()

    insert_sql = create_sql_insert("underline_indicator", columns, params)

    update_foreign_key = create_sql_update_fk(
        table="underline_indicator",
        foreign_table="underline_discriptor",
        conditional="symbol",
    )

    try:
        cursor.execute(insert_sql, info)
        cursor.execute(update_foreign_key, (info["symbol"],))
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()


def insert_underline_discriptor_data(conn, dat, columns, params):
    cursor = conn.cursor()
    info = dat.info
    insert_sql = create_sql_insert("underline_discriptor", columns, params)

    try:
        cursor.execute(insert_sql, info)
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()


def insert_expiration_data(conn, dat, columns):
    cursor = conn.cursor()
    insert_sql = create_sql_insert("expiration", columns)

    for expiration in dat.options:
        try:
            cursor.execute(insert_sql, (expiration,))
        except sqlite3.Error as e:
            print(f"Error executing query: {e}")
            conn.rollback()


def dataframe_to_dict(data):
    if isinstance(data, pd.DataFrame):
        is_datetime_col = filter(
            lambda x: pd.api.types.is_datetime64_any_dtype(data[x]),
            data.columns,
        )
        for col in is_datetime_col:
            data[col] = data[col].dt.strftime("%Y-%m-%d %H:%M:%S")
        return data.to_dict(orient="records")


def insert_options_data(conn, dat, columns, params):
    cursor = conn.cursor()

    cursor.execute("select date from expiration;")
    for (expiration,) in cursor.fetchall():

        calls = dataframe_to_dict(dat.option_chain(expiration).calls)
        puts = dataframe_to_dict(dat.option_chain(expiration).puts)

        try:
            cursor.executemany(create_sql_insert("calls", columns, params), calls)
            cursor.executemany(create_sql_insert("puts", columns, params), puts)
            cursor.execute(
                create_sql_update_fk(
                    table="calls",
                    foreign_table="expiration",
                    conditional="date",
                ),
                (expiration,),
            )
            cursor.execute(
                create_sql_update_fk(
                    table="puts",
                    foreign_table="expiration",
                    conditional="date",
                ),
                (expiration,),
            )
        except sqlite3.Error as e:
            print(f"Error executing query: {e}")
            conn.rollback()


def list_columns(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = [table[0] for table in cursor.fetchall()]
    all_columns = {}
    for table in tables:
        if not table == "sqlite_sequence":
            cursor.execute(f"PRAGMA table_info({table});")
            columns = [col[1] for col in cursor.fetchall()]
            all_columns[table] = columns
    return all_columns


def main():
    parser = argparse.ArgumentParser(
        prog="yf-cli",
        formatter_class=argparse.RawTextHelpFormatter,
        description="yfinance CLI Tool",
        epilog=textwrap.dedent(
            """\

Example usage:
--------------
python yf-sqlite3.py :memory: msft --options --underline \\
    --selector "select * from underline_discriptor;" \\
    --selector "select * from underline_indicator;" \\
    --selector "select * from expiration;" \\
    --selector "select c.* from calls c join expiration e on c.expiration_id = e.id where e.date = '2025-01-17';" > msft_output.txt

python yf-sqlite3.py :memory: nvda --options --underline \\
    --selector "select * from underline_discriptor;" \\
    --selector "select * from underline_indicator;" \\
    --selector "select * from expiration;" \\
    --selector "select c.* from calls c join expiration e on c.expiration_id = e.id where e.date = '2025-01-17';" > nvda_output.txt
            """
        ),
    )
    # fmt: off
    parser.add_argument("db", help="Create SQLite database file or use in :memory:")
    parser.add_argument("ticker", help="Query yahoo finance for this ticker")
    parser.add_argument("-s", "--selector", action="append", help="Execute custom select queries.")
    parser.add_argument("-o", "--options", action="store_true", help="insert options data into calls/puts tables")
    parser.add_argument("-u", "--underline", action="store_true", help="insert unerline security data into a table")
    # fmt: on

    args = parser.parse_args()

    conn = connect_db(args.db)

    dat = yf.Ticker(args.ticker.upper())

    run_sql_script(conn, "create_table.sql")
    for key, columns in list_columns(conn).items():
        filtered_columns = filter(
            lambda x: not re.match(".*id.*", x),
            columns,
        )
        filtered_columns = list(filtered_columns)
        params = map(
            lambda x: f":{x}",
            filtered_columns,
        )
        columns = map(
            lambda x: f'"{x}"' if x[0].isdigit() else x,
            filtered_columns,
        )
        columns = ", ".join(columns)
        params = ", ".join(params)

        # fmt: off
        print(f"============================= {key} TABLE =============================")
        print(f"columns => {columns}")
        print(f"params => {params}")
        print()
        # fmt: on

        if args.options:
            if key == "expiration":
                insert_expiration_data(conn, dat, columns)
            if key == "calls":
                insert_options_data(conn, dat, columns, params)

        if args.underline:
            if key == "underline_discriptor":
                insert_underline_discriptor_data(conn, dat, columns, params)
            if key == "underline_indicator":
                insert_underline_indicator_data(conn, dat, columns, params)

        conn.commit()

    if args.selector:
        run_selector(conn, args.selector)

    conn.close()


if __name__ == "__main__":
    main()
