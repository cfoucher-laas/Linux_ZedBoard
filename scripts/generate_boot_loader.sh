#! /bin/bash

#
# File:      generate_boot_loader.sh
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
# Date:      2017-06-17
#
# Description:
#
#            This script is used to generate the
#            boot loader using default parameters.
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.1      Clément Foucher  2017-02-10  Added support for other Vivado versions; Use new script hierarchy.
#            1.2      Clément Foucher  2017-05-17  Updated to Vivado 2017.1; Removed source compression support; Enhanced read prompt.
#



#########
# Begin #
#########

###
# Environment set-up

# First get project root
export SCRIPTSDIR="$(dirname $(readlink -f $0))"
export BASEDIR="$(dirname $SCRIPTSDIR)"

# Put a name on parameter
export project_name=$1

# Initialize environment
source $SCRIPTSDIR/common/initialize.sh "generate_boot_loader"
if [ $? -ne 0 ]; then
  exit 1
fi

# Check for required sources
$SCRIPTSDIR/common/check_sources.sh 1 0 0 1
if [ $? -ne 0 ]; then
  exit 1
fi

# Define local script-related paths
export boot_loader_work_dir=$CURRENTPROJECTBASEDIR/$BOOTLOADERFOLDERBASENAME
export boot_loader_output_dir=$CURRENTPROJECTOUTPUTDIR/$BOOTLOADERFOLDERBASENAME
export boot_loader_output_file=$boot_loader_output_dir/$BOOTLOADEROUTPUTNAME
export boot_loader_generated_file=$boot_loader_work_dir/$BOOTLOADERGENERATEDFILENAME
export customized_header_file=$CURRENTPROJECTBASEDIR/config/zynq-common.h

# Check for previously generated outputs directory
$SCRIPTSDIR/common/check_previous_results_existence.sh $boot_loader_work_dir $boot_loader_output_dir 0
if [ $? -ne 0 ]; then
  echoandlog ""
  echoandlog "Exiting script. No change has been made."
  echoandlog ""
  exit 1
fi

###
# Go

echo
echo "### This script will now generate a U-Boot boot loader. ###"


# Prepare sources

echoandlog
echoandlog "Copying file system generator sources..."
rsync -ar $BOOTLOADERSOURCESFOLDER/* $CURRENTPROJECTBASEDIR/$BOOTLOADERFOLDERBASENAME --exclude $BOOTLOADERSOURCESFOLDER/.git
echoandlog "Done."

echoandlog ""
echoandlog "Patching U-boot..."
writetolog "Command line: \`patch $boot_loader_work_dir/include/configs/zynq-common.h < $BOOTLOADERPATCHFILE\`"
writetolog "### Begin patch output ###"
writetolog ""
patch $boot_loader_work_dir/include/configs/zynq-common.h < $BOOTLOADERPATCHFILE &>> $LOGFILE
writetolog ""
writetolog "### End patch output ###"
echoandlog "Done."

# Configure

set_zynq_cross_compile


echo ""
echo "Configuring project..."
writetolog ""
writetolog "Cleaning U-boot folder..."
writetolog "Command line: \`make -C $boot_loader_work_dir distclean\`"
writetolog "### Begin make output ###"
writetolog ""
make -C $boot_loader_work_dir distclean &>> $LOGFILE
writetolog ""
writetolog "### End make output ###"
writetolog "Done."
writetolog ""
writetolog "Configuring U-boot..."
writetolog "Command line: \`make -C $boot_loader_work_dir zynq_zed_config\`"
writetolog ""
writetolog "### Begin make output ###"
writetolog ""
make -C $boot_loader_work_dir zynq_zed_config &>> $LOGFILE
writetolog ""
writetolog "### End make output ###"
writetolog "Done."
echo "Done."

# Generate

echoandlog ""
writetolog "Asking user whether he/she needs to define a MAC address..."
read -p "Do you need to set a specific MAC address for your board? (y/N): " -n 1 specify_mac_ans
echo

if [ -z $specify_mac_ans ]; then
  specify_mac=0
elif [ $specify_mac_ans == "Y" ]; then
  specify_mac=1
elif [ $specify_mac_ans == "y" ]; then
  specify_mac=1
else
  specify_mac=0
fi

if [ $specify_mac -eq 1 ]; then

  mac_address_correct=0

  while [ $mac_address_correct -eq 0 ]; do

    echo
    echo "Enter the desired MAC address using format XX:XX:XX:XX:XX:XX"

    read user_mac_address

    echo
    echo "You entered the following address: \"$user_mac_address\"."
    read -p "Is the address correct? (Y/n) : " -n 1 user_mac_address_correct
    echo

    if [ -z $user_mac_address_correct ]; then
      mac_address_correct=1
    elif [ $user_mac_address_correct == "Y" ]; then
      mac_address_correct=1
    elif [ $user_mac_address_correct == "y" ]; then
      mac_address_correct=1
    else
      mac_address_correct=0
    fi

  done
  
  if [ $XILINXTOOLSVER == "2015.2" ]; then
    echo "--- zynq-common.h	2015-09-10 14:41:51.380960000 +0200
+++ zynq-common.h	2015-09-16 15:35:29.360248329 +0200
@@ -253,7 +253,7 @@
 /* Default environment */
 #define CONFIG_PREBOOT
 #define CONFIG_EXTRA_ENV_SETTINGS	\\
-	\"ethaddr=00:0a:35:00:01:22\0\"	\\
+	\"ethaddr=$user_mac_address\0\"	\\
 	\"kernel_image=uImage\0\"	\\
 	\"kernel_load_address=0x2080000\0\" \\
 	\"ramdisk_image=uramdisk.image.gz\0\"	\\" &> $boot_loader_work_dir/mac_address.patch
  elif [ $XILINXTOOLSVER == "2016.4" ]; then
    echo "--- zynq-common.h	2017-02-07 16:55:53.319769399 +0100
+++ zynq-common.h	2017-02-07 17:00:28.889164035 +0100
@@ -203,7 +203,7 @@
 /* Default environment */
 #ifndef CONFIG_EXTRA_ENV_SETTINGS
 #define CONFIG_EXTRA_ENV_SETTINGS	\\
-	\"ethaddr=00:0a:35:00:01:22\0\"	\\
+	\"ethaddr=$user_mac_address\0\"	\\
 	\"kernel_image=uImage\0\"	\\
 	\"kernel_load_address=0x2080000\0\" \\
 	\"ramdisk_image=uramdisk.image.gz\0\"	\\" &> $boot_loader_work_dir/mac_address.patch
  elif [ $XILINXTOOLSVER == "2017.1" ]; then
    echo "--- zynq-common.h     	2017-05-17 14:06:19.536116000 +0200
+++ zynq-common.h	2017-05-17 14:10:13.129170072 +0200
 /* Default environment */
 #ifndef CONFIG_EXTRA_ENV_SETTINGS
 #define CONFIG_EXTRA_ENV_SETTINGS	\\
-	\"ethaddr=00:0a:35:00:01:22\0\"	\\
+	\"ethaddr=$user_mac_address\0\"	\\
 	\"kernel_image=uImage\0\"	\\
 	\"kernel_load_address=0x2080000\0\" \\
 	\"ramdisk_image=uramdisk.image.gz\0\"	\\" &> $boot_loader_work_dir/mac_address.patch
  else
    echo "Error! Unsupported Vivado version."
    exit 1
  fi

  writetolog ""
  writetolog "User specified MAC address: \"$user_mac_address\""

  writetolog ""
  writetolog "Patching U-boot config file with MAC address"
  writetolog "Command line: \`patch $boot_loader_work_dir/include/configs/zynq-common.h < $boot_loader_work_dir/mac_address.patch\`"
  writetolog "### Begin patch output ###"
  writetolog ""
  patch $boot_loader_work_dir/include/configs/zynq-common.h < $boot_loader_work_dir/mac_address.patch &>> $LOGFILE
  writetolog ""
  writetolog "### End patch output ###"
  writetolog "Done."

else
  writetolog "No MAC address defined."
fi

echoandlog ""
echoandlog "Generating bootloader..."
writetolog "Command line: \`make -C $boot_loader_work_dir\`"
writetolog "### Begin make output ###"
writetolog ""
make -C $boot_loader_work_dir &>> $LOGFILE
writetolog ""
writetolog "### End make output ###"
echoandlog "Done."


###
# Check output and finalize

$SCRIPTSDIR/common/copy_output_file.sh $boot_loader_generated_file $boot_loader_output_dir $BOOTLOADEROUTPUTNAME
$SCRIPTSDIR/common/display_final_script_text.sh $? $boot_loader_output_file $boot_loader_generated_file

