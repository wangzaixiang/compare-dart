const std = @import("std");
const print = std.debug.print;

fn bubbleSort(arr: []i32) void {
    const n = arr.len;
    var i: usize = 0;
    while (i < n - 1) : (i += 1) {
        var j: usize = 0;
        while (j < n - i - 1) : (j += 1) {
            if (arr[j] > arr[j + 1]) {
                const temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

fn generateArray(allocator: std.mem.Allocator, n: usize) ![]i32 {
    const arr = try allocator.alloc(i32, n);
    var seed: u32 = 42; // Fixed seed for reproducible results
    
    for (arr) |*item| {
        seed = seed *% 1103515245 +% 12345;
        item.* = @intCast(seed % 10000);
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
        print("Usage: bubble_sort <n>\n", .{});
        return;
    }
    
    const n = try std.fmt.parseInt(usize, args[1], 10);
    const arr = try generateArray(allocator, n);
    defer allocator.free(arr);
    
    const start = std.time.nanoTimestamp();
    bubbleSort(arr);
    const end = std.time.nanoTimestamp();
    
    const time_ms = @divFloor(end - start, 1_000_000);
    
    print("Zig: bubble_sort({d}) = sorted\n", .{n});
    print("Time: {d}ms\n", .{time_ms});
}