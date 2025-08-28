package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

func primeSieve(n int) int {
	isPrime := make([]bool, n+1)
	for i := 0; i <= n; i++ {
		isPrime[i] = true
	}
	isPrime[0] = false
	isPrime[1] = false
	
	for i := 2; i*i <= n; i++ {
		if isPrime[i] {
			for j := i * i; j <= n; j += i {
				isPrime[j] = false
			}
		}
	}
	
	count := 0
	for i := 2; i <= n; i++ {
		if isPrime[i] {
			count++
		}
	}
	
	return count
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: prime_sieve <n>")
		return
	}

	n, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Println("Invalid number:", os.Args[1])
		return
	}

	start := time.Now()
	count := primeSieve(n)
	elapsed := time.Since(start)

	timeMs := elapsed.Milliseconds()

	fmt.Printf("Go: prime_sieve(%d) = %d\n", n, count)
	fmt.Printf("Time: %dms\n", timeMs)
}