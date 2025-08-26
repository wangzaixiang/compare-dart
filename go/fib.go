package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

func fib(n int) int {
	if n <= 1 {
		return n
	}
	return fib(n-1) + fib(n-2)
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: fib <n>")
		os.Exit(1)
	}

	n, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Println("Invalid number:", os.Args[1])
		os.Exit(1)
	}

	start := time.Now()
	result := fib(n)
	elapsed := time.Since(start)

	fmt.Printf("Go: fib(%d) = %d\n", n, result)
	fmt.Printf("Time: %dms\n", elapsed.Milliseconds())
}