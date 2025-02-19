#!/bin/bash
# Filename: monitoring.sh
# Purpose: Start DAMO monitoring on the server, run the client, then stop monitoring.
#          If interrupted (e.g. via Control+C), clean up by killing the server and stopping DAMO.

# --- Define a cleanup function to handle interruptions ---
cleanup() {
  echo "Interrupt received. Killing server and stopping DAMO monitoring..."
  pkill -f thumbnailer.py      # Kill the server process
  sudo damo stop               # Stop DAMO monitoring
  exit 1
}

# Trap SIGINT and SIGTERM signals to run the cleanup function
trap cleanup SIGINT SIGTERM

# === 1. Start the server under DAMO monitoring ===
# Start DAMO recording on the server; output saved to "damo_output_data".
sudo damo record  "python3.13 ./thumbnailer.py" &
monitor_pid=$!

# Allow some time for the server to initialize.
sleep 5

# === 2. Run the client iterations ===
# Run the client (without the --size parameter) that sends requests to the server.
python3 client_thumbnailer.py

# === 3. Stop DAMO monitoring and the server ===
# Kill the server process.
pkill -f thumbnailer.py

# Stop DAMO monitoring.
sudo damo stop

# Wait for the DAMO recording process to exit gracefully.
wait $monitor_pid

echo "Monitoring stopped. Check damo_output_data for the recording."
