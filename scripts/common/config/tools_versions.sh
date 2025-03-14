#! /bin/bash

# This file is used to select the right version of sources.

# DO NOT modify this file unless you are sure of what you do.
# Changing tools version can lead to unexpected errors.


# Xilinx Vivado version
# Officially supported version:
#  - 2017.1
# Legacy version (unsupported, but it used to work, so it should still work):
#  - 2016.4
#  - 2015.2
# All other versions are unsupported by my scripts, so you should use
# the manual procedure depicted in the tutorial instead of the scripts.
export XILINXTOOLSVER="2017.1"

# Linux kernel
if [ $XILINXTOOLSVER == "2015.2" ]; then
  export XILINXLINUXGITTAGEXTRA=.03
fi
export XILINXLINUXGITTAG=xilinx-v$XILINXTOOLSVER$XILINXLINUXGITTAGEXTRA

# Buildroot
if [ $XILINXTOOLSVER == "2017.1" ]; then
  export BUILDROOTVER="2017.02.2"
elif [ $XILINXTOOLSVER == "2015.2" ]; then
  export BUILDROOTVER="2015.08"
elif [ $XILINXTOOLSVER == "2016.4" ]; then
  export BUILDROOTVER="2016.11.2"
fi
export BUILDROOTGITTAG=$BUILDROOTVER

# U-boot
export BOOTLOADERGITTAG=xilinx-v$XILINXTOOLSVER

# Device tree generator
if [ $XILINXTOOLSVER == "2015.2" ]; then
  export DEVICETREEGITTAGEXTRA=.02
fi
export DEVICETREEGITTAG=xilinx-v$XILINXTOOLSVER$DEVICETREEGITTAGEXTRA

