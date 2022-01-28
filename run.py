#!/usr/bin/python3
import requests
from flask import Flask, render_template, redirect, request
from requests.exceptions import HTTPError
from db import user_select
import time
from backend import weather_to_db, userdate_weather_to_db

#result = select_all()

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    result = user_select(time.strftime("%Y-%m"))
    return render_template("index.html", data=result)

@app.route('/upd', methods=['POST'])
def upd():
    userdate = request.form["update_month"]
    userdate_weather_to_db(userdate)
    result2 = user_select(userdate)

    return render_template("index.html", data=result2)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

