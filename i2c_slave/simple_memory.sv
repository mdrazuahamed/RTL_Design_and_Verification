module simple_mem #(
  parameter ADDR_WIDTH = 7,
  parameter DATA_WIDTH = 8
) (
  input  logic                  clk,   // System clock
  input  logic [ADDR_WIDTH-1:0] addr,  // access address
  input  logic                  cs,    // chip select
  input  logic                  we,    // write enable
  inout  logic [DATA_WIDTH-1:0] data   // data
);

  logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH];  // memory

  assign data = (cs & ~we) ? mem[addr] : 'z;                        // drive data when device is selected and write is not applied

  always_ff @(posedge clk) begin
    if (cs && we) // store in memory
    begin
      mem [addr] <= data;
    end

  end // always_ff
  
endmodule
