FROM alpine:latest

RUN apk --no-cache add curl xz alpine-sdk perl gmp-dev file gmp openssh openssl zlib-dev strace vim less jq ncurses-dev bash autoconf

COPY ghc-8.0.1-x86_64-unknown-linux-musl.tar.xz /tmp/ghc/
COPY build.mk /tmp/

RUN : "Layer 1: fully working basic GHC in /usr/local" && \
    cd /tmp && \
    wget https://nixos.org/releases/patchelf/patchelf-0.8/patchelf-0.8.tar.bz2 && \
    tar xfj patchelf-0.8.tar.bz2 && \
    cd patchelf-0.8 && \
    ./configure && make install && \
    cd .. && \
    rm -rf patchelf* && \
    tar -xvJ -C / -f /tmp/ghc/ghc-8.0.1-x86_64-unknown-linux-musl.tar.xz && \
    cd /tmp/ghc && \
    wget https://www.haskell.org/ghc/dist/8.0.1/ghc-8.0.1-src.tar.xz && \
    tar xvfJ ghc-8.0.1-src.tar.xz && \
    cd /tmp/ghc/ghc-8.0.1 && \
    cp -v /tmp/build.mk mk/build.mk && \
    PATH=/opt/ghc-cross/bin:$PATH ./configure && \
    : "libffi has a bug, which we patch here" && \
    sed -i 's,chmod,sed -i s/__gnu_linux__/1/ libffi/build/src/closures.c \&\& chmod,' libffi/ghc.mk && \
    make -j8 && \
    make binary-dist && \
    cd /tmp && \
    mv ghc/ghc-8.0.1/ghc-8.0.1-x86_64-unknown-linux.tar.xz . && \
    rm -rf ghc /opt/ghc-cross && \
    : && \
    : end of build, but we want to minimize docker layer sizes && \
    : so we extract ghc here and delete the tarball && \
    : && \
    tar xvfJ ghc-8.0.1-x86_64-unknown-linux.tar.xz && \
    cd ghc-8.0.1 && \
    ./configure && \
    : musl ld requires --no-pie to work for some reason with ghc && \
    sed -i '/C\ compiler\ link/{ s/""/"--no-pie"/ }' settings && \
    make install && \
    cd /tmp && \
    rm -rf ghc-8.0.1 ghc-8.0.1-x86_64-unknown-linux.tar.xz

CMD /bin/sh
