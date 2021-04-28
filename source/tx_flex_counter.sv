// $Id: $
// File name:   flex_counter.sv
// Created:     2/12/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: Flex counter with rollover value.

module tx_flex_counter
#(
	parameter NUM_CNT_BITS = 4
)
(
	input wire clk,
	input wire n_rst,
	input wire clear,
	input wire count_enable,
	input wire [(NUM_CNT_BITS-1):0] rollover_val,
	output reg [(NUM_CNT_BITS-1):0] count_out,
	output reg rollover_flag

);
	reg [(NUM_CNT_BITS-1):0] next_count;
	reg update_flag;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0) begin
			count_out <= 0;
			rollover_flag <= 1'b0;
		end else begin
			count_out <= next_count;
			rollover_flag <= update_flag;
		end
	end

	always_comb begin
		next_count = count_out;
		update_flag = rollover_flag;
		if(clear) begin 
			next_count = 0;
		end else if (count_enable) begin
			if(next_count == rollover_val) begin
				next_count = 1;
			end else begin
				next_count = count_out + 1;
			end
		end
		if(next_count == rollover_val && count_enable) begin
			update_flag = 1'b1;
		end else begin
			update_flag = 1'b0;
		end
	end
endmodule
