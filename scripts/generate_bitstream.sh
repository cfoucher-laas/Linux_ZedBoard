#! /bin/bash

#
# File:      generate_bitstream.sh
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
#            This script is used to generate a default bitstream configuration file.
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.1      Clément Foucher  2017-02-10  Added support for multiple Vivado versions; Use new script hierarchy.
#



#########
# Begin #
#########

###
# Environment set-up

# First get project root
export SCRIPTSDIR="$(dirname $(readlink -f $0))"
export BASEDIR="$(dirname $SCRIPTSDIR)"

# Put a name on parameter
export project_name=$1

# Initialize environment
source $SCRIPTSDIR/common/initialize.sh "generate_bitstream"
if [ $? -ne 0 ]; then
  exit 1
fi

# Define local script-related paths
export bitsteam_work_dir=$CURRENTPROJECTBASEDIR/$BITSTREAMFOLDERBASENAME
export bitsteam_output_dir=$CURRENTPROJECTOUTPUTDIR/$BITSTREAMFOLDERBASENAME
export bitsteam_output_file=$bitsteam_output_dir/$BITSTREAMOUTPUTNAME
export bitsteam_generated_file=$bitsteam_work_dir/hardware_design.runs/impl_1/$BITSTREAMGENERATEDFILENAME

# Initialize Vivado environement
source $XILINXTOOLS/settings64.sh

# Check for required sources
$SCRIPTSDIR/common/check_sources.sh 0 0 0 0 0 0 0 0 0 0 1 1
if [ $? -ne 0 ]; then
  echoandlog ""
  echoandlog "Exiting script. No change has been made."
  echoandlog ""
  exit 1
fi

# Check for previously generated outputs directory
$SCRIPTSDIR/common/check_previous_results_existence.sh $bitsteam_work_dir $bitsteam_output_dir 0
if [ $? -ne 0 ]; then
  echoandlog ""
  echoandlog "Exiting script. No change has been made."
  echoandlog ""
  exit 1
fi

###
# Go

echo ""
echo "### This script will now generate the bitstream. ###"

echo ""
echo "Please wait while Vivado is generating bistream (this may take a while)..."

writetolog ""
writetolog "Launching Vivado script."
writetolog "Command line: \`vivado -mode tcl -source $SCRIPTSDIR/common/vivado/generate_bitstream_$XILINXTOOLSVER.tcl\`"
writetolog "### Begin Vivado output ###"
writetolog ""

# To make sure Vivado output files are stored in the log folder
cd $CURRENTPROJECTLOGDIR

vivado -mode tcl -source $SCRIPTSDIR/common/vivado/generate_bitstream_$XILINXTOOLSVER.tcl &>> $LOGFILE
writetolog ""
writetolog "### End Vivado output ###"
echoandlog "Done."


###
# Check output and finialize

$SCRIPTSDIR/common/copy_output_file.sh $bitsteam_generated_file $bitsteam_output_dir $BITSTREAMOUTPUTNAME
$SCRIPTSDIR/common/display_final_script_text.sh $? $bitsteam_output_file $bitsteam_generated_file

