// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>
// Luca Codeluppi <lcodelupp@student.ethz.ch>

`include "hci_helpers.svh"

module hci_system
  import hci_package::*;
  import hci_system_pkg::*;
#(
  // Enable/disable assertion
  parameter bit WAIVE_RQ3_ASSERT  = 1'b1,
  parameter bit WAIVE_RQ4_ASSERT  = 1'b1,
  parameter bit WAIVE_RSP3_ASSERT = 1'b1,
  parameter bit WAIVE_RSP5_ASSERT = 1'b1
) (
  input logic                          clk_i,
  input logic                          rst_ni,
  input logic                          clear_i,
  // HCI control signals
  input logic [1:0]                    arb_policy_i,
  input logic                          invert_prio_i,
  input logic [7:0]                    low_prio_max_stall_i,
  // Peripheral interconnect interface for programming
  input  logic                         periph_req_i,
  output logic                         periph_gnt_o,
  input  logic [31:0]                  periph_add_i,
  input  logic                         periph_wen_i,
  input  logic [3:0]                   periph_be_i,
  input  logic [31:0]                  periph_data_i,
  input  logic [ID_PERIPH-1:0]         periph_id_i,
  output logic [31:0]                  periph_r_data_o,
  output logic                         periph_r_valid_o,
  output logic [ID_PERIPH-1:0]         periph_r_id_o,
  // External HCI port
  input  logic                         ext_tcdm_req_i,
  output logic                         ext_tcdm_gnt_o,
  input  logic [AW_cores-1:0]          ext_tcdm_add_i,
  input  logic                         ext_tcdm_wen_i,
  input  logic [DW_cores-1:0]          ext_tcdm_data_i,
  input  logic [DW_cores/BW_cores-1:0] ext_tcdm_be_i,
  output logic [DW_cores-1:0]          ext_tcdm_r_data_o,
  output logic                         ext_tcdm_r_valid_o,
  input  logic                         ext_tcdm_r_ready_i
);

  ////////////////
  // Interfaces //
  ////////////////

  /* Null interface (used for absent DMA) */

  hci_core_intf #(
  `ifndef TARGET_SYNTHESIS
    .WAIVE_RQ3_ASSERT ( WAIVE_RQ3_ASSERT ),
    .WAIVE_RQ4_ASSERT ( WAIVE_RQ4_ASSERT ),
    .WAIVE_RSP3_ASSERT ( WAIVE_RSP3_ASSERT ),
    .WAIVE_RSP5_ASSERT ( WAIVE_RSP5_ASSERT ),
  `endif
    .DW ( 1 ),
    .AW ( 1 ),
    .BW ( 1 ),
    .UW ( 1 ),
    .IW ( 1 ),
    .EW ( 1 ),
    .EHW ( 1 )
  ) hci_null_if [0:-1] (
    .clk( clk_i )
  );

  /* Narrow HCI interfaces (cores, EXT + HWPE when !USE_HCI) */

  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(cores) = '{
    DW:  DW_cores,
    AW:  AW_cores,
    BW:  BW_cores,
    UW:  UW_cores,
    IW:  IW_cores,
    EW:  EW_cores,
    EHW: EHW_cores
  };

  // The number of narrow ports for cores is N_CORE when HCI is used (HWPEs use dedicated wide ports)
  // When fully log interco is used, instantiate additional HWPE_WIDTH_FACT ports for each HWPE
  hci_core_intf #(
  `ifndef TARGET_SYNTHESIS
    .WAIVE_RQ3_ASSERT ( WAIVE_RQ3_ASSERT ),
    .WAIVE_RQ4_ASSERT ( WAIVE_RQ4_ASSERT ),
    .WAIVE_RSP3_ASSERT ( WAIVE_RSP3_ASSERT ),
    .WAIVE_RSP5_ASSERT ( WAIVE_RSP5_ASSERT ),
  `endif
    .DW ( HCI_SIZE_cores.DW ),
    .AW ( HCI_SIZE_cores.AW ),
    .BW ( HCI_SIZE_cores.BW ),
    .UW ( HCI_SIZE_cores.UW ),
    .IW ( HCI_SIZE_cores.IW ),
    .EW ( HCI_SIZE_cores.EW ),
    .EHW ( HCI_SIZE_cores.EHW )
  ) hci_initiator_narrow [0:N_NARROW_HCI-1] (
    .clk( clk_i )
  );

  hci_core_intf #(
  `ifndef TARGET_SYNTHESIS
    .WAIVE_RQ3_ASSERT ( WAIVE_RQ3_ASSERT ),
    .WAIVE_RQ4_ASSERT ( WAIVE_RQ4_ASSERT ),
    .WAIVE_RSP3_ASSERT ( WAIVE_RSP3_ASSERT ),
    .WAIVE_RSP5_ASSERT ( WAIVE_RSP5_ASSERT ),
  `endif
    .DW ( HCI_SIZE_cores.DW ),
    .AW ( HCI_SIZE_cores.AW ),
    .BW ( HCI_SIZE_cores.BW ),
    .UW ( HCI_SIZE_cores.UW ),
    .IW ( HCI_SIZE_cores.IW ),
    .EW ( HCI_SIZE_cores.EW ),
    .EHW ( HCI_SIZE_cores.EHW )
  ) hci_initiator_ext [0:N_EXT-1] (
    .clk( clk_i )
  );

  /* Wide interfaces for HWPE (when USE_HCI) */

  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(hwpe) = '{
    DW:  DW_hwpe,
    AW:  AW_hwpe,
    BW:  BW_hwpe,
    UW:  UW_hwpe,
    IW:  IW_hwpe,
    EW:  EW_hwpe,
    EHW: EHW_hwpe
  };

  hci_core_intf #(
  `ifndef TARGET_SYNTHESIS
    .WAIVE_RQ3_ASSERT ( WAIVE_RQ3_ASSERT ),
    .WAIVE_RQ4_ASSERT ( WAIVE_RQ4_ASSERT ),
    .WAIVE_RSP3_ASSERT ( WAIVE_RSP3_ASSERT ),
    .WAIVE_RSP5_ASSERT ( WAIVE_RSP5_ASSERT ),
  `endif
    .DW ( HCI_SIZE_hwpe.DW ),
    .AW ( HCI_SIZE_hwpe.AW ),
    .BW ( HCI_SIZE_hwpe.BW ),
    .UW ( HCI_SIZE_hwpe.UW ),
    .IW ( HCI_SIZE_hwpe.IW ),
    .EW ( HCI_SIZE_hwpe.EW ),
    .EHW ( HCI_SIZE_hwpe.EHW )
  ) hci_initiator_wide [0:N_WIDE_HCI-1] (
    .clk( clk_i )
  );

  /* Target interface for TCDM banks */

  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(mems) = '{
    DW:  DW_mems,
    AW:  AW_mems,
    BW:  BW_mems,
    UW:  UW_mems,
    IW:  IW_mems,
    EW:  EW_mems,
    EHW: EHW_mems
  };

  hci_core_intf #(
  `ifndef TARGET_SYNTHESIS
    .WAIVE_RQ3_ASSERT ( WAIVE_RQ3_ASSERT ),
    .WAIVE_RQ4_ASSERT ( WAIVE_RQ4_ASSERT ),
    .WAIVE_RSP3_ASSERT ( WAIVE_RSP3_ASSERT ),
    .WAIVE_RSP5_ASSERT ( WAIVE_RSP5_ASSERT ),
  `endif
    .DW ( HCI_SIZE_mems.DW ),
    .AW ( HCI_SIZE_mems.AW ),
    .BW ( HCI_SIZE_mems.BW ),
    .UW ( HCI_SIZE_mems.UW ),
    .IW ( HCI_SIZE_mems.IW ),
    .EW ( HCI_SIZE_mems.EW ),
    .EHW ( HCI_SIZE_mems.EHW )
  ) hci_target_mems [0:N_BANKS-1] (
    .clk( clk_i )
  );

  /////////
  // HCI //
  /////////

  hci_interconnect_ctrl_t hci_control;
  assign hci_control.arb_policy         = arb_policy_i;
  assign hci_control.invert_prio        = invert_prio_i;
  assign hci_control.low_prio_max_stall = low_prio_max_stall_i;

  hci_interconnect #(
    .N_HWPE ( N_WIDE_HCI ),
    .N_CORE ( N_NARROW_HCI ),
    .N_DMA ( N_DMA ),
    .N_EXT ( N_EXT ),
    .N_MEM ( N_BANKS ),
    .TS_BIT ( TS_BIT ),
    .IW ( IW ),
    .EXPFIFO ( EXPFIFO ),
    .SEL_LIC ( SEL_LIC ),
    .FILTER_WRITE_R_VALID ( FILTER_WRITE_R_VALID ),
  `ifndef TARGET_SYNTHESIS
    .WAIVE_RQ3_ASSERT ( WAIVE_RQ3_ASSERT ),
    .WAIVE_RQ4_ASSERT ( WAIVE_RQ4_ASSERT ),
    .WAIVE_RSP3_ASSERT ( WAIVE_RSP3_ASSERT ),
    .WAIVE_RSP5_ASSERT ( WAIVE_RSP5_ASSERT ),
  `endif
    .`HCI_SIZE_PARAM(cores) ( `HCI_SIZE_PARAM(cores) ),
    .`HCI_SIZE_PARAM(mems) ( `HCI_SIZE_PARAM(mems) ),
    .`HCI_SIZE_PARAM(hwpe) ( `HCI_SIZE_PARAM(hwpe) )
  ) i_hci_interconnect (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .clear_i ( clear_i ),
    .ctrl_i ( hci_control ),
    .cores ( hci_initiator_narrow ),
    .dma ( hci_null_if ),
    .ext ( hci_initiator_ext ),
    .mems ( hci_target_mems ),
    .hwpe ( hci_initiator_wide )
  );

  ////////////////////////
  // Peripheral interco //
  ////////////////////////

  /* Bindings from ext periph signals initiator to interface */

  hwpe_ctrl_intf_periph #(
    .ID_WIDTH ( ID_PERIPH )
  ) periph_initiator_ext (
    .clk ( clk_i )
  );

  assign periph_initiator_ext.req  = periph_req_i;
  assign periph_initiator_ext.add  = periph_add_i;
  assign periph_initiator_ext.wen  = periph_wen_i;
  assign periph_initiator_ext.be   = periph_be_i;
  assign periph_initiator_ext.data = periph_data_i;
  assign periph_initiator_ext.id   = periph_id_i;
  assign periph_gnt_o              = periph_initiator_ext.gnt;
  assign periph_r_data_o           = periph_initiator_ext.r_data;
  assign periph_r_valid_o          = periph_initiator_ext.r_valid;
  assign periph_r_id_o             = periph_initiator_ext.r_id;

  /* Demux ext periph initiator to the N_DATAMOVERS periph slaves */

  hwpe_ctrl_intf_periph #(
    .ID_WIDTH ( ID_PERIPH )
  ) periph_target_datamovers [0:N_DATAMOVERS-1] (
    .clk ( clk_i )
  );

  // HWPE Datamover uses at most 9 bits for addressing configuration registers
  // Here, in the periph demux we use a static number of address MSBs to select the master to configure
  // The number of employed MSBs is clog2(MAX_N_DATAMOVERS). In this configuration, 8 bits are used.

  hwpe_ctrl_periph_demux #(
    .N_PORTS ( N_DATAMOVERS ),
    .IDX_BITS ( $clog2(MAX_N_DATAMOVERS) )
  ) i_periph_demux (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .initiator ( periph_initiator_ext ),
    .target ( periph_target_datamovers )
  );

  ////////////////////////
  // External TCDM port //
  ////////////////////////

  // Bind ext TCDM port signals to HCI EXT initiator interface
  assign hci_initiator_ext[0].req = ext_tcdm_req_i;
  assign ext_tcdm_gnt_o = hci_initiator_ext[0].gnt;
  assign hci_initiator_ext[0].add = ext_tcdm_add_i;
  assign hci_initiator_ext[0].wen = ext_tcdm_wen_i;
  assign hci_initiator_ext[0].data = ext_tcdm_data_i;
  assign hci_initiator_ext[0].be = ext_tcdm_be_i;
  assign hci_initiator_ext[0].r_ready = ext_tcdm_r_ready_i;
  assign ext_tcdm_r_data_o = hci_initiator_ext[0].r_data;
  assign ext_tcdm_r_valid_o = hci_initiator_ext[0].r_valid;

  /* Unused inputs */
  assign hci_initiator_ext[0].user = '0;
  assign hci_initiator_ext[0].id = '0;
  assign hci_initiator_ext[0].ecc = '0;
  assign hci_initiator_ext[0].ereq = '0;
  assign hci_initiator_ext[0].r_eready = '0;
  /* Unconnected outputs */
  //  hci_initiator_ext[0].r_user;
  //  hci_initiator_ext[0].r_id;
  //  hci_initiator_ext[0].r_opc;
  //  hci_initiator_ext[0].r_ecc;
  //  hci_initiator_ext[0].egnt;
  //  hci_initiator_ext[0].r_evalid;

  ////////////////
  // Datamovers //
  ////////////////

  /* HWPE Datamovers for narrow cores */

  hci_core_intf #(
  `ifndef TARGET_SYNTHESIS
    .WAIVE_RQ3_ASSERT ( WAIVE_RQ3_ASSERT ),
    .WAIVE_RQ4_ASSERT ( WAIVE_RQ4_ASSERT ),
    .WAIVE_RSP3_ASSERT ( WAIVE_RSP3_ASSERT ),
    .WAIVE_RSP5_ASSERT ( WAIVE_RSP5_ASSERT ),
  `endif
    .DW ( HCI_SIZE_cores.DW ),
    .AW ( HCI_SIZE_cores.AW ),
    .BW ( HCI_SIZE_cores.BW ),
    .UW ( HCI_SIZE_cores.UW ),
    .IW ( HCI_SIZE_cores.IW ),
    .EW ( HCI_SIZE_cores.EW ),
    .EHW ( HCI_SIZE_cores.EHW )
  ) hci_core_if [0:N_CORE-1] (
    .clk( clk_i )
  );

  generate
    for (genvar ii = 0; ii < N_CORE; ii++) begin: gen_dm_cores
      datamover_top #(
        .ID ( ID_PERIPH ),
        .BW ( DW_cores ),
        .N_CORES ( 1 ),
        .N_CONTEXT ( 2 ),
        .MISALIGNED_ACCESSES ( 0 ),
        .`HCI_SIZE_PARAM(tcdm) ( `HCI_SIZE_PARAM(cores) )
      ) i_dm_narrow (
        .clk_i ( clk_i ),
        .rst_ni ( rst_ni ),
        .test_mode_i ( 1'b0 ),
        .evt_o ( /* Unconneccted */ ),
        // TCDM interface, to bind to HCI interface
        .tcdm ( hci_core_if[ii] ),
        .periph ( periph_target_datamovers[ii] )
      );

      // Narrow interface assignment to hci_initiator_narrow until N_CORE-1
      hci_core_assign i_hci_core_assign (
        .tcdm_target ( hci_core_if[ii] ),
        .tcdm_initiator ( hci_initiator_narrow[ii] )
      );
    end
  endgenerate

  /* HWPE Datamovers for wide HWPE */

  hci_core_intf #(
  `ifndef TARGET_SYNTHESIS
    .WAIVE_RQ3_ASSERT ( WAIVE_RQ3_ASSERT ),
    .WAIVE_RQ4_ASSERT ( WAIVE_RQ4_ASSERT ),
    .WAIVE_RSP3_ASSERT ( WAIVE_RSP3_ASSERT ),
    .WAIVE_RSP5_ASSERT ( WAIVE_RSP5_ASSERT ),
  `endif
    .DW ( HCI_SIZE_hwpe.DW ),
    .AW ( HCI_SIZE_hwpe.AW ),
    .BW ( HCI_SIZE_hwpe.BW ),
    .UW ( HCI_SIZE_hwpe.UW ),
    .IW ( HCI_SIZE_hwpe.IW ),
    .EW ( HCI_SIZE_hwpe.EW ),
    .EHW ( HCI_SIZE_hwpe.EHW )
  ) hci_hwpe_if [0:N_HWPE-1] (
    .clk( clk_i )
  );

  generate
    for (genvar ii = 0; ii < N_HWPE; ii++) begin: gen_dm_hwpes
      datamover_top #(
        .ID ( ID_PERIPH ),
        .BW ( DW_hwpe ),
        .N_CORES ( 1 ),
        .N_CONTEXT ( 2 ),
        .MISALIGNED_ACCESSES ( 0 ),
        .`HCI_SIZE_PARAM(tcdm) ( `HCI_SIZE_PARAM(hwpe) )
      ) i_dm_wide (
        .clk_i ( clk_i ),
        .rst_ni ( rst_ni ),
        .test_mode_i ( 1'b0 ),
        .evt_o ( /* Unconneccted */ ),
        // TCDM interface, to bind to HCI interface
        .tcdm ( hci_hwpe_if[ii] ),
        .periph ( periph_target_datamovers[N_CORE + ii] )
      );

      /* If HCI is used, just forward HWPE port to wide HCI port */
      if (USE_HCI) begin
        hci_core_assign i_hci_hwpe_assign (
          .tcdm_target ( hci_hwpe_if[ii] ),
          .tcdm_initiator ( hci_initiator_wide[ii] )
        );
      /* If fully log interco is used, split the wide HWPE port over multiple narrow HCI ports */
      end else begin
        // Route the wide ports of the datamovers to each additional set of HWPE_WIDTH_FACT narrow core ports
        for (genvar f = 0; f < HWPE_WIDTH_FACT; f++) begin
          localparam int IDX = N_CORE + ii*HWPE_WIDTH_FACT + f;

          assign hci_initiator_narrow[IDX].req = hci_hwpe_if[ii].req;
          assign hci_initiator_narrow[IDX].add = hci_hwpe_if[ii].add + f*WORD_SIZE;
          assign hci_initiator_narrow[IDX].wen = hci_hwpe_if[ii].wen;
          assign hci_initiator_narrow[IDX].data = hci_hwpe_if[ii].data[(f+1)*WORD_SIZE*8-1:f*WORD_SIZE*8];
          assign hci_initiator_narrow[IDX].be = hci_hwpe_if[ii].be[(f+1)*WORD_SIZE-1:f*WORD_SIZE];
          assign hci_initiator_narrow[IDX].r_ready = hci_hwpe_if[ii].r_ready;
          assign hci_initiator_narrow[IDX].user = hci_hwpe_if[ii].user;
          assign hci_initiator_narrow[IDX].id = hci_hwpe_if[ii].id;
          assign hci_hwpe_if[ii].r_data[(f+1)*WORD_SIZE*8-1:f*WORD_SIZE*8] = hci_initiator_narrow[IDX].r_data;
          assign hci_initiator_narrow[IDX].ecc = hci_hwpe_if[ii].ecc;
          assign hci_initiator_narrow[IDX].ereq = hci_hwpe_if[ii].ereq;
          assign hci_initiator_narrow[IDX].r_eready = hci_hwpe_if[ii].r_eready;
        end

        // Take only the first element of the wide port
        assign hci_hwpe_if[ii].r_user = hci_initiator_narrow[N_CORE + ii*HWPE_WIDTH_FACT].r_user;
        assign hci_hwpe_if[ii].r_id = hci_initiator_narrow[N_CORE + ii*HWPE_WIDTH_FACT].r_id;
        assign hci_hwpe_if[ii].r_opc = hci_initiator_narrow[N_CORE + ii*HWPE_WIDTH_FACT].r_opc;
        assign hci_hwpe_if[ii].r_ecc = hci_initiator_narrow[N_CORE + ii*HWPE_WIDTH_FACT].r_ecc;

        // Reduction AND for gnt and valid signals coming back from TCDM through multiple narrow ports
        logic [HWPE_WIDTH_FACT-1:0] gnt_vec, rvalid_vec, egnt_vec, revalid_vec;

        for (genvar f = 0; f < HWPE_WIDTH_FACT; f++) begin
          localparam int IDX = N_CORE + ii*HWPE_WIDTH_FACT + f;
          assign gnt_vec[f] = hci_initiator_narrow[IDX].gnt;
          assign rvalid_vec[f] = hci_initiator_narrow[IDX].r_valid;
          assign egnt_vec[f] = hci_initiator_narrow[IDX].egnt;
          assign revalid_vec[f] = hci_initiator_narrow[IDX].r_evalid;
        end

        assign hci_hwpe_if[ii].gnt      = &gnt_vec;
        assign hci_hwpe_if[ii].r_valid  = &rvalid_vec;
        assign hci_hwpe_if[ii].egnt     = &egnt_vec;
        assign hci_hwpe_if[ii].r_evalid = &revalid_vec;
      end
    end
  endgenerate

  /////////////////////
  // Memory banks    //
  /////////////////////

  localparam int unsigned N_WORDS = BANK_SIZE / (DW_mems / BW_mems);

  tcdm_wrap #(
    .NumBankWords ( N_WORDS ),
    .NumBanks ( N_BANKS ),
    .DataWidth ( DW_mems ),
    .IdWidth ( IW )
  ) i_tcdm (
    .clk_i ( clk_i ),
    .rst_ni ( rst_ni ),
    .tcdm_slave ( hci_target_mems )
  );

  ////////////////
  // Assertions //
  ////////////////

  `ifndef SYNTHESIS
    initial begin
      check_n_datamovers: assert (N_DATAMOVERS <= MAX_N_DATAMOVERS)
      else begin
        $error("[ASSERT FAILED] [%m] N_DATAMOVERS %0d must be at most %0d (%s:%0d)", N_DATAMOVERS, MAX_N_DATAMOVERS, `__FILE__, `__LINE__);
      end
    end
  `endif

endmodule
