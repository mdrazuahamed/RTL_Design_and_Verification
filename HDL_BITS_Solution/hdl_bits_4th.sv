module top_module (
	input 	logic clk,
	input 	logic L,
	input 	logic r_in,
	input 	logic q_in,
	output 	logic  Q);
    logic d;
    assign d=L?r_in:q_in;
    always_ff@(posedge clk) Q<=d;

endmodule

////Exams/2014 q4a
module top_module (
    input 	logic	clk,
    input 	logic	w, R, E, L,
    output 	logic	Q
);
    logic D;
    assign D=(L)?R:(E)? w:Q;
    always_ff@(posedge clk) Q<=D;

endmodule

