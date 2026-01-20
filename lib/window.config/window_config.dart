import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:share_app/window.config/window_event.dart';
import 'package:window_manager/window_manager.dart';

const _windowWidth = 300.0;
const _windowHeight = 150.0;
const _windowTitle = 'Share App';

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
        title: _windowTitle,
        size: ui.Size(_windowWidth, _windowHeight),
        minimumSize: ui.Size(_windowWidth, _windowHeight),
        backgroundColor: Colors.transparent,
        titleBarStyle: TitleBarStyle.hidden,
        skipTaskbar: true,
      );
}
