#!/usr/bin/python3
import requests
import json
import calendar
import datetime
import time
import db
from db import insert_to_table, select_all, create_db
from requests.exceptions import HTTPError

create_db()

def find_all_month_date():
    now = datetime.datetime.now()
    year = now.year
    month = now.month
    num_days = calendar.monthrange(year, month)[1]
    every_month_day = [
        datetime.date(year, month, day).strftime("%Y/%m/%d")
        for day in range(1, num_days + 1)
    ]
    return every_month_day


def weather_for_every_day():
    try:
        response = requests.get(
            "https://www.metaweather.com/api/location/2122265/" + day
        )
        response.raise_for_status()
        jsonResponse = response.json()
        most_consensus_dayly = max(jsonResponse, key=lambda x: x["predictability"])
        value = most_consensus_dayly.pop("predictability")
        value = most_consensus_dayly.pop("visibility")
        value = most_consensus_dayly.pop("humidity")
        value = most_consensus_dayly.pop("air_pressure")
        value = most_consensus_dayly.pop("wind_speed")
        value = most_consensus_dayly.pop("wind_direction")

    except HTTPError as http_err:
        print(f"HTTP error occurred: {http_err}")
    except Exception as err:
        print(f"Other error occurred: {err}")
    return most_consensus_dayly


dates_list = find_all_month_date()

for day in dates_list:
    most_consensus_monthly = weather_for_every_day()
    insert_to_table(most_consensus_monthly)

