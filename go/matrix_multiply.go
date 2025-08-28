package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

func matrixMultiply(a, b, c [][]int, size int) {
	for i := 0; i < size; i++ {
		for j := 0; j < size; j++ {
			c[i][j] = 0
			for k := 0; k < size; k++ {
				c[i][j] += a[i][k] * b[k][j]
			}
		}
	}
}

func allocateMatrix(size int) [][]int {
	matrix := make([][]int, size)
	for i := range matrix {
		matrix[i] = make([]int, size)
	}
	return matrix
}

func initMatrix(matrix [][]int, size int, seedOffset int) {
	for i := 0; i < size; i++ {
		for j := 0; j < size; j++ {
			matrix[i][j] = (i*3 + j*7 + seedOffset) % 100
		}
	}
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: matrix_multiply <size>")
		return
	}

	size, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Println("Invalid number:", os.Args[1])
		return
	}

	a := allocateMatrix(size)
	b := allocateMatrix(size)
	c := allocateMatrix(size)

	initMatrix(a, size, 0)
	initMatrix(b, size, 1)

	start := time.Now()
	matrixMultiply(a, b, c, size)
	elapsed := time.Since(start)

	// Calculate checksum to verify correctness
	checksum := int64(0)
	for i := 0; i < size; i++ {
		for j := 0; j < size; j++ {
			checksum += int64(c[i][j])
		}
	}

	timeMs := elapsed.Milliseconds()

	fmt.Printf("Go: matrix_multiply(%d) = %d\n", size, checksum)
	fmt.Printf("Time: %dms\n", timeMs)
}