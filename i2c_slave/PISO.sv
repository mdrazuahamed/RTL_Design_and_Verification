module PISO #(
  parameter DEPTH = 4
) (
  input  logic             clk,          // global clock
  input  logic             rst_n,        // active low reset
  input  logic             en,           // device enable
  input  logic [DEPTH-1:0] parallel_in,  // parallel input
  input  logic             load,         // load parallel input
  output logic             serial_out    // serial output
);

  logic [DEPTH-1:0] buffer; // buffer for shifting & output

  assign serial_out = buffer [DEPTH-1]; // load last element of the buffer

  always_ff @ (posedge clk) begin
    
    if (rst_n) begin  // not reset
      if (en) // device enabled
      begin
        if (load) buffer <= parallel_in;  
        else      buffer <= {buffer, 1'b0};
      end
    end

    else // apply reset
    begin
      buffer <= '0;
    end

  end
  
endmodule
