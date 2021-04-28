// $Id: $
// File name:   flex_stp_sr.sv
// Created:     2/20/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: Flexible Serial to Parallel Shift Register.

module flex_stp_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire serial_in,
	output reg [(NUM_BITS - 1): 0] parallel_out
);

	reg [(NUM_BITS - 1): 0] next_parallel_out;
	always_ff @ (posedge clk, negedge n_rst) begin
		if(n_rst == 1'b0) begin
			parallel_out <= '1;
		end else begin
			parallel_out <= next_parallel_out;
		end
	end

	always_comb begin
		next_parallel_out = parallel_out;
		if(shift_enable) begin
			if(SHIFT_MSB) begin
				next_parallel_out = {parallel_out[(NUM_BITS - 2): 0], serial_in};
			end else begin
				next_parallel_out = {serial_in, parallel_out[(NUM_BITS - 1):1]};
			end
		end	
	end
endmodule
