module shift_register (
  input logic clk,
  input logic n_rst,
  input logic shift_enable,
  input logic d_sent,
  output logic [23:0] rcv_data,
  output logic [7:0] rx_packet_data
  // output logic [7:0] sync_byte_data,
  // output logic [7:0] pid_data

);
  flex_stp_sr #(.NUM_BITS(24), .SHIFT_MSB(1)) flex_stp (.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable), .serial_in(d_sent), .parallel_out(rcv_data));
  always_comb begin
    rx_packet_data = rcv_data[23:16];
  end
  // assign rx_packet_data = rcv_data[23:16];
  // assign sync_byte_data = rcv_data[7:0];
  // assign pid_data = rcv_data[7:0];
endmodule