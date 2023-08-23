module apb_mem_top #(
    parameter ADDR_WIDTH=0,
    parameter DATA_WIDTH=0
) (
    input  logic                   clk;
    input  logic                   arst_n;
    input  logic [3:0]             psel;
    input  logic                   penable;
    input  logic [ADDR_WIDTH-1:0]  paddr;
    input  logic                   pwrite;
    input  logic [DATA_WIDTH-1:0]  pwdata;
    output wire  [DATA_WIDTH-1:0]  prdata;
    output wire                    pready;
	);
    generate 
        for (genvar i = 0; i < 4; i++) begin
            apb_mem #(
                .ADDR_WIDTH ( ADDR_WIDTH ),
                .DATA_WIDTH ( DATA_WIDTH )
            ) u_apb_mem (
                .clk(clk),
                .arst_n(arst_n),
                .psel(psel[i]),
                .penable(penable),
                .paddr(paddr),
                .pwrite(pwrite),
                .pwdata(pwdata),
                .prdata(prdata),
                .pready(pready)
            );
        end
    endgenerate
endmodule
