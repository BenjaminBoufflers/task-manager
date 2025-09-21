FROM python:3.11-alpine3.19 AS base
LABEL maintainer="thebigbenj"

ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN python -m venv /py && \
  /py/bin/pip install --upgrade pip && \
  apk add --update --no-cache postgresql-client && \
  apk add --update --no-cache --virtual .tmp-build-deps \
    build-base postgresql-dev musl-dev && \
    rm -rf /tmp && \
  apk del .tmp-build-deps && \
  adduser \
    --disabled-password \
    --no-create-home \
    django-user

ENV PATH="/py/bin:$PATH"

COPY ./src ./src

EXPOSE 8000


FROM base AS dev

COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY .flake8 ./

RUN /py/bin/pip install -r /tmp/requirements.dev.txt

WORKDIR /app/src

USER django-user


FROM base AS prod

COPY ./requirements.txt /tmp/requirements.txt
RUN /py/bin/pip install -r /tmp/requirements.txt

WORKDIR /app/src

USER django-user



