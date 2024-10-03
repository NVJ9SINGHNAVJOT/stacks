#!/bin/bash

# Create the proxy network (external)
create_proxy_network() {
  if check_network_exists "proxy"; then
    echo "Network 'proxy' already exists."
  else
    echo "Creating external network 'proxy'..."
    docker network create --driver bridge --external "proxy"
    echo "'proxy' network created."
  fi
}

create_proxy_network