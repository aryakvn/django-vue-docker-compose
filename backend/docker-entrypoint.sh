#!/bin/bash

# Run migrations
python manage.py migrate --noinput

# Collect static files
python manage.py collectstatic --noinput

# Start daphne
exec daphne -b 0.0.0.0 -p 8000 backend.asgi:application