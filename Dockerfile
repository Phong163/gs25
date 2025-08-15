FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1
ENV CUDA_PATH=/usr/local/cuda
ENV PATH=$CUDA_PATH/bin:$PATH
ENV LD_LIBRARY_PATH=$CUDA_PATH/lib64:$LD_LIBRARY_PATH

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-dev python3-pip \
    build-essential cmake git \
    libgl1 libglib2.0-0 libsm6 libxext6 libxrender-dev \
    librdkafka-dev libcudnn8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel
RUN pip install numpy

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN pip install git+https://github.com/KaiyangZhou/deep-person-reid.git

WORKDIR /app
COPY . .

CMD ["python3", "main_metric5.py"]
