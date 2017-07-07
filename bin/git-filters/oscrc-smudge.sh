#!/bin/bash

PASS=$(pass work/i_obs-passx | head -n1)
sed -e "s/^#\(passx\?\)=.*/\1=$PASS/g"
