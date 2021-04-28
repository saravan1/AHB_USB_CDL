module control_rx (
  input logic clk,
  input logic n_rst,
  input logic edge_detect,
  input logic eop,
  input logic shift_enable,
  input logic [7:0] rcv_data,
  input logic byte_received,
  input logic PID_error,
  input logic [7:0] PID_byte,
  input logic [6:0] buffer_occupancy,
  output logic write_en,
  output logic EOP_err,
  output logic PID_clear,
  output logic PID_mode,
  output logic rx_data_ready,
  output logic rx_trans_active
);

  typedef enum bit[4:0] {IDLE, SYN_CHK, 
                         PID_WAIT, PID_RECV, PID_WRITE, PID_CHECK, 
                         WAIT, RECV, WRITE,
                         TOKEN, TOKEN2, TOKEN_IDLE,
                         DATA_DLE, DATA1, DATA2, DATA3, 
                         EOP_IDLE,EOP, RX_ERR, DONE} statelogic;
  statelogic state;
  statelogic n_state;

  // logic [4:0] out;
  // assign recieved = out[4];
  // assign write_en = out[3];
  // assign EOP_err = out[2];
  // assign PID_clear = out[1];
  // assign PID_mode = out[0];
  
  // localparam hold_byte = 8'b10000000;
  // localparam idle_byte = '0;
  // localparam sync_byte = 5'b10010;
  // localparam pid_byte = 5'b10000;
  // localparam write_byte = 5'b10001;
  // localparam final_byte = 5'b11000;
  // localparam eop_byte = 5'b10100;
  // localparam closeout = 5'b00100;

  //ff logic on posedge and negedge
  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 0) begin
      state <= IDLE;
    end else begin
      state <= n_state;
    end
  end

  // //output logic 
  // always_comb 
  // begin
  //   out = idle_byte;
  //   case(state)
  //     IDLE: 
  //     begin
  //       out = idle_byte;
  //     end
  //     EOP_IDLE: 
  //     begin
  //       out = eop_byte;
  //     end
  //     SYN_CHK: 
  //     begin
  //       out = sync_byte;
  //     end
  //     PID_WAIT:
  //     begin
  //       out = pid_byte;
  //     end
  //     PID_RECV: 
  //     begin
  //       out = pid_byte;
  //     end
  //     PID_WRITE: 
  //     begin
  //       out = write_byte;
  //     end
  //     PID_CHECK: 
  //     begin
  //       out = pid_byte;
  //     end
  //     WAIT: 
  //     begin
  //       out = pid_byte;
  //     end
  //     EOP: 
  //     begin
  //       out = pid_byte;
  //     end
  //     EOP_ERR: 
  //     begin
  //       out = eop_byte;
  //     end
  //     RECV: 
  //     begin
  //       out = pid_byte;
  //     end
  //     WRITE: 
  //     begin
  //       out = final_byte;
  //     end
  //     DONE: 
  //     begin
  //       out = closeout;
  //     end
  //   endcase
  // end

  // state logic for each round value.
  always_comb 
  begin
    n_state = state;
    case(state)
      IDLE: 
      begin
        if(edge_detect)
        begin
            n_state = SYN_CHK;
        end
      end
      SYN_CHK: 
      begin
       if((rcv_data == hold_byte) && byte_received)
       //if(byte_received)
        begin
          n_state = PID_WAIT;
        end
        else if((rcv_data != hold_byte) && byte_received)
        begin
          n_state = RX_ERR;
        end
      end
      PID_WAIT: 
      begin
        if(shift_enable && !eop)
        begin
          n_state = PID_RECV;
        end
        else if(shift_enable && eop)
        begin
          n_state = EOP_IDLE;
        end
      end
      PID_RECV: 
      begin
        if(shift_enable && eop)
        begin
          n_state = EOP_IDLE;
        end
        else if(byte_received)
        begin
          n_state = PID_WRITE;
        end
      end
      PID_WRITE: 
      begin
        n_state = PID_CHECK;
      end
      PID_CHECK: 
      begin
        if ((PID_byte == 8'b11000011) || (PID_byte == 8'b01001011))
        begin
          n_state = DATA_IDLE;
        end
        else if ((PID_byte == 8'b11100001) || (PID_byte == 8'b01101001))
        begin
          n_state = TOKEN;
        end
        else if(PID_error)
        begin
          n_state = RX_ERR;
        end
        else
        begin
          n_state = WAIT;
        end
      end
      EOP: 
      begin
        if(edge_detect)
        begin
          n_state = IDLE;
        end
      end
      RX_ERR: 
      begin
        if(shift_enable && eop)
        begin
          n_state = EOP_IDLE;
        end
      end
      EOP_IDLE: 
      begin
        if(edge_detect)
        begin
          n_state = DONE;
        end
      end
      WAIT: 
      begin
        if(shift_enable && !eop)
        begin
          n_state = RECV;
        end
        else if(shift_enable && eop)
        begin
          n_state = EOP;
        end
      end
      RECV: 
      begin
        if(byte_received)
        begin
          n_state = WRITE;
        end
        else if(shift_enable && eop)
        begin
          n_state = EOP_IDLE;
        end
      end
      DATA_IDLE:
      begin
        if(byte_received)
        begin
          n_state = DATA1;
        end
        else if(eop)
        begin
          n_state = RX_ERR;
        end
      end
      DATA1:
      begin
        if(byte_received && buffer_occupancy < 7'd63)
        begin
          n_state = DATA2;
        end
        else if(byte_received && buffer_occupancy > 7'd63)
        begin
          n_state = RX_ERR;
        end
        else if(eop)
        begin
          n_state = RX_ERR;
        end
      end
      DATA2:
      begin
        if(byte_received && buffer_occupancy < 7'd63)
        begin
          n_state = DATA3;
        end
        else if(byte_received && buffer_occupancy > 7'd63)
        begin
          n_state = RX_ERR;
        end
        else if(eop)
        begin
          n_state = RX_ERR;
        end
      end
      DATA3:
      begin
        if(byte_received && buffer_occupancy < 7'd63)
        begin
          n_state = DATA3;
        end
        else if(byte_received && buffer_occupancy > 7'd63)
        begin
          n_state = RX_ERR;
        end
        else if(eop)
        begin
          n_state = EOP;
        end
      end
      TOKEN1:
      begin
        if(byte_received)
        begin
          n_state = TOKEN2;
        end
        else if(eop)
        begin
          n_state = RX_ERR;
        end
      end
      TOKEN2:
      begin
        if(byte_received)
        begin
          n_state = TOKEN_DONE;
        end
        else if(eop)
        begin
          n_state = RX_ERR;
        end
      end
      TOKEN_DONE:
      begin
        if(eop)
        begin
          n_state = EOP;
        end
        else
        begin
          n_state = RX_ERR;
        end
      end
      WRITE: 
      begin
        n_state = WAIT;
      end
      DONE: 
      begin
        if(edge_detect)
        begin
          n_state = SYN_CHK;
        end
      end
    endcase
  end

  // RX TRANSFER ACTIVE
  always_comb
  begin
    rx_trans_active = 1'b1;
    case(state)
    IDLE: rx_trans_active = 1'b0;
    RX_ERR: rx_trans_active = 1'b0;
    EOP_IDLE: rx_trans_active = 1'b0;
    endcase
  end

  // STORE RX DATA
  always_comb
  begin  
    write_en = 1'b0;
    case(state)
    DATA1: write_en = 1'b1;
    DATA2: write_en = 1'b1;
    DATA3: write_en = 1'b1;
    endcase
  end
 
  // RX_ERROR
  always_comb
  begin  
    EOP_err = 1'b0;
    case(state)
    RX_ERR: EOP_err = 1'b1;
    endcase
  end

  // FLUSH REGISTER
  always_comb
  begin  
    PID_clear = 1'b0;
    case(state)
    IDLE: PID_clear = 1'b1;
    endcase
  end

  // PID Mode
  always_comb
  begin  
    PID_mode = 1'b1;
    case(state)
    IDLE:  PID_mode = 1'b0;
    SYN_CHK: PID_mode = 1'b0;
    WAIT: PID_mode = 1'b0;
    RECV: PID_mode = 1'b0;
    PID_RECV: PID_mode = 1'b0;
    PID_WRITE: PID_mode = 1'b0;
    PID_WAIT: PID_mode = 1'b0;
    PID_CHECK: PID_mode = 1'b0;
    endcase
  end

  // RX Data Ready
  always_comb
  begin  
    rx_data_ready = 1'b0;
    case(state)
    DATA1: rx_data_ready = 1'b1;
    DATA2: rx_data_ready = 1'b1;
    DATA3: rx_data_ready = 1'b1;
    endcase
  end

endmodule