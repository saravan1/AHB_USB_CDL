// $Id: $
// File name:   sr_8bit.sv
// Created:     4/15/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: 8-bit parallel to serial shift register. 


module sr_8bit (
	input wire clk,
	input wire n_rst,
	input wire [7:0] parallel_in,
	input wire load_enable,
	input wire shift_enable,
	output reg serial_out
);

flex_pts_sr #(.SHIFT_MSB(1), .NUM_BITS(8)) SR8BIT(.clk(clk), .n_rst(n_rst), .parallel_in(parallel_in),
.load_enable(load_enable), .shift_enable(shift_enable), .serial_out(serial_out));
endmodule

