module top_module(
    input [2:0] in,
    output reg [1:0] out );
    always_comb
    begin
        out = 0;
        for(int i=0;i<3;i++)
        begin
            if(in[i]==1) out=out+1;
        end
    end
endmodule

///Adder with overflow

module top_module (
    input logic[7:0] a,
    input logic[7:0] b,
    output logic[7:0] s,
    output logic overflow
); //
 	logic cin,cout;
    logic [6:0]temp;
    assign {cout,s}=a+b;
    assign {cin,temp}=a[6:0]+b[6:0];
    assign overflow =(cout==cin)?0:1;
endmodule



///kmap1
module top_module(
    input 	logic a,
    input 	logic b,
    input 	logic c,
    output 	logic out  ); 
	assign out=a|b|c;
endmodule

///kmap2
module top_module(
    input 	logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic out  ); 
    assign out=(~b&~c)|(~a&~d)|(~c&~d&~a)|(c&d&a)|(c&~a&b);

endmodule

//kmap3
module top_module(
    input 	logic a,
    input 	logic b,
    input 	logic c,
    input 	logic d,
    output 	logic out  ); 
    assign out=a|c&~b;
endmodule

///kmap4
module top_module(

    input 	logic a,
    input 	logic b,
    input 	logic c,
    input 	logic d,
    output 	logic out  ); 
    assign out=(~a&b&~c&~d)|(a&~b&~c&~d)|(a&b&~c&d)|(~a&b&c&d)|(a&~b&c&d)|(~a&~b&c&~d)|(a&b&c&~d)|(~a&~b&~c&d);

endmodule

/////kmap5
module top_module (
    input 	logic a,
    input 	logic b,
    input 	logic c,
    input 	logic d,
    output 	logic out_sop,
    output 	logic out_pos
); 
    assign out_sop=(~a&c)|(a&b&c&d);
    //assign out_sop=(b&c&d)|(~a&~b&c&~d);
    assign out_pos=(a|b|c|~d)&(a|~b|c|d)&(a|~b|c|~d)&(a|~b|~c|d)&(~a|b|c|~d)&(~a|b|~c|d)&(~a|~b|c|~d)&(~a|~b|~c|d);
   // assign out_pos=(a|c|d)&(~a|c|~d)&(~b|~c|d)&(~a|~c|d);
endmodule

/////Exams/m2014 q3
module top_module (
    input logic[4:1] x, 
    output logic f );
    assign f=x[3]&~x[1] | x[4]&x[2];

endmodule

////Exams/2012 q1g
module top_module (
    input  logic [4:1] x,
    output logic f
); 
    assign f=(~x[1]&x[3])|(~x[2]&~x[4])|(x[2]&x[3]&x[4]);
endmodule


//////////Exams/ece241 2014 q3

module top_module (
    input 	logic c,
    input 	logic d,
    output 	logic [3:0] mux_in
); 
   // logic a,b;
		assign mux_in[0]=~d?(~c?0:1):1;
        assign mux_in[1]=0;
        assign mux_in[2]=~d?1:0;
        assign mux_in[3]=d?(c?1:0):0;

endmodule
///////Bcdadd4

module top_module ( 
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );
    logic [2:0]cout_temp;
    bcd_fadd ins1(a[3:0],b[3:0],cin,cout_temp[0],sum[3:0] );
    bcd_fadd in2(a[7:4],b[7:4],cout_temp[0],cout_temp[1],sum[7:4] );
    bcd_fadd ins3(a[11:8],b[11:8],cout_temp[1],cout_temp[2],sum[11:8] );
    bcd_fadd ins4(a[15:12],b[15:12],cout_temp[2],cout,sum[15:12] );

endmodule
//dff
module top_module (
    input 	logic clk,    // Clocks are used in sequential circuits
    input 	logic  d,
    output 	logic q );//

    always_ff@(posedge clk) q<=d;

endmodule

///Dff8r

module top_module (
    input 	logic clk,
    input 	logic  reset,            // Synchronous reset
    input 	logic  [7:0] d,
    output 	logic  [7:0] q
);
	always_ff@(posedge clk) 
    begin
        if(reset) q<=0;
        else q<=d;
    end
    
endmodule

/////Dff8p

module top_module (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    always_ff@(negedge clk) 
    begin
        if(reset) q<='h34;
        else q<=d;
    end
endmodule

/////Dff8ar

module top_module (
    input 	logic clk,
    input 	logic  areset,   // active high asynchronous reset
    input 	logic  [7:0] d,
    output 	logic  [7:0] q
);
    always_ff@(posedge clk or posedge areset) 
    begin
        if(areset) q<=0;
        else q<=d;
    end

endmodule

/////Dff16e

module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);
    always_ff@(posedge clk) 
    begin
        if(!resetn) q<=0;
        else 
        begin
            if(byteena[1]) q[15:8]<=d[15:8];
            if(byteena[0]) q[7:0]<=d[7:0]; 
          
        end
    end
endmodule

///Exams/m2014 q4a>>>>>>>>>>>>>latch
module top_module (
    input logic d, 
    input logic ena,
    output logic q);
    always_ff 
    begin
        if(ena) q=d;
    end
endmodule

///////Exams/m2014 q4b

module top_module (
    input clk,
    input d, 
    input ar,   // asynchronous reset
    output q);
    always_ff@(posedge clk or posedge ar) 
    begin
        if(ar) q<=0;
        else q<=d;
    end

endmodule

/////////Exams/m2014 q4c

module top_module (
    input clk,
    input d, 
    input r,   // synchronous reset
    output q);
    always_ff@(posedge clk) 
    begin
        if(r) q<=0;
        else q<=d;
    end

endmodule
/////////Exams/m2014 q4d

module top_module (
    input logic clk,
    input logic in, 
    output logic out);
    logic xor_out;
    xor ins1(xor_out,in,out);
    always_ff@(posedge clk) 
    begin
        out<=xor_out;
    end

endmodule


