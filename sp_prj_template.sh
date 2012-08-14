#!/bin/sh
# shell scripts contains information for Advanced Softap Development
#
# NOTE:
# 1. 'SP_' prefix are preserved for variables used by sp_prj_lib, so don't name your variables with this

# super project name
export SP_PRJ_NAME="Your Project Name"

export SP_ROOT="/home/yours/project/root"

# contained project list
# all just uses 'path' as 'name' relative to the ${SP_ROOT}
export SP_PRJ_LIST=(                            \
    related/part1/component1                    \
    related/part2/c2                            \
)

# the projects the last operation was on
export SP_CURRENT_PROJS=

# this script's path for sp_reload
export SP_PRJ_CONF_PATH=$( cd "$( dirname "$0" )" && pwd )/$(basename "$0")

################################################################ 
# custom env variables you can add variables of your own, 

export BUILD_TOP=$SP_ROOT
export PRODUCT_OUT="the/output/path"

export OTHERS="$SP_ROOT/../others"

################################################################ 
# load library
. ~/bin/sp_prj_lib.sh
