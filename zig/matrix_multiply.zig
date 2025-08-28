const std = @import("std");
const print = std.debug.print;

fn matrixMultiply(a: [][]i32, b: [][]i32, c: [][]i32, size: usize) void {
    for (0..size) |i| {
        for (0..size) |j| {
            c[i][j] = 0;
            for (0..size) |k| {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

fn allocateMatrix(allocator: std.mem.Allocator, size: usize) ![][]i32 {
    const matrix = try allocator.alloc([]i32, size);
    for (matrix) |*row| {
        row.* = try allocator.alloc(i32, size);
    }
    return matrix;
}

fn freeMatrix(allocator: std.mem.Allocator, matrix: [][]i32) void {
    for (matrix) |row| {
        allocator.free(row);
    }
    allocator.free(matrix);
}

fn initMatrix(matrix: [][]i32, size: usize, seed_offset: u32) void {
    for (0..size) |i| {
        for (0..size) |j| {
            matrix[i][j] = @intCast((i * 3 + j * 7 + seed_offset) % 100);
        }
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len < 2) {
        print("Usage: matrix_multiply <size>\n", .{});
        return;
    }
    
    const size = try std.fmt.parseInt(usize, args[1], 10);
    
    const a = try allocateMatrix(allocator, size);
    defer freeMatrix(allocator, a);
    const b = try allocateMatrix(allocator, size);
    defer freeMatrix(allocator, b);
    const c = try allocateMatrix(allocator, size);
    defer freeMatrix(allocator, c);
    
    initMatrix(a, size, 0);
    initMatrix(b, size, 1);
    
    const start = std.time.nanoTimestamp();
    matrixMultiply(a, b, c, size);
    const end = std.time.nanoTimestamp();
    
    // Calculate checksum to verify correctness
    var checksum: i64 = 0;
    for (0..size) |i| {
        for (0..size) |j| {
            checksum += c[i][j];
        }
    }
    
    const time_ms = @divFloor(end - start, 1_000_000);
    
    print("Zig: matrix_multiply({d}) = {d}\n", .{ size, checksum });
    print("Time: {d}ms\n", .{time_ms});
}