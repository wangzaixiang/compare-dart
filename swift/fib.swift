import Foundation

func fib(_ n: Int) -> Int {
    if n <= 1 { return n }
    return fib(n - 1) + fib(n - 2)
}

let args = CommandLine.arguments

guard args.count >= 2, let n = Int(args[1]) else {
    print("Usage: fib <n>")
    exit(1)
}

let startTime = CFAbsoluteTimeGetCurrent()
let result = fib(n)
let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime

print("Swift: fib(\(n)) = \(result)")
print("Time: \(Int(timeElapsed * 1000))ms")