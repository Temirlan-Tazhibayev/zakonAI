# Use a base Python image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

COPY . /app/


# Скачиваем файл с помощью wget в папку /app/data
RUN wget -O /app/data/model-00001-of-00002.safetensors "https://huggingface.co/google/gemma-2-2b-it/resolve/main/model-00001-of-00002.safetensors?download=true"
RUN wget -O /app/data/model-00002-of-00002.safetensors "https://huggingface.co/google/gemma-2-2b-it/resolve/main/model-00002-of-00002.safetensors?download=true"

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    cmake \
    make \
    g++ \
    curl \
    wget \
    git \
    libopenblas-dev \
    libomp-dev \
    libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Install llama-cpp-python dependencies (example)
RUN python3 -m venv venv

RUN source venv/bin/activate


RUN pip install --upgrade pip setuptools wheel

RUN pip install -r requirements.txt

# Install llama-cpp-python
RUN pip install llama-cpp-python

# Install JupyterLab
RUN pip install jupyterlab

# Expose the port JupyterLab will run on
EXPOSE 8888

# Command to run JupyterLab when the container starts
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
