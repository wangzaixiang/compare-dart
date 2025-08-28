import sys
import time

def counting_sort(arr, n, max_val):
    count = [0] * (max_val + 1)
    output = [0] * n
    
    # Count occurrences
    for i in range(n):
        count[arr[i]] += 1
    
    # Change count[i] so that it contains position of this character in output array
    for i in range(1, max_val + 1):
        count[i] += count[i - 1]
    
    # Build output array
    for i in range(n - 1, -1, -1):
        val = arr[i]
        output[count[val] - 1] = arr[i]
        count[val] -= 1
    
    # Copy output array to arr
    for i in range(n):
        arr[i] = output[i]

def generate_array(n, max_val):
    arr = []
    for i in range(n):
        arr.append((i * 7 + i * i * 3) % (max_val + 1))
    return arr

if len(sys.argv) < 2:
    print('Usage: counting_sort <n>')
    sys.exit(1)

try:
    n = int(sys.argv[1])
except ValueError:
    print('Invalid number:', sys.argv[1])
    sys.exit(1)

max_val = 999
arr = generate_array(n, max_val)

start = time.time()
counting_sort(arr, n, max_val)
end = time.time()

# Calculate checksum to verify correctness
checksum = 0
for i in range(n):
    checksum += arr[i]

time_ms = int((end - start) * 1000)

print(f'Python: counting_sort({n}) = {checksum}')
print(f'Time: {time_ms}ms')