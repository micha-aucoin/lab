import argparse
import json
import sqlite3

import pandas as pd
import yfinance as yf

con = sqlite3.connect(":memory:")
cur = con.cursor()

cur.execute(
    """
    CREATE TABLE calls(
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
cur.execute(
    """
    CREATE TABLE puts(
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


dat = yf.Ticker("MSFT")
expirations = dat.options
for expiration in expirations:
    calls = two_dict(dat.option_chain(expiration).calls)
    puts = two_dict(dat.option_chain(expiration).puts)

    cur.executemany(
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
    cur.executemany(
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

cur.execute("SELECT * FROM calls")
print(cur.fetchall())
con.close()
