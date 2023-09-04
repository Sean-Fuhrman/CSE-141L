// Create Date:    2016.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2018.01.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;			  // includes package "definitions"
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
  output logic EQUAL,          //ALU arg 0 = ALU arg 1
    );
	 
  op_mne op_mnemonic;			  // type enum: used for convenient waveform viewing
	
  always_comb begin
    {SC_OUT, OUT} = 0;            // default -- clear carry out and result out
    // single instruction for both LSW & MSW
    
    //SET FLAGS
    // zero flag set
    if(ALU_OUT == 8'b00000000) begin
      ZERO = 1'b1;
    end else begin 
      ZERO = 1'b0;
    end
    // even flag set
    if(ALU_OUT[0] == 0) begin
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
    PARITY = ALU_arg_0[7] ^ ALU_arg_0[6] ^ ALU_arg_0[5] ^ ALU_arg_0[4] ^ ALU_arg_0[3] ^ ALU_arg_0[2] ^ ALU_arg_0[1] ALU_arg_0[0];
  end

  // COMPUTE ALU OUTPUT 
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
    end else begin // data movement operation 
      case(Data_op_code)
        kMOVE:   ALU_out = ALU_arg1;
        kFLAG:   ALU_out = {4'b0000, ZERO, BEVEN, PARITY, EQUAL};
        kLOAD:   ALU_OUT = 20;
        kSTORE:  ALU_OUT = 21;
      endcase
    end
    
endmodule
/*
  case(OP)
    kADD : {SC_OUT, OUT} = {1'b0,INPUTA} + INPUTB + SC_IN;  // add w/ carry-in & out
    kLSH : {SC_OUT, OUT} = {INPUTA, SC_IN};  	            // shift left 
	kRSH : {OUT, SC_OUT} = {SC_IN, INPUTA};			        // shift right
//  kRSH : {OUT, SC_OUT} = (INPUTA << 1'b1) | SC_IN;
 	kXOR : begin 
 	         OUT    = INPUTA^INPUTB;  	     			   // exclusive OR
			 SC_OUT = 0;					   		       // clear carry out -- possible convenience
		   end
    kAND : begin                                           // bitwise AND
             OUT    = INPUTA & INPUTB;
			 SC_OUT = 0;
		   end
    kSUB : begin
	         OUT    = INPUTA + (~INPUTB) + SC_IN;	       // check me on this!
			 SC_OUT = 0;                                   // check me on this!
	       end
    default: {SC_OUT,OUT} = 0;						       // no-op, zero out
  endcase
// option 2 -- separate LSW and MSW instructions
//    case(OP)
//	  kADDL : {SC_OUT,OUT} = INPUTA + INPUTB ;    // LSW add operation
//	  kLSAL : {SC_OUT,OUT} = (INPUTA<<1) ;  	  // LSW shift instruction
//	  kADDU : begin
//	            OUT = INPUTA + INPUTB + SC_IN;    // MSW add operation
//                SC_OUT = 0;   
//              end
//	  kLSAU : begin
//	            OUT = (INPUTA<<1) + SC_IN;  	  // MSW shift instruction
//                SC_OUT = 0;
//               end
//      kXOR  : OUT = INPUTA ^ INPUTB;
//	  kBRNE : OUT = INPUTA - INPUTB;   // use in conjunction w/ instruction decode 
//  endcase
	case(OUT)
	  'b0     : ZERO = 1'b1;
	  default : ZERO = 1'b0;
	endcase
//$display("ALU Out %d \n",OUT);
    op_mnemonic = op_mne'(OP);					  // displays operation name in waveform viewer
  end											
  always_comb BEVEN = OUT[0];          			  // note [0] -- look at LSB only
//    OP == 3'b101; //!INPUTB[0];               
// always_comb	branch_enable = opcode[8:6]==3'b101? 1 : 0;  
*/




	   /*
			Left shift

            
			  input a = 10110011   sc_in = 1

              output = 01100111
			  sc_out =	1

							   */
            