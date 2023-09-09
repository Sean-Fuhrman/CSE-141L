package assembler;

public class kissTest {
    private static final String fileName = "C:\\Users\\14252\\CSE-141L\\assembler\\Kiss_Progs\\TestProg";
    public static void main(String[] args) {
        KissSim simulator = new KissSim(8,256,8);
        int[] LUT = new int[]{0,351,418,390,0,0,0,1024};
        simulator.setLut(LUT);
        simulator.specs();
        simulator.loadCode(fileName);    
        for(int i = 0; i <= 29; i++) {
            simulator.setMemVal(0b11111111, i); // LOWER 8 BITS - STORED IN R6
        }
        simulator.executeInstructionsDebug(500);
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
        
        // PROG 2 TESTING CODE

        /*
        // hamming encoding of 000 0000 0000
        simulator.setMemVal(0, 128);// LSW INPUT 
        simulator.setMemVal(0b110000000, 0); // MSW INPUT
        simulator.setMemVal(0b00000000, 1); //LSW INPUT
        simulator.setMemVal(0b110000000, 58); // MSW INPUT
        simulator.setMemVal(0b00000000, 59); //LSW INPUT
        System.out.println("CORRECTED INPUT MSW: " + simulator.readMemVal(58));
        System.out.println("CORRECTED INPUT LSW: " + simulator.readMemVal(59));
        System.out.println("CORRECT OUTPUT MSW: " + simulator.readMemVal(28));
        System.out.println("CORRECT OUTPUT LSW: " + simulator.readMemVal(29));
        System.out.println(" i = " + simulator.readMemVal(128));
        */
        