#!/bin/bash

DFU_UTIL=$(which dfu-util 2>/dev/null)
if [ -z "$DFU_UTIL" ] || ! $DFU_UTIL -w -V &>/dev/null
then
	echo "Install or update dfu-util from your distro should the provided one not work with your distro"
	DFU_UTIL=recovery/dfu-util
fi

# USB DFU device vendor and product ID used in the boot ROM, the R5 SPL and the A53 SPL
VID_PID_ROM="0451:6165"
VID_PID_R5="0451:6165"
VID_PID_A53="0451:6165"

wait_usb_device()
{
	VID_PID=$1

	while ! lsusb -d $VID_PID
	do
		sleep 1
	done
}

# load boot binaries, boot script and tezi fitimage to RAM and boot U-Boot
wait_usb_device $VID_PID_ROM
sudo $DFU_UTIL -w -R -a bootloader --device $VID_PID_ROM -D tiboot3-am62x-gp-evm.bin-dfu
wait_usb_device $VID_PID_R5
sudo $DFU_UTIL -w -R -a tispl.bin --device $VID_PID_R5 -D tispl.bin
wait_usb_device $VID_PID_A53
sudo $DFU_UTIL -w -a u-boot.img --device $VID_PID_A53 -D u-boot.img-recoverytezi
sudo $DFU_UTIL -w -a ramdisk_addr_r --device $VID_PID_A53 -D tezi.itb
sudo $DFU_UTIL -w -a loadaddr --device $VID_PID_A53 -D overlays.txt
sudo $DFU_UTIL -w -R -a scriptaddr --device $VID_PID_A53 -D boot-tezi.scr

exit 0
