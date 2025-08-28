#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void matrix_multiply(int** a, int** b, int** c, int size) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            c[i][j] = 0;
            for (int k = 0; k < size; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

int** allocate_matrix(int size) {
    int** matrix = malloc(size * sizeof(int*));
    for (int i = 0; i < size; i++) {
        matrix[i] = malloc(size * sizeof(int));
    }
    return matrix;
}

void free_matrix(int** matrix, int size) {
    for (int i = 0; i < size; i++) {
        free(matrix[i]);
    }
    free(matrix);
}

void init_matrix(int** matrix, int size, int seed_offset) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            matrix[i][j] = (i * 3 + j * 7 + seed_offset) % 100;
        }
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: matrix_multiply <size>\n");
        return 1;
    }
    
    int size = atoi(argv[1]);
    
    int** a = allocate_matrix(size);
    int** b = allocate_matrix(size);
    int** c = allocate_matrix(size);
    
    init_matrix(a, size, 0);
    init_matrix(b, size, 1);
    
    clock_t start = clock();
    matrix_multiply(a, b, c, size);
    clock_t end = clock();
    
    double time_ms = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    
    // Calculate checksum to verify correctness
    long checksum = 0;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            checksum += c[i][j];
        }
    }
    
    printf("C: matrix_multiply(%d) = %ld\n", size, checksum);
    printf("Time: %.0fms\n", time_ms);
    
    free_matrix(a, size);
    free_matrix(b, size);
    free_matrix(c, size);
    
    return 0;
}