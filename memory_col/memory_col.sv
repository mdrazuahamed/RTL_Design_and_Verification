module memory_col
(   input  logic          clk,
    input  logic [7:0]    wr_data,
    input  logic          byte_en,
    input  logic [1023:0] addr,
    output logic [7:0]    rd_data  
);
   logic [7:0]mem[1023:0];
   logic [1023:0]mux_out;

   always_ff@(posedge clk)
   begin
      rd_data <= mem[addr];
      if(byte_en)
          mem[addr] <= wr_data;
   end

endmodule