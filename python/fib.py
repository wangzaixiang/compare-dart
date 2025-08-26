#!/usr/bin/env python3
import sys
import time

def fib(n):
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 fib.py <n>")
        sys.exit(1)
    
    n = int(sys.argv[1])
    start_time = time.time()
    result = fib(n)
    end_time = time.time()
    
    time_ms = int((end_time - start_time) * 1000)
    
    print(f"Python: fib({n}) = {result}")
    print(f"Time: {time_ms}ms")