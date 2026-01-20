import 'package:flutter/material.dart';

import 'package:share_app/model/failures.dart';

const _iconSize = 48.0;
const _dialogTitle = 'Erro';
const _closeButtonText = 'Fechar';

class ErrorModal extends StatelessWidget {
  final AppFailure failure;
  final VoidCallback? onClose;

  const ErrorModal({
    super.key,
    required this.failure,
    this.onClose,
  });

  static Future<void> show(
    BuildContext context,
    AppFailure failure, {
    VoidCallback? onClose,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorModal(
        failure: failure,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      icon: Icon(
        Icons.error_outline,
        color: colorScheme.error,
        size: _iconSize,
      ),
      title: const Text(_dialogTitle),
      content: Text(failure.message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onClose?.call();
          },
          child: const Text(_closeButtonText),
        ),
      ],
    );
  }
}
