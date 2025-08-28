import Foundation

func primeSieve(_ n: Int) -> Int {
    var isPrime = Array(repeating: true, count: n + 1)
    isPrime[0] = false
    if n > 0 {
        isPrime[1] = false
    }
    
    var i = 2
    while i * i <= n {
        if isPrime[i] {
            var j = i * i
            while j <= n {
                isPrime[j] = false
                j += i
            }
        }
        i += 1
    }
    
    var count = 0
    for i in 2...n {
        if isPrime[i] {
            count += 1
        }
    }
    
    return count
}

let args = CommandLine.arguments
if args.count < 2 {
    print("Usage: prime_sieve <n>")
    exit(1)
}

guard let n = Int(args[1]) else {
    print("Invalid number: \(args[1])")
    exit(1)
}

let start = CFAbsoluteTimeGetCurrent()
let count = primeSieve(n)
let end = CFAbsoluteTimeGetCurrent()

let timeMs = Int((end - start) * 1000)

print("Swift: prime_sieve(\(n)) = \(count)")
print("Time: \(timeMs)ms")