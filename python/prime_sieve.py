import sys
import time

def prime_sieve(n):
    is_prime = [True] * (n + 1)
    is_prime[0] = is_prime[1] = False
    
    i = 2
    while i * i <= n:
        if is_prime[i]:
            j = i * i
            while j <= n:
                is_prime[j] = False
                j += i
        i += 1
    
    count = 0
    for i in range(2, n + 1):
        if is_prime[i]:
            count += 1
    
    return count

if len(sys.argv) < 2:
    print('Usage: prime_sieve <n>')
    sys.exit(1)

try:
    n = int(sys.argv[1])
except ValueError:
    print('Invalid number:', sys.argv[1])
    sys.exit(1)

start = time.time()
count = prime_sieve(n)
end = time.time()

time_ms = int((end - start) * 1000)

print(f'Python: prime_sieve({n}) = {count}')
print(f'Time: {time_ms}ms')