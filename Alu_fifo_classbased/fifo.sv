module fifo #(
  parameter DATA_WIDTH = 8,
  parameter DEPTH      = 8
) (
  input  logic                  clk_i,
  input  logic                  arst_n,

  input  logic [DATA_WIDTH-1:0] data_in,
  input  logic                  data_in_valid,
  output logic                  data_in_ready,

  output logic [DATA_WIDTH-1:0] data_out,
  output logic                  data_out_valid,
  input  logic                  data_out_ready
);
   
  logic [$clog2(DEPTH)-1:0]		read_ptr, write_ptr;
  logic [$clog2(DEPTH)-1:0]		fifo_counter;
  logic [DATA_WIDTH-1:0]				mem		[DEPTH-1:0];
  logic read_hand_shake, write_hand_shake;
  
  assign write_hand_shake = (data_in_valid & data_in_ready);
  assign read_hand_shake  = (data_out_valid & data_out_ready);
  
  
  assign data_in_ready = (fifo_counter < DEPTH);//check fifo is full or not full
  assign data_out_valid = (fifo_counter > 0);//check fifo is empty or not
    
  
  always_ff@(posedge clk_i or negedge arst_n) 
  begin
    if(!arst_n)
      fifo_counter<=0;
    else
    begin
        case({write_hand_shake,read_hand_shake})
		  2'b10: fifo_counter <= fifo_counter+1;
          2'b01: fifo_counter <= fifo_counter-1;
          default: fifo_counter <=  fifo_counter; 
        endcase
    end 
  end
  
  
  always_ff@(posedge clk_i or negedge arst_n) 
  begin
    if(!arst_n) 
      begin
    	read_ptr		<=0;
    	write_ptr		<=0;
      end
    
      else
      begin 
        if(write_hand_shake)
      	begin
      		write_ptr <= (write_ptr==DEPTH-1)?0:write_ptr+1;
      	end

    
        if (read_hand_shake)
      	begin
      		read_ptr  <=(read_ptr==DEPTH-1)?0:read_ptr +1;
   	  	end
      end
  end
      
  
  always_ff@(posedge clk_i)//write input data to fifo
  begin  

      if (write_hand_shake)
      begin
        mem[write_ptr]<=data_in;
      end
 
  end

  assign  data_out = mem[read_ptr];
  
endmodule