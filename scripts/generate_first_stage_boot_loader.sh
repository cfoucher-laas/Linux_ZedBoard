#! /bin/bash

#
# File:      generate_first_stage_boot_loader.sh
#
# Author:    Clément Foucher <Clement.Foucher@laas.fr>
#            2017 - Laboratoire d'analyse et d'architecture des systèmes (LAAS-CNRS)
#
# Copyright: Copyright 2017 CNRS
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
# Version:   1.0
#
# Date:      2017-02-08
#
# Description:
#
#            This script is used to generate the board first stage boot loader.
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#



#########
# Begin #
#########

###
# Environment

# First get project root
export SCRIPTSDIR="$(dirname $(readlink -f $0))"
export BASEDIR="$(dirname $SCRIPTSDIR)"

export project_name=$1

# Initialize environment
source $SCRIPTSDIR/common/initialize.sh
if [ $? -ne 0 ]; then
  exit 1
fi

# Define local script-related paths
export sdk_work_dir=$CURRENTPROJECTBASEDIR/$BITSTREAMFOLDERBASENAME/$BITSTREAMFOLDERBASENAME.sdk
export fsbl_work_dir=$sdk_work_dir/FSBL
export fsbl_output_dir=$CURRENTPROJECTOUTPUTDIR/$DEVICETREEFOLDERBASENAME
export fsbl_output_file=$device_tree_output_dir/$DEVICETREEOUTPUTNAME
export fsbl_generated_file=$fsbl_work_dir/FSBL/Release/$FSBLOUTPUTNAME
export fsbl_log_file=$CURRENTPROJECTLOGDIR/generate_first_stage_boot_loader.log

echo
echo "Checking working directory..."

# Vivado script

if ! [ -f $SCRIPTSDIR/common/generate_first_stage_boot_loader_$XILINXTOOLSVER.tcl ]; then
  echo "Error! Vivado script ($SCRIPTSDIR/common/generate_first_stage_boot_loader_$XILINXTOOLSVER.tcl) is missing."
  echo "Plase make sure your Vivado version is supported."

  exit 1
fi


# Work directory
do_overwrite=0

if [ -d $fsbl_work_dir ]; then
  echo "~~ INFO ~~ An already existing working directory was found at path $fsbl_work_dir."
  echo "Do you want to:"
  echo "Overwrite this folder (All design files will be lost) => Type \"OVERWRITE\""
  echo "Exit script => any other input"
  read overwrite_ans

  if [ -z "$overwrite_ans" ]; then
    :
  elif [ "$overwrite_ans" == "OVERWRITE" ]; then
    do_overwrite=1
  fi

  if [ $do_overwrite -eq 1 ]; then
    rm -rf $fsbl_work_dir
    if [ -r $fsbl_output_file ]; then
      rm -f $fsbl_output_file
    fi
  else
    echo 
    echo "Exiting script. No change has been made."
    echo

    exit 1
  fi
fi

# Output directory (Has already been emptied if previous answer was overwrite)
# Only way to get there is if we manually removed work dir, but not output file.
if [ -d $fsbl_output_dir ] then
  if [ -r $fsbl_output_file ]; then

    echo "~~ INFO ~~ An already generated first stage boot loader was found at path $fsbl_output_file."
    echo "Do you want to overwrite this file?"
    echo "Type \"YES\" to do so, any other input to exit script."
    read overwrite_ans

    do_overwrite=0
    if [ -z "$overwrite_ans" ]; then
      :
    elif [ "$overwrite_ans" == "YES" ]; then
      do_overwrite=1
    fi

    if [ $do_overwrite -eq 1 ]; then
      rm -f $fsbl_output_file
    else
      echo 
      echo "Exiting script. No change has been made."
      echo
      exit 1
    fi

  fi
fi

# Logs directory
if ! [ -d $CURRENTPROJECTLOGDIR ]; then
  mkdir $CURRENTPROJECTLOGDIR
fi

echo "Done."


###
# Go

# Go
echo
echo "This script will now generate the first stage boot loader."

echo
echo "Please wait while XSDK is generating the first stage boot loader..."

# To make sure Vivado output files are stored in the log folder
cd $CURRENTPROJECTLOGDIR

source $XILINXTOOLS/settings64.sh
xsdk -batch -source $SCRIPTSDIR/common/generate_first_stage_boot_loader_$XILINXTOOLSVER.tcl &> $fsbl_log_file
echo "Done."


###
# Check outputs

if [ -r $fsbl_generated_file ]; then

  if ! [ -d $CURRENTPROJECTOUTPUTDIR ]; then
    mkdir $CURRENTPROJECTOUTPUTDIR
  fi

  if ! [ -d $fsbl_output_dir ]; then
    mkdir $fsbl_output_dir
  fi

  cp $fsbl_generated_file $fsbl_output_file

  echo
  echo "Done. Output file is $fsbl_output_file."
  echo "Generation log is located at path $fsbl_log_file."
  echo
else
  echo "Error! Output file $fsbl_generated_file wasn't generated!"
  echo "Please check $fsbl_log_file to look for errors during generation."
  echo
  exit
fi

