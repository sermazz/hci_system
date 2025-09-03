// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

package tb_hci_system_pkg;
  /* Tb parameters */

  localparam time CLK_PERIOD = 2ns; // `timeprecision 1ps` will convert this in ps
  localparam int unsigned RST_CYCLES = 10;
  localparam real TbTA = 0.2; // in ns
  localparam real TbTT = CLK_PERIOD/1000 - 0.2; // wait `#` needs ns because of `timeunit 1ns`

  localparam int unsigned PERIPH_SEL_WIDTH = $clog2(hci_system_pkg::MAX_N_DATAMOVERS);

  // Same signals as the interface `hwpe_ctrl_intf_periph` from `hwpe-ctrl`
  // Declared here as a datatype to simplify function declarations
  typedef struct{
    logic                                 req;
    logic                                 gnt;
    logic [31:0]                          add;
    logic                                 wen;
    logic [3:0]                           be;
    logic [31:0]                          data;
    logic [hci_system_pkg::ID_PERIPH-1:0] id;
    logic [31:0]                          r_data;
    logic                                 r_valid;
    logic [hci_system_pkg::ID_PERIPH-1:0] r_id;
  } periph_bus_t;

  task automatic periph_write(
    input  logic [31:0] base_addr,      // Base address
    input  logic [31:0] offset,         // Offset
    input  logic [31:0] data,           // Write data
    ref    logic        clk_i,          // Clock signal
    ref    periph_bus_t periph_bus      // Peripheral bus reference
    );
  // Initialize the peripheral bus for write operation
      @(posedge clk_i);                   // Wait for positive clock edge
      #TbTA;
      periph_bus.req  = 1'b0;
      periph_bus.add  = 32'b0;
      periph_bus.wen  = 1'b1;             // Default state: write enable high
      periph_bus.be   = 4'b0000;          // Default state: no byte enable
      periph_bus.data = 32'b0;
      periph_bus.id   = '0;               // Reset transaction ID


      // Setup phase
      @(posedge clk_i);                   // Wait for positive clock edge
      #TbTA;                                // Application delay
      periph_bus.req  = 1'b1;             // Request signal active
      periph_bus.add  = base_addr + offset; // Set target address
      periph_bus.wen  = 1'b0;             // Enable write operation
      periph_bus.be   = 4'b1111;          // Enable all bytes
      periph_bus.data = data;             // Set write data
      periph_bus.id   = '0;               // Reset transaction ID


      // Wait for grant signal
      if (periph_bus.gnt !== 1) begin
          wait (periph_bus.gnt === 1); // Wait for it to become 1 if not already 1
      end           // Wait until grant is asserted

      // Hold phase
      @(posedge clk_i);                   // Wait for next clock edge
      #TbTA;                                // Application delay
      // Termination phase
      periph_bus.req  = 1'b0;             // Deassert request
      periph_bus.add  = 32'b0;            // Clear address
      periph_bus.wen  = 1'b1;             // Return to default state
      periph_bus.be   = 4'b1111;          // Maintain byte enable

      @(posedge clk_i);                   // Final clock edge for cleanup
  endtask : periph_write

  task automatic periph_read(
      input  logic [31:0] base_addr,      // Base address
      input  logic [31:0] offset,         // Offset
      output logic [31:0] data,           // Output data
      ref    logic        clk_i,          // Clock signal
      ref    periph_bus_t periph_bus      // Peripheral bus reference
  );
      // Initialize the peripheral bus for read operation
      periph_bus.req  = 1'b0;
      periph_bus.add  = 32'b0;
      periph_bus.wen  = 1'b1;             // Default state: not a write operation
      periph_bus.be   = 4'b0000;          // Reset byte enable
      periph_bus.data = 32'b0;            // Data not used for read
      periph_bus.id   = '0;               // Reset transaction ID

      // Setup phase
      @(posedge clk_i);                   // Wait for positive clock edge
      #TbTA;                                // Application delay
      periph_bus.req  = 1'b1;             // Assert request signal
      periph_bus.add  = base_addr + offset; // Set target address
      periph_bus.wen  = 1'b1;             // Enable read operation
      periph_bus.be   = 4'b1111;          // Enable all bytes
      periph_bus.id   = 0;                // Reset transaction ID


      // Wait for grant signal
      if (periph_bus.gnt !== 1) begin
          wait (periph_bus.gnt === 1); // Wait for it to become 1 if not already 1
      end

      // Wait for read data to be valid
      @(posedge clk_i);                   // Wait for next clock edge
      if (periph_bus.r_valid !== 1) begin
          wait (periph_bus.r_valid === 1); // Wait for it to become 1 if not already 1
      end
      data = periph_bus.r_data;           // Capture read data

      // Termination phase
      @(posedge clk_i);                   // Wait for positive clock edge
      periph_bus.req  = 1'b0;             // Deassert request signal
      periph_bus.add  = 32'b0;            // Clear address
      periph_bus.wen  = 1'b1;             // Return to default state
      periph_bus.be   = 4'b1111;          // Maintain byte enable
  endtask : periph_read

endpackage