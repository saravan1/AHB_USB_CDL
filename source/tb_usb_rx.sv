`timescale 1ns / 10ps

module tb_usb_rx ();
  localparam  CLK_PERIOD    = 10;

  logic tb_clk;
  logic tb_n_rst;
  logic tb_dplus_in;
  logic tb_dminus_in;
  logic tb_r_enable;
  logic [6:0] tb_buffer_occupancy;
  logic [7:0] tb_rx_packet_data;
  logic [3:0] tb_rx_packet;
  logic tb_store_rx_packet_data;
  logic tb_flush;
  logic tb_rx_error;
  logic tb_rx_trans_active;
  logic tb_rx_data_ready;
  logic [7:0] tb_test_byte;
  logic [3:0] tb_PID;
  logic [3:0] tb_expected_PID;
  logic [7:0] tb_expected_rx_packet_data;
  logic tb_expected_rx_error;
  integer tb_count_one;
  integer tb_bit_num;
  integer tb_test_num;
  string tb_test_description;

  task reset_dut;
  begin
    tb_n_rst = 0;

    @(posedge tb_clk);
    @(posedge tb_clk);

    @(negedge tb_clk);
    
    tb_n_rst = 1;

    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask

  task send_byte;
    input logic [7:0] target;
    integer i;
    integer count_one;
  begin
    @(posedge tb_clk);
    tb_bit_num = 0;
    for(i = 0; i < 8; i++ ) begin
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
    tb_bit_num = 0;
 //   for(i = 0; i < 3; i++ ) begin
    tb_dplus_in = 0;
    tb_dminus_in = 0;
    #(CLK_PERIOD * 5);
    tb_bit_num++;
 //   end
    tb_dplus_in = 1;
    #(CLK_PERIOD * 8);
  end
  endtask

  task send_bit;
    input logic target;
  begin
    if(target) begin
      tb_count_one++;
    end
    if(target == 0) begin
        tb_dplus_in =  ~tb_dplus_in;
        tb_dminus_in = ~tb_dplus_in;
        tb_count_one = 0;
    end
    #(CLK_PERIOD * 5);
    tb_bit_num ++;
    // if(!(tb_count_one < 6)) begin
    //     tb_count_one = 0;
    //     tb_dplus_in =  ~tb_dplus_in;
    //     tb_dminus_in = ~tb_dplus_in;
    //     #(CLK_PERIOD * 8);
    //     tb_bit_num ++;
    // end
  end
  endtask

  // task read_fifo;
  //  [7:0] expected_out;
  // begin
  //   if(tb_r_data == expected_out) begin
  //     $info("All Good, test case: %d. %s", tb_test_num, tb_test_description);
  //   end else begin
  //     $info("Bad Output: %d. %s", tb_test_num, tb_test_description);
  //   end
  //   @(negedge tb_clk);
  //   tb_r_enable = 1;
  //   #(CLK_PERIOD);
  //   tb_r_enable = 0;
  //   #(CLK_PERIOD * 3);
  // end
  // endtask

  task check_outputs;
  begin
    if(tb_rx_error == tb_expected_rx_error) begin
      $info("Correct rx error output: %d. %s", tb_test_num, tb_test_description);
    end else begin
      $info("Incorrect rx error output: %d. %s", tb_test_num, tb_test_description);
    end
    
    if(tb_rx_packet_data == tb_expected_rx_packet_data) begin
      $info("Correct rx_packet_data output: Pid: %d. %s", tb_test_num, tb_test_description);
    end 
    else begin
      $info("Incorrect rx_packet_data output: %d. %s", tb_test_num, tb_test_description);
    end
  end
  endtask

  task check_PID;
  begin
   if(tb_rx_packet == tb_expected_PID) begin
      $info("Correct rx_packet output: Pid: %d. %s", tb_test_num, tb_test_description);
    end 
    else begin
      $info("Incorrect rx_packet output: %d. %s", tb_test_num, tb_test_description);
    end
  end
  endtask

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

  usb_rx DUT (.clk(tb_clk),.n_rst(tb_n_rst),.dplus_in(tb_dplus_in),.dminus_in(tb_dminus_in),
    .buffer_occupancy(tb_buffer_occupancy),.rx_packet_data(tb_rx_packet_data),.rx_packet(tb_rx_packet),
    .store_rx_packet_data(tb_store_rx_packet_data),.flush(tb_flush),.rx_error(tb_rx_error),
    .rx_trans_active(tb_rx_trans_active),.rx_data_ready(tb_rx_data_ready)
  );
  

  // begin
  initial begin
    tb_n_rst = 1;
    tb_dplus_in = 1;
    tb_dminus_in = 0;
    tb_r_enable = 0;
    tb_bit_num = 0;
    tb_test_num = 0;
    tb_expected_PID = '1;
    tb_count_one = 0;
    tb_buffer_occupancy = 7'd16;

    // Test Case 1 // 
    // reset DUT
    tb_test_num++;
    tb_test_description = "reset DUT";
    tb_bit_num = 0;
    reset_dut();
    #(CLK_PERIOD * 3);

    // Test Case 2 // 
    // send a an ACK
    tb_test_num++;
    tb_test_description = "send a ACK";
    tb_bit_num = 0;
    tb_expected_PID = 4'b0010;
    tb_expected_rx_error = 1'b0;
    tb_expected_rx_packet_data = 8'b11111111;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b0010;
    send_PID(tb_PID);
    #(CLK_PERIOD * 3);
    check_PID();
    check_outputs();
    send_eop();


    // Test Case 3// 
    // send a Data0
    tb_test_num++;
    tb_test_description = "send Data0";
    tb_bit_num = 0;
    tb_expected_PID = 4'b0011;
    tb_expected_rx_error = 1'b0;
    tb_expected_rx_packet_data = 8'b01010101;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b0011;
    send_PID(tb_PID);
    #(CLK_PERIOD * 1);
    check_PID();
    send_byte(8'b10101010);
    #(CLK_PERIOD * 1);
    send_byte(8'b11111111);
    #(CLK_PERIOD * 1);
    send_byte(8'b11111111);
    check_outputs();
    send_eop();

    //  // Test Case 4// 
    // send a Data1
    tb_test_num++;
    tb_test_description = "send Data1";
    tb_bit_num = 0;
    tb_expected_PID = 4'b1011;
    tb_expected_rx_error = 1'b0;
    tb_expected_rx_packet_data = 8'b00110011;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b1011;
    send_PID(tb_PID);
    #(CLK_PERIOD * 1);
    check_PID();
    send_byte(8'b11001100);
    #(CLK_PERIOD * 1);
    send_byte(8'b11111111);
    #(CLK_PERIOD * 1);
    send_byte(8'b11111111);
    check_outputs();
    send_eop();

    // // Test Case 5// 
    // // send a Data0
    tb_test_num++;
    tb_test_description = "send Data1 Multiple Bytes";
    tb_bit_num = 0;
    tb_expected_PID = 4'b1011;
    tb_expected_rx_error = 1'b0;
    tb_expected_rx_packet_data = 8'b01000000;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b1011;
    send_PID(tb_PID);
    #(CLK_PERIOD * 1);
    check_PID();
    send_byte(8'b10101010);
     #(CLK_PERIOD * 1);
    send_byte(8'b10101010);
     #(CLK_PERIOD * 1);
    send_byte(8'b10101010);
     #(CLK_PERIOD * 1);
    send_byte(8'b10101010);
     #(CLK_PERIOD * 1);
    send_byte(8'b00000010);
     #(CLK_PERIOD * 1);
    send_byte(8'b11111111);
     #(CLK_PERIOD * 1);
    send_byte(8'b11111111);
    check_outputs();
    send_eop();
   

    // Test Case 6// 
    // send a Data0
    tb_test_num++;
    tb_test_description = "send Data1 - 2Bytes";
    tb_bit_num = 0;
    tb_expected_PID = 4'b1011;
    tb_expected_rx_error = 1'b0;
    tb_expected_rx_packet_data = 8'b11010010;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b1011;
    send_PID(tb_PID);
    #(CLK_PERIOD * 1);
    check_PID();
    send_byte(8'b10101010);
    #(CLK_PERIOD * 1);
    send_byte(8'b11111111);
    check_outputs();
    send_eop();

    // Test Case 7// 
    // send a Data0
    tb_test_num++;
    tb_test_description = "send Data1 - 1Bytes";
    tb_bit_num = 0;
    tb_expected_PID = 4'b1011;
    tb_expected_rx_error = 1'b0;
    tb_expected_rx_packet_data = 8'b00000001;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b1011;
    send_PID(tb_PID);
    #(CLK_PERIOD * 1);
    check_PID();
    send_byte(8'b10101010);
    check_outputs();
    send_eop();

    // Test Case 7
    // send a IN
    tb_test_num++;
    tb_test_description = "send Token - IN";
    tb_bit_num = 0;
    tb_expected_PID = 4'b1001;
    tb_expected_rx_error = 1'b0;
    tb_expected_rx_packet_data = 8'b10010110;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b1001;
    send_PID(tb_PID);
    #(CLK_PERIOD * 1);
    check_PID();
    send_byte(8'b10101010);
    #(CLK_PERIOD * 1);
    send_byte(8'b10101010);
    check_outputs();
    send_eop();

    // Test Case 8
    // send a OUT
    tb_test_num++;
    tb_test_description = "send Token - OUT";
    tb_bit_num = 0;
    tb_expected_PID = 4'b0001;
    tb_expected_rx_error = 1'b0;
    tb_expected_rx_packet_data = 8'b10000111;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b0001;
    send_PID(tb_PID);
    #(CLK_PERIOD * 1);
    check_PID();
    send_byte(8'b10101010);
    #(CLK_PERIOD * 1);
    send_byte(8'b10101010);
    check_outputs();
    send_eop();
    
    // // Test Case 9
    // // send a Data0
    tb_test_num++;
    tb_test_description = "send Token - OUT Error";
    tb_bit_num = 0;
    tb_expected_PID = 4'b0001;
    tb_expected_rx_error = 1'b0;
    tb_expected_rx_packet_data = 8'b00000001;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b0001;
    send_PID(tb_PID);
    #(CLK_PERIOD * 1);
    check_PID();
    send_byte(8'b10101010);
    #(CLK_PERIOD * 3);
    check_outputs();
    send_eop();

    // // Test Case 10
    // // send a Data0
    tb_test_num++;
    tb_test_description = "send Token - IN Error";
    tb_bit_num = 0;
    tb_expected_PID = 4'b1001;
    tb_expected_rx_error = 1'b0;
    tb_expected_rx_packet_data = 8'b00000001;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b1001;
    tb_expected_PID = 4'b1001;
    send_PID(tb_PID);
    #(CLK_PERIOD * 1);
    check_PID();
    send_byte(8'b10101010);
    #(CLK_PERIOD * 3);
    check_outputs();
    send_eop();

    // // Test Case 11
    // // send a Data0
    tb_test_num++;
    tb_test_description = "Invalid PID";
    tb_bit_num = 0;
    tb_expected_PID = 4'b1111;
    tb_expected_rx_error = 1'b1;
    tb_expected_rx_packet_data = 8'b11111111;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_sync();
    tb_PID = 4'b1111;
    send_PID(tb_PID);
    #(CLK_PERIOD * 1);
    check_PID();
    #(CLK_PERIOD * 2);
    check_outputs();
    send_eop();

    // // Test Case 12
    // // invalid sync
    tb_test_num++;
    tb_test_description = "Invalid Sync";
    tb_bit_num = 0;
    tb_expected_PID = 4'b1001;
    tb_expected_rx_error = 1'b1;
    tb_expected_rx_packet_data = 8'b11111111;
    reset_dut();
    #(CLK_PERIOD * 3);
    send_byte(8'b10101010);
    #(CLK_PERIOD * 3);
    check_outputs();
    send_eop();
    $stop;


  //   // Test Case 3 //
  //   // send three byte
  //   tb_test_num++;
  //   tb_test_description = "send three bytes";
  //   tb_bit_num = 0;
  //   reset_dut();
  //   #(CLK_PERIOD * 3);
  //   send_sync();
  //   tb_expected_PID = 4'b0001;
  //   send_PID(tb_expected_PID);
  //   check_PID(tb_expected_PID);
  //   tb_test_byte = 8'b00000000;
  //   send_byte(tb_test_byte);
  //   tb_test_byte = 8'b01000000;
  //   send_byte(tb_test_byte);
  //   tb_test_byte = 8'b01100001;
  //   send_byte(tb_test_byte);
  //   send_eop();
  //   #(CLK_PERIOD * 3);
  //  // read_fifo(8'b00000000);
  //   #(CLK_PERIOD);
  //  // read_fifo(8'b01000000);
  //   #(CLK_PERIOD);
  // //  read_fifo(8'b01100001);

  //   // Test Case 4 // 
  //   // SYNC Error case
  //   tb_test_num++;
  //   tb_test_description = "SYNC err case";
  //   tb_bit_num = 0;
  //   reset_dut();
  //   #(CLK_PERIOD * 3);
  //   send_bit(0);
  //   send_bit(0);
  //   send_bit(0);
  //   send_bit(0);
  //   send_bit(0);
  //   send_bit(0);
  //   send_bit(0);
  //   send_bit(0);
  //   tb_test_byte = 8'b01010000;
  //   tb_expected_PID = 4'b0001;
  //   send_PID(tb_expected_PID);
  //   check_err();
  //   send_byte(tb_test_byte);
  //   send_eop();
  //   #(CLK_PERIOD * 8);

//     // test case 5 EOP err case
//     tb_test_num++;
//     tb_test_description = " EOP err case";
//     tb_bit_num = 0;
//     reset_dut();
//     #(CLK_PERIOD * 3);

//     send_sync();
//     tb_expected_PID = 4'b0001;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     send_bit(0);
//     send_bit(0);
//     send_bit(0);
//     send_bit(0);
//     send_bit(0);
//     send_eop();

//     #(CLK_PERIOD * 3);
//     send_sync();
//     tb_expected_PID = 4'b0001;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     send_eop();

//     //test case 6 immediate another packet with PID change
//     tb_test_num++;
//     tb_test_description = "immediate another packet with PID change";
//     tb_bit_num = 0;
//     reset_dut();
//     #(CLK_PERIOD * 3);

//     send_sync();
//     tb_expected_PID = 4'b0001;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     send_eop();

//     send_sync();
//     tb_expected_PID = 4'b1011;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     tb_test_byte = 8'b10000001;
//     send_byte(tb_test_byte);
//     send_eop();
//     read_fifo(tb_test_byte);

//     //test case 7 incorrect PID value err case 
//     tb_test_num++;
//     tb_test_description = "incorrect PID err case";
//     tb_bit_num = 0;
//     reset_dut();
//     #(CLK_PERIOD * 3);

//     send_sync();
//     send_PID(4'b1111);
//     tb_test_byte = 8'b10000001;
//     send_byte(tb_test_byte);
//     send_eop();
    
//     //test case 8 EOP during PID_RCV err case 
//     tb_test_num++;
//     tb_test_description = "EOP during PID_RCV err case";
//     tb_bit_num = 0;
//     reset_dut();
//     #(CLK_PERIOD * 3);

//     send_sync();
//     send_bit(1);
//     send_bit(1);
//     send_bit(0);
//     send_bit(1);
//     send_eop();

//     // test case 9 check all possible PID
//     tb_test_num++;
//     tb_test_description = "test case 9 check all possible PID";
//     tb_bit_num = 0;
//     reset_dut();
//     #(CLK_PERIOD * 3);

//     send_sync();
//     tb_expected_PID = 4'b0001;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     send_eop();

//     send_sync();
//     tb_expected_PID = 4'b1001;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     send_eop();

//     send_sync();
//     tb_expected_PID = 4'b0011;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     send_eop();

//     send_sync();
//     tb_expected_PID = 4'b1011;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     send_eop();

//     send_sync();
//     tb_expected_PID = 4'b0010;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     send_eop();

//     send_sync();
//     tb_expected_PID = 4'b1010;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     send_eop();

//     send_sync();
//     tb_expected_PID = 4'b1110;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     send_eop();

//     // test case 10 bit stuffing
//     tb_test_num++;
//     tb_test_description = "bit stuffing";
//     tb_bit_num = 0;
//     reset_dut();
//     #(CLK_PERIOD * 3);

//     send_sync();
//     tb_expected_PID = 4'b1011;
//     send_PID(tb_expected_PID);
//     check_PID(tb_expected_PID);
//     tb_test_byte = 8'b11111111;
//     send_byte(tb_test_byte);
//     tb_test_byte = 8'b11110111;
//     send_byte(tb_test_byte);
//     tb_test_byte = 8'b11001111;
//     send_byte(tb_test_byte);
//     send_eop();
//     #(CLK_PERIOD * 3);
//     read_fifo(8'b11111111);
//     #(CLK_PERIOD);
//     read_fifo(8'b11110111);
//     #(CLK_PERIOD);
//     read_fifo(8'b11001111);
    
   end


 endmodule