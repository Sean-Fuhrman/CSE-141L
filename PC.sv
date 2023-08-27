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
    if(PC > 1023)            //if PC reaches 1024, halt
	  halt <= 1;		  
	else if(EQUAL && instruction[6] == 1'b1) begin
		if(instruction[5:3] == 3'b000) begin
			// ADD IN LOOKUP TABLE!
			PC <= PC + 2;
		end else if(instruction[5:3] 3'b111) begin
			// ADD IN LOOKUP TABLE!
			PC <= PC - 2;
		end  
	end else 
	  PC <= PC + 1;	     // default == increment by 1
end



    
	
	/* WHAT IS THIS FOR???
	else if(jump_en) begin
	  if(PC>13)
	    PC <= PC - 14;
	  else
	    halt <= 1;       // trap error condition
	end
	*/ 
	

always @()
endmodule
        