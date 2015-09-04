#! /bin/bash

# This script is used to download a specific source.
#
# /!\
# This script can fail, so return code must be checked after call.

# Allowed parameters:
# linux_kernel => Download Linux kernel
# file_system => Download file system generator




#########
# Begin #
#########


###
# Environment

# Check for root existence
source ./common/initialize.sh
if [ $? -ne 0 ]; then
  exit 1
fi

# Make sure the resource directory exists
if [ -d $RESOURCESDIR ]; then
  :
else
  mkdir $RESOURCESDIR
fi

# Define URLs
source $SCRIPTSDIR/sources_url.sh

# Download
if [ $1 -eq "linux_kernel" ]; then

  echo
  echo "Downloading Linux kernel, this can take some time..."

  git clone $LINUXKERNELURL $KERNELSOURCES
  cd $KERNELSOURCES
  git checkout $XILINXLINUXGITTAG

  echo "Done."

elif [ $1 -eq "file_system" ]; then

  echo
  echo "Downloading file system generator, this can take some time..."

  git clone $BUILDROOTURL $FSSOURCES
  cd $FSLSOURCES
  git checkout $BUILDROOTGITTAB

  echo "Done."

fi

