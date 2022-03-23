setenv bootargs igb_mac=${ethaddr} console=ttyS0,115200 quiet video=HDMI-A-1:640x480-16@60D rootfstype=@@INITRAMFS_FSTYPES@@ root=/dev/ram autoinstall ${teziargs}

# Re-enable fdt relocation since in place fdt edits corrupt the ramdisk
# in a FIT image...
setenv fdt_high

# Load FIT image from location as detected by distroboot
load ${devtype} ${devnum}:${distro_bootpart} ${ramdisk_addr_r} ${prefix}tezi.itb

bootm ${ramdisk_addr_r}#conf-${soc}-${fdt_module}-${fdt_board}.dtb
