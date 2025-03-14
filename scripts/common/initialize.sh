#! /bin/bash

#
# File:      initialize.sh
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
# Date:      2017-02-09
#
# Description:
#
#            This script defines base variables used in other scripts,
#            and checks for correct root definition.
#            It must be *sourced* at the beginning of any other script.
#
#            /!\
#            This script can fail, so return code must be checked after call.
#
#            Prerequisites:
#               The variable $project_name must be defined before valling this script,
#               or can be ignored $discard_project_test if explicitely defined.
#            Parameters:
#               $1: If defined, a logging file will be set up using the parameter as the name.
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.1      Clément Foucher  2017-02-10  Added call to logging environment script.
#



#########
# Begin #
#########

echo
echo "Initializing script environment..."

###
# First get tools versions (used in environment.sh)
source $SCRIPTSDIR/common/config/tools_versions.sh

###
# Then define environment-related variables (used in project_paths.sh)
source $SCRIPTSDIR/user-config/environment.sh

###
# Finally define project folders paths
source $SCRIPTSDIR/common/config/project_paths.sh

###
# Define tool chain procedure
source $SCRIPTSDIR/common/config/cross_compile_toolchain.sh

###
# Check for project name, unless stated otherwise
if [ -z "$discard_project_test" ]; then

  if [ -z "$project_name" ]; then
    echo
    echo "Error! No project name provided!"
    echo "Please provide project name as a parameter of this script."
    echo
    echo "Exiting."
    echo

    exit 1
  fi

  if ! [ -d $PROJECTSDIR/$project_name ]; then
    echo
    echo "Error! Project does not exist."
    echo "It should be located in $PROJECTSDIR/$project_name."
    echo "Did you used the \"initialize_project.sh\" script?"
    echo "It should be located at $SCRIPTSDIR/initialize_project.sh."
    echo
    echo "Exiting."
    echo

    exit 1
  fi

  # Set helper variables
  export CURRENTPROJECTBASEDIR=$PROJECTSDIR/$project_name
  export CURRENTPROJECTOUTPUTDIR=$CURRENTPROJECTBASEDIR/output
  export CURRENTPROJECTLOGDIR=$CURRENTPROJECTBASEDIR/logs
  export CURRENTPROJECTCONFIGDIR=$CURRENTPROJECTBASEDIR/config

  ###
  # Set up scripting environment if requested
  if [ $# -eq 1 ]; then
    source $SCRIPTSDIR/common/set_logging_environment.sh $1
  fi

fi

echo "Done."

