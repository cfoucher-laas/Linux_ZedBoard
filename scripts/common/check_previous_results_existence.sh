#! /bin/bash

#
# File:      check_previous_results_existence.sh
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
#            This script is used to check on work directory and output file existence and allow user to overwrite them.
#
#            Prerequisites:
#              Function $echoandlog must be defined prior to calling this script.
#            Expected parameters:
#              - $1: Work directory path,
#              - $2: Output directory path,
#              - $3: Set to 1 if the re-use option has to be displayed, 0 otherwise,
#              - $4: (optional) Set to 1 if no work directory is required. Parameter $1 will be discarded.
#            Returns:
#              - 0: Work directory is clean (either there was no work directory or user chose to overwrite it)
#              - 1: User chose to re-use existing working directory
#              - 2: Cancel (there was an existing work directory and user chose to preserve it)
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
if [ $# -ne 3 ] && [ $# -ne 4 ]; then
  echo
  echo "Error! Incorrect number of parameters provided ($#)."
  echo "Plase consult $SCRIPTSDIR/common/check_previous_results_existence.sh for information on parameters."
  echo

  exit 9
fi

# Put a name on parameters
work_dir_path=$1
output_dir_path=$2
reuse_existing_option=$3

skip_work_dir_check=0
if ! [ -z $4 ]; then
  if [ $4 -eq 1 ]; then
    skip_work_dir_check=1
  fi
fi

# Local variables
auto_erase_output_files=0
do_reuse=0
do_overwrite=0



# Check work directory existence

if ! [ $skip_work_dir_check -eq 1 ]; then

  echoandlog ""
  echoandlog "Checking for existing work directory..."

  if [ -d $work_dir_path ]; then

    echo "~~ INFO ~~"
    echoandlog "An already existing working directory was found at path $work_dir_path."
    writetolog "Asking user what he/she want to do with it."
    echo "Do you want to:"
    echo "Overwrite this folder (All files will be lost) => Type \"OVERWRITE\""
    if ! [ $reuse_existing_option == 0 ]; then
      echo "Re-use this folder as is (Do not copy ) => Type \"REUSE\""
    fi
    echo "Exit script => any other input"
    read overwrite_ans

    if [ -z "$overwrite_ans" ]; then
      :
    elif [ "$overwrite_ans" == "OVERWRITE" ]; then
      do_overwrite=1
    fi

    if [ $reuse_existing_option -eq 1 ]; then
      if [ "$overwrite_ans" == "REUSE" ]; then
        do_reuse=1
      fi
    fi

    if [ $do_overwrite -eq 1 ]; then

      echoandlog "Erasing existing work directory $work_dir_path."

      rm -rf $work_dir_path
      auto_erase_output_files=1

    elif [ $do_reuse -eq 1 ]; then

      echoandlog "Re-using existing work directory $work_dir_path."
      auto_erase_output_files=1

    else

      writetolog "User choose to preserve existing directory."
      echo "Existing directory will be preserved."
      exit 3

    fi

  else
    echoandlog "No previous working directory found."
  fi
  echoandlog "Done."
fi

# Check output files existence

if [ $auto_erase_output_files -eq 0 ]; then

  echoandlog ""
  echoandlog "Checking previously generated output files existence..."

  if [ -d $output_dir_path ]; then

    if ! [ -z "$(ls -A $output_dir_path)" ]; then
      echo "~~ INFO ~~"
      echoandlog "Previously generated files were found at path $output_dir_path."
      writetolog "Asking user what he/she want to do with them."
      echo "Do you want to overwrite these files?"
      echo "Type \"YES\" to do so, any other input to exit script."
      read overwrite_ans

      do_overwrite=0
      if [ -z "$overwrite_ans" ]; then
        :
      elif [ "$overwrite_ans" == "YES" ]; then
        do_overwrite=1
      fi

      if [ $do_overwrite -eq 1 ]; then
        echoandlog "Erasing existing files at path $output_dir_path/."
        rm -f $output_dir_path/*
      else
        writetolog "User choose to not erase existing files."
        echo "Existing files will be preserved."
        exit 1
      fi
    else
      echoandlog "No previous output files found."
    fi

  else
    echoandlog "No previous output files found."
  fi
  echoandlog "Done."
else
  if [ -d $output_dir_path ]; then
    if ! [ -z "$(ls -A $output_dir_path)" ]; then
      echoandlog "Output files were found in $output_dir_path."
      echoandlog "Erasing them."
      rm -f $output_dir_path/*
    fi
  fi
fi

if [ $do_reuse -eq 1 ]; then
  exit 1
else
  exit 0
fi

