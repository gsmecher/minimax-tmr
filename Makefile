default: minimax_tmr.edif

.PHONY: default clean

clean:
	-rm -f minimax.edif minimax_tmr.edif

minimax.edif: bin/export_edif.tcl minimax/rtl/minimax.v
	bin/export_edif.tcl

minimax_tmr.edif: bin/apply_tmr.py minimax.edif
	bin/apply_tmr.py
