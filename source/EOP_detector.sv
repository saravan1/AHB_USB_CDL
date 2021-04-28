module EOP_detector (
  input logic dplus_in,
  input logic dminus_in,
  output logic eop
);

always_comb 
begin
  if(dplus_in == 0 && dminus_in == 0)
    begin
      eop = 1;
    end
  else
    begin
      eop = 0;
    end
end
endmodule