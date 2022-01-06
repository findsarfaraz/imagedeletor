import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/notifiers/fold_trackback_notifier.dart';

final folderTrackBackProvider =
    ChangeNotifierProvider<FolderTrackBackNotifier>((ref) {
  return FolderTrackBackNotifier();
});
