#! /bin/bash

# This script is used to check whether the target project
# has been correctly defined by the user, and do exist.

if [ -z $project_name ] ; then
  echo
  echo "Error! No project name provided!"
  echo "Please provide project name as a parameter of this script."
  echo
  exit 1
fi

if [ -d $PROJECTSDIR/$project_name ]; then
  :
else
  echo
  echo "Error! Project does not exist."
  echo "It should be located in $PROJECTSDIR/$project_name."
  echo "Did you used the \"initialize_project.sh\" script?"
  echo
  exit 1
fi

