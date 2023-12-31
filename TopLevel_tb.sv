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

// program 3-specific variables
logic[  7:0] cto,		       // how many bytes hold the pattern? (32 max)
             cts,		       // how many patterns in the whole string? (253 max)
		     ctb;		       // how many patterns fit inside any byte? (160 max)
logic        ctp;		       // flags occurrence of patern in a given byte
logic[  4:0] pat;              // pattern to search for
logic[255:0] str2; 	           // message string
logic[  7:0] mat_str[32];      // message string parsed into bytes

initial begin
  for(int i=0; i<256; i++) begin
    DUT.data_mem1.core[i] = 8'h0;	     // clear data_mem
  end
  for(int j=0; j<8; j++) begin
    DUT.reg_file1.registers[j] = 8'b0;  
  end

 
// program 3
// pattern we are looking for; experiment w/ various values
  pat = 5'b0000;//5'b10101;//$random;//5'b11111;
  str2 = 0;
  DUT.reg_file1.registers[7] = pat;
  DUT.data_mem1.core[32] = {pat,3'b0};
  for(int i=0; i<32; i++) begin
// search field; experiment w/ various vales
    mat_str[i] = 8'b00000000;//8'b01010101;// $random;// 8'b11111111;
	DUT.data_mem1.core[i] = mat_str[i];   
	str2 = (str2<<8)+mat_str[i];
  end
  ctb = 0;
  for(int j=0; j<32; j++) begin
    if(pat==mat_str[j][4:0]) ctb++;
    if(pat==mat_str[j][5:1]) ctb++;
    if(pat==mat_str[j][6:2]) ctb++;
    if(pat==mat_str[j][7:3]) ctb++;
  end
  cto = 0;
  for(int j=0; j<32; j++) 
    if((pat==mat_str[j][4:0]) | (pat==mat_str[j][5:1]) |
       (pat==mat_str[j][6:2]) | (pat==mat_str[j][7:3])) cto ++;
  cts = 0;
  for(int j=0; j<252; j++) begin
    if(pat==str2[255:251]) cts++;
	str2 = str2<<1;
  end        	    
  #10ns start   = 1'b1;      // pulse request to DUT
  #10ns start   = 1'b0;
  wait(halt);               // wait for ack from DUT
  $display();
  $display("start program 3");
  $display();
  $display("number of patterns w/o byte crossing    = %d %d",ctb,DUT.data_mem1.core[33]);   //160 max
  $display("number of bytes w/ at least one pattern = %d %d",cto,DUT.data_mem1.core[34]);   // 32 max
  $display("number of patterns w/ byte crossing     = %d %d",cts,DUT.data_mem1.core[35]);   //253 max
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

