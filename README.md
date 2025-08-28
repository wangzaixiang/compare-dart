# 🚀 编程语言性能测试工具

## 项目概述

通用的编程语言性能测试框架，支持多种编程语言和测试用例的自动化性能对比。本项目提供完整的测试工具链，包括自动化测试执行、多格式结果输出和可视化报告生成。

## ✨ 主要特性

### 🎯 核心功能
- **自动化测试**: 一键运行所有语言和测试用例
- **智能编译**: 自动处理不同语言的编译和执行
- **性能排名**: 实时显示性能排名和统计信息
- **多格式输出**: 支持 CSV、JSON、HTML、PDF 等格式

### 📊 可视化报告
- **交互式图表**: 基于 Vega-Lite 的专业数据可视化
- **对数坐标轴**: 清晰展示大跨度性能差异
- **完整报告**: 包含图表、排名和控制台输出
- **PDF 导出**: 一键生成专业性能测试报告

### ⚡ 快速模式
- **参数化测试**: 支持 `--quick` 模式快速验证
- **灵活配置**: 通过 YAML 配置文件自定义测试参数
- **内存优化**: 使用 ArenaAllocator 确保高效内存管理

## 🔧 支持的编程语言

### 编译型语言
- **C**: GCC 和 Clang 编译器
- **Rust**: 高性能系统编程语言
- **Zig**: 现代系统编程语言
- **Go**: Google 开发的并发编程语言
- **Swift**: Apple 开发的现代编程语言

### Java 生态
- **Java (JVM)**: 传统 Java 虚拟机
- **Java (GraalVM)**: 高性能 Native Image

### Dart 生态
- **Dart (AOT)**: 预编译模式
- **Dart (JIT)**: 即时编译模式

### JavaScript 运行时
- **Node.js**: 传统 JavaScript 运行时
- **Bun**: 高性能 JavaScript 运行时

### Python 生态
- **Python (CPython)**: 标准 Python 解释器
- **Python (PyPy)**: JIT 编译版本

### Lua 生态
- **Lua**: 标准 Lua 解释器
- **Lua (LuaJIT)**: JIT 编译版本

## 📋 测试用例

### 算法测试套件

#### fib - 斐波那契递归算法
- **标准模式**: fib(42) - 高计算强度递归测试
- **快速模式**: fib(38) - 快速验证模式
- **测试重点**: CPU 计算性能、递归调用开销

#### bubble_sort - 冒泡排序算法
- **标准模式**: 35,000 个随机整数排序
- **快速模式**: 8,000 个随机整数排序
- **测试重点**: O(n²) 算法性能、内存访问模式

#### prime_sieve - 埃拉托斯特尼筛法
- **标准模式**: 筛选到 200,000,000
- **快速模式**: 筛选到 20,000,000
- **测试重点**: 内存密集型算法、布尔数组操作

#### quicksort - 快速排序
- **标准模式**: 4,000,000 个随机整数
- **快速模式**: 800,000 个随机整数
- **测试重点**: 分治算法、递归性能

#### matrix_multiply - 矩阵乘法
- **标准模式**: 600x600 矩阵相乘
- **快速模式**: 200x200 矩阵相乘
- **测试重点**: 三重嵌套循环、缓存友好性

#### mandelbrot - 曼德布洛特集合
- **标准模式**: 2000 次迭代
- **快速模式**: 500 次迭代
- **测试重点**: 浮点计算密集型任务

#### binary_tree_traverse - 二叉树遍历
- **标准模式**: 深度 21 的完全二叉树
- **快速模式**: 深度 17 的完全二叉树
- **测试重点**: 递归遍历、指针操作

#### counting_sort - 计数排序
- **标准模式**: 200,000,000 个元素
- **快速模式**: 20,000,000 个元素
- **测试重点**: 线性时间算法、数组索引

#### string_reverse - 字符串反转
- **标准模式**: 2,000,000,000 字符
- **快速模式**: 100,000,000 字符
- **测试重点**: 双指针技术、内存操作

#### hanoi_tower - 汉诺塔
- **标准模式**: 28 个盘子
- **快速模式**: 24 个盘子
- **测试重点**: 指数级递归、栈深度

## 🛠️ 安装和使用

### 前置要求
- **Zig 编译器**: 运行测试工具的核心依赖
- **各语言编译器/运行时**: 根据需要安装对应语言环境

### 基础使用

```bash
# 运行完整测试套件
zig run run_bench.zig

# 快速模式测试 (推荐用于快速验证)
zig run run_bench.zig -- --quick

# 只测试指定编程语言
zig run run_bench.zig -- --lang rust

# 只运行指定测试用例
zig run run_bench.zig -- --case fib

# 组合使用多个选项
zig run run_bench.zig -- --quick --lang java --case mandelbrot

# 显示帮助信息
zig run run_bench.zig -- --help
```

### 命令行选项

| 选项 | 说明 | 示例 |
|------|------|------|
| `--quick` | 使用快速模式参数进行测试 | `zig run run_bench.zig -- --quick` |
| `--lang <语言>` | 只测试指定的编程语言 | `zig run run_bench.zig -- --lang rust` |
| `--case <用例>` | 只运行指定的测试用例 | `zig run run_bench.zig -- --case fib` |
| `--help, -h` | 显示帮助信息 | `zig run run_bench.zig -- --help` |

### 高级用法示例

```bash
# 快速验证 Rust 语言的斐波那契算法性能
zig run run_bench.zig -- --quick --lang rust --case fib

# 对比多种语言的排序算法性能 (只运行快速排序用例)
zig run run_bench.zig -- --case quicksort

# 测试特定语言的所有算法 (使用快速模式)
zig run run_bench.zig -- --quick --lang go

# 单独测试矩阵乘法的性能对比
zig run run_bench.zig -- --case matrix_multiply
```

### 结果输出

程序会在 `output/results/` 目录生成以下文件：

- **bench_result.csv**: 原始数据，适合进一步分析
- **bench_result.json**: 结构化数据，便于程序处理
- **bench_result.html**: 包含 Vega-Lite 图表的可视化报告
- **bench_result.pdf**: 专业的 PDF 测试报告（需要 Chrome）

## 🎨 可视化特性

### Vega-Lite 图表
- **对数坐标轴**: 清晰展示大跨度性能数据
- **交互式提示**: 鼠标悬停显示详细信息
- **自动排序**: 按性能自动排序显示
- **颜色编码**: 基于排名的视觉区分

### HTML 报告内容
1. **📊 测试概览**: 测试时间、语言数量、用例统计
2. **📈 性能图表**: 每个测试用例的 Bar Chart 对比
3. **📋 控制台输出**: 完整的排名表格和详细信息

## ⚙️ 配置文件

项目使用 `conf/config.yaml` 进行配置：

```yaml
# 全局配置
global:
  output_dir: "output"
  default_timeout_ms: 30000

# 语言配置示例
languages:
  gcc:
    name: "C(GCC)"
    src_template: "c/{case}.c"
    compile_cmd: "gcc -O2 c/{case}.c -o output/executables/{case}_gcc"
    execute_cmd: "output/executables/{case}_gcc"
    enabled: true

# 测试用例配置
test_cases:
  fib:
    name: "fib"
    description: "Fibonacci 43 (递归算法)"
    args_quick: 40      # 快速模式参数
    args: 43           # 标准模式参数
    timeout_ms: 60000
    enabled: true
```

## 📦 可选依赖

### PDF 生成支持
为了生成 PDF 报告，需要安装以下工具之一：

```bash
# macOS - 使用 Chrome (推荐)
# Chrome 自动检测路径: /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

# 或安装其他 PDF 转换工具
brew install wkhtmltopdf  # 已停止维护
```

### GraalVM Native Image
测试 Java GraalVM Native Image 性能：

```bash
# macOS (使用 Homebrew)
brew install --cask graalvm/tap/graalvm-jdk17

# 设置环境变量
export PATH="/Library/Java/JavaVirtualMachines/graalvm-jdk-17/Contents/Home/bin:$PATH"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/graalvm-jdk-17/Contents/Home"

# 安装 native-image 工具
gu install native-image
```

## 📈 最新性能测试结果

基于优化后的测试参数，以下是各语言在主要测试用例中的性能表现：

### fib - Fibonacci 递归算法 (fib(42))

| 排名  | 编程语言                | 执行时间    | 相对倍数  |
|-----|---------------------|---------|-------|
| 🥇  | C(Clang)            | 983ms   | 1.0x  |
| 🥈  | C(GCC)              | 986ms   | 1.0x  |
| 🥉  | Go                  | 1071ms  | 1.1x  |
| 4️⃣ | Java(GraalVM)       | 1227ms  | 1.2x  |
| 5️⃣ | JavaScript(Node.js) | 3054ms  | 3.1x  |
| 📍  | Python(CPython)     | 46389ms | 47.2x |

### prime_sieve - 埃拉托斯特尼筛法 (200M)

| 排名  | 编程语言                | 执行时间    | 相对倍数  |
|-----|---------------------|---------|-------|
| 🥇  | Go                  | 917ms   | 1.0x  |
| 🥈  | C(GCC)              | 1179ms  | 1.3x  |
| 🥉  | C(Clang)            | 1186ms  | 1.3x  |
| 4️⃣ | Java(GraalVM)       | 1347ms  | 1.5x  |
| 📍  | Python(CPython)     | 34732ms | 37.9x |

### quicksort - 快速排序 (4M 元素)

| 排名  | 编程语言                | 执行时间    | 相对倍数  |
|-----|---------------------|---------|-------|
| 🥇  | C(GCC)              | 524ms   | 1.0x  |
| 🥈  | C(Clang)            | 524ms   | 1.0x  |
| 🥉  | Go                  | 711ms   | 1.4x  |
| 4️⃣ | Java(GraalVM)       | 1004ms  | 1.9x  |
| 5️⃣ | JavaScript(Node.js) | 1207ms  | 2.3x  |
| 📍  | Python(CPython)     | 33254ms | 63.5x |

### bubble_sort - 冒泡排序 (35K 元素)

| 排名  | 编程语言                | 执行时间    | 相对倍数  |
|-----|---------------------|---------|-------|
| 🥇  | C(GCC)              | 1172ms  | 1.0x  |
| 🥈  | Go                  | 1175ms  | 1.0x  |
| 🥉  | C(Clang)            | 1177ms  | 1.0x  |
| 4️⃣ | Java(GraalVM)       | 1229ms  | 1.0x  |
| 5️⃣ | JavaScript(Node.js) | 2624ms  | 2.2x  |
| 📍  | Python(CPython)     | 28988ms | 24.7x |

### matrix_multiply - 矩阵乘法 (600x600)

| 排名  | 编程语言                | 执行时间    | 相对倍数   |
|-----|---------------------|---------|--------|
| 🥇  | C(GCC)              | 211ms   | 1.0x   |
| 🥈  | C(Clang)            | 211ms   | 1.0x   |
| 🥉  | Java(GraalVM)       | 218ms   | 1.0x   |
| 4️⃣ | Go                  | 717ms   | 3.4x   |
| 5️⃣ | JavaScript(Node.js) | 801ms   | 3.8x   |
| 📍  | Python(CPython)     | 21206ms | 100.5x |

## 🔍 性能分析

### 关键观察
- **C 语言统治地位**: GCC 和 Clang 编译的 C 代码在多数测试中表现最佳
- **Go 的均衡表现**: 在内存密集型算法(prime_sieve)中表现优异，整体性能稳定
- **Java GraalVM 优势**: 相比传统 JVM，在多种算法中都显示出良好的 AOT 编译优化效果
- **JavaScript 的局限性**: Node.js 在计算密集型任务中性能相对较弱，部分测试因内存限制失败
- **Python 性能差距**: CPython 在所有测试中都显示出显著的性能劣势，比最快语言慢 20-100 倍

### 测试参数优化效果
经过参数调整，现在各测试用例的执行时间更加合理：
- **正式模式**: 500-2000ms，适合全面性能对比
- **快速模式**: 10-100ms，适合快速验证和调试
- **内存优化**: 避免了 JavaScript 等语言的内存溢出问题

## 🚀 技术架构

### 核心组件
- **YAML 配置解析器**: 灵活的测试配置管理
- **多语言执行引擎**: 统一的编译和执行接口
- **结果收集和排序**: 智能的性能数据处理
- **多格式输出**: CSV/JSON/HTML/PDF 全格式支持

### 内存管理
- **ArenaAllocator**: 集中内存管理，避免内存泄漏
- **零拷贝设计**: 高效的字符串处理和数据传递

### 可视化技术
- **Vega-Lite**: 声明式数据可视化
- **对数坐标**: 适应大跨度性能数据
- **SVG 渲染**: 高质量矢量图形输出

## 📄 许可证

本项目采用开源许可证，欢迎贡献和改进。

## 🤝 贡献指南

欢迎提交 Pull Request 来添加新的编程语言、测试用例或功能改进！

---

> **注意**: 性能测试结果可能因硬件配置、系统环境和编译器版本而有所差异。建议在相同环境下进行对比测试以获得准确结果。