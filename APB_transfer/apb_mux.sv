module apb_mux
( 
	input  logic [31:0] prdata[4],
	input  logic        pready[4],
	input  logic [3:0]  psel,
	output logic [31:0] mst_prdata,
	output logic        mst_pready

);
    always_comb
	begin
        case(psel)
			4'b0001:begin
			    mst_prdata = prdata[0];
			    mst_pready = pready[0];
			end
			4'b0010:begin
				mst_prdata =prdata [1];
			    mst_pready = pready[1];
			end
			4'b0100:begin
				mst_prdata = prdata[2];
			    mst_pready = pready [2];
			end
			4'b1000:begin
				mst_prdata = prdata[3];
			    mst_pready = pready[3];
			end
			default: begin
			    mst_prdata = 'b0;
				mst_pready = 'b0;
			end
        endcase
	end

endmodule
