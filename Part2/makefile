PROJECT = I_FormatCPU
OPENROAD = ~/OpenROAD-flow-scripts/flow
OPENROAD_DESIGN = $(OPENROAD)/designs/nangate45/$(PROJECT)
OPENROAD_REPORT = $(OPENROAD)/reports/nangate45/$(PROJECT)/base
V = $(filter-out tb_%.v, $(wildcard *.v))

.PHONY: all run wave tb fst vvp im openroad_gui openroad clean
.PRECIOUS: %.vvp %.fst $(addprefix $(OPENROAD_DESIGN)/, $(V) config.mk constraint.sdc)

all: $(PROJECT).vvp

wave: $(PROJECT).fst
	gtkwave $<

tb fst run $(PROJECT).fst: $(PROJECT).vvp testbench/IM.dat testbench/RF.dat
	vvp $< -fst;

vvp: $(PROJECT).vvp

$(PROJECT).vvp: tb_$(PROJECT).v $(V)
	iverilog -g2012 $^ -o $@

im: testbench/IM.dat

testbench/IM.dat: main.a assembler.py
	python3 assembler.py main.a $@

openroad_gui: $(OPENROAD_REPORT)/6_finish.rpt $(OPENROAD_REPORT)/synth_stat.txt
	cd $(OPENROAD) && make gui_final

openroad: 6_finish.rpt synth_stat.txt

6_finish.rpt synth_stat.txt: $(OPENROAD_REPORT)/6_finish.rpt $(OPENROAD_REPORT)/synth_stat.txt
	cp $^ .

$(OPENROAD_REPORT)/%: $(addprefix $(OPENROAD_DESIGN)/, $(V) config.mk constraint.sdc)
	cd $(OPENROAD) && make clean_all && make

$(OPENROAD_DESIGN)/%: % $(OPENROAD_DESIGN)
	cp $< $@

$(OPENROAD_DESIGN):
	mkdir -p $(OPENROAD_DESIGN)

clean:
	rm -f *.vvp *.fst 6_finish.rpt synth_stat.txt