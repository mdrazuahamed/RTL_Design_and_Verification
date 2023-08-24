module uart #(
  	parameter DEPTH = 5
)
(
	input logic  			clk,
	input logic  			rx,
	input logic  			rst,
  	input logic 			enable,
  	input logic  [DEPTH-1:0]	data_in,
	output logic 			tx,
  	output logic [DEPTH-1:0]	data_out
 );

	logic 	      [2:0]  		count;//for counting DATA state staying time
	logic 	      {DEPTH-1:0] 	temp_sipo,temp_piso;
        typedef enum 	logic [1:0] 	{IDLE, START, DATA,STOP} 	state_t;
        state_t 	        	pstate,nstate;
	
  always_ff@(posedge clk) begin//Sipo construction | rx
    	if(nstate==IDLE | nstate == START) begin
      		temp_sipo <= 5'b0;
    		data_out <= 5'b0;
   	end
    	else if(nstate==DATA)
    		temp_sipo <= {temp_sipo[DEPTH-2:0],rx}; 
    
    	else if(nstate==STOP)
      		data_out <=	temp_sipo;
  end

  always_ff@(posedge clk)//PISO construction |tx
    begin
      if(enable==1) 
        begin
     		tx <= 1'b0;
      		temp_piso <= data_in;
    	end
     	
      else if(enable==0)
      begin
          temp_piso<= {temp_piso[DEPTH-2:0],1'b1};
       	  tx <=temp_piso[DEPTH-1];
      end
  end
 
  always_comb
		begin
		case(pstate)
	
		IDLE: 
		begin
	 		if(~rx) 
	 		begin
	 		    nstate = START;
	 		end
	 		
	 		else    
	 		begin
	 		    nstate = IDLE;
	 		end
		end
	
		START: 
		begin
			nstate = DATA;
		end
	
		DATA: 
		begin
			if(count==DEPTH) nstate = STOP;
			else         nstate = DATA;
		end
		STOP: if(rx)	     nstate = IDLE;
		      else 	         nstate = STOP;
		endcase
	end
		
  always_ff@(posedge clk) 
	begin
      if(pstate==IDLE | pstate == START | pstate == STOP)  
		begin
			count<=1;
		end	
	
		else
		begin
			count<=count+1;
		end
	end
	
  always_ff@(posedge clk or negedge rst) 
	begin
		if(!rst) 
		begin 
			pstate <= IDLE;
		end
		
		else
		begin
			pstate <= nstate;
		end
	end
endmodule

