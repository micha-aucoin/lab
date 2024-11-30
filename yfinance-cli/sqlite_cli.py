import argparse
import sqlite3
import sys
import textwrap


def connect_db(db_name):
    """Connect to the SQLite database or create it if it doesn't exist."""
    try:
        conn = sqlite3.connect(db_name)
        return conn
    except sqlite3.Error as e:
        print(f"Error connecting to database: {e}")
        sys.exit(1)


def run_query(conn, queries):
    """Run a custom SQL query."""
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
                print("======== executed successfully ========")
                print(query)
        except sqlite3.Error as e:
            print(f"Error executing query: {e}")
            conn.rollback()


def main():
    parser = argparse.ArgumentParser(
        prog="sqlite3",
        formatter_class=argparse.RawTextHelpFormatter,
        description="SQLite3 CLI Tool",
        epilog=textwrap.dedent(
            """\

Example usage:
--------------
python3 sqlite_cli.py :memory: \\
    --query 'create table users(name,email,age);' \\
    --query 'insert into users(name,email,age) values("Alice","alice@example.com",30);' \\
    --query 'select name from users;' \\
    --query 'select email from users;' \\
    --query 'select age from users;'
            """
        ),
    )
    parser.add_argument(
        "db",
        help="SQLite database file or :memory:",
    )
    parser.add_argument(
        "-q",
        "--query",
        action="append",
        help="Execute a custom SQL query.",
    )

    args = parser.parse_args()
    conn = connect_db(args.db)
    if args.query:
        run_query(conn, args.query)

    print()
    conn.close()


if __name__ == "__main__":
    main()
