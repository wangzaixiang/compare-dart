import Foundation

class Node {
    var data: Int
    var left: Node?
    var right: Node?
    
    init(_ data: Int) {
        self.data = data
        self.left = nil
        self.right = nil
    }
}

func buildTree(_ depth: Int, _ counter: inout Int) -> Node? {
    if depth <= 0 { return nil }
    
    let node = Node(counter)
    counter += 1
    node.left = buildTree(depth - 1, &counter)
    node.right = buildTree(depth - 1, &counter)
    return node
}

func traverseInOrder(_ node: Node?) -> Int {
    guard let node = node else { return 0 }
    
    var sum = 0
    sum += traverseInOrder(node.left)
    sum += node.data
    sum += traverseInOrder(node.right)
    return sum
}

let args = CommandLine.arguments
if args.count < 2 {
    print("Usage: binary_tree_traverse <depth>")
    exit(1)
}

guard let depth = Int(args[1]) else {
    print("Invalid number: \(args[1])")
    exit(1)
}

var counter = 0

let start = CFAbsoluteTimeGetCurrent()
let root = buildTree(depth, &counter)
let sum = traverseInOrder(root)
let end = CFAbsoluteTimeGetCurrent()

let timeMs = Int((end - start) * 1000)

print("Swift: binary_tree_traverse(\(depth)) = \(sum)")
print("Time: \(timeMs)ms")