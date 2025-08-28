import Foundation

func quicksort(_ arr: inout [Int], _ low: Int, _ high: Int) {
    if low < high {
        let pi = partition(&arr, low, high)
        quicksort(&arr, low, pi - 1)
        quicksort(&arr, pi + 1, high)
    }
}

func partition(_ arr: inout [Int], _ low: Int, _ high: Int) -> Int {
    let pivot = arr[high]
    var i = low - 1
    
    for j in low...high-1 {
        if arr[j] < pivot {
            i += 1
            arr.swapAt(i, j)
        }
    }
    arr.swapAt(i + 1, high)
    return i + 1
}

func generateArraySeeded(_ n: Int) -> [Int] {
    srand48(42)
    return Array(0..<n).map { _ in Int(drand48() * 10000) }
}

let args = CommandLine.arguments
if args.count < 2 {
    print("Usage: quicksort <n>")
    exit(1)
}

guard let n = Int(args[1]) else {
    print("Invalid number: \(args[1])")
    exit(1)
}

var arr = generateArraySeeded(n)

let start = CFAbsoluteTimeGetCurrent()
quicksort(&arr, 0, n - 1)
let end = CFAbsoluteTimeGetCurrent()

let timeMs = Int((end - start) * 1000)

print("Swift: quicksort(\(n)) = sorted")
print("Time: \(timeMs)ms")