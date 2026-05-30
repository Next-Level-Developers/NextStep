import os
from pathlib import Path

import psycopg2


password = os.environ.get("RDS_PASSWORD", "<Enter_DB_Password>")
sslrootcert = Path(__file__).resolve().parent / "global-bundle.pem"

conn = None
try:
    conn = psycopg2.connect(
        host="djangodb.cvmekawm0tyq.ap-south-1.rds.amazonaws.com",
        port=5432,
        database="postgres",
        user="postgres",
        password=password,
        sslmode="verify-full",
        sslrootcert=str(sslrootcert),
    )
    cur = conn.cursor()
    cur.execute("SELECT version();")
    print(cur.fetchone()[0])
    cur.close()
except Exception as exc:
    print(f"Database error: {exc}")
    raise
finally:
    if conn:
        conn.close()
