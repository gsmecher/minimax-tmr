#!/usr/bin/env -S vivado -mode tcl -source

# Open Vivado to view the generated EDIF.

create_project -force wrapper wrapper -part xc7a35t-csg324-1
read_edif minimax.edif
read_edif minimax_tmr.edif
read_vhdl -vhdl2008 rtl/wrapper.vhd
read_verilog rtl/minimax_bb.v
add_files -fileset constrs_1 rtl/arty_a7.xdc
add_files minimax/asm/blink.mem
set_property top wrapper [current_fileset]
launch_runs impl_1 -jobs 8

start_gui
