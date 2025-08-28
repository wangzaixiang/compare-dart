import java.util.Random;

public class bubble_sort {
    
    public static void bubbleSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = i + 1; j < n; j++) {
                if (arr[i] > arr[j]) {
                    int temp = arr[j];
                    arr[j] = arr[i];
                    arr[i] = temp;
                }
            }
        }
    }
    
    public static int[] generateArray(int n) {
        Random random = new Random(42); // Fixed seed for reproducible results
        int[] arr = new int[n];
        for (int i = 0; i < n; i++) {
            arr[i] = random.nextInt(10000);
        }
        return arr;
    }
    
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: BubbleSort <n>");
            return;
        }
        
        int n = Integer.parseInt(args[0]);
        int[] arr = generateArray(n);
        
        long start = System.currentTimeMillis();
        bubbleSort(arr);
        long end = System.currentTimeMillis();
        
        long timeMs = end - start;
        
        System.out.println("Java: bubble_sort(" + n + ") = sorted");
        System.out.println("Time: " + timeMs + "ms");
    }
}