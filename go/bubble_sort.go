package main

import (
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"time"
)

func bubbleSort(arr []int) {
	n := len(arr)
	for i := 0; i < n-1; i++ {
		for j := i + 1; j < n; j++ {
			if arr[i] > arr[j] {
				arr[i], arr[j] = arr[j], arr[i]
			}
		}
	}
}

func generateArray(n int) []int {
	rand.Seed(42) // Fixed seed for reproducible results
	arr := make([]int, n)
	for i := 0; i < n; i++ {
		arr[i] = rand.Intn(10000)
	}
	return arr
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: bubble_sort <n>")
		return
	}

	n, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Println("Invalid number:", os.Args[1])
		return
	}

	arr := generateArray(n)

	start := time.Now()
	bubbleSort(arr)
	elapsed := time.Since(start)

	timeMs := elapsed.Milliseconds()

	fmt.Printf("Go: bubble_sort(%d) = sorted\n", n)
	fmt.Printf("Time: %dms\n", timeMs)
}