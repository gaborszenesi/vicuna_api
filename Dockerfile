FROM nvidia/cuda:11.7.0-devel-ubuntu20.04
WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget python3-pip git build-essential make cmake lsb-release screen && \
    pip3 install --upgrade --no-cache-dir pip && \
    wget -q -c -nc https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && \
    unzip -qq -n ./ngrok-stable-linux-amd64.zip

COPY --chmod=0777 . ./

RUN pip3 install -e . && \
    python3 ./repositories/GPTQ-for-LLaMa/setup_cuda.py install && \
    mkdir ./models/anon8231489123_vicuna-13b-GPTQ-4bit-128g

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