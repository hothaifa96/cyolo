FROM python:3.11.4-slim-bullseye
WORKDIR /app
COPY requirements.txt .
RUN  pip3 install -r requirements.txt
ENV PORT=4222
ENV HOST=localhost
ENV SUBJECT=test1
COPY main.py .
cmd python3 main.py