#!/usr/bin/python3
from db import create_db, insert_to_table
from datetime import date, timedelta
from backend import weather_for_every_day, weather_to_db

def list_dates():
    start_date = date(2014, 5, 31)
    end_date = date.today()

    delta = end_date - start_date
    datelist = []    
    for i in range(delta.days + 1):
       day = start_date + timedelta(days=i)
       day = day.strftime("%Y/%m/%d")
       insert_to_table(weather_for_every_day(day))
       print(day + ' added to db')
    return day
print(list_dates())

