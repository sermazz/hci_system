// Copyright 2025 ETH Zurich and University of Bologna.
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

  localparam time CLK_PERIOD = 2ns; // `timeprecision 1ps` will convert this in ps
  localparam int unsigned RST_CYCLES = 10;
  localparam real TbTA = 0.2; // in ns
  localparam real TbTT = CLK_PERIOD/1000 - 0.2; // wait `#` needs ns because of `timeunit 1ns`

  localparam int unsigned PERIPH_SEL_WIDTH = $clog2(MAX_N_DATAMOVERS);

  //////////////////////
  // Datamover config //
  //////////////////////

  // Number of accesses over each dimension (pure number)
  localparam logic [11:0] dm_core_in_d0_len = 15;
  localparam logic [11:0] dm_core_in_d1_len = 0;
  localparam logic [11:0] dm_core_out_d0_len = 15;
  localparam logic [11:0] dm_core_out_d1_len = 0;
  localparam logic [11:0] dm_core_tot_len = 15;
  localparam logic [31:0] DM_CORE_LEN0 = {dm_core_in_d1_len[7:0], dm_core_in_d0_len, dm_core_tot_len}; // length register 0
  localparam logic [31:0] DM_CORE_LEN1 = {dm_core_in_d1_len[11:8], dm_core_out_d1_len, dm_core_out_d0_len}; // length register 1

  // In bytes
  //NOTE: Actual base addresses computed directly in `tb_hci_system.sv`
  localparam logic [31:0] DM_CORE_IN_PTR = 0; // input base address
  localparam logic [31:0] DM_CORE_OUT_PTR = 1 * WORD_SIZE; // output base address
  localparam logic [31:0] DM_CORE_IN_D0_STRIDE = (N_BANKS) * WORD_SIZE; // dim 0 read stride
  localparam logic [31:0] DM_CORE_IN_D1_STRIDE = 0; // dim 1 read stride
  localparam logic [31:0] DM_CORE_IN_D2_STRIDE = 0; // dim 2 read stride
  localparam logic [31:0] DM_CORE_OUT_D0_STRIDE = 1 * WORD_SIZE; // dim 0 write stride
  localparam logic [31:0] DM_CORE_OUT_D1_STRIDE = 0; // dim 1 write stride
  localparam logic [31:0] DM_CORE_OUT_D2_STRIDE = 0; // dim 2 write stride
  localparam logic [31:0] DM_CORE_TRANSP_MODE = {29'b0, 3'b000}; // transpose mode (i.e., element width)

  // Number of accesses over each dimension (pure number)
  localparam logic [11:0] dm_hwpe_in_d0_len = 2;
  localparam logic [11:0] dm_hwpe_in_d1_len = 0;
  localparam logic [11:0] dm_hwpe_out_d0_len = 2;
  localparam logic [11:0] dm_hwpe_out_d1_len = 0;
  localparam logic [11:0] dm_hwpe_tot_len = 2;
  localparam logic [31:0] DM_HWPE_LEN0 = {dm_hwpe_in_d1_len[7:0], dm_hwpe_in_d0_len, dm_hwpe_tot_len}; // length register 0
  localparam logic [31:0] DM_HWPE_LEN1 = {dm_hwpe_in_d1_len[11:8], dm_hwpe_out_d1_len, dm_hwpe_out_d0_len}; // length register 1

  // In bytes
  //NOTE: Actual base addresses computed directly in `tb_hci_system.sv`
  localparam logic [31:0] DM_HWPE_IN_PTR = N_BANKS * 20 * WORD_SIZE; // input base address
  localparam logic [31:0] DM_HWPE_OUT_PTR = N_BANKS * 20 * WORD_SIZE + HWPE_WIDTH_FACT * WORD_SIZE; // output base address
  localparam logic [31:0] DM_HWPE_IN_D0_STRIDE = (N_BANKS) * WORD_SIZE; // dim 0 read stride
  localparam logic [31:0] DM_HWPE_IN_D1_STRIDE = 0; // dim 1 read stride
  localparam logic [31:0] DM_HWPE_IN_D2_STRIDE = 0; // dim 2 read stride
  localparam logic [31:0] DM_HWPE_OUT_D0_STRIDE = (N_BANKS) * WORD_SIZE; // dim 0 write stride
  localparam logic [31:0] DM_HWPE_OUT_D1_STRIDE = 0; // dim 1 write stride
  localparam logic [31:0] DM_HWPE_OUT_D2_STRIDE = 0; // dim 2 write stride
  localparam logic [31:0] DM_HWPE_TRANSP_MODE = {29'b0, 3'b000}; // transpose mode (i.e., element width)

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