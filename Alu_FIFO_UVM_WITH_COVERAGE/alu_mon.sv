`include "my_defs.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;

class alu_mon extends uvm_monitor;    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (alu_mon)

    ////////////////////////////////////////
    // INTERFACE INSTANTIATIONS
    ////////////////////////////////////////

    virtual top_alu_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)) intf;

    ////////////////////////////////////////
    // ANALYSIS PORTS{{{
    ////////////////////////////////////////

    uvm_analysis_port #(alu_rsp_item) mon_analysis_port;
    local mailbox #(alu_rsp_item) mon_in_A      = new ();
    local mailbox #(alu_rsp_item) mon_in_B      = new ();
    local mailbox #(alu_rsp_item) mon_in_O      = new ();
    local mailbox #(alu_rsp_item) mon_in_opcode = new ();
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "alu_mon", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        mon_analysis_port = new ("mon_analysis_port", this);
        if (!uvm_config_db #(virtual top_alu_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)))::get(null, "*", "intf", intf)) begin
            $display("FATAL %s %0d", `__FILE__, `__LINE__);
            $finish;
        end
    endfunction

    
    task run_phase (uvm_phase phase);
    
        fork

            forever begin
                @ (posedge intf.clk_i);
                if (intf.fifo_1_in_valid & intf.fifo_1_in_ready) begin
                    alu_rsp_item item;
                    item = new ();
                    item.inA = intf.fifo_1_in;
                    mon_in_A.put(item);
                end
            end

            forever begin
                @ (posedge intf.clk_i);
                if (intf.fifo_2_in_valid & intf.fifo_2_in_ready) begin
                    alu_rsp_item item;
                    item = new ();
                    item.inB = intf.fifo_2_in;
                    mon_in_B.put(item);
                end
            end
			
            forever begin
                @ (posedge intf.clk_i);
                if (intf.fifo_4_in_valid & intf.fifo_4_in_ready) begin
                    alu_rsp_item item;
                    item = new ();
                    item.opcode = intf.fifo_4_in;
                    mon_in_opcode.put(item);
                end
            end

            forever begin
                @ (posedge intf.clk_i);
                if (intf.fifo_3_out_valid & intf.fifo_3_out_ready) begin
                    alu_rsp_item item;
                    item = new ();
                    item.out = intf.out;
                    mon_in_O.put(item);
                end
            end

            forever begin
                alu_rsp_item item_A;
                alu_rsp_item item_B;
                alu_rsp_item item_O;
                alu_rsp_item item_opcode;
				alu_rsp_item item;
                item = new ();
                mon_in_A.get     (item_A);
                mon_in_B.get     (item_B);
                mon_in_O.get     (item_O);
                mon_in_opcode.get(item_opcode);
                item.inA    = item_A.inA;
                item.inB    = item_B.inB;
                item.out    = item_O.out;
				item.opcode = item_opcode.opcode;
                mon_analysis_port.write(item);
            end
		join_none
    endtask


endclass
