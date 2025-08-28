const std = @import("std");
const print = std.debug.print;

fn mandelbrot(x0: f64, y0: f64, max_iter: i32) i32 {
    var x: f64 = 0.0;
    var y: f64 = 0.0;
    var iteration: i32 = 0;
    
    while (x*x + y*y <= 4.0 and iteration < max_iter) {
        const xtemp = x*x - y*y + x0;
        y = 2.0*x*y + y0;
        x = xtemp;
        iteration += 1;
    }
    return iteration;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len < 2) {
        print("Usage: mandelbrot <size>\n", .{});
        return;
    }
    
    const size = try std.fmt.parseInt(i32, args[1], 10);
    const max_iter: i32 = 100;
    
    const start = std.time.nanoTimestamp();
    
    var count: i32 = 0;
    var py: i32 = 0;
    while (py < size) : (py += 1) {
        var px: i32 = 0;
        while (px < size) : (px += 1) {
            const x0 = (@as(f64, @floatFromInt(px)) - @as(f64, @floatFromInt(size)) / 2.0) * 3.0 / @as(f64, @floatFromInt(size));
            const y0 = (@as(f64, @floatFromInt(py)) - @as(f64, @floatFromInt(size)) / 2.0) * 3.0 / @as(f64, @floatFromInt(size));
            const iter = mandelbrot(x0, y0, max_iter);
            if (iter < max_iter) {
                count += 1;
            }
        }
    }
    
    const end = std.time.nanoTimestamp();
    const time_ms = @divFloor(end - start, 1_000_000);
    
    print("Zig: mandelbrot({d}) = {d}\n", .{ size, count });
    print("Time: {d}ms\n", .{time_ms});
}