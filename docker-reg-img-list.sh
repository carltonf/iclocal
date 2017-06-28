#!/bin/bash
# %W% %G% %U%
#
#	View private registry v2,	require $LOCAL_DOCKER_REG_ROOTDIR is mounted locally
#
# Learned From https://github.com/BradleyA/Search-docker-registry-v2-script.1.0
#

#	Enter the full path to your private registry v2
LOCAL_DOCKER_REG_ROOTDIR="/vagrant/public/docker-registry"

echo "* List all images in $LOCAL_DOCKER_REG_ROOTDIR:"
TMPFILE=$(mktemp)

# An example of unfiltered path of imagehlp
# : $LOCAL_DOCKER_REG_ROOTDIR/docker/registry/v2/repositories/carltonf/jekyll-toolbox/_manifests/tags/20160808/current
find $LOCAL_DOCKER_REG_ROOTDIR -print \
    | grep -o 'v2/repositories/.*/current$'                       \
    | sed -e 's/\/_manifests\/tags\//:/'                          \
          -e 's/\/current//'                                      \
          -e 's/^.*repositories\//    /'                          \
    | sort | tee $TMPFILE

num_imgs=`wc -l $TMPFILE | awk {'print $1'}`
total_size=`du -hs $LOCAL_DOCKER_REG_ROOTDIR | awk {'print $1'}`
echo "Number of images: $num_imgs"
echo "Disk space used: $total_size"

# clean up
rm $TMPFILE
