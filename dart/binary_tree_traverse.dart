class Node {
  int data;
  Node? left;
  Node? right;
  
  Node(this.data);
}

Node? buildTree(int depth, List<int> counter) {
  if (depth <= 0) return null;
  
  final node = Node(counter[0]++);
  node.left = buildTree(depth - 1, counter);
  node.right = buildTree(depth - 1, counter);
  return node;
}

int traverseInOrder(Node? node) {
  if (node == null) return 0;
  
  int sum = 0;
  sum += traverseInOrder(node.left);
  sum += node.data;
  sum += traverseInOrder(node.right);
  return sum;
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: binary_tree_traverse <depth>');
    return;
  }
  
  final depth = int.parse(args[0]);
  final counter = [0];
  
  final stopwatch = Stopwatch()..start();
  final root = buildTree(depth, counter);
  final sum = traverseInOrder(root);
  stopwatch.stop();
  
  print('Dart: binary_tree_traverse($depth) = $sum');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');
}