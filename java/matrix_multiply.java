import java.util.Random;

public class matrix_multiply {
    
    public static void matrixMultiply(int[][] a, int[][] b, int[][] c, int size) {
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                c[i][j] = 0;
                for (int k = 0; k < size; k++) {
                    c[i][j] += a[i][k] * b[k][j];
                }
            }
        }
    }
    
    public static int[][] allocateMatrix(int size) {
        return new int[size][size];
    }
    
    public static void initMatrix(int[][] matrix, int size, int seedOffset) {
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                matrix[i][j] = (i * 3 + j * 7 + seedOffset) % 100;
            }
        }
    }
    
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: matrix_multiply <size>");
            return;
        }
        
        int size = Integer.parseInt(args[0]);
        
        int[][] a = allocateMatrix(size);
        int[][] b = allocateMatrix(size);
        int[][] c = allocateMatrix(size);
        
        initMatrix(a, size, 0);
        initMatrix(b, size, 1);
        
        long start = System.currentTimeMillis();
        matrixMultiply(a, b, c, size);
        long end = System.currentTimeMillis();
        
        // Calculate checksum to verify correctness
        long checksum = 0;
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                checksum += c[i][j];
            }
        }
        
        long timeMs = end - start;
        
        System.out.println("Java: matrix_multiply(" + size + ") = " + checksum);
        System.out.println("Time: " + timeMs + "ms");
    }
}