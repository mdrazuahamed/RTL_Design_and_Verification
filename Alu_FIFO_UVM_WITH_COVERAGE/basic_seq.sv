class basic_seq extends uvm_sequence #(alu_seq_item);

    `uvm_object_utils(basic_seq)

    function new(string name="basic_seq");
        super.new(name);
    endfunction

    virtual task body();

        for (int i = 0; i < 25; i++)
        begin
            alu_seq_item item = alu_seq_item::type_id::create("item");
            start_item(item);
            item.randomize();
            finish_item(item);
        end

    endtask

endclass
