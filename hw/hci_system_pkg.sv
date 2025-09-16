// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>


package hci_system_pkg;

  /////////////////////////////
  // Configurable parameters //
  /////////////////////////////
  // (see config.mk)

  // Number of initiators
  localparam int unsigned N_HWPE = `ifdef N_HWPE `N_HWPE `else 1 `endif;                             // Number of HWPE ports
  localparam int unsigned N_CORE =  `ifdef N_CORE `N_CORE `else 8 `endif;                            // Number of Core ports
  // Parameters for HWPE initiators
  localparam int unsigned HWPE_WIDTH_FACT =  `ifdef HWPE_WIDTH_FACT `HWPE_WIDTH_FACT `else 4 `endif; // Bitwidth of an HWPE as multiple of core's bitwidth
  // Parameters for Memory bank slaves
  localparam int unsigned N_BANKS   =  `ifdef N_BANKS `N_BANKS `else 16 `endif;                      // Number of Memory banks
  localparam int unsigned BANK_SIZE =  `ifdef BANK_SIZE `BANK_SIZE `else 2048 `endif;                // Bank size in bytes
  // Interconnect parameters
  localparam int unsigned SEL_LIC =  `ifdef SEL_LIC `SEL_LIC `else 0 `endif;                         // Log interconnect type selector
  localparam string       INTERCO =  `ifdef INTERCO `INTERCO `else "log" `endif;                     // Use fully log, static mux for HWPEs, or full HCI

  //////////////////////////
  // Hardcoded parameters //
  //////////////////////////

  localparam int unsigned N_DMA = 0;                                        // No DMA ports supported here
  localparam int unsigned N_EXT = 1;                                        // Only 1 external port to fill up TCDM
  localparam int unsigned ID_PERIPH = 2;                                    // Width of periph_id signal to detect master (we should only have 1)
  localparam int unsigned MAX_N_DATAMOVERS = 32;                            // Max number of Datamover HWPEs

  localparam int unsigned TS_BIT = 21;                                      // TEST_SET_BIT (for Log Interconnect)
  localparam int unsigned EXPFIFO = 0;                                      // FIFO Depth for HWPE Interconnect

  localparam int unsigned WORD_SIZE = 4; // in bytes

  // hardcoded because it's a interface bitwidth (it's a bit more than necessary, MAX_N_DATAMOVERS contains also N_CORES)
  localparam int unsigned HWPE_SEL_WIDTH = $clog2(MAX_N_DATAMOVERS);

  //////////////////////////
  // Dependent parameters //
  //////////////////////////

  // If fully log interco is used, instantiate additional HWPE_WIDTH_FACT narrow core ports for each HWPE
  localparam int unsigned N_NARROW_HCI = N_CORE + (N_HWPE * HWPE_WIDTH_FACT) * (INTERCO == "log");
  // If HCI is used, instantiate one dedicated wide port for each HWPE
  localparam int unsigned N_WIDE_HCI = INTERCO == "hci" ? N_HWPE : (INTERCO == "smux" ? 1 : 0);

  // In this system we use datamovers as cores and HWPE
  localparam int unsigned N_DATAMOVERS = N_CORE + N_HWPE;

  localparam int unsigned IW = N_NARROW_HCI + N_WIDE_HCI + N_DMA + N_EXT;       // One-hot slave ID width
  localparam int unsigned FILTER_WRITE_R_VALID[0:N_WIDE_HCI-1] = '{default: 0}; // Enable filtering of only r_valid respons
  localparam int unsigned TCDM_SIZE = N_BANKS * BANK_SIZE;                      // Total TCDM size in bytes

  ///////////////
  // Bitwidths //
  ///////////////

  // Cores bitwidths (default values from `hci_package`)
  localparam int unsigned DW_cores  = 32;                                   // Data bus width
  localparam int unsigned AW_cores  = 32;                                   // Address bus width
  localparam int unsigned BW_cores  = 8;                                    // Width of a "byte" in bits
  localparam int unsigned UW_cores  = 1;                                    // User field width
  localparam int unsigned IW_cores  = 8;                                    // ID width
  localparam int unsigned EW_cores  = 1;                                    // ECC field width
  localparam int unsigned EHW_cores = 1;                                    // ECC handshake width
  // HWPE bitwidths
  localparam int unsigned DW_hwpe  = DW_cores * HWPE_WIDTH_FACT;
  localparam int unsigned AW_hwpe  = AW_cores;
  localparam int unsigned BW_hwpe  = BW_cores;
  localparam int unsigned UW_hwpe  = UW_cores;
  localparam int unsigned IW_hwpe  = IW_cores;
  localparam int unsigned EW_hwpe  = EW_cores;
  localparam int unsigned EHW_hwpe = EHW_cores;
  // Memory bank bitwidths
  localparam int unsigned DW_mems  = DW_cores;
  localparam int unsigned AW_mems  = $clog2(BANK_SIZE);
  localparam int unsigned BW_mems  = BW_cores;
  localparam int unsigned UW_mems  = UW_cores;
  localparam int unsigned IW_mems  = IW;
  localparam int unsigned EW_mems  = EW_cores;
  localparam int unsigned EHW_mems = EHW_cores;

endpackage
