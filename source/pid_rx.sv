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

  assign rx_packet = {hold[4],hold[5],hold[6],hold[7]};

  localparam out = 4'b0001;
  localparam in = 4'b1001;
  localparam data0 = 4'b0011;
  localparam data1 = 4'b1011;
  localparam ack = 4'b0010;
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

  assign PID_err = !((rx_packet == data0) || 
                     (rx_packet == data1) || 
                     (rx_packet == ack) || 
                     (rx_packet == in) || 
                     (rx_packet == out));

endmodule