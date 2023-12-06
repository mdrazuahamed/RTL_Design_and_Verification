//# memory column for storing rd_data
// ### Author : Razu Ahamed (en.razu.ahamed@gmail.com)

module uart_top_tb;
	bit    clk;
	logic  rst;
  	logic  enable;
	logic  [4:0]data_in;
 	logic  [4:0]data_out;

uart_top ins1
  (
    .clk		(clk),
    .rst		(rst),
    .data_in	(data_in),
    .enable		(enable),
    .data_out	(data_out) 
);
	 always #5 clk = ~ clk;
   initial begin
    	clk=0;
      rst=0;
      enable = 0;
      #15 rst = 1;
      data_in=5'b11001;
      enable = 1;
      #5
      enable = 0;
       
      #200 $finish;  
  end 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

  end

endmodule 
