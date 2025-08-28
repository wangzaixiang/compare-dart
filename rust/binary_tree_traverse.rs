use std::env;
use std::time::Instant;

#[derive(Debug)]
struct Node {
    data: i32,
    left: Option<Box<Node>>,
    right: Option<Box<Node>>,
}

impl Node {
    fn new(data: i32) -> Self {
        Node {
            data,
            left: None,
            right: None,
        }
    }
}

fn build_tree(depth: i32, counter: &mut i32) -> Option<Box<Node>> {
    if depth <= 0 {
        return None;
    }
    
    let mut node = Box::new(Node::new(*counter));
    *counter += 1;
    node.left = build_tree(depth - 1, counter);
    node.right = build_tree(depth - 1, counter);
    Some(node)
}

fn traverse_in_order(node: &Option<Box<Node>>) -> i32 {
    match node {
        None => 0,
        Some(n) => {
            let mut sum = 0;
            sum += traverse_in_order(&n.left);
            sum += n.data;
            sum += traverse_in_order(&n.right);
            sum
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: binary_tree_traverse <depth>");
        return;
    }
    
    let depth: i32 = args[1].parse().unwrap();
    let mut counter = 0;
    
    let start = Instant::now();
    let root = build_tree(depth, &mut counter);
    let sum = traverse_in_order(&root);
    let duration = start.elapsed();
    
    let time_ms = duration.as_millis();
    
    println!("Rust: binary_tree_traverse({}) = {}", depth, sum);
    println!("Time: {}ms", time_ms);
}