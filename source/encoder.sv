// $Id: $
// File name:   encoder.sv
// Created:     4/15/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: Encoder for USB TX.

module encoder(
	input wire clk,
	input wire n_rst,
	input wire serial_out,
	input wire eop_flag,
	input wire shift_enable,
	input wire reset_out,
	output reg Dplus_out,
	output reg Dminus_out,
	output reg packet_done
);

	reg next_Dplus_out;
	reg next_Dminus_out;
	
	always_ff @(posedge clk, negedge n_rst) begin
		if(n_rst == 1'b0) begin
			Dplus_out <= 1'b1;
			Dminus_out <= 1'b0;
		end else begin 
			Dplus_out <= next_Dplus_out;
			Dminus_out <= next_Dminus_out;
		end
	end
	
	always_comb begin
		next_Dplus_out = Dplus_out;
		next_Dminus_out = Dminus_out;
		packet_done = 1'b0;
		if(eop_flag && shift_enable) begin
			next_Dplus_out = 1'b0;
			next_Dminus_out = 1'b0;
			packet_done = 1'b1;
		end else if(!serial_out && shift_enable) begin
			next_Dplus_out = ~Dplus_out; 
			next_Dminus_out = ~Dminus_out;
		end else if (reset_out) begin
			next_Dplus_out = 1'b1;
			next_Dminus_out = 1'b0;
		end
	end

endmodule
