// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	   // machine code

  output logic Reg_write_en,
  			Immediate_en,
  			Data_write_en,
  			Data_read_en,
        Select_data,
  output logic [0:2] Reg_write_address,
  					Reg_read_address_0, //most of the time R0
  					Reg_read_address_1, //most of the time R1
  					Immediate
  	
  );
  always_comb begin
    // zero out all enables until set
    Reg_write_en = 1'b0;
    Immediate_en = 1'b0;
    Data_write_en = 1'b0;
    Data_read_en = 1'b0;
    Select_data = 1'b0;
	 Reg_write_address = 3'b000;
	 Reg_read_address_0 = 3'b000;
	 Reg_read_address_1 = 3'b000;

    Immediate = Instruction[2:0];
    // check if command is a data operation 
    if(Instruction[8] == 1) begin
      case(Instruction[7:6])
        kMOVE:  begin
            Reg_write_en = 1'b1;
            Reg_read_address_0 = 3'b000; //(DON'T CARE)
            Reg_read_address_1 = Instruction[2:0];
            Reg_write_address = Instruction[5:3];
        end
        kFLAG:   begin
            Reg_write_en = 1'b1;
            Reg_read_address_0 = 3'b000; //(DON'T CARE)
            Reg_read_address_1 = Instruction[2:0];
            Reg_write_address = Instruction[5:3];
        end
        kLOAD:    begin
            Reg_write_en = 1'b1;
            Data_read_en = 1'b1;
            Select_data = 1'b1;
            Reg_write_address  = Instruction[5:3];
            Reg_read_address_0 = Instruction[2:0];
        end
        kSTORE:   begin 
            Data_write_en = 1'b1;
            Reg_read_address_0 = Instruction[5:3];
            Reg_read_address_1 = Instruction[2:0];
        end
      endcase 
    end else if(Instruction[6] == 0) begin //not data and not branching
		case(Instruction[5:3]) 
        kADD:   Reg_write_en = 1'b1;
        kLSL:   Reg_write_en = 1'b1;
        kXOR:   Reg_write_en = 1'b1;
        kAND:   Reg_write_en = 1'b1;
        kCMP:   Reg_write_en = 1'b0;
        kSET:   Reg_write_en = 1'b1;
        kLSR:   Reg_write_en = 1'b1;
        kSUB:   Reg_write_en = 1'b1;
      endcase
      Reg_read_address_0 = 3'b000;
      Reg_read_address_1 = 3'b001; 
      Reg_write_address =  3'b010;
      if(Instruction[7] == 1'b1) begin
        Immediate_en = 1;
      end
    end else begin //branching instruction
		  Reg_read_address_0 = 3'b000;
		  Reg_read_address_1 = 3'b001;
	 end
  end
endmodule

   // ARM instructions sequence
   //				cmp r5, r4
   //				beq jump_label