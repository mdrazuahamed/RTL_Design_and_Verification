package adder_verif_pkg;

    /////////////////////////////////////////////////////////////////////////////
    // seq item
    /////////////////////////////////////////////////////////////////////////////

    class adder_seq_item # (parameter DATA_IN_WIDTH = 0);
        
        rand bit [DATA_IN_WIDTH-1:0] inA;
        rand bit [DATA_IN_WIDTH-1:0] inB;

        function string to_string();
            string txt;
            $sformat(txt, "inA:0x%h inB:0x%h", inA, inB);
            return txt;
        endfunction 

    endclass
    
    /////////////////////////////////////////////////////////////////////////////
    // rsp item
    /////////////////////////////////////////////////////////////////////////////

    class adder_rsp_item # (parameter DATA_IN_WIDTH = 0) 
    extends adder_seq_item # (.DATA_IN_WIDTH (DATA_IN_WIDTH));
        
        bit [DATA_IN_WIDTH:0] out;

        function string to_string();
            string txt;
            txt = super.to_string();
            $sformat(txt, "%s out:0x%h ", txt, out);
            return txt;
        endfunction 

    endclass
    
    /////////////////////////////////////////////////////////////////////////////
    // driver item
    /////////////////////////////////////////////////////////////////////////////

    class adder_dvr # (parameter DATA_IN_WIDTH = 0);

        typedef adder_seq_item # (
            .DATA_IN_WIDTH (DATA_IN_WIDTH)
        ) seq_item_t;

        virtual top_adder_fifo_intf #(.DATA_IN_WIDTH(DATA_IN_WIDTH)) intf;

        int d_min = 1;// For delay
        int d_max = 4;

        mailbox #(seq_item_t) dvr_mbx;

        local mailbox #(seq_item_t) dvr_in_A = new ();
        local mailbox #(seq_item_t) dvr_in_B = new ();
        local mailbox #(seq_item_t) dvr_in_O = new ();

        function new (virtual top_adder_fifo_intf #(.DATA_IN_WIDTH(DATA_IN_WIDTH)) intf);        
            this.intf = intf;
        endfunction

        task automatic run ();
            fork

                forever begin
                    seq_item_t item;
                    seq_item_t item_A;//for fifo_in_1
                    seq_item_t item_B;//for fifo_in_2
                    seq_item_t item_O;// for fifo_3_out_ready
                    dvr_mbx.get(item);//sequencer put this item that's on tb_top
                    item_A = new item;
                    item_B = new item;
                    item_O = new item;
                    dvr_in_A.put(item_A);
                    dvr_in_B.put(item_B);
                    dvr_in_O.put(item_O);
                end

                forever begin
                    seq_item_t item;
                    dvr_in_A.get(item);
                    repeat ($urandom_range(d_min, d_max)) @ (posedge intf.clk_i);//d for delay
                    intf.fifo_1_in       <= item.inA;
                    intf.fifo_1_in_valid <= '1;
                    do @ (posedge intf.clk_i);
                    while (intf.fifo_1_in_ready !== '1);
                    intf.fifo_1_in_valid <= '0;
                end

                forever begin
                    seq_item_t item;
                    dvr_in_B.get(item);
                    repeat ($urandom_range(d_min, d_max)) @ (posedge intf.clk_i);
                    intf.fifo_2_in       <= item.inB;
                    intf.fifo_2_in_valid <= '1;
                    do @ (posedge intf.clk_i);
                    while (intf.fifo_2_in_ready !== '1);
                    intf.fifo_2_in_valid <= '0;
                end

                forever begin
                    seq_item_t item;
                    dvr_in_O.get(item);
                    repeat ($urandom_range(d_min, d_max)) @ (posedge intf.clk_i);
                    intf.fifo_3_out_ready <= '1;
                    do @ (posedge intf.clk_i);
                    while (intf.fifo_3_out_valid !== '1);
                    intf.fifo_3_out_ready <= '0;
                end

            join_none
        endtask

    endclass
    
    /////////////////////////////////////////////////////////////////////////////
    // monitor item
    /////////////////////////////////////////////////////////////////////////////

    class adder_mon # (parameter DATA_IN_WIDTH = 0);

        typedef adder_rsp_item # (
            .DATA_IN_WIDTH (DATA_IN_WIDTH)
        ) rsp_item_t;

        virtual top_adder_fifo_intf #(.DATA_IN_WIDTH(DATA_IN_WIDTH)) intf;

        mailbox #(rsp_item_t) mon_mbx;

        local mailbox #(rsp_item_t) mon_in_A = new ();
        local mailbox #(rsp_item_t) mon_in_B = new ();
        local mailbox #(rsp_item_t) mon_in_O = new ();

        function new (virtual top_adder_fifo_intf #(.DATA_IN_WIDTH(DATA_IN_WIDTH)) intf);        
            this.intf = intf;
        endfunction

        task automatic run ();
            fork

                forever begin
                    @ (posedge intf.clk_i);
                    if (intf.fifo_1_in_valid & intf.fifo_1_in_ready) begin
                        rsp_item_t item;
                        item = new ();
                        item.inA = intf.fifo_1_in;
                        mon_in_A.put(item);
                    end
                end

                forever begin
                    @ (posedge intf.clk_i);
                    if (intf.fifo_2_in_valid & intf.fifo_2_in_ready) begin
                        rsp_item_t item;
                        item = new ();
                        item.inB = intf.fifo_2_in;
                        mon_in_B.put(item);
                    end
                end

                forever begin
                    @ (posedge intf.clk_i);
                    if (intf.fifo_3_out_valid & intf.fifo_3_out_ready) begin
                        rsp_item_t item;
                        item = new ();
                        item.out = intf.out;
                        mon_in_O.put(item);
                    end
                end

                forever begin
                    rsp_item_t item_A;
                    rsp_item_t item_B;
                    rsp_item_t item_O;
                    rsp_item_t item;
                    item = new ();
                    mon_in_A.get(item_A);
                    mon_in_B.get(item_B);
                    mon_in_O.get(item_O);
                    item.inA = item_A.inA;
                    item.inB = item_B.inB;
                    item.out = item_O.out;
                    mon_mbx.put(item);
                end

            join_none
        endtask

    endclass
    
    /////////////////////////////////////////////////////////////////////////////
    // scoreboard item
    /////////////////////////////////////////////////////////////////////////////

    class adder_scbd # (parameter DATA_IN_WIDTH = 0);

        typedef adder_rsp_item # (
            .DATA_IN_WIDTH (DATA_IN_WIDTH)
        ) rsp_item_t;

        mailbox #(rsp_item_t) scbd_mbx;

        int PASS;
        int FAIL;

        task check_items();
            rsp_item_t item;
            PASS = 0;
            FAIL = 0;
            while (scbd_mbx.num()) begin
                scbd_mbx.get(item);
                if ((item.inA + item.inB) == item.out) begin 
                    PASS++; 
                    $display ("%c[0;32m PASSED %3d + %3d = %3d %c[0m", 27, item.inA, item.inB, item.out, 27);
                end
                else begin 
                    FAIL++;
                    $display ("%c[0;31m FAILED %3d + %3d = %3d %c[0m", 27, item.inA, item.inB, item.out, 27);
                end
            end
            if (FAIL) $write("%c[7;31m", 27);
            else      $write("%c[7;32m", 27);
            $display("%0d/%0d PASSED%c[0m", PASS, PASS + FAIL, 27);
        endtask

    endclass

endpackage
