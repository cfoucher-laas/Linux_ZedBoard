#! /bin/bash

#
# File:      generate_linux_kernel_common.sh
#
# Author:    Clément Foucher <Clement.Foucher@laas.fr>
#            2015; 2017 - Laboratoire d'analyse et d'architecture des systèmes (LAAS-CNRS)
#
# Copyright: Copyright 2015; 2017 CNRS
#
#            This program is free software: you can redistribute it and/or modify
#            it under the terms of the GNU General Public License as published by
#            the Free Software Foundation, either version 2 of the License, or
#            (at your option) any later version.
#
#            This program is distributed in the hope that it will be useful,
#            but WITHOUT ANY WARRANTY; without even the implied warranty of
#            MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#            GNU General Public License for more details.
#
#            You should have received a copy of the GNU General Public License
#            along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
# Version:   1.2
#
# Date:      2017-05-17
#
# Description:
#
#            This script is used to generate the Linux kernel.
#            Depending on the parameters, the kernels uses default configuration
#            or opens a GUI for the user.
#
#            The initialize script must be run before calling this script.
#            The check_sources script is not required to be run first.
#
#            Parameters:
#              - $1 => can be either "default" or "custom".
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.1      Clément Foucher  2017-02-10  Use new script hierarchy.
#            1.2      Clément Foucher  2017-05-17  Removed source compression support; Enhanced read prompt.
#



#########
# Begin #
#########


###
# Environment

# Check parameters
if [ $# -ne 1 ]; then
  echo "Error! Incorrect number of parameters provided ($#)."
  echo "Please consult file $SCRIPTSDIR/common/generate_linux_kernel_common.sh for information on parameters."
  echo
  echo "Exiting."
  echo

  exit 9
elif [ "$1" == "default" ]; then
  behavior="default"
elif [ "$1" == "custom" ]; then
  behavior="custom"
else
  echo "Error! Incorrect value of parameter given (\$1=$1)."
  echo "Please consult file $SCRIPTSDIR/common/generate_linux_kernel_common.sh for information on parameters."
  echo
  echo "Exiting."
  echo

  exit 9
fi

# Define local script-related paths
export linux_kernel_work_dir=$CURRENTPROJECTBASEDIR/$KERNELFOLDERBASENAME
export linux_kernel_output_dir=$CURRENTPROJECTOUTPUTDIR/$KERNELFOLDERBASENAME
export linux_kernel_output_file=$linux_kernel_output_dir/$LINUXKERNELOUTPUTNAME
export generated_file_kernel=$linux_kernel_work_dir/arch/$LINUXKERNELARCHNAME/boot/$LINUXKERNELOUTPUTNAME

# Check for previously generated outputs directory
do_reuse=0
$SCRIPTSDIR/common/check_previous_results_existence.sh $linux_kernel_work_dir $linux_kernel_output_dir 1
check_previous_result=$?
if [ $check_previous_result -ne 0 ] && [ $check_previous_result -ne 1 ]; then
  echoandlog ""
  echoandlog "Exiting script. No change has been made."
  echoandlog ""
  exit 1
elif [ $check_previous_result -eq 1 ] ; then
  do_reuse=1
fi

# Set cross-compilation environement
set_zynq_cross_compile

###
# Go

if [ "$behavior" == "default" ]; then
  echo ""
  echo "### This script now will configure and generate the Linux kernel with default options. ###"
elif [ "$behavior" == "custom" ]; then
  echo ""
  echo "### This script now will ask you for Linux kernel configuration then generate it. ###"
fi


# Prepare sources

if [ $do_reuse -eq 0 ]; then
  echoandlog ""
  echoandlog "Copying Linux kernel sources..."
  rsync -ar $KERNELSOURCESFOLDER/* $CURRENTPROJECTBASEDIR/$KERNELFOLDERBASENAME --exclude $KERNELSOURCESFOLDER/.git

  echoandlog "Done."
fi

# Kernel configuration
if [ $do_reuse -eq 0 ]; then
  echoandlog ""
  if [ "$behavior" == "default" ]; then
    echoandlog "Configuring kernel..."
  elif [ "$behavior" == "custom" ]; then
    echoandlog "Initial kernel configuration..."
  fi

  writetolog "Command line: \`make -C $linux_kernel_work_dir distclean\`"
  writetolog "### Begin make output ###"
  writetolog ""
  make -C $linux_kernel_work_dir distclean &>> $LOGFILE
  writetolog ""
  writetolog "### End make output ###"
  writetolog "Command line: \`make -C $linux_kernel_work_dir ARCH=arm xilinx_zynq_defconfig\`"
  writetolog "### Begin make output ###"
  writetolog ""
  make -C $linux_kernel_work_dir ARCH=arm xilinx_zynq_defconfig &>> $LOGFILE
  writetolog ""
  writetolog "### End make output ###"

  echoandlog "Done."
fi

if [ "$behavior" == "default" ]; then
  cp $LINUXKERNELCONFIGFILE $linux_kernel_work_dir/.config
elif [ "$behavior" == "custom" ]; then
  echoandlog ""
  echo "Please use the GUI to configure kernel."
  echo "Once done, save then exit the GUI."
  echo
  echo "Waiting for user configuration..."
  writetolog "Asking user for kernel configuration using GUI..."
  writetolog "Command line: \`make -C $linux_kernel_work_dir ARCH=arm xconfig\`"
  writetolog "### Begin make output ###"
  writetolog ""
  make -C $linux_kernel_work_dir ARCH=arm xconfig &>> $LOGFILE
  writetolog ""
  writetolog "### End make output ###"
  echoandlog "Done."
fi

# Kernel generation

if [ "$behavior" == "custom" ]; then
  # Check if configuration has been saved
  if ! [ -f $linux_kernel_work_dir/.config ]; then
    echoandlog ""
    echoandlog "Error! Configuration file missing."
    echoandlog "Did you save your modifications before closing GUI?"
    echoandlog ""
    echoandlog "Exiting."
    echoandlog ""
    
    exit 1
  fi
  # Ask for generation, as user may not be satisfied with its configuration
  echo
  echo "Configuration saved."
  echo

  read -p "Begin kernel generation? (Y/n): " -n 1 begin_generation_ans
  echo

  if [ -z "$begin_generation_ans" ]; then
    begin_generation=1
  elif [ "$begin_generation_ans" == "n" ]; then
    begin_generation=0
  elif [ "$begin_generation_ans" == "N" ]; then
    begin_generation=0
  else
    begin_generation=1
  fi

  if [ $begin_generation -eq 0 ]; then
    echoandlog ""
    echoandlog "Generation cancelled by user."
    echoandlog ""
    echoandlog "Exiting."
    echoandlog ""

    exit 1
  fi
  
fi

echo
echo "Generating linux kernel (this may take a while)..."

# Make sure the mkimage utility is the correct one
export PATH=$CURRENTPROJECTBASEDIR/$BOOTLOADERFOLDERBASENAME/tools:$PATH

writetolog ""
writetolog "Generating linux kernel..."
writetolog "Command line: \`make -C $linux_kernel_work_dir ARCH=arm UIMAGE_LOADADDR=0x8000 uImage\`"
writetolog "### Begin make output ###"
writetolog ""
make -C $linux_kernel_work_dir ARCH=arm UIMAGE_LOADADDR=0x8000 uImage &>> $LOGFILE
writetolog ""
writetolog "### End make output ###"
echoandlog "Done."

###
# Check output and finalize

$SCRIPTSDIR/common/copy_output_file.sh $generated_file_kernel $linux_kernel_output_dir
$SCRIPTSDIR/common/display_final_script_text.sh $? $linux_kernel_output_file $generated_file_kernel

