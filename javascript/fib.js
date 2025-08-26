function fib(n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

const args = process.argv.slice(2);

if (args.length === 0) {
    console.log('Usage: fib <n>');
    process.exit(1);
}

const n = parseInt(args[0]);
const start = Date.now();
const result = fib(n);
const end = Date.now();

console.log(`JavaScript: fib(${n}) = ${result}`);
console.log(`Time: ${end - start}ms`);