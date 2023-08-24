
// Code your design here
module top_module( 
    input logic [99:0] a, b,
    input logic cin,
    output logic [99:0] cout,
    output logic[99:0] sum );
    logic cin_temp[100];
    //genvar i;
    generate
      for( genvar i = 0; i<100;i++)
        begin
          adder_1bit 
          u_adder_1bit(
              .a(a[i]),
              .b(b[i]),
              .cin(cin_temp[i]),
              .cout(cout[i]),
              .sum(sum[i])
          );
            if ( i ==0)
                assign cin_temp[i]=cin;
            else
                assign cin_temp[i]=cout[i-1];
         end
     endgenerate
endmodule

		
module adder_1bit(
    input logic a,b,cin,
    output logic cout,sum
 );
  assign {cout,sum}=a+b+cin;

endmodule

// Code your testbench here
// or browse Examples
module top_module_tb;
  logic [99:0]a,b,sum,cout;
  logic cin;
  
  top_module ins1( 
    .a(a), 
    .b(b),
    .cin(cin),
    .cout(cout),
    .sum(sum) 
  );
  initial 
  begin
    cin=1;
    a=20;
    b=50;
    
    #10 $finish;
      
  end
  initial 
    begin
      $dumpfile("dump.vcd"); $dumpvars;
    end
  
endmodule


///////////////////////////
//Truth table

module top_module(
    input x3,
    input x2,
    input x1,  // three inputs
    output f   // one output
);
    assign f=((~x3) & x2 & (~x1))|((~x3) & x2 & (x1))|((x3) & x2 & (x1))|((x3) & (~x2) & (x1));
endmodule

////////////ringer

module top_module (
    input ring,
    input vibrate_mode,
    output ringer,       // Make sound
    output motor         // Vibrate
);
    assign {motor,ringer} = ring?(vibrate_mode?2'b10:2'b01):2'b00;
endmodule
/////////////////Thermostat
module top_module (
    input too_cold,
    input too_hot,
    input mode,
    input fan_on,
    output heater,
    output aircon,
    output fan
);
    assign {aircon,heater} = mode?(too_cold?2'b01:2'b00):(too_hot?2'b10:2'b00);
   	//assign aircon = ~mode & too_hot;
    assign fan = (heater | aircon) | fan_on;
endmodule

////////////////////Popcount3

module top_module(
    input [2:0] in,
    output reg [1:0] out );
    always_ff@(in)
    begin
        out = 0;
        for(int i=0;i<3;i++)
        begin
            if(in[i]==1) out=out+1;
            else out = out;
        end
    end
endmodule
