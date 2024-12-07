import argparse
import json
import sqlite3
import sys
import textwrap
from datetime import datetime

import pandas as pd
import yfinance as yf

data = {
    "expiration": """
       :date
    """,
    "options": """
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
    """,
    "underline_discriptor": """
        :currency,
        :exchange,
        :quoteType,
        :symbol,
        :underlyingSymbol,
        :shortName,
        :longName,
        :timeZoneFullName,
        :timeZoneShortName,
        :financialCurrency
    """,
    "underline_indicator": """
        :date,
        :regularMarketPreviousClose,
        :regularMarketOpen,
        :regularMarketDayLow,
        :regularMarketDayHigh,
        :dividendRate,
        :beta,
        :regularMarketVolume,
        :averageVolume,
        :averageVolume10days,
        :averageDailyVolume10Day,
        :bid,
        :ask,
        :bidSize,
        :askSize,
        :marketCap,
        :fiftyTwoWeekLow,
        :fiftyTwoWeekHigh,
        :fiftyDayAverage,
        :twoHundredDayAverage,
        :sharesOutstanding,
        :sharesShort,
        :sharesShortPriorMonth,
        :sharesShortPreviousMonthDate,
        :heldPercentInsiders,
        :heldPercentInstitutions,
        :shortRatio,
        :bookValue,
        :priceToBook,
        :enterpriseToRevenue,
        :enterpriseToEbitda,
        :"52WeekChange",
        :SandP52WeekChange,
        :lastDividendValue,
        :lastDividendDate,
        :currentPrice,
        :targetHighPrice,
        :targetLowPrice,
        :targetMeanPrice,
        :targetMedianPrice,
        :recommendationMean,
        :recommendationKey,
        :numberOfAnalystOpinions,
        :totalCashPerShare,
        :quickRatio,
        :currentRatio,
        :debtToEquity,
        :revenuePerShare,
        :returnOnAssets,
        :returnOnEquity,
        :trailingPegRatio
    """,
}


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
            if query.strip().lower().startswith("select"):
                rows = cursor.fetchall()
                for row in rows:
                    print(row)
            else:
                print(f"I'm not executing this -> {query}")

        except sqlite3.Error as e:
            print(f"Error executing query: {e}")
            conn.rollback()


def run_sql_script(conn, sql_script):
    cursor = conn.cursor()
    with open(sql_script, "r") as file:
        sql_file = file.read()
    try:
        cursor.executescript(sql_file)
    except sqlite3.Error as e:
        print(f"Error executing script:\n{sql_file}")
        print()
        print(f"Error executing query: {e}")
        conn.rollback()


def insert_underline_indicator_data(conn, ticker, columns, values):
    cursor = conn.cursor()
    info = yf.Ticker(ticker).info
    info["date"] = datetime.now()
    underline_discriptor_id = "(select id from underline_discriptor where symbol = ?)"

    try:
        # fmt: off
        cursor.execute(f"insert into underline_indicator({columns}) values({values})", info)
        cursor.execute(f"""update underline_indicator 
                           set underline_discriptor_id = {underline_discriptor_id} 
                           where underline_discriptor_id is NULL
                        """, 
                       (info["symbol"],))
        # fmt: on
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()


def insert_underline_discriptor_data(conn, ticker, columns, values):
    cursor = conn.cursor()
    dat = yf.Ticker(ticker)
    info = dat.info
    # fmt: off
    try:
        cursor.execute(f"insert into underline_discriptor({columns}) values({values})", info)
        conn.commit()
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()
    # fmt: on


def insert_expiration_data(conn, ticker, columns):
    cursor = conn.cursor()
    dat = yf.Ticker(ticker)
    expirations = dat.options
    for expiration in expirations:
        # fmt: off
        try:
            cursor.execute(f"insert into expiration({columns}) values(?)", (expiration,))
        except sqlite3.Error as e:
            print(f"Error executing query: {e}")
            conn.rollback()
        # fmt: on


def two_dict(data):
    if isinstance(data, pd.DataFrame):
        for col in data.columns:
            if pd.api.types.is_datetime64_any_dtype(data[col]):
                data[col] = data[col].dt.strftime("%Y-%m-%d %H:%M:%S")
        return data.to_dict(orient="records")


def insert_options_data(conn, ticker, columns, values):
    cursor = conn.cursor()
    dat = yf.Ticker(ticker)
    expiration_id = "(select id from expiration where date = ?)"
    try:
        cursor.execute("select date from expiration;")
        for (expiration,) in cursor.fetchall():

            calls = two_dict(dat.option_chain(expiration).calls)
            puts = two_dict(dat.option_chain(expiration).puts)
            cursor.executemany(f"insert into calls({columns}) values({values})", calls)
            cursor.executemany(f"insert into puts({columns}) values({values})", puts)

            # fmt: off
            cursor.execute(f"""update calls 
                               set expiration_id = {expiration_id} 
                               where expiration_id is null
                            """, (expiration,))
                            
            cursor.execute(f"""update puts 
                               set expiration_id = {expiration_id} 
                               where expiration_id is null
                            """, 
                            (expiration,))
            # fmt: on
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()


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

    ticker = args.ticker.upper()

    run_sql_script(conn, "create_table.sql")

    for key, _ in data.items():
        values = map(
            lambda x: x.replace('"', ""),
            data[key].splitlines(),
        )
        columns = map(
            lambda x: x.replace(":", ""),
            data[key].splitlines(),
        )
        columns = "\n\t".join(columns)
        values = "\n\t".join(values)

        # fmt: off
        print(f"============================= {key} TABLE =============================")
        print(f"columns => {columns}")
        print(f"values => {values}")
        print()
        # fmt: on

        if args.options:
            if key == "expiration":
                insert_expiration_data(conn, ticker, columns)
            if key == "options":
                insert_options_data(conn, ticker, columns, values)

        if args.underline:
            if key == "underline_discriptor":
                insert_underline_discriptor_data(conn, ticker, columns, values)
            if key == "underline_indicator":
                insert_underline_indicator_data(conn, ticker, columns, values)

        conn.commit()

    if args.selector:
        run_selector(conn, args.selector)

    conn.close()


if __name__ == "__main__":
    main()
