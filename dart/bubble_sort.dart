import 'dart:math';

void bubbleSort(List<int> arr) {
  int n = arr.length;
  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
      if (arr[j] > arr[j + 1]) {
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
    }
  }
}

List<int> generateArray(int n) {
  final random = Random(42); // Fixed seed for reproducible results
  return List.generate(n, (index) => random.nextInt(10000));
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: bubble_sort <n>');
    return;
  }
  
  final n = int.parse(args[0]);
  final arr = generateArray(n);
  
  final stopwatch = Stopwatch()..start();
  bubbleSort(arr);
  stopwatch.stop();
  
  print('Dart: bubble_sort($n) = sorted');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');
}