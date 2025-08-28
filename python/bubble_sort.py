import sys
import time
import random

def bubble_sort(arr):
    n = len(arr)
    for i in range(n - 1):
        for j in range(i + 1, n):
            if arr[i] > arr[j]:
                arr[i], arr[j] = arr[j], arr[i]

def generate_array(n):
    random.seed(42)  # Fixed seed for reproducible results
    return [random.randint(0, 9999) for _ in range(n)]

if len(sys.argv) < 2:
    print('Usage: bubble_sort <n>')
    sys.exit(1)

try:
    n = int(sys.argv[1])
except ValueError:
    print('Invalid number:', sys.argv[1])
    sys.exit(1)

arr = generate_array(n)

start = time.time()
bubble_sort(arr)
end = time.time()

time_ms = int((end - start) * 1000)

print(f'Python: bubble_sort({n}) = sorted')
print(f'Time: {time_ms}ms')