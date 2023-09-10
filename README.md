# CSE 141L

[video presentation](https://drive.google.com/drive/folders/1HmsRpzn0iwFm-ZPn1IrzISTMuJK_Xp3M?usp=sharing)

## Overview
in order to correctly run our code please place the KISS assembly code you wish to run in the 
file kiss_assembly.txt inside of the assembler directory, then run the KissAsm class.
the outputted machine code will be stored in Kiss.bin inside of the assembler directory, 
you may then run this code in questa or modelsim or wherever you wish by placing the code
into the file storing all instruction memory, and compiling and running whatever test bench you please. 

If you wish to see a more detailed view of what exactly is happening within each instruction feel free to use our simulator which gives a detailed overview of each command, and outputs the reg data pre and post every command- this can be done by placing your machine code in the TestProg file and then running the kissTest file with the commands evident in the simulator class.

## Detailed Walkthrough

### Assembler

To assemble your code, place your code into kiss_assembly.txt (or whatever is at the top of KissAsm.java file). Then run the main function of KissAsm.java and the result will be placed into kiss.bin. This is automatically linked to our instruction ROM

Inside our assembler folder there is the code for Prog1, Prog2, and Prog3 inside the Kiss_Progs folder

### Processor

To compile our processor in Quartus, you have to compile TopLevel.sv, reg_file.sv, PC.sv, LUT.sv, inst_rom2.sv, definitions.sv, 
data_mem.sv, Ctrl.sv, and ALU.sv. TopLevel is the main module and the files control their respective sub-modules. Inst_rom2 contains the link which loads in the assembly.

In addition to getting the assembly code assembled, you must also use the correct LUT for each program. We keep the LUTs in LUT.txt. Make sure to put the code in LUT.txt inside 
the switch statement in LUT.sv as all of our programs use different LUTs. 

### Test Bench

For the programs, we have test benches prog1_tb.sv, prog2_tb.sv, and prog3_tb.sv. All these test benches generate random test cases to thoroughly test our programs. These can be 
simulated in Questa