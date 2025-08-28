const std = @import("std");
const print = std.debug.print;

fn primeSieve(allocator: std.mem.Allocator, n: usize) !usize {
    const is_prime = try allocator.alloc(bool, n + 1);
    defer allocator.free(is_prime);
    
    for (is_prime) |*item| {
        item.* = true;
    }
    is_prime[0] = false;
    if (n > 0) is_prime[1] = false;
    
    var i: usize = 2;
    while (i * i <= n) : (i += 1) {
        if (is_prime[i]) {
            var j = i * i;
            while (j <= n) : (j += i) {
                is_prime[j] = false;
            }
        }
    }
    
    var count: usize = 0;
    i = 2;
    while (i <= n) : (i += 1) {
        if (is_prime[i]) {
            count += 1;
        }
    }
    
    return count;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len < 2) {
        print("Usage: prime_sieve <n>\n", .{});
        return;
    }
    
    const n = try std.fmt.parseInt(usize, args[1], 10);
    
    const start = std.time.nanoTimestamp();
    const count = try primeSieve(allocator, n);
    const end = std.time.nanoTimestamp();
    
    const time_ms = @divFloor(end - start, 1_000_000);
    
    print("Zig: prime_sieve({d}) = {d}\n", .{ n, count });
    print("Time: {d}ms\n", .{time_ms});
}