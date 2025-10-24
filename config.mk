# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

N_HWPE ?= 8
N_CORE ?= 8
HWPE_WIDTH_FACT ?= 8
N_BANKS ?= 16
BANK_SIZE ?= 1024
SEL_LIC ?= 0
# Interco type, can be:
# - LOG: fully logarithmic interconnect
# - SMUX: HCI with only 1 wide port at the shallow branch, multiple HWPEs are muxed
# - HCI: full HCI with multiple wide ports at the shallow branch
INTERCO ?= SMUX


#########################
# Parameters generation #
#########################
# Do not change from here on!

HW_CFG_DEFS :=
HW_CFG_TARGS :=

HW_CFG_DEFS += -D N_HWPE=$(N_HWPE)
HW_CFG_DEFS += -D N_CORE=$(N_CORE)
HW_CFG_DEFS += -D HWPE_WIDTH_FACT=$(HWPE_WIDTH_FACT)
HW_CFG_DEFS += -D N_BANKS=$(N_BANKS)
HW_CFG_DEFS += -D BANK_SIZE=$(BANK_SIZE)
HW_CFG_DEFS += -D SEL_LIC=$(SEL_LIC)
HW_CFG_DEFS += -D INTERCO=$(INTERCO)
