// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
module LUT(
  input[2:0] addr,
  output logic[9:0] Target
  );

always_comb 
  case(addr)		   //-16'd30;
	3'b000: Target = 10'd0;
	3'b001: Target = 10'd351;
	3'b010: Target = 10'd418;
	3'b011: Target = 10'd390;
	3'b100: Target = 10'd0;
	3'b101: Target = 10'd0;
	3'b110: Target = 10'd0;
	3'b111: Target = 10'd1023;

	default: Target = 10'd1;
  endcase

endmodule