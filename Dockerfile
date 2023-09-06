FROM python:3.10-slim as wsgi-server-base

RUN apt update \
    && apt install -y --no-install-recommends python3-dev default-libmysqlclient-dev build-essential libpq-dev dos2unix \
    && rm -rf /var/lib/apt/lists/*

ENV DJANGO_SUPERUSER_USERNAME=admin
ENV DJANGO_SUPERUSER_PASSWORD=password
ENV DJANGO_SUPERUSER_EMAIL=admin@example.com

WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt


COPY . .

RUN python manage.py collectstatic --no-input

EXPOSE 8000

FROM wsgi-server-base as wsgi-server

RUN python manage.py check --deploy \
    && dos2unix entrypoint.sh \
    && chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

FROM nginx:1.22-alpine as web-server

WORKDIR /app

COPY --from=wsgi-server-base /app/static /app/static

COPY nginx.conf /etc/nginx/templates/default.conf.template
