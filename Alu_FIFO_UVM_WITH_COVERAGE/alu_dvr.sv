`include "my_defs.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;

class alu_dvr extends uvm_driver #(alu_seq_item);    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (alu_dvr)

    ////////////////////////////////////////
    // INTERFACE INSTANTIATIONS
    ////////////////////////////////////////

    virtual top_alu_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)) intf;

    ////////////////////////////////////////
    // CLASS INSTANTIATIONS
    ////////////////////////////////////////
    uvm_analysis_port #(alu_seq_item) dvr_analysis_port;
    local mailbox #(alu_seq_item) dvr_in_A      = new ();
    local mailbox #(alu_seq_item) dvr_in_B      = new ();
    local mailbox #(alu_seq_item) dvr_in_O      = new ();
    local mailbox #(alu_seq_item) dvr_in_opcode = new ();
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "alu_dvr", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        dvr_analysis_port = new ("dvr_analysis_port", this);
        if (!uvm_config_db #(virtual top_alu_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)))::get(null, "*", "intf", intf)) begin
            $display("FATAL %s %0d", `__FILE__, `__LINE__);
            $finish;
        end
    endfunction

    task run_phase (uvm_phase phase);
    
        fork

            forever begin
                alu_seq_item item;
                alu_seq_item item_A;
                alu_seq_item item_B;
                alu_seq_item item_O;
				alu_seq_item item_opcode;
                seq_item_port.get_next_item(item);
                item_A      = new item;
                item_B      = new item;
                item_O      = new item;
				item_opcode = new item;
                dvr_in_A.put      (item_A);
                dvr_in_B.put      (item_B);
                dvr_in_O.put      (item_O);
				dvr_in_opcode.put (item_opcode);
                seq_item_port.item_done();
            end

            forever begin
                alu_seq_item item;
                dvr_in_A.get(item);
                // PORAY repeat ($urandom_range(d_min, d_max)) @ (posedge intf.clk_i);
                intf.fifo_1_in       <= item.inA;
                intf.fifo_1_in_valid <= '1;
                do @ (posedge intf.clk_i);
                while (intf.fifo_1_in_ready !== '1);
                intf.fifo_1_in_valid <= '0;
            end

            forever begin
                alu_seq_item item;
                dvr_in_B.get(item);
                // PORAY repeat ($urandom_range(d_min, d_max)) @ (posedge intf.clk_i);
                intf.fifo_2_in       <= item.inB;
                intf.fifo_2_in_valid <= '1;
                do @ (posedge intf.clk_i);
                while (intf.fifo_2_in_ready !== '1);
                intf.fifo_2_in_valid <= '0;
            end

            forever begin
                alu_seq_item item;
                dvr_in_opcode.get(item);
                // PORAY repeat ($urandom_range(d_min, d_max)) @ (posedge intf.clk_i);
                intf.fifo_4_in       <= item.opcode;
                intf.fifo_4_in_valid <= '1;
                do @ (posedge intf.clk_i);
                while (intf.fifo_4_in_ready !== '1);
                intf.fifo_4_in_valid <= '0;
            end
            forever begin
                alu_seq_item item;
                dvr_in_O.get(item);
                // PORAY repeat ($urandom_range(d_min, d_max)) @ (posedge intf.clk_i);
                intf.fifo_3_out_ready <= '1;
                do @ (posedge intf.clk_i);
                while (intf.fifo_3_out_valid !== '1);
                intf.fifo_3_out_ready <= '0;
            end

        join_none

    endtask

endclass
