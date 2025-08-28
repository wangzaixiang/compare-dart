import Foundation

func countingSort(_ arr: inout [Int], _ n: Int, _ maxVal: Int) {
    var count = Array(repeating: 0, count: maxVal + 1)
    var output = Array(repeating: 0, count: n)
    
    // Count occurrences
    for i in 0..<n {
        count[arr[i]] += 1
    }
    
    // Change count[i] so that it contains position of this character in output array
    for i in 1...maxVal {
        count[i] += count[i - 1]
    }
    
    // Build output array
    for i in stride(from: n - 1, through: 0, by: -1) {
        let val = arr[i]
        output[count[val] - 1] = arr[i]
        count[val] -= 1
    }
    
    // Copy output array to arr
    for i in 0..<n {
        arr[i] = output[i]
    }
}

func generateArray(_ n: Int, _ maxVal: Int) -> [Int] {
    var arr = Array(repeating: 0, count: n)
    for i in 0..<n {
        arr[i] = (i * 7 + i * i * 3) % (maxVal + 1)
    }
    return arr
}

let args = CommandLine.arguments
if args.count < 2 {
    print("Usage: counting_sort <n>")
    exit(1)
}

guard let n = Int(args[1]) else {
    print("Invalid number: \(args[1])")
    exit(1)
}

let maxVal = 999
var arr = generateArray(n, maxVal)

let start = CFAbsoluteTimeGetCurrent()
countingSort(&arr, n, maxVal)
let end = CFAbsoluteTimeGetCurrent()

// Calculate checksum to verify correctness
var checksum: Int64 = 0
for i in 0..<n {
    checksum += Int64(arr[i])
}

let timeMs = Int((end - start) * 1000)

print("Swift: counting_sort(\(n)) = \(checksum)")
print("Time: \(timeMs)ms")