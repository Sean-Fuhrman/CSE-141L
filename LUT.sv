// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
module LUT(
  input[2:0] addr,
  output logic[9:0] Target
  );

always_comb 
  case(addr)		   //-16'd30;
	3'b000: Target = 9'd5;
	default: Target = 9'd1;
  endcase

endmodule