#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

void bubble_sort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

void generate_array(int arr[], int n) {
    srand(42);  // Fixed seed for reproducible results
    for (int i = 0; i < n; i++) {
        arr[i] = rand() % 10000;
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: bubble_sort <n>\n");
        return 1;
    }
    
    int n = atoi(argv[1]);
    int* arr = malloc(n * sizeof(int));
    if (!arr) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    generate_array(arr, n);
    
    clock_t start = clock();
    bubble_sort(arr, n);
    clock_t end = clock();
    
    double time_ms = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    
    printf("C: bubble_sort(%d) = sorted\n", n);
    printf("Time: %.0fms\n", time_ms);
    
    free(arr);
    return 0;
}