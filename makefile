FLIST += ./rtl/clk_gate/clk_gate.sv
FLIST += ./tb/tb_clk_gate/tb_clk_gate.sv


#// Change the TOP module name as per as the testbench module 
TOP = tb_clk_gate

CT += *.log
CT += *.pb
CT += *.jou
CT += *.vcd
CT += xsim.dir
CT += top.wdb

run: clean
	@xvlog -sv $(FLIST)
	@xelab $(TOP) -s top
	@xsim top -runall						
clean:
	@rm -rf $(CT)
