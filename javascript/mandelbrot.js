function mandelbrot(x0, y0, maxIter) {
    let x = 0.0;
    let y = 0.0;
    let iteration = 0;
    
    while (x*x + y*y <= 4.0 && iteration < maxIter) {
        const xtemp = x*x - y*y + x0;
        y = 2*x*y + y0;
        x = xtemp;
        iteration++;
    }
    return iteration;
}

// 兼容 Node.js 和 QuickJS
const args = typeof process !== 'undefined' ? process.argv.slice(2) : scriptArgs.slice(1);
if (args.length < 1) {
    console.log('Usage: mandelbrot <size>');
    if (typeof process !== 'undefined') process.exit(1);
    else throw new Error('Usage: mandelbrot <size>');
}

const size = parseInt(args[0]);
if (isNaN(size)) {
    console.log('Invalid number:', args[0]);
    if (typeof process !== 'undefined') process.exit(1);
    else throw new Error('Usage: mandelbrot <size>');
}

const maxIter = 100;

const start = Date.now();

let count = 0;
for (let py = 0; py < size; py++) {
    for (let px = 0; px < size; px++) {
        const x0 = (px - size/2.0) * 3.0 / size;
        const y0 = (py - size/2.0) * 3.0 / size;
        const iter = mandelbrot(x0, y0, maxIter);
        if (iter < maxIter) {
            count++;
        }
    }
}

const end = Date.now();
const timeMs = end - start;

console.log(`JavaScript: mandelbrot(${size}) = ${count}`);
console.log(`Time: ${timeMs}ms`);