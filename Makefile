# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

include config.mk
include bender.mk

HCI_ROOT = $(shell pwd)

# Tooling
BENDER ?= bender

################
# Dependencies #
################

.PHONY: checkout
checkout: $(HCI_ROOT)/.bender/.checkout_stamp

$(HCI_ROOT)/.bender/.checkout_stamp: $(HCI_ROOT)/Bender.lock
	$(BENDER) checkout && \
	date > $@

###########
# Targets #
###########

include $(HCI_ROOT)/hw/hw.mk
include $(HCI_ROOT)/test/test.mk
include $(HCI_ROOT)/target/sim/sim.mk

# Nonfree targets
ASIC_REMOTE ?= git@iis-git.ee.ethz.ch:pulp-restricted/hci_system_asic.git
ASIC_REV    ?= deploy

asic-init:
	git clone $(ASIC_REMOTE) target/asic
	cd target/asic && git checkout $(ASIC_REV)

-include $(HCI_ROOT)/target/asic/asic.mk