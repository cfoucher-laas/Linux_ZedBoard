#! /bin/bash

#
# File:      download_sources.sh
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
# Date:      2017-05-17
#
# Description:
#
#            This script can be used to manually download specific sources outside any other script.
#
#            It is redundant with the "git_checker.sh" script, but this is done so to allow asking
#            the user which sources he/she wants *before* begining download.
#
#            TODO: define sub-script for this one (really repetitive)
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.1      Clément Foucher  2017-05-17  Removed source compression support; Enhanced read prompt.
#



#########
# Begin #
#########


###
# Environment

# First get project root
export SCRIPTSDIR="$(dirname $(readlink -f $0))"
export BASEDIR="$(dirname $SCRIPTSDIR)"

# Initialize
export discard_project_test="discard"
source $SCRIPTSDIR/common/initialize.sh
if [ $? -ne 0 ]; then
  exit 1
fi

###
# Check for existing sources

echo
echo "Checking for existing sources..."

download_anything=0

# Linux kernel
if [ -d $KERNELSOURCESFOLDER ]; then
  missing_kernel=0
else
  missing_kernel=1
fi

if [ $missing_kernel -eq 0 ]; then
  echo "Linux kernel was found at $KERNELSOURCESFOLDER/."
  dl_linux_kernel=0
else
  read -p "Linux kernel is missing. Do you want to download it? (Y/n): " -n 1 ans_linux_kernel
  echo

  if [ -z $ans_linux_kernel ]; then
    # Yes is default answer
    dl_linux_kernel=1
    download_anything=1
  elif [ $ans_linux_kernel == "y" ]; then
    dl_linux_kernel=1
    download_anything=1
  elif [ $ans_linux_kernel == "Y" ]; then
    dl_linux_kernel=1
    download_anything=1
  else
    dl_linux_kernel=0
  fi

  if [ $dl_linux_kernel -eq 1 ]; then
    echo "Linux kernel will be downloaded."
    echo
  fi
fi

# File system generator

if [ -d $FILESYSTEMSOURCESFOLDER ]; then
  missing_fs=0
else
  missing_fs=1
fi

if [ $missing_fs -eq 0 ]; then
  echo "File system generator was found at $FILESYSTEMSOURCESFOLDER/."
  dl_file_system=0
else
  read -p "File system generator is missing. Do you want to download it? (Y/n): " -n 1 ans_file_system
  echo

  if [ -z $ans_file_system ]; then
    # Yes is default answer
    dl_file_system=1
    download_anything=1
  elif [ $ans_file_system == "y" ]; then
    dl_file_system=1
    download_anything=1
  elif [ $ans_file_system == "Y" ]; then
    dl_file_system=1
    download_anything=1
  else
    dl_file_system=0
  fi

  if [ $dl_file_system -eq 1 ]; then
    echo "File system generator will be downloaded."
    echo
  fi
fi

# Boot loader generator

if [ -d $BOOTLOADERSOURCESFOLDER ]; then
  missing_boot_loader=0
else
  missing_boot_loader=1
fi

if [ $missing_boot_loader -eq 0 ]; then
  echo "Boot loader generator was found at $BOOTLOADERSOURCESFOLDER/."
  dl_boot_loader=0
else
  read -p "Boot loader generator is missing. Do you want to download it? (Y/n): " -n 1 ans_boot_loader
  echo

  if [ -z $ans_boot_loader ]; then
    # Yes is default answer
    dl_boot_loader=1
    download_anything=1
  elif [ $ans_boot_loader == "y" ]; then
    dl_boot_loader=1
    download_anything=1
  elif [ $ans_boot_loader == "Y" ]; then
    dl_boot_loader=1
    download_anything=1
  else
    dl_boot_loader=0
  fi

  if [ $dl_boot_loader -eq 1 ]; then
    echo "Boot loader generator will be downloaded."
    echo
  fi
fi


# Device tree generator

if [ -d $DEVICETREESOURCESFOLDER ]; then
  missing_device_tree=0
else
  missing_device_tree=1
fi

if [ $missing_device_tree -eq 0 ]; then
  echo "Device tree generator was found at $DEVICETREESOURCESFOLDER/."
  dl_device_tree=0
else
  read -p "Device tree generator is missing. Do you want to download it? (Y/n): " -n 1 ans_device_tree
  echo

  if [ -z $ans_device_tree ]; then
    # Yes is default answer
    dl_device_tree=1
    download_anything=1
  elif [ $ans_device_tree == "y" ]; then
    dl_device_tree=1
    download_anything=1
  elif [ $ans_device_tree == "Y" ]; then
    dl_device_tree=1
    download_anything=1
  else
    dl_device_tree=0
  fi

  if [ $dl_device_tree -eq 1 ]; then
    echo "Device tree generator will be downloaded."
    echo
  fi
fi

###
# Download

if [ $download_anything -eq 1 ]; then

  echo
  echo "Beginning source download..."

  if [ $dl_linux_kernel -eq 1 ]; then
    $SCRIPTSDIR/common/source_downloader.sh linux_kernel
    if [ $? -ne 0 ]; then
      exit 1
    fi
  fi

  if [ $dl_file_system -eq 1 ]; then
    $SCRIPTSDIR/common/source_downloader.sh file_system
    if [ $? -ne 0 ]; then
      exit 1
    fi
  fi

  if [ $dl_boot_loader -eq 1 ]; then
    $SCRIPTSDIR/common/source_downloader.sh boot_loader
    if [ $? -ne 0 ]; then
      exit 1
    fi
  fi

  if [ $dl_device_tree -eq 1 ]; then
    $SCRIPTSDIR/common/source_downloader.sh device_tree
    if [ $? -ne 0 ]; then
      exit 1
    fi
    # Checkout must be done here, as this is not used by a script
    git -C $DEVICETREESOURCESFOLDER checkout $DEVICETREEGITTAG
  fi

  echo
  echo "Source download completed."

else

  echo
  echo "No download requested."

fi


###
# Done

echo
echo "Exiting."
echo

