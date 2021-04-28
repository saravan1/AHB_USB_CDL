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
  output logic recieved,
  output logic write_en,
  output logic EOP_err,
  output logic PID_clear,
  output logic PID_mode,
  output logic rx_data_ready,
  output logic rx_trans_active,
);

  typedef enum bit[3:0] {IDLE, SYN_CHK, WAIT, RECV, PID_RECV, PID_WRITE, PID_WAIT, PID_CHECK, WRITE, EOP, TOKEN, DATA, EOP_IDLE, EOP_ERR, DONE} statelogic;
  statelogic state;
  statelogic n_state;

  logic [4:0] out;
  assign recieved = out[4];
  assign write_en = out[3];
  assign EOP_err = out[2];
  assign PID_clear = out[1];
  assign PID_mode = out[0];
  
  localparam hold_byte = 8'b10000000;
  localparam idle_byte = '0;
  localparam sync_byte = 5'b10010;
  localparam pid_byte = 5'b10000;
  localparam write_byte = 5'b10001;
  localparam final_byte = 5'b11000;
  localparam eop_byte = 5'b10100;
  localparam closeout = 5'b00100;

  //ff logic on posedge and negedge
  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 0) begin
      state <= IDLE;
    end else begin
      state <= n_state;
    end
  end

  always_comb
  begin
    
  end

    //output logic 
  always_comb 
  begin
    out = idle_byte;
    case(state)
      IDLE: 
      begin
        out = idle_byte;
      end
      EOP_IDLE: 
      begin
        out = eop_byte;
      end
      SYN_CHK: 
      begin
        out = sync_byte;
      end
      PID_WAIT:
      begin
        out = pid_byte;
      end
      PID_RECV: 
      begin
        out = pid_byte;
      end
      PID_WRITE: 
      begin
        out = write_byte;
      end
      PID_CHECK: 
      begin
        out = pid_byte;
      end
      WAIT: 
      begin
        out = pid_byte;
      end
      EOP: 
      begin
        out = pid_byte;
      end
      EOP_ERR: 
      begin
        out = eop_byte;
      end
      RECV: 
      begin
        out = pid_byte;
      end
      WRITE: 
      begin
        out = final_byte;
      end
      DONE: 
      begin
        out = closeout;
      end
    endcase
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
       //if(byte_received)
        begin
          n_state = PID_WAIT;
        end
        else if((rcv_data != hold_byte) && byte_received)
        begin
          n_state = EOP_ERR;
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
          n_state = DATA;
        end
        else if ((PID_byte == 8'b11100001) || (PID_byte == 8'b01101001))
        begin
          n_state = TOKEN;
        end
        else if(PID_EOP_ERR)
        begin
          n_state = EOP_ERR;
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
      EOP_ERR: 
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
      DATA:
      begin
        if(!eop)
        begin
          n_state = DATA;
        end
        else if(eop)
        begin
          n_state = EOP;
        end
      end
      TOKEN:
      begin
        if(!eop)
        begin
          n_state = TOKEN;
        end
        else if(eop)
        begin
          n_state = EOP;
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

  always_comb
  begin
    rx_trans_active = 1'b1;
    if(state == IDLE) begin
      rx_trans_active = 1'b0;
    end
    else if (state == DONE)
    begin
      rx_trans_active = 1'b0;
    end
  end
endmodule