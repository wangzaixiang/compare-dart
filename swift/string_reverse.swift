import Foundation

func reverseString(_ str: String) -> String {
    var chars = Array(str)
    var start = 0
    var end = chars.count - 1
    
    while start < end {
        chars.swapAt(start, end)
        start += 1
        end -= 1
    }
    
    return String(chars)
}

func generateString(_ length: Int) -> String {
    var result = ""
    for i in 0..<length {
        let char = Character(UnicodeScalar(65 + (i % 26))!)
        result.append(char)
    }
    return result
}

let args = CommandLine.arguments
if args.count < 2 {
    print("Usage: string_reverse <length>")
    exit(1)
}

guard let length = Int(args[1]) else {
    print("Invalid number: \(args[1])")
    exit(1)
}

let str = generateString(length)

let start = CFAbsoluteTimeGetCurrent()
let reversed = reverseString(str)
let end = CFAbsoluteTimeGetCurrent()

// Calculate checksum to verify correctness
var checksum: Int64 = 0
for c in reversed {
    checksum += Int64(c.asciiValue!)
}

let timeMs = Int((end - start) * 1000)

print("Swift: string_reverse(\(length)) = \(checksum)")
print("Time: \(timeMs)ms")