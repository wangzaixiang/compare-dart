import sys
import time

move_count = 0

def hanoi_tower(n, from_pole, to_pole, aux_pole):
    global move_count
    if n == 1:
        move_count += 1
        return
    
    hanoi_tower(n - 1, from_pole, aux_pole, to_pole)
    move_count += 1
    hanoi_tower(n - 1, aux_pole, to_pole, from_pole)

if len(sys.argv) < 2:
    print('Usage: hanoi_tower <n>')
    sys.exit(1)

try:
    n = int(sys.argv[1])
except ValueError:
    print('Invalid number:', sys.argv[1])
    sys.exit(1)

move_count = 0

start = time.time()
hanoi_tower(n, 'A', 'C', 'B')
end = time.time()

time_ms = int((end - start) * 1000)

print(f'Python: hanoi_tower({n}) = {move_count}')
print(f'Time: {time_ms}ms')