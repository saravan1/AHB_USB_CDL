module decoder (
  input logic clk,
  input logic n_rst,
  input logic d_high,
  input logic shift_enable,
  input logic eop,
  output logic d_sent
);

  //next state logic that is where it is.
  logic main_hold;
  logic end_hold;
  logic n_hold;

  //ff logic on negedge and posedge
  always_ff @(posedge clk, negedge n_rst) 
  begin
    if(n_rst != 0) 
    begin
      main_hold <= d_high;
      end_hold <= n_hold;
    end 
    else 
    begin
      main_hold <= 1;
      end_hold <= 1;
    end
  end

  //comb logic
  always_comb 
  begin
    if (shift_enable) 
    begin
      if (eop) 
      begin
        n_hold = 1;
      end 
      else 
      begin
        n_hold = main_hold;
      end
    end 
    else 
    begin
      n_hold = end_hold;
    end
  end

  //assign output logic to next reg.
  assign d_sent = !(end_hold ^ main_hold);
  
endmodule