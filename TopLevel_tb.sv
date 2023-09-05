// Create Date:   2017.01.25
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb.v
//  CSE141L
// This is NOT synthesizable; use for logic simulation only
// Verilog Test Fixture created for module: TopLevel

module TopLevel_tb;	     // Lab 17

// To DUT Inputs
  bit start;
  bit CLK;

// From DUT Outputs
  wire halt;		   // done flag

// Instantiate the Device Under Test (DUT)
  TopLevel DUT (
	.start           , 
	.CLK             , 
	.halt             
	);

initial begin
  start = 1;
// Initialize DUT's data memory
  #10ns for(int i=0; i<256; i++) begin
    DUT.data_mem1.core[i] = 8'h0;	     // clear data_mem
  end
// students may also pre_load desired constants into data_mem
// Initialize DUT's register file
  for(int j=0; j<8; j++) begin
    DUT.reg_file1.registers[j] = 8'b0;  
  end

// launch program in DUT
  #10ns start = 0;
// Wait for done flag, then display results
  wait (halt);
  #10ns for(int j=0; j<8; j++) begin
    $display("Register %d = %d",j, DUT.reg_file1.registers[j]);
  end
        $display("instruction = %d %t",DUT.PC,$time);
  #10ns $stop;			   
end

always begin   // clock period = 10 Verilog time units
  #5ns  CLK = 1;
 
  $display("PC = %d", DUT.PC1.PC);
  $display("Instruction = %b",DUT.Instruction);
  $display("Op Code = %b",DUT.ALU1.ALU_op_code);
  $display("ALU OUT = %d",DUT.ALU1.ALU_out);
  for(int j=0; j<8; j++) begin
    $display("Register %d = %d",j, DUT.reg_file1.registers[j]);
  end
  #5ns  CLK = 0;
end
      
endmodule

