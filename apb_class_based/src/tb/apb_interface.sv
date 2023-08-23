interface apb_intf #(
	parameter ADDR_WIDTH=0,
	parameter DATA_WIDTH=0,
	parameter NUM_OF_APB =0
) (
	input logic clk_i,
	input logic arst_n

    logic [3:0]             psel;
    logic                   penable;
    logic [ADDR_WIDTH-1:0]  paddr;
    logic                   pwrite;
    logic [DATA_WIDTH-1:0]  pwdata;
    logic  [DATA_WIDTH-1:0] prdata;
    logic                   pready;
);
