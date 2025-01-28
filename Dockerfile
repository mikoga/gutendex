# Use the official Python 3.9 base image
FROM python:3.9-alpine

# Set the working directory in the container
WORKDIR /app

# Install system dependencies required for psycopg2 and other tools
RUN apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    postgresql-dev \
    build-base \
    netcat-openbsd \
    rsync \
    && pip install --upgrade pip

# Copy the requirements file (if you have one)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code to the container
COPY manage.py .
COPY static ./static
COPY gutendex ./gutendex
COPY catalog_files ./catalog_files
COPY books ./books
COPY license .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh \
    && mkdir -p /app/catalog_files/tmp/cache/epub

ENTRYPOINT [ "./entrypoint.sh" ]