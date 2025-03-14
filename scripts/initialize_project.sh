#! /bin/bash

#
# File:      initialize_project.sh
#
# Author:    Clément Foucher <Clement.Foucher@laas.fr>
#            2015 - Laboratoire d'analyse et d'architecture des systèmes (LAAS-CNRS)
#
# Copyright: Copyright 2015 CNRS
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
# Date:      2015-09-21
#
# Description:
#
#            This script is used to initialize a project folder.
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#



#########
# Begin #
#########


###
# Environment

# First get project root
export SCRIPTSDIR="$(dirname $(readlink -f $0))"
export BASEDIR="$(dirname $SCRIPTSDIR)"

# Define project folders paths
export discard_project_test="discard"
source $SCRIPTSDIR/common/initialize.sh
if [ $? -ne 0 ]; then
  exit 1
fi

# Check if script parameters are correct
export project_name=$1

if [ -z $project_name ] ; then
  echo
  echo "Error! No project name provided!"
  echo "Please provide the project name as a parameter of this script."
  echo
  echo "Script syntax:"
  echo "initialize_project.sh <project_name>"
  echo

  exit 1
fi

# Define current project directory
export current_project_dir=$PROJECTSDIR/$project_name

# Check if project doesn't exist already
if [ -d $current_project_dir ]; then
  echo
  echo "Error! An already existing project exists under that name."
  echo "Remove or rename $current_project_dir if you want to create a new project using that name."
  echo

  exit 1
fi


###
# Begin

echo
echo "Creating project..."

# Projects dir
if ! [ -d $PROJECTSDIR/ ]; then
  mkdir $PROJECTSDIR
fi

# Project dir
mkdir $current_project_dir

# Sub-project dirs
mkdir $current_project_dir/logs

mkdir $current_project_dir/output
mkdir $current_project_dir/output/bin
mkdir $current_project_dir/output/boot_loader
mkdir $current_project_dir/output/dtb
mkdir $current_project_dir/output/file_system
mkdir $current_project_dir/output/hardware_design
mkdir $current_project_dir/output/linux_kernel
mkdir $current_project_dir/output/device_tree
mkdir $current_project_dir/output/first_stage_boot_loader

mkdir $current_project_dir/binary_generation

# Done.

echo "Done. Your project will be located in $current_project_dir."
echo "Some folders have already been created for you."
echo

