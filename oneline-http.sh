#!/bin/sh

# Ref: https://gist.github.com/willurd/5720255

function is_port_used {
  local port=$1
  # NOTE: pay attention to string interpolation
  local is_used=$(lsof -i4 -n -P | grep "$port.*LISTEN")
  if [ x"$is_used" != x ]; then
    echo true
  else
    echo false
  fi
}

function get_port_unused {
  local port=$1
  while [ $(is_port_used $port) = "true" ]; do
    port=$((port + 1))
  done
  echo $port
}

# NOTE: default port and port auto-correction
PORT=8000
PORT=$(get_port_unused $PORT)
# echo "Http server is using port: $PORT"

DBG=exec
which python3 &>/dev/null
if [ $? -eq 0 ];then
  #NOTE: Prefer python3
  $DBG python3 -m http.server $PORT
else
  $DBG python2 -m SimpleHTTPServer $PORT
fi
