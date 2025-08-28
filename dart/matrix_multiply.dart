import 'dart:math';

void matrixMultiply(List<List<int>> a, List<List<int>> b, List<List<int>> c, int size) {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      c[i][j] = 0;
      for (int k = 0; k < size; k++) {
        c[i][j] += a[i][k] * b[k][j];
      }
    }
  }
}

List<List<int>> allocateMatrix(int size) {
  return List.generate(size, (i) => List.filled(size, 0));
}

void initMatrix(List<List<int>> matrix, int size, int seedOffset) {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      matrix[i][j] = (i * 3 + j * 7 + seedOffset) % 100;
    }
  }
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: matrix_multiply <size>');
    return;
  }
  
  final size = int.parse(args[0]);
  
  final a = allocateMatrix(size);
  final b = allocateMatrix(size);
  final c = allocateMatrix(size);
  
  initMatrix(a, size, 0);
  initMatrix(b, size, 1);
  
  final stopwatch = Stopwatch()..start();
  matrixMultiply(a, b, c, size);
  stopwatch.stop();
  
  // Calculate checksum to verify correctness
  int checksum = 0;
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      checksum += c[i][j];
    }
  }
  
  print('Dart: matrix_multiply($size) = $checksum');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');
}