// $Id: $
// File name:   tb_ahb_lite_usb.sv
// Created:     4/27/2021
// Author:      Lohith Chittineni
// Lab Section: 3
// Version:     1.0  Initial Design Entry
// Description: Top level test bench for AHB Lite USB.

`timescale 1ns / 10ps

module tb_ahb_lite_usb();

// Timing related constants
localparam CLK_PERIOD = 10;
localparam BUS_DELAY  = 800ps; // Based on FF propagation delay
localparam PROPAGATION_DELAY = 0.8; 

// Sizing related constants
localparam DATA_WIDTH      = 4;
localparam ADDR_WIDTH      = 7;
localparam DATA_WIDTH_BITS = DATA_WIDTH * 8;
localparam DATA_MAX_BIT    = DATA_WIDTH_BITS - 1;
localparam ADDR_MAX_BIT    = ADDR_WIDTH - 1;

// HTRANS Codes
localparam TRANS_IDLE = 2'd0;
localparam TRANS_BUSY = 2'd1;
localparam TRANS_NSEQ = 2'd2;
localparam TRANS_SEQ  = 2'd3;

// Define our address mapping scheme via constants
localparam ADDR_READ_MIN  = 8'd0;
localparam ADDR_READ_MAX  = 8'd127;
localparam ADDR_WRITE_MIN = 8'd64;
localparam ADDR_WRITE_MAX = 8'd255;

//*****************************************************************************
// Declare TB Signals (Bus Model Controls)
//*****************************************************************************
// Testing setup signals
bit                          tb_enqueue_transaction;
bit                          tb_transaction_write;
bit                          tb_transaction_fake;
bit [(ADDR_WIDTH - 1):0]     tb_transaction_addr;
bit [((DATA_WIDTH*8) - 1):0] tb_transaction_data [];
bit                          tb_transaction_error;
bit [2:0]                    tb_transaction_size;
// Testing control signal(s)
logic    tb_model_reset;
logic    tb_enable_transactions;
integer  tb_current_addr_transaction_num;
integer  tb_current_addr_beat_num;
logic    tb_current_addr_transaction_error;
integer  tb_current_data_transaction_num;
integer  tb_current_data_beat_num;
logic    tb_current_data_transaction_error;

string                 tb_test_case;
integer                tb_test_case_num;
bit   [DATA_MAX_BIT:0] tb_test_data [];
string                 tb_check_tag;
logic                  tb_mismatch;
logic                  tb_check;
logic                  tb_bit_num;
integer                tb_i;

//*****************************************************************************
// General System signals
//*****************************************************************************
logic tb_clk;
logic tb_n_rst;

// Expected value check signals
logic                   tb_expected_hresp;
logic [DATA_MAX_BIT:0]  tb_expected_hrdata;
logic                   tb_expected_hready;
logic                   tb_expected_dplus_out;
logic                   tb_expected_dminus_out;

//*****************************************************************************
// AHB-Lite-USB Side Signals 
//*****************************************************************************
logic                          tb_hsel;
logic [1:0]                    tb_htrans;
logic [(ADDR_WIDTH - 1):0]     tb_haddr;
logic [1:0]                    tb_hsize;
logic                          tb_hwrite;
logic [((DATA_WIDTH*8) - 1):0] tb_hwdata;
logic [((DATA_WIDTH*8) - 1):0] tb_hrdata;
logic                          tb_hresp;
logic                          tb_hready;
logic                          tb_dplus_in;
logic                          tb_dminus_in;
logic                          tb_dplus_out;
logic                          tb_dminus_out;
//*****************************************************************************
// Clock Generation Block
//*****************************************************************************
// Clock generation block
always begin
  // Start with clock low to avoid false rising edge events at t=0
  tb_clk = 1'b0;
  // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
  #(CLK_PERIOD/2.0);
  tb_clk = 1'b1;
  // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
  #(CLK_PERIOD/2.0);
end

//*****************************************************************************
// Bus Model Instance
//*****************************************************************************
ahb_lite_bus_cdl BFM (.clk(tb_clk),
                  // Testing setup signals
                  .enqueue_transaction(tb_enqueue_transaction),
                  .transaction_write(tb_transaction_write),
                  .transaction_fake(tb_transaction_fake),
                  .transaction_addr(tb_transaction_addr),
                  .transaction_data(tb_transaction_data),
                  .transaction_error(tb_transaction_error),
                  .transaction_size(tb_transaction_size),
                  // Testing controls
                  .model_reset(tb_model_reset),
                  .enable_transactions(tb_enable_transactions),
                  .current_addr_transaction_num(tb_current_addr_transaction_num),
                  .current_addr_transaction_error(tb_current_addr_transaction_error),
                  .current_data_transaction_num(tb_current_data_transaction_num),
                  .current_data_transaction_error(tb_current_data_transaction_error),
                  // AHB-Lite-Slave Side
                  .hsel(tb_hsel),
                  .haddr(tb_haddr),
                  .hsize(tb_hsize),
                  .htrans(tb_htrans),
                  .hwrite(tb_hwrite),
                  .hwdata(tb_hwdata),
                  .hrdata(tb_hrdata),
                  .hresp(tb_hresp),
                  .hready(tb_hready));

//*****************************************************************************
// Test Module Instance
//*****************************************************************************
ahb_lite_usb DUT(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.haddr(tb_haddr),
	.hsel(tb_hsel),
	.htrans(tb_htrans),
	.hsize(tb_hsize),
	.hwrite(tb_hwrite),
	.hwdata(tb_hwdata),
	.dplus_in(tb_dplus_in),
	.dminus_in(tb_dminus_in),
	.hrdata(tb_hrdata),
	.hready(tb_hready),
	.hresp(tb_hresp),
	.dplus_out(tb_dplus_out),
	.dminus_out(tb_dminus_out)
);

//*****************************************************************************
// DUT Related TB Tasks
//*****************************************************************************
// Task for standard DUT reset procedure
task reset_dut;
begin
  // Activate the reset
  tb_n_rst = 1'b0;

  // Maintain the reset for more than one cycle
  @(posedge tb_clk);
  @(posedge tb_clk);

  // Wait until safely away from rising edge of the clock before releasing
  @(negedge tb_clk);
  tb_n_rst = 1'b1;

  // Leave out of reset for a couple cycles before allowing other stimulus
  // Wait for negative clock edges, 
  // since inputs to DUT should normally be applied away from rising clock edges
  @(negedge tb_clk);
  @(negedge tb_clk);
end
endtask

// Task to cleanly and consistently check DUT output values
task check_outputs;
  input string check_tag;
begin
  tb_mismatch = 1'b0;
  tb_check    = 1'b1;
  if(tb_expected_hrdata == tb_hrdata) begin // Check passed
    $info("Correct 'hrdata' output %s during %s test case", check_tag, tb_test_case);
  end
  else begin // Check failed
    tb_mismatch = 1'b1;
    $error("Incorrect 'hrdata' output %s during %s test case", check_tag, tb_test_case);
  end

  if(tb_expected_hresp == tb_hresp) begin // Check passed
    $info("Correct 'hresp' output %s during %s test case", check_tag, tb_test_case);
  end
  else begin // Check failed
    tb_mismatch = 1'b1;
    $error("Incorrect 'hresp' output %s during %s test case", check_tag, tb_test_case);
  end

  if(tb_expected_hready == tb_hready) begin // Check passed
    $info("Correct 'hready' output %s during %s test case", check_tag, tb_test_case);
  end
  else begin // Check failed
    tb_mismatch = 1'b1;
    $error("Incorrect 'hready' output %s during %s test case", check_tag, tb_test_case);
  end

  // Wait some small amount of time so check pulse timing is visible on waves
  #(0.1);
  tb_check =1'b0;
end
endtask

  task send_byte;
    input logic [7:0] target;
    integer i;
  begin
    @(posedge tb_clk);
    for(i =0; i < 8; i++ ) begin
      send_bit(target[i]);
    end
  end
  endtask

  task send_sync;
  begin
    send_byte(8'b10000000);
  end
  endtask

  task send_PID;
    input logic [3:0]PID;
  begin
    send_byte({~PID[3],~PID[2],~PID[1],~PID[0],PID[3],PID[2],PID[1],PID[0]});
  end
  endtask

  task send_eop;
    integer i;
  begin
    @(posedge tb_clk);
    tb_dplus_in = 0;
    tb_dminus_in = 0;
    #(CLK_PERIOD * 5);

    tb_dplus_in = 1;
    #(CLK_PERIOD * 8);
  end
  endtask

  task send_bit;
    input logic target;
  begin
    if(target == 0) begin
        tb_dplus_in =  ~tb_dplus_in;
        tb_dminus_in = ~tb_dplus_in;
    end
    #(CLK_PERIOD * 5);
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
		if(sync[7-i] == tb_dplus_out) begin
		      $info("Correct D plus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D plus output %s during %s test case", check_tag, tb_test_case);
		end
		if(!sync[7-i] == tb_dminus_out) begin
		      $info("Correct D minus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D minus output %s during %s test case", check_tag, tb_test_case);
		end
	end
	for(i = 0; i < 8; i += 1) begin
		if(pid[7-i] == tb_dplus_out) begin
		      $info("Correct D plus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D plus output %s during %s test case", check_tag, tb_test_case);
		end
		if(!pid[7-i] == tb_dminus_out) begin
		      $info("Correct D minus output %s during %s test case", check_tag, tb_test_case);
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
		if(data[7-i] == tb_dplus_out) begin
		      $info("Correct D minus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D minus output %s during %s test case", check_tag, tb_test_case);
		end
		if(!data[7-i] == tb_dminus_out) begin
		      $info("Correct D minus output %s during %s test case", check_tag, tb_test_case);
		end else begin
		      $info("Incorrect D minus output %s during %s test case", check_tag, tb_test_case);
		end
		#(5 * CLK_PERIOD);
	end
end
endtask


//*****************************************************************************
// Bus Model Usage Related TB Tasks
//*****************************************************************************
// Task to pulse the reset for the bus model
task reset_model;
begin
  tb_model_reset = 1'b1;
  #(0.1);
  tb_model_reset = 1'b0;
end
endtask

// Task to enqueue a new transaction
task enqueue_transaction;
  input bit for_dut;
  input bit write_mode;
  input bit [ADDR_MAX_BIT:0] address;
  input bit [DATA_MAX_BIT:0] data [];
  input bit expected_error;
  input bit [1:0] size;
begin
  // Make sure enqueue flag is low (will need a 0->1 pulse later)
  tb_enqueue_transaction = 1'b0;
  #0.1ns;

  // Setup info about transaction
  tb_transaction_fake  = ~for_dut;
  tb_transaction_write = write_mode;
  tb_transaction_addr  = address;
  tb_transaction_data  = data;
  tb_transaction_error = expected_error;
  tb_transaction_size  = {1'b0,size};

  // Pulse the enqueue flag
  tb_enqueue_transaction = 1'b1;
  #0.1ns;
  tb_enqueue_transaction = 1'b0;
end
endtask

// Task to wait for multiple transactions to happen
task execute_transactions;
  input integer num_transactions;
  integer wait_var;
begin
  // Activate the bus model
  tb_enable_transactions = 1'b1;
  @(posedge tb_clk);

  // Process the transactions (all but last one overlap 1 out of 2 cycles
  for(wait_var = 0; wait_var < num_transactions; wait_var++) begin
    @(posedge tb_clk);
  end

  // Run out the last one (currently in data phase)
  @(posedge tb_clk);

  // Turn off the bus model
  @(negedge tb_clk);
  tb_enable_transactions = 1'b0;
end
endtask

//*****************************************************************************
// Main TB Process
//*****************************************************************************
//*****************************************************************************
initial begin
  // Initialize Test Case Navigation Signals
  tb_test_case       = "Initialization";
  tb_test_case_num   = -1;
  tb_test_data       = new[1];
  tb_check_tag       = "N/A";
  tb_check           = 1'b0;
  tb_mismatch        = 1'b0;
  // Initialize all of the directly controled DUT inputs
  tb_n_rst          = 1'b1;
  tb_dplus_in       = 1;
  tb_dminus_in      = 0;
  // Initialize all of the bus model control inputs
  tb_model_reset          = 1'b0;
  tb_enable_transactions  = 1'b0;
  tb_enqueue_transaction  = 1'b0;
  tb_transaction_write    = 1'b0;
  tb_transaction_fake     = 1'b0;
  tb_transaction_addr     = '0;
  tb_transaction_data     = new[1];
  tb_transaction_error    = 1'b0;
  tb_transaction_size     = 3'd0;

  // Wait some time before starting first test case
  #(0.3);

  // Clear the bus model
  reset_model();

  //*****************************************************************************
  // Power-on-Reset Test Case
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Power-on-Reset";
  tb_test_case_num = tb_test_case_num + 1;
  
  // Reset the DUT
  reset_dut();

  //*****************************************************************************
  // Test Case: USB RX to AHB LITE - SEND IN TOKEN
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "SEND IN TOKEN";
  tb_test_case_num = tb_test_case_num + 1;

  // // Reset the DUT to isolate from prior test case
  reset_dut();
  #(CLK_PERIOD * 5);
  send_sync();
  send_PID(4'b1001);
  send_byte(8'b00010111);
  send_byte(8'b00010111);
  // Enqueue the needed transactions
  enqueue_transaction(1'b1, 1'b0, 4'h4, {8'b00000010}, 1'b0, 2'd0);
  // Run the transactions via the model
  execute_transactions(1);
  send_eop();

  #(CLK_PERIOD * 8);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = {16'd0,16'd2};
  tb_expected_hready = 1'b1;
  check_outputs("after reading data status");

  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

//*****************************************************************************
  // Test Case: USB RX to AHB LITE - SEND NEW DATA/ READ STATUS
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "SEND MULTIPLE BYTES TO DATA BUFFER";
  tb_test_case_num = tb_test_case_num + 1;

  // // Reset the DUT to isolate from prior test case
  reset_dut();
  #(CLK_PERIOD * 5);
  send_sync();
  send_PID(4'b0011);
  send_byte(8'b11110000);
  send_byte(8'b11110000);
  send_byte(8'b11110000);
  send_byte(8'b11110000);
  send_byte(8'b00010111);
  send_byte(8'b00010111);
  send_byte(8'b00010111);
  send_byte(8'b11000011);
  send_byte(8'b00010111);
  send_byte(8'b11111111);
  send_byte(8'b11111111);
  // Enqueue the needed transactions
  enqueue_transaction(1'b1, 1'b0, 4'h4, {8'b00000001}, 1'b0, 2'd0);
  // Run the transactions via the model
  execute_transactions(1);
  send_eop();

  #(CLK_PERIOD * 8);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = {16'd0,16'd1};
  tb_expected_hready = 1'b1;
  check_outputs("after reading data status");

  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

//*****************************************************************************
  // Test Case: Read Data Buffer Register
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "READ 4 BYTES FROM DATA BUFFER";

  // Enqueue the needed transactions
  tb_test_data = '{8'h1};
  enqueue_transaction(1'b1, 1'b0, 4'h0, tb_test_data,1'b0, 2'd3);
  // Run the transactions via the model
  execute_transactions(1);
  #(CLK_PERIOD * 3);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = {8'b00001111, 8'b00001111, 8'b00001111, 8'b00001111};
  tb_expected_hready = 1'b1;
  // Check the DUT outputs
  check_outputs("READ 4 BYTES FROM DATA BUFFER");
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

   //*****************************************************************************
  // Test Case: Flush Data Buffer Register
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "FLUSH FIFO";

  // Enqueue the needed transactions
  tb_test_data = '{32'd1}; 
  enqueue_transaction(1'b1, 1'b1, 4'hd, tb_test_data,1'b0, 2'd0);

  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 4'hd, tb_test_data, 1'b0, 2'd0);
  
  // Run the transactions via the model
  execute_transactions(2);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'd1;
  tb_expected_hready = 1'b1;
  // Check the DUT outputs
   check_outputs("FLUSH FIFO");
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: AHB LITE to USB TX
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Send DATA packet from AHB LITE to USB TX";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Write DATA TO FIFO FIRST
  // Enqueue the needed transactions
  tb_test_data = '{32'b10101010101010101010101010101010}; 
  enqueue_transaction(1'b1, 1'b1, 4'h0, tb_test_data,1'b0, 2'd3);
  
  // Run the transactions via the model
  execute_transactions(1);
  #(CLK_PERIOD * 3);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'd0;
  tb_expected_hready = 1'b1;
  // Check the DUT outputs
  check_outputs("Write to Data Buffer Register");
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Write/ Read TX Packet CTRL Reg
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Write/ Read TX Packet CTRL Reg";

  // Enqueue the needed transactions
  tb_test_data = '{8'd1};
  enqueue_transaction(1'b1, 1'b1, 4'hC, tb_test_data, 1'b0, 2'd1);

  enqueue_transaction(1'b1, 1'b0, 4'hC, tb_test_data, 1'b0, 2'd1);
  // Run the transactions via the model
  execute_transactions(2);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'd1;
  tb_expected_hready = 1'b1;
  // Check the DUT outputs
  check_outputs("Write/ Read TX Packet CTRL Reg");
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

  tb_test_case = "DATA0 packet transmission";
  //check_init(8'b01010100, 8'b00010100, "after DATA0");
  //check_data(8'b00110011, "after DATA0");
  #(125*CLK_PERIOD);
   tb_test_data = '{8'd0};
  enqueue_transaction(1'b1, 1'b1, 4'hC, tb_test_data, 1'b0, 2'd1);

  enqueue_transaction(1'b1, 1'b0, 4'hC, tb_test_data, 1'b0, 2'd1);
  // Run the transactions via the model
  execute_transactions(2);

  #(CLK_PERIOD * 3);
  //check_data(8'b00110011, "after DATA0");
  #(125*CLK_PERIOD);
  //check_data(8'b00110011, "after DATA0");
  #(125*CLK_PERIOD);

  #(CLK_PERIOD * 3);
  
  //*****************************************************************************
  // Test Case: RX error
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "RX ERROR";
  tb_test_case_num = tb_test_case_num + 1;

  reset_dut();
  #(CLK_PERIOD * 3);
  send_sync();
  send_PID(4'b0001);
  // check_PID();
  #(CLK_PERIOD * 1);
  send_byte(8'b10101010);
  #(CLK_PERIOD * 5);
  send_eop();

  #(CLK_PERIOD * 5);

  tb_test_data = '{32'd1}; 
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 4'h6, tb_test_data, 1'b0, 2'd1);
  
  // Run the transactions via the model
  execute_transactions(1);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'd1;
  tb_expected_hready = 1'b1;
  // Check the DUT outputs
  check_outputs("RX ERROR");

  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: TX error
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "TX ERROR";
  tb_test_case_num = tb_test_case_num + 1;

  reset_dut();

  // FLUSH FIFO
   // Enqueue the needed transactions
  tb_test_data = '{32'd1}; 
  enqueue_transaction(1'b1, 1'b1, 4'hd, tb_test_data,1'b0, 2'd0);
  
  // Run the transactions via the model
  execute_transactions(1);

  #(CLK_PERIOD * 5);

  // Send TX CTRL new value
  tb_test_data = '{32'd1};
  enqueue_transaction(1'b1, 1'b1, 4'hC, tb_test_data, 1'b0, 2'd0);

  enqueue_transaction(1'b1, 1'b0, 4'hC, tb_test_data, 1'b0, 2'd0);
  // Run the transactions via the model
  execute_transactions(2);

  #(CLK_PERIOD * 40);

   // Send TX CTRL new value
  tb_test_data = '{32'd0};
  enqueue_transaction(1'b1, 1'b1, 4'hC, tb_test_data, 1'b0, 2'd0);

  enqueue_transaction(1'b1, 1'b0, 4'hC, tb_test_data, 1'b0, 2'd0);
  // Run the transactions via the model
  execute_transactions(2);

    #(CLK_PERIOD * 40);

  // tb_test_data = '{32'd1};
  // // read error register
  // enqueue_transaction(1'b1, 1'b0, 4'h7, tb_test_data, 1'b0, 2'd0);
  // // Run the transactions via the model
  // execute_transactions(1);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'd1;
  tb_expected_hready = 1'b1;
  // Check the DUT outputs
  //check_outputs("TX ERROR");

  #(CLK_PERIOD * 3);

  $stop;
end

endmodule

