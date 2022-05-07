#!/usr/bin/python3
import sqlite3

dbfile = "weather.db"
    
def create_db():
    conn = sqlite3.connect(dbfile)
    c = conn.cursor()
    c.execute("""CREATE TABLE IF NOT EXISTS weather (
                                        id integer,
                                        weather_state_name text,
                                        weather_state_abbr text,
                                        wind_direction_compass text,
                                        created text,
                                        applicable_date text PRIMARY KEY,
                                        min_temp integer,
                                        max_temp integer,
                                        the_temp integer)""")

    conn.commit()
    conn.close()

def insert_to_table(most_consensus_monthly):
    conn = sqlite3.connect(dbfile)
    c = conn.cursor()
    c.execute("INSERT OR REPLACE INTO weather VALUES (?,?,?,?,?,?,?,?,?)", [most_consensus_monthly["id"], most_consensus_monthly["weather_state_name"], most_consensus_monthly["weather_state_abbr"], most_consensus_monthly["wind_direction_compass"], most_consensus_monthly["created"], most_consensus_monthly["applicable_date"], most_consensus_monthly["min_temp"], most_consensus_monthly["max_temp"], most_consensus_monthly["the_temp"]])
    conn.commit()
    conn.close()

def select_all():
    conn = sqlite3.connect(dbfile)
    c = conn.cursor()
    result = c.execute('SELECT * FROM weather ORDER BY applicable_date ASC').fetchall()
    conn.close()
    return(result)

def user_select(userdate):
    date=userdate
    conn = sqlite3.connect(dbfile)
    c = conn.cursor()
    result = c.execute("SELECT * FROM weather WHERE strftime('%Y-%m', applicable_date) = ? ORDER BY applicable_date ASC", (date,)).fetchall()
    conn.close()
    return(result)
