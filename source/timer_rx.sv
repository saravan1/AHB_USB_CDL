// $Id: $
// File name:   timer_rx.sv
// Created:     4/15/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: Timer module for USB TX.

module timer_rx (
	input wire clk,
	input wire n_rst,
	input wire enable_timer,
	output reg shift_enable,
	output reg byte_sent
);
	reg [3:0] count_out_one;
	tx_flex_counter SE (.clk(clk), .n_rst(n_rst), .clear(~enable_timer), .count_enable(enable_timer), 
	.rollover_val(4'd5), .count_out(count_out_one), .rollover_flag());
	tx_flex_counter PD (.clk(clk), .n_rst(n_rst), .clear(~enable_timer), .count_enable(shift_enable), 
	.rollover_val(4'd8), .count_out(), .rollover_flag(byte_sent));
	always_comb begin
		shift_enable = 1'b0;
		if(count_out_one == 4'd1) begin
			shift_enable = 1'b1;
		end
	end
endmodule
