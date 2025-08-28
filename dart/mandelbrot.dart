import 'dart:math';

int mandelbrot(double x0, double y0, int maxIter) {
  double x = 0.0;
  double y = 0.0;
  int iteration = 0;
  
  while (x*x + y*y <= 4.0 && iteration < maxIter) {
    double xtemp = x*x - y*y + x0;
    y = 2*x*y + y0;
    x = xtemp;
    iteration++;
  }
  return iteration;
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: mandelbrot <size>');
    return;
  }
  
  final size = int.parse(args[0]);
  final maxIter = 100;
  
  final stopwatch = Stopwatch()..start();
  
  int count = 0;
  for (int py = 0; py < size; py++) {
    for (int px = 0; px < size; px++) {
      double x0 = (px - size/2.0) * 3.0 / size;
      double y0 = (py - size/2.0) * 3.0 / size;
      int iter = mandelbrot(x0, y0, maxIter);
      if (iter < maxIter) count++;
    }
  }
  
  stopwatch.stop();
  
  print('Dart: mandelbrot($size) = $count');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');
}