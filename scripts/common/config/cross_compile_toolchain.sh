#! /bin/bash

# This script is used to provide a cross-compilation environment.

# DO NOT modify this file unless you are sure of what you do.

set_zynq_cross_compile() {
  if [ -n "$PATH" ]; then
    export PATH=$ARMTOOLCHAIN:$PATH
  else
    export PATH=$ARMTOOLCHAIN
  fi
  export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
}

export -f set_zynq_cross_compile

