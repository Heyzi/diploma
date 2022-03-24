#!/usr/bin/python3
from flask import Flask, render_template, request, flash
from db import user_select
import time
import os
from backend import userdate_weather_to_db

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    
    if request.method == "GET":
      date = time.strftime("%Y-%m")
      result = user_select(time.strftime("%Y-%m"))

      return render_template("index.html", data=result, cur_month=date)
    else:
      userdate = request.form["update_month"]
      if request.form['action'] == 'update':
          if (userdate_weather_to_db(userdate)=="nodata"):
#unfancy variant:
#             flash('No data found')
             showmodal=True
             result2 = user_select(userdate)
          else:
              showmodal=False
              result2 = user_select(userdate)

      else:
       showmodal=False
       user_select(userdate)
       result2 = user_select(userdate)
       if not result2:
         showmodal=True
    return render_template("index.html", data=result2, cur_month=userdate, showmodal=showmodal)

@app.errorhandler(500)
def internal_error(error):
    return render_template("500.html"), 500

@app.errorhandler(404)
def page_not_found(error):
    return render_template("404.html"), 404

if __name__ == "__main__":

    app.run(host=os.getenv('RUN_HOST'), port=os.getenv('RUN_PORT'))
#test
