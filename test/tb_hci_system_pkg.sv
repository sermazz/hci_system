// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>
// Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

package tb_hci_system_pkg;
  import hci_system_pkg::*;

  ///////////////////
  // Tb parameters //
  ///////////////////

  localparam time CLK_PERIOD = `ifdef CLK_NS `CLK_NS * 1ns `else 5ns `endif; // `timeprecision 1ps` will convert this in ps
  localparam int unsigned RST_CYCLES = 10;
  // CLK_PERIOD is `time` type: in real arithmetic it is in ps (timeprecision unit).
  // Dividing by 1000 converts to ns (timeunit), which is what `#` delays expect.
  localparam real TbTA = CLK_PERIOD/1000 * 0.1; // 10% into period, in ns
  localparam real TbTT = CLK_PERIOD/1000 - TbTA; // 10% before next edge, in ns

  localparam int unsigned PERIPH_SEL_WIDTH = $clog2(MAX_N_DATAMOVERS);

  // VCD dumping
  localparam int unsigned VCD_ENABLE = `ifdef VCD `VCD `else 0 `endif;
  localparam string VCD_FILE = `ifdef VCD_FILE `VCD_FILE `else "dump.vcd" `endif;

  ////////////////////////////
  // Core datamover config  //
  ////////////////////////////
  // Each core scans a private 16-word vector with bank-row stride, then writes
  // results tightly packed: realistic narrow-port traffic across all N_BANKS.

  localparam logic [11:0] dm_core_in_d0_len = 15;  // 16 reads per core
  localparam logic [11:0] dm_core_in_d1_len = 0;
  localparam logic [11:0] dm_core_out_d0_len = 15; // 16 writes per core
  localparam logic [11:0] dm_core_out_d1_len = 0;
  localparam logic [11:0] dm_core_tot_len = 15;
  localparam logic [31:0] DM_CORE_LEN0 = {dm_core_in_d1_len[7:0], dm_core_in_d0_len, dm_core_tot_len};
  localparam logic [31:0] DM_CORE_LEN1 = {dm_core_in_d1_len[11:8], dm_core_out_d1_len, dm_core_out_d0_len};

  // In bytes; actual per-core base addresses computed in tb_hci_system.sv using the offset formula
  //   core_i_in  = DM_CORE_IN_PTR  + N_BANKS*WORD_SIZE*(dm_core_in_d0_len+1)*i
  //   core_i_out = DM_CORE_OUT_PTR + N_BANKS*WORD_SIZE*i
  localparam logic [31:0] DM_CORE_IN_PTR = 0;
  // Place outputs after the input region: last read is at (N_CORE-1)*WORD_SIZE + dm_core_in_d0_len*N_BANKS*WORD_SIZE
  // = 7*4 + 15*128 = 28 + 1920 = 1948 B → round to next TCDM row boundary = 2048 B
  localparam logic [31:0] DM_CORE_OUT_PTR = N_BANKS * WORD_SIZE * (dm_core_in_d0_len + 1);
  localparam logic [31:0] DM_CORE_IN_D0_STRIDE = N_BANKS * WORD_SIZE; // stride through TCDM rows
  localparam logic [31:0] DM_CORE_IN_D1_STRIDE = 0;
  localparam logic [31:0] DM_CORE_IN_D2_STRIDE = 0;
  localparam logic [31:0] DM_CORE_OUT_D0_STRIDE = 1 * WORD_SIZE;      // tight-packed write
  localparam logic [31:0] DM_CORE_OUT_D1_STRIDE = 0;
  localparam logic [31:0] DM_CORE_OUT_D2_STRIDE = 0;
  localparam logic [31:0] DM_CORE_TRANSP_MODE = {29'b0, 3'b000};

  //////////////////////////////////////////////
  // HWPE datamover config — GEMM tile access //
  //////////////////////////////////////////////
  // Models weight-tile read for a GEMM inner loop:
  //   d0: K dimension — (d0_len+1) wide beats across a weight row
  //   d1: M dimension — (d1_len+1) rows of the weight tile
  // Output: 1D write of (out_d0_len+1) partial-sum beats (one per TCDM row).
  //
  // With stride = N_BANKS*WORD_SIZE (one bank-row step):
  //   1 beat = HWPE_WIDTH_FACT words wide, stride = N_BANKS words
  //   d1_stride = (d0_len+1) * N_BANKS * WORD_SIZE (one tile-row stride in bank-rows)
  //   tile: 4 rows × 4 beats → total 16 beats in, 16 beats out

  localparam logic [11:0] dm_hwpe_gemm_in_d0_len  = 3;   // 4 wide beats per tile row
  localparam logic [11:0] dm_hwpe_gemm_in_d1_len  = 3;   // 4 tile rows
  localparam logic [11:0] dm_hwpe_gemm_out_d0_len = 15;  // 16 partial-sum write beats (1D)
  localparam logic [11:0] dm_hwpe_gemm_out_d1_len = 0;
  localparam logic [11:0] dm_hwpe_gemm_tot_len    = 15;  // max(4*4, 16) - 1 = 15
  localparam logic [31:0] DM_HWPE_GEMM_LEN0 = {dm_hwpe_gemm_in_d1_len[7:0], dm_hwpe_gemm_in_d0_len, dm_hwpe_gemm_tot_len};
  localparam logic [31:0] DM_HWPE_GEMM_LEN1 = {dm_hwpe_gemm_in_d1_len[11:8], dm_hwpe_gemm_out_d1_len, dm_hwpe_gemm_out_d0_len};

  // Strides use N_BANKS*WORD_SIZE so every beat maps to the same HWPE_WIDTH_FACT bank columns,
  // keeping each HWPE's accesses permanently bank-disjoint from every other HWPE (LOG interco safe).
  localparam logic [31:0] DM_HWPE_GEMM_IN_D0_STRIDE  = N_BANKS * WORD_SIZE;                               // one bank-row step
  localparam logic [31:0] DM_HWPE_GEMM_IN_D1_STRIDE  = (dm_hwpe_gemm_in_d0_len + 1) * N_BANKS * WORD_SIZE; // next tile row
  localparam logic [31:0] DM_HWPE_GEMM_IN_D2_STRIDE  = 0;
  localparam logic [31:0] DM_HWPE_GEMM_OUT_D0_STRIDE = N_BANKS * WORD_SIZE;  // partial sums to successive TCDM rows
  localparam logic [31:0] DM_HWPE_GEMM_OUT_D1_STRIDE = 0;
  localparam logic [31:0] DM_HWPE_GEMM_OUT_D2_STRIDE = 0;
  localparam logic [31:0] DM_HWPE_GEMM_TRANSP_MODE   = {29'b0, 3'b000};

  // Memory footprint per GEMM HWPE slot (input region + output region)
  // Footprint = number of bank rows consumed × N_BANKS × WORD_SIZE (beat width cancels with stride)
  localparam int unsigned DM_HWPE_GEMM_IN_FOOTPRINT  = (dm_hwpe_gemm_in_d1_len + 1) * (dm_hwpe_gemm_in_d0_len + 1) * N_BANKS * WORD_SIZE;
  localparam int unsigned DM_HWPE_GEMM_OUT_FOOTPRINT = (dm_hwpe_gemm_out_d0_len + 1) * N_BANKS * WORD_SIZE;
  localparam int unsigned DM_HWPE_GEMM_SLOT_SIZE     = DM_HWPE_GEMM_IN_FOOTPRINT + DM_HWPE_GEMM_OUT_FOOTPRINT;

  ////////////////////////////////////////////
  // HWPE datamover config — DMA 1D copy   //
  ////////////////////////////////////////////
  // Models a 1D linear DMA prefetch of a buffer:
  //   (d0_len+1) sequential wide beats, in and out at the same stride.
  // Used by the first N_HWPE/2 HWPEs when N_HWPE >= 2, overlapping with GEMM HWPEs
  // to stress HCI arbitration between prefetch and compute traffic.

  localparam logic [11:0] dm_hwpe_dma_in_d0_len  = 15;  // 16 wide beats
  localparam logic [11:0] dm_hwpe_dma_in_d1_len  = 0;
  localparam logic [11:0] dm_hwpe_dma_out_d0_len = 15;
  localparam logic [11:0] dm_hwpe_dma_out_d1_len = 0;
  localparam logic [11:0] dm_hwpe_dma_tot_len    = 15;
  localparam logic [31:0] DM_HWPE_DMA_LEN0 = {dm_hwpe_dma_in_d1_len[7:0], dm_hwpe_dma_in_d0_len, dm_hwpe_dma_tot_len};
  localparam logic [31:0] DM_HWPE_DMA_LEN1 = {dm_hwpe_dma_in_d1_len[11:8], dm_hwpe_dma_out_d1_len, dm_hwpe_dma_out_d0_len};

  // Strides use N_BANKS*WORD_SIZE (same as GEMM) to keep this HWPE on the same bank column for all beats.
  localparam logic [31:0] DM_HWPE_DMA_IN_D0_STRIDE  = N_BANKS * WORD_SIZE; // one bank-row step per beat
  localparam logic [31:0] DM_HWPE_DMA_IN_D1_STRIDE  = 0;
  localparam logic [31:0] DM_HWPE_DMA_IN_D2_STRIDE  = 0;
  localparam logic [31:0] DM_HWPE_DMA_OUT_D0_STRIDE = N_BANKS * WORD_SIZE;
  localparam logic [31:0] DM_HWPE_DMA_OUT_D1_STRIDE = 0;
  localparam logic [31:0] DM_HWPE_DMA_OUT_D2_STRIDE = 0;
  localparam logic [31:0] DM_HWPE_DMA_TRANSP_MODE   = {29'b0, 3'b000};

  // Memory footprint per DMA HWPE slot (input + output)
  localparam int unsigned DM_HWPE_DMA_IN_FOOTPRINT  = (dm_hwpe_dma_in_d0_len + 1) * N_BANKS * WORD_SIZE;
  localparam int unsigned DM_HWPE_DMA_OUT_FOOTPRINT = (dm_hwpe_dma_out_d0_len + 1) * N_BANKS * WORD_SIZE;
  localparam int unsigned DM_HWPE_DMA_SLOT_SIZE     = DM_HWPE_DMA_IN_FOOTPRINT + DM_HWPE_DMA_OUT_FOOTPRINT;

  ///////////////////////////
  // HWPE address layout   //
  ///////////////////////////
  // HWPEs are split: first N_HWPE/2 are DMA, remaining are GEMM.
  //   N_HWPE=1: 0 DMA + 1 GEMM  → pure weight-tile access
  //   N_HWPE=2: 1 DMA + 1 GEMM  → prefetch + compute overlap
  //   N_HWPE=4: 2 DMA + 2 GEMM  → dual prefetch + dual compute
  //
  // Bank-column assignment (LOG interco requirement):
  //   Each wide HWPE i is assigned a permanent column of HWPE_WIDTH_FACT consecutive banks:
  //     banks { i*HWPE_WIDTH_FACT, ..., (i+1)*HWPE_WIDTH_FACT-1 } mod N_BANKS
  //   This is achieved by setting all strides to N_BANKS*WORD_SIZE (one bank-row step)
  //   and spacing HWPE base addresses by DM_HWPE_BANK_COL_STRIDE = HWPE_WIDTH_FACT*WORD_SIZE.
  //   Requires: N_BANKS >= N_HWPE * HWPE_WIDTH_FACT.
  //
  // Per-HWPE base addresses are computed in tb_hci_system.sv:
  //   Any hwpe i_hwpe (0-indexed):  DM_HWPE_BASE + i_hwpe * DM_HWPE_BANK_COL_STRIDE
  //   out_base = in_base + DM_HWPE_{DMA,GEMM}_IN_FOOTPRINT
  //
  // DM_HWPE_BASE must be aligned to N_BANKS*WORD_SIZE (20 KB = 5120 words; 5120 % N_BANKS == 0
  // for all power-of-two N_BANKS up to 5120).
  // The core region occupies bytes 0..(~16 KB), so 20 KB is a safe HWPE base.
  localparam int unsigned N_DMA_HWPE           = N_HWPE / 2;
  localparam logic [31:0] DM_HWPE_BASE         = 20 * 1024; // 20 KB, aligned to N_BANKS*WORD_SIZE
  localparam int unsigned DM_HWPE_BANK_COL_STRIDE = HWPE_WIDTH_FACT * WORD_SIZE; // byte offset between HWPE bank columns

  /////////////////////
  // Datamover utils //
  /////////////////////

  // Same signals as the interface `hwpe_ctrl_intf_periph` from `hwpe-ctrl`
  // Declared here as a datatype to simplify function declarations
  typedef struct{
    logic                                 req;
    logic                                 gnt;
    logic [31:0]                          add;
    logic                                 wen;
    logic [3:0]                           be;
    logic [31:0]                          data;
    logic [ID_PERIPH-1:0] id;
    logic [31:0]                          r_data;
    logic                                 r_valid;
    logic [ID_PERIPH-1:0] r_id;
  } periph_bus_t;

  task automatic periph_write (
    input  logic [31:0] base_addr, // Base address
    input  logic [31:0] offset,    // Offset
    input  logic [31:0] data,      // Write data
    ref    logic        clk_i,     // Clock signal
    ref    periph_bus_t periph_bus // Peripheral bus reference
  );
    // Initialize the peripheral bus for write operation
    @(posedge clk_i);                     // Wait for positive clock edge
    #TbTA;
    periph_bus.req  = 1'b0;
    periph_bus.add  = 32'b0;
    periph_bus.wen  = 1'b1;               // Default state: write enable high
    periph_bus.be   = 4'b0000;            // Default state: no byte enable
    periph_bus.data = 32'b0;
    periph_bus.id   = '0;                 // Reset transaction ID

    // Setup phase
    @(posedge clk_i);                     // Wait for positive clock edge
    #TbTA;                                // Application delay
    periph_bus.req  = 1'b1;               // Request signal active
    periph_bus.add  = base_addr + offset; // Set target address
    periph_bus.wen  = 1'b0;               // Enable write operation
    periph_bus.be   = 4'b1111;            // Enable all bytes
    periph_bus.data = data;               // Set write data
    periph_bus.id   = '0;                 // Reset transaction ID

    // Wait for grant signal
    if (periph_bus.gnt !== 1) begin
        wait (periph_bus.gnt === 1);      // Wait for it to become 1 if not already 1
    end                                   // Wait until grant is asserted

    // Hold phase
    @(posedge clk_i);                     // Wait for next clock edge
    #TbTA;                                // Application delay
    // Termination phase
    periph_bus.req  = 1'b0;               // Deassert request
    periph_bus.add  = 32'b0;              // Clear address
    periph_bus.wen  = 1'b1;               // Return to default state
    periph_bus.be   = 4'b1111;            // Maintain byte enable

    @(posedge clk_i);                     // Final clock edge for cleanup
  endtask : periph_write

  task automatic periph_read(
    input  logic [31:0] base_addr, // Base address
    input  logic [31:0] offset,    // Offset
    output logic [31:0] data,      // Output data
    ref    logic        clk_i,     // Clock signal
    ref    periph_bus_t periph_bus // Peripheral bus reference
  );
    // Initialize the peripheral bus for read operation
    periph_bus.req  = 1'b0;
    periph_bus.add  = 32'b0;
    periph_bus.wen  = 1'b1;               // Default state: not a write operation
    periph_bus.be   = 4'b0000;            // Reset byte enable
    periph_bus.data = 32'b0;              // Data not used for read
    periph_bus.id   = '0;                 // Reset transaction ID

    // Setup phase
    @(posedge clk_i);                     // Wait for positive clock edge
    #TbTA;                                // Application delay
    periph_bus.req  = 1'b1;               // Assert request signal
    periph_bus.add  = base_addr + offset; // Set target address
    periph_bus.wen  = 1'b1;               // Enable read operation
    periph_bus.be   = 4'b1111;            // Enable all bytes
    periph_bus.id   = 0;                  // Reset transaction ID

    // Wait for grant signal
    if (periph_bus.gnt !== 1) begin
        wait (periph_bus.gnt === 1);      // Wait for it to become 1 if not already 1
    end

    // Wait for read data to be valid
    @(posedge clk_i);                     // Wait for next clock edge
    if (periph_bus.r_valid !== 1) begin
        wait (periph_bus.r_valid === 1);  // Wait for it to become 1 if not already 1
    end
    data = periph_bus.r_data;             // Capture read data

    // Termination phase
    @(posedge clk_i);                     // Wait for positive clock edge
    periph_bus.req  = 1'b0;               // Deassert request signal
    periph_bus.add  = 32'b0;              // Clear address
    periph_bus.wen  = 1'b1;               // Return to default state
    periph_bus.be   = 4'b1111;            // Maintain byte enable
  endtask : periph_read
endpackage
