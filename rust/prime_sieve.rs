use std::env;
use std::time::Instant;

fn prime_sieve(n: usize) -> usize {
    let mut is_prime = vec![true; n + 1];
    is_prime[0] = false;
    if n > 0 {
        is_prime[1] = false;
    }
    
    let mut i = 2;
    while i * i <= n {
        if is_prime[i] {
            let mut j = i * i;
            while j <= n {
                is_prime[j] = false;
                j += i;
            }
        }
        i += 1;
    }
    
    let mut count = 0;
    for i in 2..=n {
        if is_prime[i] {
            count += 1;
        }
    }
    
    count
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: prime_sieve <n>");
        return;
    }
    
    let n: usize = args[1].parse().unwrap();
    
    let start = Instant::now();
    let count = prime_sieve(n);
    let duration = start.elapsed();
    
    let time_ms = duration.as_millis();
    
    println!("Rust: prime_sieve({}) = {}", n, count);
    println!("Time: {}ms", time_ms);
}