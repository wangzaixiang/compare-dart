int primeSieve(int n) {
  List<bool> isPrime = List.filled(n + 1, true);
  isPrime[0] = isPrime[1] = false;
  
  for (int i = 2; i * i <= n; i++) {
    if (isPrime[i]) {
      for (int j = i * i; j <= n; j += i) {
        isPrime[j] = false;
      }
    }
  }
  
  int count = 0;
  for (int i = 2; i <= n; i++) {
    if (isPrime[i]) count++;
  }
  
  return count;
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: prime_sieve <n>');
    return;
  }
  
  final n = int.parse(args[0]);
  
  final stopwatch = Stopwatch()..start();
  final count = primeSieve(n);
  stopwatch.stop();
  
  print('Dart: prime_sieve($n) = $count');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');
}