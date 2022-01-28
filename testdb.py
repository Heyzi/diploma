#!/usr/bin/python3
import sqlite3

def select_all():
    conn = sqlite3.connect(dbfile)
    c = conn.cursor()
    sqlite_select_query = """SELECT * from weather"""
    c.execute(sqlite_select_query)
    records = c.fetchall()
    print(result)
    conn.close()
    return(result)

