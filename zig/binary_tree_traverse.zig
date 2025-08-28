const std = @import("std");
const print = std.debug.print;

const Node = struct {
    data: i32,
    left: ?*Node,
    right: ?*Node,
};

fn buildTree(allocator: std.mem.Allocator, depth: i32, counter: *i32) !?*Node {
    if (depth <= 0) return null;
    
    const node = try allocator.create(Node);
    node.data = counter.*;
    counter.* += 1;
    node.left = try buildTree(allocator, depth - 1, counter);
    node.right = try buildTree(allocator, depth - 1, counter);
    return node;
}

fn traverseInOrder(node: ?*Node) i32 {
    if (node == null) return 0;
    
    var sum: i32 = 0;
    sum += traverseInOrder(node.?.left);
    sum += node.?.data;
    sum += traverseInOrder(node.?.right);
    return sum;
}

fn freeTree(allocator: std.mem.Allocator, node: ?*Node) void {
    if (node == null) return;
    
    freeTree(allocator, node.?.left);
    freeTree(allocator, node.?.right);
    allocator.destroy(node.?);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len < 2) {
        print("Usage: binary_tree_traverse <depth>\n", .{});
        return;
    }
    
    const depth = try std.fmt.parseInt(i32, args[1], 10);
    var counter: i32 = 0;
    
    const start = std.time.nanoTimestamp();
    const root = try buildTree(allocator, depth, &counter);
    const sum = traverseInOrder(root);
    freeTree(allocator, root);
    const end = std.time.nanoTimestamp();
    
    const time_ms = @divFloor(end - start, 1_000_000);
    
    print("Zig: binary_tree_traverse({d}) = {d}\n", .{ depth, sum });
    print("Time: {d}ms\n", .{time_ms});
}