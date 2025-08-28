import sys
import time

def mandelbrot(x0, y0, max_iter):
    x = 0.0
    y = 0.0
    iteration = 0
    
    while x*x + y*y <= 4.0 and iteration < max_iter:
        xtemp = x*x - y*y + x0
        y = 2*x*y + y0
        x = xtemp
        iteration += 1
    return iteration

if len(sys.argv) < 2:
    print('Usage: mandelbrot <size>')
    sys.exit(1)

try:
    size = int(sys.argv[1])
except ValueError:
    print('Invalid number:', sys.argv[1])
    sys.exit(1)

max_iter = 100

start = time.time()

count = 0
for py in range(size):
    for px in range(size):
        x0 = (px - size/2.0) * 3.0 / size
        y0 = (py - size/2.0) * 3.0 / size
        iter_count = mandelbrot(x0, y0, max_iter)
        if iter_count < max_iter:
            count += 1

end = time.time()
time_ms = int((end - start) * 1000)

print(f'Python: mandelbrot({size}) = {count}')
print(f'Time: {time_ms}ms')