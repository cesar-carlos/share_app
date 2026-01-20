import 'package:result_dart/result_dart.dart';
import 'package:share_plus/share_plus.dart';

import 'package:share_app/model/failures.dart';
import 'package:share_app/model/share_file.dart';

const _shareText = 'Share App';

class ShareFileService {
  static Future<Result<void>> shareFiles(List<ShareFile> shareFiles) async {
    if (shareFiles.isEmpty) {
      return Failure(ShareFailure('No files to share'));
    }

    try {
      final xFiles = shareFiles
          .map((file) => XFile(file.fullPath, name: file.fileName))
          .toList();

      await SharePlus.instance.share(
        ShareParams(
          files: xFiles,
          text: _shareText,
        ),
      );

      return const Success(unit);
    } catch (e) {
      return Failure(ShareFailure.error(e));
    }
  }
}
