public class counting_sort {
    
    public static void countingSort(int[] arr, int n, int maxVal) {
        int[] count = new int[maxVal + 1];
        int[] output = new int[n];
        
        // Count occurrences - add bounds checking
        for (int i = 0; i < n; i++) {
            if (arr[i] >= 0 && arr[i] <= maxVal) {
                count[arr[i]]++;
            }
        }
        
        // Change count[i] so that it contains position of this character in output array
        for (int i = 1; i <= maxVal; i++) {
            count[i] += count[i - 1];
        }
        
        // Build output array - add bounds checking
        for (int i = n - 1; i >= 0; i--) {
            if (arr[i] >= 0 && arr[i] <= maxVal && count[arr[i]] > 0) {
                output[count[arr[i]] - 1] = arr[i];
                count[arr[i]]--;
            }
        }
        
        // Copy output array to arr
        for (int i = 0; i < n; i++) {
            arr[i] = output[i];
        }
    }
    
    public static int[] generateArray(int n, int maxVal) {
        int[] arr = new int[n];
        for (int i = 0; i < n; i++) {
            // Use safer generation to avoid overflow and ensure positive numbers
            long val = ((long)(i * 7) + ((long)(i % 1000) * 3)) % (long)(maxVal + 1);
            arr[i] = (int)val;
        }
        return arr;
    }
    
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: counting_sort <n>");
            return;
        }
        
        int n = Integer.parseInt(args[0]);
        int maxVal = 999;
        int[] arr = generateArray(n, maxVal);
        
        long start = System.currentTimeMillis();
        countingSort(arr, n, maxVal);
        long end = System.currentTimeMillis();
        
        // Calculate checksum to verify correctness
        long checksum = 0;
        for (int i = 0; i < n; i++) {
            checksum += arr[i];
        }
        
        long timeMs = end - start;
        
        System.out.println("Java: counting_sort(" + n + ") = " + checksum);
        System.out.println("Time: " + timeMs + "ms");
    }
}