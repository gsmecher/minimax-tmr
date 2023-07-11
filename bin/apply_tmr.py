#!/usr/bin/env python3

import sys
sys.path.append('spydrnet-tmr')
sys.path.append('spydrnet')

import spydrnet as sdn
import spydrnet_tmr as tmr

from spydrnet.uniquify import uniquify

from spydrnet_tmr.analysis.voter_insertion.find_after_ff_voter_points import find_after_ff_voter_points
from spydrnet_tmr.support_files.vendor_names import XILINX
from spydrnet_tmr.transformation.replication.organ import XilinxTMRVoter

netlist = sdn.parse('minimax.edif')
uniquify(netlist)

# Replicate all leaf nodes
hinstances_to_replicate = list(netlist.get_hinstances(
    recursive=True,
    filter=lambda x: x.item.reference.is_leaf()
        and "vcc" not in x.name.lower()
        and "gnd" not in x.name.lower()
        and "ibuf" not in x.name.lower()
        and 'ibuf' not in x.item.reference.name.lower()
    ))

instances_to_replicate = [x.item for x in hinstances_to_replicate]
print(f"Instances to replicate: {len(instances_to_replicate)}")

# Replicate instruction and reset ports
replicated_ports = {
    "reset",
    "inst[15:0]",
    "inst_ce",
    "inst_addr[11:0]",
    "addr[31:0]",
    "wdata[31:0]",
    "rdata[31:0]",
    "wmask[3:0]",
    "rreq",
    "rack",
}
print([p.name for p in netlist.get_hports()])
hports_to_replicate = list(netlist.get_hports(
    filter = lambda x: x.name.lower() in replicated_ports))

ports_to_replicate = [x.item for x in hports_to_replicate]
print(f"Ports to replicate: {len(ports_to_replicate)} ({', '.join(p.name for p in ports_to_replicate)})")
assert len(replicated_ports) == len(ports_to_replicate)

# Insertion points
insertion_points = find_after_ff_voter_points(
        netlist,
        [*hinstances_to_replicate, *hports_to_replicate],
        XILINX)
print(f"Insertion points: {len(insertion_points)}")

replicas = tmr.apply_nmr([*instances_to_replicate, *ports_to_replicate], 3, name_suffix='TMR', rename_original=True)
tmr.uniquify_nmr_property(replicas, {"HBLKNM", "HLUTNM", "SOFT_HLUTNM"}, "TMR")

voters = tmr.insert_organs(replicas, insertion_points, XilinxTMRVoter(), 'VOTER')

sdn.compose(netlist, "minimax_tmr.edif")
