interface top_adder_fifo_intf #(
    parameter DATA_IN_WIDTH = 0
) (
    input logic clk_i,
    input logic arst_n
); 

    logic [DATA_IN_WIDTH-1:0] fifo_1_in       ;
    logic                     fifo_1_in_valid ;
    logic                     fifo_1_in_ready ;
    logic [DATA_IN_WIDTH-1:0] fifo_2_in       ;
    logic                     fifo_2_in_valid ;
    logic                     fifo_2_in_ready ;
    logic [DATA_IN_WIDTH:0]   out             ;
    logic                     fifo_3_out_valid;
    logic                     fifo_3_out_ready;

endinterface