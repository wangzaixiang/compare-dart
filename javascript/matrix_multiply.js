function matrixMultiply(a, b, c, size) {
    for (let i = 0; i < size; i++) {
        for (let j = 0; j < size; j++) {
            c[i][j] = 0;
            for (let k = 0; k < size; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

function allocateMatrix(size) {
    const matrix = [];
    for (let i = 0; i < size; i++) {
        matrix[i] = new Array(size);
    }
    return matrix;
}

function initMatrix(matrix, size, seedOffset) {
    for (let i = 0; i < size; i++) {
        for (let j = 0; j < size; j++) {
            matrix[i][j] = (i * 3 + j * 7 + seedOffset) % 100;
        }
    }
}

// 兼容 Node.js 和 QuickJS
const args = typeof process !== 'undefined' ? process.argv.slice(2) : scriptArgs.slice(1);
if (args.length < 1) {
    console.log('Usage: matrix_multiply <size>');
    if (typeof process !== 'undefined') process.exit(1);
    else throw new Error('Usage error');
}

const size = parseInt(args[0]);
if (isNaN(size)) {
    console.log('Invalid number:', args[0]);
    if (typeof process !== 'undefined') process.exit(1);
    else throw new Error('Usage error');
}

const a = allocateMatrix(size);
const b = allocateMatrix(size);
const c = allocateMatrix(size);

initMatrix(a, size, 0);
initMatrix(b, size, 1);

const start = Date.now();
matrixMultiply(a, b, c, size);
const end = Date.now();

// Calculate checksum to verify correctness
let checksum = 0;
for (let i = 0; i < size; i++) {
    for (let j = 0; j < size; j++) {
        checksum += c[i][j];
    }
}

const timeMs = end - start;

console.log(`JavaScript: matrix_multiply(${size}) = ${checksum}`);
console.log(`Time: ${timeMs}ms`);