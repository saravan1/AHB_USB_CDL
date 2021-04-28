module shift_register (
  input logic clk,
  input logic n_rst,
  input logic shift_enable,
  input logic d_sent,
  output logic [23:0] rcv_data
  output logic [7:0] rx_packet_data;
);
  
  logic hold;
  
  assign hold =  shift_enable & ~stuff_bit;

  flex_stp_sr #(.NUM_BITS(24), .SHIFT_MSB(1)) flex_stp (.clk(clk), .n_rst(n_rst), .shift_enable(hold), .serial_in(d_sent), .parallel_out(rcv_data));
  assign rx_packet_data = rcv_data[7:0];
endmodule