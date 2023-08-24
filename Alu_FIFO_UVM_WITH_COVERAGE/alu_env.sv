`include "uvm_macros.svh"

import uvm_pkg::*;

class alu_env extends uvm_env;    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (alu_env)

    ////////////////////////////////////////
    // CLASS INSTANTIATIONS
    ////////////////////////////////////////

    alu_agent       agent;
    alu_scbd        scbd;
   // alu_coverage    cov;  
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "alu_env", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        agent = alu_agent::type_id::create($sformatf("agent"), this);
        scbd  = alu_scbd::type_id::create($sformatf("scbd"), this);
       // cov   = alu_coverage::type_id::create($sformatf("cov"), this);
     
    endfunction

    function void connect_phase (uvm_phase phase);
        agent.mon.mon_analysis_port.connect(scbd.m_analysis_imp);
        //agent.dvr.dvr_analysis_port.connect(cov.cov_analysis_imp);
    endfunction

endclass
