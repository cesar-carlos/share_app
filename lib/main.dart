import 'package:flutter/material.dart';

import 'package:share_app/page/home_page.dart';
import 'package:share_app/window.config/window_config.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final String stringArgs = args.join('');

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
