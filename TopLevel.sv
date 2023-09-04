// Code your design here
// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only	


module TopLevel(		   // you will have the same 3 ports
    input     start,	   // init/reset, active high
	input     CLK,		   // clock -- posedge used inside design
    output    halt		   // done flag from DUT
    );

  wire [ 9:0] PC;            // program count
  wire [ 8:0] Instruction;   // our 9-bit opcode
  wire [ 7:0] Source_0_data, Source_1_data;  // reg_file outputs
  wire [ 7:0] ALU_arg_0, ALU_arg_1, 	   // ALU operand inputs for R0 and R1 respecitvely
         	  ALU_out;       // ALU result
  wire [ 7:0] Reg_write_data,  // data in to reg file
              Data_memory_in,  // data in to data_memory
	   	      Data_memory_out,
					Data_address; // data out from data_memory
  wire [2:0] Reg_write_address, //register write addres
  			 Reg_read_address_0, //register read address, R0 for algorithmic commands
  			 Reg_read_address_1, //register read address, R1 for algorithmic commands
  			 Immediate;
wire     Data_read_en,	   // data_memory read enable
		   Data_write_en,	   // data_memory write enable
			Reg_write_en,	   // reg_file write enable
  			Immediate_en,
			Select_data,   // select data from data_memory or ALU
			sc_clr,        // carry reg clear
			sc_en,	       // carry reg enable
		    SC_OUT,	       // to carry register
			ZERO,		   // ALU output = 0 flag
			BEVEN,		   // ALU ARG 0 is even flag
  			PARTIY,		   // ALU ARG 0 parity is even
  			EQUAL;		   // ALU input args are equal
logic[15:0] cycle_ct;	   // standalone; NOT PC!
logic       SC_IN;         // carry register (loop with ALU)

// Fetch = Program Counter + Instruction ROM
// Program Counter
  PC PC1 (
	.init (start), 
    .halt (halt),  // SystemVerilg shorthand for .halt(halt), 
    .instruction (Instruction),
    .EQUAL (EQUAL),
	.CLK (CLK)  ,  // (CLK) is required in Verilog, optional in SystemVerilog
	.PC            // program count = index to instruction memory
	);					  

// Control decoder
  Ctrl Ctrl1 (
    .Instruction (Instruction),    // from instr_ROM
    .Reg_write_en (Reg_write_en),
    .Immediate_en (Immediate_en),
    .Data_write_en (Data_write_en),
    .Data_read_en (Data_read_en),
	 .Select_data(Select_data),
    .Reg_write_address (Reg_write_address),
    .Reg_read_address_0 (Reg_read_address_0), //most of the time R0
    .Reg_read_address_1 (Reg_read_address_1), //most of the time R1
    .Immediate (Immediate)
  );
  
// instruction ROM
  InstROM instr_ROM1(
	.InstAddress (PC), 
	.InstOut  (Instruction)
	);


assign Reg_write_data = Select_data ? ALU_out : Data_memory_out;  // select data from ALU or data_memory 

// reg file
  reg_file #(.W(8),.D(3)) reg_file1 (
    .CLK (CLK),
    .Reg_write_en,
    .Reg_write_address,
    .Reg_read_address_0,  //R0 if arithmetic
    .Reg_read_address_1,  //R1 if arithmetic
    .Reg_write_data,
    .Source_0_data, 
  	.Source_1_data
	);

    assign ALU_arg_0 = Source_0_data;  // connect RF out to ALU in
	assign ALU_arg_1 = Immediate_en? {5'b00000, Immediate} : Source_1_data;  // connect RF out to ALU in

    ALU ALU1  (
		.ALU_arg_0(ALU_arg_0),      	// R0 if arithmetic
    	.ALU_arg_1(ALU_arg_1),       // R1 if arithmetic
  		.ALU_op_code(Instruction[5:3]),			// ALU opcode, part of microcode
		.ALU_out(ALU_out),    //0utput reg [7:0] OUT,
      .SC_IN(SC_IN),  			// shift in/carry in 
      .SC_OUT(SC_OUT),	    // shift out/carry out
      .ZERO(ZERO),          // zero out flag
      .BEVEN(BEVEN),         // LSB of input B = 0
      .PARITY(PARITY),        //parity of ALU arg 0
      .EQUAL(EQUAL)         //ALU arg 0 = ALU arg 1
	  );
  
	assign Data_address = Source_0_data;
	assign Data_memory_in = Source_1_data;
	data_mem data_mem1(
 		.Data_address,
  		.Data_read_en,
  		.Data_write_en,
  		.Data_memory_in,
  		.Data_memory_out,
		.CLK 		  (CLK),
		.reset		  (start)
	);
	
// count number of instructions executed
always_ff @(posedge CLK)
  if (start == 1)	   // if(start)
  	cycle_ct <= 0;
  else if(halt == 0)   // if(!halt)
  	cycle_ct <= cycle_ct+16'b1;

always_ff @(posedge CLK)    // carry/shift in/out register
  if(sc_clr)				// tie sc_clr low if this function not needed
    SC_IN <= 0;             // clear/reset the carry (optional)
  else if(sc_en)			// tie sc_en high if carry always updates on every clock cycle (no holdovers)
    SC_IN <= SC_OUT;        // update the carry  

endmodule
