package assembler;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;
// this program functions as a simulator for KISS machine code, instead of going directly
// into the microprocessor this program converts all arithmetic operations to java 
// and simulates data memory and registers using arrays 
public class KissSim {



    private int[] registers;
    private int[] dat_mem;
    private int[] LUT; 
    private int currInstruction;
    private boolean LUT_set;
    private ArrayList<Instruction> instructions;
    public KissSim(int regCap, int dat_memCap, int LUT_size){
        registers = new int[regCap];
        dat_mem = new int[dat_memCap];
        LUT = new int[LUT_size];
        currInstruction = 0;
        LUT_set = false;
        instructions = new ArrayList<>();

    }

    public void setLut(int[] LUT_Vals) {
        if(LUT_set) {
            System.out.println("CANNOT OVERWRITE LUT ONCE SET!");
            System.exit(4);
        }
        for(int i = 0; i < LUT_Vals.length; i++){
            LUT[i] = LUT_Vals[i];
        }
        LUT_set = true;
    }

    // prints out "specs" of Kiss processor we are on (size of memory, number of registers, etc.)
    public void specs() {
        System.out.println("Number of registers:" + registers.length);
        System.out.println("size of dat_mem:" + dat_mem.length + " bytes" );
        System.out.println("size of LUT:" + LUT.length);
    }

    public void loadCode(String fileName){
        if(instructions.size() != 0) {
            System.out.println("ERROR: code has already been loaded in! can not run two programs on same simulator");
            System.exit(2);
        }
        File codeFile = new File(fileName);
        if(!codeFile.exists()) {
            System.out.println("ERROR: File specified does not exist, please try again");
            System.exit(1);
        }
        Scanner codeReader = null;
        try {
            codeReader = new Scanner(codeFile);
        } catch (FileNotFoundException e) {
            System.out.println("ERROR: FILE NOT FOUND!");
            System.exit(4);
        }
        while(codeReader.hasNextLine()){
            String currentLine = codeReader.nextLine();
            if(currentLine.length() > 0 && currentLine.compareTo("\n") != 0 ) {
                Instruction newInstruction = decode(currentLine);
                instructions.add(newInstruction);
            }
        }
    }

    private Instruction decode(String line) {
        int opcodeVal = 0;
        int operandOneVal = 0;
        int operandTwoVal = 0;
        String opcodeString = line.substring(0,3);
        // decode opcode value
        System.out.println(opcodeString);
        switch(opcodeString){
            case("ADD"): { 
                if(checkImmediate(3, line)) {
                    opcodeVal = InstructionValues.ADDI;
                } else {
                    opcodeVal = InstructionValues.ADD;
                }
                break;
            }
            case("LSL"): {
                if(checkImmediate(3, line)) {
                    opcodeVal = InstructionValues.LSLI;
                } else {
                    opcodeVal = InstructionValues.LSL;
                }
                break;
            }
            case("LSR"): {
                if(checkImmediate(3, line)) {
                    opcodeVal = InstructionValues.LSRI;
                } else {
                    opcodeVal = InstructionValues.LSL;
                }
                break;
            }
            case("XOR"): {
                opcodeVal = InstructionValues.XOR;
                break;
            } 
            case("AND"): {
                if(checkImmediate(3, line)) {
                    opcodeVal = InstructionValues.ADDI;
                } else {
                    opcodeVal = InstructionValues.ADD;
                }
                break;
            }
            case("CMP"): {
                if(checkImmediate(3, line)) {
                    opcodeVal = InstructionValues.CMPI;
                } else {
                    opcodeVal = InstructionValues.CMP;
                }
                break;
            }
            case("BAD"): {
                if(checkImmediate(4, line)) {
                    opcodeVal = InstructionValues.BADDI;
                } else {
                    opcodeVal = InstructionValues.BADD;
                }
                break;
            } 
            case("BSU"): {
                if(checkImmediate(4, line)) {
                    opcodeVal = InstructionValues.BSUBI;
                } else {
                    opcodeVal = InstructionValues.BADD;
                }
                break;
            }
            case("SUB"): {
                if(checkImmediate(3, line)) {
                    opcodeVal = InstructionValues.SUBI;
                } else {
                    opcodeVal = InstructionValues.SUB;
                }
                break;
            }
            case("SET"): {
                if(checkImmediate(3, line)) {
                    opcodeVal = InstructionValues.SETI;
                } else {
                    opcodeVal = InstructionValues.SET;
                }
                break;
            }
            case("MOV"): {
                opcodeVal = InstructionValues.MOVE;
                break;
            } 
            case("LOA"): {
                opcodeVal = InstructionValues.LOAD;
                break;
            }
            case("STO"): {
                opcodeVal = InstructionValues.STORE;
                break;
            }
            case("FLA"): {
                opcodeVal = InstructionValues.FLAG;
                break;
            }
            default: {
                System.out.println("ERROR: UNABLE TO DECIPHER LINE OF CODE:" + line);
                System.exit(3);
            }
        }

        //decode operand one
        for(int i = 0; i < line.length(); i++) {
            if(line.charAt(i) <= 57 && line.charAt(i) >= 48) {
                operandOneVal = line.charAt(i) - 48;
                break;
            }
        }

        // decode operand two 
        boolean seenOperandOne = false;
        for(int i = 0; i < line.length(); i++) {
            if(line.charAt(i) <= 57 && line.charAt(i) >= 48) {
                if(seenOperandOne) {
                    operandTwoVal = line.charAt(i) - 48;
                    break;
                }
                seenOperandOne = true;
            }
        }

    // create instruction and return it 
    return new Instruction(opcodeVal, operandOneVal, operandTwoVal);
    }

    private void executeInstruction(Instruction newInstruction) {
        switch(newInstruction.getOpcode()) {
            case(InstructionValues.ADD): {
                registers[2] = registers[1] + registers[0];
                break;
            }
            case(InstructionValues.ADDI): {
                registers[2] = registers[0] + newInstruction.getOperandOne();
                break;
            }
            case(InstructionValues.SUB): {
                registers[2] = registers[0] - registers[1];
                break;
            }
            case(InstructionValues.SUBI): {
                registers[2] = registers[0] - newInstruction.getOperandOne();
                break;
            }
            case(InstructionValues.LSL): {
                if(registers[0] == 0) {
                    registers[2] = 0;
                    break;
                }
                String binRep = Integer.toBinaryString(registers[0]);
                // pad with zero's if necessary
                while(binRep.length() != 8) {
                    binRep =  "0" + binRep; 
                }
                System.out.println(binRep);
                StringBuilder stringReverser = new StringBuilder(binRep);
                String binRepReverse = stringReverser.reverse().toString();
                int newVal = 0;
                for(int i = 0; i < 8 - registers[1]; i++) {
                    if(binRepReverse.charAt(i) == '1') {
                    newVal += Math.pow(2, i + registers[i]);
                    }
                }
                registers[2] = newVal;
                break;
            }
            case(InstructionValues.LSLI): {
                if(registers[0] == 0) {
                    registers[2] = 0;
                    break;
                } 
                String binRep = Integer.toBinaryString(registers[0]);
                // pad with zero's if necessary
                while(binRep.length() != 8 ) {
                    binRep = "0" + binRep;
                }
                System.out.println(binRep);
                StringBuilder stringReverser = new StringBuilder(binRep);
                String binRepReverse = stringReverser.reverse().toString();
                int newVal = 0;
                for(int i = 0; i < 8 - newInstruction.getOperandOne(); i++) {
                    if(binRepReverse.charAt(i) == '1') {
                    newVal += Math.pow(2, i + newInstruction.getOperandOne());
                    }
                }
                registers[2] = newVal;
                break;
            }
            case(InstructionValues.LSR): {
                registers[2] = registers[0] >> registers[1];
                break;
            }
            case(InstructionValues.LSRI): {
                registers[2] = registers[0] >>newInstruction.getOperandOne();
                break;
            } 
            case(InstructionValues.XOR): {
                registers[2] = registers[0] ^ registers[1];
                break;
            }
            case(InstructionValues.AND): {
                registers[2] = registers[0] & registers[1];
                break;
            }
            case(InstructionValues.ANDI): {
                registers[2] = registers[0] & newInstruction.getOperandOne();
                break;
            }
            case(InstructionValues.CMP): {
                if(instructions.size() == currInstruction + 1) {
                    break;
                }
                if((registers[0] == registers[1] && instructions.get(currInstruction + 1).getOpcode() == InstructionValues.BSUB)
                || (registers[0] == registers[1] && instructions.get(currInstruction + 1).getOpcode() == InstructionValues.BSUBI)
                || (registers[0] != registers[1] && instructions.get(currInstruction + 1).getOpcode() == InstructionValues.BADD)
                || (registers[0] != registers[1] && instructions.get(currInstruction + 1).getOpcode() == InstructionValues.BSUBI)) {
                    currInstruction ++;
                }
                break;
            }
            case(InstructionValues.CMPI): {
                if(instructions.size() == currInstruction + 1) {
                    break;
                }
                if((registers[0] == newInstruction.getOperandOne() && instructions.get(currInstruction + 1).getOpcode() == InstructionValues.BSUB)
                || (registers[0] == newInstruction.getOperandOne() && instructions.get(currInstruction + 1).getOpcode() == InstructionValues.BSUBI)
                || (registers[0] != newInstruction.getOperandOne() && instructions.get(currInstruction + 1).getOpcode() == InstructionValues.BADD)
                || (registers[0] != newInstruction.getOperandOne() && instructions.get(currInstruction + 1).getOpcode() == InstructionValues.BSUBI)) {
                    currInstruction ++;
                }
                break;
            }
            case(InstructionValues.BADD): {
                currInstruction = LUT[newInstruction.getOperandOne()] - 1;
                break;
            }
            case(InstructionValues.BADDI): {
                currInstruction = currInstruction + newInstruction.getOperandOne() - 1;
                break;
            }
            case(InstructionValues.BSUB): { 
                currInstruction = LUT[newInstruction.getOperandOne()] - 1;
                break;
            }
            case(InstructionValues.BSUBI): {
                currInstruction = currInstruction + newInstruction.getOperandOne() - 1;
                break;
            }
            case(InstructionValues.SET): {
                registers[2] = registers[0];
                break;
            }
            case(InstructionValues.SETI): {
                registers[2] = newInstruction.getOperandOne();
                break;
            }
            case(InstructionValues.MOVE): {
                registers[newInstruction.getOperandOne()] = registers[newInstruction.getOperandTwo()];
                break;
            }
            case(InstructionValues.LOAD): {
                registers[newInstruction.getOperandOne()] = dat_mem[registers[newInstruction.getOperandTwo()]];
                break;
            }
            case(InstructionValues.STORE): {
                dat_mem[registers[newInstruction.getOperandOne()]] = registers[newInstruction.getOperandTwo()];
                break;
            }
            case(InstructionValues.FLAG): {
                int numOnes = 0;
                String binString = Integer.toBinaryString(registers[newInstruction.getOperandTwo()]);
                for(int i = 0; i < binString.length(); i++) {
                    if(binString.charAt(i) == '1') {
                        numOnes ++;
                    }
                }
                if(numOnes % 2 == 1) {
                    registers[newInstruction.getOperandOne()] = 0b00001000;
                } else {
                    registers[newInstruction.getOperandOne()] = 0b00000000;
                }
                break;

            }
            default: {
                System.out.println("INSTRUCTION ON LINE " + currInstruction + " HAS BEEN CORRUPTED");
                System.exit(3);
            }
        }
        currInstruction ++;
    }

    public void executeInstructions(int numInstructions) {
        for(int i = 1; i <= numInstructions; i++) {
            executeInstruction(instructions.get(currInstruction));
            currInstruction ++;
            if(currInstruction >= 1024) {
                System.out.println("DONE FLAG RAISED!");
                System.exit(0);
            }
        }
    }

    public void executeInstructionsDebug(int numInstructions) {
        for(int i = 0; i < numInstructions; i++) {
            System.out.println("EXECUTING INSTRUCTION AT LINE: " + currInstruction);
            Instruction execute = instructions.get(currInstruction);
            System.out.println("instruction corresponds to command: " + execute.toString());
            System.out.println("register values before instruction");
            printRegVal();
            executeInstruction(execute);
            System.out.println("register values post instruction");
            printRegVal();
        }
    }


    public void restartProg() {
        clearMemory();
        currInstruction = 0;
    }

    private void clearMemory() {
        for(int i = 0; i < registers.length; i++) {
            registers[i] = 0;
        }
        for(int i = 0; i < dat_mem.length; i++) {
            dat_mem[i] = 0;
        }
    }

    public void printRegVal() {
        for(int i = 0; i < registers.length; i++) {
            System.out.print("Register " + i +" stores:" + registers[i] + " ");
            if(i != 0 && i % 4 == 0) {
                System.out.println();
            }
        }
        System.out.println();
    }

    public void printMemVal() {
        for(int i = 0;  i < dat_mem.length; i++) {
            if(dat_mem[i] != 0) {
                System.out.print("dat_mem at location " + i + " stores:" + dat_mem[i] + " ");
            }
        }
        System.out.println();
    }

    private boolean checkImmediate(int index, String str) {
        if(str.length() <= index) {
            return false;
        }
        return str.charAt(index) == 'I';
    }

    public void setMemVal(int value, int index) {
        dat_mem[index] = value;
    }
    
    public void setRegVal(int value, int index) {
        registers[index] = value;
    }
}
    