module alu #(
    parameter DATA_IN_WIDTH = 8
) (
    input logic                     clk_i,
    input logic                     arst_n,

    input logic[DATA_IN_WIDTH-1:0]  in_A,
    input logic                     in_A_valid,
    output logic                    in_A_ready,

    input  logic[DATA_IN_WIDTH-1:0] in_B,
    input  logic                    in_B_valid,
    output logic                    in_B_ready,

    output logic[DATA_IN_WIDTH:0]   out,
    output logic                    out_valid,
    input  logic                    out_ready,


    input  logic[2:0]                opcode,
    input   logic                    opcode_valid,
    output  logic                    opcode_ready
);

    assign out_valid    = in_A_valid & in_B_valid & opcode_valid;
    assign in_A_ready   = in_B_valid & out_ready  & opcode_valid;
    assign in_B_ready   = in_A_valid & out_ready  & opcode_valid;
    assign opcode_ready = in_A_valid & in_B_valid & out_ready   ;

    always_comb begin
        case(opcode)
            3'b000 : out =~in_A ;
            3'b001 : out = in_A + in_B;
            3'b010 : out = in_A - in_B;
            3'b011 : out = in_A / in_B;
            3'b100 : out = in_A % in_B;
            3'b101 : out = in_A & in_B;
            3'b110 : out = in_A | in_B;
            3'b111 : out = in_A ^ in_B;
            default: out = 0;
        endcase
    end

endmodule