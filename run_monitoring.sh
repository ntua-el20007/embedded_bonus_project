#!/bin/bash
# Filename: run_monitoring.sh
# Purpose: Start DAMO monitoring on the server, run the client, then stop monitoring

# === 1. Start the server under DAMO monitoring ===
# This starts damo recording the server's memory accesses.
# The output will be stored in "damo_output_data"
sudo damo record --out damo_output_data "python3.13 ./thumbnailer.py" &
monitor_pid=$!

# Allow some time for the server to initialize
sleep 5

# === 2. Run the client iterations ===
# Run the client (without the --size parameter) that sends requests to the server.
python3 client_thumbnailer.py

# === 3. Notify DAMO to stop monitoring ===
sudo damo stop

# Optionally wait for the damo record process to exit gracefully
wait $monitor_pid

echo "Monitoring stopped. Check damo_output_data for the recording."

