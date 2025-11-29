import copy
import os
import sqlite3
import json
from datetime import datetime
from pathlib import Path
from collections.abc import Mapping

DEFAULT_DB_NAME = "demo.db"
DB_ENV_VAR = "OPENSPOOLMAN_PRINT_HISTORY_DB"


def _default_db_path() -> Path:
    """Resolve the print history database path, allowing an env override."""

    env_path = os.getenv(DB_ENV_VAR)
    if env_path:
        return Path(env_path).expanduser().resolve()

    return Path(__file__).resolve().parent / "data" / DEFAULT_DB_NAME


db_config = {"db_path": str(_default_db_path())}  # Configuration for database location


_DEMO_PRINTS = [
    {
        "id": 1,
        "print_date": "2024-01-01 12:00:00",
        "file_name": "benchy.3mf",
        "print_type": "PLA",
        "image_file": None,
        "filament_info": [
            {"spool_id": 1, "filament_type": "PLA", "color": "Red", "grams_used": 22.5, "ams_slot": 1},
            {"spool_id": 2, "filament_type": "PLA", "color": "Black", "grams_used": 3.0, "ams_slot": 4},
        ],
    },
    {
        "id": 2,
        "print_date": "2024-01-03 17:45:00",
        "file_name": "phone_stand.3mf",
        "print_type": "PLA",
        "image_file": None,
        "filament_info": [
            {"spool_id": 3, "filament_type": "PLA", "color": "Sky Blue", "grams_used": 12.0, "ams_slot": 2},
        ],
    },
    {
        "id": 3,
        "print_date": "2024-01-10 09:30:00",
        "file_name": "gears.3mf",
        "print_type": "PETG",
        "image_file": None,
        "filament_info": [
            {"spool_id": 4, "filament_type": "PETG", "color": "Green", "grams_used": 30.5, "ams_slot": 1},
        ],
    },
]

def create_database() -> None:
    """
    Creates an SQLite database to store 3D printer print jobs and filament usage if it does not exist.
    """
    db_path = Path(db_config["db_path"])
    if not db_path.exists():
        db_path.parent.mkdir(parents=True, exist_ok=True)

        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # Create table for prints
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS prints (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                print_date TEXT NOT NULL,
                file_name TEXT NOT NULL,
                print_type TEXT NOT NULL,
                image_file TEXT
            )
        ''')
        
        # Create table for filament usage
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS filament_usage (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                print_id INTEGER NOT NULL,
                spool_id INTEGER,
                filament_type TEXT NOT NULL,
                color TEXT NOT NULL,
                grams_used REAL NOT NULL,
                ams_slot INTEGER NOT NULL,
                FOREIGN KEY (print_id) REFERENCES prints (id) ON DELETE CASCADE
            )
        ''')

        conn.commit()
        _seed_demo_data(conn)
        conn.close()


def _seed_demo_data(conn: sqlite3.Connection) -> None:
    """Populate a new database with a small demo history so the UI renders."""

    cursor = conn.cursor()
    cursor.execute("SELECT COUNT(*) FROM prints")
    if cursor.fetchone()[0]:
        return

    for print_job in _DEMO_PRINTS:
        cursor.execute(
            "INSERT INTO prints (id, print_date, file_name, print_type, image_file) VALUES (?, ?, ?, ?, ?)",
            (
                print_job["id"],
                print_job["print_date"],
                print_job["file_name"],
                print_job["print_type"],
                print_job["image_file"],
            ),
        )

        for filament in print_job["filament_info"]:
            cursor.execute(
                """
                INSERT INTO filament_usage (print_id, spool_id, filament_type, color, grams_used, ams_slot)
                VALUES (?, ?, ?, ?, ?, ?)
                """,
                (
                    print_job["id"],
                    filament.get("spool_id"),
                    filament["filament_type"],
                    filament["color"],
                    filament["grams_used"],
                    filament["ams_slot"],
                ),
            )

    conn.commit()

def insert_print(file_name: str, print_type: str, image_file: str = None, print_date: str = None) -> int:
    """
    Inserts a new print job into the database and returns the print ID.
    If no print_date is provided, the current timestamp is used.
    """
    if print_date is None:
        print_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    conn = sqlite3.connect(db_config["db_path"])
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO prints (print_date, file_name, print_type, image_file)
        VALUES (?, ?, ?, ?)
    ''', (print_date, file_name, print_type, image_file))
    print_id = cursor.lastrowid
    conn.commit()
    conn.close()
    return print_id

def insert_filament_usage(print_id: int, filament_type: str, color: str, grams_used: float, ams_slot: int) -> None:
    """
    Inserts a new filament usage entry for a specific print job.
    """
    conn = sqlite3.connect(db_config["db_path"])
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO filament_usage (print_id, filament_type, color, grams_used, ams_slot)
        VALUES (?, ?, ?, ?, ?)
    ''', (print_id, filament_type, color, grams_used, ams_slot))
    conn.commit()
    conn.close()

def update_filament_spool(print_id: int, filament_id: int, spool_id: int) -> None:
    """
    Updates the spool_id for a given filament usage entry, ensuring it belongs to the specified print job.
    """
    conn = sqlite3.connect(db_config["db_path"])
    cursor = conn.cursor()
    cursor.execute('''
        UPDATE filament_usage
        SET spool_id = ?
        WHERE ams_slot = ? AND print_id = ?
    ''', (spool_id, filament_id, print_id))
    conn.commit()
    conn.close()


def get_prints_with_filament(limit: int | None = None, offset: int | None = None):
    """
    Retrieves print jobs along with their associated filament usage, grouped by print job.

    A total count is returned to support pagination.
    """
    conn = sqlite3.connect(db_config["db_path"])
    conn.row_factory = sqlite3.Row  # Enable column name access

    count_cursor = conn.cursor()
    count_cursor.execute("SELECT COUNT(*) FROM prints")
    total_count = count_cursor.fetchone()[0]

    cursor = conn.cursor()
    query = '''
        SELECT p.id AS id, p.print_date AS print_date, p.file_name AS file_name,
               p.print_type AS print_type, p.image_file AS image_file,
               (
                   SELECT json_group_array(json_object(
                       'spool_id', f.spool_id,
                       'filament_type', f.filament_type,
                       'color', f.color,
                       'grams_used', f.grams_used,
                       'ams_slot', f.ams_slot
                   )) FROM filament_usage f WHERE f.print_id = p.id
               ) AS filament_info
        FROM prints p
        ORDER BY p.print_date DESC
    '''
    params: list[int] = []
    if limit is not None:
        query += " LIMIT ?"
        params.append(limit)
        if offset is not None:
            query += " OFFSET ?"
            params.append(offset)

    cursor.execute(query, params)
    prints = [dict(row) for row in cursor.fetchall()]
    conn.close()
    return prints, total_count

def get_prints_by_spool(spool_id: int):
    """
    Retrieves all print jobs that used a specific spool.
    """
    conn = sqlite3.connect(db_config["db_path"])
    cursor = conn.cursor()
    cursor.execute('''
        SELECT DISTINCT p.* FROM prints p
        JOIN filament_usage f ON p.id = f.print_id
        WHERE f.spool_id = ?
    ''', (spool_id,))
    prints = cursor.fetchall()
    conn.close()
    return prints

def get_filament_for_slot(print_id: int, ams_slot: int):
    conn = sqlite3.connect(db_config["db_path"])
    conn.row_factory = sqlite3.Row  # Enable column name access
    cursor = conn.cursor()
    
    cursor.execute('''
        SELECT * FROM filament_usage
        WHERE print_id = ? AND ams_slot = ?
    ''', (print_id, ams_slot))
    
    results = cursor.fetchone()
    conn.close()
    return results

# Example for creating the database if it does not exist
create_database()

# Example usage
#print_id = insert_print("test_print.gcode", "PLA", "test_print.png")
#insert_filament_usage(print_id, 15.2, 1)  # Spool_id is unknown initially
#insert_filament_usage(print_id, 10.5, 2, 123)  # Spool_id is known

# Updating spool_id for the first filament entry
#update_filament_spool(1, 456)  # Assigns spool_id to the first filament usage entry

#print("All Prints:", get_prints())
#print(f"Filament usage for print {print_id}:", get_filament_usage(print_id))
#print(f"Prints using spool 123:", get_prints_by_spool(123))
