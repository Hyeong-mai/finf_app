class TimeFormatter {
  static String formatSeconds(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes분$remainingSeconds초';
  }

  static String formatMilliseconds(int milliseconds) {
    final seconds = milliseconds ~/ 1000;
    return formatSeconds(seconds);
  }
}
