# setup_db.py
import sqlite3
import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
DB_NAME = "setupDB.db"

def init_db():
    if os.path.exists(DB_NAME):
        os.remove(DB_NAME)

    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    
    schema_path = BASE_DIR / "setupDB.sql"
    data_path = BASE_DIR / "populateData.sql"
    
    with open(schema_path, 'r') as sql_file:
        cursor.executescript(sql_file.read())
    print("Database schema created.")

    # Populate data
    with open(data_path, 'r') as sql_file:
        cursor.executescript(sql_file.read())
    print("Database populated with initial data.")

    # Read and execute setupDB.sql (create tables)
    #with open('MVP_App\setupDB.sql', 'r') as sql_file:
     #   cursor.executescript(sql_file.read())

    # Read and execute populateData.sql (insert data)
    #with open('MVP_App\populateData.sql', 'r') as sql_file:
     #   cursor.executescript(sql_file.read())

    conn.commit()
    conn.close()
    print(f"Database {DB_NAME} initialized successfully.")

if __name__ == '__main__':
    init_db()