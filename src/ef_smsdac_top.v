/*
 * Copyright (c) 2024 Eric Fogleman
 * SPDX-License-Identifier: Apache-2.0
 *
 * Segmented mismatch-shaping DAC top-level wrapper
 * Input clock at 1-50 MHz
 * 8-b unsigned input data on d_in; sync'd to clk
 * d_out{3..0} connect to 8x, 4x, 2x, 1x weight 3-level DACs
 */
 
// Top level 
module ef_smsdac_top ( clk, rst_b, d_in, d_out_3, d_out_2, d_out_1, d_out_0 );

  input clk;
  input rst_b;
  input  [7:0] d_in;
  output  [1:0] d_out_3;
  output  [1:0] d_out_2;
  output  [1:0] d_out_1;
  output  [1:0] d_out_0;

  wire [7:0] d_sync; // input data after clock syncrhonizer
  wire en_dith = 1'b0;  // no control bit available right now
  wire x_c = 1'b0;  // no carry in
  wire [6:0] r;  // random dither bits
  wire [1:0] y6, y5, y4, y3, y2, y1, y0;  // encoder outputs; only y6...y4 used
  wire y_c;

  // input data sync reg
  u_sync ef_smsdac_sync(
    .clk(clk), 
    .rst_b(rst_b), 
    .d(d_in), 
    .q(d_sync));  

  // mismatch-shaping encoder
  u_dac ef_smsdac_mse(
    .clk(clk), 
    .rst_b(rst_b), 
    .x(d_sync), 
    .x_c(x_c), 
    .r(r), 
    .y6(y6), 
    .y5(y5), 
    .y4(y4), 
    .y3(y3), // n/c
    .y2(y2), // n/c
    .y1(y1), // n/c
    .y0(y0), // n/c
    .y_c(y_c));

  // lfsr for encoder dither
  u_lfsr ef_smsdac_lfsr10_7(
    .clk(clk), 
    .rst_b(rst_b), 
    .en_dith(en_dith), 
    .r(r));

  // output retiming reg
  u_reg ef_smsdac_reg(
    .clk(clk), 
    .rst_b(rst_b), 
    .d({d_sync[7],y_c,y6[1:0],y5[1:0],y4[1:0]}), 
    .q({d_out_3[1:0],d_out_2[1:0],d_out_1[1:0],d_out_0[1:0]});

endmodule
