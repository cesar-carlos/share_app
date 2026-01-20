import 'dart:convert';

import 'package:result_dart/result_dart.dart';
import 'package:share_app/model/failures.dart';
import 'package:share_app/model/share_file.dart';

class ArgsDecode {
  static Result<List<ShareFile>> exec(String args) {
    if (args.isEmpty) {
      return Failure(DecodeFailure.invalidFormat());
    }

    try {
      final bytes = base64.decode(args);
      final decoded = utf8.decode(bytes);

      final Map<String, dynamic> jsonArgs = json.decode(decoded);
      final List<dynamic> list = jsonArgs['ShareFilePaths'];

      if (list.isEmpty) {
        return Failure(DecodeFailure.jsonParse());
      }

      final files = <ShareFile>[];

      for (final jsonItem in list) {
        if (jsonItem is! Map<String, dynamic>) {
          return Failure(
            JsonParseFailure.invalidType('ShareFilePaths item', 'Map'),
          );
        }

        final result = ShareFile.fromJson(jsonItem);

        final String? error = result.fold(
          (success) => null,
          (exception) => exception.toString(),
        );

        if (error != null) {
          return result.fold(
            (_) => Failure(JsonParseFailure.error('Unknown error')),
            (exception) => Failure(exception),
          );
        }

        result.fold(
          (file) => files.add(file),
          (_) {},
        );
      }

      return Success(files);
    } on FormatException {
      return Failure(DecodeFailure.base64Decode());
    } catch (e) {
      return Failure(DecodeFailure.error(e));
    }
  }
}
