#!/bin/bash

# Start the controller and model_worker in the background
cd /usr/src/app

echo "Starting controller"
python3 -m fastchat.serve.controller --host "127.0.0.1" >> output.txt &
echo "Controller started. Waiting 30 seconds"
end=$((SECONDS+30))
while [ $SECONDS -lt $end ]; do tail -c 500 output.txt; sleep 1; done

echo "Starting worker"
python3 -m fastchat.serve.model_worker --model-path anon8231489123/vicuna-13b-GPTQ-4bit-128g --model-name vicuna-gptq --wbits 4 --groupsize 128 --host "127.0.0.1" --worker-address "http://127.0.0.1:21002" --controller-address "http://127.0.0.1:21001" >> output.txt &
echo "Worker started. Waiting 30 seconds"
end=$((SECONDS+30))
while [ $SECONDS -lt $end ]; do tail -c 500 output.txt; sleep 1; done

# Start the application
echo "Starting API"
python3 -m fastchat.serve.api --host 127.0.0.1 --port 8000 >> output.txt &
echo "API started. Waiting 10 seconds before sharing URL"
end=$((SECONDS+10))
while [ $SECONDS -lt $end ]; do tail -c 500 output.txt; sleep 1; done

echo "Starting ngrok";
./ngrok http 127.0.0.1:8000 &
echo "Waiting for 10 seconds to be ready"
sleep 10

# Print the result of the curl call
curl -s "http://127.0.0.1:4040/api/tunnels"