#! /bin/bash

# Do not edit the following line
source $SCRIPTSDIR/common/tools_versions.sh

#
##
###
# Adapt the following paths depending on the configuration of your host computer
###
##
#

# CompactFlash pseudo-file driver
# This variable MUST be adapted to your local configuration
# It is usally "/dev/<something>"
#export CFDRV="/dev/sdb"

# Mount point of the drives on your host computer
# This variable MUST be adapted to your local configuration
# Probable value: "/run/media/<user_name>" or "/media"
#export BOARDROOTDIR="/run/media/cfoucher"

# Port and IP address of the license server hosting Xilinx license
# If licences are managed locally of if the variable is already existing in your environment, just comment the line
#export LM_LICENSE_FILE="1650@134.59.213.13"

# Architecture of the host computer
# Set to "32" or "64"
#export HOST_ARCH="64"

# Install directory: this is where the third party tools will be installed
# Default value: "/opt"
#export INSTALLDIR="/opt"

# Xilinx tools location on your host computer
# You probalby should not have to edit this variable
# Do it only if your Vivado installation is not located in its default place
# Default value: "/opt/Xilinx/"$XILINXTOOLSVER"/ISE_DS"
export XILINXTOOLS="/opt/Xilinx/Vivado/"$XILINXTOOLSVER"/"

# Mount directory: must be an existing empty folder
# Do not edit until there is a problem with original value
# Default value: "/mnt"
#export MOUNTDIR="/mnt"

#
##
###
# End of user-editable content
###
##
#

