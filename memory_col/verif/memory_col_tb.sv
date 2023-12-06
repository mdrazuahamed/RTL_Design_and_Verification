// # memory column for storing rd_data
// ### Author : Razu Ahamed (en.razu.ahamed@gmail.com)

module memory_col_tb;

    logic          clk;
    logic [7:0]    wr_data;
    logic          byte_en;
    logic [1023:0] addr;
    logic [7:0]    rd_data;

    memory_col_n
      u_memory_col_n
    (   .clk    (clk),
        .wr_data(wr_data),
        .byte_en(byte_en),
        .addr   (addr),
        .rd_data(rd_data)
        );

    task start_clock ();
      fork
        forever begin
          clk = 1; #5;
          clk = 0; #5;
        end
      join_none
    endtask

    initial 
    begin
      $dumpfile("dump.vcd"); 
      $dumpvars;
    end

    initial
    begin
      start_clock ();
      for(int i=0;i<100;i++)
      begin
        wr_data <= $urandom;
        byte_en <= $urandom;
        addr    <= $urandom;
        repeat(3) @(posedge clk);
        $display("write_data=%d,byte_en=%d, read_data=%d,address =%0d",wr_data,byte_en,rd_data,addr);
      end
      $finish;
    end
endmodule