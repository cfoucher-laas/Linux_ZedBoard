#! /bin/bash

# This script is used to define paths that will be used
# in other scripts. It must be sourced at the beginning
# of every other script.

# DO NOT edit this file unless you are sure of what you do.
# Editing these variables will impact the hierarchy of projects.

# Base directories
export RESOURCESDIR="$BASEDIR/resources"
export PROJECTSDIR="$BASEDIR/projects"

# Resources directories
export KERNELFOLDERBASENAME=linux_kernel
export FILESYSTEMFOLDERBASENAME=file_system
export BOOTLOADERFOLDERBASENAME=boot_loader
export DEVICETREEFOLDERBASENAME=device_tree
export BITSTREAMFOLDERBASENAME=hardware_design
export DEVICETREEBLOBFOLDERBASENAME=dtb

export ARCHIVESEXTENSION=.tar.bz2

export KERNELRESOURCES=$RESOURCESDIR/$KERNELFOLDERBASENAME
export FILESYSTEMRESOURCES=$RESOURCESDIR/$FILESYSTEMFOLDERBASENAME
export BOOTLOADERRESOURCES=$RESOURCESDIR/$BOOTLOADERFOLDERBASENAME
export DEVICETREERESOURCES=$RESOURCESDIR/$DEVICETREEFOLDERBASENAME

export KERNELSOURCESFOLDER=$KERNELRESOURCES/$KERNELFOLDERBASENAME-sources
export FILESYSTEMSOURCESFOLDER=$FILESYSTEMRESOURCES/$FILESYSTEMFOLDERBASENAME-generator
export BOOTLOADERSOURCESFOLDER=$BOOTLOADERRESOURCES/$BOOTLOADERFOLDERBASENAME-generator
export DEVICETREESOURCESFOLDER=$DEVICETREERESOURCES/$DEVICETREEFOLDERBASENAME-generator

export KERNELSOURCESARCHIVE=$KERNELRESOURCES/$KERNELFOLDERBASENAME-sources$ARCHIVESEXTENSION
export FILESYSTEMSOURCESARCHIVE=$FILESYSTEMRESOURCES/$FILESYSTEMFOLDERBASENAME-generator$ARCHIVESEXTENSION
export BOOTLOADERSOURCESARCHIVE=$BOOTLOADERRESOURCES/$BOOTLOADERFOLDERBASENAME-generator$ARCHIVESEXTENSION
export DEVICETREESOURCESARCHIVE=$DEVICETREERESOURCES/$DEVICETREEFOLDERBASENAME-generator$ARCHIVESEXTENSION

# Provided resources files
export LINUXKERNELCONFIGFILE=$KERNELRESOURCES/_.config-kernel-zedboard-$XILINXTOOLSVER
export FILESYSTEMCONFIGFILE=$FILESYSTEMRESOURCES/_.config-fs-zedboard-$XILINXTOOLSVER
export BOOTLOADERPATCHFILE=$BOOTLOADERRESOURCES/boot_loader.$XILINXTOOLSVER.patch

# Linux kernel related files
export LINUXKERNELOUTPUTNAME=uImage
export LINUXKERNELARCHNAME=arm

# File system related files
export FILESYSTEMEXTTYPE=ext4
export FILESYSTEMOUTPUTNAME=rootfs.$FILESYSTEMEXTTYPE

# Boot loader related
export BOOTLOADEROUTPUTNAME=u-boot.elf
export BOOTLOADERGENERATEDFILENAME=u-boot

# Bitstream related
export BITSTREAMOUTPUTNAME=bitstream.bit
export BITSTREAMGENERATEDFILENAME=design_1_wrapper.bit

# Device tree related
export DEVICETREEOUTPUTNAME=system.dts
export DEVICETREEBLOBOUTPUTNAME=devicetree.dtb

# FSBL related
export FSBLOUTPUTNAME=FSBL.elf

