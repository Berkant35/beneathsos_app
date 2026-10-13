import 'dart:convert';

import 'package:beneathsos_app/core/sharing/share_port.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'share_service.g.dart';

/// The share sheet through `share_plus`. Implements [SharePort].
class ShareService implements SharePort {
  @override
  Future<bool> share(List<SharedFile> files, {required String subject}) async {
    final result = await SharePlus.instance.share(
      ShareParams(
        subject: subject,
        files: [
          for (final f in files)
            XFile.fromData(utf8.encode(f.text), mimeType: f.mimeType),
        ],
        fileNameOverrides: [for (final f in files) f.name],
      ),
    );
    return result.status != ShareResultStatus.dismissed;
  }
}

/// App-wide share sheet.
@Riverpod(keepAlive: true)
SharePort share(Ref ref) => ShareService();
