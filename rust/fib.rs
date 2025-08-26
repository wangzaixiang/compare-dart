use std::env;
use std::time::Instant;

fn fib(n: i32) -> i32 {
    if n <= 1 {
        return n;
    }
    fib(n - 1) + fib(n - 2)
}

fn main() {
    let args: Vec<String> = env::args().collect();
    
    if args.len() < 2 {
        println!("Usage: fib <n>");
        return;
    }
    
    let n: i32 = args[1].parse().unwrap();
    let start = Instant::now();
    let result = fib(n);
    let duration = start.elapsed();
    
    println!("Rust: fib({}) = {}", n, result);
    println!("Time: {}ms", duration.as_millis());
}