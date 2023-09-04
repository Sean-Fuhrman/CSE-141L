package assembler;

public class kissTest {
    private static final String fileName = "C:\\Users\\14252\\CSE-141L\\assembler\\Kiss_Progs\\TestProg";
    public static void main(String[] args) {
        KissSim simulator = new KissSim(8,256,8);
        simulator.specs();
        simulator.loadCode(fileName);
        simulator.setMemVal(0b11111111, 0); // LOWER 8 BITS - STORED IN R6
        simulator.setMemVal(0b00000111, 1); // UPPER 3 BITS - STORED IN R7
        simulator.executeInstructionsDebug(122);

    }
    
}
