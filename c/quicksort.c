#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int partition(int arr[], int low, int high) {
    int pivot = arr[high];
    int i = low - 1;
    
    for (int j = low; j <= high - 1; j++) {
        if (arr[j] < pivot) {
            i++;
            swap(&arr[i], &arr[j]);
        }
    }
    swap(&arr[i + 1], &arr[high]);
    return i + 1;
}

void quicksort(int arr[], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quicksort(arr, low, pi - 1);
        quicksort(arr, pi + 1, high);
    }
}

void generate_array(int arr[], int n) {
    srand(42);
    for (int i = 0; i < n; i++) {
        arr[i] = rand() % 10000;
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: quicksort <n>\n");
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
    quicksort(arr, 0, n - 1);
    clock_t end = clock();
    
    double time_ms = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    
    printf("C: quicksort(%d) = sorted\n", n);
    printf("Time: %.0fms\n", time_ms);
    
    free(arr);
    return 0;
}