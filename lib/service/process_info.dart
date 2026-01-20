import 'package:process_run/shell.dart';

class ProcessInfo {
  static Future<void> killProcess(String processName) async {
    final Shell shell = Shell();

    try {
      final result = await shell.run(
        'tasklist /FI "IMAGENAME eq $processName" /FO CSV',
      );

      final lines = result.outLines;

      if (lines.length <= 1) {
        return;
      }

      for (final line in lines.skip(1)) {
        final columns = line.split(',');
        final pid = columns[1].replaceAll('"', '');

        await shell.run('taskkill /PID $pid /F');
      }
    } catch (e) {
      // Silently ignore errors
    }
  }

  static Future<String> windowsVersion() async {
    final Shell shell = Shell();

    final result = await shell.run('systeminfo');

    final osVersionLine = result.outLines.firstWhere(
      (line) => line.startsWith('Nome do sistema operacional'),
      orElse: () => 'OS Version not found',
    );

    return osVersionLine;
  }
}
