FROM python:3.8-slim

RUN apt update -y && apt install awscli -y
WORKDIR /app

# Copy only requirements.txt first to leverage Docker caching for pip install
COPY requirements.txt /app/

RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY . /app


RUN pip install --upgrade accelerate
RUN pip uninstall -y transformers accelerate
RUN pip install transformers accelerate

CMD ["python3", "app.py"]
