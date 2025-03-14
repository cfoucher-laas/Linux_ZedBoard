#
# File:      generate_bitstream_2015.2.sh
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
#            This script is used to generate a basic bitstream using Vivado.
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


# Access global environment
global env
set project_base_dir $::env(CURRENTPROJECTBASEDIR)

# Go

create_project hardware_design "$project_base_dir/hardware_design" -part xc7z020clg484-1
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
create_bd_design "design_1"
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
set_property -dict [list CONFIG.preset {ZedBoard}] [get_bd_cells processing_system7_0]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
endgroup
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
save_bd_design
close_bd_design [get_bd_designs design_1]
make_wrapper -files [get_files "$project_base_dir/hardware_design/hardware_design.srcs/sources_1/bd/design_1/design_1.bd"] -top
add_files -norecurse "$project_base_dir/hardware_design/hardware_design.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v"
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
generate_target all [get_files  "$project_base_dir/hardware_design/hardware_design.srcs/sources_1/bd/design_1/design_1.bd"]
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
exit

