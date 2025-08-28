#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int mandelbrot(double x0, double y0, int max_iter) {
    double x = 0.0;
    double y = 0.0;
    int iteration = 0;
    
    while (x*x + y*y <= 4.0 && iteration < max_iter) {
        double xtemp = x*x - y*y + x0;
        y = 2*x*y + y0;
        x = xtemp;
        iteration++;
    }
    return iteration;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: mandelbrot <size>\n");
        return 1;
    }
    
    int size = atoi(argv[1]);
    int max_iter = 100;
    
    clock_t start = clock();
    
    int count = 0;
    for (int py = 0; py < size; py++) {
        for (int px = 0; px < size; px++) {
            double x0 = (px - size/2.0) * 3.0 / size;
            double y0 = (py - size/2.0) * 3.0 / size;
            int iter = mandelbrot(x0, y0, max_iter);
            if (iter < max_iter) count++;
        }
    }
    
    clock_t end = clock();
    double time_ms = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    
    printf("C: mandelbrot(%d) = %d\n", size, count);
    printf("Time: %.0fms\n", time_ms);
    
    return 0;
}