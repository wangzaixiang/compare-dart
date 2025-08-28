#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct Node {
    int data;
    struct Node* left;
    struct Node* right;
} Node;

Node* createNode(int data) {
    Node* node = malloc(sizeof(Node));
    node->data = data;
    node->left = NULL;
    node->right = NULL;
    return node;
}

Node* buildTree(int depth, int* counter) {
    if (depth <= 0) return NULL;
    
    Node* node = createNode((*counter)++);
    node->left = buildTree(depth - 1, counter);
    node->right = buildTree(depth - 1, counter);
    return node;
}

int traverseInOrder(Node* node) {
    if (node == NULL) return 0;
    
    int sum = 0;
    sum += traverseInOrder(node->left);
    sum += node->data;
    sum += traverseInOrder(node->right);
    return sum;
}

void freeTree(Node* node) {
    if (node == NULL) return;
    
    freeTree(node->left);
    freeTree(node->right);
    free(node);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: binary_tree_traverse <depth>\n");
        return 1;
    }
    
    int depth = atoi(argv[1]);
    int counter = 0;
    
    clock_t start = clock();
    Node* root = buildTree(depth, &counter);
    int sum = traverseInOrder(root);
    freeTree(root);
    clock_t end = clock();
    
    double time_ms = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    
    printf("C: binary_tree_traverse(%d) = %d\n", depth, sum);
    printf("Time: %.0fms\n", time_ms);
    
    return 0;
}