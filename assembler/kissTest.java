package assembler;

public class kissTest {
    private static final String fileName = "C:\\Users\\14252\\CSE-141L\\assembler\\Kiss_Progs\\TestProg";
    public static void main(String[] args) {
        KissSim simulator = new KissSim(8,256,8);
        int[] LUT = new int[]{0,351,418,390,0,0,0,1024};
        simulator.setLut(LUT);
        simulator.specs();
        simulator.loadCode(fileName);
        // hamming encoding of 000 0000 0000
        simulator.setMemVal(0, 128);
        simulator.setMemVal(0b00000000, 30); // MSW INPUT
        simulator.setMemVal(0b00000000, 31); // LSW INPUT 
        simulator.executeInstructionsDebug(5850);
        
        System.out.println("CORRECTED INPUT MSW: " + simulator.readMemVal(30));
        System.out.println("CORRECTED INPUT LSW: " + simulator.readMemVal(31));
        System.out.println("CORRECT OUTPUT MSW: " + simulator.readMemVal(0));
        System.out.println("CORRECT OUTPUT LSW: " + simulator.readMemVal(0));
        System.out.println(" i = " + simulator.readMemVal(128));
        
        
        
    } 
    
}



/* PROG ONE TESTING COD
KissSim simulator = new KissSim(8,256,8);
        int[] LUT = new int[]{0,0,0,0,0,0,0,1024};
        simulator.setLut(LUT);
        simulator.specs();
        simulator.loadCode(fileName);
        for(int i = 0; i <= 29; i++) {
        simulator.setMemVal(0b000000101, i); // LOWER 8 BITS - STORED IN R6
        }
        simulator.executeInstructionsDebug(6360);
        for(int i = 0; i < 30; i+=2) {
            String lowerHamCode = Integer.toBinaryString(simulator.readMemVal(30 + i));
            String upperHamCode = Integer.toBinaryString(simulator.readMemVal(30 + i + 1));
            // pad with zeros to get to 16 bits
            while(lowerHamCode.length() != 8) {
                lowerHamCode = "0" + lowerHamCode;
            }
            while(upperHamCode.length() != 8) {
                upperHamCode = "0" + upperHamCode;
            }
        
            System.out.println("OUTPUT HAMMING CODE = " + upperHamCode + lowerHamCode + " for index " + i);
        }     
        */   