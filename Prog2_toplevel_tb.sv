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

  bit  [11:1] d1_in[15];           // original messages
logic      p0, p8, p4, p2, p1;  // Hamming block parity bits
logic[15:0] d1_out[15];          // orig messages w/ parity inserted


logic[11:1] d2_in[15];           // use to generate data
logic[15:0] d2_good[15];         // d2_in w/ parity
logic[ 3:0] flip[15];            // position of first corruption bit
logic[ 5:0] flip2[15];           // position of possible second corruption bit
logic[15:0] d2_bad1[15];         // possibly corrupt message w/ parity
logic[15:0] d2_bad[15];          // possibly corrupt messages w/ parity
logic       s16, s8, s4, s2, s1; // parity generated from data of d_bad
logic[ 3:0] err;                 // bitwise XOR of p* and s* as 4-bit vector        
logic[11:1] d2_corr[15];         // recovered and corrected messages
bit  [15:0] score2, case2;
initial begin
  start = 1;
// Initialize DUT's data memory
  for(int i=0; i<256; i++) begin
    DUT.data_mem1.core[i] = 8'h0;	     // clear data_mem
  end
  for(int j=0; j<8; j++) begin
    DUT.reg_file1.registers[j] = 8'b0;  
  end

    DUT.data_mem1.core[31] = 8'b00000111;
    DUT.data_mem1.core[30] = 8'b11101101;
  
//    for(int i=0; i<15; i++) begin
// 	d2_in[i] = $random;
//     p8 = ^d2_in[i][11:5];
//     p4 = (^d2_in[i][11:8])^(^d2_in[i][4:2]); 
//     p2 = d2_in[i][11]^d2_in[i][10]^d2_in[i][7]^d2_in[i][6]^d2_in[i][4]^d2_in[i][3]^d2_in[i][1];
//     p1 = d2_in[i][11]^d2_in[i][ 9]^d2_in[i][7]^d2_in[i][5]^d2_in[i][4]^d2_in[i][2]^d2_in[i][1];
//     p0 = ^d2_in[i]^p8^p4^p2^p1;
//     d2_good[i] = {d2_in[i][11:5],p8,d2_in[i][4:2],p4,d2_in[i][1],p2,p1,p0};
// // flip one bit
//     flip[i] = $random;	  // 'b1000000;
//     d2_bad1[i] = d2_good[i] ^ (1'b1<<flip[i]);
// // flip second bit about 25% of the time (flip2<16)		// 00_0010     1010
// // if flip2[5:4]!=0, flip2 will have no effect, and we'll have a one-bit flip
//     flip2[i] = $random;	   // 'b0;
// 	d2_bad[i] = d2_bad1[i] ^ (1'b1<<flip2[i]);
// // if flip2[5:4]==0 && flip2[3:0]==flip, then flip2 undoes flip, so no error
// 	DUT.data_mem1.core[31+2*i] = {d2_bad[i][15:8]};
//     DUT.data_mem1.core[30+2*i] = {d2_bad[i][ 7:0]};
//   end
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
  for(int j=0; j<8; j++) begin
    $display("Register %d = %d",j, DUT.reg_file1.registers[j]);
  end
  #5ns  CLK = 1;
 
  $display("PC = %d", DUT.PC1.PC);
  $display("Instruction = %b",DUT.Instruction);
  $display("Op Code = %b",DUT.ALU1.ALU_op_code);
  $display("ALU OUT = %d",DUT.ALU1.ALU_out);
  $display("EQUAL Flag = %b", DUT.EQUAL);
  $display("ALU Arg 0  = %b", DUT.ALU1.ALU_arg_0);
  $display("ALU Arg 1  = %b", DUT.ALU1.ALU_arg_1);
  $display("Reg read arress 0 = %d", DUT.Ctrl1.Reg_read_address_0);
  $display("Reg read arress 1 = %d", DUT.Ctrl1.Reg_read_address_1);
  #5ns  CLK = 0;
end
      
endmodule

