module eop_detector (
  input logic d_high,
  input logic d_low,
  output logic eop
);

always_comb 
begin
  if(d_high == 0 && d_low == 0)
    begin
      eop = 1;
    end
  else
    begin
      eop = 0;
    end
end
endmodule