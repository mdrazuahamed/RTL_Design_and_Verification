
//////////////Dff8ar
module top_module (
    input clk,
    input areset,   // active high asynchronous reset
    input [7:0] d,
    output [7:0] q
);
    always_ff@(posedge clk or posedge areset) 
    begin
        if(areset) q<=0;
        else q<=d;
    end

endmodule
////////dff16e
module top_module (
    input  logic clk,
    input  logic resetn,
    input  logic [1:0] byteena,
    input  logic [15:0] d,
    output logic  [15:0] q
);
    always_ff@(posedge clk) 
    begin
        if(!resetn) q<=0;
        else begin
        if(byteena[1]) q[15:8]<=d[15:8];
        if(byteena[0]) q[7:0]<=d[7:0];
        end
    end

endmodule

////////////////Exams/m2014 q4d
module top_module (
    input clk,
    input in, 
    output out);
    logic d;
    assign d=in^out;
    always_ff@(posedge clk) out <=d;

endmodule

//////////////Exams/ece241 2014 q4
module top_module (
    input logic clk,
    input logic  x,
    output  logic z
); 
    logic xor_,and_,or_,in1,in2,in2bar,in3,in3bar;
	assign xor_= x ^ in1;
    assign and_= x & in2bar;
    assign or_= x | in3bar;
    assign in2bar = ~in2;
    assign in3bar = ~in3;
    assign  z=~(in1|in2|in3);
    always_ff@(posedge clk) {in1,in2,in3}={xor_,and_,or_};
endmodule



///////////////////////Exams/ece241 2013 q7
module top_module (
    input clk,
    input j,
    input k,
    output Q); 
    always_ff@(posedge clk)
    begin
        case({j,k})
            2'b00: Q<=Q;
            2'b01: Q<=0 ;
            2'b10: Q<=1;
            2'b11: Q<=~Q;
        endcase
    end

endmodule

/////////////////////////////Edgedetect2


module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    logic [7:0]in_p;
    always_ff@(posedge clk)
    begin
        in_p<=in;
        //in_p1<=in;
        anyedge<=(~in_p&in)|(in_p&~in);
    end

        

endmodule
/////Edgecapture
module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
); 
    logic [31:0]in_previous;
    always_ff@(posedge clk) 
    begin
        in_previous<=in;
        if(reset) out<=0;
        else out <= (in_previous & ~in)|out;
        
    end
	
	
endmodule



