import 'package:beneathsos_app/core/sharing/share_port.dart';

/// Records what was offered to the share sheet; [fail] makes the sheet fail.
final class FakeShare implements SharePort {
  final shared = <List<SharedFile>>[];
  bool fail = false;

  @override
  Future<void> share(List<SharedFile> files, {required String subject}) async {
    if (fail) throw StateError('share sheet unavailable');
    shared.add(files);
  }
}
