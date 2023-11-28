interface uart_vip_if #(
  parameter int DATA_WIDTH = 5,
  parameter int PARITY_TYPE= 2,
  parameter int STOP_BITS = 2,
  parameter int BAUD_RATE = 9600
);
 // Allowed number of bits are " 5 | 6 | 7 | 8 "
 // Allowed values are " 0 | 1 | 2 "
 // 0 : No Parity Bit
 // 1 : Odd Parity
 // 2 : Even Parity
 // Allowed values are " 1 | 2 "
 // bit per second
  logic         rx;
  logic         tx;
  int           stop_bits;

  //local variable
  int parity_rx = 0; // parity bit by calculating receive data
  int parity_tx = 0; // parity bit by calculating send data


  function logic set_parity( int PARITY_TYPE, logic [DATA_WIDTH-1:0]data);
    case(PARITY_TYPE)
         0:  ;
         1:  set_parity = ~(^data); // odd parity
         2:  set_parity = ^data;    // even parity
         default: ;
    endcase
    return set_parity;
  endfunction

  task set_baud ( output int time_per_bit, output int half_time); 
    time_per_bit = 10**9/BAUD_RATE;
    half_time    = time_per_bit/2;
  endtask

  task send_data ( input int data );
    int time_per_bit;
    int half_time;
    set_baud (time_per_bit,half_time); // calculate time for one bit

    tx=1'b0;        // sending start bit
    # (half_time * 1ns);

    for (int i=0; i<DATA_WIDTH ; i++) begin
      tx = data[i]; // sending data bits
      #(time_per_bit * 1ns);
    end

    parity_tx = set_parity(PARITY_TYPE,data);
    tx = parity_tx; // sending parity bit
    #(time_per_bit * 1ns);

    repeat(STOP_BITS)
    begin
      tx = 1'b1;    // sending stop bit
      #(time_per_bit * 1ns);
    end 
  endtask

	task recv_data (output int data);
    int time_per_bit;
    int half_time;
    data = 0;
    set_baud (time_per_bit, half_time);

    // waiting for rx to low
    wait(rx == 1'b0);
    #(time_per_bit * 1ns);

    // Receiving Data bit by bit
  for (int i=0; i<DATA_WIDTH; i++) begin
			data[i] = rx;
			#(time_per_bit * 1ns);
		end

    // Receiving Parity bit
		parity_rx = rx;
		#(time_per_bit * 1ns);
    for(int j=0;j<STOP_BITS;j++)
    begin
      stop_bits[j]= rx;    // sending stop bit
      #(time_per_bit * 1ns);
    end 
  endtask

endinterface
