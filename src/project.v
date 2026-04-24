/*
 * Copyright (c) 2024 Uri Shaked
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_danielhufnagle_rng(
  input  wire [7:0] ui_in,
  output wire [7:0] uo_out,
  input  wire [7:0] uio_in,
  output wire [7:0] uio_out,
  output wire [7:0] uio_oe,
  input  wire       ena,
  input  wire       clk,
  input  wire       rst_n
);
  reg [7:0] lfsr;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      lfsr <= 8'hF;
    else
      lfsr <= {lfsr[6:0], lfsr[3] ^ lfsr[2]}; // linear feedback shift register
  end
  
  assign uo_out = lfsr[7:0];
  
  // Unused outputs
  assign uio_out = 8'b0;
  assign uio_oe = 8'b0;
endmodule
