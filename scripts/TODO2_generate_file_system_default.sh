#! /bin/bash

# This script is used to generate the
# Linux kernel using default parameters.



#########
# Begin #
#########


###
# Environment

# Check for required elements
source ./common/initialize.sh 0 0 0 1
if [ $? -ne 0 ]; then
  exit 1
fi

# Check if project is correctly defined
export project_name=$1
$SCRIPTSDIR/common/check_project.sh
if [ $? -ne 0 ]; then
  exit 1
fi



exit 0




##### TODO #####


  set_zynq_cross_compile
  export file_system_workdir=$PROJECTSDIR/$project_name/file_system/$file_system_folder_naming_convention
  export file_system_output_name=rootfs.ext4


echo
echo "This script will prepare all needed files for Linux file system generation, perform default configuration, then generate the file system."

###
# Initial tests

# Sources
echo
echo "Checking sources..."
if [ -r $RESOURCESDIR/packages/file_system/$file_system_archive_naming_convention ]; then
  :
else
  echo "Error! Source file $RESOURCESDIR/packages/file_system/$file_system_archive_naming_convention does not exist or you do not have the rights fo reading it."
  echo "Please make sure file exists and you have the correct rights for reading it."
  echo
  exit
fi

  if [ -r $RESOURCESDIR/packages/file_system/_.config-zedboard ]; then
    :
  else
    echo "Error! Source file $RESOURCESDIR/packages/file_system/_.config-zedboard does not exist."
    echo "Please make sure you already did the hardware generation step and did place the dts file in this folder."
    echo
    exit
  fi


echo "Done."

# Work directory
echo
echo "Checking folder hierarchy..."
if [ -d $file_system_workdir ]; then
  echo "~~ INFO ~~ An already existing working directory was found at path $file_system_workdir."
  echo "Do you want to:"
  echo "Overwrite this folder => Type \"O\""
  echo "Exit script => any input"
  read ans
  if [ "$ans" == "O" ]; then
    rm -rf $file_system_workdir
  else
    echo
    echo "Exiting script. No change have been made."
    echo
    exit
  fi
else
  
    if [ -d $PROJECTSDIR/$project_name/file_system ]; then
      :
    else
      mkdir $PROJECTSDIR/$project_name/file_system
    fi
  
fi

# Output directory
if [ -r $PROJECTSDIR/$project_name/output/file_system/$file_system_output_name ]; then
  if [ "$ans" == "O" ]; then
     rm -f $PROJECTSDIR/$project_name/output/file_system/$file_system_output_name
  else
    echo "~~ INFO ~~ An already generated file system was found at path $PROJECTSDIR/$project_name/output/file_system/$file_system_output_name."
    echo "Do you want to overwrite this file?"
    echo "Type \"YES\" to do so, any other input to exit script."
    read ans
    if [ "$ans" == "YES" ]; then
      rm -f $PROJECTSDIR/$project_name/output/file_system/$file_system_output_name
    else
      echo
      echo "Exiting script. No change have been made."
      echo
      exit
    fi
  fi
fi

# Logs directory
if [ -d $PROJECTSDIR/$project_name/logs ]; then
  :
else
  mkdir $PROJECTSDIR/$project_name/logs
fi
echo "Done."

###
# Prepare sources

echo
echo "Preparing work directory..."

  cd $PROJECTSDIR/$project_name/file_system

tar -xzf $RESOURCESDIR/packages/file_system/$file_system_archive_naming_convention
echo "Done."

###
# Configure file system

echo
echo "Configuring file system..."
cd $file_system_workdir
#make xconfig &> $PROJECTSDIR/$project_name/logs/generate_file_system_default.log

  cp $RESOURCESDIR/packages/file_system/_.config-zedboard $file_system_workdir/.config

echo "Done."

###
# File system generation

echo
echo "Generating file system (this may take a while)..."
cd $file_system_workdir
make &> $PROJECTSDIR/$project_name/logs/generate_file_system_default.log

if [ -r $file_system_workdir/output/images/$file_system_output_name ]; then

  if [ -d $PROJECTSDIR/$project_name/output ]; then
    :
  else
    mkdir $PROJECTSDIR/$project_name/output
  fi
  if [ -d $PROJECTSDIR/$project_name/output/file_system ]; then
    :
  else
    mkdir $PROJECTSDIR/$project_name/output/file_system
  fi

  cp $file_system_workdir/output/images/$file_system_output_name $PROJECTSDIR/$project_name/output/file_system/
  echo
  echo "Done. Output file is $PROJECTSDIR/$project_name/output/file_system/$file_system_output_name."
  echo "Generation log is located at path $PROJECTSDIR/$project_name/logs/generate_file_system_default.log."
  echo
else
  echo "Error! Output file $file_system_workdir/output/images/$file_system_output_name wasn't generated!"
  echo "Please check $PROJECTSDIR/$project_name/logs/generate_file_system_default.log to look for errors during generation."
  echo
  exit
fi

