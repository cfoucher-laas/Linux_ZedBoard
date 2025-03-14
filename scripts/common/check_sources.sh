#! /bin/bash

#
# File:      check_sources.sh
#
# Author:    Clément Foucher <Clement.Foucher@laas.fr>
#            2015; 2017 - Laboratoire d'analyse et d'architecture des systèmes (LAAS-CNRS)
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
# Version:   1.2
#
# Date:      2017-05-17
#
# Description:
#
#            This script checks for required directories and files existence.
#            It can be run at the beginning of other scripts to make sure we do
#            not use elements that don't exist.
#            Some elements will be asked for download if needed.
#
#            Prerequisites:
#              Function $echoandlog must be defined prior to calling this script.
#            Parameters order for checks is:
#              $1  => Boot loader sources      (downloadable resource)
#              $2  => Linux kernel source code (downloadable resource)
#              $3  => File system generator    (downloadable resource)
#              $4  => Boot loader patch file   (common resource)
#              $5  => Linux kernel config file (common resource)
#              $6  => File system config file  (common resource)
#              $7  => Device tree file         (project local)
#              $8  => Generated file system    (project local)
#              $9  => U-Boot mkimage tool      (project local)
#              $10 => Linux kernel dtc script  (project local)
#              $11 => Bitstream generation tcl (version-depending script)
#              $12 => Vivado executable        (external tool)
#            Returns:
#              0: Everything went well
#              1: A file is missing
#              2: A downloadable resource is missing, and user explicitely discarded it
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.1      Clément Foucher  2017-02-10  Added check for Vivado script and executable; Use new log functions.
#            1.2      Clément Foucher  2017-05-17  Updated parameters for git_checker.sh
#



#########
# Begin #
#########


# Determine which sources are to be checked
# This part is used to allow omitting parameters

if [ -z "$1" ]; then
  check_boot_loader=0
elif [ "$1" -eq 1 ]; then
  check_boot_loader=1
else
  check_boot_loader=0
fi


if [ -z "$2" ]; then
  check_linux_kernel=0
elif [ "$2" -eq 1 ]; then
  check_linux_kernel=1
else
  check_linux_kernel=0
fi

if [ -z "$3" ]; then
  check_file_system=0
elif [ "$3" -eq 1 ]; then
  check_file_system=1
else
  check_file_system=0
fi

if [ -z "$4" ]; then
  check_boot_loader_patch=0
elif [ "$4" -eq 1 ]; then
  check_boot_loader_patch=1
else
  check_boot_loader_patch=0
fi

if [ -z "$5" ]; then
  check_linux_kernel_config_file=0
elif [ "$5" -eq 1 ]; then
  check_linux_kernel_config_file=1
else
  check_linux_kernel_config_file=0
fi

if [ -z "$6" ]; then
  check_file_system_config_file=0
elif [ "$6" -eq 1 ]; then
  check_file_system_config_file=1
else
  check_file_system_config_file=0
fi

if [ -z "$7" ]; then
  check_dev_tree=0
elif [ "$7" -eq 1 ]; then
  check_dev_tree=1
else
  check_dev_tree=0
fi

if [ -z "$8" ]; then
  check_generated_file_system=0
elif [ "$8" -eq 1 ]; then
  check_generated_file_system=1
else
  check_generated_file_system=0
fi

if [ -z "$9" ]; then
  check_mkimage=0
elif [ "$9" -eq 1 ]; then
  check_mkimage=1
else
  check_mkimage=0
fi

if [ -z "${10}" ]; then
  check_dtc=0
elif [ "${10}" -eq 1 ]; then
  check_dtc=1
else
  check_dtc=0
fi

if [ -z "${11}" ]; then
  check_bitstream_tcl=0
elif [ "${11}" -eq 1 ]; then
  check_bitstream_tcl=1
else
  check_bitstream_tcl=0
fi

if [ -z "${12}" ]; then
  check_vivavo=0
elif [ "${11}" -eq 1 ]; then
  check_vivavo=1
else
  check_vivavo=0
fi

###
# Check for sources

echoandlog ""
echoandlog "Checking for required sources..."

### Generated files ###

# Device tree

if [ $check_dev_tree -eq 1 ]; then
  $SCRIPTSDIR/common/file_checker.sh $CURRENTPROJECTOUTPUTDIR/$DEVICETREEFOLDERBASENAME/$DEVICETREEOUTPUTNAME
  if [ $? -ne 0 ]; then
    exit 1
  fi
fi

# File system

if [ $check_generated_file_system -eq 1 ]; then
  $SCRIPTSDIR/common/file_checker.sh $CURRENTPROJECTOUTPUTDIR/$FILESYSTEMFOLDERBASENAME/$FILESYSTEMOUTPUTNAME
  if [ $? -ne 0 ]; then
    exit 1
  fi
fi

# U-boot mkimage utility

if [ $check_mkimage -eq 1 ]; then
  $SCRIPTSDIR/common/file_checker.sh $CURRENTPROJECTBASEDIR/$BOOTLOADERFOLDERBASENAME/tools/mkimage
  if [ $? -ne 0 ]; then
    exit 1
  fi
fi

# Linux dtc script

if [ $check_dtc -eq 1 ]; then
  $SCRIPTSDIR/common/file_checker.sh $CURRENTPROJECTBASEDIR/$KERNELFOLDERBASENAME/scripts/dtc/dtc
  if [ $? -ne 0 ]; then
    exit 1
  fi
fi


### Provided files ###

# Boot loader patch file

if [ $check_boot_loader_patch -eq 1 ]; then
  $SCRIPTSDIR/common/file_checker.sh $BOOTLOADERPATCHFILE
  if [ $? -ne 0 ]; then
    echoandlog "Error! U-boot patch file ($BOOTLOADERPATCHFILE) is missing."
    echoandlog "Plase make sure your Vivado version is supported by these scripts."
    echoandlog "Check $SCRIPTSDIR/common/config/tools_versions.sh for more details about Vivado supported versions."
    exit 1
  fi
fi

# Linux kernel config file

if [ $check_linux_kernel_config_file -eq 1 ]; then
  $SCRIPTSDIR/common/file_checker.sh $LINUXKERNELCONFIGFILE
  if [ $? -ne 0 ]; then
    echoandlog "Error! Kernel default configuration file ($LINUXKERNELCONFIGFILE) is missing."
    echoandlog "Plase make sure your Vivado version is supported by these scripts."
    echoandlog "Check $SCRIPTSDIR/common/config/tools_versions.sh for more details about Vivado supported versions."
    exit 1
  fi
fi

# File system config file

if [ $check_file_system_config_file -eq 1 ]; then
  $SCRIPTSDIR/common/file_checker.sh $FILESYSTEMCONFIGFILE
  if [ $? -ne 0 ]; then
    echoandlog "Error! Buildroot default configuration file ($FILESYSTEMCONFIGFILE) is missing."
    echoandlog "Plase make sure your Vivado version is supported by these scripts."
    echoandlog "Check $SCRIPTSDIR/common/config/tools_versions.sh for more details about Vivado supported versions."
    exit 1
  fi
fi

# Vivado tcl script

if [ $check_bitstream_tcl -eq 1 ]; then
  $SCRIPTSDIR/common/file_checker.sh $SCRIPTSDIR/common/vivado/generate_bitstream_$XILINXTOOLSVER.tcl
  if [ $? -ne 0 ]; then
    echoandlog "Error! Vivado script ($SCRIPTSDIR/common/vivado/generate_bitstream_$XILINXTOOLSVER.tcl) is missing."
    echoandlog "Plase make sure your Vivado version is supported by these scripts."
    echoandlog "Check $SCRIPTSDIR/common/config/tools_versions.sh for more details about Vivado supported versions."

    exit 1
  fi
fi

### Downloadable archives ###

# Linux kernel sources

if [ $check_linux_kernel -eq 1 ]; then
  $SCRIPTSDIR/common/git_checker.sh $KERNELSOURCESFOLDER $XILINXLINUXGITTAG "Linux kernel" linux_kernel
  if [ $? -ne 0 ]; then
    if [ $? -eq 2 ]; then
      echoandlog ""
      echoandlog "Script aborted by user."
      exit 2
    else
      exit 1
    fi
  fi
fi

# File system generator

if [ $check_file_system -eq 1 ]; then
  $SCRIPTSDIR/common/git_checker.sh $FILESYSTEMSOURCESFOLDER $BUILDROOTGITTAG "file system generator" file_system
  if [ $? -ne 0 ]; then
    if [ $? -eq 2 ]; then
      echoandlog ""
      echoandlog "Script aborted by user."
      exit 2
    else
      exit 1
    fi
  fi
fi


# Boot loader sources

if [ $check_boot_loader -eq 1 ]; then
  $SCRIPTSDIR/common/git_checker.sh $BOOTLOADERSOURCESFOLDER $BOOTLOADERGITTAG "boot loader generator" boot_loader
  if [ $? -ne 0 ]; then
    if [ $? -eq 2 ]; then
      echoandlog ""
      echoandlog "Script aborted by user."
      exit 2
    else
      exit 1
    fi
  fi
fi

### External tools ###

if [ $check_vivavo -eq 1 ]; then
  if [ -z "$(command -v vivado)" ]; then
    echoandlog "Error! \`vivado\` command is not found."
    echoandlog "Make sure Vivado is installed and its path is correctly defined in $SCRIPTSDIR/user_config/environment.sh"
    exit 1
  else
    echoandlog "Vivado found at path $(command -v vivado)."
  fi
fi

echoandlog "Done."
exit 0

