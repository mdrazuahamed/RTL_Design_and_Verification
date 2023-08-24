
/////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2020-2023 DSI, Inc (All Rights Reserved)
//
// Project Name: Hydra
// Module Name:
//[MODULE NAME]
// Designer:
//[DESIGNER NAME]
// Description:
//[DESCRIPTION]
//
/////////////////////////////////////////////////////////////////////////////////
module apb_top_tb;

    logic         pclk;
    logic         presetn;
    logic  [31:0] paddr;
	logic  [3:0 ] psel;
	logic         penable;
	logic         pwrite;
	logic  [31:0] pwdata;
	logic  [ 3:0] pstrb;
	logic  [31:0] prdata;
	logic         pready;
    
    apb u_apb_top0( 
		.pclk(pclk),
		.preset(presetn),
		.paddr(paddr),
		.psel(psel),
		.penable(penable),
		.pwrite(pwrite),
		.pwdata(pwdata),
		.pstrb(pstrb),
		.prdata(prdata),
		.pready(pready)

	);



    always #5 pclk=!pclk;

    initial 
    begin
	   pclk=0;
	   @(posedge pclk) ;
	   presetn=0;
	   @(posedge pclk) ;
 	   presetn= 1;
	   pstrb = 4'b1111;
	   paddr= 20;
	   pwdata=50;
	   pwrite = 1'b1;
	   psel=4'b0001;
	   @(posedge pclk) ;
	   penable =1;
	   #15 penable =0;
	   pwrite = 0;
	   @(posedge pclk) ;
	   @(posedge pclk) ;
	   penable =1;


	    #200 $finish;

    end

endmodule