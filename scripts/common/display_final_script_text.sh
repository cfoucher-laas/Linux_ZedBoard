#! /bin/bash

#
# File:      display_final_script_text.sh
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
#            This script is display the final script text depending on script result.
#
#            Prerequisites:
#              Variable $LOGFILE and function $echoandlog must be defined prior to calling this script.
#            Expected parameters:
#              - $1: Script result (0 = OK, any other value = Error),
#              - $2: Output file path,
#              - $3: Expected generated file path.
#            Returns:
#              - 0: Successfull
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
if [ $# -ne 3 ]; then
  echo
  echo "Error! Incorrect number of parameters provided ($#)."
  echo "Plase consult $SCRIPTSDIR/common/display_final_script_text.sh for information on parameters."
  echo

  exit 9
fi

# Put a name on parameters
script_result=$1
output_file_path=$2
generated_file_path=$3

# Display text
echoandlog ""
if [ $script_result -eq 0 ]; then
  echoandlog "Script completed successfully."
  echoandlog "Output file is $output_file_path."
  echo       "Detailed log can be consulted at path $LOGFILE."
else
  echoandlog "Error! Output file $generated_file_path wasn't generated!"
  echo       "Please check $LOGFILE to look for errors during generation."
fi
echoandlog ""

exit 0

