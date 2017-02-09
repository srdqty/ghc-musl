#!/usr/bin/env bash

docker build -t ghc-8.0.1-cross ghc-cross/
id=$(docker create ghc-8.0.1-cross)
docker cp $id:/ghc-8.0.1-x86_64-unknown-linux-musl.tar.xz ghc-musl/ghc-8.0.1-x86_64-unknown-linux-musl.tar.xz
docker rm -v $id
