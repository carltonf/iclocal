#!/bin/sh
# a simple script that enable search 'sourceforge' and 'github' simultaneously
# features:
# 1. support 'space'
# todo:
# 1. make one page that displayed results from two sites
# 2. ?Q: enable advanced search feature?
# 3. add possible other sites to search

BROWSER=firefox

if [[ $# < 1 ]]; then
    echo "Usage: what to search"
    exit -1
fi

query=$(echo $* | sed 's|\ |+|g')

# this one can't be used
# "$BROWSER http://code.google.com/query/#q=$query &"
$BROWSER "http://sourceforge.net/directory/?q=$query"
$BROWSER "https://github.com/search?q=$query&type=Everything&repo=&langOverride=&start_value=1"
$BROWSER "http://stackoverflow.com/search?q=$query"
