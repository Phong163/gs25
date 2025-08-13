# Sử dụng base image ubuntu:22.04
FROM ubuntu:22.04

# Thiết lập biến môi trường
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# Cài đặt các gói hệ thống cần thiết
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
    libpng-dev \
    libjpeg-dev \
    libopenjp2-7-dev \
    libtiff5-dev \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cài numpy trước để tránh lỗi khi install deep-person-reid
RUN pip3 install numpy

# Cài torch CPU trước (nếu cần cho deep-person-reid)
RUN pip3 install torch --index-url https://download.pytorch.org/whl/cpu

# Cài requirements chung trước
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Cài deep-person-reid sau
RUN pip3 install git+https://github.com/KaiyangZhou/deep-person-reid.git

# Sao chép mã nguồn
WORKDIR /app
COPY . .

# Lệnh mặc định khi chạy container
CMD ["python3", "main_metric5.py"]
