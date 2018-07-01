#!/bin/sh
./configure --prefix=/usr \
    --enable-kvm \
    --disable-xen \
    --enable-debug-info \
    --enable-debug \
    --enable-gtk \
    --enable-vhost-net \
    --disable-debug-tcg \
    --enable-opengl \
    --target-list=x86_64-softmmu
