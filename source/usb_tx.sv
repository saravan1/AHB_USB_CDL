// $Id: $
// File name:   USB_TX.sv
// Created:     4/15/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: USB TX full module. 

module usb_tx (
	input wire clk,
	input wire n_rst,
	input wire [3:0] tx_packet,
	input wire [7:0] tx_packet_data,
	input wire [6:0] buffer_occupancy,
	output reg tx_error,
	output reg get_tx_packet_data,
	output reg tx_transfer_active,
	output reg Dplus_out,
	output reg Dminus_out
);
	reg eop_flag;
	reg load_enable;
	reg [7:0] parallel_in;
	reg serial_out;
	reg shift_enable;
	reg enable_timer;
	reg byte_sent;
	reg reset_out;
	reg packet_done;

	control CNTFSM(.clk(clk), .n_rst(n_rst), .tx_packet(tx_packet), .tx_packet_data(tx_packet_data),
	.buffer_occupancy(buffer_occupancy), .eop_flag(eop_flag), .load_enable(load_enable), 
	.parallel_in(parallel_in), .tx_error(tx_error), .get_tx_packet_data(get_tx_packet_data),
	.tx_transfer_active(tx_transfer_active), .enable_timer(enable_timer), .byte_sent(byte_sent),
	.reset_out(reset_out), .packet_done(packet_done));
	
	sr_8bit SR(.clk(clk), .n_rst(n_rst), .load_enable(load_enable), .parallel_in(parallel_in),
	.shift_enable(shift_enable), .serial_out(serial_out));
	
	encoder ENDR(.clk(clk), .n_rst(n_rst), .eop_flag(eop_flag), .serial_out(serial_out),
	.Dplus_out(Dplus_out), .Dminus_out(Dminus_out), .shift_enable(shift_enable), .reset_out(reset_out), .packet_done(packet_done));
	
	timer TIM(.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), .byte_sent(byte_sent),
	.shift_enable(shift_enable));

endmodule
