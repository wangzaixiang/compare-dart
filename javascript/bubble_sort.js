function bubbleSort(arr) {
    const n = arr.length;
    for (let i = 0; i < n - 1; i++) {
        for (let j = i + 1; j < n; j++) {
            if (arr[i] > arr[j]) {
                [arr[i], arr[j]] = [arr[j], arr[i]];
            }
        }
    }
}

function generateArray(n) {
    // Simple seeded random for reproducible results
    let seed = 42;
    function seededRandom() {
        seed = (seed * 9301 + 49297) % 233280;
        return seed / 233280;
    }
    
    const arr = [];
    for (let i = 0; i < n; i++) {
        arr.push(Math.floor(seededRandom() * 10000));
    }
    return arr;
}

const args = process.argv.slice(2);
if (args.length < 1) {
    console.log('Usage: bubble_sort <n>');
    process.exit(1);
}

const n = parseInt(args[0]);
if (isNaN(n)) {
    console.log('Invalid number:', args[0]);
    process.exit(1);
}

const arr = generateArray(n);

const start = Date.now();
bubbleSort(arr);
const end = Date.now();

const timeMs = end - start;

console.log(`JavaScript: bubble_sort(${n}) = sorted`);
console.log(`Time: ${timeMs}ms`);