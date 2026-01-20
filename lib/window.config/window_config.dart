import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:share_app/window.config/window_event.dart';
import 'package:window_manager/window_manager.dart';

class WindowConfig {
  Future<void> config() async {
    await windowManager.ensureInitialized();
    await windowManager.setPreventClose(true);
    await windowManager.setMaximizable(false);
    await windowManager.setMinimizable(false);

    windowManager.addListener(WindowEvent());

    await windowManager.waitUntilReadyToShow(_windowOptions(), () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  WindowOptions _windowOptions() => const WindowOptions(
        center: true,
        title: 'Share App',
        size: ui.Size(550, 700),
        minimumSize: ui.Size(550, 700),
        backgroundColor: Colors.transparent,
        titleBarStyle: TitleBarStyle.hidden,
        skipTaskbar: true,
      );
}
