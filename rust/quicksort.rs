use std::env;
use std::time::Instant;

fn quicksort(arr: &mut [i32], low: isize, high: isize) {
    if low < high {
        let pi = partition(arr, low, high);
        quicksort(arr, low, pi - 1);
        quicksort(arr, pi + 1, high);
    }
}

fn partition(arr: &mut [i32], low: isize, high: isize) -> isize {
    let pivot = arr[high as usize];
    let mut i = low - 1;
    
    for j in low..high {
        if arr[j as usize] < pivot {
            i += 1;
            arr.swap(i as usize, j as usize);
        }
    }
    arr.swap((i + 1) as usize, high as usize);
    i + 1
}

fn generate_array(n: usize) -> Vec<i32> {
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
        println!("Usage: quicksort <n>");
        return;
    }
    
    let n: usize = args[1].parse().unwrap();
    let mut arr = generate_array(n);
    
    let start = Instant::now();
    quicksort(&mut arr, 0, (n - 1) as isize);
    let duration = start.elapsed();
    
    let time_ms = duration.as_millis();
    
    println!("Rust: quicksort({}) = sorted", n);
    println!("Time: {}ms", time_ms);
}