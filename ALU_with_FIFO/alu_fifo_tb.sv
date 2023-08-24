`timescale 1ns / 1ps



module tb_top_alu_fifo ;
   /////////////////////////////////////////////////////////////////////////////
  // LOCALPARAMETERS
  /////////////////////////////////////////////////////////////////////////////

  localparam DATA_IN_WIDTH = 8;
  
  /////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  /////////////////////////////////////////////////////////////////////////////
  logic                     clk_i;
  logic                     arst_n;

  logic [DATA_IN_WIDTH-1:0] fifo_1_in;
  logic  					fifo_1_in_valid;
  logic   				    fifo_1_in_ready;
  
  logic [DATA_IN_WIDTH-1:0] fifo_2_in;
  logic 					fifo_2_in_valid;
  logic  				    fifo_2_in_ready;
  logic [DATA_IN_WIDTH-1:0] out;
  logic                     fifo_3_out_valid;
  logic                     fifo_3_out_ready;
    
  logic [DATA_IN_WIDTH-1:0] fifo_1_in_for_dvr [$];
  logic [DATA_IN_WIDTH-1:0] fifo_1_in_for_mon [$];
  logic [DATA_IN_WIDTH-1:0] fifo_2_in_for_dvr [$];
  logic [DATA_IN_WIDTH-1:0] fifo_2_in_for_mon [$];
  logic [DATA_IN_WIDTH-1:0] fifo_3_in_for_dvr [$];
  logic [DATA_IN_WIDTH-1:0] fifo_3_in_for_mon [$];
  
  int pass;
  int fail;

   /////////////////////////////////////////////////////////////////////////////
  // INTERFACE
  /////////////////////////////////////////////////////////////////////////////
  
  /////////////////////////////////////////////////////////////////////////////
  // CONNECTIONS
  /////////////////////////////////////////////////////////////////////////////
  
  /////////////////////////////////////////////////////////////////////////////
  // DUT
  /////////////////////////////////////////////////////////////////////////////

top_adder_fifo #(
  .DATA_IN_WIDTH(DATA_IN_WIDTH)
) u_ins1 (
  	.clk_i            (clk_i ),
  	.arst_n           (arst_n),

  	.fifo_1_in        (fifo_1_in),
  	.fifo_1_in_valid  (fifo_1_in_valid),
  	.fifo_1_in_ready  (fifo_1_in_ready),
  
  	.fifo_2_in        (fifo_2_in),
  	.fifo_2_in_valid  (fifo_2_in_valid),
  	.fifo_2_in_ready  (fifo_2_in_ready),
  	.out              (out ),
  	.fifo_3_out_valid (fifo_3_out_valid),
  	.fifo_3_out_ready (fifo_3_out_ready));
   /////////////////////////////////////////////////////////////////////////////
  // CLASS INSTANCIATIONS
  /////////////////////////////////////////////////////////////////////////////
  
  /////////////////////////////////////////////////////////////////////////////
  // METHODS
  /////////////////////////////////////////////////////////////////////////////
  task apply_reset ();
    clk_i          <= 1; 
    arst_n         <= 1;
    fifo_1_in      <= 0; 
    fifo_2_in      <= 0; 
    
    fifo_1_in_valid<=0; 
    fifo_1_in_valid<=0; 
    fifo_3_out_ready<= 0; 
    fifo_1_in_for_dvr.delete();
    fifo_1_in_for_mon.delete();
    fifo_2_in_for_dvr.delete();
    fifo_2_in_for_mon.delete();
    fifo_3_in_for_dvr.delete();
    fifo_3_in_for_mon.delete();
    #100;
    arst_n         <= 0; 
    #100;
    arst_n         <= 1; 
    #100;
  endtask

  task start_clock ();
    fork
      forever begin
        clk_i = 1; #5;
        clk_i = 0; #5;
      end
    join_none
    repeat (2) @ (posedge clk_i);
  endtask

  /////////////////////////////////////////////////////////////////////////////
  // DRIVE
  /////////////////////////////////////////////////////////////////////////////

  task generate_sequence(int num = 1);
    for (int i = 0; i < num; i++) begin
        fifo_1_in_for_dvr.push_back($random);
        fifo_2_in_for_dvr.push_back($random);    
      // data_for_dvr.push_back($random);
    end
  endtask

  task run_in_driver();
    fork
      forever begin
        if (fifo_1_in_for_dvr.size()) begin
          fifo_1_in      <= fifo_1_in_for_dvr.pop_front();
          fifo_1_in_valid <= '1;
          do @ (posedge clk_i);
          while (fifo_1_in_ready !== 1);
          fifo_1_in_valid <= '0;                    
        end
        else begin
          @ (posedge clk_i);        
        end
      end
      forever begin
        if (fifo_2_in_for_dvr.size()) begin
          fifo_2_in      <= fifo_2_in_for_dvr.pop_front();
          fifo_2_in_valid <= '1;
          do @ (posedge clk_i);
          while (fifo_2_in_ready !== 1);
          fifo_2_in_valid <= '0;                    
        end
        else begin
          @ (posedge clk_i);        
        end
      end
    join_none
  endtask

  task run_out_driver();
    fork
      forever begin
        fifo_3_out_ready <= 1;
        @ (posedge clk_i);
      end
    join_none
  endtask

  /////////////////////////////////////////////////////////////////////////////
  // MONITORING
  /////////////////////////////////////////////////////////////////////////////
  
  
    always @(posedge clk_i) begin
      if (fifo_3_out_valid & fifo_3_out_ready) begin
        //fifo_3_in_for_mon.push_back(fifo_3_out);
        fifo_3_in_for_mon.push_back(out);
    end    
  end
  
  always @(posedge clk_i) begin
    if (fifo_3_out_valid & fifo_3_out_ready) begin
      if (out == fifo_3_in_for_mon.pop_front()) begin
         pass++;
      end
      else begin
        fail++;
      end
    end    
  end

  task wait_cooldown();
    static int cnt = 0;
    while ((cnt < 10) || fifo_3_in_for_dvr.size() || fifo_3_in_for_mon.size()) begin
      @ (posedge clk_i);
      cnt++;
      if (fifo_3_out_valid & fifo_3_out_ready) cnt = 0;
    end
  endtask
  
  
  /////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  /////////////////////////////////////////////////////////////////////////////

  initial begin
	$dumpfile("dump.vcd"); $dumpvars;
    apply_reset();
    generate_sequence(1000);
    start_clock();
    run_in_driver();
    run_out_driver();
    wait_cooldown();
    $finish();
  end

  final begin
    $display("\n\n\nSimulation has ended");
    $display("%0d/%0d PASSED\n\n\n", pass, pass+fail);
  end

endmodule

