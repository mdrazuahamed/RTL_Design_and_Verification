////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : mem_core
//    DESCRIPTION : basic building block for memory
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                           clk_i
                     --------↓---------
                    ¦                  ¦
 [AddrWidth] addr_i →                  ¦
[ElemWidth] wdata_i →     mem_core     → [CELL_WIDTG] rdata_o
               we_i →                  ¦
                    ¦                  ¦
                     ------------------
*/

module mem_core #(
    parameter int ElemWidth = 8,
    parameter int AddrWidth = 8
) (
    input  logic                 clk_i,
    input  logic                 cs_i,
    input  logic                 we_i,
    input  logic [AddrWidth-1:0] addr_i,
    input  logic [ElemWidth-1:0] wdata_i,
    output logic [ElemWidth-1:0] rdata_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int Depth = (2 ** AddrWidth);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [Depth-1:0][ElemWidth-1:0] mem;

  logic do_write;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign rdata_o  = mem[addr_i];

  assign do_write = cs_i & we_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SEQUENCIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i) begin
    if (do_write) begin
      mem[addr_i] <= wdata_i;
    end
  end

endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                       clk_i        cs_i
                      ---↓----------↓---
                     ¦                  ¦
  [AddrWidth] addr_i →                  ¦
 [DataWidth] wdata_i →     mem_bank     → [DataWidth] rdata_o
 [DataBytes] wstrb_i →                  ¦
                     ¦                  ¦
                      ------------------
*/

module mem_bank #(
    parameter  int AddrWidth = 8,
    parameter  int DataSize  = 2,
    localparam int DataBytes = (2 ** DataSize),
    localparam int DataWidth = (8 * (2 ** DataSize))
) (
    input  logic                 clk_i,
    input  logic                 cs_i,
    input  logic [AddrWidth-1:0] addr_i,
    input  logic [DataWidth-1:0] wdata_i,
    input  logic [DataBytes-1:0] wstrb_i,
    output logic [DataWidth-1:0] rdata_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < DataBytes; i++) begin : g_mem_cores
    mem_core #(
        .ElemWidth(8),
        .AddrWidth(AddrWidth - DataSize)
    ) u_mem_core (
        .clk_i  (clk_i),
        .cs_i   (cs_i),
        .we_i   (wstrb_i[i]),
        .addr_i (addr_i[AddrWidth-1:DataSize]),
        .wdata_i(wdata_i[(8*(i+1)-1):(8*i)]),
        .rdata_o(rdata_o[(8*(i+1)-1):(8*i)])
    );
  end

endmodule

