function fib(n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

// 兼容 Node.js 和 QuickJS
const args = typeof process !== 'undefined' ? process.argv.slice(2) : scriptArgs.slice(1);

if (args.length === 0) {
    console.log('Usage: fib <n>');
    if (typeof process !== 'undefined') process.exit(1);
    else throw new Error('Usage: fib <n>');
}

const n = parseInt(args[0]);
const start = Date.now();
const result = fib(n);
const end = Date.now();

console.log(`JavaScript: fib(${n}) = ${result}`);
console.log(`Time: ${end - start}ms`);