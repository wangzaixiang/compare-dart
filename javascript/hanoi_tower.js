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

const args = process.argv.slice(2);
if (args.length < 1) {
    console.log('Usage: hanoi_tower <n>');
    process.exit(1);
}

const n = parseInt(args[0]);
if (isNaN(n)) {
    console.log('Invalid number:', args[0]);
    process.exit(1);
}

moveCount = 0;

const start = Date.now();
hanoiTower(n, 'A', 'C', 'B');
const end = Date.now();

const timeMs = end - start;

console.log(`JavaScript: hanoi_tower(${n}) = ${moveCount}`);
console.log(`Time: ${timeMs}ms`);