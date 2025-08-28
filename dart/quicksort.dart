import 'dart:math';

void quicksort(List<int> arr, int low, int high) {
  if (low < high) {
    int pi = partition(arr, low, high);
    quicksort(arr, low, pi - 1);
    quicksort(arr, pi + 1, high);
  }
}

int partition(List<int> arr, int low, int high) {
  int pivot = arr[high];
  int i = low - 1;
  
  for (int j = low; j <= high - 1; j++) {
    if (arr[j] < pivot) {
      i++;
      int temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
    }
  }
  int temp = arr[i + 1];
  arr[i + 1] = arr[high];
  arr[high] = temp;
  return i + 1;
}

List<int> generateArray(int n) {
  final random = Random(42);
  return List.generate(n, (index) => random.nextInt(10000));
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: quicksort <n>');
    return;
  }
  
  final n = int.parse(args[0]);
  final arr = generateArray(n);
  
  final stopwatch = Stopwatch()..start();
  quicksort(arr, 0, n - 1);
  stopwatch.stop();
  
  print('Dart: quicksort($n) = sorted');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');
}