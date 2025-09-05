function quicksort(arr, low, high) {
    if (low < high) {
        const pi = partition(arr, low, high);
        quicksort(arr, low, pi - 1);
        quicksort(arr, pi + 1, high);
    }
}

function partition(arr, low, high) {
    const pivot = arr[high];
    let i = low - 1;
    
    for (let j = low; j <= high - 1; j++) {
        if (arr[j] < pivot) {
            i++;
            [arr[i], arr[j]] = [arr[j], arr[i]];
        }
    }
    [arr[i + 1], arr[high]] = [arr[high], arr[i + 1]];
    return i + 1;
}

function generateArray(n) {
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

// 兼容 Node.js 和 QuickJS
const args = typeof process !== 'undefined' ? process.argv.slice(2) : scriptArgs.slice(1);
if (args.length < 1) {
    console.log('Usage: quicksort <n>');
    if (typeof process !== 'undefined') process.exit(1);
    else throw new Error('Usage error');
}

const n = parseInt(args[0]);
if (isNaN(n)) {
    console.log('Invalid number:', args[0]);
    if (typeof process !== 'undefined') process.exit(1);
    else throw new Error('Usage error');
}

const arr = generateArray(n);

const start = Date.now();
quicksort(arr, 0, n - 1);
const end = Date.now();

const timeMs = end - start;

console.log(`JavaScript: quicksort(${n}) = sorted`);
console.log(`Time: ${timeMs}ms`);