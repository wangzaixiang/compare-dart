import Foundation

var moveCount = 0

func hanoiTower(_ n: Int, _ from: Character, _ to: Character, _ aux: Character) {
    if n == 1 {
        moveCount += 1
        return
    }
    
    hanoiTower(n - 1, from, aux, to)
    moveCount += 1
    hanoiTower(n - 1, aux, to, from)
}

let args = CommandLine.arguments
if args.count < 2 {
    print("Usage: hanoi_tower <n>")
    exit(1)
}

guard let n = Int(args[1]) else {
    print("Invalid number: \(args[1])")
    exit(1)
}

moveCount = 0

let start = CFAbsoluteTimeGetCurrent()
hanoiTower(n, "A", "C", "B")
let end = CFAbsoluteTimeGetCurrent()

let timeMs = Int((end - start) * 1000)

print("Swift: hanoi_tower(\(n)) = \(moveCount)")
print("Time: \(timeMs)ms")