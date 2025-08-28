class Node {
    constructor(data) {
        this.data = data;
        this.left = null;
        this.right = null;
    }
}

function buildTree(depth, counter) {
    if (depth <= 0) return null;
    
    const node = new Node(counter[0]++);
    node.left = buildTree(depth - 1, counter);
    node.right = buildTree(depth - 1, counter);
    return node;
}

function traverseInOrder(node) {
    if (node === null) return 0;
    
    let sum = 0;
    sum += traverseInOrder(node.left);
    sum += node.data;
    sum += traverseInOrder(node.right);
    return sum;
}

const args = process.argv.slice(2);
if (args.length < 1) {
    console.log('Usage: binary_tree_traverse <depth>');
    process.exit(1);
}

const depth = parseInt(args[0]);
if (isNaN(depth)) {
    console.log('Invalid number:', args[0]);
    process.exit(1);
}

const counter = [0];

const start = Date.now();
const root = buildTree(depth, counter);
const sum = traverseInOrder(root);
const end = Date.now();

const timeMs = end - start;

console.log(`JavaScript: binary_tree_traverse(${depth}) = ${sum}`);
console.log(`Time: ${timeMs}ms`);