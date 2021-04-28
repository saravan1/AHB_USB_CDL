// $Id: $
// File name:   tb_usb_tx.sv
// Created:     4/25/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: Test bench for USB TX. 

`timescale 1ns / 10ps

module tb_usb_tx();

//Define parameters
localparam CLK_PERIOD = 10;
localparam INACTIVE_VALUE = '0;

//Declare DUT portmap signals
reg tb_clk;
reg tb_n_rst;
reg [3:0] tb_tx_packet;
reg [7:0] tb_tx_packet_data;
reg [6:0] tb_buffer_occupancy;

reg tb_tx_error;
reg tb_get_tx_packet_data;
reg tb_tx_transfer_active;
reg tb_Dplus_out;
reg tb_Dminus_out;

//Test bench debug signals
integer tb_test_num;
string tb_test_case;
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

//Task to check outputs
task check_init;
	input logic [7:0] sync;
	input logic [7:0] pid;
	input string check_tag;
	integer i;
begin
	for(i = 0; i < 8; i += 1) begin
		#(5*CLK_PERIOD);
		if(sync[7-i] == tb_Dplus_out) begin
		      //$info("Correct D plus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D plus output %s during %s test case", check_tag, tb_test_case);
		end
		if(!sync[7-i] == tb_Dminus_out) begin
		      //$info("Correct D minus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D minus output %s during %s test case", check_tag, tb_test_case);
		end
	end
	for(i = 0; i < 8; i += 1) begin
		if(pid[7-i] == tb_Dplus_out) begin
		      //$info("Correct D plus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D plus output %s during %s test case", check_tag, tb_test_case);
		end
		if(!pid[7-i] == tb_Dminus_out) begin
		      //$info("Correct D minus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D minus output %s during %s test case", check_tag, tb_test_case);
		end
		#(5*CLK_PERIOD);
	end
end
endtask

task check_data;
	input logic [7:0] data;
	input string check_tag;
	integer i; 
begin
	for(i = 0; i < 8; i += 1) begin
		if(data[7-i] == tb_Dplus_out) begin
		      //$info("Correct D minus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D minus output %s during %s test case", check_tag, tb_test_case);
		end
		if(!data[7-i] == tb_Dminus_out) begin
		      //$info("Correct D minus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D minus output %s during %s test case", check_tag, tb_test_case);
		end
		#(5 * CLK_PERIOD);
	end
end
endtask

task check_outputs;
	input logic tb_expected_tx_error;
	input logic tb_expected_get_tx_packet_data;
	input logic tb_expected_tx_transfer_active;
	input string check_tag;
begin
	if(tb_tx_error == tb_expected_tx_error) begin
	      //$info("Correct TX Error output %s during %s test case", check_tag, tb_test_case);
	end else begin
	      $info("Incorrect TX Error output %s during %s test case", check_tag, tb_test_case);
	end
	
	if(tb_get_tx_packet_data == tb_expected_get_tx_packet_data) begin
		//$info("Correct Get TX PKT Data output %s during %s test case", check_tag, tb_test_case);
	end else begin
	      $info("Incorrect Get TX PKT Data output %s during %s test case", check_tag, tb_test_case);
	end

	if(tb_tx_transfer_active == tb_expected_tx_transfer_active) begin
		//$info("Correct TX Transfer Active output %s during %s test case", check_tag, tb_test_case);
	end else begin
	      $info("Incorrect TX Transfer Active output %s during %s test case", check_tag, tb_test_case);
	end
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
usb_tx DUT(.clk(tb_clk), .n_rst(tb_n_rst), .tx_packet(tb_tx_packet),
.tx_packet_data(tb_tx_packet_data), .buffer_occupancy(tb_buffer_occupancy), 
.tx_error(tb_tx_error), .get_tx_packet_data(tb_get_tx_packet_data),
.tx_transfer_active(tb_tx_transfer_active), .Dplus_out(tb_Dplus_out),
.Dminus_out(tb_Dminus_out));

initial
begin
//Initialize all test bench signals
tb_test_num = -1;
tb_test_case = "TB Init";
tb_n_rst = 1'b1;
tb_tx_packet = INACTIVE_VALUE;
tb_tx_packet_data = INACTIVE_VALUE;
tb_buffer_occupancy = INACTIVE_VALUE;

#(0.1);

// ************************************************************************
// Test Case 1: Power-on Reset of the DUT
// ************************************************************************
tb_test_num  = 0;
tb_test_case = "Power-on-Reset";

reset_dut();

// ************************************************************************
// Test Case 2: ACK packet transmission
// ************************************************************************
@(negedge tb_clk);
tb_test_num = tb_test_num + 1;
tb_test_case = "ACK packet transmission";

tb_tx_packet = 4'b0010;
check_init(8'b01010100, 8'b01101100, "after ACK"); 
#(2*CLK_PERIOD);
tb_tx_packet = 4'b0000;
#(8*CLK_PERIOD);
check_outputs(1'b0, 1'b0, 1'b0, "after ACK");
// ************************************************************************
// Test Case 3: NACK packet transmission
// ************************************************************************
@(negedge tb_clk);
tb_test_num = tb_test_num + 1;
tb_test_case = "NACK packet transmission";

tb_tx_packet = 4'b1010;
check_init(8'b01010100, 8'b01100011, "after NACK"); 
#(2*CLK_PERIOD);
tb_tx_packet = 4'b0000;
#(8*CLK_PERIOD);
check_outputs(1'b0, 1'b0, 1'b0, "after NACK");

// ************************************************************************
// Test Case 4: DATA0 packet transmission
// ************************************************************************
@(negedge tb_clk);
tb_test_num = tb_test_num + 1;
tb_test_case = "DATA0 packet transmission";
tb_buffer_occupancy = 1;
tb_tx_packet_data = 8'b10101010;
tb_tx_packet = 4'b0011;
check_init(8'b01010100, 8'b00010100, "after DATA0");
check_data(8'b00110011, "after DATA0");
tb_buffer_occupancy = 0;
tb_tx_packet = 4'b0000;
#(125*CLK_PERIOD);
check_outputs(1'b0, 1'b0, 1'b0, "after DATA0");

// ************************************************************************
// Test Case 5: DATA1 packet transmission
// ************************************************************************
@(negedge tb_clk);
tb_test_num = tb_test_num + 1;
tb_test_case = "DATA1 packet transmission";
tb_buffer_occupancy = 1;
tb_tx_packet_data = 8'b01010101;
tb_tx_packet = 4'b1011;
check_init(8'b01010100, 8'b00011011, "after DATA1");
check_data(8'b01100110, "after DATA1");
tb_buffer_occupancy = 0;
tb_tx_packet = 4'b0000;
#(125*CLK_PERIOD);
check_outputs(1'b0, 1'b0, 1'b0, "after DATA1");

// ************************************************************************
// Test Case 6: STALL packet transmission
// ************************************************************************
@(negedge tb_clk);
tb_test_num = tb_test_num + 1;
tb_test_case = "STALL packet transmission";

tb_tx_packet = 4'b1110;
check_init(8'b01010100, 8'b01111101, "after STALL"); 
#(2*CLK_PERIOD);
tb_tx_packet = 4'b0000;
#(8*CLK_PERIOD);
check_outputs(1'b0, 1'b0, 1'b0, "after STALL");

// ************************************************************************
// Test Case 7: TX Error from Empty Queue
// ************************************************************************
@(negedge tb_clk);
tb_test_num = tb_test_num + 1;
tb_test_case = "TX Error from Empty Queue";

tb_tx_packet = 4'b0011;
check_init(8'b01010100, 8'b00010100, "after TX ERR Empty");
tb_tx_packet = 4'b0000;
check_outputs(1'b1, 1'b0, 1'b1, "after TX ERR Empty");
#(15*CLK_PERIOD);

// ************************************************************************
// Test Case 8: TX Error from Invalid TX Packet
// ************************************************************************
@(negedge tb_clk);
tb_test_num = tb_test_num + 1;
tb_test_case = "Invalid transmission";

tb_tx_packet = 4'b1111;
check_init(8'b01010100, 8'b00000101, "after TX ERR INV PKT"); 
tb_tx_packet = 4'b0000;
check_outputs(1'b0, 1'b0, 1'b0, "after TX ERR INV PKT");
#(15*CLK_PERIOD);
end
endmodule
