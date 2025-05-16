# MAIN-ONLY: DO NOT MODIFY THIS FILE
#
# Copyright © Telecom Paris
# Copyright © Renaud Pacalet (renaud.pacalet@telecom-paris.fr)
# 
# This file must be used under the terms of the CeCILL. This source
# file is licensed as described in the file COPYING, which you should
# have received as part of this distribution. The terms are also
# available at:
# https://cecill.info/licences/Licence_CeCILL_V2.1-en.html
#

set_msg_config -id {[Board 49-26]} -severity WARNING -suppress
set_msg_config -id {[Designutils 20-3303]} -severity WARNING -suppress
set_msg_config -id {[IP_Flow 19-240]} -severity WARNING -suppress
set_msg_config -id {[IP_Flow 19-5098]} -severity {CRITICAL WARNING} -new_severity WARNING
set_msg_config -id {[IP_Flow 19-5655]} -severity {CRITICAL WARNING} -new_severity WARNING
set_msg_config -id {[IP_Flow 19-11770]} -severity WARNING -suppress
set_msg_config -id {[Opt 31-1131]} -severity WARNING -suppress
set_msg_config -id {[PSU-} -severity {CRITICAL WARNING} -string "PS DDR interfaces might fail when entering negative DQS skew values" -suppress
set_msg_config -id {[Synth 8-7080]} -severity WARNING -suppress
set_msg_config -id {[Vivado_Tcl 4-921]} -severity WARNING -suppress

set board [get_board_parts digilentinc.com:zybo:part0:1.0]
set part xc7z010clg400-1

proc usage {} {
    puts "
usage: vivado -mode batch -source <script>
    <script>: TCL script"
    exit -1
}

set script [file normalize [info script]]
set dir [file dirname $script]
regsub {\..*} [file tail $script] "" design
set params $dir/$design.params.tcl

if [file exists $params] {
    source $params
} else {
    puts "
Error: parameter file $params not found. Aborting."
    exit -1
}

if { $argc != 0 } {
    usage
}

puts "*********************************************"
puts "Summary of build parameters"
puts "*********************************************"
puts "Board: $board"
puts "Part: $part"
puts "Root directory: $dir"
puts "Design name: $design"
puts "Frequency: $f_mhz MHz"
puts "*********************************************"

#############
# Create IP #
#############
create_project -part $part $design $design
set_property board_part $board [current_project]
foreach {du lib} [array get dus] {
    read_vhdl -vhdl2008 -library $lib $dir/$du
}
ipx::package_project -force_update_compile_order -import_files -root_dir $design -vendor www.telecom-paris.fr -library DS -force $design
close_project

###########################
# Create top level design #
###########################
set top ${design}_top
set_part $part
set_property board_part $board [current_project]
set_property ip_repo_paths [list ./$design] [current_fileset]
update_ip_catalog
create_bd_design $top
set ip [create_bd_cell -type ip -vlnv [get_ipdefs *www.telecom-paris.fr:DS:$design:*] $design]
set ps7 [create_bd_cell -type ip -vlnv [get_ipdefs *xilinx.com:ip:processing_system7:*] ps7]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" } $ps7
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ $f_mhz] $ps7
set_property -dict [list CONFIG.PCW_USE_M_AXI_GP0 {1}] $ps7
set_property -dict [list CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {1}] $ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_ACP {1}] $ps7

# Interconnections
# ps7 - ip
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config [list Master "$ps7/M_AXI_GP0" Clk "Auto"] [get_bd_intf_pins $ip/s0_axi]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config [list Master "$ip/m0_axi" Clk "Auto" ]  [get_bd_intf_pins $ps7/S_AXI_ACP]

# Addresses ranges
set_property offset 0x40000000 [get_bd_addr_segs -of_object [get_bd_intf_pins /$ps7/M_AXI_GP0]]
set_property range 4K [get_bd_addr_segs -of_object [get_bd_intf_pins /$ps7/M_AXI_GP0]]

# Synthesis flow
validate_bd_design
save_bd_design
generate_target all [get_files $top.bd]
make_wrapper -top [get_files $top.bd] -import -force
# write_hwdef -force -file $design.hwdef
synth_design -top $top

# IOs
foreach io [ array names ios ] {
    set pin [ lindex $ios($io) 0 ]
    set std [ lindex $ios($io) 1 ]
    set_property package_pin $pin [get_ports $io]
    set_property iostandard $std [get_ports [list $io]]
}

# Implementation
opt_design
place_design
route_design

# Reports
report_utilization -force -file $design.utilization.rpt
report_utilization -hierarchical -force -file $design.utilization.hierarchical.rpt
report_timing_summary -file $design.timing.rpt

# Bitstream
write_bitstream -force fpga.bit
write_hw_platform -fixed -force -file $design.xsa

# Messages
puts ""
puts "*********************************************"
puts "\[VIVADO\]: done"
puts "*********************************************"
puts "Summary of build parameters"
puts "*********************************************"
puts "Board: $board"
puts "Part: $part"
puts "Root directory: $dir"
puts "Design name: $design"
puts "Frequency: $f_mhz MHz"
puts "*********************************************"
puts "  bitstream in fpga.bit"
puts "  hardware definition file in $design.xsa"
puts "  flat resource utilization report in $design.utilization.rpt"
puts "  hierarchical resource utilization report in $design.utilization.hierarchical.rpt"
puts "  timing report in $design.timing.rpt"
puts "*********************************************"

# Quit
quit

# vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=0:
