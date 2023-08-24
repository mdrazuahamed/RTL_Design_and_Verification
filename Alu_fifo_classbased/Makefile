SEED = 1

CLEAN_TARGETS += *.wdb
CLEAN_TARGETS += *.log
CLEAN_TARGETS += *.jou
CLEAN_TARGETS += *.pb
CLEAN_TARGETS += .Xil
CLEAN_TARGETS += xsim.dir

SRC += src/design/fifo.sv
SRC += src/design/adder.sv
SRC += src/design/top_adder_fifo.sv
SRC += src/tb/top_adder_fifo_intf.sv
SRC += src/tb/tb_top.sv

.PHONY: help
help:
	@echo "make vivado SEED=1 # to simulate with seed=1"
	@echo "make wave # to see waveform"
	@echo "make clean # to clean up the enviroment"

.PHONY: vivado
vivado: elaborate
	@xsim top -sv_seed $(SEED) -runall
	@rm -rf $(CLEAN_TARGETS)

.PHONY: elaborate
elaborate: compile
	@xelab tb_top -s top

.PHONY: compile
compile: remove_temp
	@ xvlog -sv $(SRC)

.PHONY: remove_temp
remove_temp:
	@rm -rf $(CLEAN_TARGETS)

.PHONY: clean
clean: remove_temp
	@rm -rf *.vcd

.PHONY: wave
wave:
	@rm -rf wave.gtkw
	@echo "[*]" > wave.gtkw
	@echo "[*] GTKWave Analyzer v3.3.100 (w)1999-2019 BSI" >> wave.gtkw
	@echo "[*] Tue Apr 04 05:41:48 2023" >> wave.gtkw
	@echo "[*]" >> wave.gtkw
	@echo "[dumpfile] \"C:\\Users\\foeza\\Desktop\\adder\\raw.vcd\"" >> wave.gtkw
	@echo "[dumpfile_mtime] \"Tue Apr 04 05:39:21 2023\"" >> wave.gtkw
	@echo "[dumpfile_size] 45847" >> wave.gtkw
	@echo "[savefile] \"C:\\Users\\foeza\\Desktop\\adder\\wave.gtkw\"" >> wave.gtkw
	@echo "[timestart] 0" >> wave.gtkw
	@echo "[size] 1920 1009" >> wave.gtkw
	@echo "[pos] -35 -35" >> wave.gtkw
	@echo "*-18.487314 534000 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1" >> wave.gtkw
	@echo "[treeopen] tb_top." >> wave.gtkw
	@echo "[sst_width] 197" >> wave.gtkw
	@echo "[signals_width] 158" >> wave.gtkw
	@echo "[sst_expanded] 1" >> wave.gtkw
	@echo "[sst_vpaned_height] 297" >> wave.gtkw
	@echo "@28" >> wave.gtkw
	@echo "tb_top.arst_n" >> wave.gtkw
	@echo "tb_top.clk_i" >> wave.gtkw
	@echo "@22" >> wave.gtkw
	@echo "tb_top.intf.fifo_1_in[7:0]" >> wave.gtkw
	@echo "@28" >> wave.gtkw
	@echo "tb_top.intf.fifo_1_in_valid" >> wave.gtkw
	@echo "tb_top.intf.fifo_1_in_ready" >> wave.gtkw
	@echo "@22" >> wave.gtkw
	@echo "tb_top.intf.fifo_2_in[7:0]" >> wave.gtkw
	@echo "@28" >> wave.gtkw
	@echo "tb_top.intf.fifo_2_in_valid" >> wave.gtkw
	@echo "tb_top.intf.fifo_2_in_ready" >> wave.gtkw
	@echo "@22" >> wave.gtkw
	@echo "tb_top.intf.out[8:0]" >> wave.gtkw
	@echo "@28" >> wave.gtkw
	@echo "tb_top.intf.fifo_3_out_valid" >> wave.gtkw
	@echo "@29" >> wave.gtkw
	@echo "tb_top.intf.fifo_3_out_ready" >> wave.gtkw
	@echo "[pattern_trace] 1" >> wave.gtkw
	@echo "[pattern_trace] 0" >> wave.gtkw
	@gtkwave wave.gtkw
	@rm wave.gtkw
