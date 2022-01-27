#!/usr/bin/python3
import sqlite3

dbfile = "weather.db"
    
def create_db():
    conn = sqlite3.connect(dbfile)
    c = conn.cursor()
    c.execute("""CREATE TABLE IF NOT EXISTS weather (
                                        id integer PRIMARY KEY,
                                        weather_state_name text NOT NULL,
                                        weather_state_abbr text NOT NULL,
                                        wind_direction_compass text NOT NULL,
                                        created date NOT NULL,
                                        applicable_date date NOT NULL,
                                        min_temp integer NOT NULL,
                                        max_temp integer NOT NULL,
                                        the_temp integer NOT NULL)""")

    conn.commit()
    conn.close()

def insert_to_table(most_consensus_monthly):
    conn = sqlite3.connect(dbfile)
    c = conn.cursor()
    c.execute("INSERT OR IGNORE INTO weather VALUES (?,?,?,?,?,?,?,?,?)", [most_consensus_monthly["id"], most_consensus_monthly["weather_state_name"], most_consensus_monthly["weather_state_abbr"], most_consensus_monthly["wind_direction_compass"], most_consensus_monthly["created"], most_consensus_monthly["applicable_date"], most_consensus_monthly["min_temp"], most_consensus_monthly["max_temp"], most_consensus_monthly["the_temp"]])
    conn.commit()
    conn.close()

def select_all():
    conn = sqlite3.connect(dbfile)
    c = conn.cursor()
    c.execute("SELECT * FROM weather ORDER BY applicable_date ASC")
    conn.row_factory = lambda c, r: dict(zip([col[0] for col in c.description], r))
    result = c.execute('SELECT * FROM weather ORDER BY applicable_date ASC').fetchall()
    print(type(result))
    conn.close()
    return(result)

if __name__ == "__main__":
   create_db()
   select_all()
