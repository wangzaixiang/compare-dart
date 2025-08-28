public class mandelbrot {
    
    public static int mandelbrot(double x0, double y0, int maxIter) {
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
    
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: mandelbrot <size>");
            return;
        }
        
        int size = Integer.parseInt(args[0]);
        int maxIter = 100;
        
        long start = System.currentTimeMillis();
        
        int count = 0;
        for (int py = 0; py < size; py++) {
            for (int px = 0; px < size; px++) {
                double x0 = (px - size/2.0) * 3.0 / size;
                double y0 = (py - size/2.0) * 3.0 / size;
                int iter = mandelbrot(x0, y0, maxIter);
                if (iter < maxIter) count++;
            }
        }
        
        long end = System.currentTimeMillis();
        long timeMs = end - start;
        
        System.out.println("Java: mandelbrot(" + size + ") = " + count);
        System.out.println("Time: " + timeMs + "ms");
    }
}