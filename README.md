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

### fib - 斐波那契递归算法
- **标准模式**: fib(43) - 高计算强度递归测试
- **快速模式**: fib(40) - 快速验证模式
- **测试重点**: CPU 计算性能、递归调用开销

### bubble_sort - 冒泡排序算法
- **标准模式**: 40,000 个随机整数排序
- **快速模式**: 1,000 个随机整数排序
- **测试重点**: 循环性能、内存访问效率

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

### fib(40) 快速模式结果

| 排名  | 编程语言                | 执行时间    | 相对倍数  |
|-----|---------------------|---------|-------|
| 🥇  | Java(JVM)           | 1359ms  | 1.0x  |
| 🥈  | C(GCC)              | 1586ms  | 1.2x  |
| 🥉  | Zig                 | 1590ms  | 1.2x  |
| 4️⃣ | C(Clang)            | 1593ms  | 1.2x  |
| 5️⃣ | Rust                | 1594ms  | 1.2x  |
| 6️⃣ | Go                  | 1731ms  | 1.3x  |
| 7️⃣ | Java(GraalVM)       | 1996ms  | 1.5x  |
| 8️⃣ | Swift               | 2001ms  | 1.5x  |
| 9️⃣ | JavaScript(Bun)     | 2548ms  | 1.9x  |
| 🔟  | Dart(AOT)           | 2798ms  | 2.1x  |
| 📍  | Lua(LuaJIT)         | 4098ms  | 3.0x  |
| 📍  | JavaScript(Node.js) | 4955ms  | 3.6x  |
| 📍  | Python(PyPy)        | 5685ms  | 4.2x  |
| 📍  | Dart(JIT)           | 6749ms  | 5.0x  |
| 📍  | Lua                 | 43250ms | 31.8x |
| 📍  | Python(CPython)     | 74740ms | 55.0x |

### bubble_sort(1000) 快速模式结果

| 排名  | 编程语言                | 执行时间    | 相对倍数  |
|-----|---------------------|---------|-------|
| 🥇  | C(GCC)              | 1523ms  | 1.0x  |
| 🥈  | C(Clang)            | 1550ms  | 1.0x  |
| 🥉  | Zig                 | 1626ms  | 1.1x  |
| 4️⃣ | Go                  | 1917ms  | 1.3x  |
| 5️⃣ | Java(JVM)           | 1967ms  | 1.3x  |
| 6️⃣ | Rust                | 2192ms  | 1.4x  |
| 7️⃣ | Java(GraalVM)       | 2291ms  | 1.5x  |
| 8️⃣ | Swift               | 2331ms  | 1.5x  |
| 9️⃣ | Dart(JIT)           | 2683ms  | 1.8x  |
| 🔟  | Dart(AOT)           | 3111ms  | 2.0x  |
| 📍  | Lua(LuaJIT)         | 3120ms  | 2.0x  |
| 📍  | JavaScript(Bun)     | 3707ms  | 2.4x  |
| 📍  | Python(PyPy)        | 3869ms  | 2.5x  |
| 📍  | JavaScript(Node.js) | 6012ms  | 3.9x  |
| 📍  | Lua                 | 24891ms | 16.3x |
| 📍  | Python(CPython)     | 70675ms | 46.4x |

## 🔍 性能分析

### 关键观察
- **Java JVM 优势**: JIT 编译优化使其在递归测试中表现优异
- **系统级语言集团**: C、Zig、Rust 性能极其接近
- **Go 平衡性**: 在垃圾回收语言中表现出色
- **JavaScript 运行时差异**: Bun 显著优于 Node.js
- **JIT vs 解释**: LuaJIT 和 PyPy 相比解释版本有显著提升

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