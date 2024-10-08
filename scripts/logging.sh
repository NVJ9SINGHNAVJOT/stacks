#!/bin/bash

# Logging functions

# Function to get the current timestamp
current_time() {
    date +"%Y-%m-%dT%H:%M:%S%z"
}

# Function to log information messages
loginf() {
    echo -e "$(current_time) \e[1;34m[INF]\e[0m $1"  # Bright blue for [INF]
}

# Function to log error messages
logerr() {
    echo -e "$(current_time) \e[1;31m[ERR]\e[0m \e[0;31m$1\e[0m"  # Bright red for [ERR] and dull red for message
}

# Function to log warning messages
war() {
    echo -e "$(current_time) \e[1;33m[WAR]\e[0m $1"  # Yellow for [WAR]
}

# Function to log logsuccess messages
logsuccess() {
    echo -e "$(current_time) \e[1;32m[SUCCESS]\e[0m $1"  # Bright green for [SUCCESS]
}
