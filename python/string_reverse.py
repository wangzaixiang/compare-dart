import sys
import time

def reverse_string(s):
    chars = list(s)
    start = 0
    end = len(chars) - 1
    
    while start < end:
        chars[start], chars[end] = chars[end], chars[start]
        start += 1
        end -= 1
    
    return ''.join(chars)

def generate_string(length):
    s = ''
    for i in range(length):
        s += chr(ord('A') + (i % 26))
    return s

if len(sys.argv) < 2:
    print('Usage: string_reverse <length>')
    sys.exit(1)

try:
    length = int(sys.argv[1])
except ValueError:
    print('Invalid number:', sys.argv[1])
    sys.exit(1)

s = generate_string(length)

start = time.time()
reversed_s = reverse_string(s)
end = time.time()

# Calculate checksum to verify correctness
checksum = 0
for c in reversed_s:
    checksum += ord(c)

time_ms = int((end - start) * 1000)

print(f'Python: string_reverse({length}) = {checksum}')
print(f'Time: {time_ms}ms')