use std::env;
use std::time::Instant;

fn mandelbrot(x0: f64, y0: f64, max_iter: i32) -> i32 {
    let mut x = 0.0;
    let mut y = 0.0;
    let mut iteration = 0;
    
    while x*x + y*y <= 4.0 && iteration < max_iter {
        let xtemp = x*x - y*y + x0;
        y = 2.0*x*y + y0;
        x = xtemp;
        iteration += 1;
    }
    iteration
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: mandelbrot <size>");
        return;
    }
    
    let size: i32 = args[1].parse().unwrap();
    let max_iter = 100;
    
    let start = Instant::now();
    
    let mut count = 0;
    for py in 0..size {
        for px in 0..size {
            let x0 = (px as f64 - size as f64 / 2.0) * 3.0 / size as f64;
            let y0 = (py as f64 - size as f64 / 2.0) * 3.0 / size as f64;
            let iter = mandelbrot(x0, y0, max_iter);
            if iter < max_iter {
                count += 1;
            }
        }
    }
    
    let duration = start.elapsed();
    let time_ms = duration.as_millis();
    
    println!("Rust: mandelbrot({}) = {}", size, count);
    println!("Time: {}ms", time_ms);
}