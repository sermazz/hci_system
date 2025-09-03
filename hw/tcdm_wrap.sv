// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Davide Rossi <davide.rossi@unibo.it>
// Antonio Pullini <pullinia@iis.ee.ethz.ch>
// Igor Loi <igor.loi@unibo.it>
// Francesco Conti <fconti@iis.ee.ethz.ch>
// Luca Codeluppi <lcodelupp@student.ethz.ch>
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

module tcdm_wrap #(
  parameter int unsigned NumBankWords = 256,
  parameter int unsigned NumBanks     = 1,
  parameter int unsigned DataWidth    = 32,
  parameter int unsigned IdWidth      = 1
)(
  input logic          clk_i,
  input logic          rst_ni,
  hci_core_intf.target tcdm_slave [0:NumBanks-1]
);

  for (genvar i = 0; i < NumBanks; i++) begin : gen_banks

    // r_id is same as request id (requirement from OBI)
    logic [IdWidth-1:0] resp_id_d, resp_id_q;
    assign resp_id_d = tcdm_slave[i].id;
    assign tcdm_slave[i].r_id = resp_id_q;

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if(~rst_ni) begin
        resp_id_q <= '0;
      end else begin
        resp_id_q <= resp_id_d;
      end
    end

    // request is always granted
    assign tcdm_slave[i].gnt = 1'b1;

    // bank
    tc_sram #(
      `ifndef SYNTHESIS
      .SimInit ( "ones" ),        // Simulation initialization
      .PrintSimCfg ( 0 ),         // Print configuration
      `endif
      .NumWords ( NumBankWords ), // Number of Words in data array
      .DataWidth ( DataWidth ),   // Data signal width
      .ByteWidth ( 8 ),           // Width of a data byte
      .NumPorts ( 1 ),            // Number of read and write ports
      .Latency ( 1 )              // Latency when the read data is available
    ) i_bank (
      .clk_i ( clk_i ),
      .rst_ni ( rst_ni ),
      .req_i ( tcdm_slave[i].req ),
      .we_i ( ~tcdm_slave[i].wen ),
      .addr_i ( tcdm_slave[i].add[$clog2(NumBankWords)+2-1:2] ),
      .wdata_i ( tcdm_slave[i].data ),
      .be_i ( tcdm_slave[i].be ),
      .rdata_o ( tcdm_slave[i].r_data )
    );

    always_ff @(posedge clk_i or negedge rst_ni) begin : rvalid_gen
      if(~rst_ni) begin
        tcdm_slave[i].r_valid <= 1'b0;
      end else begin
        if(tcdm_slave[i].req && tcdm_slave[i].gnt && tcdm_slave[i].wen) begin
          tcdm_slave[i].r_valid <= 1'b1;
        end else begin
          tcdm_slave[i].r_valid <= 1'b0;
        end
      end
    end

    // assign tcdm_slave[i].r_ready = 1'b1;
  end

endmodule

