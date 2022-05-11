#!/usr/bin/python3
from flask import Flask, render_template, request, flash
from db import user_select
import time
import os
import socket
import math
from backend import userdate_weather_to_db
from cpu_load_generator import load_single_core, load_all_cores, from_profile

app = Flask(__name__)



@app.route("/", methods=["GET", "POST"])
def index():
    with open('pyapp-release', 'rb') as fp:
     v = fp.read()
    if request.method == "GET":
      date = time.strftime("%Y-%m")
      result = user_select(time.strftime("%Y-%m"))
      
      return render_template("index.html", data=result, cur_month=date, hostname=socket.gethostname(), env=os.getenv('FLASK_ENV'), version=v)
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
       if request.form['action'] == 'stress':
         load_all_cores(duration_s=15, target_load=0.9)
        # os.system("python -m cpu_load_generator -l 0.8 -d 5 -c -1")
          # while True:
          #  math.factorial(50)  

    return render_template("index.html", data=result2, cur_month=userdate, showmodal=showmodal, hostname=socket.gethostname(), env=os.getenv('FLASK_ENV'), version=v)

@app.errorhandler(500)
def internal_error(error):
    return render_template("500.html"), 500

@app.errorhandler(404)
def page_not_found(error):
    return render_template("404.html"), 404

if __name__ == "__main__":

    app.run(host=os.getenv('RUN_HOST'), port=os.getenv('RUN_PORT'))
#test
