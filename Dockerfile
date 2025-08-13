FROM nvcr.io/nvidia/l4t-pytorch:r35.5.0-pth2.1-py3

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# Cài thêm thư viện hệ thống
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libgl1 \
    libglib2.0-0 \
    librdkafka-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Numpy trước để tránh lỗi
RUN pip3 install --upgrade pip && pip3 install numpy

# Install requirements
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Install deep-person-reid
RUN pip3 install git+https://github.com/KaiyangZhou/deep-person-reid.git

# Copy source
WORKDIR /app
COPY . .

CMD ["python3", "your_script.py"]
