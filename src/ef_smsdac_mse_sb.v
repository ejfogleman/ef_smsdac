/*
 * Copyright (c) 2024 Eric Fogleman
 * SPDX-License-Identifier: Apache-2.0
 *
 * Switching block for fully-segmented mismatch shaping encoder
 * from SEGMENTED MISMATCH-SHAPING D/A CONVERSION, 
 * Fishov, Fogleman, Siragusa, Galton 
 * 2002 IEEE International Symposium on Circuits and Systems (ISCAS)
 */

module ef_smsdac_mse_sb ( clk, rst_b, r, x0, x_c, y0, y1, y_c );

  input clk, rst_b, r, x0, x_c; 
  output y0, y1, y_c;

	reg q, q0;
	wire q_d, q0_d;
	wire odd, y1, y0, y_c;

	// input parity
	assign odd = x0 ^ x_c;

	// "carry" output (extra lsb); round up/down on odd input
	assign y_c = odd ? q : x0;

	// 3-level DAC outputs
	assign y1 = odd & ~q;
	assign y0 = ~odd | ~q;

	// switching sequence; update only on odd inputs
	assign q0_d = odd ? ~q0 : q0; 
	assign q_d = odd ? ( ~q ? ~q0 : r ) : q;

	always @( posedge clk, negedge rst_b ) begin 
		if ( rst_b == 1'b0 ) begin
			q0 <= 1'b0;
			q <= 1'b0;
		end
		else begin 
			q0 <= q0_d;
			q <= q_d; 
		end
	end
			 
endmodule
