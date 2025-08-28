package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

type Node struct {
	data  int
	left  *Node
	right *Node
}

func buildTree(depth int, counter *int) *Node {
	if depth <= 0 {
		return nil
	}
	
	node := &Node{data: *counter}
	*counter++
	node.left = buildTree(depth-1, counter)
	node.right = buildTree(depth-1, counter)
	return node
}

func traverseInOrder(node *Node) int {
	if node == nil {
		return 0
	}
	
	sum := 0
	sum += traverseInOrder(node.left)
	sum += node.data
	sum += traverseInOrder(node.right)
	return sum
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: binary_tree_traverse <depth>")
		return
	}

	depth, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Println("Invalid number:", os.Args[1])
		return
	}

	counter := 0

	start := time.Now()
	root := buildTree(depth, &counter)
	sum := traverseInOrder(root)
	elapsed := time.Since(start)

	timeMs := elapsed.Milliseconds()

	fmt.Printf("Go: binary_tree_traverse(%d) = %d\n", depth, sum)
	fmt.Printf("Time: %dms\n", timeMs)
}