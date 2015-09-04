#! /bin/bash

# This script can be used to manually download specific sources outside any other script.



#########
# Begin #
#########


###
# Environment

# Initialize
source ./common/initialize.sh
if [ $? -ne 0 ]; then
  exit 1
fi


###
# Check for existing sources

echo
echo "Checking for existing sources..."

# Linux kernel
if [ -d $KERNELSOURCES ]; then
  echo "Linux kernel was found in $KERNELSOURCES."
  dl_linux_kernel=0
else
  echo "Linux kernel is missing. Do you want to download it (Y/n)?"
  read ans_linux_kernel

  if [ $ans_linux_kernel -eq "y" ]; then
    dl_linux_kernel=1
  elif [ $ans_linux_kernel -eq "Y" ]; then
    dl_linux_kernel=1
  elif [ $ans_linux_kernel -z ]; then
    # Yes is default answer
    dl_linux_kernel=1
  else
    dl_linux_kernel=0
  fi
fi

# File system generator

if [ -d $FSSOURCES ]; then
  echo "Buildroot was found in $FSSOURCES."
  dl_file_system=0
else
  echo "Buildroot is missing. Do you want to download it (Y/n)?"
  read ans_file_system

  if [ $ans_file_system -eq "y" ]; then
    dl_file_system=1
  elif [ $ans_file_system -eq "Y" ]; then
    dl_file_system=1
  elif [ $ans_file_system -z ]; then
    # Yes is default answer
    dl_file_system=1
  else
    dl_file_system=0
  fi
fi

###
# Download

echo
echo "Beginning source download..."

if [ $dl_linux_kernel -eq 1 ]; then
  $SCRIPTSDIR/common/source_downloader.sh linux_kernel
fi

if [ $dl_file_system -eq 1 ]; then
  $SCRIPTSDIR/common/source_downloader.sh file_system
fi

###
# Done

echo
echo "Source download completed."
echo "Exiting."
echo

