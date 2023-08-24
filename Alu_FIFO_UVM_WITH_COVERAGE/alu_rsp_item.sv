`include "my_defs.svh"

class alu_rsp_item extends alu_seq_item;
    
    `uvm_object_utils(alu_rsp_item)

    bit [`DATA_IN_WIDTH:0] out;

    function string to_string();
        string txt;
        txt = super.to_string();
        $sformat(txt, "%s out:0x%h ", txt, out);
        return txt;
    endfunction 

    function new(string name = "alu_rsp_item");
        super.new(name);
    endfunction

endclass
