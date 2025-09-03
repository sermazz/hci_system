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

  // Null interface
  hci_core_intf #(
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

  // CORE and EXT interfaces
  localparam hci_package::hci_size_parameter_t `HCI_SIZE_PARAM(cores) = '{
    DW:  DW_cores,
    AW:  AW_cores,
    BW:  BW_cores,
    UW:  UW_cores,
    IW:  IW_cores,
    EW:  EW_cores,
    EHW: EHW_cores
  };

  hci_core_intf #(
    .DW ( HCI_SIZE_cores.DW ),
    .AW ( HCI_SIZE_cores.AW ),
    .BW ( HCI_SIZE_cores.BW ),
    .UW ( HCI_SIZE_cores.UW ),
    .IW ( HCI_SIZE_cores.IW ),
    .EW ( HCI_SIZE_cores.EW ),
    .EHW ( HCI_SIZE_cores.EHW )
  ) hci_initiator_core [0:N_CORE-1] (
    .clk( clk_i )
  );

  hci_core_intf #(
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

  // MEM interfaces
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

  // HWPE interfaces
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
    .DW ( HCI_SIZE_hwpe.DW ),
    .AW ( HCI_SIZE_hwpe.AW ),
    .BW ( HCI_SIZE_hwpe.BW ),
    .UW ( HCI_SIZE_hwpe.UW ),
    .IW ( HCI_SIZE_hwpe.IW ),
    .EW ( HCI_SIZE_hwpe.EW ),
    .EHW ( HCI_SIZE_hwpe.EHW )
  ) hci_initiator_hwpe [0:N_HWPE-1] (
    .clk( clk_i )
  );

  /////////////////////
  // HCI             //
  /////////////////////

  hci_interconnect_ctrl_t hci_control;
  assign hci_control.arb_policy         = arb_policy_i;
  assign hci_control.invert_prio        = invert_prio_i;
  assign hci_control.low_prio_max_stall = low_prio_max_stall_i;

  hci_interconnect #(
    .N_HWPE ( N_HWPE ),
    .N_CORE ( N_CORE ),
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
    .cores ( hci_initiator_core ),
    .dma ( hci_null_if ),
    .ext ( hci_initiator_ext ),
    .mems ( hci_target_mems ),
    .hwpe ( hci_initiator_hwpe )
  );

  ////////////////////////
  // Peripheral interco //
  ////////////////////////

  hwpe_ctrl_intf_periph #(
    .ID_WIDTH ( ID_PERIPH )
  ) periph_req_if (
    .clk ( clk_i )
  );

  hwpe_ctrl_intf_periph #(
    .ID_WIDTH ( ID_PERIPH )
  ) periph_datamovers_if [0:N_DATAMOVERS-1] (
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
    .initiator ( periph_req_if ),
    .target ( periph_datamovers_if )
  );

  // Bind external periph configuration port to periph_req_if interface
  assign periph_req_if.req  = periph_req_i;
  assign periph_req_if.add  = periph_add_i;
  assign periph_req_if.wen  = periph_wen_i;
  assign periph_req_if.be   = periph_be_i;
  assign periph_req_if.data = periph_data_i;
  assign periph_req_if.id   = periph_id_i;
  assign periph_gnt_o       = periph_req_if.gnt;
  assign periph_r_data_o    = periph_req_if.r_data;
  assign periph_r_valid_o   = periph_req_if.r_valid;
  assign periph_r_id_o      = periph_req_if.r_id;

  ////////////////////////
  // External TCDM port //
  ////////////////////////

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

  generate
    for (genvar ii = 0; ii < N_CORE; ii++) begin: gen_initiators_cores
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
        .tcdm ( hci_initiator_core[ii] ),
        .periph ( periph_datamovers_if[ii] )
      );
    end
  endgenerate

  generate
    for (genvar ii = 0; ii < N_HWPE; ii++) begin: gen_initiators_hwpes
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
        .tcdm ( hci_initiator_hwpe[ii] ),
        .periph ( periph_datamovers_if[N_CORE + ii] )
      );
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
