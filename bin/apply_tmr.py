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
    filter=lambda x: x.item.reference.is_leaf()))

instances_to_replicate = list(x.item for x in hinstances_to_replicate)
print(f"Instances to replicate: {len(instances_to_replicate)}")

# Replicate all INPUT ports
#hports_to_replicate = list(netlist.get_hports(filter = lambda x: x.item.direction is sdn.IN))
#ports_to_replicate = list(x.item for x in hports_to_replicate)
#print(f"Ports to replicate: {len(ports_to_replicate)}")

# Replicate only internal state - no ports
hports_to_replicate = []
ports_to_replicate = []
print(f"Ports to replicate: {len(ports_to_replicate)}")

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
