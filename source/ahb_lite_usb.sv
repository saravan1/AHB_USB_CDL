// $Id: $
// File name:   ahb_lite_usb.sv
// Created:     4/21/2021
// Author:      Lohith Chittineni
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: AHB USB Top Level Design

module ahb_lite_usb
(
    input wire clk,
    input wire n_rst,
    input wire[3:0] haddr,
    input wire hsel,
    input wire[1:0] htrans,
    input wire[1:0] hsize,
    input wire hwrite, 
    input wire[31:0] hwdata,
    input wire dplus_in,
    input wire dminus_in,

    output reg[31:0] hrdata,
    output reg hready,
    output reg hresp,
    output reg dplus_out,
    output reg dminus_out
);
	reg clear;
	reg flush;
	reg [3:0] rx_packet;
	reg rx_data_ready;
	reg rx_trans_active;
	reg rx_error;
	reg [7:0] rx_data;
	reg get_rx_data;
	reg store_rx_packet_data;
	reg [7:0] rx_packet_data;
	reg [6:0] buffer_occupancy;
	reg store_tx_data;
	reg [7:0] tx_data;
	reg tx_error;
	reg tx_trans_active;
	reg [3:0] tx_packet; 
	reg [7:0] tx_packet_data;
	reg get_tx_packet_data;
	
// AHB LITE MODULE
ahb_lite_slave AHB(
	.clk(clk), 
	.n_rst(n_rst), 
	.hsel(hsel), 
	.haddr(haddr),
	.hsize(hsize),
	.htrans(htrans),
	.hwrite(hwrite),
	.hwdata(hwdata), 
	.rx_packet(rx_packet),
	.rx_data_ready(rx_data_ready),
	.rx_trans_active(rx_trans_active),
	.rx_error(rx_error), 
	.buffer_occupancy(buffer_occupancy),
	.rx_data(rx_data),
	.tx_trans_active(tx_trans_active),
	.tx_error(tx_error),
	.hrdata(hrdata), 
	.hready(hready),
	.hresp(hresp),
	.clear(clear),
	.get_rx_data(get_rx_data),
	.store_tx_data(store_tx_data), 
	.tx_data(tx_data),
	.tx_packet(tx_packet)
);

// DATA BUFFER MODULE
databuffer DATABUFF(
	.clk(clk), 
	.n_rst(n_rst), 
	.clear(clear),
	.flush(flush), 
	.get_rx_data(get_rx_data),
	.get_tx_packet_data(get_tx_packet_data),
	.store_tx_data(store_tx_data),
	.store_rx_packet_data(store_rx_packet_data),
	.tx_data(tx_data),
	.rx_packet_data(rx_packet_data),
	.buffer_occupancy(buffer_occupancy),
	.rx_data(rx_data),
	.tx_packet_data(tx_packet_data)
);

// USB TX MODULE
usb_tx USBTX(
	.clk(clk),
	.n_rst(n_rst),
	.tx_packet(tx_packet), 
	.tx_packet_data(tx_packet_data),
	.buffer_occupancy(buffer_occupancy),
	.tx_error(tx_error),
	.get_tx_packet_data(get_tx_packet_data),
	.tx_transfer_active(tx_trans_active),
	.Dplus_out(dplus_out),
	.Dminus_out(dminus_out)
);

// USB RX MODULE
  usb_rx USBRX (
    .clk(clk),
    .n_rst(n_rst),
    .dplus_in(dplus_in),
    .dminus_in(dminus_in),
    .buffer_occupancy(buffer_occupancy),
    .rx_packet_data(rx_packet_data),
    .rx_packet(rx_packet),
    .store_rx_packet_data(store_rx_packet_data),
    .flush(flush),
    .rx_error(rx_error),
    .rx_trans_active(rx_trans_active),
    .rx_data_ready(rx_data_ready)
  );


endmodule
