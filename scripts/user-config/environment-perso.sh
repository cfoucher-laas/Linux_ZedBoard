#! /bin/bash

#                                                                                #
##                                                                              ##
###                                                                            ###
# Adapt the following paths depending on the configuration of your host computer #
###                                                                            ###
##                                                                              ##
#                                                                                #


##                ##
# System variables #
##                ##


# Mount point of the drives on your host computer.
#
# This variable *MUST* be adapted to your local configuration.
#
# Probable values:
#   - "/run/media/<user_name>" or "/media" on Fedora,
#   - "/media/<user_name>" on Ubuntu
export SDMOUNTDIR="/media/cfoucher"

# Mount directory: must be an existing empty folder.
#
# Do not edit unless there is a problem with original value.
#
# Default value: "/mnt"
export MOUNTDIR="/mnt"


##                ##
# Xilinx variables #
##                ##


# Port and IP address of the license server hosting Xilinx license.
# It must be set if your license is provided by a remote server.
#
# If licences are managed locally or if the variable is already declared
# in your environment, just leave this line commented.
#
# Value format type: "1234@111.222.333.444"
export LM_LICENSE_FILE="2100@flexalter.laas.fr"

# Xilinx base install directory.
#
# You probalby shouldn't have to edit this variable.
# Do it only if your Xilinx installation is not located in its default place.
#
# Default value: "/opt/Xilinx"
export XILINXBASEDIRECTORY="/local/app/Xilinx"

# Xilinx tools location on your host computer.
#
# You probalby shouldn't have to edit this variable.
# Do it only if your Xilinx installation is not standard.
#
# Default value: "$XILINXBASEDIRECTORY/Vivado/"$XILINXTOOLSVER"/"
export XILINXTOOLS="$XILINXBASEDIRECTORY/Vivado/"$XILINXTOOLSVER"/"

# Location or Xilinx-provided ARM toolchain.
#
# You probalby shouldn't have to edit this variable.
# Do it only if your Xilinx installation is not standard.
#
# Default value: ""$XILINXBASEDIRECTORY/SDK/$XILINXTOOLSVER/gnu/arm/lin/bin""
export ARMTOOLCHAIN="$XILINXBASEDIRECTORY/SDK/$XILINXTOOLSVER/gnu/arm/lin/bin"


#                           #
##                         ##
###                       ###
# End of configuration file #
###                       ###
##                         ##
#                           #

