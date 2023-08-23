module i2c_slave  # ( parameter max_count = 4

)
	(
	input logic 		clk,
	input logic 		rst_n,
	input logic 		SDA_in,//SDA as input
	output logic 		SDA_out//SDA as output

);  // net for counter
	logic 					en_f_c;
	logic 					down_f_c;
	logic [$clog2(max_count+1)-1:0] 	count_f_c; 
	
	// net for PISO
	logic 		en_f_p;
	logic [7:0]	parallel_in_f_p;
	logic 		serial_out_f_p;

	//net for SIPO
	logic 		en_f_s;
	logic 		serial_in_f_s;
	logic [7:0]	parallel_out_f_s;
	
	//net for Memory
	logic 		[6:0]	addr_f_m;
	logic 			cs_f_m;
	logic 			we_f_m;
	logic 		[7:0]	data_f_m;
	
	simple_mem ins1(
  		.clk		(clk),   	// System clock
  		.addr		(addr_f_m),  // access address
  		.cs		(cs_f_m),    // chip select
  		.we		(we_f_m),    // write enable
  		.data		(data_f_m)   // data
 	);

	SIPO ins2(
  		.clk      		(clk),          // global clock
  		.rst_n			(rst_n),        // active low reset
  		.en			(en_f_s),           // device enable
  		.serial_in		(SDA_in),    // serial input
  		.parallel_out 		(parallel_out_f_s)  // parallel output
	);

	PISO ins3(
  		.clk		(clk),          // global clock
  		.rst_n		(rst_n),        // active low reset
  		.en		(en_f_s),           // device enable
  		.parallel_in	(data_f_m),  // parallel input
  		.load		(load_f_p),         // load parallel input
  		.serial_out	(serial_out_f_p)    // serial output
	);

	COUNTER ins4 (
  	  .clk		(clk),   // global clock
  	  .rst_n	(rst_n), // active law reset
	  .en		(en_f_c),    // device enable
	  .down	(down_f_c),  // count in reverse
      	  .count	(count_f_c)  // count output
	);
	parameter 	IDLE 		= 0,
	 	      	ACTIVE 	= 1;
	bit     		pstate, nstate;
	 	      	
		always@(*) begin:NSOL
		begin:NSL
				case(pstate)
				IDLE 			: begin
								if(clk) begin
									if(negedge SDA_in) 	nstate =ACTIVE;
									end

							 end
	 	      		 ACTIVE		: if (count_f_c == 18) nstate = IDLE;
	 	      		 default 		: 'bz;
				 endcase
			end
			
			begin:OL
				case(pstate)
				IDLE			: 	rst_n <= 0;
				ACTIVE			: 	en_f_s <= 1;
								if (count_f_c == 7) begin
									addr_f_m <= parallel_out_f_s[6:0];
									if(parallel_out_f_s[7]=0) begin//checking read/write bit if 1 then read or if 0 then write
										cs_f_m= 1;
										we_f_m= 1;
									end
									else if(parallel_out_f_s[7]=1)begin//checking read/write bit if 1 then read or if 0 then write
										cs_f_m= 1;
										we_f_m= 0;
									end
									else begin
										cs_f_m= 'bz;
										we_f_m= 'bz;
									end
										
													
								end
								
								else if(count_f_c == 8) begin
									SDA_out = 0;
									end
										cs & ~we) ? mem[addr] : 'z;
									end
								else if(count_f_c == 17) begin
								SDA_out = 0;
								end 
									
							  	if()
							  	end
				
				
				

				default		: begin 
				end
				endcase
			end
		end	
		
		always@(posedge clk or negedge rst_n) begin: psr
			if(!rst_n)
				pstate<=IDLE;
			else pstate <= nstate;
		end


endmodule
