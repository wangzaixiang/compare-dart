use std::env;
use std::time::Instant;

static mut MOVE_COUNT: i32 = 0;

fn hanoi_tower(n: i32, from: char, to: char, aux: char) {
    if n == 1 {
        unsafe {
            MOVE_COUNT += 1;
        }
        return;
    }
    
    hanoi_tower(n - 1, from, aux, to);
    unsafe {
        MOVE_COUNT += 1;
    }
    hanoi_tower(n - 1, aux, to, from);
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: hanoi_tower <n>");
        return;
    }
    
    let n: i32 = args[1].parse().unwrap();
    
    unsafe {
        MOVE_COUNT = 0;
    }
    
    let start = Instant::now();
    hanoi_tower(n, 'A', 'C', 'B');
    let duration = start.elapsed();
    
    let time_ms = duration.as_millis();
    
    unsafe {
        println!("Rust: hanoi_tower({}) = {}", n, MOVE_COUNT);
    }
    println!("Time: {}ms", time_ms);
}