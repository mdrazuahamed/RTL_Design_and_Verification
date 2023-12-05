module memory_col
(   input  logic          clk,
    input  logic [7:0]    wr_data,
    input  logic          byte_en,
    input  logic [1023:0] addr,
    output logic [7:0]    rd_data   
);
   logic [7:0]mem[1023:0];
   logic [1023:0]mux_out;
   
   always_comb
   begin
     for(i=0;i<1024:i++)
     begin
        if(addr==i)
            temp_en = i;
     end
   end
   
   always_ff@(posedge clk)
   begin
      rd_data <= mem[addr];
      if(byte_en)
          mem[temp_en] <= wr_data;
   end                  

endmodule