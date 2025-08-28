import Foundation

func bubbleSort(_ arr: inout [Int]) {
    let n = arr.count
    for i in 0..<(n - 1) {
        for j in 0..<(n - i - 1) {
            if arr[j] > arr[j + 1] {
                arr.swapAt(j, j + 1)
            }
        }
    }
}

func generateArray(_ n: Int) -> [Int] {
    var rng = SystemRandomNumberGenerator()
    rng = SystemRandomNumberGenerator() // Reset with fixed behavior
    return Array(0..<n).map { _ in Int.random(in: 0..<10000, using: &rng) }
}

// Simple seeded random for reproducible results
func generateArraySeeded(_ n: Int) -> [Int] {
    srand48(42) // Fixed seed
    return Array(0..<n).map { _ in Int(drand48() * 10000) }
}

let args = CommandLine.arguments
if args.count < 2 {
    print("Usage: bubble_sort <n>")
    exit(1)
}

guard let n = Int(args[1]) else {
    print("Invalid number: \(args[1])")
    exit(1)
}

var arr = generateArraySeeded(n)

let start = CFAbsoluteTimeGetCurrent()
bubbleSort(&arr)
let end = CFAbsoluteTimeGetCurrent()

let timeMs = Int((end - start) * 1000)

print("Swift: bubble_sort(\(n)) = sorted")
print("Time: \(timeMs)ms")