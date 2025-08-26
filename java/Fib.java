public class Fib {
    public static int fib(int n) {
        if (n <= 1) return n;
        return fib(n - 1) + fib(n - 2);
    }
    
    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Usage: java Fib <n>");
            return;
        }
        
        int n = Integer.parseInt(args[0]);
        long startTime = System.currentTimeMillis();
        int result = fib(n);
        long endTime = System.currentTimeMillis();
        
        System.out.println("Java: fib(" + n + ") = " + result);
        System.out.println("Time: " + (endTime - startTime) + "ms");
    }
}