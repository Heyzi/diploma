#!/usr/bin/python3
import requests
from flask import Flask, render_template, redirect, request
from db import user_select
import time
from backend import weather_to_db, userdate_weather_to_db


app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    date = time.strftime("%Y-%m")
    result = user_select(time.strftime("%Y-%m"))
    return render_template("index.html", data=result, cur_month=date)

@app.route('/upd', methods=['POST'])
def upd():
    userdate = request.form["update_month"]
    if request.form['action'] == 'update':
     userdate_weather_to_db(userdate)
     result2 = user_select(userdate)
    else:
     user_select(userdate)
     result2 = user_select(userdate)

    return render_template("index.html", data=result2, cur_month=userdate)

@app.errorhandler(500)
def internal_error(error):

    return render_template("500.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

