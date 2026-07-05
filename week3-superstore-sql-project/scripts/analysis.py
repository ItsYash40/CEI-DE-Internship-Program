

import csv
import re
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DB_PATH = ROOT / "outputs" / "superstore.db"
CSV_PATH = ROOT / "data" / "superstore.csv"
SQL_DIR = ROOT / "sql"
RESULTS_PATH = ROOT / "outputs" / "query_results.md"

COLUMN_MAP = {
    "Row ID": "row_id", "Order ID": "order_id", "Order Date": "order_date",
    "Ship Date": "ship_date", "Ship Mode": "ship_mode", "Customer ID": "customer_id",
    "Customer Name": "customer_name", "Segment": "segment", "Country": "country",
    "City": "city", "State": "state", "Postal Code": "postal_code", "Region": "region",
    "Product ID": "product_id", "Category": "category", "Sub-Category": "sub_category",
    "Product Name": "product_name", "Sales": "sales", "Quantity": "quantity",
    "Discount": "discount", "Profit": "profit",
}


def load_csv_to_raw(conn):
    """Reads the CSV and loads it into superstore_raw (table already created by 01_load_raw.sql)."""
    with open(CSV_PATH, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = []
        for r in reader:
            rows.append(tuple(r[col] for col in COLUMN_MAP.keys()))

    placeholders = ", ".join(["?"] * len(COLUMN_MAP))
    cols = ", ".join(COLUMN_MAP.values())
    conn.executemany(f"INSERT INTO superstore_raw ({cols}) VALUES ({placeholders})", rows)
    conn.commit()
    print(f"Loaded {len(rows)} rows into superstore_raw.")


def strip_sql_comments(sql_text):
    """Removes '-- ...' line comments (this project uses no block comments
    or string literals containing '--', so a simple per-line strip is safe)."""
    cleaned_lines = []
    for line in sql_text.splitlines():
        idx = line.find("--")
        cleaned_lines.append(line[:idx] if idx != -1 else line)
    return "\n".join(cleaned_lines)


def split_statements(sql_text):
    """Strips comments first, then splits on semicolons that end a statement."""
    cleaned = strip_sql_comments(sql_text)
    statements = [s.strip() for s in cleaned.split(";")]
    return [s for s in statements if s]


def run_sql_file(conn, path, out_lines):
    sql_text = path.read_text(encoding="utf-8")
    out_lines.append(f"\n## {path.name}\n")

    statements = split_statements(sql_text)
    query_num = 0
    for stmt in statements:
        # Only execute SELECT / WITH (read) or DDL statements. DDL (CREATE/DROP) has no output.
        upper = stmt.upper()
        try:
            cur = conn.execute(stmt)
        except sqlite3.Error as e:
            out_lines.append(f"\n**Error running statement:** `{e}`\n```sql\n{stmt[:300]}\n```\n")
            continue

        if upper.startswith("WITH") or upper.startswith("SELECT"):
            query_num += 1
            rows = cur.fetchall()
            col_names = [d[0] for d in cur.description]

            # pull the comment right above this statement, if any, as a mini-title
            out_lines.append(f"\n**Query {query_num}**\n")
            out_lines.append("| " + " | ".join(col_names) + " |")
            out_lines.append("|" + "|".join(["---"] * len(col_names)) + "|")
            for row in rows[:15]:  # cap displayed rows to keep the file readable
                out_lines.append("| " + " | ".join(str(v) for v in row) + " |")
            if len(rows) > 15:
                out_lines.append(f"\n*... {len(rows) - 15} more row(s) not shown (see full results by running the script yourself) ...*\n")
            out_lines.append(f"\n_Rows returned: {len(rows)}_\n")
    conn.commit()


def main():
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    if DB_PATH.exists():
        DB_PATH.unlink()

    conn = sqlite3.connect(DB_PATH)

    out_lines = ["# Query Results\n", "Generated automatically by `scripts/run_analysis.py`. "
                 "Each section corresponds to one file in `/sql`, in execution order.\n"]

    # Step 1: create + load raw table
    run_sql_file(conn, SQL_DIR / "01_load_raw.sql", out_lines)
    load_csv_to_raw(conn)

    # Step 2: build dimension/fact tables
    run_sql_file(conn, SQL_DIR / "02_create_dimension_tables.sql", out_lines)

    # Step 3-6: analysis queries
    for fname in ["03_subqueries.sql", "04_ctes.sql", "05_window_functions.sql", "06_combined_customer_ranking.sql"]:
        run_sql_file(conn, SQL_DIR / fname, out_lines)

    RESULTS_PATH.write_text("\n".join(out_lines), encoding="utf-8")
    conn.close()
    print(f"Done. Results written to {RESULTS_PATH}")
    print(f"Database saved to {DB_PATH}")


if __name__ == "__main__":
    main()
