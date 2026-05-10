#!/usr/bin/env python

import csv
import sqlite3
import sys
from typing import cast


def query_db(
    db: str,
    query: str,
    params: tuple = (),
    as_dict: bool = False,
) -> list[dict] | list[tuple]:
    conn = None
    rows: list[tuple] = []
    try:
        conn = sqlite3.connect(db)
        if as_dict:
            conn.row_factory = sqlite3.Row
        cur = conn.cursor()
        cur.execute(query, params)
        rows = cur.fetchall()
        if as_dict:
            return [dict(row) for row in rows]
        else:
            return rows
    except sqlite3.Error as e:
        print(f"SQL ERROR -> {e}")
        return []
    finally:
        if conn:
            conn.close()


def get_history(db: str, symbol: str) -> list[dict]:
    query = """
    SELECT m.symbol
        , m.shortName
        , datetime(mi.created_at) AS created_at
        , mi.regularMarketPreviousClose AS underlying_price
    FROM market_info mi
        JOIN metadata m ON mi.metadata_id = m.id
    WHERE m.symbol = ?
    order by datetime(mi.created_at);
    """
    params = [symbol]
    return cast(list[dict], query_db(db, query, tuple(params), as_dict=True))


def get_expiration_dates(symbol: str, db: str) -> list[str]:
    query = """
    SELECT DISTINCT
        date(e.expiration_date) AS expiration_date
    FROM options_info o
    JOIN metadata m
        ON o.metadata_id = m.id
    JOIN expirations e
        ON o.expiration_id = e.id
    WHERE m.symbol = ?
    ORDER BY expiration_date DESC;
    """
    params = [symbol]
    return [date[0] for date in query_db(db, query, tuple(params))]


def get_options(
    db: str,
    symbol: str,
    expiration_date=None,
    created_at=None,
    option_type=None,
) -> list[dict]:
    query = """
    SELECT *
    FROM options_info o
        JOIN metadata m ON o.metadata_id = m.id
        JOIN market_info mi ON o.market_info_id = mi.id
        JOIN expirations e ON o.expiration_id = e.id
    WHERE m.symbol = ?
    """
    params = [symbol]

    if created_at:
        query += " AND date(mi.created_at) = ?"
        params.append(created_at)

    if expiration_date:
        query += " AND date(e.expiration_date) = ?"
        params.append(expiration_date)

    if option_type:
        query += " AND o.option_type = ?"
        params.append(option_type)

    return cast(list[dict], query_db(db, query, tuple(params), as_dict=True))


def get_strad(db, symbol, expiration_date, created_at=None):
    options = get_options(
        db,
        symbol,
        expiration_date=expiration_date,
        created_at=created_at,
    )

    strikes = {}
    for opt in options:
        strike = opt["strike"]
        if strike not in strikes:
            strikes[strike] = {
                "strike": strike,
                "put_lastPrice": None,
                "call_lastPrice": None,
            }

        if opt["option_type"] == "put":
            strikes[strike]["put_lastPrice"] = opt["lastPrice"]
        elif opt["option_type"] == "call":
            strikes[strike]["call_lastPrice"] = opt["lastPrice"]

    return sorted(strikes.values(), key=lambda x: x["strike"])


if __name__ == "__main__":
    db = "db.db"
    symbol = "SPY"

    expiration_dates: list[str] = get_expiration_dates(db=db, symbol=symbol)
    created_at_dates: list[str] = [
        d["created_at"][:10] for d in get_history(db=db, symbol=symbol)
    ]

    for idx, date in enumerate(created_at_dates):
        if idx % 5 == 0 and idx != 0:
            print()
        sys.stdout.write(f"{date:<{20}}")
    print()
    created_at = input("select created at date > ")

    for idx, date in enumerate(expiration_dates):
        if idx % 5 == 0 and idx != 0:
            print()
        sys.stdout.write(f"{date:<{20}}")
    print()
    expiration_date = input("select expiration date > ")

    strad: list[dict] = get_strad(
        db=db, symbol=symbol, expiration_date=expiration_date, created_at=created_at
    )
    print(
        f"strad(db={db}, symbol={symbol}, expiration={expiration_date}, created_at={created_at})"
    )
    writer = csv.DictWriter(sys.stdout, fieldnames=strad[0].keys())
    writer.writeheader()
    writer.writerows(strad)
