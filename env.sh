#!/usr/bin/bash
python3 -m venv .venv
source .venv/bin/activate
pip3 install Flask --quiet
export FLASK_ENV=production
export FLASK_RUN_PORT=8080
export FLASK_RUN_HOST=localhost
export FLASK_APP=testapp.py
