public class string_reverse {
    
    public static String reverseString(String str) {
        char[] chars = str.toCharArray();
        int start = 0;
        int end = chars.length - 1;
        
        while (start < end) {
            char temp = chars[start];
            chars[start] = chars[end];
            chars[end] = temp;
            start++;
            end--;
        }
        
        return new String(chars);
    }
    
    public static String generateString(int len) {
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            sb.append((char)('A' + (i % 26)));
        }
        return sb.toString();
    }
    
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: string_reverse <length>");
            return;
        }
        
        int len = Integer.parseInt(args[0]);
        String str = generateString(len);
        
        long start = System.currentTimeMillis();
        String reversed = reverseString(str);
        long end = System.currentTimeMillis();
        
        // Calculate checksum to verify correctness
        long checksum = 0;
        for (int i = 0; i < reversed.length(); i++) {
            checksum += reversed.charAt(i);
        }
        
        long timeMs = end - start;
        
        System.out.println("Java: string_reverse(" + len + ") = " + checksum);
        System.out.println("Time: " + timeMs + "ms");
    }
}