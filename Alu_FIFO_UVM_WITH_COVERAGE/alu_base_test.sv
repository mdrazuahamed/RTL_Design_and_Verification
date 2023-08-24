`include "uvm_macros.svh"

import uvm_pkg::*;

class alu_base_test extends uvm_test;    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (alu_base_test)

    ////////////////////////////////////////
    // CLASS INSTANTIATIONS
    ////////////////////////////////////////

    alu_env env;
   
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "alu_base_test", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        env = alu_env::type_id::create($sformatf("env"), this);
    endfunction    

    ////////////////////////////////////////
    // TASKS
    ////////////////////////////////////////

    task run_phase (uvm_phase phase);
        uvm_top.print_topology();
    endtask

    task apply_reset();
        tb_top.apply_reset();
    endtask

    task start_clock();
        tb_top.start_clock();
    endtask

    task delay (int x);
        repeat (x) @ (posedge tb_top.clk_i);
    endtask

    task wait_cooldown(int wcnt = 10);
        int cnt;
        cnt = 0;
        while (cnt<wcnt) begin
            cnt++;
            @ (posedge tb_top.intf.clk_i);
            if (tb_top.intf.fifo_1_in_valid & tb_top.intf.fifo_1_in_ready) cnt = 0;
            if (tb_top.intf.fifo_2_in_valid & tb_top.intf.fifo_2_in_ready) cnt = 0;
            if (tb_top.intf.fifo_3_out_valid & tb_top.intf.fifo_3_out_ready) cnt = 0;
            if (tb_top.intf.fifo_4_in_valid & tb_top.intf.fifo_4_in_ready) cnt = 0;
        end
    endtask

endclass
