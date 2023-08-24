module top_adder_fifo #(
  parameter DATA_IN_WIDTH = 8
) (
  input logic                     clk_i,
  input logic                     arst_n,

  input logic [DATA_IN_WIDTH-1:0] fifo_1_in,
  input logic  					  fifo_1_in_valid,
  output logic   				  fifo_1_in_ready,
  
  input  logic [DATA_IN_WIDTH-1:0] fifo_2_in,
  input  logic 					   fifo_2_in_valid,
  output logic  				   fifo_2_in_ready,
  output logic  [DATA_IN_WIDTH:0] out,
  output logic  fifo_3_out_valid,
  input logic   fifo_3_out_ready
  
 );
  logic  					 fifo_3_in_valid;
  logic  					 fifo_3_in_ready;
 
  logic  					 fifo_1_out_valid;
  logic  					 fifo_1_out_ready;
  
  logic  					 fifo_2_out_valid;
  logic  					 fifo_2_out_ready;
  logic [DATA_IN_WIDTH-0:0]  alu_out;
  
  logic [DATA_IN_WIDTH-1:0]	 in_A;
  logic [DATA_IN_WIDTH-1:0]	 in_B;
  
  adder #(
  .DATA_IN_WIDTH(DATA_IN_WIDTH)
)
  ins0(
    .clk_i(clk_i),
  .arst_n(arst_n),

  .in_A(in_A),
  .in_A_valid(fifo_1_out_valid),
  .in_A_ready(fifo_1_out_ready),

  .in_B(in_B),
  .in_B_valid(fifo_2_out_valid),
  .in_B_ready(fifo_2_out_ready),

  .out(alu_out),
  .out_valid(fifo_3_in_valid),
  .out_ready(fifo_3_in_ready)
);
  

 fifo #(
  .DATA_WIDTH(DATA_IN_WIDTH)

  )
  ins1(
  .clk_i(clk_i),
  .arst_n(arst_n),

  .data_in(fifo_1_in),
  .data_in_valid(fifo_1_in_valid),
  .data_in_ready(fifo_1_in_ready),

  .data_out(in_A),
  .data_out_valid(fifo_1_out_valid),
  .data_out_ready(fifo_1_out_ready)
);
 
 fifo #(
  .DATA_WIDTH(DATA_IN_WIDTH)

  ) 
  ins2(
  .clk_i(clk_i),
  .arst_n(arst_n),

  .data_in(fifo_2_in),
  .data_in_valid(fifo_2_in_valid),
  .data_in_ready(fifo_2_in_ready),

  .data_out(in_B),
  .data_out_valid(fifo_2_out_valid),
  .data_out_ready(fifo_2_out_ready)
);
  
 fifo #(
  .DATA_WIDTH(DATA_IN_WIDTH+1)

  )
  ins3(
  .clk_i(clk_i),
  .arst_n(arst_n),

  .data_in(alu_out),
  .data_in_valid(fifo_3_in_valid),
  .data_in_ready(fifo_3_in_ready),

  .data_out(out),
  .data_out_valid(fifo_3_out_valid),
  .data_out_ready(fifo_3_out_ready)
);


endmodule
