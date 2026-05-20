// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>
// Luca Codeluppi <lcodelupp@student.ethz.ch>

timeunit 1ns;
timeprecision 1ps;

`include "hci_helpers.svh"

`ifdef TCDM_ASIC_FAST_PRELOAD
  `ifdef TARGET_ASIC
    `include "tcdm_asic_backdoor.svh"
  `endif
`endif

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
  logic [HWPE_SEL_WIDTH-1:0] s_hwpe_sel;

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
    .hwpe_sel_i ( s_hwpe_sel ),
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

  //TODO: This testbench does not currently test the INTERCO == "smux" case

  initial begin
    logic [31:0] status;
    logic [31:0] dm_offset;
    logic [N_DATAMOVERS-1:0] dm_done;
    int i_hwpe, gemm_idx, dm_i;
    logic [31:0] hwpe_in_base, hwpe_out_base;
    automatic logic ret;

    $info("Starting test");

    // Warn if bank-column assignment overflows: HWPEs would alias onto the same banks and may
    // deadlock under LOG interco. Simulation continues so the effect can be observed.
    if (N_HWPE * HWPE_WIDTH_FACT > N_BANKS)
      $warning("tb_hci_system: N_HWPE(%0d) * HWPE_WIDTH_FACT(%0d) = %0d exceeds N_BANKS(%0d); HWPE bank columns wrap around — LOG interco deadlock likely.",
               N_HWPE, HWPE_WIDTH_FACT, N_HWPE * HWPE_WIDTH_FACT, N_BANKS);

    /* Initialize */
    status = '1;
    dm_done = '0;
    // Set up HCI
    s_arb_policy = 2'b00;
    s_invert_prio = 1'b0;
    s_low_prio_max_stall = 8'd5;
    // Clear all inputs
    s_clear = 1'b0;
    //TODO: Implement s_hwpe_sel for correct testing of `INTERCO==SMUX` case (e.g., blind round-robin among HWPEs, or request-based)
    s_hwpe_sel = 'd0;
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
`ifdef TCDM_ASIC_FAST_PRELOAD
  `ifdef TARGET_ASIC
    // Backdoor: force tc_sram ports directly on all N_BANKS in parallel,
    // bypassing HCI interconnect (1 clock per word row instead of 1 per word total).
    for (int j = 0; j < BANK_SIZE / WORD_SIZE; j++) begin
      for (int i = 0; i < N_BANKS; i++) begin
        ret = std::randomize(s_ext_tcdm_data); assert(ret);
        tcdm_backdoor_force(i, j, s_ext_tcdm_data);
      end
      @(posedge s_clk);
    end
    for (int i = 0; i < N_BANKS; i++)
      tcdm_backdoor_release(i);
    repeat (5) @(posedge s_clk);
  `else
    $fatal("TCDM_ASIC_FAST_PRELOAD is only supported for TARGET_ASIC");
  `endif
`else
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
`endif

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
        // Set up CORES
        $info("Configuring core datamover %0d", i);
        // Offset core i by i*WORD_SIZE so core i always hits bank i (banks 0..N_CORE-1),
        // spreading narrow traffic across different banks and avoiding all-core-to-bank-0 aliasing.
        // (stride = N_BANKS*WORD_SIZE keeps each core pinned to its own bank across all accesses)
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_PTR,  DM_CORE_IN_PTR  + i * WORD_SIZE, s_clk, periph_if);
        periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_PTR, DM_CORE_OUT_PTR + i * WORD_SIZE, s_clk, periph_if);

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
        // Set up HWPEs: first N_DMA_HWPE HWPEs run a DMA (1D linear copy), remaining run a GEMM (2D tile).
        //   N_HWPE=1: 0 DMA + 1 GEMM  (pure weight-tile read)
        //   N_HWPE=2: 1 DMA + 1 GEMM  (prefetch + compute overlap)
        //   N_HWPE=4: 2 DMA + 2 GEMM  (dual prefetch + dual compute)
        i_hwpe = i - N_CORE;
        if (i_hwpe < N_DMA_HWPE) begin
          // DMA pattern: 1D strided access, (dm_hwpe_dma_in_d0_len+1) wide beats
          // Base offset i_hwpe*DM_HWPE_BANK_COL_STRIDE pins this HWPE to bank column i_hwpe.
          $info("Configuring HWPE datamover %0d as DMA", i_hwpe);
          hwpe_in_base  = DM_HWPE_BASE + i_hwpe * DM_HWPE_BANK_COL_STRIDE;
          hwpe_out_base = hwpe_in_base + DM_HWPE_DMA_IN_FOOTPRINT;
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_PTR,       hwpe_in_base,               s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_PTR,      hwpe_out_base,              s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_LEN0,         DM_HWPE_DMA_LEN0,           s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_LEN1,         DM_HWPE_DMA_LEN1,           s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D0_STRIDE, DM_HWPE_DMA_IN_D0_STRIDE,  s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D1_STRIDE, DM_HWPE_DMA_IN_D1_STRIDE,  s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D2_STRIDE, DM_HWPE_DMA_IN_D2_STRIDE,  s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D0_STRIDE,DM_HWPE_DMA_OUT_D0_STRIDE, s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D1_STRIDE,DM_HWPE_DMA_OUT_D1_STRIDE, s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D2_STRIDE,DM_HWPE_DMA_OUT_D2_STRIDE, s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_TRANSP_MODE,  DM_HWPE_DMA_TRANSP_MODE,   s_clk, periph_if);
        end else begin
          // GEMM pattern: 2D tiled weight-matrix access, (d0_len+1) beats × (d1_len+1) rows
          // Base offset i_hwpe*DM_HWPE_BANK_COL_STRIDE gives this HWPE its own bank column,
          // disjoint from all DMA HWPEs (i_hwpe < N_DMA_HWPE) and other GEMM HWPEs.
          gemm_idx      = i_hwpe - N_DMA_HWPE;
          $info("Configuring HWPE datamover %0d as GEMM (gemm_idx=%0d)", i_hwpe, gemm_idx);
          hwpe_in_base  = DM_HWPE_BASE + i_hwpe * DM_HWPE_BANK_COL_STRIDE;
          hwpe_out_base = hwpe_in_base + DM_HWPE_GEMM_IN_FOOTPRINT;
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_PTR,       hwpe_in_base,                s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_PTR,      hwpe_out_base,               s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_LEN0,         DM_HWPE_GEMM_LEN0,           s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_LEN1,         DM_HWPE_GEMM_LEN1,           s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D0_STRIDE, DM_HWPE_GEMM_IN_D0_STRIDE,  s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D1_STRIDE, DM_HWPE_GEMM_IN_D1_STRIDE,  s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_IN_D2_STRIDE, DM_HWPE_GEMM_IN_D2_STRIDE,  s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D0_STRIDE,DM_HWPE_GEMM_OUT_D0_STRIDE, s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D1_STRIDE,DM_HWPE_GEMM_OUT_D1_STRIDE, s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_OUT_D2_STRIDE,DM_HWPE_GEMM_OUT_D2_STRIDE, s_clk, periph_if);
          periph_write(dm_offset + datamover_package::DATAMOVER_REGISTER_OFFS, datamover_package::DATAMOVER_REG_TRANSP_MODE,  DM_HWPE_GEMM_TRANSP_MODE,   s_clk, periph_if);
        end
      end
      repeat (10) @(posedge s_clk);
    end

    $info("Triggering datamovers");

    if (INTERCO == LOG && N_HWPE * HWPE_WIDTH_FACT > N_BANKS) begin
      // Under LOG interco with bank overflow, simultaneous wide HWPEs alias onto the same
      // banks and deadlock. Serialize HWPEs in bank-safe groups of N_BANKS/HWPE_WIDTH_FACT;
      // cores are narrow and trigger unconditionally alongside the first group.
      $info("LOG bank overflow (%0d HWPEs x %0d banks > %0d): serializing HWPEs in groups of %0d",
            N_HWPE, HWPE_WIDTH_FACT, N_BANKS, N_BANKS / HWPE_WIDTH_FACT);
      for (int i = 0; i < N_CORE; i++) begin
        $info("Triggering datamover %0d", i);
        dm_offset = { i[PERIPH_SEL_WIDTH-1:0], {(32-PERIPH_SEL_WIDTH){1'b0}} };
        periph_write(dm_offset + datamover_package::HWPE_REGISTER_OFFS, datamover_package::DATAMOVER_COMMIT_AND_TRIGGER, 32'h0, s_clk, periph_if);
        @(posedge s_clk);
      end
      for (i_hwpe = 0; i_hwpe < N_HWPE; i_hwpe += N_BANKS / HWPE_WIDTH_FACT) begin
        for (int j = i_hwpe; j < i_hwpe + N_BANKS / HWPE_WIDTH_FACT && j < N_HWPE; j++) begin
          dm_i = N_CORE + j;
          $info("Triggering datamover %0d", dm_i);
          dm_offset = { dm_i[PERIPH_SEL_WIDTH-1:0], {(32-PERIPH_SEL_WIDTH){1'b0}} };
          periph_write(dm_offset + datamover_package::HWPE_REGISTER_OFFS, datamover_package::DATAMOVER_COMMIT_AND_TRIGGER, 32'h0, s_clk, periph_if);
          @(posedge s_clk);
        end
        // Wait for this group before triggering the next (skip on last group — main wait handles it)
        if (i_hwpe + N_BANKS / HWPE_WIDTH_FACT < N_HWPE) begin
          for (int j = i_hwpe; j < i_hwpe + N_BANKS / HWPE_WIDTH_FACT && j < N_HWPE; j++) begin
            dm_i = N_CORE + j;
            dm_offset = { dm_i[PERIPH_SEL_WIDTH-1:0], {(32-PERIPH_SEL_WIDTH){1'b0}} };
            status = '1;
            while (status != 32'h00000000) begin
              repeat(10) @(posedge s_clk);
              periph_read(dm_offset + datamover_package::HWPE_REGISTER_OFFS, datamover_package::DATAMOVER_STATUS, status, s_clk, periph_if);
            end
            dm_done[dm_i] = 1'b1;
            $info("Datamover %0d is done!", dm_i);
          end
        end
      end
    end else begin
      for (int i = 0; i < N_DATAMOVERS; i++) begin
        $info("Triggering datamover %0d", i);
        dm_offset = { i[PERIPH_SEL_WIDTH-1:0], {(32-PERIPH_SEL_WIDTH){1'b0}} };
        periph_write(dm_offset + datamover_package::HWPE_REGISTER_OFFS, datamover_package::DATAMOVER_COMMIT_AND_TRIGGER, 32'h0, s_clk, periph_if);
        @(posedge s_clk);
      end
    end

    $info("Waiting for end of task...");
    while ((& dm_done) != 1) begin
      repeat(10) @(posedge s_clk);
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
    end
    @(posedge s_clk);

    $info("All initiators are done.");

    // if (VCD_ENABLE) begin
    //   $info("VCD dumping done, flushing... ", VCD_FILE);
    //   $dumpflush;
    // end else begin
    //   $info("VCD dumping disabled, skipping flush");
    // end
    repeat(20) @(posedge s_clk);
    $info("Simulation ended");
    $finish();
  end

endmodule
