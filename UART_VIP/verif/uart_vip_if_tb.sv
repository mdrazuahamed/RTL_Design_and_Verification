//# memory column for storing rd_data
// ### Author : Razu Ahamed (en.razu.ahamed@gmail.com)

`include "../vip/uart_vip_if.sv"

module uart_vip_if_tb;

  localparam int DATA_WIDTH = 6;  // number of bit to transfer
  localparam int PARITY_TYPE = 1;  // even parity
  localparam int STOP_BITS = 2;  // number of stop bits
  localparam int BAUD_RATE = 9600;  // Bit per second

  uart_vip_if #(
      .DATA_WIDTH (DATA_WIDTH),
      .PARITY_TYPE(PARITY_TYPE),
      .STOP_BITS  (STOP_BITS),
      .BAUD_RATE  (BAUD_RATE)
  ) uart_if_master ();
  uart_vip_if #(
      .DATA_WIDTH (DATA_WIDTH),
      .PARITY_TYPE(PARITY_TYPE),
      .STOP_BITS  (STOP_BITS),
      .BAUD_RATE  (BAUD_RATE)
  ) uart_if_slave ();
  /* integer baud_rate = 9600; // bits/s
   integer clk_period = 5; // ns
   integer parity_type = 2; // 0: No Parity, 1: Odd Parity; 2: Even Parity
   int    stop_bits = 2; // " 1 | 2 "
   logic         rx;
  */
  int data_in_m;
  int data_in_s;
  int data_out_m;
  int data_out_s;
  always_comb begin
    uart_if_master.rx = uart_if_slave.tx;
    uart_if_slave.rx  = uart_if_master.tx;
  end
  initial begin
    for (int i = 0; i < 1; i++) begin
      //data_in_m = $urandom_range(1, 32);
      //data_in_s = $urandom_range(1, 32);
      data_in_m = 6'b111101;
      data_in_s = 6'b100001;
      fork
        uart_if_master.send_data(data_in_m);
        uart_if_slave.send_data(data_in_s);
        uart_if_master.recv_data(data_out_m);
        uart_if_slave.recv_data(data_out_s);
      join
      $display("******************************output printing  start **********************************");
      $display("data_in_s=%0b,data_out_m= %0b, data_in_m =%0b,data_out_S= %0b", data_in_s,
               data_out_m, data_in_m, data_out_s);
      $display("****************************************************************");
      $display("BAUD_RATE=%0d,PARITY_TYPE= %0d, STOP_BITS =%0d,DATA_WIDTH= %0d", BAUD_RATE,
               PARITY_TYPE, STOP_BITS, DATA_WIDTH);
      $display("****************************************************************");
      $display(
          "master_parity_tx = %0d, slave_parity_rx = %0d,salave_parity_tx = %0d, master_parity_rx = %0d",
          uart_if_master.parity_tx, uart_if_slave.parity_rx, uart_if_slave.parity_tx,
          uart_if_master.parity_rx);
      $display("****************************************************************");
      $display("Master_stop_bits = %0b, slave_stop_bits = %0b",uart_if_master.stop_bits,uart_if_slave.stop_bits);
      $display("******************************output printing end **********************************");
    end
    #5000000 $finish;
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
