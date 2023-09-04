// Create Date:    2016.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2018.01.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*; // includes package "definitions"
module ALU(
  input [ 7:0] ALU_arg_0,      	// R0 if arithmetic
               ALU_arg_1,       // R1 if arithmetic
  input [ 2:0] ALU_op_code,			// ALU opcode, part of microcode
  input [1:0] Data_op_code,
  input Data_signifier,
  input        SC_IN,             // shift in/carry in 
  output logic [7:0] ALU_out,		  // or:  output reg [7:0] OUT,
  output logic SC_OUT,			   // shift out/carry out
  output logic ZERO,           // zero out flag
  output logic BEVEN,          // LSB of input B = 0
  output logic PARITY,         //parity of ALU arg 0
  output logic EQUAL          //ALU arg 0 = ALU arg 1
    );
	 
	logic zero_flag = 0;
	logic beven_flag = 0;
	logic parity_flag = 0;
  always_comb begin
    {SC_OUT} = 0;            // default -- clear carry out and result out
	 ALU_out = 0;
    // single instruction for both LSW & MSW
    if(Data_signifier == 0) begin  // arithmetic operation
      case(ALU_op_code) 
        kADD:   ALU_out = ALU_arg_0 + ALU_arg_1;
        kLSL:   ALU_out = ALU_arg_0 << ALU_arg_1;
        kXOR:   ALU_out = ALU_arg_0 ^ ALU_arg_1;
        kAND:   ALU_out = ALU_arg_0 & ALU_arg_1;
        kCMP:   ALU_out = 0;
        kSET:   ALU_out = ALU_arg_1;
        kLSR:   ALU_out = ALU_arg_0 >> ALU_arg_1;
        kSUB:   ALU_out = ALU_arg_0 - ALU_arg_1;
      endcase
    end else begin
      case(Data_op_code)
        kMOVE:   ALU_out = ALU_arg_1;
        kFLAG:   begin
           zero_flag = (ALU_arg_1 == 8'b00000000)? 1'b1: 1'b0;
           beven_flag = (ALU_arg_1[0] == 0)? 1'b1: 1'b0;
           parity_flag = (^ALU_arg_1)? 1'b1: 1'b0;
          ALU_out = {5'b00000, zero_flag, beven_flag, parity_flag};
        end 
        kLOAD:   ALU_out = 20;
        kSTORE:  ALU_out = 21;
      endcase
    end
    //SET FLAGS
    // zero flag set
    if(ALU_out == 8'b00000000) begin
      ZERO = 1'b1;
    end else begin 
      ZERO = 1'b0;
    end
    // even flag set
    if(ALU_out[0] == 0) begin
      BEVEN = 1'b1;
    end else begin
      BEVEN = 1'b0;
    end 
    // equal flag set 
    if(ALU_arg_0 == ALU_arg_1) begin
      EQUAL = 1'b1;
    end else begin
      EQUAL = 1'b0;
    end
    //parity flag set
    PARITY = ^ALU_arg_0;
  end
endmodule
             