// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>
// Luca Codeluppi <lcodelupp@student.ethz.ch>

timeunit 1ns;
timeprecision 1ps;

`include "hci_helpers.svh"

module tb_hci_system
  import hci_package::*;
  import hci_system_pkg::*;
  import tb_hci_system_pkg::*;
#()();

  /* Signals */

  logic                 s_clk, s_rst_n;
  logic                 s_clear;

  logic [1:0]           s_arb_policy;
  logic                 s_invert_prio;
  logic [7:0]           s_low_prio_max_stall;

  logic                 s_periph_req;
  logic                 s_periph_gnt;
  logic [31:0]          s_periph_add;
  logic                 s_periph_wen;
  logic [3:0]           s_periph_be;
  logic [31:0]          s_periph_data;
  logic [ID_PERIPH-1:0] s_periph_id;
  logic [31:0]          s_periph_r_data;
  logic                 s_periph_r_valid;
  logic [ID_PERIPH-1:0] s_periph_r_id;

  logic                 s_ext_tcdm_req;
  logic                 s_ext_tcdm_gnt;
  logic [31:0]          s_ext_tcdm_add;
  logic                 s_ext_tcdm_wen;
  logic [31:0]          s_ext_tcdm_data;
  logic [3:0]           s_ext_tcdm_be;
  logic [31:0]          s_ext_tcdm_r_data;
  logic                 s_ext_tcdm_r_valid;
  logic                 s_ext_tcdm_r_ready;

  /* Clock */

  clk_rst_gen #(
      .ClkPeriod ( CLK_PERIOD ),
      .RstClkCycles ( RST_CYCLES )
  ) i_clk_rst_gen (
      .clk_o ( s_clk ),
      .rst_no( s_rst_n )
  );

  ////////////////
  // HCI system //
  ////////////////

  hci_system #() i_dut (
    .clk_i ( s_clk ),
    .rst_ni ( s_rst_n ),
    .clear_i ( s_clear ),
    .arb_policy_i ( s_arb_policy ),
    .invert_prio_i ( s_invert_prio ),
    .low_prio_max_stall_i ( s_low_prio_max_stall ),
    .periph_req_i ( s_periph_req ),
    .periph_gnt_o ( s_periph_gnt ),
    .periph_add_i ( s_periph_add ),
    .periph_wen_i ( s_periph_wen ),
    .periph_be_i ( s_periph_be ),
    .periph_data_i ( s_periph_data ),
    .periph_id_i ( s_periph_id ),
    .periph_r_data_o ( s_periph_r_data ),
    .periph_r_valid_o ( s_periph_r_valid ),
    .periph_r_id_o ( s_periph_r_id ),
    .ext_tcdm_req_i ( s_ext_tcdm_req ),
    .ext_tcdm_gnt_o ( s_ext_tcdm_gnt ),
    .ext_tcdm_add_i ( s_ext_tcdm_add ),
    .ext_tcdm_wen_i ( s_ext_tcdm_wen ),
    .ext_tcdm_data_i ( s_ext_tcdm_data ),
    .ext_tcdm_be_i ( s_ext_tcdm_be ),
    .ext_tcdm_r_data_o ( s_ext_tcdm_r_data ),
    .ext_tcdm_r_valid_o ( s_ext_tcdm_r_valid ),
    .ext_tcdm_r_ready_i ( s_ext_tcdm_r_ready )
  );

  ///////////////////
  // Peripheral if //
  ///////////////////

  periph_bus_t periph_if;

  assign s_periph_req = periph_if.req;
  assign s_periph_add = periph_if.add;
  assign s_periph_wen = periph_if.wen;
  assign s_periph_be = periph_if.be;
  assign s_periph_data = periph_if.data;
  assign s_periph_id = periph_if.id;
  assign periph_if.gnt = s_periph_gnt;
  assign periph_if.r_data = s_periph_r_data;
  assign periph_if.r_valid = s_periph_r_valid;
  assign periph_if.r_id = s_periph_r_id;

  //////////
  // Test //
  //////////

  initial begin
    logic [31:0] status;
    logic [31:0] dm_offset;
    logic [N_DATAMOVERS-1:0] dm_done;
    int i_hwpe;
    automatic logic ret;

    $info("Starting test");

    /* Initialize */
    status = '1;
    dm_done = '0;
    // Set up HCI
    s_arb_policy = 2'b00;
    s_invert_prio = 1'b0;
    s_low_prio_max_stall = 8'd5;
    // Clear all inputs
    s_clear = 1'b0;
    // Peripheral interface
    periph_if.req = '0;
    periph_if.add = '0;
    periph_if.wen = '0;
    periph_if.be = '0;
    periph_if.data = '0;
    periph_if.id = '0;
    // External TCDM port
    s_ext_tcdm_req = '0;
    s_ext_tcdm_add = '0;
    s_ext_tcdm_wen = '0;
    s_ext_tcdm_data = '0;
    s_ext_tcdm_be = '0;
    s_ext_tcdm_r_ready = '0;

    // Wait for reset to be released
    @(posedge s_rst_n);
    repeat (5) @(posedge s_clk);
    #TbTA;
  
    $info("Initializing TCDM");
    s_ext_tcdm_req = 1'b1;
    s_ext_tcdm_wen = 1'b0; // wen = 0 for HCI protocol
    s_ext_tcdm_be = '1;
    s_ext_tcdm_r_ready = 1'b1; // prepare for write ack (HCI protocol returns r_valid also for writes)
    // Fill up TCDM with random words
    for (int i = 0; i < TCDM_SIZE / WORD_SIZE; i++) begin
      s_ext_tcdm_add = i << 2; // add 2 LSBs for byte offset
      // $info("Loading TCDM address %0d", s_ext_tcdm_add);
      ret = std::randomize(s_ext_tcdm_data); assert(ret);
      // Wait for write request grant
      while (1) begin
        // Go to test time
        #(TbTT - TbTA);
        if (s_ext_tcdm_gnt == 1'b1) break;
        @(posedge s_clk);
        #TbTA;
      end
      @(posedge s_clk);
      #TbTA;
      // Here we should check for write ack (r_valid)
      // but for simplicity we assume write is always successful
    end

    @(posedge s_clk);
    #TbTA;
    s_ext_tcdm_req = 1'b0;
    s_ext_tcdm_r_ready = '0;
    repeat (5) @(posedge s_clk);

    $info("Soft clear of all datamover masters");
    for(int i = 0; i < N_DATAMOVERS; i++) begin
      dm_offset = { i[PERIPH_SEL_WIDTH-1:0], {(32-PERIPH_SEL_WIDTH){1'b0}} };
      $info("Clearing datamover %0d", i);
      periph_write(dm_offset + datamover_package::HWPE_REGISTER_OFFS, datamover_package::DATAMOVER_SOFT_CLEAR, 32'hf0cacc1a, s_clk, periph_if);
      repeat (100) @(posedge s_clk);
    end

    $info("Set-up of all datamover masters");
    for(int i = 0; i < N_DATAMOVERS; i++) begin
      dm_offset = { i[PERIPH_SEL_WIDTH-1:0], {(32-PERIPH_SEL_WIDTH){1'b0}} };
      while(status != 32'h00000000)
        periph_read(dm_offset + datamover_package::HWPE_REGISTER_OFFS, datamover_package::DATAMOVER_ACQUIRE, status, s_clk, periph_if);

      if (i < N_CORE) begin
        $info("Configuring core datamover %0d", i);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_PTR, DM_CORE_IN_PTR + N_BANKS*WORD_SIZE*dm_core_in_d0_len*i, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_PTR, DM_CORE_OUT_PTR + N_BANKS*WORD_SIZE*i, s_clk, periph_if);

        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_LEN0, DM_CORE_LEN0, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_LEN1, DM_CORE_LEN1, s_clk, periph_if);

        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D0_STRIDE, DM_CORE_IN_D0_STRIDE, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D1_STRIDE, DM_CORE_IN_D1_STRIDE, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D2_STRIDE, DM_CORE_IN_D2_STRIDE, s_clk, periph_if);

        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D0_STRIDE, DM_CORE_OUT_D0_STRIDE, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D1_STRIDE, DM_CORE_OUT_D1_STRIDE, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D2_STRIDE, DM_CORE_OUT_D2_STRIDE, s_clk, periph_if);

        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_TRANSP_MODE, DM_CORE_TRANSP_MODE, s_clk, periph_if);
      end else begin
        i_hwpe = i - N_CORE;
        $info("Configuring HWPE datamover %0d", i_hwpe);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_PTR, DM_HWPE_IN_PTR + N_BANKS*WORD_SIZE*dm_hwpe_in_d0_len*i_hwpe, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_PTR, DM_HWPE_OUT_PTR + N_BANKS*WORD_SIZE*dm_hwpe_out_d0_len*i_hwpe, s_clk, periph_if);

        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_LEN0, DM_HWPE_LEN0, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_LEN1, DM_HWPE_LEN1, s_clk, periph_if);

        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D0_STRIDE, DM_HWPE_IN_D0_STRIDE, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D1_STRIDE, DM_HWPE_IN_D1_STRIDE, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D2_STRIDE, DM_HWPE_IN_D2_STRIDE, s_clk, periph_if);

        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D0_STRIDE, DM_HWPE_OUT_D0_STRIDE, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D1_STRIDE, DM_HWPE_OUT_D1_STRIDE, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D2_STRIDE, DM_HWPE_OUT_D2_STRIDE, s_clk, periph_if);

        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_TRANSP_MODE, DM_HWPE_TRANSP_MODE, s_clk, periph_if);
      end
      repeat (10) @(posedge s_clk);
    end

    $info("Triggering datamovers");
    for(int i = 0; i < N_DATAMOVERS; i++) begin
      $info("Triggering datamover %0d", i);
      dm_offset = { i[PERIPH_SEL_WIDTH-1:0], {(32-PERIPH_SEL_WIDTH){1'b0}} };
      periph_write(dm_offset + datamover_package::HWPE_REGISTER_OFFS, datamover_package::DATAMOVER_COMMIT_AND_TRIGGER, 32'h0, s_clk, periph_if);
      @(posedge s_clk);
    end

    $info("Waiting for end of task...");
    while ((& dm_done) != 1) begin
      for(int i = 0; i < N_DATAMOVERS; i++) begin
        if (dm_done[i] != 1'b1) begin
          dm_offset = { i[PERIPH_SEL_WIDTH-1:0], {(32-PERIPH_SEL_WIDTH){1'b0}} };
          status = '1;
          periph_read(dm_offset + datamover_package::HWPE_REGISTER_OFFS, datamover_package::DATAMOVER_STATUS, status, s_clk, periph_if);
          if (status == 32'h00000000) begin
            dm_done[i] = 1'b1;
            $info("Datamover %0d is done!", i);
          end
        end
      end
      repeat(20) @(posedge s_clk);
    end

    repeat(20) @(posedge s_clk);
    $info("Simulation ended");
    $finish();
  end

endmodule
