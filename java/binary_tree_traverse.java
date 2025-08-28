class Node {
    int data;
    Node left;
    Node right;
    
    Node(int data) {
        this.data = data;
        this.left = null;
        this.right = null;
    }
}

public class binary_tree_traverse {
    
    public static Node buildTree(int depth, int[] counter) {
        if (depth <= 0) return null;
        
        Node node = new Node(counter[0]++);
        node.left = buildTree(depth - 1, counter);
        node.right = buildTree(depth - 1, counter);
        return node;
    }
    
    public static int traverseInOrder(Node node) {
        if (node == null) return 0;
        
        int sum = 0;
        sum += traverseInOrder(node.left);
        sum += node.data;
        sum += traverseInOrder(node.right);
        return sum;
    }
    
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: binary_tree_traverse <depth>");
            return;
        }
        
        int depth = Integer.parseInt(args[0]);
        int[] counter = {0};
        
        long start = System.currentTimeMillis();
        Node root = buildTree(depth, counter);
        int sum = traverseInOrder(root);
        long end = System.currentTimeMillis();
        
        long timeMs = end - start;
        
        System.out.println("Java: binary_tree_traverse(" + depth + ") = " + sum);
        System.out.println("Time: " + timeMs + "ms");
    }
}