FLIST  = ../vip/uart_vip_if.sv
FLIST  = ../verif/uart_vip_if_tb.sv

TOP    = uart_vip_if_tb

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