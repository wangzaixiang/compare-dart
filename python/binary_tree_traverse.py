import sys
import time

class Node:
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None

def build_tree(depth, counter):
    if depth <= 0:
        return None
    
    node = Node(counter[0])
    counter[0] += 1
    node.left = build_tree(depth - 1, counter)
    node.right = build_tree(depth - 1, counter)
    return node

def traverse_in_order(node):
    if node is None:
        return 0
    
    sum_val = 0
    sum_val += traverse_in_order(node.left)
    sum_val += node.data
    sum_val += traverse_in_order(node.right)
    return sum_val

if len(sys.argv) < 2:
    print('Usage: binary_tree_traverse <depth>')
    sys.exit(1)

try:
    depth = int(sys.argv[1])
except ValueError:
    print('Invalid number:', sys.argv[1])
    sys.exit(1)

counter = [0]

start = time.time()
root = build_tree(depth, counter)
sum_val = traverse_in_order(root)
end = time.time()

time_ms = int((end - start) * 1000)

print(f'Python: binary_tree_traverse({depth}) = {sum_val}')
print(f'Time: {time_ms}ms')