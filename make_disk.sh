#!/bin/sh
ENABLE_TRACE=true
###
if $ENABLE_TRACE ; then
	echo 163840 > /sys/kernel/debug/tracing/buffer_size_kb
	echo 1 > /sys/kernel/debug/tracing/events/dwc3/enable
	echo 1 > /sys/kernel/debug/tracing/events/ucsi/enable
fi
###
#VENDOR_ID=0x04e8
#PRODUCT_ID=0x61f3
VENDOR_ID=0x0525
PRODUCT_ID=0x1234
modprobe usb_f_tcm
modprobe nbd
#modprobe tcm_usb_gadget 
modprobe libcomposite
if $ENABLE_TRACE ; then
	echo 1 > /sys/kernel/debug/tracing/events/target/enable
fi
cd /sys/kernel/config/usb_gadget
mkdir tcm
cd tcm
mkdir functions/tcm.0
#######
DEVICE=/dev/nbd0
qemu-nbd --cache=writeback --aio=threads --discard=unmap -c $DEVICE /home/a/vm/win10_clean.qcow2
printf "=== waiting for nbd\n"
sleep 1s
#######
cd /sys/kernel/config/target/
#mkdir -p core/fileio_0/fileio
#echo "fd_dev_name=/home/a/disk.bin,fd_dev_size=10737418240" > core/fileio_0/fileio/control
##echo 1 > core/fileio_0/fileio/enable
mkdir -p core/iblock_0/block
echo "udev_path=${DEVICE}" > core/iblock_0/block/control
echo 1 > core/iblock_0/block/enable
##
mkdir -p usb_gadget
cd usb_gadget
mkdir naa.6001405c3214b06a
cd naa.6001405c3214b06a
mkdir tpgt_1
cd tpgt_1
mkdir lun/lun_0
#ln -s ../../../core/fileio_0/fileio lun/lun_0/virtual_scsi_port
ln -s ../../../core/iblock_0/block lun/lun_0/virtual_scsi_port
echo naa.6001405c3214b06a > nexus
echo 15 > maxburst
echo 1 > enable
#######
cd /sys/kernel/config/usb_gadget/tcm
mkdir configs/c.1
ln -s functions/tcm.0 configs/c.1
echo $VENDOR_ID > idVendor
echo $PRODUCT_ID > idProduct
echo dwc3.0.auto > UDC
