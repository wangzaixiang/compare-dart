const std = @import("std");
const print = std.debug.print;

fn countingSort(allocator: std.mem.Allocator, arr: []i32, n: usize, max_val: usize) !void {
    const count = try allocator.alloc(i32, max_val + 1);
    defer allocator.free(count);
    const output = try allocator.alloc(i32, n);
    defer allocator.free(output);
    
    // Initialize count array
    for (count) |*item| {
        item.* = 0;
    }
    
    // Count occurrences
    for (0..n) |i| {
        count[@intCast(arr[i])] += 1;
    }
    
    // Change count[i] so that it contains position of this character in output array
    for (1..max_val + 1) |i| {
        count[i] += count[i - 1];
    }
    
    // Build output array
    var i = n;
    while (i > 0) {
        i -= 1;
        const val = @as(usize, @intCast(arr[i]));
        output[@intCast(count[val] - 1)] = arr[i];
        count[val] -= 1;
    }
    
    // Copy output array to arr
    for (0..n) |idx| {
        arr[idx] = output[idx];
    }
}

fn generateArray(allocator: std.mem.Allocator, n: usize, max_val: usize) ![]i32 {
    const arr = try allocator.alloc(i32, n);
    for (0..n) |i| {
        // Use safer generation to avoid overflow and ensure positive numbers
        const val = @as(u32, @intCast((i * 7 + (i % 1000) * 3) % (max_val + 1)));
        arr[i] = @as(i32, @intCast(val));
    }
    return arr;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len < 2) {
        print("Usage: counting_sort <n>\n", .{});
        return;
    }
    
    const n = try std.fmt.parseInt(usize, args[1], 10);
    const max_val: usize = 999;
    const arr = try generateArray(allocator, n, max_val);
    defer allocator.free(arr);
    
    const start = std.time.nanoTimestamp();
    try countingSort(allocator, arr, n, max_val);
    const end = std.time.nanoTimestamp();
    
    // Calculate checksum to verify correctness
    var checksum: i64 = 0;
    for (0..n) |i| {
        checksum += arr[i];
    }
    
    const time_ms = @divFloor(end - start, 1_000_000);
    
    print("Zig: counting_sort({d}) = {d}\n", .{ n, checksum });
    print("Time: {d}ms\n", .{time_ms});
}