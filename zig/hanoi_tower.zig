const std = @import("std");
const print = std.debug.print;

var move_count: i32 = 0;

fn hanoiTower(n: i32, from: u8, to: u8, aux: u8) void {
    if (n == 1) {
        move_count += 1;
        return;
    }
    
    hanoiTower(n - 1, from, aux, to);
    move_count += 1;
    hanoiTower(n - 1, aux, to, from);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len < 2) {
        print("Usage: hanoi_tower <n>\n", .{});
        return;
    }
    
    const n = try std.fmt.parseInt(i32, args[1], 10);
    move_count = 0;
    
    const start = std.time.nanoTimestamp();
    hanoiTower(n, 'A', 'C', 'B');
    const end = std.time.nanoTimestamp();
    
    const time_ms = @divFloor(end - start, 1_000_000);
    
    print("Zig: hanoi_tower({d}) = {d}\n", .{ n, move_count });
    print("Time: {d}ms\n", .{time_ms});
}