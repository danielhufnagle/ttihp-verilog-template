/*
 * Copyright (c) 2024 Uri Shaked
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_danielhufnagle_rng(
  input  wire       ena,      // always 1 when the design is powered, so you can ignore it
  input  wire       clk,      // clock
  input  wire       rst_n,     // reset_n - low to reset
  output reg [15:0] out       // output
);
  always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= 16'hF;
        else
            out <= {out[14:0], out[3] ^ out[2]}; // linear feedback shift register
    end
endmodule
