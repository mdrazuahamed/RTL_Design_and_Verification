module SIPO #(
  parameter DEPTH = 4
) (
  input  logic             clk,          // global clock
  input  logic             rst_n,        // active low reset
  input  logic             en,           // device enable
  input  logic             serial_in,    // serial input
  output logic [DEPTH-1:0] parallel_out  // parallel output
);

  always_ff @ (posedge clk) begin

    if (rst_n) // not reset
    begin
      if (en) parallel_out = {parallel_out, serial_in};              
    end

    else // apply reset
    begin
      parallel_out <= '0;
    end

  end
  
endmodule
