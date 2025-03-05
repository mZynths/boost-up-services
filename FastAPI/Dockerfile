# syntax=docker/dockerfile:1
FROM python:3.10-alpine

WORKDIR /restfulapi

RUN apk add --no-cache gcc musl-dev linux-headers

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

EXPOSE 80

COPY . .

ENTRYPOINT ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80", "--reload", "--app-dir",  "./app/"]