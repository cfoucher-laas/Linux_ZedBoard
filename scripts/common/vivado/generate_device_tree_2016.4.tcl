#
# File:      generate_device_tree_2016.4.sh
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
# Date:      2017-02-08
#
# Description:
#
#            This script is used to generate a device tree using XSDK.
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2017-02-08  First release.
#



#########
# Begin #
#########


# Access global environment
global env
set project_base_dir $::env(CURRENTPROJECTBASEDIR)

# Go
#create_project hardware_design "$sdk_work_dir" -part xc7z020clg484-1

setws "$sdk_work_dir"
repo -set $DEVICETREESOURCESFOLDER
createhw –name hw0 –hwspec /tmp/wrk/system.hdf

exit

