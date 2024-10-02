#!/bin/bash

# Check if the repository URL is provided as the first argument
if [ -z "$1" ]; then
    echo "Usage: $0 <repository_url> <destination_path> <file_path1> [<file_path2> ... <file_pathN>]"
    echo "Error: Repository URL not provided."
    exit 1
fi

# Check if the destination directory is provided as the second argument
if [ -z "$2" ]; then
    echo "Usage: $0 <repository_url> <destination_path> <file_path1> [<file_path2> ... <file_pathN>]"
    echo "Error: Destination directory not provided."
    exit 1
fi

# Check if at least one file path is provided
if [ $# -lt 3 ]; then
    echo "Usage: $0 <repository_url> <destination_path> <file_path1> [<file_path2> ... <file_pathN>]"
    echo "Error: At least one file path must be provided."
    exit 1
fi

# Assign the provided arguments to meaningful variable names
REPO_URL="$1"
DEST_DIR="$2"

# Check if the destination directory exists
if [ ! -d "$DEST_DIR" ]; then
    echo "Error: Destination directory '$DEST_DIR' does not exist."
    exit 1
fi

# Create a temporary directory for cloning the repository
TEMP_DIR=$(mktemp -d 2>/dev/null)

# Check if the temporary directory creation was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to create temporary directory."
    exit 1
fi

# Clone the repository into the temporary directory using --depth 1 for a shallow clone
git clone "$REPO_URL" "$TEMP_DIR" --depth 1

# Check if the cloning was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to clone the repository."
    rm -rf "$TEMP_DIR"  # Cleanup temporary directory on error
    exit 1
fi

# Loop through all the provided file paths (starting from the third argument)
for FILE_PATH in "${@:3}"; do
    # Construct the full destination file path
    DEST_FILE="$DEST_DIR/$(basename "$FILE_PATH")"
    
    # Check if the file exists in the destination directory
    if [ -f "$DEST_FILE" ]; then
        echo "Removing existing file at '$DEST_FILE'..."
        rm -f "$DEST_FILE"
        
        # Check if the deletion was successful
        if [ $? -ne 0 ]; then
            echo "Error: Failed to delete existing file '$DEST_FILE'."
            rm -rf "$TEMP_DIR"  # Cleanup temporary directory on error
            exit 1
        fi
    fi

    # Copy the specific file from the cloned repository to the destination directory
    cp "$TEMP_DIR/$FILE_PATH" "$DEST_DIR"

    # Check if the file copying was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to copy the file '$FILE_PATH'."
        rm -rf "$TEMP_DIR"  # Cleanup temporary directory on error
        exit 1
    fi

    echo "File '$FILE_PATH' cloned successfully to '$DEST_DIR'."
done

# Remove the temporary directory where the repository was cloned
rm -rf "$TEMP_DIR"

# Check if the temporary directory removal was successful
if [ $? -ne 0 ]; then
    echo "Warning: Failed to remove temporary directory '$TEMP_DIR'. Please clean up manually."
else
    echo "Temporary directory '$TEMP_DIR' removed successfully."
fi

# Print a success message indicating that all specified files were successfully cloned and moved
echo "All specified files cloned successfully to '$DEST_DIR'."
