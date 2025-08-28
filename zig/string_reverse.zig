const std = @import("std");
const print = std.debug.print;

fn reverseString(allocator: std.mem.Allocator, str: []const u8) ![]u8 {
    const result = try allocator.alloc(u8, str.len);
    var start: usize = 0;
    var end: usize = str.len - 1;
    
    @memcpy(result, str);
    
    while (start < end) {
        const temp = result[start];
        result[start] = result[end];
        result[end] = temp;
        start += 1;
        end -= 1;
    }
    
    return result;
}

fn generateString(allocator: std.mem.Allocator, length: usize) ![]u8 {
    const str = try allocator.alloc(u8, length);
    for (0..length) |i| {
        str[i] = @as(u8, 'A') + @as(u8, @intCast(i % 26));
    }
    return str;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len < 2) {
        print("Usage: string_reverse <length>\n", .{});
        return;
    }
    
    const length = try std.fmt.parseInt(usize, args[1], 10);
    const str = try generateString(allocator, length);
    defer allocator.free(str);
    
    const start = std.time.nanoTimestamp();
    const reversed = try reverseString(allocator, str);
    defer allocator.free(reversed);
    const end = std.time.nanoTimestamp();
    
    // Calculate checksum to verify correctness
    var checksum: i64 = 0;
    for (reversed) |c| {
        checksum += c;
    }
    
    const time_ms = @divFloor(end - start, 1_000_000);
    
    print("Zig: string_reverse({d}) = {d}\n", .{ length, checksum });
    print("Time: {d}ms\n", .{time_ms});
}