// Code your design here
/////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2020-2023 Xcelerium, Inc (All Rights Reserved)
//
// Project Name: APB protoc
// Module Name:
//[MODULE NAME]
// Designer:
//[DESIGNER NAME]
// Description:
//[DESCRIPTION]
//
/////////////////////////////////////////////////////////////////////////////////

module apb 
#(
	parameter WIDTH = 8,
	parameter DEPTH = 100,
	parameter ID    = 0

) (
        input  logic           pclk,
	input  logic           presetn,
        input  logic    [31:0] paddr,
	input  logic           psel,
	input  logic           penable,
	input  logic           pwrite,
	input  logic    [31:0] pwdata,
	input  logic    [3:0 ] pstrb,
	output logic    [31:0] prdata,
        output logic           pready
);
//////////////////////////////////////////////////////////////////////////////
// Local Parameters
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// Functions
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// Signals
//////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////
    logic[WIDTH-1:0] mem [DEPTH-1:0];

	always_ff@(posedge pclk )
	begin
            if(!presetn)
		begin
		    pready <=1;
		    prdata <=0;
		end
            else
	    begin
	         pready<=1;
	         if(psel==ID && penable)
	         begin
	             pready<=0;
		     if(pwrite)
		     begin
		         for(int i=0; i<4;i++)
		         begin
                             if(pstrb[i])
	                         mem[paddr+i] <=pwdata[(8*(i+1)-1)-:8];
		         end
		      end
		      else
		      begin
		          for(int i=0; i<4;i++)
                              prdata[(8*(i+1)-1)-:8] <= mem[paddr+i];
		      end	
	          end 
	     end
        end
endmodule
