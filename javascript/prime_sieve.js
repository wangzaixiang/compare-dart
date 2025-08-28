function primeSieve(n) {
    const isPrime = new Array(n + 1).fill(true);
    isPrime[0] = false;
    isPrime[1] = false;
    
    for (let i = 2; i * i <= n; i++) {
        if (isPrime[i]) {
            for (let j = i * i; j <= n; j += i) {
                isPrime[j] = false;
            }
        }
    }
    
    let count = 0;
    for (let i = 2; i <= n; i++) {
        if (isPrime[i]) {
            count++;
        }
    }
    
    return count;
}

const args = process.argv.slice(2);
if (args.length < 1) {
    console.log('Usage: prime_sieve <n>');
    process.exit(1);
}

const n = parseInt(args[0]);
if (isNaN(n)) {
    console.log('Invalid number:', args[0]);
    process.exit(1);
}

const start = Date.now();
const count = primeSieve(n);
const end = Date.now();

const timeMs = end - start;

console.log(`JavaScript: prime_sieve(${n}) = ${count}`);
console.log(`Time: ${timeMs}ms`);