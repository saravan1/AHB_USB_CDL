module edge_detector (
  input logic clk,
  input logic n_rst,
  input logic d_high,
  output logic edge_detect
);
  logic main_hold;
  logic n_hold;

  logic main_hold2;
  logic n_hold2;
  
  always_comb 
  begin
    edge_detect = main_hold ^ main_hold2;
    n_hold = d_high;
    n_hold2 = main_hold;
  end

  always_ff @ (posedge clk, negedge n_rst) 
  begin
    if(n_rst == 0) 
    begin
      main_hold <= 1;
      main_hold2 <= 1;
    end
    else 
    begin
      main_hold <= n_hold;
      main_hold2 <= n_hold2;
    end
  end
endmodule