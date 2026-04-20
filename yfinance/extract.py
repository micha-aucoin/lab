#!/usr/bin/env python

import csv
import sqlite3

DB_PATH = "db.db"
conn = sqlite3.connect(DB_PATH)
cursor = conn.cursor()

query = "SELECT symbol FROM metadata;"
cursor.execute(query)
rows = cursor.fetchall()  # [
#     ("DBA",),
#     ("FXY",),
#     ("GLD",),
#     ("MSTR",),
#     ("SPY",),
#     ("TLT",),
#     ("UNG",),
#     ("UUP",),
#     ("VNQ",),
#     ("XLE",),
#     ("XLV",),
# ]
symbols = [row[0] for row in rows]

query = """
SELECT m.symbol
    , m.shortName
    , mi.created_at
    , mi.regularMarketPreviousClose AS underlying_price
    , e.expiration_date
    , o.option_type
    , o.contractSymbol
    , o.strike
    , o.lastPrice
    , o.bid
    , o.ask
    , o.volume
    , o.openInterest
FROM options_info o
    JOIN metadata m ON o.metadata_id = m.id
    JOIN market_info mi ON o.market_info_id = mi.id
    JOIN expirations e ON o.expiration_id = e.id
WHERE m.symbol = ?
"""

# for sym in symbols:
#     cursor.execute(query, (sym,))
#     rows = cursor.fetchall()
#     col_names = [desc[0] for desc in cursor.description]
#     with open(f"{sym}.csv", "w", newline="") as f:
#         writer = csv.writer(f)
#         writer.writerow(col_names)  # header
#         writer.writerows(rows)
#     print(f"Wrote {sym}.csv ({len(rows)} rows)")

query = """
SELECT m.symbol
    , mi.regularMarketPreviousClose AS underlinying_price
    , date(e.expiration_date) AS expiration_date

    , c.contractSymbol AS call_contractSymbol
    , c.lastPrice      AS call_lastPrice
    , c.bid            AS call_bid
    , c.ask            AS call_ask
    , c.volume         AS call_volume
    , c.openInterest   AS call_openInterest

    , c.strike

    , p.contractSymbol AS put_contractSymbol
    , p.lastPrice      AS put_lastPrice
    , p.bid            AS put_bid
    , p.ask            AS put_ask
    , p.volume         AS put_volume
    , p.openInterest   AS put_openInterest

FROM options_info c

JOIN options_info p
    ON c.metadata_id = p.metadata_id
    AND c.expiration_id = p.expiration_id
    AND c.strike = p.strike
JOIN metadata m
    ON c.metadata_id = m.id
JOIN market_info mi
    ON c.market_info_id = mi.id
JOIN expirations e
    ON c.expiration_id = e.id

WHERE m.symbol = ?
    AND date(e.expiration_date) = ?
    AND c.option_type = 'call'
    AND p.option_type = 'put'

ORDER BY c.strike;
"""

check_query = """
SELECT 1
FROM expirations e
JOIN options_info oi ON oi.expiration_id = e.id
JOIN metadata m ON oi.metadata_id = m.id
WHERE m.symbol = ?
    AND date(e.expiration_date) = ?
LIMIT 1;
"""

symbol, expiration_date = "SPY", "2077-04-21"

cursor.execute(check_query, (symbol, expiration_date))
exists = cursor.fetchone() is not None

if not exists:
    raise ValueError(f"Expiration {expiration_date} not found for {symbol}")

cursor.execute(query, (symbol, expiration_date))
rows = cursor.fetchall()

with open(f"{symbol}_{expiration_date}_straddles.csv", "w") as f:
    writer = csv.writer(f)
    writer.writerow([desc[0] for desc in cursor.description])
    writer.writerows(rows)
    print(f"Wrote {symbol}_{expiration_date}_straddles.csv ({len(rows)} rows)")

conn.close()
