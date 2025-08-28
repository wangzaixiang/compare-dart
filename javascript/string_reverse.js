function reverseString(str) {
    const chars = str.split('');
    let start = 0;
    let end = chars.length - 1;
    
    while (start < end) {
        const temp = chars[start];
        chars[start] = chars[end];
        chars[end] = temp;
        start++;
        end--;
    }
    
    return chars.join('');
}

function generateString(length) {
    let str = '';
    for (let i = 0; i < length; i++) {
        str += String.fromCharCode(65 + (i % 26)); // 'A' + (i % 26)
    }
    return str;
}

const args = process.argv.slice(2);
if (args.length < 1) {
    console.log('Usage: string_reverse <length>');
    process.exit(1);
}

const length = parseInt(args[0]);
if (isNaN(length)) {
    console.log('Invalid number:', args[0]);
    process.exit(1);
}

const str = generateString(length);

const start = Date.now();
const reversed = reverseString(str);
const end = Date.now();

// Calculate checksum to verify correctness
let checksum = 0;
for (let i = 0; i < reversed.length; i++) {
    checksum += reversed.charCodeAt(i);
}

const timeMs = end - start;

console.log(`JavaScript: string_reverse(${length}) = ${checksum}`);
console.log(`Time: ${timeMs}ms`);