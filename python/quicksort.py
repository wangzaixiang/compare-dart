import sys
import time
import random

def quicksort(arr, low, high):
    if low < high:
        pi = partition(arr, low, high)
        quicksort(arr, low, pi - 1)
        quicksort(arr, pi + 1, high)

def partition(arr, low, high):
    pivot = arr[high]
    i = low - 1
    
    for j in range(low, high):
        if arr[j] < pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]
    
    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    return i + 1

def generate_array(n):
    random.seed(42)
    return [random.randint(0, 9999) for _ in range(n)]

if len(sys.argv) < 2:
    print('Usage: quicksort <n>')
    sys.exit(1)

try:
    n = int(sys.argv[1])
except ValueError:
    print('Invalid number:', sys.argv[1])
    sys.exit(1)

arr = generate_array(n)

start = time.time()
quicksort(arr, 0, n - 1)
end = time.time()

time_ms = int((end - start) * 1000)

print(f'Python: quicksort({n}) = sorted')
print(f'Time: {time_ms}ms')