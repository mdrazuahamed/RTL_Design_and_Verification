module uart_top  #(
  	parameter DEPTH = 5
)
  (
	input 	logic 				clk,
	input 	logic 				rst,
    input 	logic [DEPTH-1:0] 	data_in,
    input 	logic 				enable,
    output  logic [DEPTH-1:0] 	data_out 
);
  
  logic txrx_connection;
uart MASTER
	(
      .clk			(clk),
	  .rx			(),
      .rst			(rst),
  	  .enable		(enable),
      .data_in		(data_in),
	  .tx			(txrx_connection),
  	  .data_out		()
 );
uart SLAVE
	(
      .clk			(clk),
	  .rx			(txrx_connection),
      .rst			(rst),
  	  .enable		(),
  	  .data_in		(),
	  .tx			(),
      .data_out		(data_out)
 );
  
endmodule



