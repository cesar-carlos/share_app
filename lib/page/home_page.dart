import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import 'package:share_app/model/failures.dart';
import 'package:share_app/model/share_file.dart';
import 'package:share_app/service/args_decode.dart';
import 'package:share_app/service/share_file.service.dart';

const _backgroundColor = Color.fromARGB(200, 255, 255, 255);
const _autoCloseDelay = Duration(seconds: 30);
const _shareDelay = Duration(milliseconds: 300);

class HomePage extends StatefulWidget {
  final String arguments;

  const HomePage({super.key, required this.arguments});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Result<List<ShareFile>>? _decodeResult;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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
          onAutoClose();
        },
      );
    });
  }

  @override
  void dispose() {
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
          borderRadius: BorderRadius.circular(5),
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
        focusNode.requestFocus();
      },
      (error) {
        final failure = error as AppFailure;
        log('Share failure: ${failure.message}');
      },
    );
  }

  Future<void> onAutoClose() async {
    await Future.delayed(_autoCloseDelay);
    exit(0);
  }
}
