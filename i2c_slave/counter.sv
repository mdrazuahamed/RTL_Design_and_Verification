module COUNTER # (
  		parameter max_count =18   // maximum count value
	)
  	(
  		input  logic                            clk,   // global clock
  		input  logic                            rst_n, // active law reset
		input  logic                            en,    // device enable
		input  logic                            down,  // count in reverse
      output logic [$clog2(max_count+1)-1:0]  count  // count output
	);

  	always_ff @ (posedge clk) begin
    	
			if (rst_n)  // not reset
			begin

				if (en) // device is enabled
				begin

					if (down) // count in reverse
					begin
						if (count == 0)  count <= max_count; // less than 0
						else					 	 count <= count - 1; // not less than 0
					end

					else  // count forward
					begin 
						if (count == max_count) count <= 0;          // greater than Max count
						else                    count <= count + 1;	 // not greater than Max data					
					end

				end

			end // not reset

 			else // apply reset
			begin
				count <= '0;
			end // apply reset

  	end // always_ff
		
endmodule
