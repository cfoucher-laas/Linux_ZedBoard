#! /bin/bash

#
# File:      copy_file_system_to_memory_card.sh
#
# Author:    Clément Foucher <Clement.Foucher@laas.fr>
#            2015 - Laboratoire d'analyse et d'architecture des systèmes (LAAS-CNRS)
#
# Copyright: Copyright 2015 CNRS
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
# Version:   1.0.3
#
# Date:      2015-09-21
#
# Description:
#
#            This script is used to copy the generated file system
#            to a previously formated SD card.
#
#            Make sure the partition scheme accords to the
#            one depicted in the documentation first.
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.0.3    Clément Foucher  2015-11-26  Corrected emptiness check on SD card.
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

# Check for required sources
$SCRIPTSDIR/common/check_sources.sh 0 0 0 0 0 0 0 1
if [ $? -ne 0 ]; then
  exit 1
fi

# Check for correctly-defined mount directory
echo
echo "Testing mount directory..."
if ! [ -d "$SDMOUNTDIR/linux_fs" ]; then
  echo "Error! Board root directory incorrect."
  echo "Please ensure the SD card is inserted and that variable \$SDMOUNTDIR"
  echo "Defined in $SCRIPTSDIR/user-config/environment.sh is correct."
  echo "Current value: \"$SDMOUNTDIR\"."
  echo
  echo "Exiting."
  echo

  exit 1
fi
echo "Done."

# Check for super-user rights
if [ "$EUID" -ne 0 ]; then
  echo
  echo "Error! Executing this script requires superuser privileges."
  echo "Please use the \"sudo\" command at the beginning of the command line."
  echo
  echo "Exiting."
  echo

  exit 1
fi

# Check for directories emptyness
if [ "$(ls -A $MOUNTDIR)" ]; then
  echo "Error! Directory $MOUNTDIR is not empty!"
  echo "Please edit $SCRIPTSDIR/user-config/environment.sh"
  echo "to indicate an empty directory as a mount directory"
  echo "(MOUNTDIR variable)."
  echo
  echo "Exiting."
  echo

  exit 1
fi

if [ "$(ls -A $SDMOUNTDIR/linux_fs)" ]; then

  # After format, a directory may still be present
  NOT_EMPTY=0
  for file in $SDMOUNTDIR/*; do
    if [ "$file" == "$SDMOUNTDIR/lost+found" ]; then
      :
    else
      NOT_EMPTY=1
    fi
  done

  if [ $NOT_EMPTY -eq 1 ]; then
    echo "Warning! Directory $SDMOUNTDIR/linux_fs is not empty!"

# Auto-erase removed for safety reasons.

#  echo "Do you want to erase its content?"
#  echo
#  echo "/!\\"
#  echo "Please make sure you are targetting the correct directory before answering."
#  echo "As you're running as root, deleting the wrong folder could seriously harm your computer."
#  echo
#  echo "Type \"YES\" to erase directory content."

#  read ans_erase

#  if [ -z "$ans_erase" ]; then
#    do_erase=0
#  elif [ "$ans_erase" == "YES" ]; then
#    do_erase=1
#  else
#    do_erase=0
#  fi

#  if [ $do_erase -eq 1 ]; then
#    echo
#    echo "Erasing content..."
#    rm -rf $SDMOUNTDIR/linux_fs/*
#    echo "Done."
#  else
#    echo
#    echo "Script aborted by user."
    echo
    echo "Exiting."
    echo

    exit 1
  fi
fi


###
# Go

echo
echo "This script will now copy generated file system to memory card."

echo
echo "Copying initial file system..."
mount -t $FILESYSTEMEXTTYPE -o loop $CURRENTPROJECTOUTPUTDIR/$FILESYSTEMFOLDERBASENAME/$FILESYSTEMOUTPUTNAME $MOUNTDIR
cp -rf $MOUNTDIR/* $SDMOUNTDIR/linux_fs
umount -l $MOUNTDIR
echo "Done."

echo
echo "Copy completed successfully."
echo 

