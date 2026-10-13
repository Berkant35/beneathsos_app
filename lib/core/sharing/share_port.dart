/// A file handed to the system share sheet.
typedef SharedFile = ({String name, String mimeType, String text});

/// The system share sheet: the person chooses where files go; the app itself sends nothing (rule 4).
abstract interface class SharePort {
  /// Offers [files] to share; returns when the sheet closes.
  Future<void> share(List<SharedFile> files, {required String subject});
}
