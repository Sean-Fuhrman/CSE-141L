// CSE141L
// program counter
// accepts branch and jump instructions
// default = increment by 1
// issues halt when PC reaches 63
module PC(
  input init,
  input [8:0] instruction,
  		EQUAL,
		CLK,
  output logic halt,
  output logic[ 9:0] PC);

  logic [9:0] LUT_out;
  LUT LUT1 (
	.addr(instruction[2:0]),
	.Target(LUT_out)
	);
always @(posedge CLK)
  if(init) begin
    PC <= 0;
	halt <= 0;
  end
  // NEED TO ENSURE INSTRUCTION IS ARITHMETIC COMMAND!
  else begin
    if(PC > 6)            //if PC reaches 1024, halt
	  halt <= 1;		  
	else if(instruction[8] == 1'b0 && instruction[6] == 1'b1) begin //check it's ariithmetic branching instruction 
		if(instruction[5:3] == 3'b000 && EQUAL) begin
			PC <= LUT_out;
		end else if(instruction[5:3] == 3'b001 && EQUAL) begin
			PC <= PC + instruction[2:0];
		end  else if(instruction[5:3] == 3'b010 && ~EQUAL) begin
			PC <= LUT_out;
		end else if (instruction[5:3] == 3'b011 && ~EQUAL) begin
			PC <= PC + instruction[2:0];
		end
	end else 
	  PC <= PC + 1;	     // default == increment by 1
end
endmodule
        