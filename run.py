#!/usr/bin/python3
import requests
from flask import Flask, render_template, redirect, request
from requests.exceptions import HTTPError
from db import  select_all
from backend import weather_to_db, userdate_weather_to_db

#result = select_all()

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    result = select_all()
#    if request.method == "POST":
#        if request.form.get("update") == "update":
#            
#        elif request.method == 'GET':
#             return render_template("index.html", data=result)
    return render_template("index.html", data=result)

@app.route('/upd', methods=['POST'])
def upd():
    userdate = request.form["update_month"]
    userdate_weather_to_db(userdate)
    result2 = select_all()
#   return redirect("/" )
    return render_template("index.html", data=result2)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

