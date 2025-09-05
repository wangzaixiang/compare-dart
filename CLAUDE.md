# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This is a comprehensive multi-language performance benchmarking framework that compares execution performance across 17+ programming languages including C, Java, Rust, Go, Swift, Dart, JavaScript (Node.js/Bun/QuickJS), Python, Lua, and Zig through standardized algorithm implementations and automated testing workflows.

## Architecture Overview
The system uses a **centralized orchestration pattern** with three main layers:

1. **Configuration Layer** (`conf/config.yaml`) - YAML-based configuration defining language toolchains, compilation commands, and test cases
2. **Orchestration Layer** (`run_bench.zig`) - Zig-based test runner that handles configuration parsing, compilation, execution, and results aggregation  
3. **Implementation Layer** - Language-specific directories with parallel implementations of identical algorithms

## Core Commands

### Building and Running
```bash
# Run all enabled tests
zig run ./run_bench.zig

# Run tests for specific language
zig run ./run_bench.zig --lang rust

# Run specific test case across all languages
zig run ./run_bench.zig --case fib

# Run quick tests (shorter parameters)
zig run ./run_bench.zig --quick
```

### Adding New Languages
1. Create language directory (e.g., `kotlin/`)
2. Implement all algorithm files following naming pattern: `{algorithm}.{extension}`
3. Add language configuration to `conf/config.yaml`:
   ```yaml
   kotlin:
     name: "Kotlin"
     src_template: "kotlin/{case}.kt"
     compile_cmd: "kotlinc kotlin/{case}.kt -include-runtime -d output/executables/{case}.jar"
     execute_cmd: "java -jar output/executables/{case}.jar"
     enabled: true
   ```

### Adding New Test Cases
1. Implement algorithm in all language directories
2. Add test case configuration to `conf/config.yaml`:
   ```yaml
   new_algorithm:
     name: "new_algorithm"
     description: "Algorithm description"
     args_quick: 1000
     args: 10000
     timeout_ms: 30000
     enabled: true
   ```

## Algorithm Implementation Requirements

### Standardized Output Format
All implementations must output exactly:
```
{Language}: {algorithm}({params}) = {result}
Time: {time}ms
```

### Command Line Argument Parsing
Each implementation must:
- Accept algorithm parameters via command line arguments
- Handle invalid/missing arguments gracefully
- Use consistent argument parsing patterns per language

### Cross-Platform Compatibility
- **Node.js/QuickJS**: Use `typeof process !== 'undefined' ? process.argv.slice(2) : scriptArgs.slice(1)` for argument parsing
- **Exit handling**: Use `if (typeof process !== 'undefined') process.exit(1); else throw new Error('message')` for QuickJS compatibility

## Directory Structure
- `c/` - C implementations (GCC/Clang variants)
- `java/` - Java implementations (JVM/GraalVM variants)  
- `rust/` - Rust implementations
- `go/` - Go implementations
- `swift/` - Swift implementations
- `dart/` - Dart implementations (JIT/AOT variants)
- `javascript/` - JavaScript implementations (Node.js/Bun/QuickJS)
- `python/` - Python implementations (CPython/PyPy)
- `lua/` - Lua implementations (Lua/LuaJIT)
- `zig/` - Zig implementations
- `conf/` - Configuration files
- `output/executables/` - Compiled binaries
- `output/results/` - Generated reports (CSV, JSON, HTML, PDF)

## Configuration System
The `conf/config.yaml` file controls:
- **Language toolchains**: Compilation and execution commands
- **Test case parameters**: Arguments and timeouts  
- **Enable/disable flags**: For selective testing
- **Multiple variants**: Support for different compilers/runtimes per language

## Algorithm Test Suite
Current implementations include:
- **fib** - Recursive Fibonacci (tests recursion performance)
- **bubble_sort** - Bubble sort on large arrays (tests loops/array operations)
- **prime_sieve** - Sieve of Eratosthenes (tests mathematical computation)
- **quicksort** - Recursive quicksort (tests divide-and-conquer algorithms)
- **matrix_multiply** - Matrix multiplication (tests numerical computation)
- **binary_tree_traverse** - Tree traversal (tests recursive data structures)
- **counting_sort** - Linear time sorting (tests memory operations)
- **mandelbrot** - Mandelbrot set calculation (tests floating-point computation)
- **hanoi_tower** - Tower of Hanoi (tests exponential recursion)
- **string_reverse** - String manipulation (tests string operations)

## Results and Reporting
The framework generates comprehensive reports in multiple formats:
- **CSV** - Raw data for analysis
- **JSON** - Programmatic access
- **HTML** - Interactive charts and rankings

Reports include performance rankings, relative performance percentages, and success/failure tracking with timeout handling.

## Development Guidelines
When implementing algorithms:
1. **Maintain algorithmic consistency** - All language implementations must use identical logic
2. **Use optimal compiler flags** - Apply maximum optimization (`-O2`, `-O`, `ReleaseFast`)
3. **Handle edge cases** - Implement proper error handling for invalid inputs
4. **Follow naming conventions** - Use `{algorithm}.{extension}` pattern
5. **Test cross-platform** - Ensure compatibility across different systems
6. **Verify output format** - Match exact output specification for parsing

## important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.
use the --quick option for functional test to improve the speed.