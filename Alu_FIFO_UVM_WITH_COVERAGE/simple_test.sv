class simple_test extends alu_base_test;

    //////////////////////////////////////////////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    //////////////////////////////////////////////////////////////////////////////////

    `uvm_component_utils (simple_test)

    //////////////////////////////////////////////////////////////////////////////////
    // FUNCTIONS
    //////////////////////////////////////////////////////////////////////////////////

    function new (string name = "simple_test", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
    endfunction

    //////////////////////////////////////////////////////////////////////////////////
    // TASKS
    //////////////////////////////////////////////////////////////////////////////////

    task run_phase (uvm_phase phase);
        super.run_phase (phase);

        // running logics

        phase.raise_objection(this);

        start_clock();
        apply_reset();

        begin
            basic_seq seq;
            seq = basic_seq::type_id::create("seq");
            seq.start(env.agent.sqr);
        end

        wait_cooldown();

        phase.drop_objection(this);

    endtask

endclass : simple_test
