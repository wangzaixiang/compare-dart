#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int move_count = 0;

void hanoi_tower(int n, char from, char to, char aux) {
    if (n == 1) {
        move_count++;
        return;
    }
    
    hanoi_tower(n - 1, from, aux, to);
    move_count++;
    hanoi_tower(n - 1, aux, to, from);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: hanoi_tower <n>\n");
        return 1;
    }
    
    int n = atoi(argv[1]);
    move_count = 0;
    
    clock_t start = clock();
    hanoi_tower(n, 'A', 'C', 'B');
    clock_t end = clock();
    
    double time_ms = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    
    printf("C: hanoi_tower(%d) = %d\n", n, move_count);
    printf("Time: %.0fms\n", time_ms);
    
    return 0;
}