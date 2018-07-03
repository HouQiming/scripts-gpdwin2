#!/bin/sh
# for Qemu 2.12 you should add "display=off" option when you create VM without dma-buf.
#todo: set up better networking - right now it's qemu's default
UUID=2aee154e-7d0d-11e8-88b8-6f45320c7162
AUDIO_DEV=0000\:00\:1f.3
#QEMU_AUDIO_DRV=pa
#QEMU_PA_SERVER=/run/user/1000/pulse/native
#QEMU_AUDIO_DRV=alsa
#QEMU_ALSA_DAC_BUFFER_SIZE=4096
#DISPLAY=:0
#-soundhw hda
modprobe vfio-pci
echo "$UUID" > /sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_4/create
echo $AUDIO_DEV > /sys/bus/pci/devices/$AUDIO_DEV/driver/unbind
echo `cat /sys/bus/pci/devices/$AUDIO_DEV/vendor` `cat /sys/bus/pci/devices/$AUDIO_DEV/device` > /sys/bus/pci/drivers/vfio-pci/new_id
echo $AUDIO_DEV > /sys/bus/pci/drivers/vfio-pci/bind
#-serial mon:stdio
qemu-system-x86_64 \
  -name gvt-g-guest \
  -k en-us \
  -serial stdio \
  \
  -m 4096 -smp 2,sockets=1,cores=2 -M pc \
  -cpu host \
  -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1 \
  -machine kernel_irqchip=on \
  \
  -bios /usr/share/qemu/OVMF.fd -enable-kvm \
  \
  -display gtk,gl=on,grab_on_hover=on -full-screen\
  -vga none \
  -device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:00:02.0/$UUID,display=on,x-igd-opregion=on \
  \
  -drive if=ide,id=hd,file=./win10_clean.qcow2,format=qcow2,cache=writeback,aio=threads \
  \
  -netdev user,id=user.0,smb=/home/a/vm/shared -device e1000,romfile=,netdev=user.0 \
  \
  -device vfio-pci,host=00:1f.3 \
  -usb -device usb-tablet \
  -device usb-host,vendorid=0x0079,productid=0x18d4 \
  ;
echo $AUDIO_DEV > /sys/bus/pci/devices/$AUDIO_DEV/driver/unbind
echo $AUDIO_DEV > /sys/bus/pci/drivers/snd_hda_intel/bind
echo 1 > /sys/bus/pci/devices/0000:00:02.0/$UUID/remove
