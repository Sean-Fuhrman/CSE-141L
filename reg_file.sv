// Create Date:    2017.01.25
// Design Name:    CSE141L
// Module Name:    reg_file 
//
// Additional Comments: $clog2

module reg_file #(parameter W=8, D=3)(		 // W = data path width; D = pointer width
  input           CLK,
                  Reg_write_en,
  input  [D-1:0] Reg_write_address,
                 Reg_read_address_0,  //R0 if arithmetic
                 Reg_read_address_1,  //R1 if arithmetic
  input  [ W-1:0] Reg_write_data,
  output [ W-1:0] Source_0_data, 
  				  Source_1_data
    );

// W bits wide [W-1:0] and 2**4 registers deep 	 
logic [W-1:0] registers[2**D];	  // or just registers[16] if we know D=4 always

assign  Source_0_data = registers[Reg_read_address_0];
assign  Source_1_data = registers[Reg_read_address_1];              

// sequential (clocked) writes 
always @ (posedge CLK)
  if (Reg_write_en)	                             // && waddr requires nonzero pointer address
// if (write_en) if want to be able to write to address 0, as well
    registers[Reg_write_address] <= Reg_write_data;

endmodule
