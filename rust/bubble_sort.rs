use std::env;
use std::time::Instant;

fn bubble_sort(arr: &mut [i32]) {
    let n = arr.len();
    for i in 0..n - 1 {
        for j in 0..n - i - 1 {
            if arr[j] > arr[j + 1] {
                arr.swap(j, j + 1);
            }
        }
    }
}

fn generate_array(n: usize) -> Vec<i32> {
    // Simple seeded random for reproducible results
    let mut seed: u32 = 42;
    let mut arr = Vec::with_capacity(n);
    
    for _ in 0..n {
        seed = seed.wrapping_mul(1103515245).wrapping_add(12345);
        arr.push((seed % 10000) as i32);
    }
    
    arr
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: bubble_sort <n>");
        return;
    }
    
    let n: usize = args[1].parse().unwrap();
    let mut arr = generate_array(n);
    
    let start = Instant::now();
    bubble_sort(&mut arr);
    let duration = start.elapsed();
    
    let time_ms = duration.as_millis();
    
    println!("Rust: bubble_sort({}) = sorted", n);
    println!("Time: {}ms", time_ms);
}