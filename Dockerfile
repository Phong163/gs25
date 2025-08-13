FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-dev \
    python3-pip \
    build-essential \
    cmake \
    git \
    libgl1 \
    libglib2.0-0 \
    librdkafka-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install numpy
COPY requirements.txt .
RUN pip3 install -r requirements.txt
RUN pip3 install git+https://github.com/KaiyangZhou/deep-person-reid.git

WORKDIR /app
COPY . .

CMD ["python3", "main_metric5.py", "--send_api", "--store_id", "vn316"]
