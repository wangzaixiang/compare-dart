public class hanoi_tower {
    
    private static int moveCount = 0;
    
    public static void hanoiTower(int n, char from, char to, char aux) {
        if (n == 1) {
            moveCount++;
            return;
        }
        
        hanoiTower(n - 1, from, aux, to);
        moveCount++;
        hanoiTower(n - 1, aux, to, from);
    }
    
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: hanoi_tower <n>");
            return;
        }
        
        int n = Integer.parseInt(args[0]);
        moveCount = 0;
        
        long start = System.currentTimeMillis();
        hanoiTower(n, 'A', 'C', 'B');
        long end = System.currentTimeMillis();
        
        long timeMs = end - start;
        
        System.out.println("Java: hanoi_tower(" + n + ") = " + moveCount);
        System.out.println("Time: " + timeMs + "ms");
    }
}