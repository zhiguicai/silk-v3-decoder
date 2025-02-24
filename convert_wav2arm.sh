#!/bin/bash
# File: wav_to_amr_converter.sh
# Description: Convert WAV audio files to AMR format with fixed output path.
# Usage: sh wav_to_amr_converter.sh input_file.wav

# Fixed output directory
OUTPUT_DIR="/usr/app/tmp"

# Function to print error messages and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Validate input parameters
if [ "$#" -ne 1 ]; then
    error_exit "Usage: $0 <input_file.wav>"
fi

INPUT_FILE="$1"
FILENAME=$(basename -- "$INPUT_FILE")
EXTENSION="${FILENAME##*.}"
FILENAME="${FILENAME%.*}"

# Validate input file existence
if [ ! -f "$INPUT_FILE" ]; then
    error_exit "Input file $INPUT_FILE does not exist."
fi

# Validate input format (optional enhancement)
if [ "$EXTENSION" != "wav" ] && [ "$EXTENSION" != "WAV" ]; then
    error_exit "Only WAV files are supported as input."
fi

# Set output file path
OUTPUT_FILE="$OUTPUT_DIR/${FILENAME}.amr"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR" || error_exit "Failed to create output directory."

# Perform conversion with optimized parameters
ffmpeg -i "$INPUT_FILE" -ar 8000 -ac 1 -c:a libopencore_amrnb "$OUTPUT_FILE" -y >/dev/null 2>&1

# Check conversion status
if [ $? -ne 0 ]; then
    error_exit "Conversion of $INPUT_FILE failed. Please check: 1) Input file validity 2) FFmpeg installation 3) Codec support."
fi

# Verify output file existence
if [ ! -f "$OUTPUT_FILE" ]; then
    error_exit "Output file $OUTPUT_FILE was not generated successfully."
fi

# Optional success indication (silent by default)
echo "Conversion successful: ${OUTPUT_FILE}"