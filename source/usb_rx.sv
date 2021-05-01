module usb_rx (
  input logic clk,
  input logic n_rst,
  input logic dplus_in,
  input logic dminus_in,
  input logic [6:0] buffer_occupancy,
  output logic [7:0] rx_packet_data,
  output logic [3:0] rx_packet,
  output logic store_rx_packet_data,
  output logic flush,
  output logic rx_error,
  output logic rx_trans_active,
  output logic rx_data_ready
);

  //file variables used for input holds and reg holds
  logic dplus_in_sync;
  logic dminus_in_sync;
  logic edge_detect;
  logic d_sent;
  logic EOP_detect;
  logic shift_enable;
  logic [23:0] recv_data;
  // logic [7:0] sync_byte_data;
  // logic [7:0] pid_data;
  // logic PID_mode;
  // logic PID_error;
  // logic PID_clear;
  // logic [3:0] PID_byte;
  logic enable_timer;
  logic byte_received;

  //main mapped working
  // sync_high s_h (
  //   .clk(clk), 
  //   .n_rst(n_rst), 
  //   .async_in(dplus_in), 
  //   .sync_out(dplus_in_sync));

  
  sync_high s_h (
    .clk(clk), 
    .n_rst(n_rst), 
    .async_in(dplus_in), 
    .sync_out(dplus_in_sync));

  sync_low s_l (
    .clk(clk), 
    .n_rst(n_rst), 
    .async_in(dminus_in), 
    .sync_out(dminus_in_sync));

  edge_detector e1 (
    .clk(clk), 
    .n_rst(n_rst), 
    .dplus_in(dplus_in_sync), 
    .edge_detect(edge_detect));

  EOP_detector ep1 (
    .dplus_in(dplus_in_sync), 
    .dminus_in(dminus_in_sync), 
    .eop(EOP_detect));

  decoder d1 (
    .clk(clk), 
    .n_rst(n_rst), 
    .dplus_in(dplus_in_sync), 
    .shift_enable(shift_enable), 
    .eop(EOP_detect), 
    .d_sent(d_sent));

  timer_rx t1 (
    .clk(clk), 
    .n_rst(n_rst), 
    .enable_timer(enable_timer), 
    .shift_enable(shift_enable), 
    .byte_sent(byte_received));

  shift_register s1 (
    .clk(clk), 
    .n_rst(n_rst), 
    .shift_enable(shift_enable), 
    .d_sent(d_sent), 
    .rcv_data(recv_data), 
    .rx_packet_data(rx_packet_data)
    // .sync_byte_data(sync_byte_data),
    // .pid_data(pid_data)
    );
  
  control_rx c1 (
    .clk(clk), 
    .n_rst(n_rst), 
    .edge_detect(edge_detect), 
    .eop(EOP_detect), 
    .shift_enable(shift_enable), 
    .rcv_data(recv_data[7:0]), 
    .byte_received(byte_received), 
    // .PID_error(PID_error), 
    // .PID_byte(PID_byte), 
    .write_en(store_rx_packet_data), 
    .rx_err(rx_error), 
    // .PID_clear(PID_clear), 
    // .PID_mode(PID_mode), 
    .buffer_occupancy(buffer_occupancy),
    .rx_trans_active(rx_trans_active), 
    .rx_data_ready(rx_data_ready),
    .rx_packet(rx_packet),
    .enable_timer(enable_timer),
    .flush(flush));

  // pid_rx p1 (
  //   .clk(clk), 
  //   .n_rst(n_rst),
  //   .rcv_data(pid_data), 
  //   .PID_clear(PID_clear), 
  //   .PID_mode(PID_mode), 
  //   .PID_err(PID_error), 
  //   .rx_packet(rx_packet), 
  //   .PID_byte(PID_byte));
  
endmodule