////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Razu Ahamed
//    EMAIL       : engr.razu.ahamed@gmail.com
//
//    MODULE      : gray_to_bin_tb;
//    DESCRIPTION : It's verify gray to binary converter Module
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module mem_bank_tb;
//////////////////////////////////////////////////////////////////////////////////////////////////
// IMPORTS
//////////////////////////////////////////////////////////////////////////////////////////////////

`include "tb_essentials.sv"

//////////////////////////////////////////////////////////////////////////////////////////////////
// PARAMETERS
//////////////////////////////////////////////////////////////////////////////////////////////////
parameter  int AddrWidth = 8;
parameter  int DataSize  = 2;

//////////////////////////////////////////////////////////////////////////////////////////////////
// LOCALPARAMS
//////////////////////////////////////////////////////////////////////////////////////////////////

localparam int DataBytes = (2 ** DataSize);
localparam int DataWidth = (8 * (2 ** DataSize));
//////////////////////////////////////////////////////////////////////////////////////////////////
// SIGNALS
//////////////////////////////////////////////////////////////////////////////////////////////////
logic                 clk_i    ;
logic                 cs_i    ;
logic [AddrWidth-1:0] addr_i  ;
logic [DataWidth-1:0] wdata_i ;
logic [DataBytes-1:0] wstrb_i ;
logic [DataWidth-1:0] rdata_o ;
logic [DataWidth-1:0] temp;

//`CREATE_CLK(clk_i, 3, 7)

//////////////////////////////////////////////////////////////////////////////////////////////////
// Reference Modle
//////////////////////////////////////////////////////////////////////////////////////////////////
logic [7:0]mem[2**AddrWidth];

//////////////////////////////////////////////////////////////////////////////////////////////////
// RTLS
//////////////////////////////////////////////////////////////////////////////////////////////////
mem_bank #(
    .AddrWidth (AddrWidth ),
    .DataSize  (DataSize)
    //.DataBytes (DataBytes),
    //.DataWidth (DataWidth)
) mem_bank_dut(
    .clk_i    (clk_i),
    .cs_i     (cs_i),
    .addr_i   (addr_i ),
    .wdata_i  (wdata_i ),
    .wstrb_i  (wstrb_i ),
    .rdata_o  (rdata_o)
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

function ref_model(logic [DataBytes-1:0]strobe,logic[DataWidth-1:0] wdata);
    for(int i=0;i<=DataBytes-1;i++)
    begin
      if(strobe[i]==1)
      begin
        mem[addr_i+i]=wdata[(8*(i+1)-1)-:8]; 
        //$display("Chip select has problem");
      end
    end

endfunction

task check_cs_i();
  cs_i        <=1;
  wstrb_i     <=$urandom;
  addr_i      <=$urandom;
  wdata_i     <=$urandom;
  @(posedge clk_i);
  ref_model(wstrb_i,wdata_i );
  for(int i=0;i<=DataBytes-1;i++)
  begin
    temp[(8*(i+1)-1)-:8]=mem[addr_i+i]; 
    //$display("debugging temp %h",temp);
  end
  @(posedge clk_i);
  //$display("debug address =%h strobe= %b wdata_i=%h Expected_data = %h and actual data = %h ",addr_i ,wstrb_i,wdata_i,temp,rdata_o);
  if(rdata_o ===temp)begin
    $display("Expected_data = %h and actual data = %h ::Seems like Chip select Work",temp,rdata_o);
  end
  

  cs_i        <=0;
  wstrb_i     <=$urandom;
  addr_i      <=$urandom;
  wdata_i     <=$urandom;
  @(posedge clk_i);
  ref_model(wstrb_i,wdata_i );
  for(int i=0;i<=DataBytes-1;i++)
  begin
    temp[(8*(i+1)-1)-:8]=mem[addr_i+i]; 
  end
  @(posedge clk_i);
  if(rdata_o ===temp)begin
    $display("Expected_data = %h and actual data = %h ::Chip select has problem, data should not match",temp,rdata_o);
  end
  
 endtask

task check_strobe();
  cs_i        <=1;
  wstrb_i     <=4'b1010;
  addr_i      <=$urandom;
  wdata_i     <=$urandom;
  @(posedge clk_i);
  ref_model(wstrb_i,wdata_i );
  for(int i=0;i<=DataBytes-1;i++)
  begin
    temp[(8*(i+1)-1)-:8]=mem[addr_i+i]; 
  end
  @(posedge clk_i);
  if(rdata_o ===temp)begin
    $display("strobe= %b ::Expected_data = %h and actual data = %h ::strobe work",wstrb_i,temp,rdata_o);
  end

  cs_i        <=1;
  wstrb_i     <=4'b0000;
  addr_i      <=$urandom;
  wdata_i     <=$urandom;
  @(posedge clk_i);
  ref_model(wstrb_i,wdata_i );
  for(int i=0;i<=DataBytes-1;i++)
  begin
    temp[(8*(i+1)-1)-:8]=mem[addr_i+i]; 
  end
  @(posedge clk_i);
  if(rdata_o ===temp)begin
    $display("strobe= %b ::Expected_data = %h and actual data = %h ::strobe work",wstrb_i,temp,rdata_o);
  end
endtask


always begin
  clk_i = 1; #5;
  clk_i = 0; #5;
end
initial 
begin
  
  check_cs_i();
  check_strobe();
  
  #50 $finish;
end


endmodule
