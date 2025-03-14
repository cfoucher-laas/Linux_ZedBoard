#! /bin/bash

#
# File:      copy_output_file.sh
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
# Date:      2017-02-10
#
# Description:
#
#            This script is used to copy output file to output dir. The variable $CURRENTPROJECTOUTPUTDIR
#            must be defined before calling this script.
#
#            Prerequisites:
#              Function $echoandlog must be defined prior to calling this script.
#            Expected parameters:
#              - $1: Generated file path,
#              - $2: Output directory path,
#              - $3: (Optional) File name if file has to be renamed.
#            Returns:
#              - 0: Output file successfully copied
#              - 1: Output file doesn't exist
#              - 9: Script internal error (e.g. script was launched with wrong parameters)
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2017-02-10  First release.
#



#########
# Begin #
#########

# Check parameter count
if [ $# -ne 2 ] && [ $# -ne 3 ]; then
  echo
  echo "Error! Incorrect number of parameters provided ($#)."
  echo "Plase consult $SCRIPTSDIR/common/copy_output_file.sh for information on parameters."
  echo

  exit 9
fi

# Put a name on parameters
generated_file=$1
output_dir_path=$2
file_name=$3

# Check work directory existence

echoandlog ""
echoandlog "Checking output file..."

if [ -r $generated_file ]; then

  if ! [ -d $CURRENTPROJECTOUTPUTDIR ]; then
    echoandlog "Creating directory $CURRENTPROJECTOUTPUTDIR"
    mkdir $CURRENTPROJECTOUTPUTDIR
  fi

  if ! [ -d $output_dir_path ]; then
    echoandlog "Creating directory $output_dir_path"
    mkdir $output_dir_path
  fi

  if [ -z $file_name ]; then
    echoandlog "Copying file $generated_file to $output_dir_path/"
    cp $generated_file $output_dir_path/
  else
    echoandlog "Copying file $generated_file to $output_dir_path/$file_name"
    cp $generated_file $output_dir_path/$file_name
  fi

  echoandlog "Done."

else
  exit 1
fi

exit 0

