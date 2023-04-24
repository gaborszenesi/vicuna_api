#!/bin/bash

# Start the controller and model_worker in the background
echo "Starting controller"
python -m fastchat.serve.controller --host "127.0.0.1" &
echo "Controller started. Waiting 30 seconds"
sleep 30
echo "Starting worker"
python -m fastchat.serve.model_worker --model-path anon8231489123/vicuna-13b-GPTQ-4bit-128g --model-name vicuna-gptq --wbits 4 --groupsize 128 --host "127.0.0.1" --worker-address "http://127.0.0.1:21002" --controller-address "http://127.0.0.1:21001" &
echo "Worker started. Waiting 30 seconds"
sleep 30
# Start the application
echo "Starting API"
python -m fastchat.serve.api --host 127.0.0.1 --port 8000 &
echo "API started. Waiting 10 seconds before sharing URL"
# Wait for the application to be ready
sleep 10

# Run ngrok
./ngrok http 127.0.0.1:8000 &

# Wait for ngrok to be ready
sleep 10

# Print the result of the curl call
curl -s "http://127.0.0.1:4040/api/tunnels"