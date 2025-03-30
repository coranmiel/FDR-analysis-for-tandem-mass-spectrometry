#!/bin/bash

TSV_FILE="/tear/PXD004452/only_incorrect.tsv"
INPUT_DIR="/tear"
OUTPUT_DIR="./answers"

mkdir -p "$OUTPUT_DIR"

TOTAL_FILES=$(tail -n +2 "$TSV_FILE" | wc -l)
PROCESSED_FILES=0

tail -n +2 "$TSV_FILE" | while IFS=$'\t' read -r name scan; do
    INPUT_FILE="$INPUT_DIR$name"
    FILTER="index $scan"

    msconvert "$INPUT_FILE" --mgf -o "$OUTPUT_DIR" --filter "$FILTER"

    ORIGINAL_MGF="$OUTPUT_DIR/$(basename "$name" .mzML).mgf"
    OUTPUT_NAME="$(basename "$name" .mzML)_scan$((scan + 1)).mgf"
    OUTPUT_FILE="$OUTPUT_DIR/$OUTPUT_NAME"

    if [[ -f "$ORIGINAL_MGF" ]]; then
        mv "$ORIGINAL_MGF" "$OUTPUT_FILE"
    else
        echo "Error: File $ORIGINAL_MGF not found!" >&2
    fi

    PROCESSED_FILES=$((PROCESSED_FILES + 1))
    echo "Processed files: $PROCESSED_FILES of $TOTAL_FILES"
done

echo "All files processed!"
