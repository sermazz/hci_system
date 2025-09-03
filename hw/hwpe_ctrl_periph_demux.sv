// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
// SPDX-License-Identifier: SHL-0.51
//
// Sergio Mazzola <smazzola@iis.ee.ethz.ch>

module hwpe_ctrl_periph_demux #(
  parameter int unsigned N_PORTS = 8,
  // Number of MSBs of the periph address bus to identify target port
  parameter int unsigned IDX_BITS = $clog2(N_PORTS)
)(
  input  logic                 clk_i,
  input  logic                 rst_ni,
  hwpe_ctrl_intf_periph.slave  initiator,
  hwpe_ctrl_intf_periph.master target [0:N_PORTS-1]
);

  /////////////////////////////////////////////
  // Decode target port from MSBs of address //
  /////////////////////////////////////////////

  logic [IDX_BITS-1:0] sel_idx;
  assign sel_idx = initiator.add[31 -: IDX_BITS];

  // Select one-hot: it is 1 only for the port selected by `sel_idx`
  logic [N_PORTS-1:0] sel_oh;
  generate
    for (genvar gi = 0; gi < N_PORTS; gi++) begin : g_dec
      assign sel_oh[gi] = (sel_idx == gi[IDX_BITS-1:0]);
    end
  endgenerate

  ////////////////////////////
  // Drive downstream ports //
  ////////////////////////////

  generate
    for (genvar gi = 0; gi < N_PORTS; gi++) begin : g_targets
      // Drive `req` only for the selected port
      assign target[gi].req  = initiator.req & sel_oh[gi];
      // The other signals can be assigned always
      assign target[gi].add  = initiator.add;
      assign target[gi].wen  = initiator.wen;
      assign target[gi].be   = initiator.be;
      assign target[gi].data = initiator.data;
      assign target[gi].id   = initiator.id;
    end
  endgenerate

  // Grant back to initiator (only from selected target)
  logic [N_PORTS-1:0] gnt_vec;
  generate
    for (genvar gi = 0; gi < N_PORTS; gi++) begin : g_gnt
      assign gnt_vec[gi] = target[gi].gnt & sel_oh[gi];
    end
  endgenerate
  assign initiator.gnt = |gnt_vec;

  ///////////////////////////////////////////////
  // Track active port for returning read data //
  ///////////////////////////////////////////////

  // Capture the selected port on each accepted handshake.
  // That selection is used to mux the reply in the *next* cycle.
  logic [IDX_BITS-1:0] resp_sel_q;

  wire req_accepted = initiator.req & initiator.gnt;

  // Register the selection at the handshake edge
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      resp_sel_q <= '0;
    end else if (req_accepted) begin
      resp_sel_q <= sel_idx;
    end
  end

  ////////////////////////////////////////
  // Mux read response from active port //
  ////////////////////////////////////////

  // Extract widths from interface fields (portable & param-free)
  localparam int DATAW = $bits(initiator.r_data);
  localparam int IDW   = $bits(initiator.r_id);

  // Mirror target[*] response signals into plain arrays
  logic [DATAW-1:0] r_data_arr [N_PORTS];
  logic             r_valid_arr[N_PORTS];
  logic [IDW-1:0]   r_id_arr   [N_PORTS];

  generate
    for (genvar gi = 0; gi < N_PORTS; gi++) begin : g_rsp_arrays
      assign r_data_arr[gi]  = target[gi].r_data;
      assign r_valid_arr[gi] = target[gi].r_valid;
      assign r_id_arr[gi]    = target[gi].r_id;
    end
  endgenerate

  // Now it's a normal array-of-logic mux (this *is* allowed)
  assign initiator.r_data  = r_data_arr[resp_sel_q];
  assign initiator.r_valid = r_valid_arr[resp_sel_q];
  assign initiator.r_id    = r_id_arr[resp_sel_q];

  ////////////////
  // Assertions //
  ////////////////

  `ifndef SYNTHESIS
    initial begin
      check_idx_width: assert (IDX_BITS > 0)
      else begin
        $error("[ASSERT FAILED] [%m] IDX_BITS %0d is not supported by hwpe_ctrl_periph_demux (%s:%0d)", IDX_BITS, `__FILE__, `__LINE__);
      end
    end
  `endif

endmodule
