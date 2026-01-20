import 'package:result_dart/result_dart.dart';
import 'package:share_app/model/failures.dart';

class ShareFile {
  final String id;
  final String name;
  final String path;

  const ShareFile({
    required this.id,
    required this.name,
    required this.path,
  });

  String get fileName => name;
  String get fullPath => '$path\\$id.$extension';
  String get extension {
    final parts = name.split('.');
    return parts.length > 1 ? parts.last : '';
  }

  static Result<ShareFile> fromJson(Map<String, dynamic> json) {
    try {
      final id = json['Id'];
      if (id == null || id is! String) {
        return Failure(JsonParseFailure.missingField('Id'));
      }

      final name = json['Name'];
      if (name == null || name is! String) {
        return Failure(JsonParseFailure.missingField('Name'));
      }

      final path = json['Path'];
      if (path == null || path is! String) {
        return Failure(JsonParseFailure.missingField('Path'));
      }

      return Success(ShareFile(
        id: id,
        name: name,
        path: path,
      ));
    } catch (e) {
      return Failure(JsonParseFailure.error(e));
    }
  }

  @override
  String toString() {
    return '''
      ShareFile(
        id: $id,
        name: $name,
        path: $path,
      )''';
  }
}
