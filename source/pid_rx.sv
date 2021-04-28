module pid_rx (
  input logic clk,
  input logic n_rst,
  input logic [7:0] rcv_data,
  input logic PID_clear,
  input logic PID_mode,
  output logic PID_err,
  output logic [3:0] rx_packet,
  output logic [3:0] PID_byte
);
  logic [7:0] hold;
  logic [7:0] next_hold;

  assign rx_packet = hold[7:4];

  localparam out = 8'b10000111;
  localparam in = 8'b10010110;
  localparam data0 = 8'b11000011;
  localparam data1 = 8'b11010010;
  localparam ack = 8'b01001011;
  //localparam nak = 4'b1010;
  //localparam stall = 4'b1110;

  //ff logic
  always_ff @(posedge clk, negedge n_rst) 
  begin
    if (n_rst == 0) 
    begin
      hold <= '1;
    end else 
    begin
      hold <= next_hold;
    end
  end

  //comb logic for PID byte into rx_data
  always_comb 
  begin
    next_hold = hold;
    if (PID_clear) 
    begin
      next_hold = '1;
    end
    if(PID_mode) 
    begin
      next_hold = rcv_data;
    end
  end

  // 0010 0100 1011 first flipped and then flipped inverse
  //assign PID_byte = { rx_packet[0],rx_packet[1],rx_packet[2],rx_packet[3],
   //                   ~rx_packet[0],~rx_packet[1],~rx_packet[2],~rx_packet[3]};

  assign PID_byte = rx_packet;

  assign PID_err = !((rx_packet == data0[7:4]) || 
                     (rx_packet == data1[7:4]) || 
                     (rx_packet == ack[7:4]) || 
                     (rx_packet == in[7:4]) || 
                     (rx_packet == out[7:4]));

endmodule