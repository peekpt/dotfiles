#!/bin/bash

# Script to set a random wallpaper from ~/Wallpapers using hyprpaper

WALLPAPER_DIR="$HOME/Wallpapers"
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"

# Check if the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: $WALLPAPER_DIR directory does not exist"
    exit 1
fi

# Find all image files in the directory
IMAGES=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

# Check if any images were found
if [ -z "$IMAGES" ]; then
    echo "Error: No image files found in $WALLPAPER_DIR"
    exit 1
fi

# Select a random image
RANDOM_IMAGE=$(echo "$IMAGES" | shuf -n 1)

echo "Setting wallpaper: $RANDOM_IMAGE"

# Check if hyprpaper is installed
if ! command -v hyprpaper &> /dev/null; then
    echo "Error: hyprpaper command not found. Please install hyprpaper."
    exit 1
fi

# Check if hyprctl is installed
if ! command -v hyprctl &> /dev/null; then
    echo "Error: hyprctl command not found. Is Hyprland installed?"
    exit 1
fi

# Check if hyprpaper is running
if ! pgrep -x "hyprpaper" &> /dev/null; then
    echo "Starting hyprpaper..."
    
    # Start hyprpaper in the background
    if [ -f "$HYPRPAPER_CONFIG" ]; then
        hyprpaper &
    else
        # Create a minimal config if it doesn't exist
        mkdir -p "$(dirname "$HYPRPAPER_CONFIG")"
        echo "preload = $RANDOM_IMAGE" > "$HYPRPAPER_CONFIG"
        hyprpaper &
    fi
    
    # Wait for hyprpaper to initialize
    echo "Waiting for hyprpaper to initialize..."
    sleep 2
fi

# Set the wallpaper using hyprpaper
echo "Setting wallpaper with hyprpaper..."
# For all monitors
for MONITOR in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper preload "$RANDOM_IMAGE"
    hyprctl hyprpaper wallpaper "$MONITOR,$RANDOM_IMAGE"
done
echo "Wallpaper set successfully!"

