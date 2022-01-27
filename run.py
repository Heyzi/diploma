#!/usr/bin/python3
import requests
from flask import Flask, render_template
from flask import request
from requests.exceptions import HTTPError
from db import insert_to_table, select_all
import get_data

result = select_all()

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    print(request.method)
#    if request.method == "POST":
#        if request.form.get("update") == "update":
#            
#        elif request.method == 'GET':
#             return render_template("index.html", data=result)
    return render_template("index.html", data=result)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

