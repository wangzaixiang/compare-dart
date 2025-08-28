package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

func countingSort(arr []int, n int, maxVal int) {
	count := make([]int, maxVal+1)
	output := make([]int, n)
	
	// Count occurrences
	for i := 0; i < n; i++ {
		count[arr[i]]++
	}
	
	// Change count[i] so that it contains position of this character in output array
	for i := 1; i <= maxVal; i++ {
		count[i] += count[i-1]
	}
	
	// Build output array
	for i := n - 1; i >= 0; i-- {
		output[count[arr[i]]-1] = arr[i]
		count[arr[i]]--
	}
	
	// Copy output array to arr
	for i := 0; i < n; i++ {
		arr[i] = output[i]
	}
}

func generateArray(n int, maxVal int) []int {
	arr := make([]int, n)
	for i := 0; i < n; i++ {
		arr[i] = (i*7 + i*i*3) % (maxVal + 1)
	}
	return arr
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: counting_sort <n>")
		return
	}

	n, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Println("Invalid number:", os.Args[1])
		return
	}

	maxVal := 999
	arr := generateArray(n, maxVal)

	start := time.Now()
	countingSort(arr, n, maxVal)
	elapsed := time.Since(start)

	// Calculate checksum to verify correctness
	checksum := int64(0)
	for i := 0; i < n; i++ {
		checksum += int64(arr[i])
	}

	timeMs := elapsed.Milliseconds()

	fmt.Printf("Go: counting_sort(%d) = %d\n", n, checksum)
	fmt.Printf("Time: %dms\n", timeMs)
}