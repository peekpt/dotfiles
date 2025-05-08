#!/bin/bash

# Script to resize all images in ~/Wallpapers to 1920x1080
# This script creates a backup of original images before modifying them

# Configuration
WALLPAPER_DIR="$HOME/Wallpapers"
BACKUP_DIR="$HOME/Wallpapers_backup"
TARGET_SIZE="1920x1080"

# Check if the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: $WALLPAPER_DIR directory does not exist"
    exit 1
fi

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed. Please install it first."
    exit 1
fi

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create backup directory"
        exit 1
    fi
fi

# Find all image files
echo "Finding image files..."
IMAGES=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

# Check if any images were found
if [ -z "$IMAGES" ]; then
    echo "Error: No image files found in $WALLPAPER_DIR"
    exit 1
fi

# Count total images
TOTAL_IMAGES=$(echo "$IMAGES" | wc -l)
echo "Found $TOTAL_IMAGES images to process"

# Process each image
COUNTER=0
echo "$IMAGES" | while IFS= read -r IMAGE; do
    # Update counter
    ((COUNTER++))
    
    # Get filename
    FILENAME=$(basename "$IMAGE")
    
    echo "[$COUNTER/$TOTAL_IMAGES] Processing: $FILENAME"
    
    # Backup original
    echo "  - Backing up to $BACKUP_DIR/$FILENAME"
    cp "$IMAGE" "$BACKUP_DIR/"
    if [ $? -ne 0 ]; then
        echo "  - Warning: Failed to backup $FILENAME"
    fi
    
    # Resize image
    echo "  - Resizing to $TARGET_SIZE"
    convert "$IMAGE" -resize "$TARGET_SIZE^" -gravity center -extent "$TARGET_SIZE" "$IMAGE.tmp"
    if [ $? -eq 0 ]; then
        mv "$IMAGE.tmp" "$IMAGE"
        echo "  - Successfully resized"
    else
        echo "  - Error: Failed to resize $FILENAME"
        rm -f "$IMAGE.tmp" # Clean up failed temp file
    fi
done

echo "All done! Original images are backed up in $BACKUP_DIR"
echo "You may now run change_wallpaper.sh to set a resized wallpaper"

