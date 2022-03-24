FROM python:3.8-slim-buster
WORKDIR /app/msk_weather_reporter
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY ./msk_weather_reporter/ ./
ENV RUN_PORT=5555
ENV RUN_HOST=0.0.0.0
CMD [ "python", "./run.py" ]

