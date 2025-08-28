function countingSort(arr, n, maxVal) {
    const count = new Array(maxVal + 1).fill(0);
    const output = new Array(n);
    
    // Count occurrences
    for (let i = 0; i < n; i++) {
        count[arr[i]]++;
    }
    
    // Change count[i] so that it contains position of this character in output array
    for (let i = 1; i <= maxVal; i++) {
        count[i] += count[i - 1];
    }
    
    // Build output array
    for (let i = n - 1; i >= 0; i--) {
        const val = arr[i];
        output[count[val] - 1] = arr[i];
        count[val]--;
    }
    
    // Copy output array to arr
    for (let i = 0; i < n; i++) {
        arr[i] = output[i];
    }
}

function generateArray(n, maxVal) {
    const arr = new Array(n);
    for (let i = 0; i < n; i++) {
        arr[i] = (i * 7 + i * i * 3) % (maxVal + 1);
    }
    return arr;
}

const args = process.argv.slice(2);
if (args.length < 1) {
    console.log('Usage: counting_sort <n>');
    process.exit(1);
}

const n = parseInt(args[0]);
if (isNaN(n)) {
    console.log('Invalid number:', args[0]);
    process.exit(1);
}

const maxVal = 999;
const arr = generateArray(n, maxVal);

const start = Date.now();
countingSort(arr, n, maxVal);
const end = Date.now();

// Calculate checksum to verify correctness
let checksum = 0;
for (let i = 0; i < n; i++) {
    checksum += arr[i];
}

const timeMs = end - start;

console.log(`JavaScript: counting_sort(${n}) = ${checksum}`);
console.log(`Time: ${timeMs}ms`);