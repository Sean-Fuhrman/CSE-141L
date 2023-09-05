// CSE141L  -- instruction ROM -- one approach
// no external file needed, but lots of 
// DW = machine code width (9 bits for class; 32 for ARM/MIPS)
// IW = program counter width, determines instruction memory depth
module InstROM #(parameter IW = 10, DW = 9)(
  input        [IW-1:0] InstAddress,	// address pointer
  output logic [DW-1:0] InstOut);

  logic [DW-1:0] inst_rom [2**IW];	    // automatically size to pointer width

  // load machine code program into instruction ROM

  initial begin
	$readmemb("C:/Users/seant/OneDrive/Desktop/CSE-141L/assembler/Kiss.bin",inst_rom);
  end

// create the array
//  initial begin
//    inst_rom[ 0] = 010110001;
// ...
//end
// continuous combinational read output
// change the pointer (from program counter) ==> change the output
  assign InstOut = inst_rom[InstAddress];
endmodule