#!/bin/sh
UUID=2aee154e-7d0d-11e8-88b8-6f45320c7162
echo "$UUID" > /sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_4/create
#echo 1 > /sys/bus/pci/devices/0000:00:02.0/$UUID/remove
