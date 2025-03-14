#! /bin/bash

#
# File:      file_checker.sh
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
# Date:      2017-02-10
#
# Description:
#
#            This script provides a simple file check service.
#
#            Prerequisites:
#              Funtion $echoandlog must be defined prior to calling this script.
#            Parameters:
#              Exacly one parameter must be provided containing the file path to be checked for existence.
#            Returns:
#              - 0: File found
#              - 1: File not found
#              - 9: Script internal error (e.g. script was launched with wrong parameters)
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.0      Clément Foucher  2017-02-10  Use echoandlog().
#



#########
# Begin #
#########

# Check parameter count
if [ $# -ne 1 ]; then
  echo
  echo "Error! Incorrect number of parameters provided ($#)."
  echo "Plase consult $SCRIPTSDIR/common/file_checker.sh for information on parameters."
  echo
  echo "Exiting."
  echo

  exit 9
fi

# Put a name on parameter
file_path=$1

if [ -f $1 ]; then
  echoandlog "File $file_path was found."
else
  echoandlog "Error! Source file $file_path does not exist."
  echoandlog "Please make sure file exists and you have the correct permissions."
  exit 1
fi

exit 0

