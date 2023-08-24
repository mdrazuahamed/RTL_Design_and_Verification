`include "my_defs.svh"

`include "uvm_macros.svh"

import uvm_pkg::*;

class alu_seq_item extends uvm_sequence_item;

    `uvm_object_utils(alu_seq_item)
        
    rand bit [`DATA_IN_WIDTH-1:0] inA;
    rand bit [`DATA_IN_WIDTH-1:0] inB;
    rand bit [`OPCODE         :0] opcode;

    function string to_string();
        string txt;
        $sformat(txt, "inA:0x%h inB:0x%h", inA, inB);
        return txt;
    endfunction 

    function new(string name = "alu_seq_item");
        super.new(name);
    endfunction

endclass
