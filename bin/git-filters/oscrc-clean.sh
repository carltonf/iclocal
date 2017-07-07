#!/bin/bash

# Do not commit trusted prj and mask out password
sed -e 's/^\(trusted_prj\)=.*/\1=/g' \
	| sed -e 's/^\(passx\?\)=.*/#\1=notsecret/g'
