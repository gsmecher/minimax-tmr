#!/usr/bin/env -S vivado -mode tcl -source

# Export a single minimax core to EDIF for TMRing

read_verilog -sv minimax/rtl/minimax.v
set_property part "xcku060-ffva1517-1-c" [current_project]

synth_design -top minimax
write_edif -force minimax.edif
quit
