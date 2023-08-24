/////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2020-2023 DSI, Inc (All Rights Reserved)
//
// Project Name: Hydra
// Module Name:
//[MODULE NAME]
// Designer:
//[DESIGNER NAME]
// Description:
//[DESCRIPTION]
//
/////////////////////////////////////////////////////////////////////////////////
module apb_top
(
    input  logic         pclk,
    input  logic         presetn,
    input  logic  [31:0] paddr,
	input  logic  [3:0 ] psel,
	input  logic         penable,
	input  logic         pwrite,
	input  logic  [31:0] pwdata,
	input  logic  [ 3:0] pstrb,
	output logic  [31:0] mst_prdata,
	output logic         mst_pready
);

logic [31:0] prdata [4];
logic        pready [4];

generate
    for(genvar i=0; i<4 ;i++)
    begin
        apb u_apb(.pclk       (pclk     ),
                  .presetn    (presetn  ),
				  .paddr      (paddr    ),
				  .psel       (psel[i]  ),
				  .penable    (penable  ),
				  .pwrite     (pwrite   ),
				  .pstrb      (pstrb    ),
				  .prdata     (prdata[i]),
				  .pready     (pready[i])
	             );
	end
endgenerate

// apb mux for output selection

apb_mux u_apb_mux(.prdata    (prdata    ),
	              .pready    (pready    ),
				  .psel      (psel      ),
				  .mst_prdata(mst_prdata),
				  .mst_pready(mst_pready)
			     );

endmodule
