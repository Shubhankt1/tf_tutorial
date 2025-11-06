#!/bin/bash
set -e

# Update and install dependencies
sudo apt update
sudo apt install -y python3-venv openssl

# Create folder for FastAPI
mkdir -p /home/ubuntu/fastapi-test
cd /home/ubuntu/fastapi-test

# Create virtual environment
python3 -m venv venv

# Activate venv and install FastAPI + uvicorn
source venv/bin/activate
pip install --upgrade pip
pip install fastapi uvicorn

# Write FastAPI app directly
cat <<'EOF' > app.py
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello HTTPS from FastAPI!"}

@app.get("/ping")
def ping():
    return {"status": "ok"}
EOF

# Generate self-signed certificate (overwrite if exists)
openssl req -x509 -newkey rsa:2048 \
  -keyout key.pem -out cert.pem -days 365 -nodes \
  -subj "/C=US/ST=State/L=City/O=Test/CN=localhost"

# Start FastAPI server in background using venv
nohup ./venv/bin/uvicorn app:app \
  --host 0.0.0.0 --port 443 \
  --ssl-keyfile key.pem --ssl-certfile cert.pem &
