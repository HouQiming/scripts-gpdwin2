#!/bin/sh
./configure --prefix=/usr \
    --enable-kvm \
    --disable-xen \
    --disable-debug-info \
    --enable-libusb \
    --enable-gtk \
    --enable-vhost-net \
    --disable-debug-tcg \
    --enable-opengl \
    --target-list=x86_64-softmmu
