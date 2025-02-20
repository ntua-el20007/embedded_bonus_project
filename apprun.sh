#!/bin/bash

# Function to display menu and get choice
show_menu() {
    echo "Please choose an application to run:"
    echo "  1: Image Recognition (image_recognition)"
    echo "  2: Graph Pagerank (graph_pagerank)"
    echo "  3: DNA Visualization (dna_viz)"
    echo -n "Enter your choice (1-3): "
}

# Default iterations if not provided
DEFAULT_ITERATIONS=10

# Check if iterations provided as argument
if [ -z "$1" ]; then
    echo -n "Enter number of client iterations (default $DEFAULT_ITERATIONS): "
    read iterations
    iterations=${iterations:-$DEFAULT_ITERATIONS}
else
    iterations="$1"
    # Validate iterations is a positive integer
    if ! [[ "$iterations" =~ ^[0-9]+$ ]] || [ "$iterations" -le 0 ]; then
        echo "Error: Number of iterations must be a positive integer."
        exit 1
    fi
fi

# Show menu and get user choice
show_menu
read choice

# Map choice to directory
case "$choice" in
    1)
        app_dir="image_recognition"
        app_name="Image Recognition"
        ;;
    2)
        app_dir="graph_pagerank"
        app_name="Graph Pagerank"
        ;;
    3)
        app_dir="dna_viz"
        app_name="DNA Visualization"
        ;;
    *)
        echo "Error: Invalid choice. Please select 1, 2, or 3."
        exit 1
        ;;
esac

echo "Selected: $app_name with $iterations iterations"

# Start handler.py in the background
echo "Starting $app_name handler..."
sudo damo record "python3 ./$app_dir/handler.py" &

# Wait for 20 seconds to allow handler.py to initialize
echo "Waiting 20 seconds for handler to initialize..."
sleep 20

# Run client.py for specified number of iterations
echo "Running $app_name client for $iterations iterations..."
for ((i=1; i<=iterations; i++)); do
    echo "Starting run $i of client.py"
    python3 ./$app_dir/client.py
    if [ "$i" -lt "$iterations" ]; then
        sleep 1
    fi
done

# Wait for 1 second after the last client.py run
sleep 1

# Kill handler.py by name
echo "Terminating $app_name handler..."
pkill -f "python3 ./$app_dir/handler.py"

# Print completion message
echo "$app_name handler has been terminated."
