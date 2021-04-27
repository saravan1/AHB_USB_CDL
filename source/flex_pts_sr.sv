// $Id: $
// File name:   flex_pts_sr.sv
// Created:     2/20/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: Parallel to Serial Shift Register.

module flex_pts_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire load_enable,
	input wire [(NUM_BITS - 1): 0] parallel_in,
	output reg serial_out
);

	reg [(NUM_BITS - 1): 0] temp;
	reg [(NUM_BITS - 1): 0] next_temp;
	always_ff @ (posedge clk, negedge n_rst) begin
		if(n_rst == 1'b0) begin
			temp <= '1;
		end else begin
			temp <= next_temp; 
		end
	end

	always_comb begin
		next_temp = temp; 
		if(load_enable) begin
			next_temp = parallel_in;		
		end else if(shift_enable) begin
			if(SHIFT_MSB) begin
				next_temp = {temp[(NUM_BITS - 2):0], 1'b1};
			end else begin
				next_temp = {1'b1, temp[(NUM_BITS - 1):1]};
			end
		end
	end

	always_comb begin 
		serial_out = (SHIFT_MSB) ? temp[NUM_BITS - 1] : temp[0];
	end
endmodule
