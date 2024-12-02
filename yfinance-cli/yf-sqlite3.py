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
    expiration = {
        "table_name": "expiration",
        "columns": """
            id integer primary key autoincrement,
            date text unique
        """,
    }
    options = {
        "table_name": "options",
        "columns": """
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
        """,
    }
    underline_indicator = {
        "table_name": "underline_indicator",
        "columns": """
            regularMarketPreviousClose,
            regularMarketOpen,
            regularMarketDayLow,
            regularMarketDayHigh,
            dividendRate,
            beta,
            regularMarketVolume,
            averageVolume,
            averageVolume10days,
            averageDailyVolume10Day,
            bid,
            ask,
            bidSize,
            askSize,
            marketCap,
            fiftyTwoWeekLow,
            fiftyTwoWeekHigh,
            fiftyDayAverage,
            twoHundredDayAverage,
            sharesOutstanding,
            sharesShort,
            sharesShortPriorMonth,
            sharesShortPreviousMonthDate,
            heldPercentInsiders,
            heldPercentInstitutions,
            shortRatio,
            bookValue,
            priceToBook,
            enterpriseToRevenue,
            enterpriseToEbitda,
            "52WeekChange",
            SandP52WeekChange,
            lastDividendValue,
            lastDividendDate,
            currentPrice,
            targetHighPrice,
            targetLowPrice,
            targetMeanPrice,
            targetMedianPrice,
            recommendationMean,
            recommendationKey,
            numberOfAnalystOpinions,
            totalCashPerShare,
            quickRatio,
            currentRatio,
            debtToEquity,
            revenuePerShare,
            returnOnAssets,
            returnOnEquity,
            trailingPegRatio
        """,
    }
    underline_discriptor = {
        "table_name": "underline_discriptor",
        "columns": """
            currency,
            exchange,
            quoteType,
            symbol,
            underlyingSymbol,
            shortName,
            longName,
            timeZoneFullName,
            timeZoneShortName,
            financialCurrency
        """,
    }
    cursor = conn.cursor()
    try:
        # fmt: off
        cursor.execute(f"CREATE TABLE IF NOT EXISTS expiration({expiration['columns']})")
        cursor.execute(f"CREATE TABLE IF NOT EXISTS calls({options['columns']})")
        cursor.execute(f"CREATE TABLE IF NOT EXISTS puts({options['columns']})")
        cursor.execute(f"CREATE TABLE IF NOT EXISTS underline_indicator({underline_indicator['columns']})")
        cursor.execute(f"CREATE TABLE IF NOT EXISTS underline_discriptor({underline_discriptor['columns']})")
        # fmt: on
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()
    finally:
        return [expiration, options, underline_indicator, underline_discriptor]
        cursor.close()


def insert_underline_indicator_data(conn, ticker, columns, values):
    # fmt: off
    cursor = conn.cursor()
    try:
        dat = yf.Ticker(ticker)
        info = dat.info
        cursor.execute(f"insert into underline_indicator({columns}) values({values})", info)
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()
    finally:
        cursor.close()
    # fmt: on


def insert_underline_discriptor_data(conn, ticker, columns, values):
    # fmt: off
    cursor = conn.cursor()
    try:
        dat = yf.Ticker(ticker)
        info = dat.info
        cursor.execute(f"insert into underline_discriptor({columns}) values({values})", info)
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()
    finally:
        cursor.close()
    # fmt: on


def insert_expiration_data(conn, ticker, columns):
    # fmt: off
    cursor = conn.cursor()
    try:
        dat = yf.Ticker(ticker)
        expirations = dat.options
        for expiration in expirations:
            cursor.execute(f"insert into expiration({columns}) values(?)", (expiration,))
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()
    finally:
        cursor.close()
    # fmt: on


def two_dict(data):
    if isinstance(data, pd.DataFrame):
        for col in data.columns:
            if pd.api.types.is_datetime64_any_dtype(data[col]):
                data[col] = data[col].dt.strftime("%Y-%m-%d %H:%M:%S")
        return data.to_dict(orient="records")


def insert_options_data(conn, ticker, columns, values):
    cursor = conn.cursor()
    try:
        dat = yf.Ticker(ticker)
        cursor.execute("select date from expiration;")
        expirations = cursor.fetchall()
        for expiration in expirations:
            expiration = expiration[0]
            expiration_id = "(select id from expiration where date = ?)"

            calls = two_dict(dat.option_chain(expiration).calls)
            puts = two_dict(dat.option_chain(expiration).puts)
            cursor.executemany(f"insert into calls({columns}) values({values})", calls)
            cursor.executemany(f"insert into puts({columns}) values({values})", puts)

            # fmt: off
            cursor.execute(f"""update calls 
                               set expiration_id = {expiration_id} 
                               where expiration_id is null
                            """,
                            (expiration,))
            cursor.execute(f"""update puts 
                               set expiration_id = {expiration_id} 
                               where expiration_id is null
                            """, 
                            (expiration,))
            # fmt: on
    except sqlite3.Error as e:
        print(f"Error executing query: {e}")
        conn.rollback()
    finally:
        cursor.close()


def filter_columns(columns, filters):
    filtered = [[], []]
    for column in columns.splitlines():
        if column.strip() and not any(f in column for f in filters):
            column = column.strip(",").split()[0]
            values = column.strip(",").split()[0].strip('"')
            filtered[0].append(column)
            filtered[1].append(f":{values}")
    return filtered


def columns_values(conn):
    filtered_columns_values = {}
    for table in check_tables_exist(conn):

        table_name = table["table_name"]
        columns = table["columns"]
        filters = ["primary key", "foreign key", "_id"]

        columns, values = filter_columns(columns, filters)

        filtered_columns_values[table_name] = (
            ", ".join(columns),
            ", ".join(values),
        )
    return filtered_columns_values


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

    for k, v in columns_values(conn).items():
        print(f"============================= {k} TABLE =============================")
        print(f"columns => {v[0]}")
        print(f"values => {v[1]}")
        print()
        if k == "expiration":
            if args.options:
                insert_expiration_data(conn, ticker, v[0])
        if k == "options":
            if args.options:
                insert_options_data(conn, ticker, v[0], v[1])
        if k == "underline_indicator":
            if args.underline:
                insert_underline_indicator_data(conn, ticker, v[0], v[1])
        if k == "underline_discriptor":
            if args.underline:
                insert_underline_discriptor_data(conn, ticker, v[0], v[1])

    if args.selector:
        run_selector(conn, args.selector)

    print()
    conn.close()


if __name__ == "__main__":
    main()
