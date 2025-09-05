let moveCount = 0;

function hanoiTower(n, from, to, aux) {
    if (n === 1) {
        moveCount++;
        return;
    }
    
    hanoiTower(n - 1, from, aux, to);
    moveCount++;
    hanoiTower(n - 1, aux, to, from);
}

// 兼容 Node.js 和 QuickJS
const args = typeof process !== 'undefined' ? process.argv.slice(2) : scriptArgs.slice(1);
if (args.length < 1) {
    console.log('Usage: hanoi_tower <n>');
    if (typeof process !== 'undefined') process.exit(1);
    else throw new Error('Usage error');
}

const n = parseInt(args[0]);
if (isNaN(n)) {
    console.log('Invalid number:', args[0]);
    if (typeof process !== 'undefined') process.exit(1);
    else throw new Error('Usage error');
}

moveCount = 0;

const start = Date.now();
hanoiTower(n, 'A', 'C', 'B');
const end = Date.now();

const timeMs = end - start;

console.log(`JavaScript: hanoi_tower(${n}) = ${moveCount}`);
console.log(`Time: ${timeMs}ms`);