FROM python:3.8-slim-buster
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1
ENV SERVICE_NAME="msk_weather_reporter"
WORKDIR /app/$SERVICE_NAME


COPY requirements.txt requirements.txt
RUN apt update -y && apt-get install -y python3-dev build-essential && \
    pip install -r requirements.txt  --no-cache-dir
COPY ../pyapp-release ./
COPY ./msk_weather_reporter/ ./

RUN groupadd -g 1111 $SERVICE_NAME && \
    useradd -s /sbin/nologin -u 1111 $SERVICE_NAME -g $SERVICE_NAME && \
    chown $SERVICE_NAME:$SERVICE_NAME -R /app

USER $SERVICE_NAME
ENV RUN_HOST=0.0.0.0
ENV RUN_PORT=5555
EXPOSE 5555
CMD [ "python", "./run.py" ]

