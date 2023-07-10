#!/usr/bin/env -S vivado -mode tcl -source

# Export a single minimax core to EDIF for TMRing

read_verilog -sv minimax/rtl/minimax.v
set_property part "xc7a35t-csg324-1" [current_project]

set_property generic { UC_BASE=12'h800 } [current_fileset]
synth_design -top minimax
write_edif -force minimax.edif
quit
