#!/bin/sh
set -eu

docker rm -fv ipfs-brave || true

# IPFS_VERSION
# BRAVE_IPFS_VERSION

docker build -t ipfs-brave -f Dockerfile-linux .

docker run --name ipfs-brave -d ipfs-brave
docker cp ipfs-brave:/ipfs-$IPFS_VERSION/src/or/ipfs ipfs-$IPFS_VERSION-linux-brave-$BRAVE_IPFS_VERSION

if ! ldd ipfs-$IPFS_VERSION-linux-brave-$BRAVE_IPFS_VERSION 2>&1 \
       | egrep -q 'not a dynamic executable'; then
  printf >&2 'failed to make a statically linked ipfs executable'
  exit 1
fi
