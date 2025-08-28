import Foundation

func mandelbrot(_ x0: Double, _ y0: Double, _ maxIter: Int) -> Int {
    var x: Double = 0.0
    var y: Double = 0.0
    var iteration = 0
    
    while x*x + y*y <= 4.0 && iteration < maxIter {
        let xtemp = x*x - y*y + x0
        y = 2*x*y + y0
        x = xtemp
        iteration += 1
    }
    return iteration
}

let args = CommandLine.arguments
if args.count < 2 {
    print("Usage: mandelbrot <size>")
    exit(1)
}

guard let size = Int(args[1]) else {
    print("Invalid number: \(args[1])")
    exit(1)
}

let maxIter = 100

let start = CFAbsoluteTimeGetCurrent()

var count = 0
for py in 0..<size {
    for px in 0..<size {
        let x0 = (Double(px) - Double(size)/2.0) * 3.0 / Double(size)
        let y0 = (Double(py) - Double(size)/2.0) * 3.0 / Double(size)
        let iter = mandelbrot(x0, y0, maxIter)
        if iter < maxIter {
            count += 1
        }
    }
}

let end = CFAbsoluteTimeGetCurrent()
let timeMs = Int((end - start) * 1000)

print("Swift: mandelbrot(\(size)) = \(count)")
print("Time: \(timeMs)ms")