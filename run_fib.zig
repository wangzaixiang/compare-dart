const std = @import("std");
const print = std.debug.print;

const MAX_TESTS = 20;

const TestResult = struct {
    name: [50]u8,
    time_ms: u32,
    result: u32,
    success: bool,
};

fn runCommand(allocator: std.mem.Allocator, command: []const u8, name: []const u8) TestResult {
    var result = TestResult{
        .name = [_]u8{0} ** 50,
        .time_ms = 0,
        .result = 0,
        .success = false,
    };

    // Copy name
    @memcpy(result.name[0..name.len], name);

    var process = std.process.Child.init(&[_][]const u8{ "sh", "-c", command }, allocator);
    process.stdout_behavior = .Pipe;
    process.stderr_behavior = .Pipe;

    process.spawn() catch return result;

    const stdout = process.stdout.?.readToEndAlloc(allocator, 1024 * 1024) catch return result;
    defer allocator.free(stdout);

    const stderr = process.stderr.?.readToEndAlloc(allocator, 1024 * 1024) catch return result;
    defer allocator.free(stderr);

    const term = process.wait() catch return result;

    if (term != .Exited or term.Exited != 0) {
        return result;
    }

    // Use stdout first, but if empty, try stderr (some programs output to stderr)
    const output = if (stdout.len > 0) stdout else stderr;

    // Parse output to extract time and result
    var lines = std.mem.splitSequence(u8, output, "\n");

    while (lines.next()) |line| {
        const trimmed = std.mem.trim(u8, line, " \r\n\t");
        if (trimmed.len == 0) continue;

        if (std.mem.indexOf(u8, trimmed, "Time: ")) |time_start| {
            const time_str_start = time_start + 6;
            if (std.mem.indexOf(u8, trimmed[time_str_start..], "ms")) |ms_pos| {
                const time_str = trimmed[time_str_start .. time_str_start + ms_pos];
                result.time_ms = std.fmt.parseInt(u32, time_str, 10) catch 0;
            }
        }
        if (std.mem.indexOf(u8, trimmed, "fib(")) |_| {
            if (std.mem.indexOf(u8, trimmed, " = ")) |eq_pos| {
                const result_start = eq_pos + 3;
                const result_str = std.mem.trim(u8, trimmed[result_start..], " \r\n\t");
                result.result = std.fmt.parseInt(u32, result_str, 10) catch 0;
            }
        }
    }

    result.success = result.time_ms > 0 and result.result > 0;

    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const n: u32 = if (args.len >= 2) std.fmt.parseInt(u32, args[1], 10) catch 42 else 42;

    print("\n🚀 编程语言性能对比 - 递归版本的 Fibonacci\n", .{});
    print("测试参数: fib({})\n", .{n});
    print("============================================================\n\n", .{});

    // Compile all implementations first
    print("📦 编译所有实现...\n", .{});

    const compile_commands = [_][]const u8{
        "dart compile exe dart/fib.dart -o dart/fib 2>/dev/null",
        "javac java/Fib.java 2>/dev/null",
        "[ -r java/fib_graal ] || javanative-image -cp java Fib java/fib_graal --no-fallback 2>/dev/null || echo 'GraalVM native-image not available' >/dev/null",
        "zig build-exe zig/fib.zig -O ReleaseFast -femit-bin=zig/fib 2>/dev/null",
        "rustc -O rust/fib.rs -o rust/fib 2>/dev/null",
        "gcc -O2 c/fib.c -o c/fib_gcc 2>/dev/null",
        "clang -O2 c/fib.c -o c/fib_clang 2>/dev/null",
        "swiftc -O swift/fib.swift -o swift/fib 2>/dev/null",
        "go build -o go/fib go/fib.go 2>/dev/null",
    };

    for (compile_commands) |cmd| {
        var process = std.process.Child.init(&[_][]const u8{ "sh", "-c", cmd }, allocator);
        _ = process.spawnAndWait() catch {};
    }

    print("✅ 编译完成\n\n", .{});

    // Test configurations
    const tests = [_]struct {
        name: []const u8,
        command: []const u8,
    }{
        .{ .name = "Java (JVM)", .command = "java -cp java Fib" },
        .{ .name = "Java (GraalVM)", .command = "java/fib_graal" },
        .{ .name = "Zig", .command = "zig/fib" },
        .{ .name = "Rust", .command = "rust/fib" },
        .{ .name = "C (Clang)", .command = "c/fib_clang" },
        .{ .name = "C (GCC)", .command = "c/fib_gcc" },
        .{ .name = "Go", .command = "go/fib" },
        .{ .name = "Swift", .command = "swift/fib" },
        .{ .name = "JavaScript (Bun)", .command = "bun javascript/fib.js" },
        .{ .name = "Dart (AOT)", .command = "dart/fib" },
        .{ .name = "Dart (JIT)", .command = "dart dart/fib.dart" },
        .{ .name = "JavaScript (Node.js)", .command = "node javascript/fib.js" },
        .{ .name = "Python (CPython)", .command = "python3 python/fib.py" },
        .{ .name = "Python (PyPy)", .command = "pypy3.10 python/fib.py" },
        .{ .name = "Lua", .command = "lua lua/fib.lua" },
        .{ .name = "Lua (LuaJIT)", .command = "luajit lua/fib.lua" },
    };

    var results: [MAX_TESTS]TestResult = undefined;
    var result_count: u32 = 0;

    print("🏃 开始运行测试...\n\n", .{});

    for (tests) |test_case| {
        print("运行 {s}... ", .{test_case.name});

        var command_buf: [256]u8 = undefined;
        const full_command = std.fmt.bufPrint(command_buf[0..], "{s} {}", .{ test_case.command, n }) catch continue;

        const result = runCommand(allocator, full_command, test_case.name);

        if (result.success) {
            print("✅ {}ms\n", .{result.time_ms});
        } else {
            print("❌ 失败\n", .{});
        }

        results[result_count] = result;
        result_count += 1;
    }

    // Sort results by time (simple bubble sort)
    var i: u32 = 0;
    while (i < result_count) : (i += 1) {
        var j: u32 = i + 1;
        while (j < result_count) : (j += 1) {
            const should_swap = if (!results[i].success and results[j].success) true else if (results[i].success and !results[j].success) false else if (results[i].success and results[j].success) results[i].time_ms > results[j].time_ms else false;

            if (should_swap) {
                const temp = results[i];
                results[i] = results[j];
                results[j] = temp;
            }
        }
    }

    print("\n============================================================\n", .{});
    print("🏆 性能排名结果\n", .{});
    print("============================================================\n\n", .{});

    const medals = [_][]const u8{ "🥇", "🥈", "🥉", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "🔟" };

    var fastest_time: u32 = 0;
    i = 0;
    while (i < result_count) : (i += 1) {
        const result = results[i];
        if (result.success and fastest_time == 0) {
            fastest_time = result.time_ms;
        }

        if (result.success) {
            const medal = if (i < medals.len) medals[i] else "📍";
            const relative = if (fastest_time > 0) @as(f32, @floatFromInt(result.time_ms)) / @as(f32, @floatFromInt(fastest_time)) * 100.0 else 100.0;
            const name_str = std.mem.sliceTo(&result.name, 0);
            print("{s} {s:<20} {d:>4}ms ({d:.1}%)\n", .{ medal, name_str, result.time_ms, relative });
        } else {
            const name_str = std.mem.sliceTo(&result.name, 0);
            print("❌ {s:<20} 测试失败\n", .{name_str});
        }
    }

    print("\n📊 测试总结:\n", .{});
    print("• 测试参数: fib({}) = ", .{n});
    if (result_count > 0 and results[0].success) {
        print("{}\n", .{results[0].result});
    } else {
        print("N/A\n", .{});
    }

    var successful_tests: u32 = 0;
    i = 0;
    while (i < result_count) : (i += 1) {
        if (results[i].success) successful_tests += 1;
    }
    print("• 成功测试: {}/{}\n", .{ successful_tests, result_count });

    if (fastest_time > 0) {
        const fastest_name = std.mem.sliceTo(&results[0].name, 0);
        print("• 最快实现: {s} ({}ms)\n", .{ fastest_name, fastest_time });
    }

    print("\n💡 使用说明:\n", .{});
    print("  ./run_fib <n>  # 指定 fibonacci 数值 (默认: 42)\n", .{});
    print("  例如: ./run_fib 40\n", .{});
}
