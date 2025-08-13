# Sử dụng base image python:3.11-slim
FROM python:3.11-slim

# Thiết lập biến môi trường
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# Cài đặt các gói hệ thống cần thiết
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libgl1 \
    libglib2.0-0 \
    librdkafka-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cài numpy trước để tránh lỗi khi install deep-person-reid
RUN pip install numpy

# Cài requirements chung trước (không chứa deep-person-reid)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Cài deep-person-reid sau (nó cần numpy đã có sẵn)
RUN pip install git+https://github.com/KaiyangZhou/deep-person-reid.git

# Sao chép mã nguồn
WORKDIR /app
COPY . .

# Lệnh mặc định khi chạy container
CMD ["python3", "main_metric5.py", "--send_api", "--store_id", "vn316"]
