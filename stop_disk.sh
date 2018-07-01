#!/bin/sh
echo 0 > /sys/kernel/debug/tracing/events/dwc3/enable
echo 0 > /sys/kernel/debug/tracing/events/ucsi/enable
echo 0 > /sys/kernel/debug/tracing/events/target/enable
echo '' > /sys/kernel/config/usb_gadget/tcm/UDC
rm /sys/kernel/config/usb_gadget/tcm/configs/c.1/tcm.0
rmdir /sys/kernel/config/usb_gadget/tcm/configs/c.1
echo 0 > /sys/kernel/config/target/usb_gadget/naa.6001405c3214b06a/tpgt_1/enable
rm /sys/kernel/config/target/usb_gadget/naa.6001405c3214b06a/tpgt_1/lun/lun_0/virtual_scsi_port
rmdir /sys/kernel/config/target/usb_gadget/naa.6001405c3214b06a/tpgt_1/lun/lun_0
rmdir /sys/kernel/config/target/usb_gadget/naa.6001405c3214b06a/tpgt_1
rmdir /sys/kernel/config/target/usb_gadget/naa.6001405c3214b06a
rmdir /sys/kernel/config/usb_gadget/tcm/functions/tcm.0
rmdir /sys/kernel/config/usb_gadget/tcm
rmdir /sys/kernel/config/target/core/iblock_0/block
rmdir /sys/kernel/config/target/core/iblock_0
qemu-nbd -d /dev/nbd0
