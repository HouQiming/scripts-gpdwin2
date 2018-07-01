#!/bin/sh
# for Qemu 2.12 you should add "display=off" option when you create VM without dma-buf.
#todo: set up better networking - right now it's qemu's default
UUID=2aee154e-7d0d-11e8-88b8-6f45320c7162
#DISPLAY=:0
qemu-system-x86_64 \
  -name gvt-g-guest \
  -k en-us \
  -serial mon:stdio \
  \
  -m 2048 -smp 2 -M pc \
  -cpu host \
  -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1 \
  -machine kernel_irqchip=on \
  \
  -bios /usr/share/qemu/OVMF.fd -enable-kvm \
  \
  -display gtk,gl=on \
  -vga none \
  -device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:00:02.0/$UUID,display=on,x-igd-opregion=on \
  \
  -drive if=ide,id=hd,file=./win10_clean.qcow2,format=qcow2,cache=writeback,aio=threads \
  \
  -netdev user,id=user.0,smb=/home/a/vm/shared -device e1000,romfile=,netdev=user.0 \
  \
  -usb -device usb-tablet \
  ;
