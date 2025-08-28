#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

void reverse_string(char* str, int len) {
    int start = 0;
    int end = len - 1;
    
    while (start < end) {
        char temp = str[start];
        str[start] = str[end];
        str[end] = temp;
        start++;
        end--;
    }
}

char* generate_string(int len) {
    char* str = malloc((len + 1) * sizeof(char));
    if (!str) return NULL;
    
    for (int i = 0; i < len; i++) {
        str[i] = 'A' + (i % 26);
    }
    str[len] = '\0';
    return str;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: string_reverse <length>\n");
        return 1;
    }
    
    int len = atoi(argv[1]);
    char* str = generate_string(len);
    if (!str) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    clock_t start = clock();
    reverse_string(str, len);
    clock_t end = clock();
    
    double time_ms = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    
    // Calculate checksum to verify correctness
    long checksum = 0;
    for (int i = 0; i < len; i++) {
        checksum += str[i];
    }
    
    printf("C: string_reverse(%d) = %ld\n", len, checksum);
    printf("Time: %.0fms\n", time_ms);
    
    free(str);
    return 0;
}