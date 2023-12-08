FLIST  += ../memory_col_n.sv
FLIST  += memory_col_tb.sv

TOP    = memory_col_tb

CT     += *.log
CT     += *.pb
CT     += *.jou
CT     += *.vcd
CT     += xsim.dir
CT     += top.wdb

run: clean
	@xvlog -sv $(FLIST)
	@xelab $(TOP) -s top
	@xsim  top -runall

clean:
	@rm -rf $(CT)