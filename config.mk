# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

N_HWPE ?= 1
N_CORE ?= 8
HWPE_WIDTH_FACT ?= 4
N_BANKS ?= 16
BANK_SIZE ?= 2048
USE_HCI ?= 1
SEL_LIC ?= 0


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
HW_CFG_DEFS += -D USE_HCI=$(USE_HCI)
HW_CFG_DEFS += -D SEL_LIC=$(SEL_LIC)
