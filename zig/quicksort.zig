const std = @import("std");
const print = std.debug.print;

fn quicksort(arr: []i32, low: i32, high: i32) void {
    if (low < high) {
        const pi = partition(arr, low, high);
        quicksort(arr, low, pi - 1);
        quicksort(arr, pi + 1, high);
    }
}

fn partition(arr: []i32, low: i32, high: i32) i32 {
    const pivot = arr[@intCast(high)];
    var i = low - 1;
    
    var j = low;
    while (j <= high - 1) : (j += 1) {
        if (arr[@intCast(j)] < pivot) {
            i += 1;
            const temp = arr[@intCast(i)];
            arr[@intCast(i)] = arr[@intCast(j)];
            arr[@intCast(j)] = temp;
        }
    }
    const temp = arr[@intCast(i + 1)];
    arr[@intCast(i + 1)] = arr[@intCast(high)];
    arr[@intCast(high)] = temp;
    return i + 1;
}

fn generateArray(allocator: std.mem.Allocator, n: usize) ![]i32 {
    const arr = try allocator.alloc(i32, n);
    var seed: u32 = 42;
    
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
        print("Usage: quicksort <n>\n", .{});
        return;
    }
    
    const n = try std.fmt.parseInt(usize, args[1], 10);
    const arr = try generateArray(allocator, n);
    defer allocator.free(arr);
    
    const start = std.time.nanoTimestamp();
    quicksort(arr, 0, @intCast(n - 1));
    const end = std.time.nanoTimestamp();
    
    const time_ms = @divFloor(end - start, 1_000_000);
    
    print("Zig: quicksort({d}) = sorted\n", .{n});
    print("Time: {d}ms\n", .{time_ms});
}