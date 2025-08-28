const std = @import("std");
const print = std.debug.print;

// 全局配置结构
const GlobalConfig = struct {
    output_dir: []const u8,
    results_dir: []const u8,
    executables_dir: []const u8,
    default_timeout_ms: u32,
    max_concurrent: u32,
};

// 语言配置结构
const LangConfig = struct {
    name: []const u8,
    src_template: []const u8,
    compile_cmd: ?[]const u8,  // null 表示无需编译
    execute_cmd: []const u8,
    enabled: bool,
};

// 测试用例配置结构
const CaseConfig = struct {
    name: []const u8,
    description: []const u8,
    args: []const u8,
    args_quick: []const u8,
    timeout_ms: u32,
    enabled: bool,
};

// 配置管理结构
const Config = struct {
    global: GlobalConfig,
    languages: std.HashMap([]const u8, LangConfig, std.hash_map.StringContext, std.hash_map.default_max_load_percentage),
    test_cases: std.HashMap([]const u8, CaseConfig, std.hash_map.StringContext, std.hash_map.default_max_load_percentage),
    allocator: std.mem.Allocator,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) Self {
        return Self{
            .global = GlobalConfig{
                .output_dir = "output",
                .results_dir = "output/results",
                .executables_dir = "output/executables",
                .default_timeout_ms = 30000,
                .max_concurrent = 1,
            },
            .languages = std.HashMap([]const u8, LangConfig, std.hash_map.StringContext, std.hash_map.default_max_load_percentage).init(allocator),
            .test_cases = std.HashMap([]const u8, CaseConfig, std.hash_map.StringContext, std.hash_map.default_max_load_percentage).init(allocator),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        self.languages.deinit();
        self.test_cases.deinit();
    }
};

// 测试结果结构
const TestResult = struct {
    language: []const u8,
    case: []const u8,
    time_ms: u32,
    success: bool,
    error_msg: []const u8,
};

// 简化的 YAML 解析器
fn parseYaml(allocator: std.mem.Allocator, content: []const u8, config: *Config) !void {
    var lines = std.mem.splitSequence(u8, content, "\n");
    var current_section: []const u8 = "";
    var current_item: []const u8 = "";
    
    while (lines.next()) |line| {
        const trimmed = std.mem.trim(u8, line, " \t\r");
        
        // 跳过空行和注释
        if (trimmed.len == 0 or trimmed[0] == '#') continue;
        
        // 计算缩进级别
        const current_indent = countIndent(line);
        
        // 解析键值对
        if (std.mem.indexOf(u8, trimmed, ":")) |colon_pos| {
            const key = std.mem.trim(u8, trimmed[0..colon_pos], " \t");
            var value_str = std.mem.trim(u8, trimmed[colon_pos + 1 ..], " \t");
            
            // 移除注释
            if (std.mem.indexOf(u8, value_str, "#")) |comment_pos| {
                value_str = std.mem.trim(u8, value_str[0..comment_pos], " \t");
            }
            
            // 移除引号
            if (value_str.len >= 2 and value_str[0] == '"' and value_str[value_str.len - 1] == '"') {
                value_str = value_str[1 .. value_str.len - 1];
            }
            
            // 处理 YAML null 值
            if (std.mem.eql(u8, value_str, "null") or std.mem.eql(u8, value_str, "~")) {
                value_str = ""; // 统一处理为空字符串，在具体字段处理时转换为 null
            }
            
            // 根据缩进级别确定层级
            if (current_indent == 0) {
                // 顶级 section
                current_section = try allocator.dupe(u8, key);
            } else if (current_indent == 2 and std.mem.eql(u8, current_section, "languages")) {
                // languages 下的语言项
                current_item = try allocator.dupe(u8, key);
                if (value_str.len == 0) {
                    // 新的语言项开始
                    try ensureLangConfig(config, current_item);
                }
            } else if (current_indent == 2 and std.mem.eql(u8, current_section, "test_cases")) {
                // test_cases 下的测试用例项
                current_item = try allocator.dupe(u8, key);
                if (value_str.len == 0) {
                    // 新的测试用例项开始
                    try ensureCaseConfig(config, current_item);
                }
            } else if (current_indent == 2 and std.mem.eql(u8, current_section, "global")) {
                // 全局配置项
                try setGlobalConfig(config, key, value_str);
            } else if (current_indent == 4 and std.mem.eql(u8, current_section, "languages")) {
                // 语言配置的属性
                try setLangConfig(allocator, config, current_item, key, value_str);
            } else if (current_indent == 4 and std.mem.eql(u8, current_section, "test_cases")) {
                // 测试用例配置的属性
                try setCaseConfig(allocator, config, current_item, key, value_str);
            }
        }
    }
}

// 计算行的缩进级别
fn countIndent(line: []const u8) u32 {
    var indent: u32 = 0;
    for (line) |char| {
        if (char == ' ') {
            indent += 1;
        } else {
            break;
        }
    }
    return indent;
}

// 确保语言配置存在
fn ensureLangConfig(config: *Config, lang_name: []const u8) !void {
    if (!config.languages.contains(lang_name)) {
        try config.languages.put(lang_name, LangConfig{
            .name = "",
            .src_template = "",
            .compile_cmd = null,
            .execute_cmd = "",
            .enabled = true,
        });
    }
}

// 确保测试用例配置存在
fn ensureCaseConfig(config: *Config, case_name: []const u8) !void {
    if (!config.test_cases.contains(case_name)) {
        try config.test_cases.put(case_name, CaseConfig{
            .name = "",
            .description = "",
            .args = "",
            .args_quick = "",
            .timeout_ms = 30000,
            .enabled = true,
        });
    }
}

// 设置全局配置
fn setGlobalConfig(config: *Config, key: []const u8, value: []const u8) !void {
    if (std.mem.eql(u8, key, "output_dir")) {
        // 注意：这里简化处理，实际使用中可能需要复制字符串
    } else if (std.mem.eql(u8, key, "default_timeout_ms")) {
        config.global.default_timeout_ms = std.fmt.parseInt(u32, value, 10) catch 30000;
    }
    // 其他全局配置项...
}

// 设置语言配置
fn setLangConfig(allocator: std.mem.Allocator, config: *Config, lang_name: []const u8, key: []const u8, value: []const u8) !void {
    var lang_config = config.languages.get(lang_name).?;
    
    if (std.mem.eql(u8, key, "name")) {
        lang_config.name = try allocator.dupe(u8, value);
    } else if (std.mem.eql(u8, key, "src_template")) {
        lang_config.src_template = try allocator.dupe(u8, value);
    } else if (std.mem.eql(u8, key, "compile_cmd")) {
        if (value.len == 0) {
            lang_config.compile_cmd = null;
        } else {
            lang_config.compile_cmd = try allocator.dupe(u8, value);
        }
    } else if (std.mem.eql(u8, key, "execute_cmd")) {
        lang_config.execute_cmd = try allocator.dupe(u8, value);
    } else if (std.mem.eql(u8, key, "enabled")) {
        lang_config.enabled = std.mem.eql(u8, value, "true");
    }
    
    try config.languages.put(lang_name, lang_config);
}

// 设置测试用例配置
fn setCaseConfig(allocator: std.mem.Allocator, config: *Config, case_name: []const u8, key: []const u8, value: []const u8) !void {
    var case_config = config.test_cases.get(case_name).?;
    
    if (std.mem.eql(u8, key, "name")) {
        case_config.name = try allocator.dupe(u8, value);
    } else if (std.mem.eql(u8, key, "description")) {
        case_config.description = try allocator.dupe(u8, value);
    } else if (std.mem.eql(u8, key, "args")) {
        case_config.args = try allocator.dupe(u8, value);
    } else if (std.mem.eql(u8, key, "args_quick")) {
        case_config.args_quick = try allocator.dupe(u8, value);
    } else if (std.mem.eql(u8, key, "timeout_ms")) {
        case_config.timeout_ms = std.fmt.parseInt(u32, value, 10) catch 30000;
    } else if (std.mem.eql(u8, key, "enabled")) {
        case_config.enabled = std.mem.eql(u8, value, "true");
    }
    
    try config.test_cases.put(case_name, case_config);
}

// 字符串模板替换函数
fn replaceTemplate(allocator: std.mem.Allocator, template: []const u8, case_name: []const u8) ![]u8 {
    var result = try allocator.dupe(u8, template);
    
    // 替换 {case}
    while (std.mem.indexOf(u8, result, "{case}")) |pos| {
        const new_result = try std.fmt.allocPrint(allocator, "{s}{s}{s}", .{
            result[0..pos],
            case_name,
            result[pos + 6 ..],
        });
        result = new_result;
    }
    
    return result;
}

// 运行命令并计时
fn runCommand(allocator: std.mem.Allocator, command: []const u8) !TestResult {
    var result = TestResult{
        .language = "",
        .case = "",
        .time_ms = 0,
        .success = false,
        .error_msg = "",
    };

    if (command.len == 0) {
        result.success = true;
        return result;
    }

    var process = std.process.Child.init(&[_][]const u8{ "sh", "-c", command }, allocator);
    process.stdout_behavior = .Pipe;
    process.stderr_behavior = .Pipe;

    const start_time = std.time.milliTimestamp();

    process.spawn() catch |err| {
        result.error_msg = try std.fmt.allocPrint(allocator, "Failed to spawn: {}", .{err});
        return result;
    };

    const stdout = process.stdout.?.readToEndAlloc(allocator, 1024 * 1024) catch |err| {
        result.error_msg = try std.fmt.allocPrint(allocator, "Failed to read stdout: {}", .{err});
        return result;
    };
    const stderr = process.stderr.?.readToEndAlloc(allocator, 1024 * 1024) catch |err| {
        result.error_msg = try std.fmt.allocPrint(allocator, "Failed to read stderr: {}", .{err});
        return result;
    };

    const term = process.wait() catch |err| {
        result.error_msg = try std.fmt.allocPrint(allocator, "Failed to wait: {}", .{err});
        return result;
    };

    const end_time = std.time.milliTimestamp();
    result.time_ms = @intCast(end_time - start_time);

    if (term != .Exited or term.Exited != 0) {
        result.error_msg = try std.fmt.allocPrint(allocator, "Command {s} failed with exit code: {}, stderr: {s}", .{ command, if (term == .Exited) term.Exited else 255, stderr });
        return result;
    }

    // 尝试从输出中解析时间信息
    const output = if (stdout.len > 0) stdout else stderr;
    var lines = std.mem.splitSequence(u8, output, "\n");
    
    while (lines.next()) |line| {
        const trimmed = std.mem.trim(u8, line, " \r\n\t");
        if (std.mem.indexOf(u8, trimmed, "Time: ")) |time_start| {
            const time_str_start = time_start + 6;
            if (std.mem.indexOf(u8, trimmed[time_str_start..], "ms")) |ms_pos| {
                const time_str = trimmed[time_str_start .. time_str_start + ms_pos];
                result.time_ms = std.fmt.parseInt(u32, time_str, 10) catch result.time_ms;
                break;
            }
        }
    }

    result.success = true;
    return result;
}

// 编译指定语言的测试用例
fn compileCase(allocator: std.mem.Allocator, lang_config: LangConfig, case_name: []const u8) !TestResult {
    if (lang_config.compile_cmd == null) {
        return TestResult{
            .language = lang_config.name,
            .case = case_name,
            .time_ms = 0,
            .success = true,
            .error_msg = "",
        };
    }

    const compile_cmd = try replaceTemplate(allocator, lang_config.compile_cmd.?, case_name);

    return runCommand(allocator, compile_cmd);
}

// 执行测试用例
fn executeCase(allocator: std.mem.Allocator, lang_config: LangConfig, case_config: CaseConfig, use_quick_args: bool) !TestResult {
    const execute_cmd = try replaceTemplate(allocator, lang_config.execute_cmd, case_config.name);

    const args = if (use_quick_args and case_config.args_quick.len > 0) case_config.args_quick else case_config.args;
    const full_cmd = try std.fmt.allocPrint(allocator, "{s} {s}", .{ execute_cmd, args });

    var result = try runCommand(allocator, full_cmd);
    result.language = lang_config.name;
    result.case = case_config.name;
    
    return result;
}

// 输出 CSV 结果
fn outputCsv(allocator: std.mem.Allocator, results: []TestResult) !void {
    const csv_content = blk: {
        var content = try allocator.alloc(u8, 0);
        
        // 添加标题行
        const header = "language,case,time_ms,success,error_msg\n";
        content = try allocator.realloc(content, content.len + header.len);
        @memcpy(content[content.len - header.len ..], header);
        
        // 添加数据行
        for (results) |result| {
            const line = try std.fmt.allocPrint(allocator, "\"{s}\",\"{s}\",{d},{},{s}\n", .{
                result.language,
                result.case,
                result.time_ms,
                result.success,
                if (result.success) "" else result.error_msg,
            });
            
            const old_len = content.len;
            content = try allocator.realloc(content, old_len + line.len);
            @memcpy(content[old_len..], line);
        }
        
        break :blk content;
    };
    
    std.fs.cwd().writeFile(.{ 
        .sub_path = "output/results/bench_result.csv", 
        .data = csv_content 
    }) catch |err| {
        print("Failed to write CSV file: {}\n", .{err});
        return;
    };
    
    print("✅ CSV结果已保存到 output/results/bench_result.csv\n", .{});
}

// 输出 JSON 结果
fn outputJson(allocator: std.mem.Allocator, results: []TestResult) !void {
    const timestamp = std.time.timestamp();
    
    var json_content = try std.fmt.allocPrint(allocator, 
        \\{{
        \\  "timestamp": "{d}",
        \\  "results": [
        , .{timestamp});
    
    for (results, 0..) |result, i| {
        const comma = if (i > 0) "," else "";
        const entry = try std.fmt.allocPrint(allocator, 
            \\{s}
            \\    {{
            \\      "language": "{s}",
            \\      "case": "{s}",
            \\      "time_ms": {d},
            \\      "success": {}
            \\    }}
            , .{
                comma,
                result.language,
                result.case,
                result.time_ms,
                result.success,
            });
        
        const old_content = json_content;
        json_content = try std.fmt.allocPrint(allocator, "{s}{s}", .{ old_content, entry });
    }
    
    const final_content = try std.fmt.allocPrint(allocator, 
        \\{s}
        \\  ]
        \\}}
        \\
        , .{json_content});
    
    std.fs.cwd().writeFile(.{ 
        .sub_path = "output/results/bench_result.json", 
        .data = final_content 
    }) catch |err| {
        print("Failed to write JSON file: {}\n", .{err});
        return;
    };
    
    print("✅ JSON结果已保存到 output/results/bench_result.json\n", .{});
}

// 生成控制台输出内容用于HTML报告
fn generateConsoleOutput(allocator: std.mem.Allocator, results: []TestResult, config: *Config, enabled_langs: u32, enabled_cases: u32, use_quick_args: bool, _: ?[]const u8, selected_case: ?[]const u8) ![]u8 {
    var output = try std.fmt.allocPrint(allocator,
        \\🚀 编程语言性能测试工具 v2.0 (YAML Config){s}
        \\============================================================
        \\
        \\📊 配置信息:
        \\  - {d} 种编程语言
        \\  - {d} 个测试用例
        \\  - {d} 种语言已启用
        \\  - {d} 个测试用例已启用
        \\
        \\============================================================
        \\📊 测试结果汇总 (共 {d} 个结果)
        \\============================================================
        \\
        , .{ if (use_quick_args) " (快速模式)" else "", config.languages.count(), config.test_cases.count(), enabled_langs, enabled_cases, results.len });

    // 为每个测试用例生成排名（应用过滤器）
    var case_iterator = config.test_cases.iterator();
    while (case_iterator.next()) |case_entry| {
        const case_key = case_entry.key_ptr.*;
        const case_config = case_entry.value_ptr.*;
        if (!case_config.enabled) continue;
        
        // 应用用例过滤器
        if (selected_case) |filter_case| {
            if (!std.mem.eql(u8, case_key, filter_case)) continue;
        }

        const case_section = try std.fmt.allocPrint(allocator,
            \\📈 {s} - {s}
            \\------------------------------------------------------------
            \\
            , .{ case_config.name, case_config.description });
        const old_output = output;
        output = try std.fmt.allocPrint(allocator, "{s}{s}", .{ old_output, case_section });

        // 收集该用例的结果并排序
        var case_results: [100]TestResult = undefined;
        var case_count: usize = 0;
        
        for (results) |result| {
            if (std.mem.eql(u8, result.case, case_config.name)) {
                case_results[case_count] = result;
                case_count += 1;
                if (case_count >= 100) break;
            }
        }

        // 按性能排序
        for (0..case_count) |i| {
            for (i + 1..case_count) |j| {
                const should_swap = if (!case_results[i].success and case_results[j].success) 
                    true 
                else if (case_results[i].success and !case_results[j].success) 
                    false 
                else if (case_results[i].success and case_results[j].success) 
                    case_results[i].time_ms > case_results[j].time_ms 
                else 
                    false;

                if (should_swap) {
                    const temp = case_results[i];
                    case_results[i] = case_results[j];
                    case_results[j] = temp;
                }
            }
        }

        // 生成排名输出
        const medals = [_][]const u8{ "🥇", "🥈", "🥉", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "🔟" };
        
        for (case_results[0..case_count], 0..) |result, i| {
            if (result.success) {
                const medal = if (i < medals.len) medals[i] else "📍";
                const rank_line = try std.fmt.allocPrint(allocator, "{s} {s:<25} {d:>6}ms\n", .{ medal, result.language, result.time_ms });
                const old_output2 = output;
                output = try std.fmt.allocPrint(allocator, "{s}{s}", .{ old_output2, rank_line });
            } else {
                const error_line = try std.fmt.allocPrint(allocator, "❌ {s:<25} 测试失败\n", .{result.language});
                const old_output3 = output;
                output = try std.fmt.allocPrint(allocator, "{s}{s}", .{ old_output3, error_line });
            }
        }
        
        const old_output_final = output;
        output = try std.fmt.allocPrint(allocator, "{s}\n", .{old_output_final});
    }

    return output;
}

fn outputHtml(allocator: std.mem.Allocator, results: []TestResult, config: *Config, console_output: []const u8, selected_case: ?[]const u8) !void {
    // 生成 HTML 文件，包含 Vega-Lite 图表
    var html_content = try std.fmt.allocPrint(allocator,
        \\<!DOCTYPE html>
        \\<html>
        \\<head>
        \\    <meta charset="UTF-8">
        \\    <title>编程语言性能测试报告</title>
        \\    <script src="https://cdn.jsdelivr.net/npm/vega@6"></script>
        \\    <script src="https://cdn.jsdelivr.net/npm/vega-lite@6"></script>
        \\    <script src="https://cdn.jsdelivr.net/npm/vega-embed@7"></script>
        \\    <style>
        \\        body {{ font-family: 'Microsoft YaHei', Arial, sans-serif; margin: 20px; }}
        \\        h1 {{ color: #333; text-align: center; }}
        \\        h2 {{ color: #666; border-bottom: 2px solid #ddd; padding-bottom: 10px; }}
        \\        .chart-container {{ width: 100%; height: 500px; margin: 30px 0; page-break-inside: avoid; }}
        \\        .summary {{ background: #f5f5f5; padding: 15px; border-radius: 5px; margin: 20px 0; }}
        \\        .console-output {{ background: #2d2d2d; border-radius: 8px; padding: 20px; margin: 20px 0; overflow-x: auto; }}
        \\        .console-output pre {{ color: #f8f8f2; font-family: 'Consolas', 'Monaco', 'Courier New', monospace; font-size: 12px; line-height: 1.4; margin: 0; white-space: pre-wrap; }}
        \\        @media print {{ 
        \\            .chart-container {{ page-break-inside: avoid; height: 400px; }}
        \\            .console-output {{ background: #f8f8f8; border: 1px solid #ddd; }}
        \\            .console-output pre {{ color: #333; }}
        \\            body {{ print-color-adjust: exact; }}
        \\        }}
        \\    </style>
        \\</head>
        \\<body>
        \\    <h1>🚀 编程语言性能测试报告</h1>
        \\    <div class="summary">
        \\        <p><strong>测试时间:</strong> {d}</p>
        \\        <p><strong>测试语言:</strong> {d} 种</p>
        \\        <p><strong>测试用例:</strong> {d} 个</p>
        \\    </div>
        \\
        , .{ std.time.timestamp(), config.languages.count(), config.test_cases.count() });

    // 为每个测试用例生成图表（应用过滤器）
    var case_iterator = config.test_cases.iterator();
    var chart_index: u32 = 0;
    
    while (case_iterator.next()) |case_entry| {
        const case_key = case_entry.key_ptr.*;
        const case_config = case_entry.value_ptr.*;
        if (!case_config.enabled) continue;
        
        // 应用用例过滤器
        if (selected_case) |filter_case| {
            if (!std.mem.eql(u8, case_key, filter_case)) continue;
        }
        
        // 收集该用例的结果数据
        var case_results: [100]TestResult = undefined;
        var case_count: usize = 0;
        
        for (results) |result| {
            if (std.mem.eql(u8, result.case, case_config.name)) {
                case_results[case_count] = result;
                case_count += 1;
                if (case_count >= 100) break;
            }
        }
        
        // 按性能排序 (成功的结果)
        for (0..case_count) |i| {
            for (i + 1..case_count) |j| {
                const should_swap = if (!case_results[i].success and case_results[j].success) 
                    true 
                else if (case_results[i].success and !case_results[j].success) 
                    false 
                else if (case_results[i].success and case_results[j].success) 
                    case_results[i].time_ms > case_results[j].time_ms 
                else 
                    false;

                if (should_swap) {
                    const temp = case_results[i];
                    case_results[i] = case_results[j];
                    case_results[j] = temp;
                }
            }
        }
        
        // 开始生成 Vega-Lite 图表
        const chart_header = try std.fmt.allocPrint(allocator,
            \\
            \\    <h2>📊 {s} - {s}</h2>
            \\    <div id="chart{d}" class="chart-container"></div>
            \\    <script>
            \\        const spec{d} = {{
            \\            "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
            \\            "description": "{s} 性能测试结果",
            \\            "title": {{
            \\                "text": "{s} - 编程语言性能对比",
            \\                "fontSize": 16,
            \\                "fontWeight": "bold"
            \\            }},
            \\            "width": 800,
            \\            "height": 400,
            \\            "data": {{
            \\                "values": [
            , .{ case_config.name, case_config.description, chart_index, chart_index, case_config.description, case_config.name });
        
        const old_html = html_content;
        html_content = try std.fmt.allocPrint(allocator, "{s}{s}", .{ old_html, chart_header });
        
        // 添加数据点 (对于对数坐标，将0值替换为0.1ms)
        for (case_results[0..case_count], 0..) |result, i| {
            if (!result.success) continue;
            const comma = if (i > 0) "," else "";
            const log_time = if (result.time_ms == 0) 0.1 else @as(f64, @floatFromInt(result.time_ms));
            const data_point = try std.fmt.allocPrint(allocator, 
                \\{s}{{"language": "{s}", "time": {d:.1}, "rank": {d}}}
                , .{ comma, result.language, log_time, i + 1 });
            const old_html2 = html_content;
            html_content = try std.fmt.allocPrint(allocator, "{s}{s}", .{ old_html2, data_point });
        }
        
        // 完成 Vega-Lite 规格
        const chart_spec_end = try std.fmt.allocPrint(allocator,
            \\]
            \\            }},
            \\            "mark": {{
            \\                "type": "bar",
            \\                "color": "#4c78a8",
            \\                "stroke": "#333",
            \\                "strokeWidth": 1,
            \\                "cornerRadius": 3
            \\            }},
            \\            "encoding": {{
            \\                "x": {{
            \\                    "field": "language",
            \\                    "type": "nominal",
            \\                    "title": "编程语言",
            \\                    "sort": {{"field": "time", "order": "ascending"}},
            \\                    "axis": {{
            \\                        "labelAngle": -45,
            \\                        "labelFontSize": 11
            \\                    }}
            \\                }},
            \\                "y": {{
            \\                    "field": "time",
            \\                    "type": "quantitative", 
            \\                    "title": "执行时间 (毫秒) - 对数坐标",
            \\                    "scale": {{"type": "sqrt"}},
            \\                    "axis": {{"labelFontSize": 11, "format": ".0f"}}
            \\                }},
            \\                "color": {{
            \\                    "field": "rank",
            \\                    "type": "ordinal",
            \\                    "scale": {{
            \\                        "range": ["#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", 
            \\                                 "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf",
            \\                                 "#aec7e8", "#ffbb78", "#98df8a", "#ff9896", "#c5b0d5", "#c49c94"]
            \\                    }},
            \\                    "legend": null
            \\                }},
            \\                "tooltip": [
            \\                    {{"field": "language", "type": "nominal", "title": "语言"}},
            \\                    {{"field": "time", "type": "quantitative", "title": "时间(ms)"}},
            \\                    {{"field": "rank", "type": "ordinal", "title": "排名"}}
            \\                ]
            \\            }},
            \\            "config": {{
            \\                "axis": {{
            \\                    "titleFontSize": 12,
            \\                    "titleFontWeight": "bold"
            \\                }},
            \\                "title": {{
            \\                    "anchor": "start",
            \\                    "offset": 20
            \\                }}
            \\            }}
            \\        }};
            \\        
            \\        vegaEmbed('#chart{d}', spec{d}, {{
            \\            "actions": false,
            \\            "renderer": "svg"
            \\        }}).catch(console.error);
            \\    </script>
            \\
            , .{ chart_index, chart_index });
        
        const old_html3 = html_content;
        html_content = try std.fmt.allocPrint(allocator, "{s}{s}", .{ old_html3, chart_spec_end });
        
        chart_index += 1;
    }
    
    // 添加控制台输出部分
    const console_section = try std.fmt.allocPrint(allocator,
        \\
        \\    <h2>📋 控制台输出</h2>
        \\    <div class="console-output">
        \\        <pre>{s}</pre>
        \\    </div>
        \\
        , .{console_output});
    
    const old_html_with_console = html_content;
    html_content = try std.fmt.allocPrint(allocator, "{s}{s}", .{ old_html_with_console, console_section });

    // 完成 HTML 文档
    const html_end = 
        \\</body>
        \\</html>
        \\
        ;
    const final_html = try std.fmt.allocPrint(allocator, "{s}{s}", .{ html_content, html_end });
    
    // 写入 HTML 文件
    std.fs.cwd().writeFile(.{ 
        .sub_path = "output/results/bench_result.html", 
        .data = final_html 
    }) catch |err| {
        print("Failed to write HTML file: {}\n", .{err});
        return;
    };
    
    print("✅ HTML报告已保存到 output/results/bench_result.html\n", .{});
    
}

// 主函数
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();
    const allocator = arena.allocator();

    // 解析命令行参数
    const args = try std.process.argsAlloc(allocator);

    var use_quick_args = false;
    var selected_lang: ?[]const u8 = null;
    var selected_case: ?[]const u8 = null;
    var show_help = false;
    
    var i: usize = 1;
    while (i < args.len) {
        const arg = args[i];
        if (std.mem.eql(u8, arg, "--quick")) {
            use_quick_args = true;
        } else if (std.mem.eql(u8, arg, "--lang")) {
            if (i + 1 < args.len) {
                selected_lang = args[i + 1];
                i += 1; // Skip next argument
            } else {
                print("❌ --lang 选项需要指定语言名称\n", .{});
                print("用法: zig run run_bench.zig -- [--quick] [--lang <语言>] [--case <用例>]\n", .{});
                return;
            }
        } else if (std.mem.eql(u8, arg, "--case")) {
            if (i + 1 < args.len) {
                selected_case = args[i + 1];
                i += 1; // Skip next argument
            } else {
                print("❌ --case 选项需要指定测试用例名称\n", .{});
                print("用法: zig run run_bench.zig -- [--quick] [--lang <语言>] [--case <用例>]\n", .{});
                return;
            }
        } else if (std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h")) {
            show_help = true;
        }
        i += 1;
    }

    // 读取 YAML 配置文件
    if (!show_help) {
        const mode_text = if (use_quick_args) " (快速模式)" else "";
        print("\n🚀 编程语言性能测试工具 v2.0 (YAML Config){s}\n", .{mode_text});
        print("============================================================\n\n", .{});
        print("📖 读取配置文件...\n", .{});
    }
    const config_content = std.fs.cwd().readFileAlloc(allocator, "conf/config.yaml", 1024 * 1024) catch |err| {
        print("❌ 无法读取配置文件 conf/config.yaml: {}\n", .{err});
        return;
    };

    var config = Config.init(allocator);

    parseYaml(allocator, config_content, &config) catch |err| {
        print("❌ 解析配置文件失败: {}\n", .{err});
        return;
    };

    // 如果需要显示帮助信息，在配置加载后显示
    if (show_help) {
        print("🚀 编程语言性能测试工具 v2.0\n\n", .{});
        print("用法: zig run run_bench.zig -- [选项]\n\n", .{});
        print("选项:\n", .{});
        print("  --quick              使用快速模式参数进行测试\n", .{});
        print("  --lang <语言>        只测试指定的编程语言\n", .{});
        print("  --case <用例>        只运行指定的测试用例\n", .{});
        print("  --help, -h          显示此帮助信息\n\n", .{});
        
        // 显示可用的编程语言
        print("可用的编程语言:\n", .{});
        var lang_iterator = config.languages.iterator();
        while (lang_iterator.next()) |entry| {
            const lang_config = entry.value_ptr.*;
            if (lang_config.enabled) {
                print("  {s:<15} - {s}\n", .{ entry.key_ptr.*, lang_config.name });
            }
        }
        print("\n", .{});
        
        // 显示可用的测试用例
        print("可用的测试用例:\n", .{});
        var case_iterator = config.test_cases.iterator();
        while (case_iterator.next()) |entry| {
            const case_config = entry.value_ptr.*;
            if (case_config.enabled) {
                print("  {s:<15} - {s}\n", .{ entry.key_ptr.*, case_config.description });
            }
        }
        print("\n", .{});
        
        print("示例:\n", .{});
        print("  zig run run_bench.zig -- --quick\n", .{});
        print("  zig run run_bench.zig -- --lang rust\n", .{});
        print("  zig run run_bench.zig -- --case fib\n", .{});
        print("  zig run run_bench.zig -- --quick --lang java --case mandelbrot\n\n", .{});
        return;
    }

    // 创建输出目录
    std.fs.cwd().makePath("output/results") catch {};
    std.fs.cwd().makePath("output/executables") catch {};

    print("📊 配置信息:\n", .{});
    print("  - {} 种编程语言\n", .{config.languages.count()});
    print("  - {} 个测试用例\n", .{config.test_cases.count()});
    
    // 显示选择的语言和用例过滤器
    if (selected_lang) |lang| {
        print("  - 指定语言: {s}\n", .{lang});
    }
    if (selected_case) |case| {
        print("  - 指定用例: {s}\n", .{case});
    }
    
    // 统计启用的语言和测试用例数量（考虑过滤器）
    var enabled_langs: u32 = 0;
    var lang_iterator = config.languages.iterator();
    while (lang_iterator.next()) |entry| {
        const lang_key = entry.key_ptr.*;
        const lang_config = entry.value_ptr.*;
        if (!lang_config.enabled) continue;
        
        // 应用语言过滤器
        if (selected_lang) |filter_lang| {
            if (!std.mem.eql(u8, lang_key, filter_lang)) continue;
        }
        
        enabled_langs += 1;
    }
    
    var enabled_cases: u32 = 0;
    var case_iterator = config.test_cases.iterator();
    while (case_iterator.next()) |entry| {
        const case_key = entry.key_ptr.*;
        const case_config = entry.value_ptr.*;
        if (!case_config.enabled) continue;
        
        // 应用用例过滤器
        if (selected_case) |filter_case| {
            if (!std.mem.eql(u8, case_key, filter_case)) continue;
        }
        
        enabled_cases += 1;
    }
    
    print("  - {} 种语言已启用\n", .{enabled_langs});
    print("  - {} 个测试用例已启用\n\n", .{enabled_cases});
    
    // 检查是否有有效的测试组合
    if (enabled_langs == 0) {
        if (selected_lang) |lang| {
            print("❌ 找不到指定的语言: {s}\n", .{lang});
            print("可用的语言: ", .{});
            lang_iterator = config.languages.iterator();
            while (lang_iterator.next()) |entry| {
                if (entry.value_ptr.enabled) {
                    print("{s} ", .{entry.key_ptr.*});
                }
            }
            print("\n", .{});
        } else {
            print("❌ 没有启用的语言\n", .{});
        }
        return;
    }
    
    if (enabled_cases == 0) {
        if (selected_case) |case| {
            print("❌ 找不到指定的测试用例: {s}\n", .{case});
            print("可用的测试用例: ", .{});
            case_iterator = config.test_cases.iterator();
            while (case_iterator.next()) |entry| {
                if (entry.value_ptr.enabled) {
                    print("{s} ", .{entry.key_ptr.*});
                }
            }
            print("\n", .{});
        } else {
            print("❌ 没有启用的测试用例\n", .{});
        }
        return;
    }

    const MAX_RESULTS = 1000;
    var results: [MAX_RESULTS]TestResult = undefined;
    var result_count: usize = 0;

    print("🔧 开始编译和测试...\n", .{});
    
    // 遍历所有启用的语言和测试用例（应用过滤器）
    lang_iterator = config.languages.iterator();
    while (lang_iterator.next()) |lang_entry| {
        const lang_key = lang_entry.key_ptr.*;
        const lang_config = lang_entry.value_ptr.*;
        if (!lang_config.enabled) continue;
        
        // 应用语言过滤器
        if (selected_lang) |filter_lang| {
            if (!std.mem.eql(u8, lang_key, filter_lang)) continue;
        }
        
        case_iterator = config.test_cases.iterator();
        while (case_iterator.next()) |case_entry| {
            const case_key = case_entry.key_ptr.*;
            const case_config = case_entry.value_ptr.*;
            if (!case_config.enabled) continue;
            if (result_count >= MAX_RESULTS) break;
            
            // 应用用例过滤器
            if (selected_case) |filter_case| {
                if (!std.mem.eql(u8, case_key, filter_case)) continue;
            }
            
            print("  测试 {s} ({s})... ", .{ lang_config.name, case_config.name });
            
            // 编译阶段
            const compile_result = compileCase(allocator, lang_config, case_config.name) catch |err| {
                print("❌ 编译异常: {}\n", .{err});
                continue;
            };
            
            if (!compile_result.success) {
                print("❌ 编译失败: {s}\n", .{compile_result.error_msg});
                continue;
            }
            
            // 执行阶段
            const test_result = executeCase(allocator, lang_config, case_config, use_quick_args) catch |err| {
                print("❌ 执行异常: {}\n", .{err});
                continue;
            };
            
            if (test_result.success) {
                print("✅ {}ms\n", .{test_result.time_ms});
            } else {
                print("❌ 执行失败\n", .{});
            }
            
            results[result_count] = test_result;
            result_count += 1;
        }
    }

    print("\n============================================================\n", .{});
    print("📊 测试结果汇总 (共 {} 个结果)\n", .{result_count});
    print("============================================================\n\n", .{});

    // 按用例分组显示结果（应用过滤器）
    case_iterator = config.test_cases.iterator();
    while (case_iterator.next()) |case_entry| {
        const case_key = case_entry.key_ptr.*;
        const case_config = case_entry.value_ptr.*;
        if (!case_config.enabled) continue;
        
        // 应用用例过滤器
        if (selected_case) |filter_case| {
            if (!std.mem.eql(u8, case_key, filter_case)) continue;
        }
        
        print("📈 {s} - {s}\n", .{ case_config.name, case_config.description });
        print("------------------------------------------------------------\n", .{});

        // 收集该用例的所有结果
        var case_results: [MAX_RESULTS]TestResult = undefined;
        var case_count: usize = 0;
        
        for (results[0..result_count]) |result| {
            if (std.mem.eql(u8, result.case, case_config.name)) {
                case_results[case_count] = result;
                case_count += 1;
            }
        }

        // 简单排序（成功的结果按时间排序，失败的排在后面）
        for (0..case_count) |sort_i| {
            for (sort_i + 1..case_count) |sort_j| {
                const should_swap = if (!case_results[sort_i].success and case_results[sort_j].success) 
                    true 
                else if (case_results[sort_i].success and !case_results[sort_j].success) 
                    false 
                else if (case_results[sort_i].success and case_results[sort_j].success) 
                    case_results[sort_i].time_ms > case_results[sort_j].time_ms 
                else 
                    false;

                if (should_swap) {
                    const temp = case_results[sort_i];
                    case_results[sort_i] = case_results[sort_j];
                    case_results[sort_j] = temp;
                }
            }
        }

        // 显示排序结果
        const medals = [_][]const u8{ "🥇", "🥈", "🥉", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "🔟" };
        
        for (case_results[0..case_count], 0..) |result, rank_index| {
            if (result.success) {
                const medal = if (rank_index < medals.len) medals[rank_index] else "📍";
                print("{s} {s:<25} {d:>6}ms\n", .{ medal, result.language, result.time_ms });
            } else {
                print("❌ {s:<25} 测试失败\n", .{result.language});
            }
        }
        print("\n", .{});
    }

    // 输出结果文件
    print("💾 保存测试结果...\n", .{});
    
    // 生成控制台输出内容
    const console_output = try generateConsoleOutput(allocator, results[0..result_count], &config, enabled_langs, enabled_cases, use_quick_args, selected_lang, selected_case);
    
    try outputCsv(allocator, results[0..result_count]);
    try outputJson(allocator, results[0..result_count]);
    try outputHtml(allocator, results[0..result_count], &config, console_output, selected_case);

    print("\n🎉 测试完成！\n", .{});
    print("📁 结果文件保存在 output/results/ 目录下\n", .{});
}