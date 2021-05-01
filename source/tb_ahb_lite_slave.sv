// $Id: $
// File name:   tb_ahb_lite_slave.sv
// Created:     4/21/2021
// Author:      Lohith Chittineni
// Lab Section: 3
// Version:     1.0  Initial Design Entry
// Description: Full ABH-Lite slave/bus model test bench - NO BURST

`timescale 1ns / 10ps

module tb_ahb_lite_slave();

// Timing related constants
localparam CLK_PERIOD = 10;
localparam BUS_DELAY  = 800ps; // Based on FF propagation delay

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
integer                tb_i;

//*****************************************************************************
// General System signals
//*****************************************************************************
logic tb_clk;
logic tb_n_rst;

// Expected value check signals
logic                   tb_expected_hresp;
logic [DATA_MAX_BIT:0]  tb_expected_hrdata;
logic [7:0]             tb_expected_tx_data;
logic [7:0]             tb_expected_rx_data;
logic                   tb_expected_hready;

//*****************************************************************************
// AHB-Lite-Slave side signals
//*****************************************************************************
logic                          tb_hsel;
logic [1:0]                    tb_htrans;
logic [2:0]                    tb_hburst;
logic [(ADDR_WIDTH - 1):0]     tb_haddr;
logic [2:0]                    tb_hsize;
logic                          tb_hwrite;
logic [((DATA_WIDTH*8) - 1):0] tb_hwdata;
logic [((DATA_WIDTH*8) - 1):0] tb_hrdata;
logic                          tb_hresp;
logic                          tb_hready;
logic [2:0]                    tb_rx_packet;
logic                          tb_rx_data_ready;
logic                          tb_rx_trans_active;
logic                          tb_rx_error;
logic [6:0]                    tb_buffer_occupancy;
logic [7:0]                    tb_rx_data;
logic                          tb_tx_trans_active;
logic                          tb_tx_error;
logic                          tb_clear;
logic                          tb_get_rx_data;
logic                          tb_store_tx_data;
logic [7:0]                    tb_tx_data;
logic [2:0]                    tb_tx_packet;

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
ahb_lite_slave TM ( .clk(tb_clk), .n_rst(tb_n_rst),
                        // AHB-Lite-Slave Side Bus
                        .hsel(tb_hsel),
                        .haddr(tb_haddr),
                        .hsize(tb_hsize[1:0]),
                        .htrans(tb_htrans),
                        .hwrite(tb_hwrite),
                        .hwdata(tb_hwdata),
                        .hrdata(tb_hrdata),
                        .hresp(tb_hresp),
                        .hready(tb_hready),
                        .rx_packet(tb_rx_packet),
                        .rx_data_ready(tb_rx_data_ready),
                        .rx_trans_active(tb_rx_trans_active),
                        .rx_error(tb_rx_error),
                        .buffer_occupancy(tb_buffer_occupancy),
                        .rx_data(tb_rx_data),
                        .tx_trans_active(tb_tx_trans_active),
                        .tx_error(tb_tx_error),
                        .clear(tb_clear),
                        .get_rx_data(tb_get_rx_data),
                        .store_tx_data(tb_store_tx_data),
                        .tx_data(tb_tx_data),
                        .tx_packet(tb_tx_packet));

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

  if(tb_expected_tx_data == tb_tx_data) begin // Check passed
    $info("Correct 'tx_data' output %s during %s test case", check_tag, tb_test_case);
  end
  else begin // Check failed
    tb_mismatch = 1'b1;
    $error("Incorrect 'tx_data' output %s during %s test case", check_tag, tb_test_case);
  end

  // Wait some small amount of time so check pulse timing is visible on waves
  #(0.1);
  tb_check =1'b0;
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
  #(0.1);

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

  // No actual DUT -> Just a place holder currently
  
  //*****************************************************************************
  // Test Case: Read Status - New Data
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "READ STATUS NEW DATA";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_test_data = '{32'd0001}; 
  tb_rx_data_ready = 1'b1;
  enqueue_transaction(1'b1, 1'b0, 4'h4, tb_test_data, 1'b0, 2'd0);
  
  // Run the transactions via the model
  execute_transactions(1);
  
  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = {16'd0,16'h0001};
  tb_expected_hready = 1'b1;
  tb_expected_tx_data = 8'd0;
  check_outputs("after attempting to send new data status");

  // Undo assertions
  tb_rx_data_ready = 1'b0;

  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

   //*****************************************************************************
  // Test Case: Read Status - IN
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "READ STATUS IN";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_test_data = '{32'd0002}; 
  tb_rx_packet = 3'd1;
  enqueue_transaction(1'b1, 1'b0, 4'h4, tb_test_data, 1'b0, 2'd0);
  
  // Run the transactions via the model
  execute_transactions(1);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = {16'd0,16'h0002};
  tb_expected_hready = 1'b1;
  tb_expected_tx_data = 8'd0;
  check_outputs("after attempting to send IN");

  // Undo assertions
  tb_rx_packet = 3'd0;

  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Write/Read to Flush Register
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Write/Read Flush Register";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

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
  tb_expected_tx_data = 8'd0;
  // Check the DUT outputs
   check_outputs("after write/read flush register");
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Read Buffer Occupancy
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Read Buffer Occupancy";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_test_data = '{32'd16}; 
  tb_buffer_occupancy = 7'd16;
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 4'h8, tb_test_data, 1'b0, 2'd0);
  
  // Run the transactions via the model
  execute_transactions(1);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'd16;
  tb_expected_hready = 1'b1;
  tb_expected_tx_data = 8'd0;
  // Check the DUT outputs
  check_outputs("Read Buffer Occupancy");

  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Write to Data Buffer Register
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Write to Data Buffer Register";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_test_data = '{32'h14131211}; 
  enqueue_transaction(1'b1, 1'b1, 4'h0, tb_test_data,1'b0, 2'd3);
  
  // Run the transactions via the model
  execute_transactions(1);
  #(CLK_PERIOD * 3);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'd0;
  tb_expected_hready = 1'b1;
  tb_expected_tx_data = 8'h14;
  // Check the DUT outputs
  check_outputs("Write to Data Buffer Register");
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);


  //*****************************************************************************
  // Test Case: Read Data Buffer Register
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Read Data Buffer Register";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_test_data = '{8'h0};
  tb_rx_data = 8'h11;
  enqueue_transaction(1'b1, 1'b0, 4'h0, tb_test_data,1'b0, 2'd3);
  // Run the transactions via the model
  execute_transactions(1);
  tb_rx_data = 8'h12;
  #(CLK_PERIOD);
  tb_rx_data = 8'h13;
  #(CLK_PERIOD);
  tb_rx_data = 8'h14;
  #(CLK_PERIOD);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'h14131211;
  tb_expected_hready = 1'b1;
  tb_expected_tx_data = 8'd0;
  // Check the DUT outputs
  check_outputs("Read Data Buffer Register");
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Write to Data Buffer Register - 3 Bytes
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Write to Data Buffer Register 3 Bytes";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_test_data = '{32'h14131211}; 
  enqueue_transaction(1'b1, 1'b1, 4'h0, tb_test_data,1'b0, 2'd2);
  
  // Run the transactions via the model
  execute_transactions(1);
  #(CLK_PERIOD * 2);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'd0;
  tb_expected_hready = 1'b1;
  tb_expected_tx_data = 8'h13;
  // Check the DUT outputs
  check_outputs("Write to Data Buffer Register 3 Bytes");
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

   //*****************************************************************************
  // Test Case: Read Data Buffer Register - 3 Bytes
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Read Data Buffer Register 3 Bytes";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_test_data = '{8'h0};
  tb_rx_data = 8'h11;
  enqueue_transaction(1'b1, 1'b0, 4'h0, tb_test_data,1'b0, 2'd2);
  // Run the transactions via the model
  execute_transactions(1);
  tb_rx_data = 8'h12;
  #(CLK_PERIOD);
  tb_rx_data = 8'h13;
  #(CLK_PERIOD);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'h00131211;
  tb_expected_hready = 1'b1;
  tb_expected_tx_data = 8'd0;
  // Check the DUT outputs
  check_outputs("Read Data Buffer Register 3 Bytes");
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Write to Data Buffer Register - Buffer overflow
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Buffer Overflow Write";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_test_data = '{32'h14131211}; 
  tb_buffer_occupancy = 7'd64;
  enqueue_transaction(1'b1, 1'b1, 4'h0, tb_test_data,1'b0, 2'd3);
  
  // Run the transactions via the model
  execute_transactions(1);
  #(CLK_PERIOD * 3);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'd0;
  tb_expected_hready = 1'b1;
  tb_expected_tx_data = 8'h0;
  // Check the DUT outputs
  check_outputs("Buffer Overflow Write");
  tb_buffer_occupancy = 7'd0;
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Read Data Buffer Register - Buffer Occupancy 0
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Buffer Occupancy 0";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_test_data = '{8'h0};
  tb_buffer_occupancy = 7'd0;
  tb_rx_data = 8'h11;
  enqueue_transaction(1'b1, 1'b0, 4'h0, tb_test_data,1'b0, 2'd3);
  // Run the transactions via the model
  execute_transactions(1);
  tb_rx_data = 8'h12;
  #(CLK_PERIOD);
  tb_rx_data = 8'h13;
  #(CLK_PERIOD);
  tb_rx_data = 8'h14;
  #(CLK_PERIOD);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'h0;
  tb_expected_hready = 1'b1;
  tb_expected_tx_data = 8'd0;
  // Check the DUT outputs
  check_outputs("Buffer Occupancy 0");
  tb_buffer_occupancy = 7'd16;
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Write/ Read TX Packet CTRL Reg
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Write/ Read TX Packet CTRL Reg";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

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
  tb_expected_tx_data = 8'd0;
  // Check the DUT outputs
  check_outputs("Write/ Read TX Packet CTRL Reg");
 
  // Give some visual spacing between check and next test case start
  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Read Error Register
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Read Error Register";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_tx_error = 1'b1;
  tb_test_data = '{32'd1}; 
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 4'h6, tb_test_data, 1'b0, 2'd1);
  
  // Run the transactions via the model
  execute_transactions(1);

  // Check the DUT outputs
  tb_expected_hresp = 1'b0;
  tb_expected_hrdata = 32'd1;
  tb_expected_hready = 1'b1;
  tb_expected_tx_data = 8'd0;
  // Check the DUT outputs
  check_outputs("Read Error Register");

  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Read Out of Range Address
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Read Out of Range Address";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_tx_error = 1'b1;
  tb_test_data = '{32'd0}; 
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b0, 4'hE, tb_test_data, 1'b1, 2'd1);
  
  // Run the transactions via the model
  execute_transactions(1);

  // Check the DUT outputs
  tb_expected_hresp = 1'b1;
  tb_expected_hrdata = 32'd0;
  tb_expected_hready = 1'b0;
  tb_expected_tx_data = 8'd0;
  // Check the DUT outputs
  check_outputs("Read Out of Range Address");

  #(CLK_PERIOD * 3);

  //*****************************************************************************
  // Test Case: Write to Read only
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Write to Read only";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_tx_error = 1'b1;
  tb_test_data = '{32'd0}; 
  // Enqueue the 'check' read
  enqueue_transaction(1'b1, 1'b1, 4'h8, tb_test_data, 1'b1, 2'd1);
  
  // Run the transactions via the model
  execute_transactions(1);

  // Check the DUT outputs
  tb_expected_hresp = 1'b1;
  tb_expected_hrdata = 32'd0;
  tb_expected_hready = 1'b0;
  tb_expected_tx_data = 8'd0;
  // Check the DUT outputs
  check_outputs("Write to Read only");

  #(CLK_PERIOD * 3);

 
  // //*****************************************************************************
  // // Test Case: Back-to-Back Write/Read
  // //*****************************************************************************
  // // Update Navigation Info
  // tb_test_case     = "Back to back Write/Read";
  // tb_test_case_num = tb_test_case_num + 1;

  // // Reset the DUT to isolate from prior test case
  // reset_dut();

  // // Enqueue the needed transactions
  // tb_test_data = '{32'hADAD8000};
  // // Enqueue the write
  // enqueue_transaction(1'b1, 1'b1, 8'd70, tb_test_data, 1'b0, 2'd2);
  // // Enqueue the 'check' read
  // enqueue_transaction(1'b1, 1'b0, 8'd70, tb_test_data, 1'b0, 2'd2);
  
  // // Run the transactions via the model
  // execute_transactions(2);

  // // Check the DUT outputs
  // check_outputs("after attempting to send a sample");

  // // Give some visual spacing between check and next test case start
  // #(CLK_PERIOD * 3);
  $stop;
end

endmodule
