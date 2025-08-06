FROM python:3.10-slim-bookworm AS builder

# Install build dependencies
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        gcc libffi-dev musl-dev ffmpeg aria2 python3-pip supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy requirements first (better caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

# Copy the rest of the bot
COPY . .

# Add Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose necessary ports
EXPOSE 8000

# Start Supervisor (manages both gunicorn + python3 main.py)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]




