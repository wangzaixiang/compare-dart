const std = @import("std");

fn fib(n: i32) i32 {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len < 2) {
        std.debug.print("Usage: fib <n>\n", .{});
        return;
    }
    
    const n = try std.fmt.parseInt(i32, args[1], 10);
    var timer = std.time.Timer.start() catch unreachable;
    const result = fib(n);
    const elapsed = timer.read();
    
    std.debug.print("Zig: fib({}) = {}\n", .{ n, result });
    std.debug.print("Time: {}ms\n", .{elapsed / 1_000_000});
}