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
	   	      Data_memory_out; // data out from data_memory
  wire [2:0] Reg_write_address, //register write addres
  			 Reg_read_address_0, //register read address, R0 for algorithmic commands
  			 Reg_read_address_1, //register read address, R1 for algorithmic commands
  			 Immediate,
wire        Data_read_en,	   // data_memory read enable
		    Data_write_en,	   // data_memory write enable
			Reg_write_en,	   // reg_file write enable
  			Immediate_en,
			sc_clr,        // carry reg clear
			sc_en,	       // carry reg enable
		    SC_OUT,	       // to carry register
			ZERO,		   // ALU output = 0 flag
			BEVEN,		   // ALU ARG 0 is even flag
  			PARTIY,		   // ALU ARG 0 parity is even
  			EQUAL,		   // ALU input args are equal
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
    .Reg_write_address (Reg_write_address)
    .Reg_read_address_0 (Reg_read_address_0), //most of the time R0
    .Reg_read_address_1 (Reg_read_address_1), //most of the time R1
    .Immediate (Immediate),
  );
  
// instruction ROM
  InstROM instr_ROM1(
	.InstAddress (PC), 
	.InstOut  (Instruction)
	);


// reg file
  reg_file #(.W(8),.D(3)) reg_file1 (
    .CLK (CLK),
    .Reg_write_en,
  input  [D-1:0] Reg_write_address,
                 Reg_read_address_0,  //R0 if arithmetic
                 Reg_read_address_1,  //R1 if arithmetic
  input  [ W-1:0] Reg_write_data,
  output [ W-1:0] Source_0_data, 
  				  Source_1_data,
	);
// one pointer, two adjacent read accesses: (optional approach)
//	.raddrA ({Instruction[5:3],1'b0});
//	.raddrB ({Instruction[5:3],1'b1});

    assign InA = ReadA;						          // connect RF out to ALU in
	assign InB = ReadB;
	assign MEM_WRITE = (Instruction == 9'h111);       // mem_store command
	assign regWriteValue = load_inst? Mem_Out : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .INPUTA  (InA),
	  .INPUTB  (InB), 
	  .OP      (Instruction[8:6]),
	  .OUT     (ALU_out),//regWriteValue),
	  .SC_IN   ,//(SC_IN),
	  .SC_OUT  ,
	  .ZERO ,
	  .BEVEN
	  );
  
	data_mem data_mem1(
		.DataAddress  (ReadA)    , 
		.ReadMem      (1'b1),          //(MEM_READ) ,   always enabled 
		.WriteMem     (MEM_WRITE), 
		.DataIn       (memWriteValue), 
		.DataOut      (Mem_Out)  , 
		.CLK 		  		     ,
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
