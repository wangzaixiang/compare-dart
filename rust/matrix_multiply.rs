use std::env;
use std::time::Instant;

fn matrix_multiply(a: &Vec<Vec<i32>>, b: &Vec<Vec<i32>>, c: &mut Vec<Vec<i32>>, size: usize) {
    for i in 0..size {
        for j in 0..size {
            c[i][j] = 0;
            for k in 0..size {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

fn allocate_matrix(size: usize) -> Vec<Vec<i32>> {
    vec![vec![0; size]; size]
}

fn init_matrix(matrix: &mut Vec<Vec<i32>>, size: usize, seed_offset: u32) {
    for i in 0..size {
        for j in 0..size {
            matrix[i][j] = ((i * 3 + j * 7 + seed_offset as usize) % 100) as i32;
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: matrix_multiply <size>");
        return;
    }
    
    let size: usize = args[1].parse().unwrap();
    
    let mut a = allocate_matrix(size);
    let mut b = allocate_matrix(size);
    let mut c = allocate_matrix(size);
    
    init_matrix(&mut a, size, 0);
    init_matrix(&mut b, size, 1);
    
    let start = Instant::now();
    matrix_multiply(&a, &b, &mut c, size);
    let duration = start.elapsed();
    
    // Calculate checksum to verify correctness
    let mut checksum: i64 = 0;
    for i in 0..size {
        for j in 0..size {
            checksum += c[i][j] as i64;
        }
    }
    
    let time_ms = duration.as_millis();
    
    println!("Rust: matrix_multiply({}) = {}", size, checksum);
    println!("Time: {}ms", time_ms);
}