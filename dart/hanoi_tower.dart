int moveCount = 0;

void hanoiTower(int n, String from, String to, String aux) {
  if (n == 1) {
    moveCount++;
    return;
  }
  
  hanoiTower(n - 1, from, aux, to);
  moveCount++;
  hanoiTower(n - 1, aux, to, from);
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: hanoi_tower <n>');
    return;
  }
  
  final n = int.parse(args[0]);
  moveCount = 0;
  
  final stopwatch = Stopwatch()..start();
  hanoiTower(n, 'A', 'C', 'B');
  stopwatch.stop();
  
  print('Dart: hanoi_tower($n) = $moveCount');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');
}