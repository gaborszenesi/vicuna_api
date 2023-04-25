FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04
WORKDIR /usr/src/app

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV TORCH_CUDA_ARCH_LIST="7.5"

# Update package index, install tzdata, and configure the time zone
RUN echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure -f noninteractive tzdata

# Install packages
RUN apt-get install -y --no-install-recommends wget python3-pip python3-dev git build-essential make cmake lsb-release screen zip unzip curl
RUN pip install jupyterlab

# Upgrade pip
RUN pip3 install --upgrade --no-cache-dir pip
RUN pip3 install shortuuid

# Download ngrok binary
RUN wget -q -c -nc https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip

# Unzip ngrok binary
RUN unzip -qq -n ./ngrok-stable-linux-amd64.zip

COPY --chmod=0777 . ./

RUN pip3 install -e .

RUN cd ./repositories/GPTQ-for-LLaMa && python3 ./setup_cuda.py install

RUN mkdir ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g

RUN echo "Downloading model files..." && \
    wget -P ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g --show-progress http://185.51.190.195/vicuna/config.json && \
    wget -P ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g --show-progress http://185.51.190.195/vicuna/generation_config.json && \
    wget -P ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g --show-progress http://185.51.190.195/vicuna/gitattributes.txt && \
    wget -P ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g --show-progress http://185.51.190.195/vicuna/pytorch_model.bin.index.json && \
    wget -P ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g --show-progress http://185.51.190.195/vicuna/README.md && \
    wget -P ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g --show-progress http://185.51.190.195/vicuna/special_tokens_map.json && \
    wget -P ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g --show-progress http://185.51.190.195/vicuna/tokenizer.model && \
    wget -P ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g --show-progress http://185.51.190.195/vicuna/tokenizer_config.json && \
    wget -P ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g --show-progress http://185.51.190.195/vicuna/vicuna-13b-4bit-128g.safetensors

RUN chmod 777 ./scripts/entrypoint.sh

CMD ["./scripts/entrypoint.sh"]