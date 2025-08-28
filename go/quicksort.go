package main

import (
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"time"
)

func quicksort(arr []int, low, high int) {
	if low < high {
		pi := partition(arr, low, high)
		quicksort(arr, low, pi-1)
		quicksort(arr, pi+1, high)
	}
}

func partition(arr []int, low, high int) int {
	pivot := arr[high]
	i := low - 1
	
	for j := low; j <= high-1; j++ {
		if arr[j] < pivot {
			i++
			arr[i], arr[j] = arr[j], arr[i]
		}
	}
	arr[i+1], arr[high] = arr[high], arr[i+1]
	return i + 1
}

func generateArray(n int) []int {
	rand.Seed(42)
	arr := make([]int, n)
	for i := 0; i < n; i++ {
		arr[i] = rand.Intn(10000)
	}
	return arr
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: quicksort <n>")
		return
	}

	n, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Println("Invalid number:", os.Args[1])
		return
	}

	arr := generateArray(n)

	start := time.Now()
	quicksort(arr, 0, n-1)
	elapsed := time.Since(start)

	timeMs := elapsed.Milliseconds()

	fmt.Printf("Go: quicksort(%d) = sorted\n", n)
	fmt.Printf("Time: %dms\n", timeMs)
}