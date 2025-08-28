use std::env;
use std::time::Instant;

fn reverse_string(s: String) -> String {
    let mut chars: Vec<char> = s.chars().collect();
    let mut start = 0;
    let mut end = chars.len() - 1;
    
    while start < end {
        chars.swap(start, end);
        start += 1;
        end -= 1;
    }
    
    chars.iter().collect()
}

fn generate_string(length: usize) -> String {
    let mut s = String::with_capacity(length);
    for i in 0..length {
        s.push((b'A' + (i % 26) as u8) as char);
    }
    s
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: string_reverse <length>");
        return;
    }
    
    let length: usize = args[1].parse().unwrap();
    let s = generate_string(length);
    
    let start = Instant::now();
    let reversed = reverse_string(s);
    let duration = start.elapsed();
    
    // Calculate checksum to verify correctness
    let mut checksum: i64 = 0;
    for c in reversed.chars() {
        checksum += c as i64;
    }
    
    let time_ms = duration.as_millis();
    
    println!("Rust: string_reverse({}) = {}", length, checksum);
    println!("Time: {}ms", time_ms);
}