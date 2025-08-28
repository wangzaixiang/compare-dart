import Foundation

func matrixMultiply(_ a: [[Int]], _ b: [[Int]], _ c: inout [[Int]], _ size: Int) {
    for i in 0..<size {
        for j in 0..<size {
            c[i][j] = 0
            for k in 0..<size {
                c[i][j] += a[i][k] * b[k][j]
            }
        }
    }
}

func allocateMatrix(_ size: Int) -> [[Int]] {
    return Array(repeating: Array(repeating: 0, count: size), count: size)
}

func initMatrixSeeded(_ matrix: inout [[Int]], _ size: Int, _ seedOffset: Int) {
    for i in 0..<size {
        for j in 0..<size {
            matrix[i][j] = (i * 3 + j * 7 + seedOffset) % 100
        }
    }
}

let args = CommandLine.arguments
if args.count < 2 {
    print("Usage: matrix_multiply <size>")
    exit(1)
}

guard let size = Int(args[1]) else {
    print("Invalid number: \(args[1])")
    exit(1)
}

var a = allocateMatrix(size)
var b = allocateMatrix(size)
var c = allocateMatrix(size)

initMatrixSeeded(&a, size, 0)
initMatrixSeeded(&b, size, 1)

let start = CFAbsoluteTimeGetCurrent()
matrixMultiply(a, b, &c, size)
let end = CFAbsoluteTimeGetCurrent()

// Calculate checksum to verify correctness
var checksum: Int64 = 0
for i in 0..<size {
    for j in 0..<size {
        checksum += Int64(c[i][j])
    }
}

let timeMs = Int((end - start) * 1000)

print("Swift: matrix_multiply(\(size)) = \(checksum)")
print("Time: \(timeMs)ms")