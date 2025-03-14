#! /bin/bash

#                                                                                #
##                                                                              ##
###                                                                            ###
# Adapt the following paths depending on the configuration of your host computer #
###                                                                            ###
##                                                                              ##
#                                                                                #


##                       ##
# Configuration variables #
##                       ##


# This variable is used to define whether the downloaded sources must be
# compressed of not. Using compression makes first copy to a project longer,
# but uses less disk space.
#
# Adapt it at your convenience.
#
# Allowed values are 1 to enable compression, or 0 to disable it.
# Unlike other variables, don't add inverted commas around value.
export ENABLE_SOURCE_COMPRESSION=0


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
export SDMOUNTDIR="/media"

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
#export LM_LICENSE_FILE="1234@111.222.333.444"

# Xilinx base install directory.
#
# You probalby shouldn't have to edit this variable.
# Do it only if your Xilinx installation is not located in its default place.
#
# Default value: "/opt/Xilinx"
export XILINXBASEDIRECTORY="/opt/Xilinx"

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

