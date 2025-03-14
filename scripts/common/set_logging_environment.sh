#! /bin/bash

#
# File:      set_logging_environment.sh
#
# Author:    Clément Foucher <Clement.Foucher@laas.fr>
#            2017 - Laboratoire d'analyse et d'architecture des systèmes (LAAS-CNRS)
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
# Version:   1.0
#
# Date:      2017-02-09
#
# Description:
#
#            This script is used to set the log environment up.
#            It must be *sourced* by calling script.
#
#            Prerequisites:
#              Variable $CURRENTPROJECTLOGDIR msut be set prior to calling this script.
#            Expected parameters:
#              - $1: Root script name.
#            Returns:
#              - 0: Everything went well 
#              - 9: Script internal error (e.g. script was launched with wrong parameters)
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2017-02-09  First release.
#



#########
# Begin #
#########

# Check parameter count

if [ $# -ne 1 ]; then
  echo
  echo "Error! Incorrect number of parameters provided ($#)."
  echo "Plase consult $SCRIPTSDIR/common/set_log_environment.sh for information on parameters."
  echo

  exit 9
fi

# Put a name on parameter

root_script_name=$1

###
# Go
###

# Define log fine

export LOGFILE=$CURRENTPROJECTLOGDIR/$root_script_name.log

# Create and export functions

echoandlog()
(
echo $1
echo $1 &>> $LOGFILE
)

writetolog()
(
echo $1 &>> $LOGFILE
)

export -f echoandlog
export -f writetolog

# Make sure log directory exists

if ! [ -d $CURRENTPROJECTLOGDIR ]; then
  mkdir $CURRENTPROJECTLOGDIR
fi

# Initialize log file (do not use the function as this must erase content)
echo "### Begining $root_script_name.sh script. ###" &> $LOGFILE

# Done.

