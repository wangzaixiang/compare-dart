#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

int prime_sieve(int n) {
    int* is_prime = malloc((n + 1) * sizeof(int));
    if (!is_prime) return -1;
    
    // Initialize all as prime
    for (int i = 0; i <= n; i++) {
        is_prime[i] = 1;
    }
    is_prime[0] = is_prime[1] = 0;
    
    for (int i = 2; i * i <= n; i++) {
        if (is_prime[i]) {
            for (int j = i * i; j <= n; j += i) {
                is_prime[j] = 0;
            }
        }
    }
    
    int count = 0;
    for (int i = 2; i <= n; i++) {
        if (is_prime[i]) count++;
    }
    
    free(is_prime);
    return count;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: prime_sieve <n>\n");
        return 1;
    }
    
    int n = atoi(argv[1]);
    
    clock_t start = clock();
    int count = prime_sieve(n);
    clock_t end = clock();
    
    double time_ms = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    
    printf("C: prime_sieve(%d) = %d\n", n, count);
    printf("Time: %.0fms\n", time_ms);
    
    return 0;
}