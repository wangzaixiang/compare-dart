import java.util.Random;

public class quicksort {
    
    public static void quicksort(int[] arr, int low, int high) {
        if (low < high) {
            int pi = partition(arr, low, high);
            quicksort(arr, low, pi - 1);
            quicksort(arr, pi + 1, high);
        }
    }
    
    public static int partition(int[] arr, int low, int high) {
        int pivot = arr[high];
        int i = low - 1;
        
        for (int j = low; j <= high - 1; j++) {
            if (arr[j] < pivot) {
                i++;
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
        int temp = arr[i + 1];
        arr[i + 1] = arr[high];
        arr[high] = temp;
        return i + 1;
    }
    
    public static int[] generateArray(int n) {
        Random random = new Random(42);
        int[] arr = new int[n];
        for (int i = 0; i < n; i++) {
            arr[i] = random.nextInt(10000);
        }
        return arr;
    }
    
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: quicksort <n>");
            return;
        }
        
        int n = Integer.parseInt(args[0]);
        int[] arr = generateArray(n);
        
        long start = System.currentTimeMillis();
        quicksort(arr, 0, n - 1);
        long end = System.currentTimeMillis();
        
        long timeMs = end - start;
        
        System.out.println("Java: quicksort(" + n + ") = sorted");
        System.out.println("Time: " + timeMs + "ms");
    }
}