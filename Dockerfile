FROM python:3.8-slim-buster

# Install system dependencies and build tools
RUN apt update -y && \
    apt install -y --no-install-recommends \
    awscli \
    gcc \
    build-essential \
    libffi-dev \
    python3-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only requirements.txt first to leverage Docker caching for pip install
COPY requirements.txt /app/

# Upgrade pip and install dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app

# Handle specific library installation
RUN pip install --upgrade accelerate && \
    pip uninstall -y transformers accelerate && \
    pip install transformers accelerate

# Set the default command
CMD ["python3", "app.py"]
