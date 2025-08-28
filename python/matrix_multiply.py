import sys
import time
import random

def matrix_multiply(a, b, c, size):
    for i in range(size):
        for j in range(size):
            c[i][j] = 0
            for k in range(size):
                c[i][j] += a[i][k] * b[k][j]

def allocate_matrix(size):
    return [[0 for _ in range(size)] for _ in range(size)]

def init_matrix(matrix, size, seed_offset):
    for i in range(size):
        for j in range(size):
            matrix[i][j] = (i * 3 + j * 7 + seed_offset) % 100

if len(sys.argv) < 2:
    print('Usage: matrix_multiply <size>')
    sys.exit(1)

try:
    size = int(sys.argv[1])
except ValueError:
    print('Invalid number:', sys.argv[1])
    sys.exit(1)

a = allocate_matrix(size)
b = allocate_matrix(size)
c = allocate_matrix(size)

init_matrix(a, size, 0)
init_matrix(b, size, 1)

start = time.time()
matrix_multiply(a, b, c, size)
end = time.time()

# Calculate checksum to verify correctness
checksum = 0
for i in range(size):
    for j in range(size):
        checksum += c[i][j]

time_ms = int((end - start) * 1000)

print(f'Python: matrix_multiply({size}) = {checksum}')
print(f'Time: {time_ms}ms')