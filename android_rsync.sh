#!/bin/bash

if [ -d "$ANDROID_BUILD_TOP" ]; then
    echo "** error: you are not in Android build root";
else
    cd $ANDROID_BUILD_TOP
    echo "** ok, start rsyncing";
    rsync -avuz --exclude=.repo/ --exclude=.git/ `pwd` dev-tplink:
fi

