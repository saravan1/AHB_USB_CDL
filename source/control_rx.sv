module control_rx (
  input logic clk,
  input logic n_rst,
  input logic edge_detect,
  input logic eop,
  input logic shift_enable,
  input logic [7:0] rcv_data,
  input logic byte_received,
  input logic PID_error,
  input logic [3:0] PID_byte,
  input logic [6:0] buffer_occupancy,
  output logic write_en,
  output logic EOP_err,
  output logic PID_clear,
  output logic PID_mode,
  output logic rx_data_ready,
  output logic rx_trans_active,
  output logic enable_timer,
  output logic flush
);

  typedef enum bit[4:0] {IDLE, SYN_CHK, 
                         PID_WAIT, PID_CHECK,
                         TOKEN1, TOKEN2, TOKEN_DONE,
                         DATA_IDLE, DATA1, DATA2, DATA3, 
                         EOP_IDLE, EOP, EOP_ERR, PID_ERR, DONE} statelogic;
  statelogic state;
  statelogic n_state;
  
  localparam hold_byte = 8'b00000001;

  //ff logic on posedge and negedge
  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 0) begin
      state <= IDLE;
    end else begin
      state <= n_state;
    end
  end

  
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
        begin
          n_state = PID_WAIT;
        end
        else if((rcv_data != hold_byte) && byte_received)
        begin
          n_state = PID_ERR;
        end
      end
      PID_WAIT: 
      begin
        if(shift_enable && eop)
        begin
          n_state = EOP_IDLE;
        end
        else if(byte_received)
        begin
          n_state = PID_CHECK;
        end
      end
      PID_CHECK: 
      begin
        if ((PID_byte == 4'b0011) || (PID_byte == 4'b1011))
        begin
          n_state = DATA_IDLE;
        end
        else if ((PID_byte == 4'b0001) || (PID_byte == 4'b1001))
        begin
          n_state = TOKEN1;
        end
        else if(PID_error)
        begin
          n_state = PID_ERR;
        end
        else
        begin
          n_state = EOP_IDLE;
        end
      end
      EOP_IDLE: 
      begin
         if(eop)
        begin
          n_state = EOP;
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
          n_state = EOP_ERR;
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
          n_state = PID_ERR;
        end
        else if(eop)
        begin
          n_state = EOP_ERR;
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
          n_state = PID_ERR;
        end
        else if(eop)
        begin
          n_state = EOP_ERR;
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
          n_state = PID_ERR;
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
          n_state = EOP_ERR;
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
          n_state = EOP_ERR;
        end
      end
      TOKEN_DONE:
      begin
        if(eop)
        begin
          n_state = EOP;
        end
      end
      EOP_ERR: 
      if(~eop)
      begin
          n_state = DONE;
      end
      PID_ERR: 
      begin
        if(shift_enable && eop)
        begin
          n_state = EOP;
        end
      end
      EOP: 
      if(~eop)
      begin
          n_state = DONE;
      end
      DONE: 
      begin
          n_state = IDLE;
      end
    endcase
  end

  // RX TRANSFER ACTIVE
  always_comb
  begin
    rx_trans_active = 1'b1;
    case(state)
    IDLE: rx_trans_active = 1'b0;
    DONE: rx_trans_active = 1'b0;
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
    EOP_ERR: EOP_err = 1'b1;
    PID_ERR: EOP_err = 1'b1;
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
    PID_mode = 1'b0;
    case(state)
    SYN_CHK: PID_mode = 1'b1;
    // PID_WAIT: PID_mode = 1'b1;
    // PID_RECV: PID_mode = 1'b1;
    PID_WAIT: PID_mode = 1'b1;
    PID_CHECK: PID_mode = 1'b1;
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

  
  // ENABLE TIMER LOGIC
  always_comb
  begin  
    enable_timer = 1'b1;
    case(state)
    IDLE: enable_timer = 1'b0;
    // PID_WAIT: enable_timer = 1'b0;
    EOP_IDLE: enable_timer = 1'b0;
    endcase
  end
 
  // FLUSH
  always_comb
  begin  
    flush = 1'b0;
    case(state)
    DATA_IDLE: flush = 1'b1;
    endcase
  end


endmodule