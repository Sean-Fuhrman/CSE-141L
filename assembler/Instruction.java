package assembler;

public class Instruction{
    private int opcode;
    private int operandOne;
    private int operandTwo;
    Instruction (int opcode, int operandOne, int operandTwo) {
        this.opcode = opcode;
        this.operandOne = operandOne;
        this.operandTwo = operandTwo;
    }

    public int getOpcode() {
        return opcode;
    }
    
    public int getOperandOne() {
        return operandOne;
    }

    public int getOperandTwo() {
        return operandTwo;
    }

    public String toString() {
        String operand;
        switch(opcode) {
            case(InstructionValues.ADD): {
                operand = "ADD";
                break;
            }
            case(InstructionValues.ADDI): {
                operand = "ADDI";
                break;
            }
            case(InstructionValues.SUB): {
                operand = "SUB";
                break;
            }
            case(InstructionValues.SUBI): {
                operand = "SUBI";
                break;
            }
            case(InstructionValues.LSL): {
                operand = "LSL";
                break;
            }
            case(InstructionValues.LSLI): {
                 operand = "LSLI";
                 break;
            }
            case(InstructionValues.LSR): {
                operand = "LSR";
                break;
            }
            case(InstructionValues.LSRI): {
                operand = "LSRI";
                break;
            }
            case(InstructionValues.XOR): {
                operand = "XOR";
                break;
            }
            case(InstructionValues.AND): {
                operand = "AND";
                break;
            }
            case(InstructionValues.ANDI): {
                operand = "ANDI";
                break;
            }
            case(InstructionValues.CMP): {
                operand = "CMP";
                break;
            }
            case(InstructionValues.CMPI): {
                operand = "CMPI";
                break;
            }
            case(InstructionValues.BADD): {
                operand = "BADD";
                break;
            }
            case(InstructionValues.BADDI): {
                operand = "BADDI";
                break;
            }
            case(InstructionValues.BSUB): {
                operand = "BSUB";
                break;
            }
            case(InstructionValues.BSUBI): {
                operand = "BSUBI";
                break;
            }
            case(InstructionValues.SET): {
                operand = "SET";
                break;
            }
            case(InstructionValues.SETI): {
                operand = "SETI";
                break;
            }
            case(InstructionValues.MOVE): {
                operand = "MOVE";
                break;
            }
            case(InstructionValues.LOAD): {
                operand = "LOAD";
                break;
            }
            case(InstructionValues.STORE): {
                operand = "STORE";
                break;
            }
            case(InstructionValues.FLAG): {
                operand = "FLAG";
                break;
            }
            default: {
                operand = "ERR";
                break;
            }
        }
        return operand + " " + operandOne + " " + operandTwo;
    }
}