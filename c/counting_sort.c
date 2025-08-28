#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

void counting_sort(int arr[], int n, int max_val) {
    int* count = calloc(max_val + 1, sizeof(int));
    int* output = malloc(n * sizeof(int));
    
    if (!count || !output) {
        if (count) free(count);
        if (output) free(output);
        return;
    }
    
    // Count occurrences - add bounds checking
    for (int i = 0; i < n; i++) {
        if (arr[i] >= 0 && arr[i] <= max_val) {
            count[arr[i]]++;
        }
    }
    
    // Change count[i] so that it contains position of this character in output array
    for (int i = 1; i <= max_val; i++) {
        count[i] += count[i - 1];
    }
    
    // Build output array - add bounds checking
    for (int i = n - 1; i >= 0; i--) {
        if (arr[i] >= 0 && arr[i] <= max_val && count[arr[i]] > 0) {
            output[count[arr[i]] - 1] = arr[i];
            count[arr[i]]--;
        }
    }
    
    // Copy output array to arr
    for (int i = 0; i < n; i++) {
        arr[i] = output[i];
    }
    
    free(count);
    free(output);
}

void generate_array(int arr[], int n, int max_val) {
    for (int i = 0; i < n; i++) {
        // Use safer generation to avoid overflow and ensure positive numbers
        unsigned int val = ((unsigned int)(i * 7) + ((unsigned int)(i % 1000) * 3)) % (unsigned int)(max_val + 1);
        arr[i] = (int)val;
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: counting_sort <n>\n");
        return 1;
    }
    
    int n = atoi(argv[1]);
    int max_val = 999;  // Maximum value in array
    int* arr = malloc(n * sizeof(int));
    if (!arr) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    generate_array(arr, n, max_val);
    
    clock_t start = clock();
    counting_sort(arr, n, max_val);
    clock_t end = clock();
    
    double time_ms = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    
    // Calculate checksum to verify correctness
    long checksum = 0;
    for (int i = 0; i < n; i++) {
        checksum += arr[i];
    }
    
    printf("C: counting_sort(%d) = %ld\n", n, checksum);
    printf("Time: %.0fms\n", time_ms);
    
    free(arr);
    return 0;
}