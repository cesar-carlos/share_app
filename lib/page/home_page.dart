import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:window_manager/window_manager.dart';

import 'package:share_app/model/failures.dart';
import 'package:share_app/model/share_file.dart';
import 'package:share_app/service/args_decode.dart';
import 'package:share_app/service/share_file.service.dart';
import 'package:share_app/widgets/error_modal.dart';

const _backgroundColor = Color.fromARGB(200, 255, 255, 255);
const _autoCloseDelay = Duration(seconds: 30);
const _shareDelay = Duration(milliseconds: 300);
const _borderRadius = 5.0;

class HomePage extends StatefulWidget {
  final String arguments;

  const HomePage({super.key, required this.arguments});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  Result<List<ShareFile>>? _decodeResult;
  final FocusNode focusNode = FocusNode();
  bool _isMonitoringShareDialog = false;
  bool _hasLostFocus = false;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _decodeResult = ArgsDecode.exec(widget.arguments);

    _logDecodeResult();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _decodeResult?.fold(
        (files) {
          onSharePressed(files);
          onAutoClose();
        },
        (error) {
          final failure = error as AppFailure;
          log('Error decoding arguments: ${failure.message}');
          _showError(failure);
        },
      );
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    windowManager.removeListener(this);
    focusNode.dispose();
    super.dispose();
  }

  void _logDecodeResult() {
    _decodeResult?.fold(
      (files) {
        log('Successfully decoded ${files.length} file(s)');
      },
      (error) {
        final failure = error as AppFailure;
        log('Decode failure: ${failure.message}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: (event) => exit(0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          child: GestureDetector(
            onTap: () => exit(0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: _backgroundColor,
              child: Center(
                child: ElevatedButton(
                  onPressed: _decodeResult?.fold(
                    (files) => () => onSharePressed(files),
                    (_) => null,
                  ),
                  child: const Text('Share'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSharePressed(List<ShareFile> files) async {
    await Future.delayed(_shareDelay);

    final result = await ShareFileService.shareFiles(files);

    result.fold(
      (_) {
        log('Successfully shared ${files.length} file(s)');
        _cancelAutoClose();
        _startMonitoringShareDialog();
        focusNode.requestFocus();
      },
      (error) {
        final failure = error as AppFailure;
        log('Share failure: ${failure.message}');
        _showError(failure);
      },
    );
  }

  void _startMonitoringShareDialog() {
    _isMonitoringShareDialog = true;
    _hasLostFocus = false;
  }

  void _stopMonitoringShareDialog() {
    _isMonitoringShareDialog = false;
    _hasLostFocus = false;
  }

  @override
  void onWindowBlur() {
    if (_isMonitoringShareDialog) {
      _hasLostFocus = true;
      log('Window lost focus - share dialog opened');
    }
  }

  @override
  void onWindowFocus() {
    if (_isMonitoringShareDialog && _hasLostFocus) {
      log('Window regained focus - share dialog closed');
      _stopMonitoringShareDialog();
      exit(0);
    }
  }

  @override
  void onWindowClose() async {
    await windowManager.destroy();
  }

  @override
  void onWindowDocked() {}

  @override
  void onWindowEnterFullScreen() {}

  @override
  void onWindowEvent(String eventName) {}

  @override
  void onWindowLeaveFullScreen() {}

  @override
  void onWindowMaximize() {}

  @override
  void onWindowMinimize() {}

  @override
  void onWindowMove() {}

  @override
  void onWindowMoved() {}

  @override
  void onWindowResize() {}

  @override
  void onWindowResized() {}

  @override
  void onWindowRestore() {}

  @override
  void onWindowUndocked() {}

  @override
  void onWindowUnmaximize() {}

  void _showError(AppFailure failure) {
    if (!mounted) return;

    ErrorModal.show(
      context,
      failure,
      onClose: () => onAutoClose(),
    );
  }

  void _startAutoClose() {
    _cancelAutoClose();
    _autoCloseTimer = Timer(_autoCloseDelay, () {
      exit(0);
    });
  }

  void _cancelAutoClose() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;
  }

  Future<void> onAutoClose() async {
    _startAutoClose();
  }
}
