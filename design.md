# 编程语言性能测试工具设计文档

## 项目概述
通用的编程语言性能测试框架，支持多种编程语言和测试用例的自动化性能对比。

## 目录结构
```
├── c/                  # C语言实现
├── dart/               # Dart语言实现  
├── go/                 # Go语言实现
├── java/               # Java语言实现
├── javascript/         # JavaScript实现
├── lua/                # Lua实现
├── python/             # Python实现
├── rust/               # Rust实现
├── swift/              # Swift实现
├── zig/                # Zig实现
├── conf/               # 配置文件目录
│   └── config.toml     # 主配置文件
├── output/             # 输出目录
│   ├── executables/    # 编译后的可执行文件
│   └── results/        # 测试结果
│       ├── bench_result.csv
│       ├── bench_result.json
│       └── bench_result.pdf
└── run_bench.zig       # 主测试工具
```

## 配置文件设计 (conf/config.zig)

### Zig 原生配置方案
使用 Zig 源码作为配置文件，提供类型安全和编译时验证：

#### 语言配置示例
```zig
pub const languages = [_]LangConfig{
    .{
        .name = "C(GCC)",
        .src_template = "c/{case}.c",
        .compile_cmd = "gcc -O2 c/{case}.c -o output/executables/{case}_gcc",
        .execute_cmd = "output/executables/{case}_gcc",
    },
    .{
        .name = "Java(JVM)",
        .src_template = "java/{Case}.java",
        .compile_cmd = "javac java/{Case}.java -d output/executables/",
        .execute_cmd = "java -cp output/executables/ {Case}",
    },
    .{
        .name = "Dart(JIT)",
        .src_template = "dart/{case}.dart",
        .compile_cmd = null,  // 无需编译
        .execute_cmd = "dart dart/{case}.dart",
    },
};
```

#### 测试用例配置
```zig
pub const test_cases = [_]CaseConfig{
    .{
        .name = "fib",
        .description = "Fibonacci 43 (递归算法)",
        .args = "43",
        .timeout_ms = 60000,
    },
    .{
        .name = "bubble_sort", 
        .description = "冒泡排序 1,000,000 整数",
        .args = "1000000",
        .timeout_ms = 30000,
    },
};
```

### YAML 配置方案优势
- **极佳可读性**: 缩进结构清晰，支持注释
- **人类友好**: 易于编辑和维护，学习成本低
- **无需编译**: 修改配置即时生效，开发效率高  
- **数据类型丰富**: 支持字符串、数字、布尔值、null 等
- **版本控制友好**: 纯文本格式，便于 diff 和协作

完整配置文件请参考 `conf/config.yaml`。

## 工具功能设计

### run_bench.zig 主要功能
1. **配置解析**: 读取并解析 config.yaml 配置文件
2. **自动编译**: 根据配置自动编译各语言实现
3. **性能测试**: 执行测试用例并收集性能数据
4. **结果输出**: 生成多种格式的测试结果

### 命令行接口
```shell
# 运行所有语言和测试用例
zig run run_bench.zig

# 指定特定语言
zig run run_bench.zig -- --lang=gcc,java,rust

# 指定特定测试用例  
zig run run_bench.zig -- --case=fib,bubble_sort

# 指定运行次数(取平均值)
zig run run_bench.zig -- --runs=3

# 指定输出格式
zig run run_bench.zig -- --output=csv,json,pdf

# 详细输出模式
zig run run_bench.zig -- --verbose
```

## 输出格式设计

### CSV格式 (bench_result.csv)
```csv
language,case,time_ms,memory_kb,success,runs
"C(GCC)","fib",1250,1024,true,3
"Java(JVM)","fib",1890,51200,true,3
"Rust","fib",1240,1024,true,3
```

### JSON格式 (bench_result.json)
```json
{
  "timestamp": "2024-01-01T10:00:00Z",
  "results": [
    {
      "language": "C(GCC)",
      "case": "fib", 
      "time_ms": 1250,
      "success": true
    }
  ]
}
```

## 核心特性

- **配置驱动**: 通过 TOML 配置文件管理所有语言和测试用例
- **自动编译**: 根据配置自动编译各语言实现
- **多格式输出**: 支持 CSV、JSON、PDF 等多种结果格式
- **错误处理**: 编译失败自动跳过，执行超时自动终止
- **统计分析**: 支持多次运行取平均值

## 实现优先级

**Phase 1** (核心功能)
- [x] 基础框架搭建
- [ ] TOML配置文件解析
- [ ] 自动编译和执行
- [ ] CSV结果输出

**Phase 2** (增强功能)  
- [ ] JSON格式输出
- [ ] 多次运行统计
- [ ] 内存监控
- [ ] 命令行参数解析

**Phase 3** (高级功能)
- [ ] 图表生成
- [ ] Web界面
- [ ] CI/CD集成
- [ ] 历史数据对比