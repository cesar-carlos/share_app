// import 'dart:io';

import 'package:flutter/material.dart';

import 'package:share_app/page/home_page.dart';
// import 'package:share_app/service/args_decode.dart';
// import 'package:share_app/service/process_info.dart';
// import 'package:share_app/service/share_file.service.dart';
import 'package:share_app/window.config/window_config.dart';

//import 'model/demo_args.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final String stringArgs = args.join('');
  //final String stringArgs = DemoArgs.args;

  // final processInfo = await ProcessInfo.windowsVersion();
  // final isWindows11 = processInfo.contains('Windows 111');

  // if (isWindows11) {
  //   final shareFiles = ArgsDecode.exec(stringArgs);
  //   await ShareFileService.shareFiles(shareFiles);
  //   await Future.delayed(const Duration(seconds: 20), () => exit(0));
  // }

  await WindowConfig().config();
  runApp(MyApp(stringArgs));
}

class MyApp extends StatelessWidget {
  final String args;

  const MyApp(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Share App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: HomePage(arguments: args),
    );
  }
}
