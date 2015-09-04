#! /bin/bash

# This script is used to initialize a project folder.



#########
# Begin #
#########


###
# Environment

# Define project folders paths
source ./common/initialize.sh

# Check if script parameters are correct
export project_name=$1

if [ -z $project_name ] ; then
  echo
  echo "Error! No project name provided!"
  echo "Please provide the project name as a parameter of this script."
  echo
  echo "Script syntax:"
  echo "./initialize_project.sh <project_name>"
  echo
  exit 1
fi

# Check for required elements
$SCRIPTSDIR/common/initialize.sh 1 1
if [ $? -ne 0 ]; then
  exit 1
fi

# Define current project directory
export CURPROJDIR=$PROJECTSDIR/$project_name

# Check if project doesn't exist already
if [ -d $CURPROJDIR ]; then
  echo
  echo "Error! An already existing project exists under that name."
  echo "Remove or rename $CURPROJDIR if you want to create a new project using that name."
  echo
  exit 1
fi


###
# Begin

echo
echo "Creating project..."

# Projects dir
if [ -d $PROJECTSDIR/ ]; then
  :
else
  mkdir $PROJECTSDIR
fi

# Project dir
mkdir $CURPROJDIR

# Sub-project dirs
mkdir $CURPROJDIR/device_tree
mkdir $CURPROJDIR/boot_loader

# Others resources
cp $RESOURCESDIR/device_tree/zynq_devicetree.dts $CURPROJDIR/device_tree
cp $RESOURCESDIR/boot_loader/zynq_common.h $CURPROJDIR/boot_loader

echo "Done. Your project will be located in $CURPROJDIR."
echo "Some folders have already been created to host manually created elements."
echo

