// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

// TCDM backdoor preloading tasks for ASIC post-layout simulation.
// Must be `included inside the tb_hci_system module body (not in a package) because
// `force` hierarchical paths require module-scope name resolution at compile time.

// Some synthesis runs preserve the active-low we_i_BAR port name from the RAM macro
// wrapper; others flatten it to the standard active-high we_i.  Select at compile time:
//   active-low  (we_i_BAR):  +define+TCDM_WE_ACTIVE_LOW   (default if not set: active-high)
//   active-high (we_i):      no extra define needed
`ifdef TCDM_WE_ACTIVE_LOW
  `define TCDM_WE_PORT we_i_BAR
  `define TCDM_WE_ASSERT 1'b0
`else
  `define TCDM_WE_PORT we_i
  `define TCDM_WE_ASSERT 1'b1
`endif

// Force all 5 tc_sram ports for one bank using the post-layout flat instance names.
// Case statement required because SV `force` does not support variable-index
// hierarchical paths on flat netlist instances.
task automatic tcdm_backdoor_force(
  input int unsigned bank_idx,
  input int unsigned addr,
  input logic [31:0] wdata
);
  // force RHS does not allow automatic vars; copy to static locals first
  static int unsigned s_addr;
  static logic [31:0] s_wdata;
  s_addr  = addr;
  s_wdata = wdata;
  case (bank_idx)
    0:  begin force tb_hci_system.i_dut.i_tcdm.gen_banks_0__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_0__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_0__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_0__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_0__i_bank.wdata_i  = s_wdata; end
    1:  begin force tb_hci_system.i_dut.i_tcdm.gen_banks_1__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_1__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_1__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_1__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_1__i_bank.wdata_i  = s_wdata; end
    2:  begin force tb_hci_system.i_dut.i_tcdm.gen_banks_2__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_2__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_2__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_2__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_2__i_bank.wdata_i  = s_wdata; end
    3:  begin force tb_hci_system.i_dut.i_tcdm.gen_banks_3__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_3__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_3__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_3__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_3__i_bank.wdata_i  = s_wdata; end
    4:  begin force tb_hci_system.i_dut.i_tcdm.gen_banks_4__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_4__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_4__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_4__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_4__i_bank.wdata_i  = s_wdata; end
    5:  begin force tb_hci_system.i_dut.i_tcdm.gen_banks_5__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_5__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_5__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_5__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_5__i_bank.wdata_i  = s_wdata; end
    6:  begin force tb_hci_system.i_dut.i_tcdm.gen_banks_6__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_6__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_6__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_6__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_6__i_bank.wdata_i  = s_wdata; end
    7:  begin force tb_hci_system.i_dut.i_tcdm.gen_banks_7__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_7__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_7__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_7__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_7__i_bank.wdata_i  = s_wdata; end
    8:  begin force tb_hci_system.i_dut.i_tcdm.gen_banks_8__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_8__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_8__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_8__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_8__i_bank.wdata_i  = s_wdata; end
    9:  begin force tb_hci_system.i_dut.i_tcdm.gen_banks_9__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_9__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_9__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_9__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_9__i_bank.wdata_i  = s_wdata; end
    10: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_10__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_10__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_10__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_10__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_10__i_bank.wdata_i  = s_wdata; end
    11: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_11__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_11__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_11__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_11__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_11__i_bank.wdata_i  = s_wdata; end
    12: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_12__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_12__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_12__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_12__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_12__i_bank.wdata_i  = s_wdata; end
    13: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_13__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_13__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_13__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_13__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_13__i_bank.wdata_i  = s_wdata; end
    14: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_14__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_14__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_14__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_14__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_14__i_bank.wdata_i  = s_wdata; end
    15: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_15__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_15__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_15__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_15__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_15__i_bank.wdata_i  = s_wdata; end
    16: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_16__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_16__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_16__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_16__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_16__i_bank.wdata_i  = s_wdata; end
    17: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_17__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_17__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_17__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_17__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_17__i_bank.wdata_i  = s_wdata; end
    18: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_18__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_18__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_18__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_18__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_18__i_bank.wdata_i  = s_wdata; end
    19: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_19__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_19__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_19__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_19__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_19__i_bank.wdata_i  = s_wdata; end
    20: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_20__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_20__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_20__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_20__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_20__i_bank.wdata_i  = s_wdata; end
    21: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_21__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_21__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_21__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_21__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_21__i_bank.wdata_i  = s_wdata; end
    22: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_22__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_22__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_22__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_22__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_22__i_bank.wdata_i  = s_wdata; end
    23: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_23__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_23__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_23__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_23__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_23__i_bank.wdata_i  = s_wdata; end
    24: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_24__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_24__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_24__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_24__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_24__i_bank.wdata_i  = s_wdata; end
    25: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_25__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_25__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_25__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_25__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_25__i_bank.wdata_i  = s_wdata; end
    26: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_26__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_26__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_26__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_26__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_26__i_bank.wdata_i  = s_wdata; end
    27: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_27__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_27__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_27__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_27__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_27__i_bank.wdata_i  = s_wdata; end
    28: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_28__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_28__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_28__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_28__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_28__i_bank.wdata_i  = s_wdata; end
    29: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_29__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_29__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_29__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_29__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_29__i_bank.wdata_i  = s_wdata; end
    30: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_30__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_30__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_30__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_30__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_30__i_bank.wdata_i  = s_wdata; end
    31: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_31__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_31__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_31__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_31__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_31__i_bank.wdata_i  = s_wdata; end
    default: $fatal(1, "tcdm_backdoor_force: bank_idx %0d out of range", bank_idx);
  endcase
endtask : tcdm_backdoor_force

task automatic tcdm_backdoor_release(input int unsigned bank_idx);
  case (bank_idx)
    0:  begin release tb_hci_system.i_dut.i_tcdm.gen_banks_0__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_0__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_0__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_0__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_0__i_bank.wdata_i; end
    1:  begin release tb_hci_system.i_dut.i_tcdm.gen_banks_1__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_1__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_1__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_1__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_1__i_bank.wdata_i; end
    2:  begin release tb_hci_system.i_dut.i_tcdm.gen_banks_2__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_2__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_2__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_2__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_2__i_bank.wdata_i; end
    3:  begin release tb_hci_system.i_dut.i_tcdm.gen_banks_3__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_3__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_3__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_3__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_3__i_bank.wdata_i; end
    4:  begin release tb_hci_system.i_dut.i_tcdm.gen_banks_4__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_4__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_4__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_4__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_4__i_bank.wdata_i; end
    5:  begin release tb_hci_system.i_dut.i_tcdm.gen_banks_5__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_5__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_5__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_5__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_5__i_bank.wdata_i; end
    6:  begin release tb_hci_system.i_dut.i_tcdm.gen_banks_6__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_6__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_6__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_6__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_6__i_bank.wdata_i; end
    7:  begin release tb_hci_system.i_dut.i_tcdm.gen_banks_7__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_7__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_7__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_7__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_7__i_bank.wdata_i; end
    8:  begin release tb_hci_system.i_dut.i_tcdm.gen_banks_8__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_8__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_8__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_8__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_8__i_bank.wdata_i; end
    9:  begin release tb_hci_system.i_dut.i_tcdm.gen_banks_9__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_9__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_9__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_9__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_9__i_bank.wdata_i; end
    10: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_10__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_10__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_10__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_10__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_10__i_bank.wdata_i; end
    11: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_11__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_11__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_11__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_11__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_11__i_bank.wdata_i; end
    12: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_12__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_12__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_12__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_12__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_12__i_bank.wdata_i; end
    13: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_13__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_13__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_13__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_13__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_13__i_bank.wdata_i; end
    14: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_14__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_14__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_14__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_14__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_14__i_bank.wdata_i; end
    15: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_15__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_15__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_15__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_15__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_15__i_bank.wdata_i; end
    16: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_16__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_16__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_16__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_16__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_16__i_bank.wdata_i; end
    17: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_17__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_17__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_17__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_17__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_17__i_bank.wdata_i; end
    18: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_18__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_18__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_18__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_18__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_18__i_bank.wdata_i; end
    19: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_19__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_19__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_19__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_19__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_19__i_bank.wdata_i; end
    20: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_20__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_20__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_20__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_20__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_20__i_bank.wdata_i; end
    21: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_21__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_21__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_21__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_21__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_21__i_bank.wdata_i; end
    22: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_22__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_22__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_22__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_22__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_22__i_bank.wdata_i; end
    23: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_23__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_23__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_23__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_23__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_23__i_bank.wdata_i; end
    24: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_24__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_24__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_24__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_24__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_24__i_bank.wdata_i; end
    25: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_25__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_25__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_25__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_25__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_25__i_bank.wdata_i; end
    26: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_26__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_26__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_26__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_26__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_26__i_bank.wdata_i; end
    27: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_27__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_27__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_27__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_27__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_27__i_bank.wdata_i; end
    28: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_28__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_28__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_28__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_28__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_28__i_bank.wdata_i; end
    29: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_29__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_29__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_29__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_29__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_29__i_bank.wdata_i; end
    30: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_30__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_30__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_30__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_30__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_30__i_bank.wdata_i; end
    31: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_31__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_31__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_31__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_31__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_31__i_bank.wdata_i; end
    default: $fatal(1, "tcdm_backdoor_release: bank_idx %0d out of range", bank_idx);
  endcase
endtask : tcdm_backdoor_release
