#! /bin/bash

#
# File:      generate_device_tree_blob.sh
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
# Version:   1.1
#
# Date:      2017-02-10
#
# Description:
#
#            This script is used to generate the device tree blob
#            that will tell the Linux kernel about its surrounding environment.
#
#            It requires the device tree and Linux kernel to be generated first.
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.1      Clément Foucher  2017-02-10  Use new script hierarchy.
#



#########
# Begin #
#########


###
# Environment

# First get project root
export SCRIPTSDIR="$(dirname $(readlink -f $0))"
export BASEDIR="$(dirname $SCRIPTSDIR)"

# Put a name on parameter
export project_name=$1

# Initialize environment
source $SCRIPTSDIR/common/initialize.sh "generate_device_tree_blob"
if [ $? -ne 0 ]; then
  exit 1
fi

# Check for required sources
$SCRIPTSDIR/common/check_sources.sh 0 0 0 0 0 0 1 0 0 1
if [ $? -ne 0 ]; then
  exit 1
fi

# Define local script-related paths
export dtb_output_dir=$CURRENTPROJECTOUTPUTDIR/$DEVICETREEBLOBFOLDERBASENAME
export dtb_output_file=$dtb_output_dir/$DEVICETREEBLOBOUTPUTNAME
export device_tree_source_file=$CURRENTPROJECTOUTPUTDIR/$DEVICETREEFOLDERBASENAME/$DEVICETREEOUTPUTNAME

# Check for previously generated outputs directory
$SCRIPTSDIR/common/check_previous_results_existence.sh 0 $dtb_output_dir 0 1
if [ $? -ne 0 ]; then
  echoandlog ""
  echoandlog "Exiting script. No change has been made."
  echoandlog ""
  exit 1
fi

###
# Go

echo
echo "### This script will now generate the device tree blob. ###"

# Make sure output directory exists
if ! [ -d $dtb_output_dir ]; then
  mkdir $dtb_output_dir
fi

# Build device tree blob
echoandlog ""
echoandlog "Generating dtb file..."
writetolog "Command line: \`$CURRENTPROJECTBASEDIR/$KERNELFOLDERBASENAME/scripts/dtc/dtc -O dtb -I dts -o $dtb_output_file $device_tree_source_file\`"
writetolog "### Begin dtc script output ###"
writetolog ""
$CURRENTPROJECTBASEDIR/$KERNELFOLDERBASENAME/scripts/dtc/dtc -O dtb -I dts -o $dtb_output_file $device_tree_source_file &>> $LOGFILE
writetolog ""
writetolog "### End dtc script output ###"
echoandlog "Done."

###
# Check output and finalize

if [ -r $dtb_output_file ]; then
  generation_failed=0
else
  generation_failed=1
fi

$SCRIPTSDIR/common/display_final_script_text.sh $generation_failed $dtb_output_file $dtb_output_file


