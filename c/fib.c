#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: fib <n>\n");
        return 1;
    }
    
    int n = atoi(argv[1]);
    clock_t start = clock();
    int result = fib(n);
    clock_t end = clock();
    
    double time_ms = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    
    printf("C: fib(%d) = %d\n", n, result);
    printf("Time: %.0fms\n", time_ms);
    
    return 0;
}