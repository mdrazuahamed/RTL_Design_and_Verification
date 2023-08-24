module top_module #(parameter DEPTH = 3)
    ( 
    input logic[3:0] in,
    output logic[2:0] out_both,
    output logic[3:1] out_any,
    output logic[3:0] out_different );
    always_comb
    begin
        for(int i =0;i<=DEPTH-1;i++)
        begin
            if(in[i]&in[i+1]==1) out_both[i]=1;
            else out_both[i]=0;
            
        end
        for(int i =1;i<=DEPTH;i++)
            begin
                if(in[i] | in[i-1]==1) out_any[i]=1;
            else out_any[i]=0;
            end
         for(int i =0;i<=DEPTH;i++)
        begin
            if(i==3) begin
                if(in[3]!= in[0]) out_different[3]=1;
                else out_different[3]=0;
            
            end
            else if(in[i]!= in[i+1]) out_different[i]=1;
            else out_different[i]=0;
            
        end
        
    end

endmodule
//////////combinational logic>>>>Basic gate>>>>>Even longer vectors

module top_module #( parameter DEPTH = 99

)
    (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different );

    always_comb
    begin
        for(int i =0;i<=DEPTH-1;i++)
        begin
            if(in[i]&in[i+1]==1) out_both[i]=1;
            else out_both[i]=0;

        end
        for(int i =1;i<=DEPTH;i++)
            begin
                if(in[i] | in[i-1]==1) out_any[i]=1;
            else out_any[i]=0;
            end
         for(int i =0;i<=DEPTH;i++)
        begin
            if(i==DEPTH) begin
                if(in[DEPTH]!= in[0]) out_different[DEPTH]=1;
                else out_different[DEPTH]=0;

            end
            else if(in[i]!= in[i+1]) out_different[i]=1;
            else out_different[i]=0;

        end

    end

endmodule
// 2 to 1 mux
module top_module( 
    input a, b, sel,
    output out ); 
	assign out = sel?b:a;
endmodule
///9 to 1 mux
module top_module(
    input 	logic	[15:0] a, b, c, d, e, f, g, h, i,
    input 	logic 	[3:0] sel,
    output 	logic	[15:0] out );
    always_comb
    begin
        case(sel)
            4'd0: out = a;
            4'd1: out = b;
            4'd2: out = c;
            4'd3: out = d;
            4'd4: out = e;
            4'd5: out = f;
            4'd6: out = g;
            4'd7: out = h;
            4'd8: out = i;
            default: out = 16'hffff;
        endcase

    end

endmodule

////256 TO 1 MUX

module top_module
(
    input logic [255:0] in,
    input logic [7:0] sel,
    output logic out
);
	always_comb
    begin
        out =in[sel];

    end
endmodule
////////Mux256to1 with vector

module top_module(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out );
    assign out={in[sel*4+3],in[sel*4+2],in[sel*4+1],in[sel*4]};

endmodule

module top_module (
    input  logic  [3:0] x,
    input  logic  [3:0] y, 
    output logic  [4:0] sum);
    genvar i;
    logic [3:0]cin,cout;
    generate
        for(i=0;i<=3;i++)
        begin: instantiate
            assign cin[i]= cout[i-1];
            if(i==0) begin
                assign cin=0;
            end
            else if(i=3) assign sum[i+1]=cout[i];
         
            FA ins1(
                .cin(cin[i]),
                .cout(cout[i]),
                .sum(sum[i]),
                .in1(x[i]),
                .in2(y[i])
                   );
        end
    endgenerate
endmodule

module FA(
    input logic in1,
    input logic in2,
    input logic cin,
    output logic cout,
    output logic sum
    
);
    assign {cout,sum}=in1+in2+cin;  
endmodule

