package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

var moveCount int

func hanoiTower(n int, from, to, aux rune) {
	if n == 1 {
		moveCount++
		return
	}
	
	hanoiTower(n-1, from, aux, to)
	moveCount++
	hanoiTower(n-1, aux, to, from)
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: hanoi_tower <n>")
		return
	}

	n, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Println("Invalid number:", os.Args[1])
		return
	}

	moveCount = 0

	start := time.Now()
	hanoiTower(n, 'A', 'C', 'B')
	elapsed := time.Since(start)

	timeMs := elapsed.Milliseconds()

	fmt.Printf("Go: hanoi_tower(%d) = %d\n", n, moveCount)
	fmt.Printf("Time: %dms\n", timeMs)
}