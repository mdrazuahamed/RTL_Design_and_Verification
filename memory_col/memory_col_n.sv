//# memory column for storing rd_data
// ### Author : Razu Ahamed (en.razu.ahamed@gmail.com)
module memory_col_n
(   input  logic          clk,
    input  logic [7:0]    wr_data,
    input  logic          byte_en,
    input  logic [9:0]    addr,
    output logic [7:0]    rd_data
);
   logic [7:0]mem[1024];
   logic [1023:0]mux_out;

   assign mux_out = byte_en<<addr;

   always_ff@(posedge clk)
   begin
      rd_data <= mem[addr]; // read operation

      for(int i=0;i<2**10;i++) // write operation
      if(i==addr)
      begin
          if(mux_out[i])
              mem[i] <= wr_data;
      end
   end
endmodule