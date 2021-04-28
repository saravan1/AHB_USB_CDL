// $Id: $
// File name:   tb_databuffer.sv
// Created:     4/15/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: Test Bench for 64 B Data Buffer.

`timescale 1ns/10ps

module tb_databuffer();

//Define local prameters used by the test bench
localparam CLK_PERIOD = 1;
localparam INACTIVE_VALUE = '0;

//Declare DUT portmap signals
reg tb_clk;
reg tb_n_rst;
reg tb_clear;
reg tb_flush;
reg tb_get_rx_data;
reg tb_get_tx_packet_data;
reg tb_store_tx_data;
reg tb_store_rx_packet_data;
reg [7:0] tb_tx_data;
reg [7:0] tb_rx_packet_data;

wire [6:0] tb_buffer_occupancy;
wire [7:0] tb_rx_data;
wire [7:0] tb_tx_packet_data;

//Declare test bench signals
integer tb_test_num;
string tb_test_case;
integer tb_stream_test_num;
string tb_stream_check_tag;

//Task for DUT reset
task reset_dut;
begin
	tb_n_rst = 1'b0;
	@(posedge tb_clk);
	@(posedge tb_clk);
	
	@(negedge tb_clk);
	tb_n_rst = 1'b1;
	
	@(negedge tb_clk);
	@(negedge tb_clk);
end
endtask

//Task to check buffer occupancy;
task check_buffer;
	input logic [6:0] expected_buffer_occupancy;
	input string check_tag;
begin
	if(expected_buffer_occupancy == tb_buffer_occupancy) begin
	      $info("Correct buffer occupancy output %s during %s test case", check_tag, tb_test_case);
	end else begin
	      $info("Incorrect buffer occupancy output %s during %s test case", check_tag, tb_test_case);
	end
end
endtask

//Task to check outputs
task check_outputs;
	input logic [7:0] expected_rx_data;
	input logic [7:0] expected_tx_packet_data;
	input string check_tag;
begin
	if(expected_rx_data == tb_rx_data) begin
	      $info("Correct rx data output %s during %s test case", check_tag, tb_test_case);
	end else begin
	      $info("Incorrect rx data output %s during %s test case", check_tag, tb_test_case);
	end
	
	if(expected_tx_packet_data == tb_tx_packet_data) begin
	      $info("Correct tx packet data output %s during %s test case", check_tag, tb_test_case);
	end else begin
	      $info("Incorrect tx packet data output %s during %s test case", check_tag, tb_test_case);
	end
end 
endtask

task stream_buffer;
	integer num;
begin
	reset_dut;
	@(posedge tb_clk);
	tb_store_tx_data = 1'b1;
	for(num = 0; num < 63; num++)
	begin
		tb_tx_data = 8'b01101100;
		@(CLK_PERIOD);
	end
	tb_store_tx_data = 1'b0;
end
endtask

always
begin
	tb_clk = 1'b0;
	#(CLK_PERIOD/2.0);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2.0);
end

//DUT Port Map
databuffer databuff(.clk(tb_clk), .n_rst(tb_n_rst), .clear(tb_clear), .flush(tb_flush),
.get_rx_data(tb_get_rx_data), .get_tx_packet_data(tb_get_tx_packet_data), .store_tx_data(tb_store_tx_data),
.store_rx_packet_data(tb_store_rx_packet_data), .tx_data(tb_tx_data), .rx_packet_data(tb_rx_packet_data),
.buffer_occupancy(tb_buffer_occupancy), .rx_data(tb_rx_data), .tx_packet_data(tb_tx_packet_data));

initial
begin
	tb_n_rst = 1'b1;
	tb_clear = INACTIVE_VALUE;
	tb_flush = INACTIVE_VALUE;
	tb_get_rx_data = INACTIVE_VALUE; 
	tb_get_tx_packet_data = INACTIVE_VALUE;
	tb_store_tx_data = INACTIVE_VALUE;
	tb_store_rx_packet_data = INACTIVE_VALUE;
	tb_tx_data = INACTIVE_VALUE;
	tb_rx_packet_data = INACTIVE_VALUE;
	tb_test_num = 0; 
	tb_test_case = "Test bench initialization";
	tb_stream_test_num = 0;
	tb_stream_check_tag = "N/A";
	#(CLK_PERIOD*0.5);
	
	// ************************************************************************
    // Test Case 1: Power-on Reset of the DUT
    // ************************************************************************
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Power on Reset";
    #(CLK_PERIOD*0.5);
    tb_clear = INACTIVE_VALUE;
    tb_flush = INACTIVE_VALUE;
    tb_get_rx_data = INACTIVE_VALUE; 
    tb_get_tx_packet_data = INACTIVE_VALUE;
    tb_store_tx_data = INACTIVE_VALUE;
    tb_store_rx_packet_data = INACTIVE_VALUE;
    tb_tx_data = INACTIVE_VALUE;
    tb_rx_packet_data = INACTIVE_VALUE;
    tb_n_rst = 1'b0;
  
    #(CLK_PERIOD * 0.5);
    
    check_outputs(8'd0, 8'd0, "after reset applied");
    check_buffer(7'b0, "aftr reset applied");
    
    @(posedge tb_clk);
    tb_n_rst  = 1'b1; 
	#(CLK_PERIOD * 0.5);
	
	check_outputs(8'd0, 8'd0, "after reset released");
	check_buffer(7'b0, "after reset applied");

    // ************************************************************************
    // Test Case 2: Write 2 bytes to FIFO from AHB Slave Interface
    // ************************************************************************    
    @(negedge tb_clk);
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Write 2 bytes to FIFO (AHB)";

	@(posedge tb_clk);
    tb_store_tx_data = 1'b1;
    tb_tx_data = 8'b10101111;
    #(CLK_PERIOD);
    tb_store_tx_data = 1'b0;
    check_outputs(8'd0, 8'd0, "after 1 byte stored");
    #(0.1);
    check_buffer(7'd1, "after 1 byte stored");
    
    @(posedge tb_clk);
    tb_store_tx_data = 1'b1;
    tb_tx_data = 8'b11111010;
    #(CLK_PERIOD);
    tb_store_tx_data = 1'b0;
    check_outputs(8'd0, 8'd0, "after 2 byte stored");
    #(0.1);
    check_buffer(7'd2, "after 2 byte stored");    
    
    // ************************************************************************
    // Test Case 3: Read 2 bytes from FIFO that was sent by AHB
    //              and will be read by USB TX 
    // ************************************************************************    
    @(negedge tb_clk);
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Read 2 bytes from FIFO (sent by AHB read by TX)";

    @(posedge tb_clk);
    
    tb_get_tx_packet_data = 1'b1;
    #(CLK_PERIOD);
    tb_get_tx_packet_data = 1'b0;
    check_outputs(8'b0, 8'b10101111, "after 1 byte read");
    #(0.1);
    check_buffer(7'd1, "after 1 byte read");
    
    @(posedge tb_clk);
    tb_get_tx_packet_data = 1'b1;
    #(CLK_PERIOD);
    tb_get_tx_packet_data = 1'b0;
    check_outputs(8'b0, 8'b11111010, "after 2 byte read");
    #(0.1);
    check_buffer(7'd0, "after 2 byte read");
    
    // ************************************************************************
    // Test Case 4: Write 2 bytes to FIFO from USB RX
    // ************************************************************************
    @(negedge tb_clk);
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Write 2 bytes to FIFO (USB RX)";

	@(posedge tb_clk);
    tb_store_rx_packet_data = 1'b1;
    tb_rx_packet_data = 8'b10101111;
    #(CLK_PERIOD);
    tb_store_rx_packet_data = 1'b0;
    check_outputs(8'd0, 8'd0, "after 1 byte stored");
    #(0.1);
    check_buffer(7'd1, "after 1 byte stored");
    
    @(posedge tb_clk);
    tb_store_rx_packet_data = 1'b1;
    tb_rx_packet_data = 8'b11111010;
    #(CLK_PERIOD);
    tb_store_rx_packet_data = 1'b0;
    check_outputs(8'd0, 8'd0, "after 2 byte stored");
    #(0.1);
    check_buffer(7'd2, "after 2 byte stored");    
    
    // ************************************************************************
    // Test Case 5: Read 2 bytes from FIFO that was sent by USB TX
    //              and will be read by AHB Slave interface
    // ************************************************************************    
    @(negedge tb_clk);
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Read 2 bytes from FIFO (sent by RX read by AHB) ";

    @(posedge tb_clk);
    
    tb_get_rx_data = 1'b1;
    #(CLK_PERIOD);
    tb_get_rx_data = 1'b0;
    check_outputs(8'b10101111, 8'b0, "after 1 byte read");
    #(0.1);
    check_buffer(7'd1, "after 1 byte read");
    
    @(posedge tb_clk);
    tb_get_rx_data = 1'b1;
    #(CLK_PERIOD);
    tb_get_rx_data = 1'b0;
    check_outputs(8'b11111010, 8'b0, "after 2 byte read");
    #(0.1);
    check_buffer(7'd0, "after 2 byte read");
    
    // ************************************************************************
    // Test Case 6: Clear data buffer (AHB)
    // ************************************************************************
	@(negedge tb_clk);
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Clear data buffer (asserted from AHB Slave Interface)";

	@(posedge tb_clk);
    tb_store_rx_packet_data = 1'b1;
    tb_rx_packet_data = 8'b10101111;
    #(CLK_PERIOD);
    tb_rx_packet_data = 8'b11111010;
    #(CLK_PERIOD);
    tb_store_rx_packet_data = 1'b0;
    
    @(posedge tb_clk);
    tb_clear = 1'b1;
    #(CLK_PERIOD);
    tb_clear = 1'b0; 
    check_outputs(8'b0, 8'b0, "after clear signal asserted");
    #(0.1);
    check_buffer(7'd0, "after clear signal asserted");
    // ************************************************************************
    // Test Case 7: Flush data buffer (USB RX)
    // ************************************************************************
    @(negedge tb_clk);
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Flush data buffer (asserted from USB RX)";

	@(posedge tb_clk);
    tb_store_tx_data = 1'b1;
    tb_tx_data = 8'b10101111;
    #(CLK_PERIOD);
    tb_tx_data = 8'b11111010;
    #(CLK_PERIOD);
    tb_store_tx_data = 1'b0;
    
    @(posedge tb_clk);
    tb_flush = 1'b1;
    #(CLK_PERIOD);
    tb_flush = 1'b0;
    check_outputs(8'b0, 8'b0, "after flush signal asserted");
    #(0.1);
    check_buffer(7'd0, "after flush signal asserted");

end
endmodule
