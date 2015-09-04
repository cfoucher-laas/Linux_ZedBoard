#! /bin/bash

# This script is used to generate the
# Linux kernel using default parameters.



#########
# Begin #
#########


###
# Environment

# Check for required elements
source ./common/initialize.sh 0 0 1
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
export linux_kernel_workdir=$PROJECTSDIR/$project_name/linux_kernel/$linux_kernel_folder_naming_convention
#  export linux_kernel_output_name=zImage
export linux_kernel_output_name=uImage
export linux_kernel_arch_name=arm


echo
echo "This script will configure and generate the Linux kernel with default options."

###
# Initial tests

# Sources
echo
echo "Checking sources..."
if [ -r $RESOURCESDIR/packages/linux_kernel/$linux_kernel_archive_naming_convention ]; then
  :
else
  echo "Error! Source file $RESOURCESDIR/packages/linux_kernel/$linux_kernel_archive_naming_convention does not exist."
  echo "Please make sure file exists and you have the correct rights for reading it."
  echo
  exit
fi

# Additional sources

  if [ -r $PROJECTSDIR/$project_name/device_tree/zynq_devicetree.dts ]; then
    :
  else
    echo "Error! Source file $PROJECTSDIR/$project_name/device_tree/zynq_devicetree.dts does not exist."
    echo "Please make sure file exists and you have the correct rights for reading it."
    echo
    exit
  fi
  if [ -r $RESOURCESDIR/packages/linux_kernel/_.config-zedboard ]; then
    :
  else
    echo "Error! Source file $RESOURCESDIR/packages/linux_kernel/_.config-zedboard does not exist."
    echo "Please make sure file exists and you have the correct rights for reading it."
    echo
    exit
  fi

echo "Done."

# Work directory
echo
echo "Checking folder hierarchy..."
if [ -d $linux_kernel_workdir ]; then
  echo "~~ INFO ~~ An already existing working directory was found at path $linux_kernel_workdir."
  echo "Do you want to:"
  echo "Overwrite this folder => Type \"O\""
  echo "Exit script => any input"
  read ans
  if [ "$ans" == "O" ]; then
    rm -rf $linux_kernel_workdir
  else
    echo
    echo "Exiting script. No change have been made."
    echo
    exit
  fi
else
  
    if [ -d $PROJECTSDIR/$project_name/linux_kernel ]; then
      :
    else
      mkdir $PROJECTSDIR/$project_name/linux_kernel
    fi

fi

# Output directory
if [ -r $PROJECTSDIR/$project_name/output/linux_kernel/$linux_kernel_output_name ]; then
  if [ "$ans" == "O" ]; then
    rm -f $PROJECTSDIR/$project_name/output/linux_kernel/$linux_kernel_output_name
  else
    echo "~~ INFO ~~ An already generated linux kernel was found at path $PROJECTSDIR/$project_name/output/linux_kernel/$linux_kernel_output_name."
    echo "Do you want to overwrite this file?"
    echo "Type \"YES\" to do so, any other input to exit script."
    read ans
    if [ "$ans" == "YES" ]; then
      rm -f $PROJECTSDIR/$project_name/output/linux_kernel/$linux_kernel_output_name
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

  cd $PROJECTSDIR/$project_name/linux_kernel/
  tar -xzf $RESOURCESDIR/packages/linux_kernel/$linux_kernel_archive_naming_convention
#  mv ./* ./$linux_kernel_folder_naming_convention
  cp -f $PROJECTSDIR/$project_name/device_tree/zynq_devicetree.dts $linux_kernel_workdir/

echo "Done."

###
# Kernel configuration

echo
echo "Configuring kernel..."
cd $linux_kernel_workdir

  make distclean &> $PROJECTSDIR/$project_name/logs/generate_linux_kernel_default.log
  make ARCH=arm xilinx_zynq_defconfig &>> $PROJECTSDIR/$project_name/logs/generate_linux_kernel_default.log
  cp $RESOURCESDIR/packages/linux_kernel/_.config-zedboard $linux_kernel_workdir/.config
#  make ARCH=arm xconfig &>> $PROJECTSDIR/$project_name/logs/generate_linux_kernel_default.log

echo "Done."

###
# Kernel generation

echo
echo "Generating linux kernel (this may take a while)..."

cd $linux_kernel_workdir


if [ -r $linux_kernel_workdir/arch/$linux_kernel_arch_name/boot/$linux_kernel_output_name ]; then

  if [ -d $PROJECTSDIR/$project_name/output ]; then
    :
  else
    mkdir $PROJECTSDIR/$project_name/output
  fi
  if [ -d $PROJECTSDIR/$project_name/output/linux_kernel ]; then
    :
  else
    mkdir $PROJECTSDIR/$project_name/output/linux_kernel
  fi
  
    if [ -d $PROJECTSDIR/$project_name/output/dtb ]; then
      :
    else
      mkdir $PROJECTSDIR/$project_name/output/dtb
    fi
    cp $linux_kernel_workdir/devicetree.dtb $PROJECTSDIR/$project_name/output/dtb/


  cp $linux_kernel_workdir/arch/$linux_kernel_arch_name/boot/$linux_kernel_output_name $PROJECTSDIR/$project_name/output/linux_kernel/
  echo
  echo "Done. Output file is $PROJECTSDIR/$project_name/output/linux_kernel/$linux_kernel_output_name."
  echo "Generation log is located at path $PROJECTSDIR/$project_name/logs/generate_linux_kernel_default.log."
  echo
else
  echo "Error! Output file $linux_kernel_workdir/arch/$linux_kernel_arch_name/boot/$linux_kernel_output_name wasn't generated!"
  echo "Please check $PROJECTSDIR/$project_name/logs/generate_linux_kernel_default.log to look for errors during generation."
  echo
  exit
fi

