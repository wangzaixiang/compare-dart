package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

func mandelbrot(x0, y0 float64, maxIter int) int {
	x := 0.0
	y := 0.0
	iteration := 0
	
	for x*x+y*y <= 4.0 && iteration < maxIter {
		xtemp := x*x - y*y + x0
		y = 2*x*y + y0
		x = xtemp
		iteration++
	}
	return iteration
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: mandelbrot <size>")
		return
	}

	size, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Println("Invalid number:", os.Args[1])
		return
	}

	maxIter := 100

	start := time.Now()

	count := 0
	for py := 0; py < size; py++ {
		for px := 0; px < size; px++ {
			x0 := (float64(px) - float64(size)/2.0) * 3.0 / float64(size)
			y0 := (float64(py) - float64(size)/2.0) * 3.0 / float64(size)
			iter := mandelbrot(x0, y0, maxIter)
			if iter < maxIter {
				count++
			}
		}
	}

	elapsed := time.Since(start)
	timeMs := elapsed.Milliseconds()

	fmt.Printf("Go: mandelbrot(%d) = %d\n", size, count)
	fmt.Printf("Time: %dms\n", timeMs)
}