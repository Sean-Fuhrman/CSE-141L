// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	   // machine code

  output logic Reg_write_en,
  			Immediate_en
  			Data_write_en,
  			Data_read_en,
  output logic [0:2] Reg_write_address,
  					Reg_read_address_0, //most of the time R0
  					Reg_read_address_1, //most of the time R1
  					Immediate,
  	
  );


endmodule

   // ARM instructions sequence
   //				cmp r5, r4
   //				beq jump_label