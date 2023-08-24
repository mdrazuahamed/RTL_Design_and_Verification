// Code your testbench here
// or browse Examples
module SIPO_tb;
  logic clk;
  logic clear;
  logic si;
  logic [8:0]drive;
  logic [8:0]po;
  logic [8:0]po_expected;
  always #2 clk = ~clk;
  SIPO ins1(clk,clear,si,po);
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $monitor($time,"ns Serial input  =%b and Parallel Output = %b",si,po);
    clk = 0;
    po_expected = 0;
    clear = 1;
    drive = 9'b101100111;
    #4 clear =0;
    foreach(drive[i]) begin
      po_expected = {po_expected[7:0],drive[i]};
      @(negedge clk) si = drive[i]; 
      @(posedge clk) begin
        #1;
        if(po_expected==po)
          $display("po = %b nad po_exp = %b Match",po,po_expected);
          else
            $display("po = %b nad po_exp = %b not_Match",po,po_expected);
      end
    end
    @(negedge clk) $finish;
  end
  
  
endmodule
