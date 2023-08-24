`include "adder_verif_pkg.sv"

module tb_top;

	///////////////////////////////////////////////////////////////////////////
	// markup
	///////////////////////////////////////////////////////////////////////////

	initial $display ("%c[7;38m TEST STARTED %c[0m", 27, 27);
	final   $display ("%c[7;38m TEST ENDED %c[0m", 27, 27);

	///////////////////////////////////////////////////////////////////////////
	// imports
	///////////////////////////////////////////////////////////////////////////

	import adder_verif_pkg::adder_seq_item;
	import adder_verif_pkg::adder_rsp_item;
	import adder_verif_pkg::adder_dvr;
	import adder_verif_pkg::adder_mon;
	import adder_verif_pkg::adder_scbd;

	///////////////////////////////////////////////////////////////////////////
	// Localparam
	///////////////////////////////////////////////////////////////////////////

	localparam  TEST_COUNT    = 10;
	localparam  DATA_IN_WIDTH = 8;

	///////////////////////////////////////////////////////////////////////////
	// Typedeg  
	///////////////////////////////////////////////////////////////////////////

	typedef adder_seq_item # (.DATA_IN_WIDTH (DATA_IN_WIDTH)) seq_item_t;
	typedef adder_rsp_item # (.DATA_IN_WIDTH (DATA_IN_WIDTH)) rsp_item_t;

	///////////////////////////////////////////////////////////////////////////
	// class inst
	///////////////////////////////////////////////////////////////////////////

	adder_dvr  # (.DATA_IN_WIDTH (DATA_IN_WIDTH)) dvr ;
	adder_mon  # (.DATA_IN_WIDTH (DATA_IN_WIDTH)) mon ;
	adder_scbd # (.DATA_IN_WIDTH (DATA_IN_WIDTH)) scbd;
	mailbox    #(seq_item_t) dvr_mbx;
	mailbox    #(rsp_item_t) scbd_mbx;

	///////////////////////////////////////////////////////////////////////////
	// signals
	///////////////////////////////////////////////////////////////////////////

	logic clk_i  ;
	logic arst_n ;

	///////////////////////////////////////////////////////////////////////////
	// interface
	///////////////////////////////////////////////////////////////////////////

	top_adder_fifo_intf #(.DATA_IN_WIDTH(DATA_IN_WIDTH)) intf (
		.clk_i  (clk_i ), 
		.arst_n (arst_n) 
	);

	///////////////////////////////////////////////////////////////////////////
	// dut
	///////////////////////////////////////////////////////////////////////////

	top_adder_fifo #(
		.DATA_IN_WIDTH ( DATA_IN_WIDTH )
	) top_adder_fifo_dut (
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
		.fifo_3_out_ready ( intf.fifo_3_out_ready )
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

	task wait_idle ();
		static int cnt = 0;
		while (cnt < 50) begin
			@ (posedge clk_i);
			cnt++;
			if ( intf.fifo_1_in_valid  & intf.fifo_1_in_ready  ) cnt = 0;
			if ( intf.fifo_2_in_valid  & intf.fifo_2_in_ready  ) cnt = 0;
			if ( intf.fifo_3_out_valid & intf.fifo_3_out_ready ) cnt = 0;
		end
	endtask

	///////////////////////////////////////////////////////////////////////////
	// procedurals
	///////////////////////////////////////////////////////////////////////////

	initial begin
		
		// BUILD PHASE -----------------------------
		dvr      = new (intf);
		mon      = new (intf);
		scbd     = new ();
		dvr_mbx  = new ();
		scbd_mbx = new ();

		// CONNECT PHASE ---------------------------
		dvr.dvr_mbx   = dvr_mbx ;
		mon.mon_mbx   = scbd_mbx;
		scbd.scbd_mbx = scbd_mbx;

		// RUN PHASE -------------------------------

		$dumpfile("raw.vcd");
		$dumpvars;

		apply_reset();
		start_clock();

		dvr.run();
		mon.run();

		for (int i = 0; i < TEST_COUNT; i++) begin
			seq_item_t item;
			item = new ();
			item.randomize();
			dvr_mbx.put(item);
		end

		wait_idle ();

		// EXTRACT PHASE ---------------------------
		scbd.check_items();

		$finish;
	end

	///////////////////////////////////////////////////////////////////////////
	// sata hoisay
	///////////////////////////////////////////////////////////////////////////

	initial begin
		#33300;
		repeat (TEST_COUNT) #1000;
		$display("%c[7;31m SATA HOISAY %c[0m", 27, 27);
		$finish;
	end

endmodule
