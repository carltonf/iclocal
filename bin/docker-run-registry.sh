#!/bin/sh

# NOTE `--rm` is added as restarting registry container doesn't seem to work
# with vboxsf
docker run --rm -d -p 5000:5000 --name registry \
      -v /vagrant/public/docker-registry:/var/lib/registry \
      registry:2
