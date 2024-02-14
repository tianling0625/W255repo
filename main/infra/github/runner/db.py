import os

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine

load_dotenv()

PGUSER = os.environ["PGUSER"]
PGPASSWORD = os.environ["PGPASSWORD"]
PGHOST = os.environ["PGHOST"]
PGDATABASE = os.environ["PGDATABASE"]

engine = create_engine(
    f"postgresql+psycopg://{PGUSER}:{PGPASSWORD}@{PGHOST}/{PGDATABASE}"
)
query = """
SELECT * from student
WHERE github_username is not null
"""
student_dataframe = pd.read_sql_query(query, engine)
