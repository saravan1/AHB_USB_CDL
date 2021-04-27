// $Id: $
// File name:   databuffer.sv
// Created:     4/13/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: 64 B FIFO Data Buffer.

module databuffer(
	input wire clk,
	input wire n_rst,
	input wire clear,
	input wire flush,
	input wire get_rx_data,
	input wire get_tx_packet_data,
	input wire store_tx_data,
	input wire store_rx_packet_data,
	input wire [7:0] tx_data,
	input wire [7:0] rx_packet_data,
	output reg [6:0] buffer_occupancy,
	output reg [7:0] rx_data,
	output reg [7:0] tx_packet_data
);
	
	reg [6:0] read_ptr, write_ptr, next_read_ptr, next_write_ptr;
	reg [63:0][7:0] registerData, next_registerData;
	reg [6:0] next_buffer_occupancy;
	
	always_ff @(posedge clk, negedge n_rst) begin
		if(n_rst == 1'b0) begin
			read_ptr <= 7'b0;
			write_ptr <= 7'b0;
			registerData <= '0;
			buffer_occupancy <= 7'b0;
		end else begin
			read_ptr <= next_read_ptr;
			write_ptr <= next_write_ptr;
			registerData <= next_registerData;
			buffer_occupancy <= next_buffer_occupancy;
		end
	end
	
	always_comb begin
		next_registerData = registerData;
		next_write_ptr = write_ptr;
		if(clear == 1'b1 || flush == 1'b1) begin
			next_registerData = '0;
			next_write_ptr = 7'b0;
		end else if(store_tx_data) begin
			next_registerData[write_ptr] = tx_data;
			next_write_ptr = write_ptr + 1;
		end else if(store_rx_packet_data) begin
			next_registerData[write_ptr] = rx_packet_data;
			next_write_ptr = write_ptr + 1;
		end else if(write_ptr == read_ptr) begin
			next_registerData = '0;
			next_write_ptr = 7'b0;
		end
	end

	always_comb begin
		next_read_ptr = read_ptr;
		if(clear == 1'b1 || flush == 1'b1) begin
			next_read_ptr = 0;
		end else if(get_rx_data == 1'b1 || get_tx_packet_data == 1'b1) begin
			next_read_ptr = read_ptr + 1;
		end else if(write_ptr == read_ptr) begin
			next_read_ptr = 7'b0;
		end
	end
	
	always_comb begin
		next_buffer_occupancy = next_write_ptr - next_read_ptr;
	end	
	assign rx_data = (get_rx_data) ? registerData[read_ptr] : 8'b0;
	assign tx_packet_data = (get_tx_packet_data) ? registerData[read_ptr] : 8'b0;

endmodule
