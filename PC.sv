// CSE141L
// program counter
// accepts branch and jump instructions
// default = increment by 1
// issues halt when PC reaches 63
module PC(
  input init,
        instruction,
  		EQUAL,
		CLK,
  output logic halt,
  output logic[ 9:0] PC);

always @(posedge CLK)
  if(init) begin
    PC <= 0;
	halt <= 0;
  end
  else begin
    if(PC > 1023)            //if PC reaches 255, halt
	  halt <= 1;		  
	else if(EQUAL && instruction[6] == 1'b1) 
	  PC <= PC + 7;
    else if(jump_en) begin
	  if(PC>13)
	    PC <= PC - 14;
	  else
	    halt <= 1;       // trap error condition
	end
	else 
	  PC <= PC + 1;	     // default == increment by 1
  end

always @()
endmodule
        