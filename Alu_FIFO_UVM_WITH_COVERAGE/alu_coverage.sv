
`include "uvm_macros.svh"
  import uvm_pkg::*;

class alu_coverage #(type T=alu_seq_item) extends uvm_subscriber #(T);
////////////////////////////////////////
// UVM FACTORY REGISTRATION
////////////////////////////////////////

	`uvm_component_utils(alu_coverage)
////////////////////////////////////////
// CLASS INSTANTIATIONS
////////////////////////////////////////
	//alu_seq_item   item;
	T   item;


	virtual top_alu_fifo_intf vif;
    uvm_analysis_imp#(T,alu_coverage) analysis_imp;
	covergroup alu_cg ;//@(posedge vif.clk_i);
	    option.per_instance=1;
		option.goal=100;
	    inA      : coverpoint item.inA{
                      bins a1={'b0};  
			          bins a2={'b1};
                      bins a3={[1:254]};
	    }    
	    inB      : coverpoint item.inB{
                      bins b1={'b0};  
			          bins b2={'b1};
                      bins b3={[1:254]};
	    }
		opcode: coverpoint item.opcode{
			          bins op_invert ={3'b000};
			          bins op_add    ={3'b001};
			          bins op_sub    ={3'b010};
			          bins op_divided={3'b011};
			          bins op_mod    ={3'b100};
			          bins op_and   ={3'b101};
			          bins op_or    ={3'b110};
			          bins op_xor   ={3'b111};
		}

	endgroup
    function new(string name="alu_coverage",uvm_component parent );
        super.new(name,parent);
        alu_cg 	= new;
	endfunction

    function void build_phase(uvm_phase phase);
         super.build_phase (phase);
		//     analysis_imp=new("analysis_imp",this);  
    endfunction
     
   function void write(T t);
      //  this.item=item;
	  	`uvm_info("SEQ","SEQUENCE TRANSACTIONS",UVM_NONE);
		item = t;
	    alu_cg.sample();
   endfunction

endclass
