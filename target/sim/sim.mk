# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

HCI_SIM_DIR = $(HCI_ROOT)/target/sim

# Top-level to simulate
sim_top_level ?= tb_hci_system

#############
# QuestaSim #
#############

# Tooling
SIM_QUESTA ?= questa-2022.3
SIM_VLIB ?= $(SIM_QUESTA) vlib
SIM_VSIM ?= $(SIM_QUESTA) vsim
SIM_VOPT ?= $(SIM_QUESTA) vopt

# Parameters
GUI ?= 0

sim_vsim_lib ?= $(HCI_SIM_DIR)/vsim/work
SIM_SRC_FILES = $(shell find {$(HCI_HW_DIR),$(HCI_TEST_DIR)} -type f)
SIM_QUESTA_SUPPRESS ?= -suppress 3009 -suppress 3053 -suppress 8885 -suppress 12003

# vlog compilation arguments
SIM_HCI_VLOG_ARGS ?=
SIM_HCI_VLOG_ARGS += -work $(sim_vsim_lib)
# vopt optimization arguments
SIM_HCI_VOPT_ARGS ?=
SIM_HCI_VOPT_ARGS += $(SIM_QUESTA_SUPPRESS) -work $(sim_vsim_lib)
# vsim simulation arguments
SIM_HCI_VSIM_ARGS ?=
SIM_HCI_VSIM_ARGS += $(SIM_QUESTA_SUPPRESS) -lib $(sim_vsim_lib) +permissive +notimingchecks +nospecify -t 1ps
ifeq ($(GUI),0)
	SIM_HCI_VSIM_ARGS += -c
endif

$(HCI_SIM_DIR)/vsim/compile.tcl: $(HCI_ROOT)/Bender.lock $(HCI_ROOT)/Bender.yml $(HCI_ROOT)/bender.mk $(HCI_ROOT)/config.mk
	$(BENDER) script vsim $(COMMON_DEFS) $(SIM_DEFS) $(COMMON_TARGS) $(SIM_TARGS) --vlog-arg="$(SIM_HCI_VLOG_ARGS)" > $@

.PHONY: compile-vsim
compile-vsim: $(sim_vsim_lib)/.hw_compiled
$(sim_vsim_lib)/.hw_compiled: $(HCI_SIM_DIR)/vsim/compile.tcl $(HCI_ROOT)/.bender/.checkout_stamp $(SIM_SRC_FILES)
	cd $(HCI_SIM_DIR)/vsim && \
	$(SIM_VLIB) $(sim_vsim_lib) && \
	$(SIM_VSIM) -c -do 'quit -code [source $<]' && \
	date > $@

.PHONY: opt-vsim
opt-vsim: $(sim_vsim_lib)/$(sim_top_level)_optimized/.tb_opt_compiled
$(sim_vsim_lib)/$(sim_top_level)_optimized/.tb_opt_compiled: $(sim_vsim_lib)/.hw_compiled
	cd $(HCI_SIM_DIR)/vsim && \
	$(SIM_VOPT) $(SIM_HCI_VOPT_ARGS) $(sim_top_level) -o $(sim_top_level)_optimized +acc && \
	date > $@

.PHONY: run-vsim
run-vsim: $(sim_vsim_lib)/$(sim_top_level)_optimized/.tb_opt_compiled
	cd $(HCI_SIM_DIR)/vsim && \
	$(SIM_VSIM) $(SIM_HCI_VSIM_ARGS) \
	$(sim_top_level)_optimized \
	-do 'set GUI $(GUI); source $(HCI_SIM_DIR)/vsim/$(sim_top_level).tcl'

###########
# Helpers #
###########

.PHONY: clean-vsim
clean-vsim:
	rm -rf $(HCI_SIM_DIR)/vsim/work
	rm -rf $(HCI_SIM_DIR)/vsim/{transcript,*.ini,*.wlf}
	rm -f $(HCI_SIM_DIR)/vsim/compile.tcl
