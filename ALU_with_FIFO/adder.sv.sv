`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2023 11:55:19 AM
// Design Name: 
// Module Name: adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module adder #(
  parameter DATA_IN_WIDTH = 8
) (
  input                      clk_i,
  input                      arst_n,

  input  [DATA_IN_WIDTH-1:0] in_A,
  input                      in_A_valid,
  output                     in_A_ready,

  input  [DATA_IN_WIDTH-1:0] in_B,
  input                      in_B_valid,
  output                     in_B_ready,

  output [DATA_IN_WIDTH-0:0] out,
  output                     out_valid,
  input                      out_ready
);

  assign out_valid  = in_A_valid & in_B_valid;
  assign in_A_ready = in_B_valid & out_ready;
  assign in_B_ready = in_A_valid & out_ready;

  assign out = in_A + in_B;

endmodule

