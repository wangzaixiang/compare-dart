use std::env;
use std::time::Instant;

fn counting_sort(arr: &mut Vec<i32>, n: usize, max_val: usize) {
    let mut count = vec![0; max_val + 1];
    let mut output = vec![0; n];
    
    // Count occurrences
    for i in 0..n {
        count[arr[i] as usize] += 1;
    }
    
    // Change count[i] so that it contains position of this character in output array
    for i in 1..=max_val {
        count[i] += count[i - 1];
    }
    
    // Build output array
    for i in (0..n).rev() {
        let val = arr[i] as usize;
        output[count[val] - 1] = arr[i];
        count[val] -= 1;
    }
    
    // Copy output array to arr
    for i in 0..n {
        arr[i] = output[i];
    }
}

fn generate_array(n: usize, max_val: usize) -> Vec<i32> {
    let mut arr = Vec::with_capacity(n);
    for i in 0..n {
        arr.push(((i * 7 + i * i * 3) % (max_val + 1)) as i32);
    }
    arr
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: counting_sort <n>");
        return;
    }
    
    let n: usize = args[1].parse().unwrap();
    let max_val = 999;
    let mut arr = generate_array(n, max_val);
    
    let start = Instant::now();
    counting_sort(&mut arr, n, max_val);
    let duration = start.elapsed();
    
    // Calculate checksum to verify correctness
    let mut checksum: i64 = 0;
    for i in 0..n {
        checksum += arr[i] as i64;
    }
    
    let time_ms = duration.as_millis();
    
    println!("Rust: counting_sort({}) = {}", n, checksum);
    println!("Time: {}ms", time_ms);
}