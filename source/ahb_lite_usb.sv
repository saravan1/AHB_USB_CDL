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
    output reg dminus_out,
);

// AHB LITE MODULE


// DATA BUFFER MODULE



// USB TX MODULE



// USB RX MODULE


endmodule
