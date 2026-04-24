/*
 * Copyright (c) 2024 Uri Shaked
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_danielhufnagle_rng(
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
  output wire [7:0] uio_out,  // IOs: Bidirectional Output path
  output wire [7:0] uio_oe,   // IOs: Bidirectional Output enable (active high)
  input  wire       ena,      // always 1 when the design is powered, so you can ignore it
  input  wire       clk,      // clock
  input  wire       rst_n     // reset_n - low to reset
);
  reg [15:0] lfsr;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      lfsr <= 16'hF;
    else
      lfsr <= {lfsr[14:0], lfsr[3] ^ lfsr[2]}; // linear feedback shift register
  end
  
  // Output the lower 8 bits of the LFSR
  assign uo_out = lfsr[7:0];
  
  // Unused outputs
  assign uio_out = 8'b0;
  assign uio_oe = 8'b0;
endmodule
