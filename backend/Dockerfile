FROM python:3.8-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

WORKDIR /app/msk_weather_reporter
ENV RUN_PORT=8080
ENV RUN_HOST=0.0.0.0
#ENTRYPOINT python3 /app/msk_weather_reporter/run.py
