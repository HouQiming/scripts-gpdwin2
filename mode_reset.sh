#!/bin/sh
echo device > /sys/class/typec/port0/data_role
printf "05080200" | xxd -r -p | dd of=/dev/mem bs=4 count=1 seek=3741483224 oflag=seek_bytes 2>/dev/null
sleep 1s
printf "host : "; dd if=/dev/mem bs=4 count=2 skip=3741483224 iflag=skip_bytes 2>/dev/null | xxd -p
printf "06083001" | xxd -r -p | dd of=/dev/mem bs=4 count=1 seek=3741483224 oflag=seek_bytes 2>/dev/null
sleep 1s
printf "device : "; dd if=/dev/mem bs=4 count=2 skip=3741483224 iflag=skip_bytes 2>/dev/null | xxd -p
