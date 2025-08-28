void countingSort(List<int> arr, int n, int maxVal) {
  List<int> count = List.filled(maxVal + 1, 0);
  List<int> output = List.filled(n, 0);
  
  // Count occurrences
  for (int i = 0; i < n; i++) {
    count[arr[i]]++;
  }
  
  // Change count[i] so that it contains position of this character in output array
  for (int i = 1; i <= maxVal; i++) {
    count[i] += count[i - 1];
  }
  
  // Build output array
  for (int i = n - 1; i >= 0; i--) {
    output[count[arr[i]] - 1] = arr[i];
    count[arr[i]]--;
  }
  
  // Copy output array to arr
  for (int i = 0; i < n; i++) {
    arr[i] = output[i];
  }
}

List<int> generateArray(int n, int maxVal) {
  List<int> arr = List.filled(n, 0);
  for (int i = 0; i < n; i++) {
    arr[i] = (i * 7 + i * i * 3) % (maxVal + 1);
  }
  return arr;
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: counting_sort <n>');
    return;
  }
  
  final n = int.parse(args[0]);
  final maxVal = 999;
  final arr = generateArray(n, maxVal);
  
  final stopwatch = Stopwatch()..start();
  countingSort(arr, n, maxVal);
  stopwatch.stop();
  
  // Calculate checksum to verify correctness
  int checksum = 0;
  for (int i = 0; i < n; i++) {
    checksum += arr[i];
  }
  
  print('Dart: counting_sort($n) = $checksum');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');
}