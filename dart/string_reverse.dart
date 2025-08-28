String reverseString(String str) {
  List<String> chars = str.split('');
  int start = 0;
  int end = chars.length - 1;
  
  while (start < end) {
    String temp = chars[start];
    chars[start] = chars[end];
    chars[end] = temp;
    start++;
    end--;
  }
  
  return chars.join('');
}

String generateString(int len) {
  StringBuffer sb = StringBuffer();
  for (int i = 0; i < len; i++) {
    sb.write(String.fromCharCode(65 + (i % 26))); // 'A' + (i % 26)
  }
  return sb.toString();
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: string_reverse <length>');
    return;
  }
  
  final len = int.parse(args[0]);
  final str = generateString(len);
  
  final stopwatch = Stopwatch()..start();
  final reversed = reverseString(str);
  stopwatch.stop();
  
  // Calculate checksum to verify correctness
  int checksum = 0;
  for (int i = 0; i < reversed.length; i++) {
    checksum += reversed.codeUnitAt(i);
  }
  
  print('Dart: string_reverse($len) = $checksum');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');
}