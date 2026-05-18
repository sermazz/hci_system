// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

// TCDM backdoor preloading tasks for ASIC post-layout simulation.
// Must be `included inside the tb_hci_system module body (not in a package) because
// `force` hierarchical paths require module-scope name resolution at compile time.

// Two compile-time defines control this file:
//   +define+TCDM_WE_ACTIVE_LOW  -> netlist exposes active-low we_i_BAR (default: active-high we_i)
//   +define+TCDM_64_BANKS       -> netlist has 64 banks (default: 32 banks)
`ifdef TCDM_WE_ACTIVE_LOW
  `define TCDM_WE_PORT we_i_BAR
  `define TCDM_WE_ASSERT 1'b0
`else
  `define TCDM_WE_PORT we_i
  `define TCDM_WE_ASSERT 1'b0
`endif

`ifdef TCDM_ASIC_FAST_PRELOAD
`ifdef TARGET_ASIC
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

`ifdef TCDM_64_BANKS
    32: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_32__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_32__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_32__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_32__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_32__i_bank.wdata_i  = s_wdata; end
    33: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_33__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_33__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_33__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_33__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_33__i_bank.wdata_i  = s_wdata; end
    34: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_34__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_34__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_34__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_34__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_34__i_bank.wdata_i  = s_wdata; end
    35: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_35__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_35__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_35__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_35__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_35__i_bank.wdata_i  = s_wdata; end
    36: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_36__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_36__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_36__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_36__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_36__i_bank.wdata_i  = s_wdata; end
    37: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_37__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_37__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_37__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_37__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_37__i_bank.wdata_i  = s_wdata; end
    38: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_38__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_38__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_38__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_38__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_38__i_bank.wdata_i  = s_wdata; end
    39: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_39__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_39__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_39__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_39__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_39__i_bank.wdata_i  = s_wdata; end
    40: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_40__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_40__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_40__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_40__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_40__i_bank.wdata_i  = s_wdata; end
    41: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_41__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_41__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_41__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_41__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_41__i_bank.wdata_i  = s_wdata; end
    42: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_42__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_42__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_42__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_42__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_42__i_bank.wdata_i  = s_wdata; end
    43: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_43__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_43__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_43__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_43__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_43__i_bank.wdata_i  = s_wdata; end
    44: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_44__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_44__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_44__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_44__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_44__i_bank.wdata_i  = s_wdata; end
    45: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_45__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_45__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_45__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_45__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_45__i_bank.wdata_i  = s_wdata; end
    46: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_46__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_46__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_46__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_46__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_46__i_bank.wdata_i  = s_wdata; end
    47: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_47__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_47__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_47__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_47__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_47__i_bank.wdata_i  = s_wdata; end
    48: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_48__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_48__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_48__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_48__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_48__i_bank.wdata_i  = s_wdata; end
    49: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_49__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_49__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_49__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_49__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_49__i_bank.wdata_i  = s_wdata; end
    50: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_50__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_50__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_50__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_50__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_50__i_bank.wdata_i  = s_wdata; end
    51: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_51__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_51__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_51__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_51__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_51__i_bank.wdata_i  = s_wdata; end
    52: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_52__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_52__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_52__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_52__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_52__i_bank.wdata_i  = s_wdata; end
    53: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_53__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_53__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_53__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_53__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_53__i_bank.wdata_i  = s_wdata; end
    54: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_54__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_54__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_54__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_54__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_54__i_bank.wdata_i  = s_wdata; end
    55: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_55__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_55__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_55__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_55__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_55__i_bank.wdata_i  = s_wdata; end
    56: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_56__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_56__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_56__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_56__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_56__i_bank.wdata_i  = s_wdata; end
    57: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_57__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_57__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_57__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_57__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_57__i_bank.wdata_i  = s_wdata; end
    58: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_58__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_58__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_58__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_58__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_58__i_bank.wdata_i  = s_wdata; end
    59: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_59__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_59__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_59__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_59__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_59__i_bank.wdata_i  = s_wdata; end
    60: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_60__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_60__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_60__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_60__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_60__i_bank.wdata_i  = s_wdata; end
    61: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_61__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_61__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_61__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_61__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_61__i_bank.wdata_i  = s_wdata; end
    62: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_62__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_62__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_62__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_62__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_62__i_bank.wdata_i  = s_wdata; end
    63: begin force tb_hci_system.i_dut.i_tcdm.gen_banks_63__i_bank.req_i    = 1'b1;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_63__i_bank.`TCDM_WE_PORT = `TCDM_WE_ASSERT;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_63__i_bank.be_i     = 4'hF;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_63__i_bank.addr_i   = s_addr;
             force tb_hci_system.i_dut.i_tcdm.gen_banks_63__i_bank.wdata_i  = s_wdata; end
`endif
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

`ifdef TCDM_64_BANKS
    32: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_32__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_32__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_32__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_32__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_32__i_bank.wdata_i; end
    33: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_33__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_33__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_33__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_33__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_33__i_bank.wdata_i; end
    34: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_34__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_34__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_34__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_34__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_34__i_bank.wdata_i; end
    35: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_35__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_35__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_35__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_35__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_35__i_bank.wdata_i; end
    36: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_36__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_36__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_36__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_36__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_36__i_bank.wdata_i; end
    37: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_37__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_37__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_37__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_37__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_37__i_bank.wdata_i; end
    38: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_38__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_38__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_38__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_38__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_38__i_bank.wdata_i; end
    39: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_39__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_39__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_39__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_39__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_39__i_bank.wdata_i; end
    40: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_40__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_40__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_40__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_40__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_40__i_bank.wdata_i; end
    41: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_41__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_41__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_41__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_41__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_41__i_bank.wdata_i; end
    42: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_42__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_42__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_42__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_42__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_42__i_bank.wdata_i; end
    43: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_43__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_43__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_43__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_43__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_43__i_bank.wdata_i; end
    44: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_44__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_44__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_44__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_44__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_44__i_bank.wdata_i; end
    45: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_45__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_45__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_45__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_45__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_45__i_bank.wdata_i; end
    46: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_46__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_46__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_46__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_46__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_46__i_bank.wdata_i; end
    47: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_47__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_47__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_47__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_47__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_47__i_bank.wdata_i; end
    48: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_48__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_48__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_48__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_48__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_48__i_bank.wdata_i; end
    49: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_49__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_49__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_49__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_49__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_49__i_bank.wdata_i; end
    50: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_50__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_50__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_50__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_50__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_50__i_bank.wdata_i; end
    51: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_51__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_51__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_51__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_51__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_51__i_bank.wdata_i; end
    52: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_52__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_52__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_52__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_52__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_52__i_bank.wdata_i; end
    53: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_53__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_53__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_53__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_53__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_53__i_bank.wdata_i; end
    54: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_54__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_54__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_54__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_54__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_54__i_bank.wdata_i; end
    55: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_55__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_55__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_55__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_55__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_55__i_bank.wdata_i; end
    56: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_56__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_56__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_56__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_56__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_56__i_bank.wdata_i; end
    57: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_57__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_57__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_57__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_57__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_57__i_bank.wdata_i; end
    58: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_58__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_58__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_58__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_58__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_58__i_bank.wdata_i; end
    59: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_59__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_59__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_59__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_59__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_59__i_bank.wdata_i; end
    60: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_60__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_60__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_60__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_60__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_60__i_bank.wdata_i; end
    61: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_61__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_61__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_61__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_61__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_61__i_bank.wdata_i; end
    62: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_62__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_62__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_62__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_62__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_62__i_bank.wdata_i; end
    63: begin release tb_hci_system.i_dut.i_tcdm.gen_banks_63__i_bank.req_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_63__i_bank.`TCDM_WE_PORT;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_63__i_bank.be_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_63__i_bank.addr_i;
             release tb_hci_system.i_dut.i_tcdm.gen_banks_63__i_bank.wdata_i; end
`endif
    default: $fatal(1, "tcdm_backdoor_release: bank_idx %0d out of range", bank_idx);
  endcase
endtask : tcdm_backdoor_release

`endif
`endif
