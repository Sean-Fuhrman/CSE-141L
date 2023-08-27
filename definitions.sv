//This file defines the parameters used in the alu
// CSE141L
package definitions;
    
// Instruction map for arithmetic operations
    const logic [2:0]kADD  = 3'b000;
    const logic [2:0]kLSL  = 3'b001;
    const logic [2:0]kXOR  = 3'b010;
    const logic [2:0]kAND  = 3'b011;
    const logic [2:0]kCMP  = 3'b100;
	const logic [2:0]kSET  = 3'b101;
	const logic [2:0]kLSR  = 3'b110;
    const logic [2:0]kSUB  = 3'b111

// Instruction map for data operations
    const logic [1:0]kMOVE  = 2'b00;
    const logic [1:0]kFLAG  = 2'b00;
    const logic [1:0]kSTORE = 2'b10;
    const logic [1:0]kLOAD  = 2'b11;
// enum names will appear in timing diagram
    typedef enum logic[2:0] {
        ADD, LSL, XOR, AND,
        CMP, SET, LSR, SUB,
        MOVE, FLAG, STORE, LOAD} op_mne;

// note: kADD is of type logic[2:0] (3-bit binary)
//   ADD is of type enum -- equiv., but watch casting
//   see ALU.sv for how to handle this   
endpackage // definitions
