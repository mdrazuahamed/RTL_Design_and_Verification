`include "uvm_macros.svh"

import uvm_pkg::*;

class alu_agent extends uvm_agent;    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (alu_agent)

    ////////////////////////////////////////
    // CLASS INSTANTIATIONS
    ////////////////////////////////////////

    uvm_sequencer #(alu_seq_item) sqr;
    alu_dvr                 dvr;
    alu_mon                 mon;
   
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "alu_agent", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        sqr = uvm_sequencer #(alu_seq_item)::type_id::create($sformatf("sqr"), this);
        dvr = alu_dvr::type_id::create($sformatf("dvr"), this);
        mon = alu_mon::type_id::create($sformatf("mon"), this);
    endfunction

    function void connect_phase (uvm_phase phase);
        dvr.seq_item_port.connect(sqr.seq_item_export);
    endfunction

endclass
