`include "my_defs.svh"
`include "uvm_macros.svh"

module tb_top;

    import uvm_pkg::*;

    ///////////////////////////////////////////////////////////////////////////
    // markup
    ///////////////////////////////////////////////////////////////////////////

    initial $display ("%c[7;38m TEST STARTED %c[0m", 27, 27);
    final   $display ("%c[7;38m TEST ENDED %c[0m", 27, 27);

    ///////////////////////////////////////////////////////////////////////////
    // imports
    ///////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////
    // Localparam
    ///////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////
    // signals
    ///////////////////////////////////////////////////////////////////////////

    logic clk_i  ;
    logic arst_n ;

    ///////////////////////////////////////////////////////////////////////////
    // interface
    ///////////////////////////////////////////////////////////////////////////

    top_alu_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)) intf (
        .clk_i  (clk_i ), 
        .arst_n (arst_n) 
    );

    ///////////////////////////////////////////////////////////////////////////
    // dut
    ///////////////////////////////////////////////////////////////////////////

    top_alu_fifo #(
        .DATA_IN_WIDTH ( `DATA_IN_WIDTH )
    ) top_alu_fifo_dut (
        .clk_i            ( intf.clk_i            ),
        .arst_n           ( intf.arst_n           ),
        .fifo_1_in        ( intf.fifo_1_in        ),
        .fifo_1_in_valid  ( intf.fifo_1_in_valid  ),
        .fifo_1_in_ready  ( intf.fifo_1_in_ready  ),
        .fifo_2_in        ( intf.fifo_2_in        ),
        .fifo_2_in_valid  ( intf.fifo_2_in_valid  ),
        .fifo_2_in_ready  ( intf.fifo_2_in_ready  ),
        .out              ( intf.out              ),
        .fifo_3_out_valid ( intf.fifo_3_out_valid ),
        .fifo_3_out_ready ( intf.fifo_3_out_ready ),
        .fifo_4_in        ( intf.fifo_4_in        ),
        .fifo_4_in_valid  ( intf.fifo_4_in_valid  ),
        .fifo_4_in_ready  ( intf.fifo_4_in_ready  )
    );

    ///////////////////////////////////////////////////////////////////////////
    // methods
    ///////////////////////////////////////////////////////////////////////////

    task apply_reset ();
        clk_i                 = 1 ;
        arst_n                = 1 ;
        #100                      ;
        arst_n                = 0 ;
        intf.fifo_1_in_valid  = 0 ;
        intf.fifo_2_in_valid  = 0 ;
        intf.fifo_3_out_ready = 0 ;
        #100                      ;
        arst_n                = 1 ;
        #100                      ;
    endtask

    task start_clock ();
        fork
            forever begin
                clk_i = 1; #5;
                clk_i = 0; #5;
            end
        join_none
    endtask

    ///////////////////////////////////////////////////////////////////////////
    // procedurals
    ///////////////////////////////////////////////////////////////////////////

    initial begin
        
        $dumpfile("raw.vcd");
        $dumpvars;

        $display("%0d", `DATA_IN_WIDTH);

        uvm_config_db #(virtual top_alu_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)))::set(null, "*", "intf", intf);

        start_clock();

        run_test ("simple_test");
        
        $finish;
    end

endmodule
