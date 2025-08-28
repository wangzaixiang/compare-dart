package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

func reverseString(str string) string {
	runes := []rune(str)
	start := 0
	end := len(runes) - 1
	
	for start < end {
		runes[start], runes[end] = runes[end], runes[start]
		start++
		end--
	}
	
	return string(runes)
}

func generateString(length int) string {
	bytes := make([]byte, length)
	for i := 0; i < length; i++ {
		bytes[i] = byte('A' + (i % 26))
	}
	return string(bytes)
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: string_reverse <length>")
		return
	}

	length, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Println("Invalid number:", os.Args[1])
		return
	}

	str := generateString(length)

	start := time.Now()
	reversed := reverseString(str)
	elapsed := time.Since(start)

	// Calculate checksum to verify correctness
	checksum := int64(0)
	for i := 0; i < len(reversed); i++ {
		checksum += int64(reversed[i])
	}

	timeMs := elapsed.Milliseconds()

	fmt.Printf("Go: string_reverse(%d) = %d\n", length, checksum)
	fmt.Printf("Time: %dms\n", timeMs)
}