`include "my_defs.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;


covergroup cov_ with function sample (
    input bit [2:0] opc
);
    coverpoint opc {
        bins tx_opc [] = {[0:7]};
    }
endgroup


class alu_scbd extends uvm_scoreboard;    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (alu_scbd)

    //////////////////////////////////////////////////////////////////////////////////
    // SIGNALS
    //////////////////////////////////////////////////////////////////////////////////

    alu_rsp_item rsp_Q[$];
    int PASS;
    int FAIL;
    logic [8:0] TEMP;
    cov_ my_cvr=new();
    
    //////////////////////////////////////////////////////////////////////////////////
    // ANALYSIS PORTS
    //////////////////////////////////////////////////////////////////////////////////

    uvm_analysis_imp #(alu_rsp_item, alu_scbd) m_analysis_imp;
   
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "alu_scbd", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        m_analysis_imp = new ($sformatf("m_analysis_imp"), this);
    endfunction

    function void write (alu_rsp_item rsp);
        rsp_Q.push_back(rsp);
    endfunction

    function void extract_phase (uvm_phase phase);
        alu_rsp_item item;
        PASS = 0;
        FAIL = 0;
        while (rsp_Q.size()) begin
            item = rsp_Q.pop_front();
            my_cvr.sample(item.opcode);
			case(item.opcode)
                3'b000: 
                     if ((~item.inA ) == item.out[7:0]) begin 
                         PASS++; 
                         $display ("%c[0;32m PASSED ~%b = %b %c[0m", 27, item.inA, item.out[7:0],27);
                     end
				     else begin 
                         FAIL++;
                         $display ("%c[0;31m FAILED ~%3d= %3d %c[0m", 27, item.inA, item.out, 27);
                     end

                3'b001: 
                     if ((item.inA + item.inB) == item.out) begin 
                         PASS++; 
                         $display ("%c[0;32m PASSED %3d + %3d= %3d %c[0m", 27, item.inA, item.inB, item.out, 27);
                     end
				     else begin 
                         FAIL++;
                         $display ("%c[0;31m FAILED %3d + %3d = %3d %c[0m", 27, item.inA, item.inB, item.out, 27);
                     end
			   
                3'b010: 
                    if(item.inA < item.inB)
					begin
                         if ((item.inA - item.inB) == item.out) begin 
                            TEMP =~(item.out)+1'b1;
						    PASS++; 
							$display ("%c[0;32m PASSED %3d - %3d= -%3d %c[0m", 27, item.inA, item.inB, TEMP, 27);

					     end
					 end
			    	else if(item.inA > item.inB)
				    begin
                         if ((item.inA - item.inB) == item.out) begin 
					        PASS++; 
                            $display ("%c[0;32m PASSED %3d - %3d= %3d %c[0m", 27, item.inA, item.inB, item.out, 27);
					     end
				     end
					

				     else begin 
                         FAIL++;
                         $display ("%c[0;31m FAILED %3d - %3d = %3d %c[0m", 27, item.inA, item.inB, TEMP, 27);
                     end

                3'b011: 
                     if ((item.inA / item.inB) == item.out[7:0]) begin 
                         PASS++; 
                         $display ("%c[0;32m PASSED %3d / %3d= %3d %c[0m", 27, item.inA, item.inB, item.out[7:0], 27);
                     end
				     else begin 
                         FAIL++;
                         $display ("%c[0;31m FAILED %3d / %3d = %3d %c[0m", 27, item.inA, item.inB, item.out[7:0], 27);
                     end

                3'b100: 
                     if ((item.inA % item.inB) == item.out[7:0]) begin 
                         PASS++; 
                         $display ("%c[0;32m PASSED %3d mod %3d= %3d %c[0m", 27, item.inA, item.inB, item.out[7:0], 27);
                     end
				     else begin 
                         FAIL++;
                         $display ("%c[0;31m FAILED %3d mod %3d= %3d %c[0m", 27, item.inA, item.inB, item.out[7:0], 27);
                     end
					 
                3'b101: 
                     if ((item.inA & item.inB) == item.out[7:0]) begin 
                         PASS++; 
                         $display ("%c[0;32m PASSED %b & %b= %b %c[0m", 27, item.inA, item.inB, item.out[7:0], 27);
                     end
				     else begin 
                         FAIL++;
                         $display ("%c[0;31m FAILED %b & %b= %b %c[0m", 27, item.inA, item.inB, item.out[7:0], 27);
                     end
					 
                3'b110: 
                     if ((item.inA | item.inB) == item.out[7:0]) begin 
                         PASS++; 
                         $display ("%c[0;32m PASSED %b | %b= %b %c[0m", 27, item.inA, item.inB, item.out[7:0], 27);
                     end
				     else begin 
                         FAIL++;
                         $display ("%c[0;31m FAILED %b | %b= %b %c[0m", 27, item.inA, item.inB, item.out[7:0], 27);
                     end
					 
                3'b111: 
                     if ((item.inA ^ item.inB) == item.out[7:0]) begin 
                         PASS++; 
                         $display ("%c[0;32m PASSED %b ^ %b= %b %c[0m", 27, item.inA, item.inB, item.out[7:0], 27);
                     end
				     else begin 
                         FAIL++;
                         $display ("%c[0;31m FAILED %b ^ %b= %b %c[0m", 27, item.inA, item.inB, item.out[7:0], 27);
                     end
             endcase
        end
        if (FAIL) $write("%c[7;31m", 27);
        else      $write("%c[7;32m", 27);
        $display("%0d/%0d PASSED%c[0m", PASS, PASS + FAIL, 27);
    endfunction

endclass
