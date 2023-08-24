//new line
// Code your design here
module SIPO # (
    parameter WIDTH = 9
  )
  (
    input  logic              clk,
    input  logic              rst,
    input  logic              si,
    output logic [WIDTH-1:0]  po
  );
  


  always@(posedge clk or posedge rst) begin
    if(rst) begin
      po <= 0;
    end

    else begin
      po <= {po[(WIDTH-2):0],si}; 
    end

  end

endmodule
