/*
 * Copyright (c) 2024 Eric Fogleman
 * SPDX-License-Identifier: Apache-2.0
 *
 * Fully-segmented mismatch shaping encoder 
 * from SEGMENTED MISMATCH-SHAPING D/A CONVERSION, 
 * Fishov, Fogleman, Siragusa, Galton 
 * 2002 IEEE International Symposium on Circuits and Systems (ISCAS)
 * y0 drives 1x 3-level DAC
 * y1: 2x, y2: 4x, ..., y6: 64x
 * 128x DAC driven by x7, y_c
 */
 
module ef_smsdac_mse ( clk, rst_b, x, x_c, r, y6, y5, y4, y3, y2, y1, y0, y_c );

  input clk;
  input rst_b;
  input  [6:0] x;
  input x_c;
  input  [6:0] r;
  output  [1:0] y6;
  output  [1:0] y5;
  output  [1:0] y4;
  output  [1:0] y3;
  output  [1:0] y2;
  output  [1:0] y1;
  output  [1:0] y0;
  output y_c;

	wire yc_0, yc_1, yc_2, yc_3, yc_4, yc_5, yc;

	ef_smsdac_mse_sb u_s0( .x0(x[0]), 
						.xc(x_c), 
						.r(r[0]), 
						.clk(clk), 
						.rst_b(rst_b), 
						.y_c(yc_0), 
						.y0(y0[0]), 
						.y1(y0[1]));
	ef_smsdac_mse_sb u_s1( .x0(x[1]), 
						.xc(yc_0), 
						.r(r[1]), 
						.clk(clk), 
						.rst_b(rst_b), 
						.y_c(yc_1), 
						.y0(y1[0]), 
						.y1(y1[1]));
	ef_smsdac_mse_sb u_s2( .x0(x[2]), 
						.xc(yc_1), 
						.r(r[2]), 
						.clk(clk), 
						.rst_b(rst_b), 
						.y_c(yc_2), 
						.y0(y2[0]), 
						.y1(y2[1]));
	ef_smsdac_mse_sb u_s3( .x0(x[3]), 
						.xc(yc_2), 
						.r(r[3]), 
						.clk(clk), 
						.rst_b(rst_b), 
						.y_c(yc_3), 
						.y0(y3[0]), 
						.y1(y3[1]));
	ef_smsdac_mse_sb u_s4( .x0(x[4]), 
						.xc(yc_3), 
						.r(r[4]), 
						.clk(clk), 
						.rst_b(rst_b), 
						.y_c(yc_4), 
						.y0(y4[0]), 
						.y1(y4[1]));
	ef_smsdac_mse_sb u_s5( .x0(x[5]), 
						.xc(yc_4), 
						.r(r[5]), 
						.clk(clk), 
						.rst_b(rst_b), 
						.y_c(yc_5), 
						.y0(y5[0]), 
						.y1(y5[1]));
	ef_smsdac_mse_sb u_s6( .x0(x[6]), 
						.xc(yc_5), 
						.r(r[6]), 
						.clk(clk), 
						.rst_b(rst_b), 
						.y_c(yc), 
						.y0(y6[0]), 
						.y1(y6[1]));
endmodule
