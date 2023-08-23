package apb_pkg;

	//////////////////////////////////////////////////////////////
	//seq_item
	/////////////////////////////////////////////////////////////

	class apb_seq_item #(parameter ADDR_WIDTH   =0,
	                     parameter DATA_WIDTH   =0,
						 parameter NUM_OF_APB   =0
					 );

	    rand logic [ADDR_WIDTH-1:0]paddr;
		rand logic [DATA_WIDTH-1:0]pwdata;
		rand logic [NUM_OF_APB:0  ]psel;
		rand logic                 pwrite;

		function string to_string();
            string txt; 
            $sformat(txt, "paddr:0x%h pwdata:0x%h psel:0x%h", paddr,pwdata,psel);
            return txt;
        endfunction
	///////////////////////////////////////////////////////////////
	//rsp_item
	////////////////////////////////////////////////////////////////
	class   apb_rsp_item # (parameter DATA_WIDTH = 0,
	                        parameter DATA_WIDTH   =0,
				            parameter NUM_OF_APB   =0)
    extends apb_seq_item # (.DATA_IN_WIDTH (DATA_WIDTH)
	                        .ADDR_WIDTH(ADDR_WIDTH),
	                        .NUM_OF_APB(NUM_OF_APB)
	);
 
          bit [DATA_WIDTH-1:0] prdata;
 
          function string to_string();
              string txt;
              txt = super.to_string();
              $sformat(txt, "%s write_data :0x%h ", txt, prdata);
              return txt;
          endfunction     
	  endclass
   ///////////////////////////////////////////////////////////////////
   //driver
   ////////////////////////////////////////////////////////////////////
   class apb_drv #(parameter ADDR_WIDTH   =0,
	               parameter DATA_WIDTH   =0,
				   parameter NUM_OF_APB   =0
			   );
       typedef apb_seq_item #( 
		   .ADDR_WIDTH    (ADDR_WIDTH),
		   .DATA_IN_WIDTH (DATA_WIDTH),
	       .NUM_OF_APB    (NUM_OF_APB)
		)seq_item_t;
		virtual apb_intf #(.ADDR_WIDTH(ADDR_WIDTH),
			               .DATA_WIDTH(DATA_WIDTH),
                           .NUM_OF_APB (NUM_OF_APB)
					   ) intf;
		int d_min = 1;
		int d_max = 4;
		
		mailbox #(seq_item_t) drv_mbx;
        
		mailbox #(seq_item_t) drv_in = new();
        mailbox #(seq_item_t) drv_o  = new();
      function new (virtual apb_intf #(.DATA_WIDTH(DATA_WIDTH),
		                               .ADDR_WIDTH(ADDR_WIDTH),
									   .NUM_OF_APB(NUM_OF_APB)
								       ) intf);        
            this.intf = intf;
        endfunction






























endpackage
