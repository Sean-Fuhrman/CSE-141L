package assembler;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

public class KissAsm {
    private final static String inputFileName = "C:\\Users\\14252\\CSE-141L\\assembler\\kiss_assembly.txt";
    private final static String outputFileName = "C:\\Users\\14252\\CSE-141L\\assembler\\Kiss.bin";
    static int lineNumber = 0;
    public static void main (String[] args) throws IOException {
        /* 
        if(args.length == 0) {
            System.out.println("please provide a file name storing the instructions");
            System.exit(1);
        }
        */

        // create a scanner object to read from the given file containing KISS instructions
        Scanner instructionFile = null;
        try {
            instructionFile = new Scanner(new File(inputFileName));
        } catch (Exception e) {
            System.out.println("File with name \"" + inputFileName + "\" not found in the current directory! please try again");
            System.exit(1);
        }

        // construct a new file to store the machine code output
        File outputFile = new File(outputFileName);
        
        // construct a file writer object which writes to the output file
        FileWriter outputFileWrite = null;
        try {
            outputFileWrite = new FileWriter(outputFile);
        } catch (Exception e) {
            System.out.println("UNEXPECTED EXCEPTION: " + e.toString());
            System.exit(1);
        }


        // write decoded instructions to output file
        while(instructionFile.hasNextLine()) {
            System.out.println("BEGAN FILE READ");
            String nextLine = instructionFile.nextLine();
            System.out.println(nextLine);
            if(nextLine.compareTo("\n") == 1) {
                lineNumber ++;
                continue;
            }
            outputFileWrite.write(decodeLine(nextLine), 0, 9);
            outputFileWrite.write("\n", 0, 1);
            lineNumber ++;
            outputFileWrite.flush();
        }
        outputFileWrite.close();
        System.out.println("file compiled succesfully, machine code is now stored in " + outputFileName);
    }
          
    private static String decodeLine(String line) {
        System.out.println(line);
        String instructionTitle = null;
        if(line.length() == 3) {
            instructionTitle = line;
        } else {
            instructionTitle = line.substring(0, 3);
        }
        
        System.out.println(instructionTitle);
        
        switch(instructionTitle) {
            case("ADD"): return arithmeticInstruction(line, "000");
            case("LSL"): return arithmeticInstruction(line, "001");
            case("XOR"): return arithmeticInstruction(line, "010");
            case("AND"): return arithmeticInstruction(line, "011");
            case("CMP"): return arithmeticInstruction(line, "100");
            case("LSR"): return arithmeticInstruction(line, "101");
            case("SET"): return arithmeticInstruction(line,"110");
            case("SUB"): return arithmeticInstruction(line, "111");
            case("BEA"): return branchInstruction(line, "000");
            case("BER"): return branchInstruction(line, "001");
            case("BNA"): return branchInstruction(line, "010");
            case("BNR"): return branchInstruction(line, "011");
            case("BUN"): return branchInstruction(line, "100");
            case("MOV"): return datMoveInstruction(line, "00");
            case("FLA"): return datMoveInstruction(line, "01");
            case("LOA"): return datMoveInstruction(line, "10");
            case("STO"): return datMoveInstruction(line, "11");
            default: {
                System.out.println("invalid instruction at line " + lineNumber);
                System.exit(2);
            }
        }
        return instructionTitle;

    }

    private static String datMoveInstruction(String line, String opcode) {
        int operandOneStart = findSpace(line, 1);
        int operandTwoStart = findSpace(line, 2);
        int operandTwoEnd = findSpace(line, 3);
        String destinationRegister =  line.substring(operandOneStart+2, operandTwoStart);
        String sourceRegister = line.substring(operandTwoStart+2, operandTwoEnd);
        String binDestString = decToBin(destinationRegister);
        String binSrcString = decToBin(sourceRegister);
        return  "1" + opcode + binDestString + binSrcString;
    }


    private static String branchInstruction(String line, String opcode) {
        int regStart = findSpace(line, 1);
        String binImmString = decToBin(line.substring(regStart + 1));
        return "011" + opcode + binImmString;
    }

    private static String arithmeticInstruction(String line, String opcode) {
        if(line.length() >= 4 && line.charAt(3) == 'I') {
            int immediateOpStart = findSpace(line, 1);
            String binImmString = decToBin(line.substring(immediateOpStart + 1));
            return "010" + opcode + binImmString;
        }
        return "000" + opcode + "000";
    }

    private static String decToBin(String sourceRegister) {
        System.out.println(" DECIMAL VALUE = " + sourceRegister);
        String integer = String.valueOf(sourceRegister.charAt(0));
        int decVal = Integer.parseInt(integer);
        System.out.println(decVal);
        if(decVal > 7 || decVal < 0) {
            System.out.println("ERROR ON LINE:" + lineNumber + "register pointer/immediate must be within [0,7]");
        }
        // must pad the string to ensure it is 3 bits long
        if(decVal <= 1) {
            return "00" + Integer.toBinaryString(decVal);
        }
        if(decVal <= 3) {
            return "0" + Integer.toBinaryString(decVal);
        }
        return Integer.toBinaryString(decVal);
    }

    
    private static int findSpace(String line, int numSpaces) {
        int spacesFound = 0;
        for(int i = 1; i < line.length(); i++) {
            if(line.charAt(i) == ' ') {
                spacesFound ++;
                if(spacesFound == numSpaces) {
                    return i;
                }
            }
        }
        if(spacesFound == numSpaces - 1) {
            return line.length();
        }
        System.out.println("ERROR ON LINE:" + lineNumber + "incorrect spacing");
        System.exit(2);
        return 0;
    }

}