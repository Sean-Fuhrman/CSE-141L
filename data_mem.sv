// Create Date:    2017.01.25
// Design Name:
// Module Name:    DataRAM
// single address pointer for both read and write
// CSE141L
module data_mem(
  input              CLK,
  input              reset,
  input [7:0]        Data_address,
  input              Data_read_en,
  input              Data_write_en,
  input [7:0]        Data_memory_in,
  output logic[7:0]  Data_memory_out
  );

  logic [7:0] core[256];

//  initial 
//    $readmemh("dataram_init.list", my_memory);
  always_comb                     // reads are combinational
    if(Data_read_en) begin
      Data_memory_out = core[Data_address];
// optional diagnostic print
	  $display("Memory read M[%d] = %d",DataAddress,DataOut);
    end else 
      Data_memory_out = 'bZ;           // tristate, undriven

  always_ff @ (posedge CLK)		 // writes are sequential
    if(reset) begin
// you may initialize your memory w/ constants, if you wish
      for(int i=0;i<256;i++)
	    core[i] <= 0;
      core[ 16] <= 254;   // overrides the 0
      core[244] <= 5;
	end
    else if(Data_write_en) begin
      core[Data_address] <= Data_memory_in;
// optional diagnostic print statement
	  $display("Memory write M[%d] = %d",DataAddress,DataIn);
    end

endmodule
