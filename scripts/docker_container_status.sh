# Function to check if the container exists
does_container_exist() {
    local container_name="$1"

    # Exit if no container name is given
    if [ -z "$container_name" ]; then
        echo "Error: No container name provided."
        exit 1
    fi

    docker inspect --type container "$container_name" > /dev/null 2>&1
}

# Function to check if the container is running
is_container_running() {
    local container_name=$1

        # Exit if no container name is given
    if [ -z "$container_name" ]; then
        echo "Error: No container name provided."
        exit 1
    fi
    
    # Get the container's status using inspect and check if it's running
    local status=$(docker inspect -f '{{.State.Status}}' "$container_name" 2>/dev/null)
    
    if [ "$status" == "running" ]; then
        return 0 # True (running)
    else
        return 1 # False (not running)
    fi
}