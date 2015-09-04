#! /bin/bash

# This script checks for required directories and files existence.
# It must be *sourced* before other scripts to make sure we do not use 
# elements that don't exist.
# Some elements will be asked for download if needed.
#
# /!\
# This script can fail, so return code must be checked after call.

# Parameters order for checks is:
# 1 => Device tree config file
# 2 => Boot loader header file
# 3 => Linux kernel source code
# 4 => File system generator



#########
# Begin #
#########


###
# Define project folders paths
source ./common/define_project_paths.sh


###
# Check if folders are correctly defined

echo
echo "Checking folder hierarchy..."

# Base directory: the root of everything.
# This test is ALWAYS run.

if [ -d $BASEDIR ]; then
  :
else
  echo
  echo "Error! Project root $BASEDIR does not exist!"
  echo
  echo "Did you edit script \"project_root.sh\"?"
  echo "This file should be found in the subfolder \"environment\""
  echo "of the \"script\" folder from where the current script were executed."
  echo
  exit 1
fi

echo "Done."


###
# Check for sources

echo
echo "Checking sources..."

# Device tree source file

if [ $1 -eq 1 ]; then
  if [ -r $DEVICETREEDTS ]; then
    :
  else
    echo "Error! Source file $DEVICETREEDTS does not exist."
    echo "Please make sure file exists and you have the correct permissions."
    echo
    exit 1
  fi
fi

# Boot loader source file

if [ $2 -eq 1 ]; then
  if [ -r $BOOTLOADERHEADER ]; then
    :
  else
    echo "Error! Source file $BOOTLOADERHEADER does not exist."
    echo "Please make sure file exists and you have the correct permissions."
    echo
    exit 1
  fi
fi

# Linux kernel sources

if [ $3 -eq 1 ]; then
  if [ -d $KERNELSOURCES ]; then
    :
  else
    echo "Folder $KERNELSOURCES can't be found."
    echo "Do you want to download it now? (y/N)"
    echo "This can take some time depending on your connection."
    read download_kernel

    if [ $download_kernel -eq "y" ]; then
      do_download_linux=1
    elif [ $download_kernel -eq "Y" ]; then
      do_download_linux=1
    else
      do_download_linux=0
    fi

    if [ $do_download_linux -eq 1 ]; then
      $SCRIPTSDIR/common/source_downloader.sh linux_kernel
      if [ $? -ne 0 ]; then
        echo "An error occured while downloading Linux kernel."
        echo "Exiting."
        echo
        exit 1
      fi
    else
      echo "Download cancelled."
      echo "Exiting."
      echo
      exit 1
    fi
  fi
fi

# File system generator

if [ $4 -eq 1 ]; then
  if [ -d $FSSOURCES ]; then
    :
  else
    echo "Folder $FSSOURCES can't be found."
    echo "Do you want to download it now? (y/N)"
    echo "This can take some time depending on your connection."
    read download_file_system

    if [ $download_file_system -eq "y" ]; then
      do_download_fs=1
    elif [ $download_file_system -eq "Y" ]; then
      do_download_fs=1
    else
      do_download_fs=0
    fi

    if [ $do_download_fs -eq 1 ]; then
      $SCRIPTSDIR/common/source_downloader.sh file_system
      if [ $? -ne 0 ]; then
        echo "An error occured while downloading file system generator."
        echo "Exiting."
        echo
        exit 1
      fi
    else
      echo "Download cancelled."
      echo "Exiting."
      echo
      exit 1
    fi
  fi
fi

echo "Done."

###
# Finally, define environment-related variables

source $SCRITPTSDIR/environment/environment.sh
source $SCRIPTSDIR/common/cross_compile_toolchain.sh

