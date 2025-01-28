#!/bin/sh
MAX_RETRIES=30
RETRY_INTERVAL=2

echo "Waiting for Postgres to be ready..."

# Loop to check MySQL availability
for i in $(seq 1 $MAX_RETRIES); do
  nc -z $DATABASE_HOST $DATABASE_PORT && break
  echo "Waiting for Postgres... ($i/$MAX_RETRIES)"
  sleep $RETRY_INTERVAL
done

python manage.py migrate
python manage.py updatecatalog
python manage.py collectstatic # into /var/www/gutendex/static-root
python manage.py runserver ${BIND_HOST}:${BIND_PORT}
