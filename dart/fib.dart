int fib(int n) {
  if (n <= 1) return n;
  return fib(n - 1) + fib(n - 2);
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: fib <n>');
    return;
  }
  
  final n = int.parse(args[0]);
  final stopwatch = Stopwatch()..start();
  final result = fib(n);
  stopwatch.stop();
  
  print('Dart: fib($n) = $result');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');
}