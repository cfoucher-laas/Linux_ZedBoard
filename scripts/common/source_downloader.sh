#! /bin/bash

#
# File:      source_downloader.sh
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
#            This script is used to download a specific source.
#
#            /!\
#            This script can fail, so return code must be checked after call.
#
#            Allowed parameters ($1):
#            linux_kernel => Download Linux kernel
#            file_system  => Download file system generator
#            boot_loader  => Download boot loader generator
#            device_tree  => Download device tree generator
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.1      Clément Foucher  2017-05-17  Removed source compression support;
#                                                  Cleared git checkout (now managed by git_checker.sh)
#



#########
# Begin #
#########


###
# Environment

# Check parameter count

if [ $# -ne 1 ]; then
  echo
  echo "Error! Incorrect number of parameters provided ($#)."
  echo "Plase consult $SCRIPTSDIR/common/source_downloader.sh for information on parameters."
  echo

  exit 9
fi

# Make sure the resource directory exists
if ! [ -d $RESOURCESDIR ]; then
  mkdir $RESOURCESDIR
fi

# Define URLs
source $SCRIPTSDIR/common/config/sources_url.sh

# Define variables depending on requested sources

if [ "$1" == "linux_kernel" ]; then
  export curent_download_url=$LINUXKERNELURL
  export current_source_folder=$KERNELSOURCESFOLDER
  export current_readable_name="Linux kernel"
elif [ "$1" == "file_system" ]; then
  export curent_download_url=$BUILDROOTURL
  export current_source_folder=$FILESYSTEMSOURCESFOLDER
  export current_readable_name="file system generator"
elif [ "$1" == "boot_loader" ]; then
  export curent_download_url=$BOOTLOADERURL
  export current_source_folder=$BOOTLOADERSOURCESFOLDER
  export current_readable_name="boot loader generator"
elif [ "$1" == "device_tree" ]; then
  export curent_download_url=$DEVICETREEURL
  export current_source_folder=$DEVICETREESOURCESFOLDER
  export current_readable_name="device tree generator"
else
  echo
  echo "Error! Unkown parameter: $1"
  echo "Please check file $SCRIPTSDIR/common/source_downloader.sh"
  echo "to see list of allowed parameters."
  echo
  echo "Exiting."
  echo

  exit 1
fi


echo
echo "Downloading $current_readable_name (this may take a while)..."
echo

git clone $curent_download_url $current_source_folder
if [ $? -ne 0 ]; then
  echo
  echo "Error! Source download failed."
  echo "You may want to delete folder $current_source_folder/ if it exists."
  echo
  echo "Exiting."
  echo

  exit 1
fi

echo
echo "Done."

